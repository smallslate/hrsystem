models = require('../factory/db').models

class EmployeeDao
  getMaxEmplidOfCompany: (companyId) ->
    models['Employee'].max('emplId',{ where: {companyId: companyId}}) 

  getCompanyRoles: (companyid) ->
    models['Role'].findAll({where: {companyid:companyid},attributes:['roleId','roleName','roleDescr']})

  getEmployeeByEmplid: (companyId,emplid) ->
    models['Employee'].find({ where: {companyId: companyId,emplId:emplid}})   

  saveNewEmployee: (emplObj) ->
    models['Employee'].create(emplObj)  

module.exports = new EmployeeDao()    
