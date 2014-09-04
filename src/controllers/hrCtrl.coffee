P = require("q")
_ = require("lodash")
employeeDao = require('../dao/employeeDao')
accountDao = require('../dao/accountDao')

class HrCtrl
  getNextEmplid: (companyId)->
  	P.invoke(employeeDao,"getMaxEmplidOfCompany",companyId)
    .then (maxEmplid) ->
      return maxEmplid+1

  getCompanyRoles: (companyId)->
  	P.invoke(employeeDao,"getCompanyRoles",companyId)

  getEmpAccountDetails: (companyId,emplid)->
    P.invoke(employeeDao,"getEmployeeByEmplid",companyId,emplid)
    .then (emplObj) ->
      P.invoke(accountDao,"getUserByUuid",emplObj.UserId,false)
      .then (userObj) ->
        userObj.getRoles()
        .then (rolesObj)->
          newEmpObj = {firstName:userObj.firstName,middleName:userObj.middleName,lastName:userObj.lastName,signInId:userObj.signInId,email:userObj.email,emplId:emplObj.emplId,supervisorId:emplObj.supervisorId,isAccountActive:userObj.isAccountActive,uuid:userObj.uuid,roleIds:_.pluck(rolesObj,'roleId')}
          return newEmpObj

  addNewEmployee: (companyId,emplObj)->
    P.invoke(accountDao,"getSigninIdCount",emplObj.signInId)
    .then (count) ->
      if count>0
        throw new Error('user.signin.not.available')
      else
        P.invoke(employeeDao,"getEmployeeByEmplid",companyId,emplObj.emplId)
        .then (currentEmplObj) ->
          if currentEmplObj? then throw new Error('employee.exist.with.emplid')
          reqNewUserObj = {signInId:emplObj.signInId,email:emplObj.email,firstName:emplObj.firstName,middleName:emplObj?.middleName,lastName:emplObj.lastName,CompanyId:companyId}
          P.invoke(accountDao,"createNewAccount",reqNewUserObj)
            .then (newUser) ->
              P.invoke(employeeDao,"saveNewEmployee",{emplId:emplObj.emplId,CompanyId:companyId,UserId:newUser.uuid,supervisorId:emplObj.supervisorId})
              .then (newEmplObj) ->
                P.invoke(employeeDao,'getCompanyRolesById',companyId,emplObj.roleIds)
                .then (roleList) ->
                  newUser.setRoles(roleList)
                  .then (addedRoleList) ->
                    newEmpObj = {firstName:newUser.firstName,middleName:newUser.middleName,lastName:newUser.lastName,signInId:newUser.signInId,email:newUser.email,emplId:newEmplObj.emplId,supervisorId:newEmplObj.supervisorId,isAccountActive:newUser.isAccountActive,uuid:newUser.uuid,roleIds:_.pluck(addedRoleList,'roleId')}
                    return newEmpObj

module.exports = new HrCtrl() 