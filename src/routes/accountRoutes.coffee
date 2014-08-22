P = require("q")
accountCtrl = require('../controllers/accountCtrl')
messages = require('../utils/messages').code

module.exports = (app)->
  server = app.server


  server.get "/c/:companyId/signin",(req,res)->
    res.render("common/signin")


  server.get "/c/:companyId/recovery",(req,res)->
    res.render("common/accountRecovery")


  server.get "/c/:companyId/:signInId/:verificationId/:type/createPassword",(req,res)->
    P.invoke(accountCtrl, "verifyResetPasswordLink",req.params.verificationId,req.params.signInId,req.params.companyId)
    .then (verificationObj)->
      verificationObj.firstName = verificationObj.firstName.toUpperCase()
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
    P.invoke(accountCtrl, "accountRecovery",req.params,req.body,req.session.company.companyName)
    .then (obj)->
      if req.body.recovery =='forgotPassword'
        res.render("common/signin",{message:messages['password.recovery.email.sent']})
      else
        res.render("common/signin",{message:messages['user.recovery.email.sent']})   
    ,(err) ->
      if err.message in ['password.recovery.userid.notvalid','password.recovery.useremail.notvalid','password.recovery.option.notvalid']
        res.render("common/accountRecovery",{message:messages[err.message]})
      else 
        console.log err  
        res.render("common/accountRecovery",{message:messages['server.error']})        
    