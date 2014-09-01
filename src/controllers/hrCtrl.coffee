P = require("q")
employeeDao = require('../dao/employeeDao')

class HrCtrl
  getNextEmplid: (companyId)->
  	P.invoke(employeeDao,"getMaxEmplidOfCompany",companyId)
    .then (maxEmplid) ->
      return maxEmplid+1

  getCompanyRoles: (companyId)->
  	P.invoke(employeeDao,"getCompanyRoles",companyId)

module.exports = new HrCtrl()