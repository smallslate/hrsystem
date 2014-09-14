P = require("q")
moment = require("moment")

employeeDao = require('../dao/employeeDao')
accountDao = require('../dao/accountDao')

class EmpCtrl
  saveTimeSheet: (companyId,uuid,timesheetObj) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:timesheetObj.weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length < 1
          timesheetObj['submittedOn'] = new Date()
          timesheetObj['EmployeeId'] = emplObj.id
          employeeDao.createTimeSheet(timesheetObj)
          .then (dbTimeSheetObj) ->
            savedTimeSheet = {}
            savedTimeSheet.id = dbTimeSheetObj.id
            savedTimeSheet.weekId = dbTimeSheetObj.weekId
            savedTimeSheet.status = dbTimeSheetObj.status
            savedTimeSheet.submittedOn = dbTimeSheetObj.submittedOn
            savedTimeSheet.approvedOn = dbTimeSheetObj.approvedOn
            savedTimeSheet.approvedBy = dbTimeSheetObj.approvedBy
            savedTimeSheet.tasks = []
            for taskObj in dbTimeSheetObj.tasks
              savedTimeSheet.tasks.push({name:taskObj.name,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
            return savedTimeSheet
        else if savedTimesheetObjList?.length > 0 
          savedTimesheetObj = savedTimesheetObjList[0]
          savedTimesheetObj['submittedOn'] =  new Date()
          savedTimesheetObj.save()
          employeeDao.deleteTimeSheetTasks(savedTimesheetObj.id)
          .then () ->
            employeeDao.createTimeSheetTasks(timesheetObj.tasks,savedTimesheetObj.id)
            timesheetObj.status = 'submit'
            timesheetObj.submittedOn =  savedTimesheetObj.submittedOn
            timesheetObj.approvedOn = savedTimesheetObj.approvedOn
            timesheetObj.approvedBy = savedTimesheetObj.approvedBy
            return timesheetObj 

  getTimesheetById: (companyId,uuid,weekId) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
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
            savedTimeSheet.approvedBy = dbTimeSheetObj.approvedBy
            savedTimeSheet.tasks = []
            for taskObj in taskList
              savedTimeSheet.tasks.push({name:taskObj.name,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
            return savedTimeSheet
        else
          savedTimeSheet = {}
          savedTimeSheet.status = 'new'
          savedTimeSheet.weekId = weekId
          return savedTimeSheet




module.exports = new EmpCtrl()      