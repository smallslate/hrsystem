P = require("q")
accountCtrl = require('../controllers/accountCtrl')
messages = require('../utils/messages').code

module.exports = (app)->
  server = app.server

  server.get "/c/:companyId/:signInId/:verificationId/:type/createPassword",(req,res)->
    P.invoke(accountCtrl, "verifyResetPasswordLink",req.params.verificationId,req.params.signInId,req.params.companyId)
    .then (verificationObj)->
      verificationObj.firstName = verificationObj.firstName.toUpperCase()
      if req.params.type == 'new'
        res.render("common/createPassword",{verificationObj:verificationObj})
      else
        res.render("common/createPassword",{verificationObj:verificationObj})    
    ,(err) ->
      if err.message =='password.link.invalid'
        res.render("common/signin",{message:messages['password.link.invalid']})
      else
        res.render("common/createPassword",{message:messages['server.error']})

  server.post "/c/:companyId/:signInId/:verificationId/setNewPassword",(req,res)->
    P.invoke(accountCtrl, "setNewPassword",req.params.verificationId,req.params.signInId,req.params.companyId,req.body.newPassword,req.body.reEnterNewPassword)
    .then (obj)->
      res.render("common/signin",{message:messages['password.success']}) 
    ,(err) ->
      if err.message =='password.link.invalid'
        res.render("common/signin",{message:messages['password.link.invalid']})
      else   
        res.render("common/createPassword",{message:messages['server.error']})   
    