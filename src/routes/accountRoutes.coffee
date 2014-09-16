P = require("q")
accountCtrl = require('../controllers/accountCtrl')
messages = require('../utils/messages').code
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

module.exports = (app)->
  server = app.server
  server.use(passport.initialize())
  server.use(passport.session())

  passport.serializeUser (user, done)->
    done(null, user.signInId)

  passport.deserializeUser (username, done)->
    P.invoke(accountCtrl,"getUserBySigninId",username)
    .then (userObj)->
      done(null, userObj)
    .catch (err) ->
      done(err,null)

  passport.use(new LocalStrategy((username, password, done)->
    P.invoke(accountCtrl,"authenticateUser",username,password)
    .then (userObj)->
      if !userObj
        return done(null, false)
      else
        return done(null, userObj)
    .catch (err) ->
      done(null, false)
  ))

  server.all '/c/:companyId/*',accountCtrl.updateCompanyInSession
  server.all '/c/:companyId/a/*',accountCtrl.authorizeAccountRequest
  
  server.all '/c/:companyId/hr/*',accountCtrl.authorizeHRRequest
  server.all '/c/:companyId/emplid/:emplid/hr/*',accountCtrl.authorizeHRRequest
  server.all '/rest/hr/*',accountCtrl.authorizeRestRequest

  server.all '/c/:companyId/emp/*',accountCtrl.authorizeEmpRequest
  server.all '/rest/emp/*',accountCtrl.authorizeRestRequest

  server.get "/c/:companyId/signin",(req,res)->
    if req.isAuthenticated()
      res.redirect("/c/#{req.session.company.companyId}/a/home")
    else  
      res.render("common/signin")

  server.get "/c/:companyId/a/signOut",(req,res)->
    req.session.destroy()
    req.logout()
    res.render("common/signin",message:messages['signout.success'])

  server.post "/rest/hr/checkSigninIdAvailability",(req,res)->
    P.invoke(accountCtrl, "checkSigninIdAvailability",req.body.signInId)
    .then (obj)->
      res.send(obj) 

  server.post "/c/:companyId/signin",(req, res,next)->
    authenticate = passport.authenticate 'local',(err, user, info)->
      if err then res.render("common/signin")
      if !user then return res.render("common/signin",message:messages['user.password.error'])

      if user.dataValues.companyId == req.session.company.companyuid
        req.logIn user,(err)->
          if err then  res.render("common/signin",message:messages['user.password.error'])
          pid = []
          for role in user.roles
            for pageAccess in role.pageAccesses
              pid.push pageAccess.pageId
          req.session.user = {}
          req.session.user.name = user.dataValues.lastName
          req.session.user.uuid = user.dataValues.uuid
          req.session.user.companyuid = user.dataValues.companyId
          req.session.user.pid = pid
          res.redirect("/c/#{req.session.company.companyId}/a/home")    
      else
        req.session.destroy()
        req.logout()
        return res.render("common/signin",message:messages['user.password.error'])     
    authenticate(req, res, next)


  server.get "/c/:companyId/a/home",(req,res)->
    res.render("employee/home")

  server.get "/c/:companyId/a/accountSetting",(req,res)->
    res.render("common/accountSetting")

  server.get "/c/:companyId/recovery",(req,res)->
    res.render("common/accountRecovery")

  server.get "/c/:companyId/a/changePassword",(req,res)->
    res.render("common/changePassword")

  server.post "/c/:companyId/a/changePassword",(req,res)->
    P.invoke(accountCtrl, "changePassword",req.session.user.uuid,req.body.currentPassword,req.body.newPassword,req.body.reEnterNewPassword)
    .then (obj)->
      res.render("common/accountSetting",{message:messages['password.success']})
    ,(err) ->
      req.session.destroy()
      req.logout()
      if err?.message?
        res.render("common/signin",{message:messages[err.message]})
      else   
        res.render("common/signin",{message:messages['server.error']})  

  server.get "/c/:companyId/:signInId/:verificationId/:type/createPassword",(req,res)->
    P.invoke(accountCtrl, "verifyResetPasswordLink",req.params.verificationId,req.params.signInId,req.params.companyId)
    .then (verificationObj)->
      verificationObj.lastName = verificationObj.lastName.toUpperCase()
      res.render("common/createPassword",{verificationObj:verificationObj})    
    ,(err) ->
      if err.message =='password.link.invalid'
        res.render("common/signin",{message:messages[err.message]})
      else
        res.render("common/createPassword",{message:messages['server.error']})


  server.post "/c/:companyId/:signInId/:verificationId/setNewPassword",(req,res)->
    P.invoke(accountCtrl, "setNewPassword",req.params.verificationId,req.params.signInId,req.params.companyId,req.body.newPassword,req.body.reEnterNewPassword)
    .then (obj)->
      res.render("common/signin",{message:messages['password.success']}) 
    ,(err) ->
      if err.message =='password.link.invalid'
        res.render("common/signin",{message:messages[err.message]})
      else   
        res.render("common/createPassword",{message:messages['server.error']}) 


  server.post "/c/:companyId/accountRecovery",(req,res)->
    P.invoke(accountCtrl, "accountRecovery",req.session.company.companyuid,req.body,req.session.company.companyName)
    .then (obj)->
      if req.body.recovery =='forgotPassword'
        res.render("common/signin",{message:messages['password.recovery.email.sent']})
      else
        res.render("common/signin",{message:messages['user.recovery.email.sent']})   
    ,(err) ->
      if err.message in ['password.recovery.signInId.notvalid','password.recovery.useremail.notvalid','password.recovery.option.notvalid']
        res.render("common/accountRecovery",{message:messages[err.message]})
      else  
        res.render("common/accountRecovery",{message:messages['server.error']})        
    