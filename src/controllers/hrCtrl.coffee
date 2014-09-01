P = require("q")
employeeDao = require('../dao/employeeDao')
accountDao = require('../dao/accountDao')

class HrCtrl
  getNextEmplid: (companyId)->
  	P.invoke(employeeDao,"getMaxEmplidOfCompany",companyId)
    .then (maxEmplid) ->
      return maxEmplid+1

  getCompanyRoles: (companyId)->
  	P.invoke(employeeDao,"getCompanyRoles",companyId)

  addNewEmployee: (companyId,emplObj)->
    P.invoke(accountDao,"getSigninIdCount",emplObj.signInId)
    .then (count) ->
      if count>0
        throw new Error('user.signin.not.available')
      else
        P.invoke(employeeDao,"getEmployeeByEmplid",companyId,emplObj.emplId)
        .then (currentEmplObj) ->
          if currentEmplObj? then throw new Error('employee.exist.with.emplid')
          if emplObj.supervisorId?
            P.invoke(employeeDao,"getEmployeeByEmplid",companyId,emplObj.supervisorId)
              .then (supervisorEmplObj) ->
                if !supervisorEmplObj then throw new Error('supervisor.emplid.invalid')
   			    newUserObj = {signInId:emplObj.signInId,email:emplObj.email,firstName:emplObj.firstName,middleName:emplObj?.middleName,lastName:emplObj.lastName,CompanyId:companyId}
   			    P.invoke(accountDao,"createNewAccount",newUserObj)
   			    .then (createdNewUserObj) ->
   			      P.invoke(accountDao,"createNewEmployee",{emplId:emplObj.emplId,companyId:companyId,userId:createdNewUserObj.uuid,supervisorId:emplObj.supervisorId})
                  .then(newEmplObj) ->
                    return newEmplObj


module.exports = new HrCtrl()