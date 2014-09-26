P = require("q")
_ = require("lodash")
employeeDao = require('../dao/employeeDao')
accountDao = require('../dao/accountDao')
mailUtils = require('../utils/mailUtils')
commonUtils = require('../utils/common')
cloudStore = require('../factory/cloudStore')

class HrCtrl
  getNextEmplid: (companyId)->
  	P.invoke(employeeDao,"getMaxEmplidOfCompany",companyId)
    .then (maxEmplid) ->
      return maxEmplid+1

  getEmployeeHeader: (companyId,emplid)->
    console.log 'companyId,emplid=',companyId,emplid
    P.invoke(employeeDao,"getEmployeeHeader",companyId,emplid)
    .fail (err) ->
      console.log 'catch block',err
      return null

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

  getEmpTimesheetDocs: (companyId,emplid,weekId) ->
    employeeDao.getEmployeeByEmplid(companyId,emplid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length > 0
          return savedTimesheetObjList[0].getTimesheetDocs()
        else 
          return []

  downloadEmpTimesheetDoc: (companyId,params) ->
    employeeDao.getTimeSheetDocById(params.id)
    .then (timesheetDoc) ->
      employeeDao.getTimesheetById(timesheetDoc.TimesheetId)
      .then (savedTimesheetObj) ->
        employeeDao.getEmployeeById(companyId,savedTimesheetObj.EmployeeId)
        .then (empObj) ->
          if empObj && empObj.id > 0
            cloudStore.downloadTimesheetFromStore(timesheetDoc.cloudName)
            .then (fileData) ->
              fileObj = {}
              fileObj.fileData = fileData
              fileObj.timeSheetDoc = timesheetDoc
              return fileObj
          else
            return null

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
              savedTimeSheet.tasks.push({name:taskObj.name,comments:taskObj.comments,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
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
              savedTimeSheet.tasks.push({name:taskObj.name,comments:taskObj.comments,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
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

  getDepartmentList: (companyId)->
    P.invoke(employeeDao,"getDepartmentList",companyId)

  getDeptDetails: (companyId,deptId)->
    P.invoke(employeeDao,"getDeptDetails",companyId,deptId)

  saveDeptDetails: (companyId,deptObj)->
    console.log 'deptObj.departmentHead=',deptObj.departmentHead
    if !deptObj.departmentHead || isNaN(deptObj.departmentHead)
      deptObj.departmentHead = 0

    if deptObj.id && deptObj.id > 0
      P.invoke(employeeDao,"getDeptDetails",companyId,deptObj.id)
      .then (dbDeptObj) ->
        dbDeptObj.departmentName = deptObj.departmentName
        dbDeptObj.departmentHead = deptObj.departmentHead
        dbDeptObj.save()
        return dbDeptObj
    else
      deptObj.CompanyId = companyId
      P.invoke(employeeDao,"createNewDept",deptObj)

  getTsTasksList: (companyId,deptId)->
    if deptId && !isNaN(deptId) && deptId > 0
      return []
    else  
      P.invoke(employeeDao,"getAllTsTasksList",companyId)

  getTsTaskDetails: (companyId,taskId)->
    P.invoke(employeeDao,"getTsTaskDetails",companyId,taskId)
    .then (tsTaskDetails) ->
      tsTaskDetails.getDepartments({attributes:['id','departmentName','departmentHead','isActive']})
      .then (deptList) ->
        tsTaskDetailsObj = {id:tsTaskDetails.id,name:tsTaskDetails.name,descr:tsTaskDetails.descr,isActive:tsTaskDetails.isActive}
        tsTaskDetailsObj.deptList = []
        tsTaskDetailsObj.deptList = deptList
        return tsTaskDetailsObj

  saveTsTaskDetails: (companyId,taskObj)->
    if taskObj?.id
      P.invoke(employeeDao,"getTsTaskDetails",companyId,taskObj.id)
      .then (tsTaskDetails) ->
        tsTaskDetails.name = taskObj.name
        tsTaskDetails.descr = taskObj.descr
        tsTaskDetails.save()
        P.invoke(employeeDao,"deleteTaskDepart",taskObj.id)
        .then () ->
          tsTaskDetails.setDepartments(taskObj.deptList)
          return taskObj
    else
                

module.exports = new HrCtrl() 