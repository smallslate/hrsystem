P = require("q")
accountDao = require('../dao/accountDao')
bcrypt = require("bcrypt-nodejs")
mail = require('../factory/mail')
uuid = require("node-uuid")
moment = require("moment")
messages = require('../utils/messages').code
authorizedUrl = require('../factory/pages').authorizedUrl
pages =  require('../factory/pages').pages

class AccountCtrl
  getUserBySigninId: (signInId)->
    accountDao.getUserBySigninId(signInId)

  checkSigninIdAvailability: (signInId)->
    P.invoke(accountDao,"getSigninIdCount",signInId)
    .then (count) ->
      if count > 0
        return messages['user.signin.not.available']
      else 
        return messages['user.signin.available']

  authenticateUser: (signInId,password)->
    comparePassword = (userObjList)->
      userObj = userObjList[0]
      if !userObj || !userObj.hashPassword || userObj.hashPassword.length<8
        return null
      else   
        P.nfcall(bcrypt.compare,password,userObj.hashPassword)
        .then (res)->
          return if res then userObj else null
    P.invoke(accountDao,"getAllUserAttributesBySigninId",signInId)
    .then(comparePassword)
    .catch (err) ->
      console.log err



  verifyResetPasswordLink: (verificationId,signInId,companyId)->
    P.invoke(accountDao,"getResetPasswordVerificationObj",verificationId,signInId,companyId)
    .then (verificationObj) ->
      if verificationObj?.dataValues
        expireDate = moment(verificationObj.dataValues.createdAt).add('days', 7)
        if expireDate.isAfter(moment())
          return verificationObj.dataValues
        else  
          verificationObj.destroy() 
          throw new Error('password.link.invalid')
      else
        throw new Error('password.link.invalid')


  setNewPassword: (verificationId,signInId,companyId,newPassword,reenteredPassword)->
    savePasswordHash = (hash)->
      P.invoke(accountDao,"updateUserPassword",signInId,hash,companyId)
    generateHash = (verificationObj)->
      P.nfcall(bcrypt.hash,newPassword,null,null)
    validateVerificationObj = (verificationObj)->
      throw new Error('password.link.invalid') unless verificationObj
      return verificationObj.destroy() 
    if newPassword == reenteredPassword	
      P.invoke(accountDao,"getResetPasswordVerificationObj",verificationId,signInId,companyId)
      .then(validateVerificationObj)
      .then(generateHash)
      .then(savePasswordHash)
      .catch (err) ->
        throw new Error('server.error')
    else
      throw new Error('password.not.match') 

  changePassword: (uuid,companyId,oldPassword,newPassword,reenteredPassword)->
    savePasswordHash = (hash)->
      P.invoke(accountDao,"updateUserPasswordByUid",uuid,hash,companyId)
    generateHash = (userObj)->
      P.nfcall(bcrypt.hash,newPassword,null,null)
    comparePassword = (userObj)->
      if !userObj 
        throw new Error('server.error')
      else   
        P.nfcall(bcrypt.compare,oldPassword,userObj.hashPassword)
        .then (res)->
          return if res then userObj else throw new Error('user.old.password.incorrect')

    if newPassword == reenteredPassword 
      P.invoke(accountDao,"getAllUserAttributesByUid",uuid,companyId)
      .then(comparePassword)
      .then(generateHash)
      .then(savePasswordHash)
    else
      throw new Error('password.not.match')

  accountRecovery: (companyuid,body,companyName)->
    if body.recovery =='forgotPassword'
      P.invoke(accountDao,"getUserBySigninIdAndCompanyId",body.signInId,companyuid)
      .then (userObj)->
        if userObj
          accountDao.getCompanyByuid(userObj.dataValues.companyId,true)
          .then (company)->
            verificationId = uuid.v4()
            P.invoke(accountDao,"saveNewVerification",{'lastName':userObj.lastName,'verificationId':verificationId,'signInId':userObj.signInId,'companyId':company.companyId})
            .then (verificationObj)->
              valuesObj = 
                'to':userObj.email
                'companyId':company.companyId
                'companyName': companyName
                'signInId': userObj.signInId
                'verificationId':verificationId
              mailOptions = mail.getForgotPasswordObj(valuesObj)
              mail.transporter.sendMail mailOptions
              return true
        else  
          throw new Error('password.recovery.signInId.notvalid')    
    else if body.recovery =='forgotSignInId'
      P.invoke(accountDao,"getUserByEmailIdAndCompanyId",body.emailAddress,companyuid)
      .then (userObj)->
        if userObj
          valuesObj = 
              'to':userObj.email
              'signInId': userObj.signInId
              'companyName': companyName
          mailOptions = mail.getForgotSignInIdObj(valuesObj)
          mail.transporter.sendMail mailOptions 
          return true
        else  
          throw new Error('password.recovery.useremail.notvalid')
    else
     throw new Error('password.recovery.option.notvalid')

  authorizeAccountRequest:(req,res,next)=>
    @authorizeRequest(req,res,'/a/',next)

  authorizeHRRequest:(req,res,next)=>
    @authorizeRequest(req,res,'/hr/',next)

  authorizeEmpRequest:(req,res,next)=>
    @authorizeRequest(req,res,'/emp/',next)

  authorizeRestRequest:(req,res,next)=>
    @authorizeRequest(req,res,'/rest/',next)

  authorizeRequest:(req,res,type,next)->
    if req.isAuthenticated()
      if req.session.company.companyuid == req.session.user.companyuid
        isAuthorized = false
        accessUrl = req.url
        if accessUrl.indexOf('?id=') > -1
          accessUrl = accessUrl.substring(0,accessUrl.indexOf('?id='))
        reqUrl = accessUrl.substring(accessUrl.indexOf(type),accessUrl.length)
        if reqUrl in authorizedUrl 
          isAuthorized = true
        else
          userPageAccessIds = req.session.user?.pid
          for userPageId in userPageAccessIds
            if pages[userPageId] && reqUrl in pages[userPageId]?.url
              isAuthorized = true
              break;
        if !isAuthorized
          req.session.destroy()
          req.logout()
          res.render("common/signin",message:messages['url.not.authorize'])
        else
          res.locals.user = req.session.user
          res.locals.user.pid = req.session.user?.pid
          previousUrl = req.session.previousUrl 
          if previousUrl?
            req.session.previousUrl = null
            res.redirect(previousUrl)
          else
            next()
      else
        res.locals= null
        req.session.destroy()
        req.logout()
        res.render("common/signin",message:messages['user.signin.required'])  
    else
      req.session.previousUrl = req.url
      res.render("common/signin",message:messages['user.signin.required'])    


  updateCompanyInSession:(req,res,next)->
    if req.session?.company
      if req.session.company.companyId == req.params.companyId
        res.locals.company = req.session.company
        next()
      else
        res.locals= null
        req.session.destroy()
        req.logout()
        #replace with common login
        res.render("common/signin",message:messages['user.login.error'])
    else
      res.locals= {}
      req.session.user = null
      req.logout()
      accountDao.getCompanyById(req.params.companyId,true)
      .then (company)->
        if company 
          req.session.company = res.locals.company = company
          next()
        else
          #replace with common login
          res.render("common/signin",message:messages['user.login.error'])
      ,(error)->
        #replace with common login
        res.render("common/signin",message:messages['user.login.error'])
module.exports = new AccountCtrl()

    
  