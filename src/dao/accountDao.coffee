models = require('../factory/db').models

class AccountDao
  getResetPasswordVerificationObj: (verificationId,signInId,companyId) ->
    models['Verification'].find({ where: {verificationId: verificationId,signInId:signInId,companyId:companyId}})    	

  updateUserPassword : (signInId,passwordHash) ->
    models['Employees'].find({ where: {signInId: signInId}})
    .success (empObj)->
      empObj.hashPassword = passwordHash
      empObj.save(['hashPassword'])

  updateUserPasswordByUid : (employeeuid,passwordHash) ->
    models['Employees'].find({ where: {employeeuid: employeeuid}})
    .success (empObj)->
      empObj.hashPassword = passwordHash
      empObj.save(['hashPassword'])

  getUserBySigninId: (signInId) ->
    models['Employees'].find({ where: {signInId: signInId},attributes:['employeeuid','firstName','signInId','companyId','email']})

  getAllUserAttributesBySigninId: (signInId) ->
    models['Employees'].find({ where: {signInId: signInId},attributes:['employeeuid','firstName','signInId','companyId','email','hashPassword']})

  getAllUserAttributesByUid: (employeeuid) ->
    models['Employees'].find({ where: {employeeuid: employeeuid},attributes:['employeeuid','firstName','signInId','companyId','email','hashPassword']})

  getUserBySigninIdAndCompanyId: (signInId,companyId) ->
    models['Employees'].find({ where: {signInId: signInId,companyId:companyId},attributes:['employeeuid','firstName','signInId','companyId','email']})

  getUserByEmailIdAndCompanyId: (emailAddress,companyId) ->
    models['Employees'].find({ where: {email: emailAddress,companyId:companyId},attributes:['employeeuid','email','signInId']})

  saveNewVerification: (verificationObj) ->
    models['Verification'].create(verificationObj) 

  getCompanyById: (companyId,isActive=true) ->
    models['Companies'].find 
      where:
        companyId:companyId
        isActive:isActive
      attributes:['companyId','companyName','companyImg']

module.exports = new AccountDao()