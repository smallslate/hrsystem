db = require('../factory/db')
sequelize = db.sequelize
models = db.models

class AccountDao
  getResetPasswordVerificationObj: (verificationId,signInId,companyId) ->
    models['Verification'].find({ where: {verificationId: verificationId,signInId:signInId,companyId:companyId}})    	

  updateUserPassword : (signInId,passwordHash) ->
    models['User'].find({ where: {signInId: signInId,isAccountActive:true}})
    .success (userObj)->
      userObj.hashPassword = passwordHash
      userObj.save(['hashPassword'])

  updateUserPasswordByUid : (uuid,passwordHash,companyId) ->
    models['User'].find({ where: {uuid: uuid,isAccountActive:true,CompanyId:companyId}})
    .success (userObj)->
      userObj.hashPassword = passwordHash
      userObj.save(['hashPassword'])

  getSigninIdCount: (signInId) ->
    models['User'].count({where: {signInId: signInId}})

  getUserBySigninId: (signInId) ->
    models['User'].find({ where: {signInId: signInId,isAccountActive:true},attributes:['uuid','lastName','signInId','companyId','email']})

  getUserByUuid: (uuid,isAccountActive=true,companyId) ->
    if isAccountActive
      models['User'].find({ where: {uuid: uuid,isAccountActive:true,CompanyId:companyId},attributes:['uuid','signInId','email','firstName','middleName','lastName','isAccountActive','CompanyId']})
    else
      models['User'].find({ where: {uuid: uuid,CompanyId:companyId},attributes:['uuid','signInId','email','firstName','middleName','lastName','isAccountActive','CompanyId']})

  getAllUserAttributesBySigninId: (signInId) ->
    models['User'].findAll({ where: {signInId: signInId,isAccountActive:true},include: [{model: models['Role'], include: [models['PageAccess']]}],attributes:['uuid','lastName','signInId','companyId','email','hashPassword']})

  getAllUserAttributesByUid: (uuid,companyId) ->
    models['User'].find({ where: {uuid: uuid,isAccountActive:true,CompanyId:companyId},attributes:['uuid','lastName','signInId','companyId','email','hashPassword']})

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

  getRoleList: (companyid) ->
    models['Role'].findAll({where: {CompanyId:companyid},attributes:['roleId','roleName','roleDescr']})

  getRoleDetails: (companyid,roleId) ->
    models['Role'].find({where: {roleId:roleId,CompanyId:companyid},attributes:['roleId','roleName','roleDescr']})

  createRole: (companyid,roleObj) ->
    models['Role'].create({roleName:roleObj.roleName,roleDescr:roleObj.roleDescr,CompanyId:companyid}) 

  getCompanyAccessPageIds: (companyid) ->
    models['PageAccess'].findAll({where: {CompanyId:companyid},attributes:['pageId']})

  deletePageAccessRoles: (roleId) ->
    sequelize.query("DELETE FROM PageAccessesRoles WHERE RoleId ="+roleId)

module.exports = new AccountDao()