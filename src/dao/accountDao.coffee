models = require('../factory/db').models

class AccountDao
  getResetPasswordVerificationObj: (verificationId,signInId,companyId) ->
    models['Verification'].find({ where: {verificationId: verificationId,signInId:signInId,companyId:companyId}})    	

  updateUserPassword : (signInId,passwordHash) ->
    models['User'].find({ where: {signInId: signInId}})
    .success (userObj)->
      userObj.hashPassword = passwordHash
      userObj.save(['hashPassword'])

  updateUserPasswordByUid : (uuid,passwordHash) ->
    models['User'].find({ where: {uuid: uuid}})
    .success (userObj)->
      userObj.hashPassword = passwordHash
      userObj.save(['hashPassword'])

  getUserBySigninId: (signInId) ->
    models['User'].find({ where: {signInId: signInId},attributes:['uuid','displayName','signInId','companyId','email']})

  getAllUserAttributesBySigninId: (signInId) ->
    models['User'].find({ where: {signInId: signInId},attributes:['uuid','displayName','signInId','companyId','email','hashPassword']})

  getAllUserAttributesByUid: (uuid) ->
    models['User'].find({ where: {uuid: uuid},attributes:['uuid','displayName','signInId','companyId','email','hashPassword']})

  getUserBySigninIdAndCompanyId: (signInId,companyId) ->
    models['User'].find({ where: {signInId: signInId,companyId:companyId},attributes:['uuid','displayName','signInId','companyId','email']})

  getUserByEmailIdAndCompanyId: (emailAddress,companyId) ->
    models['User'].find({ where: {email: emailAddress,companyId:companyId},attributes:['uuid','email','signInId']})

  saveNewVerification: (verificationObj) ->
    models['Verification'].create(verificationObj) 

  getCompanyById: (companyId,isActive=true) ->
    models['Company'].find 
      where:
        companyId:companyId
        isActive:isActive
      attributes:['companyuid','companyId','companyName','companyImg']

  getCompanyByuid: (companyuid,isActive=true) ->
    models['Company'].find 
      where:
        companyuid:companyuid
        isActive:isActive
      attributes:['companyuid','companyId','companyName','companyImg']
module.exports = new AccountDao()