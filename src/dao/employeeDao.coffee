models = require('../factory/db').models

class EmployeeDao
  getMaxEmplidOfCompany: (companyId) ->
    models['Employee'].max('emplId',{ where: {companyId: companyId}}) 

  getCompanyRoles: (companyid) ->
    models['Role'].findAll({where: {companyid:companyid},attributes:['roleId','roleName','roleDescr']})


module.exports = new EmployeeDao()    
