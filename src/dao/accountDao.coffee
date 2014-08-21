models = require('../factory/db').models

class AccountDao
  getResetPasswordVerificationObj: (verificationId,signInId,companyId) ->
    models['Verification'].find({ where: {verificationId: verificationId,signInId:signInId,companyId:companyId}})    	


  updateUserPassword : (signInId,passwordHash) ->
    models['Employees'].find({ where: {signInId: signInId}})
    .success (empObj)->
      empObj.hashPassword = passwordHash
      empObj.save(['hashPassword'])


  getUserBySigninIdAndCompanyId: (signInId,companyId) ->
    models['Employees'].find({ where: {signInId: signInId,companyId:companyId}})

  getUserByEmailIdAndCompanyId: (emailAddress,companyId) ->
    models['Employees'].find({ where: {email: emailAddress,companyId:companyId}})

  saveNewVerification: (verificationObj) ->
    models['Verification'].create(verificationObj) 

module.exports = new AccountDao()