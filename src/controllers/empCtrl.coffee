P = require("q")
moment = require("moment")
commonUtils = require('../utils/common')
employeeDao = require('../dao/employeeDao')
accountDao = require('../dao/accountDao')
fs = require('fs')
messages = require('../utils/messages').code
cloudStore = require('../factory/cloudStore')
mailUtils = require('../utils/mailUtils')

class EmpCtrl

  uploadTimeSheetDoc: (companyId,uuid,body,files) =>
    file = files.files
    if file.size > 5000000
      fs.unlink(file.path)
      throw new Error('upload.file.size.5mb')
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
            timesheetObj['status'] =  'draft'
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
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      employeeDao.getTimeSheetDocById(params.id)
      .then (timesheetDoc) ->
        employeeDao.getTimesheetById(timesheetDoc.TimesheetId)
        .then (savedTimesheetObj) ->
          if savedTimesheetObj?.EmployeeId == emplObj.id
            cloudStore.downloadTimesheetFromStore(timesheetDoc.cloudName)
            .then (fileData) ->
              fileObj = {}
              fileObj.fileData = fileData
              fileObj.timeSheetDoc = timesheetDoc
              return fileObj
          else
            return null    

  saveTimeSheet: (companyId,uuid,timesheetObj) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      emplObj.getTimesheets({where:{weekId:timesheetObj.weekId}})
      .then (savedTimesheetObjList) ->
        if savedTimesheetObjList?.length < 1
          timesheetObj['EmployeeId'] = emplObj.id
          employeeDao.createTimeSheet(timesheetObj)
          .then (dbTimeSheetObj) ->
            if timesheetObj.status =='submit'
              mailUtils.sendTimesheetSubmitEmail(emplObj,timesheetObj)
            savedTimeSheet = {}
            savedTimeSheet.id = dbTimeSheetObj.id
            savedTimeSheet.weekId = dbTimeSheetObj.weekId
            savedTimeSheet.status = dbTimeSheetObj.status
            savedTimeSheet.submittedOn = dbTimeSheetObj.submittedOn
            savedTimeSheet.tasks = []
            for taskObj in dbTimeSheetObj.tasks
              savedTimeSheet.tasks.push({name:taskObj.name,comments:taskObj.comments,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
            return savedTimeSheet
        else if savedTimesheetObjList?.length > 0 
          savedTimesheetObj = savedTimesheetObjList[0]
          if timesheetObj.status =='submit' && savedTimesheetObj.status =='draft'
            mailUtils.sendTimesheetSubmitEmail(emplObj,timesheetObj)
          savedTimesheetObj['submittedOn'] =  new Date()
          savedTimesheetObj['status'] =  timesheetObj.status
          savedTimesheetObj.save()
          employeeDao.deleteTimeSheetTasks(savedTimesheetObj.id)
          .then () ->
            employeeDao.createTimeSheetTasks(timesheetObj.tasks,savedTimesheetObj.id)
            timesheetObj.status = savedTimesheetObj.status
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
              savedTimeSheet.tasks.push({name:taskObj.name,comments:taskObj.comments,Sun:taskObj.Sun,Mon:taskObj.Mon,Tue:taskObj.Tue,Wed:taskObj.Wed,Thu:taskObj.Thu,Fri:taskObj.Fri,Sat:taskObj.Sat})
            if dbTimeSheetObj.approvedBy
              accountDao.getUserByUuid(dbTimeSheetObj.approvedBy,true,companyId)
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

  getCompanyTasks: (companyId) ->
    return employeeDao.getCompanyTasks(companyId)

  getCompanyTasksByDept: (companyId,uuid) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      if emplObj?.DepartmentId
        return employeeDao.getCompanyTasksByDept(companyId,emplObj.DepartmentId)
      else
        return employeeDao.getCompanyTasks(companyId) 

  getEmployeeFileRooms: (companyId) ->
    return employeeDao.getEmployeeFileRooms(companyId) 

  getEmpFileRoomDocs: (companyId,uuid,fileRoomId) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      P.invoke(employeeDao,"getFileRoomDetails",companyId,fileRoomId)
      .then (fileRoomDetails) ->
        employeeDao.getEmpFileRoomDocs(emplObj.id,fileRoomId)
        .then (fileRoomDocsList) ->
          empFileRoom = {roomName:fileRoomDetails.roomName,accessToEmployee:fileRoomDetails.accessToEmployee,accessToSupervisor:fileRoomDetails.accessToSupervisor}
          empFileRoom.files = []
          if fileRoomDocsList && fileRoomDocsList.length>0
            for fileRoomDoc in fileRoomDocsList
              empFileRoom.files.push(fileRoomDoc) 
          return empFileRoom      

  empUploadToFileRoom: (companyId,uuid,body,files) ->
    file = files.files
    if file.size > 5000000
      fs.unlink(file.path)
      throw new Error('upload.file.size.5mb')
    else
      employeeDao.getEmployeeByUUid(companyId,uuid)
      .then (emplObj) ->
        P.invoke(employeeDao,"getFileRoomDetails",companyId,body.fileRoomId)
        .then (fileRoomDetails) ->
          if fileRoomDetails.accessToEmployee == 'DU'
            P.invoke(cloudStore,"empUploadToFileRoom",file,uuid,fileRoomDetails.id)
            .then (fileNameOnCloud) ->
              fileRoomDocObj = {orginalName:file.originalname,cloudName:fileNameOnCloud,mimeType:file.mimetype,extension:file.extension,EmployeeId:emplObj.id,FileRoomId:body.fileRoomId}
              P.invoke(employeeDao,"createFileRoomDoc",fileRoomDocObj)
              .then (fileObj) ->
                employeeDao.getEmpFileRoomDocs(emplObj.id,fileRoomDetails.id)
                .then (fileRoomDocsList) ->
                  empFileRoom = {roomName:fileRoomDetails.roomName,accessToEmployee:fileRoomDetails.accessToEmployee,accessToSupervisor:fileRoomDetails.accessToSupervisor}
                  empFileRoom.files = []
                  if fileRoomDocsList && fileRoomDocsList.length>0
                    for fileRoomDoc in fileRoomDocsList
                      empFileRoom.files.push(fileRoomDoc) 
                  return empFileRoom
          else
            throw new Error('employee.no.access.change')        

  deleteEmpFileFromRoom: (companyId,uuid,fileRoomId,fileId) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      P.invoke(employeeDao,"getFileRoomDetails",companyId,fileRoomId)
        .then (fileRoomDetails) ->
          if fileRoomDetails.accessToEmployee == 'DU'
            P.invoke(employeeDao,"getDocFromFileRoom",fileRoomId,fileId,emplObj.id)
            .then (docDetails) ->
              cloudStore.deleteFileRoomFileFromStore(docDetails.cloudName)
              docDetails.destroy()
              .then () ->
                employeeDao.getEmpFileRoomDocs(emplObj.id,fileRoomDetails.id)
                .then (fileRoomDocsList) ->
                  empFileRoom = {roomName:fileRoomDetails.roomName,accessToEmployee:fileRoomDetails.accessToEmployee,accessToSupervisor:fileRoomDetails.accessToSupervisor}
                  empFileRoom.files = []
                  if fileRoomDocsList && fileRoomDocsList.length>0
                    for fileRoomDoc in fileRoomDocsList
                      empFileRoom.files.push(fileRoomDoc) 
                  return empFileRoom
          else
            throw new Error('employee.no.access.change')  
      
        
  downloadDocFromFileRoom: (companyId,uuid,params) ->
    employeeDao.getEmployeeByUUid(companyId,uuid)
    .then (emplObj) ->
      employeeDao.getFileRoomDoc(params.id,emplObj.id)
      .then (docDetails) ->
        if docDetails
          cloudStore.downloadFileRoomFileFromStore(docDetails.cloudName)
          .then (fileData) ->
            fileObj = {}
            fileObj.fileData = fileData
            fileObj.fileRoomDoc = docDetails
            return fileObj
        else
          throw new Error('employee.no.access.change')

module.exports = new EmpCtrl()      
