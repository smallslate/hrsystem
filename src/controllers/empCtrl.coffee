P = require("q")
moment = require("moment")
commonUtils = require('../utils/common')
employeeDao = require('../dao/employeeDao')
accountDao = require('../dao/accountDao')
fs = require('fs')
messages = require('../utils/messages').code
cloudStore = require('../factory/cloudStore')

class EmpCtrl

  uploadTimeSheetDoc: (companyId,uuid,body,files) =>
    file = files.files
    if file.size > 1000000
      fs.unlink(file.path)
      throw new Error('upload.file.size.1mb')
    else
      employeeDao.getEmployeeByUUid(companyId,uuid)
      .then (emplObj) =>
        emplObj.getTimesheets({where:{weekId:body.weekId}})
        .then (savedTimesheetObjList) =>
          if savedTimesheetObjList?.length > 0
            return @saveTimeSheetDoc(savedTimesheetObjList[0],file,uuid) 
          else
            timesheetObj = {}
            timesheetObj['EmployeeId'] = emplObj.id
            timesheetObj['weekId'] = body.weekId
            timesheetObj['submittedOn'] =  new Date()
            timesheetObj['tasks'] = []
            employeeDao.createTimeSheet(timesheetObj)
            .then (dbTimeSheetObj) =>
              return @saveTimeSheetDoc(dbTimeSheetObj,file,uuid) 

  saveTimeSheetDoc: (timesheetObj,file,uuid) ->
    P.invoke(cloudStore,"uploadTimesheetToStore",file,uuid,timesheetObj.weekId)
    .then (fileNameOnCloud) ->
      timesheetDoc = {orginalName:file.originalname,cloudName:fileNameOnCloud,mimeType:file.mimetype,extension:file.extension,TimesheetId:timesheetObj.id}
      employeeDao.createTimeSheetDoc(timesheetDoc)
      .then (dbTimesheetDoc) ->
        timesheetObj.getTimesheetDocs()
        .then (timesheetDocsList) ->
          return timesheetDocsList

  deleteTimesheetDoc: (companyId,uuid,weekId,timesheetDocId) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length > 0
          employeeDao.getTimeSheetDoc(savedTimesheetObjList[0].id,timesheetDocId)
          .then (timeSheetDoc) ->
            cloudStore.deleteTimesheetFromStore(timeSheetDoc.cloudName)
            timeSheetDoc.destroy()
            .then () ->
              return savedTimesheetObjList[0].getTimesheetDocs()
        else 
          return []

  getTimesheetDocs: (companyId,uuid,weekId) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length > 0
          return savedTimesheetObjList[0].getTimesheetDocs()
        else 
          return []  

  downloadTimesheetDoc: (companyId,uuid,params) ->
    console.log 'companyId,uuid,params',companyId,uuid,params
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      employeeDao.getTimeSheetDocById(params.docId)
      .then (timesheetDoc) ->
        employeeDao.getTimesheetById(timesheetDoc.TimesheetId)
        .then (savedTimesheetObjList) ->
          cloudStore.downloadTimesheetFromStore(timesheetDoc.cloudName)
          .then (fileData) ->
            fileObj = {}
            fileObj.fileData = fileData
            fileObj.timeSheetDoc = timesheetDoc
            return fileObj

  saveTimeSheet: (companyId,uuid,timesheetObj) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:timesheetObj.weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length < 1
          timesheetObj['EmployeeId'] = emplObj.id
          employeeDao.createTimeSheet(timesheetObj)
          .then (dbTimeSheetObj) ->
            savedTimeSheet = {}
            savedTimeSheet.id = dbTimeSheetObj.id
            savedTimeSheet.weekId = dbTimeSheetObj.weekId
            savedTimeSheet.status = dbTimeSheetObj.status
            savedTimeSheet.submittedOn = dbTimeSheetObj.submittedOn
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
            return timesheetObj 
        else
          return null    

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




module.exports = new EmpCtrl()      
