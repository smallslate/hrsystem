db = require('../factory/db')
sequelize = db.sequelize
models = db.models

class EmployeeDao
  getMaxEmplidOfCompany: (companyId) ->
    models['Employee'].max('emplId',{ where: {CompanyId: companyId}}) 

  getCompanyRoles: (companyid) ->
    models['Role'].findAll({where: {CompanyId:companyid},attributes:['roleId','roleName','roleDescr']})

  getCompanyRolesById: (companyid,roleIdList) ->
    models['Role'].findAll({where: {CompanyId:companyid,roleId:[roleIdList]},attributes:['roleId','roleName','roleDescr']})

  getEmployeeByEmplid: (companyId,emplid) ->
    models['Employee'].find({ where: {CompanyId: companyId,emplId:emplid}})

  getEmployeeById: (companyId,emplid) ->
    models['Employee'].find({ where: {CompanyId: companyId,id:emplid}})

  getDepartmentList: (companyid) ->
    models['Department'].findAll({where: {CompanyId:companyid},attributes:['id','departmentName','departmentHead','isActive']})

  getAllTsTasksList: (companyid) ->
    models['CompanyTask'].findAll({where: {CompanyId:companyid},attributes:['id','name','descr','isActive']})

  getTsTaskDetails: (companyid,taskId) ->
    models['CompanyTask'].find({where: {id:taskId,CompanyId:companyid},attributes:['id','name','descr','isActive']})

  getCompanyTasks: (companyId) ->
    models['CompanyTask'].findAll({where: {CompanyId:companyId,isActive:true},attributes:['id','name']})

  createCompanyTask: (companyId,taskObj) ->
    models['CompanyTask'].create({name:taskObj.name,descr:taskObj.descr,CompanyId:companyId})
    
  getCompanyTasksByDept: (companyId,deptId) ->
    models['Department'].find({where: {CompanyId:companyId,id:deptId}})
    .then (deptObj) ->
      deptObj.getCompanyTasks()

  getDeptDetails: (companyId,deptId) ->
    models['Department'].find({where: {CompanyId:companyId,id:deptId},attributes:['id','departmentName','departmentHead','isActive']})

  createNewDept: (deptObj) ->
    models['Department'].create({departmentName:deptObj.departmentName,departmentHead:deptObj.departmentHead,CompanyId:deptObj.CompanyId})
    
  getEmployeeByUUid: (companyId,uuid) ->
    models['Employee'].find({where: {CompanyId: companyId,UserId:uuid}})  
   
  saveNewEmployee: (emplObj) ->
    models['Employee'].create(emplObj)  

  createTimeSheetDoc: (timesheetDocObj) ->
    models['TimesheetDoc'].create(timesheetDocObj) 

  getTimeSheetDoc: (timesheetId,timesheetDocId) ->
    models['TimesheetDoc'].find({where:{TimesheetId:timesheetId,id:timesheetDocId}}) 

  getTimeSheetDocById: (timesheetDocId) ->
    models['TimesheetDoc'].find({where:{id:timesheetDocId}}) 

  deleteTimeSheetDoc: (timesheetId,timesheetDocId) ->
    models['TimesheetDoc'].destroy({TimesheetId:timesheetId,id:timesheetDocId})   

  createTimeSheet: (timesheetObj) ->
    models['Timesheet'].create({status:timesheetObj.status,weekId:timesheetObj.weekId,EmployeeId:timesheetObj.EmployeeId,submittedOn:new Date()})
    .then (dbTimeSheetObj) ->
      if timesheetObj.tasks && timesheetObj.tasks.length > 0
        for task in timesheetObj.tasks
          task.TimesheetId = dbTimeSheetObj.id
          if !(task.name) || isNaN(task.name) || task.name <1
            task.name = 0
        models['TimesheetTask'].bulkCreate(timesheetObj.tasks)
        .then ()->
          dbTimeSheetObj.getTimesheetTasks()
          .then (timesheetTasks) ->
            dbTimeSheetObj.tasks = timesheetTasks
            return dbTimeSheetObj
      else  
        dbTimeSheetObj.tasks = []    
        return dbTimeSheetObj
  getTimesheetByEmplidAndWeekId: (emplId,weekId) ->
    models['Timesheet'].find({where: {EmployeeId: emplId,weekId:weekId}})

  getTimesheetById: (timesheetId) ->
    models['Timesheet'].find({where: {id: timesheetId}})  

  deleteTimeSheetTasks: (timeSheetId) ->
    models['TimesheetTask'].destroy({TimesheetId:timeSheetId})

  createTimeSheetTasks: (taskList,timesheetId) ->
    for task in taskList
      if Number.isNaN(task.name) || task.name ==' '|| task.name ==''
        task.name =0
      task.TimesheetId = timesheetId
      console.log(task.name)
    models['TimesheetTask'].bulkCreate(taskList) 

  getFileRoomsByCompanyId: (companyId) ->
    models['FileRoom'].findAll({where: {CompanyId:companyId},attributes:['id','roomName','accessToEmployee','accessToSupervisor']})

  getFileRoomDetails: (companyid,fileRoomId) ->
    models['FileRoom'].find({where: {id:fileRoomId,CompanyId:companyid},attributes:['id','roomName','accessToEmployee','accessToSupervisor']})

  createFileRoom: (companyid,fileRoomObj) ->
    models['FileRoom'].create({roomName:fileRoomObj.roomName,accessToEmployee:fileRoomObj.accessToEmployee,accessToSupervisor:fileRoomObj.accessToSupervisor,CompanyId:companyid})
  
  getEmployeeFileRooms: (companyid) ->
    models['FileRoom'].findAll({where: {CompanyId:companyid,accessToEmployee:['OD','DU']},attributes:['id','roomName','accessToEmployee','accessToSupervisor']})

  getAllFileRooms: (companyid) ->
    models['FileRoom'].findAll({where: {CompanyId:companyid},attributes:['id','roomName','accessToEmployee','accessToSupervisor']})

  getEmpFileRoomDocs: (employeeId,fileRoomId) ->
    models['FileRoomDoc'].findAll({where: {EmployeeId:employeeId,FileRoomId:fileRoomId},attributes:['id','orginalName','mimeType','extension']})

  getDocFromFileRoom: (fileRoomId,fileId,employeeId) ->
    models['FileRoomDoc'].find({where: {EmployeeId:employeeId,FileRoomId:fileRoomId,id:fileId},attributes:['id','cloudName','orginalName','mimeType','extension']})

  getFileRoomDoc: (fileId,employeeId) ->
    models['FileRoomDoc'].find({where: {EmployeeId:employeeId,id:fileId},attributes:['id','cloudName','orginalName','mimeType','extension']})

  getFileRoomDocById: (fileId) ->
    models['FileRoomDoc'].find({where: {id:fileId},attributes:['id','cloudName','orginalName','mimeType','extension']})

  createFileRoomDoc: (fileRoomDocObj) ->
   models['FileRoomDoc'].create({orginalName:fileRoomDocObj.orginalName,cloudName:fileRoomDocObj.cloudName,mimeType:fileRoomDocObj.mimeType,extension:fileRoomDocObj.extension,EmployeeId:fileRoomDocObj.EmployeeId,FileRoomId:fileRoomDocObj.FileRoomId})

  getAllEmployeeList: (companyId) ->
    sequelize.query("SELECT us.uuid,us.signInId,us.firstName,us.middleName,us.lastName,emp.emplid,emp.supervisorId,
      us.isAccountActive FROM Users us,Employees emp where us.uuid = emp.UserId and us.CompanyId ="+companyId)   

  getAllActiveEmployeeList: (companyId) ->
    sequelize.query("SELECT us.uuid,us.firstName,us.middleName,us.lastName,emp.emplid,emp.supervisorId
       FROM Users us,Employees emp where us.uuid = emp.UserId and us.isAccountActive =true and us.CompanyId ="+companyId)     

  getEmployeeHeader: (companyId,emplid) ->
    query = "select us.firstName,us.middleName,us.lastName,emp.emplId,emp.supervisorId,(select CONCAT(uss.firstName,' ',uss.middleName,' ',uss.lastName) from Users uss,Employees empp where uss.uuid = empp.UserId and uss.CompanyId = us.CompanyId and empp.emplId = emp.supervisorId) supervisorName from Users us, Employees emp where us.uuid = emp.UserId and us.CompanyId ="+ companyId
    query = query+" and emp.emplId ="+emplid
    sequelize.query(query)
    .then (result) ->
      if result && result.length>0
        return result[0]
      else
        return {}  

  getEmployeeSupervisorDetails: (companyId,emplid) ->
    query = "select us.email,us.firstName,us.middleName,us.lastName,ee.UserId,ee.emplId from Employees ee,Users us where us.uuid= ee.UserId and us.CompanyId = ee.CompanyId" 
    query = query+" and ee.CompanyId="+companyId
    query = query+" and ee.emplId = (SELECT e.supervisorId from Employees e where e.CompanyId=ee.CompanyId"
    query = query+" and e.emplId ="+emplid+")"
    sequelize.query(query)
    .then (result) ->
      if result && result.length>0
        return result[0]
      else
        return {} 

  deleteTaskDepart: (taskId) ->
    sequelize.query("DELETE FROM CompanyTasksDepartments WHERE CompanyTaskId ="+taskId)

module.exports = new EmployeeDao()    
