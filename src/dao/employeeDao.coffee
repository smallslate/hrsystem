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

  getEmployeeByUUid: (companyId,uuid) ->
    models['Employee'].find({where: {CompanyId: companyId,UserId:uuid}})  
   
  saveNewEmployee: (emplObj) ->
    models['Employee'].create(emplObj)  

  createTimeSheet: (timesheetObj) ->
    models['Timesheet'].create({weekId:timesheetObj.weekId,EmployeeId:timesheetObj.EmployeeId})
    .then (dbTimeSheetObj) ->
      for task in timesheetObj.tasks
        task.TimesheetId = dbTimeSheetObj.id
      models['TimesheetTask'].bulkCreate(timesheetObj.tasks)
      .then ()->
        dbTimeSheetObj.getTimesheetTasks()
        .then (timesheetTasks) ->
          dbTimeSheetObj.tasks = timesheetTasks
          return dbTimeSheetObj

  deleteTimeSheetTasks: (timeSheetId) ->
    models['TimesheetTask'].destroy({TimesheetId:timeSheetId})

  getTimeSheetTasks: (timeSheetId) ->
    models['TimesheetTask'].destroy({TimesheetId:timeSheetId})

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





module.exports = new EmployeeDao()    
