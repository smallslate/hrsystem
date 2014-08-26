P = require("q")
accountDao = require('../dao/accountDao')
bcrypt = require("bcrypt-nodejs")
mail = require('../factory/mail')
uuid = require("node-uuid")
moment = require("moment")
messages = require('../utils/messages').code
authorizedUrl = ['/a/home','/a/signOut','/a/accountSetting','/a/changePassword']

class AccountCtrl
  getUserBySigninId: (signInId)->
    accountDao.getUserBySigninId(signInId)


  authenticateUser: (signInId,password)->
    comparePassword = (userObj)->
      if !userObj 
        return null
      else   
        P.nfcall(bcrypt.compare,password,userObj.hashPassword)
        .then (res)->
          return if res then userObj else null
    P.invoke(accountDao,"getAllUserAttributesBySigninId",signInId)
    .then(comparePassword)



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
      P.invoke(accountDao,"updateUserPassword",signInId,hash)
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

  changePassword: (employeeuid,oldPassword,newPassword,reenteredPassword)->
    console.log 'employeeuid=',employeeuid
    savePasswordHash = (hash)->
      P.invoke(accountDao,"updateUserPasswordByUid",employeeuid,hash)
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
      P.invoke(accountDao,"getAllUserAttributesByUid",employeeuid)
      .then(comparePassword)
      .then(generateHash)
      .then(savePasswordHash)
    else
      throw new Error('password.not.match')

  accountRecovery: (params,body,companyName)->
    if body.recovery =='forgotPassword'
      P.invoke(accountDao,"getUserBySigninIdAndCompanyId",body.signInId,params.companyId)
      .then (empObj)->
        if empObj
          verificationId = uuid.v4()
          P.invoke(accountDao,"saveNewVerification",{'firstName':empObj.firstName,'verificationId':verificationId,'signInId':empObj.signInId,'companyId':empObj.companyId})
          .then (verificationObj)->
            valuesObj = 
              'to':empObj.email
              'companyId':empObj.companyId
              'companyName': companyName
              'signInId': empObj.signInId
              'verificationId':verificationId
            mailOptions = mail.getForgotPasswordObj(valuesObj)
            mail.transporter.sendMail mailOptions
            return true
        else  
          throw new Error('password.recovery.signInId.notvalid')    
    else if body.recovery =='forgotSignInId'
      P.invoke(accountDao,"getUserByEmailIdAndCompanyId",body.emailAddress,params.companyId)
      .then (empObj)->
        if empObj
          valuesObj = 
              'to':empObj.email
              'signInId': empObj.signInId
              'companyName': companyName
          mailOptions = mail.getForgotSignInIdObj(valuesObj)
          mail.transporter.sendMail mailOptions 
          return true
        else  
          throw new Error('password.recovery.useremail.notvalid')
    else
     throw new Error('password.recovery.option.notvalid')


  authorizeRequest:(req,res,next)->
    if req.isAuthenticated()
      isAuthorized = false
      accessUrl = req.url
      previousUrl = req.session.previousUrl 
      reqUrl = accessUrl.substring(accessUrl.indexOf('/a/'),accessUrl.length)
      if previousUrl? 
        req.session.previousUrl = null
        reqUrl = previousUrl.substring(previousUrl.indexOf('/a/'),previousUrl.length)
      if reqUrl in authorizedUrl 
        isAuthorized = true
      else
        req.session.destroy()
        req.logout()
        res.render("common/signin",message:messages['url.not.authorize'])

      res.locals.emp = req.session.emp
      if previousUrl?
        res.redirect(previousUrl)
      else
        next()
    else
      req.session.previousUrl = req.url
      res.render("common/signin",message:messages['user.signin.required'])    


  updateCompanyInSession:(req,res,next)->
    if req.session?.company?.companyId
      if req.params.companyId == req.session.company.companyId
        res.locals.company = req.session.company
        next()
      else
        res.locals= null
        req.session.destroy()
        req.logout()
        #replace with common login
        res.render("common/signin",message:messages['user.login.error'])
    else
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

    
  