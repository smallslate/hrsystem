models = require('../factory/db').models

class AccountDao
  getResetPasswordVerificationObj: (verificationId,signInId,companyId) ->
    models['Verification'].find({ where: {verificationId: verificationId,signInId:signInId,companyId:companyId}})    	

  updateUserPassword : (signInId,passwordHash) ->
    models['Employees'].find({ where: {signInId: signInId}})
    .success (empObj)->
      empObj.hashPassword = passwordHash
      empObj.save(['hashPassword'])

module.exports = new AccountDao()