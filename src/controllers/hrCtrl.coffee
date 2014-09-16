P = require("q")
_ = require("lodash")
employeeDao = require('../dao/employeeDao')
accountDao = require('../dao/accountDao')
mailUtils = require('../utils/mailUtils')
commonUtils = require('../utils/common')

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

  getAllEmployeeList: (companyId)->
    return employeeDao.getAllEmployeeList(companyId)

  getAllActiveEmployeeList: (companyId)->
    return employeeDao.getAllActiveEmployeeList(companyId)

  updateEmpAccount: (companyId,emplObj)->
    if !emplObj?.roleIds || emplObj?.roleIds?.length<1
      emplObj.roleIds = [0]
    if emplObj.uuid
      P.invoke(accountDao,"getUserByUuid",emplObj.uuid,false)
      .then (userObj) ->
        if !userObj || userObj.CompanyId!=companyId
          throw new Error('employee.no.access.change')
         else
          P.invoke(employeeDao,"getEmployeeByEmplid",companyId,emplObj.emplId) 
          .then (currentEmplObj) ->
            if !currentEmplObj || currentEmplObj.UserId!=emplObj.uuid
              throw new Error('employee.no.access.change')
            else
              userObj.setRoles(null)
              .then (obj) ->
                P.invoke(employeeDao,'getCompanyRolesById',companyId,emplObj.roleIds)
                .then (roleList) ->
                  userObj.firstName = emplObj.firstName
                  userObj.middleName = emplObj.middleName
                  userObj.lastName = emplObj.lastName
                  userObj.email = emplObj.email
                  if emplObj.action == 'activate'
                    emplObj.isAccountActive = userObj.isAccountActive = true
                    mailUtils.sendAccountActivationEmail(userObj,currentEmplObj)
                  else if emplObj.action == 'deActivate'
                    emplObj.isAccountActive = userObj.isAccountActive = false
                  userObj.setRoles(roleList)
                  userObj.save()
                  currentEmplObj.supervisorId= emplObj.supervisorId
                  currentEmplObj.save()
                  return emplObj
    else  
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

  getEmpTimesheet: (companyId,emplid,weekId) ->
    employeeDao.getEmployeeByEmplid(companyId,emplid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length > 0
          dbTimeSheetObj = savedTimesheetObjList[0]
          dbTimeSheetObj.getTimesheetTasks()
          .then (taskList) ->
            savedTimeSheet = {}
            savedTimeSheet.id = dbTimeSheetObj.id
            savedTimeSheet.weekId = dbTimeSheetObj.weekId
            savedTimeSheet.status = dbTimeSheetObj.status
            savedTimeSheet.submittedOn = dbTimeSheetObj.submittedOn
            savedTimeSheet.approvedOn = dbTimeSheetObj.approvedOn
            savedTimeSheet.tasks = []
            for taskObj in taskList
              savedTimeSheet.tasks.push({name:taskObj.name,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
            if dbTimeSheetObj.approvedBy
              accountDao.getUserByUuid(dbTimeSheetObj.approvedBy)
              .then (userNameObj) ->
                savedTimeSheet.approvedBy = commonUtils.getFullName(userNameObj)
                return savedTimeSheet
            else    
              return savedTimeSheet
        else
          savedTimeSheet = {}
          savedTimeSheet.status = 'new'
          savedTimeSheet.weekId = weekId
          return savedTimeSheet

  approveTimeSheet: (companyId,approverId,emplid,weekId) ->
    employeeDao.getEmployeeByEmplid(companyId,emplid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length > 0
          dbTimeSheetObj = savedTimesheetObjList[0]
          dbTimeSheetObj.approvedOn = new Date()
          dbTimeSheetObj.approvedBy = approverId
          dbTimeSheetObj.status = 'approved'
          dbTimeSheetObj.save()
          dbTimeSheetObj.getTimesheetTasks()
          .then (taskList) ->
            savedTimeSheet = {}
            savedTimeSheet.id = dbTimeSheetObj.id
            savedTimeSheet.weekId = dbTimeSheetObj.weekId
            savedTimeSheet.status = dbTimeSheetObj.status
            savedTimeSheet.approvedOn = dbTimeSheetObj.approvedOn
            savedTimeSheet.submittedOn = dbTimeSheetObj.submittedOn
            savedTimeSheet.tasks = []
            for taskObj in taskList
              savedTimeSheet.tasks.push({name:taskObj.name,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
            if dbTimeSheetObj.approvedBy
              accountDao.getUserByUuid(dbTimeSheetObj.approvedBy)
              .then (userNameObj) ->
                savedTimeSheet.approvedBy = commonUtils.getFullName(userNameObj)
                return savedTimeSheet
            else    
              return savedTimeSheet
        else
          savedTimeSheet = {}
          savedTimeSheet.status = 'new'
          savedTimeSheet.weekId = weekId
          return savedTimeSheet

module.exports = new HrCtrl() 