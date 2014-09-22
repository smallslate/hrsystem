db = require('../factory/db')
sequelize = db.sequelize
models = db.models

class EmployeeDao
  getMaxEmplidOfCompany: (companyId) ->
    models['Employee'].max('emplId',{ where: {companyId: companyId}}) 

  getCompanyRoles: (companyid) ->
    models['Role'].findAll({where: {companyid:companyid},attributes:['roleId','roleName','roleDescr']})

  getCompanyRolesById: (companyid,roleIdList) ->
    models['Role'].findAll({where: {companyid:companyid,roleId:[roleIdList]},attributes:['roleId','roleName','roleDescr']})

  getEmployeeByEmplid: (companyId,emplid) ->
    models['Employee'].find({ where: {companyId: companyId,emplId:emplid}})

  getEmployeeById: (companyId,emplid) ->
    models['Employee'].find({ where: {companyId: companyId,id:emplid}})

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
    models['Timesheet'].create({weekId:timesheetObj.weekId,EmployeeId:timesheetObj.EmployeeId,submittedOn:new Date()})
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

  getTimeSheetTasks: (timeSheetId) ->
    models['TimesheetTask'].destroy({TimesheetId:timeSheetId})

  getCompanyTasks: (companyId) ->
    models['CompanyTask'].findAll({where: {CompanyId:companyId,isActive:true},attributes:['id','name']})

  createTimeSheetTasks: (taskList,timesheetId) ->
    for task in taskList
        task.TimesheetId = timesheetId
    models['TimesheetTask'].bulkCreate(taskList) 

  getAllEmployeeList: (companyId) ->
    sequelize.query("SELECT us.uuid,us.signInId,us.firstName,us.middleName,us.lastName,emp.emplid,emp.supervisorId,
      us.isAccountActive FROM Users us,Employees emp where us.uuid = emp.UserId and us.CompanyId ="+companyId)   

  getAllActiveEmployeeList: (companyId) ->
    sequelize.query("SELECT us.uuid,us.firstName,us.middleName,us.lastName,emp.emplid,emp.supervisorId
       FROM Users us,Employees emp where us.uuid = emp.UserId and us.isAccountActive =true and us.CompanyId ="+companyId)     

  getEmployeeHeader: (companyId,emplid) ->
    console.log 'query companyId,emplid=',companyId,emplid
    sequelize.query("select us.firstName,us.middleName,us.lastName,emp.emplId,emp.supervisorId
      from Users us, Employees emp where us.uuid = emp.UserId and us.CompanyId ="+ companyId +" and emp.emplId ="+emplid) 




module.exports = new EmployeeDao()    
