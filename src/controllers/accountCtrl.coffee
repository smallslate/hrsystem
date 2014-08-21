P = require("q")
accountDao = require('../dao/accountDao')
bcrypt = require("bcrypt-nodejs")
mail = require('../factory/mail')
uuid = require("node-uuid")

class AccountCtrl

  verifyResetPasswordLink: (verificationId,signInId,companyId)->
    P.invoke(accountDao,"getResetPasswordVerificationObj",verificationId,signInId,companyId)
    .then (verificationObj) ->
      if verificationObj?.dataValues
        return verificationObj.dataValues
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
      .done()
    else
      throw new Error('password.not.match') 


  accountRecovery: (params,body)->
    if body.recovery =='forgotPassword'
      P.invoke(accountDao,"getUserBySigninIdAndCompanyId",body.userId,params.companyId)
      .then (empObj)->
        if empObj
          verificationId = uuid.v4()
          P.invoke(accountDao,"saveNewVerification",{'firstName':empObj.firstName,'verificationId':verificationId,'signInId':empObj.signInId,'companyId':empObj.companyId})
          .then (verificationObj)->
            valuesObj = 
              'to':empObj.email
              'companyId':empObj.companyId
              'signInId': empObj.signInId
              'verificationId':verificationId
            mailOptions = mail.getForgotPasswordObj(valuesObj)
            mail.transporter.sendMail mailOptions
            return true
        else  
          throw new Error('password.recovery.userid.notvalid')    
    else if body.recovery =='forgotUserId'
      P.invoke(accountDao,"getUserByEmailIdAndCompanyId",body.emailAddress,params.companyId)
      .then (empObj)->
        if empObj
          valuesObj = 
              'to':empObj.email
              'signInId': empObj.signInId
          mailOptions = mail.getForgotUserIdObj(valuesObj)
          mail.transporter.sendMail mailOptions 
          return true
        else  
          throw new Error('password.recovery.useremail.notvalid')
    else
     throw new Error('password.recovery.option.notvalid')

module.exports = new AccountCtrl()

    
  