models = require('../factory/db').models

class AccountDao
  getResetPasswordVerificationObj: (verificationId,signInId,companyId) ->
    models['Verification'].find({ where: {verificationId: verificationId,signInId:signInId,companyId:companyId}})    	

  updateUserPassword : (signInId,passwordHash) ->
    models['User'].find({ where: {signInId: signInId,isAccountActive:true}})
    .success (userObj)->
      userObj.hashPassword = passwordHash
      userObj.save(['hashPassword'])

  updateUserPasswordByUid : (uuid,passwordHash) ->
    models['User'].find({ where: {uuid: uuid,isAccountActive:true}})
    .success (userObj)->
      userObj.hashPassword = passwordHash
      userObj.save(['hashPassword'])

  getSigninIdCount: (signInId) ->
    models['User'].count({where: {signInId: signInId}})

  getUserBySigninId: (signInId) ->
    models['User'].find({ where: {signInId: signInId,isAccountActive:true},attributes:['uuid','lastName','signInId','companyId','email']})

  getUserByUuid: (uuid,isAccountActive=true) ->
    if isAccountActive
      models['User'].find({ where: {uuid: uuid,isAccountActive:true},attributes:['uuid','signInId','email','firstName','middleName','lastName','isAccountActive','CompanyId']})
    else
      models['User'].find({ where: {uuid: uuid},attributes:['uuid','signInId','email','firstName','middleName','lastName','isAccountActive','CompanyId']})

  getAllUserAttributesBySigninId: (signInId) ->
    models['User'].findAll({ where: {signInId: signInId,isAccountActive:true},include: [{model: models['Role'], include: [models['PageAccess']]}],attributes:['uuid','lastName','signInId','companyId','email','hashPassword']})

  getAllUserAttributesByUid: (uuid) ->
    models['User'].find({ where: {uuid: uuid,isAccountActive:true},attributes:['uuid','lastName','signInId','companyId','email','hashPassword']})

  getUserBySigninIdAndCompanyId: (signInId,companyId) ->
    models['User'].find({ where: {signInId: signInId,companyId:companyId,isAccountActive:true},attributes:['uuid','lastName','signInId','companyId','email']})

  getUserByEmailIdAndCompanyId: (emailAddress,companyId) ->
    models['User'].find({ where: {email: emailAddress,companyId:companyId,isAccountActive:true},attributes:['uuid','email','signInId']})

  saveNewVerification: (verificationObj) ->
    models['Verification'].create(verificationObj) 

  createNewAccount: (newUserObj) ->
    models['User'].create(newUserObj)   

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