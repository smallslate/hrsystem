P = require("q")
accountDao = require('../dao/accountDao')
bcrypt = require("bcrypt-nodejs")


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

module.exports = new AccountCtrl()

    
  