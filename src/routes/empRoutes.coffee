P = require("q")
messages = require('../utils/messages').code
empCtrl = require('../controllers/empCtrl')

module.exports = (app)->
  server = app.server

  server.get "/c/:companyId/emp/empHome",(req,res)->
    res.render("employee/emp/empHome")

  server.get "/c/:companyId/emp/timesheet",(req,res)->
    res.render("employee/emp/timesheet")  

  server.get "/c/:companyId/emp/fileRooms",(req,res)->
    res.render("employee/emp/empFileRoom") 

  server.get "/c/:companyId/id/:id/emp/empFileRoomDocs",(req,res)->
    res.render("employee/emp/empFileRoomDocs")

  server.post "/rest/emp/getTimesheetDocs",(req,res)->
    P.invoke(empCtrl,"getTimesheetDocs",req.session.user.companyuid,req.session.user.uuid,req.body.weekId)
    .then (timeSheetDocList) ->
      res.send(timeSheetDocList)
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])

  server.get "/rest/emp/downloadTimesheetDoc",(req,res)->
    P.invoke(empCtrl,"downloadTimesheetDoc",req.session.user.companyuid,req.session.user.uuid,req.query)
    .then (fileObj) ->
      res.setHeader('Content-disposition', 'attachment; filename=' + fileObj.timeSheetDoc.orginalName)
      res.setHeader('Content-type', fileObj.timeSheetDoc.mimeType)
      res.end(fileObj.fileData, "binary")
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])

  server.post "/rest/emp/deleteTimesheetDoc",(req,res)->
    P.invoke(empCtrl,"deleteTimesheetDoc",req.session.user.companyuid,req.session.user.uuid,req.body.weekId,req.body.timesheetDocId)
    .then (timeSheetDocList) ->
      res.send(timeSheetDocList)
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])

  server.post "/rest/emp/uploadTimeSheetDoc",(req,res)->
    P.invoke(empCtrl,"uploadTimeSheetDoc",req.session.user.companyuid,req.session.user.uuid,req.body,req.files)
    .then (timeSheetDocList) ->
      res.send(timeSheetDocList)
    ,(err) -> 
      console.log 'err=',err
      if err?.message
        res.send([{message:messages[err.message]}])
      else   
        res.send(messages['server.error'])

  server.post "/rest/emp/saveTimeSheet",(req,res)->
    P.invoke(empCtrl,"saveTimeSheet",req.session.user.companyuid,req.session.user.uuid,req.body)
    .then (timeSheetObj) ->
      res.send(timeSheetObj)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])

  server.post "/rest/emp/getTimeSheet",(req,res)->
    P.invoke(empCtrl,"getTimesheetById",req.session.user.companyuid,req.session.user.uuid,req.body.weekId)
    .then (timeSheetObj) ->
      res.send(timeSheetObj)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])  

  server.post "/rest/emp/getCompanyTasks",(req,res)->
    P.invoke(empCtrl,"getCompanyTasks",req.session.user.companyuid)
    .then (companyTasksList) ->
      res.send(companyTasksList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/emp/getCompanyTasksByDept",(req,res)->
    P.invoke(empCtrl,"getCompanyTasksByDept",req.session.user.companyuid,req.session.user.uuid)
    .then (companyTasksList) ->
      res.send(companyTasksList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/emp/getEmployeeFileRooms",(req,res)->
    P.invoke(empCtrl,"getEmployeeFileRooms",req.session.user.companyuid)
    .then (employeeFileRoomList) ->
      res.send(employeeFileRoomList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/emp/getEmpFileRoomDocs",(req,res)->
    P.invoke(empCtrl,"getEmpFileRoomDocs",req.session.user.companyuid,req.session.user.uuid,req.body.fileRoomId)
    .then (empFileRoomDocList) ->
      res.send(empFileRoomDocList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/emp/empUploadToFileRoom",(req,res)->
    P.invoke(empCtrl,"empUploadToFileRoom",req.session.user.companyuid,req.session.user.uuid,req.body,req.files)
    .then (empFileRoomDocList) ->
      res.send(empFileRoomDocList)
    ,(err) -> 
      console.log 'err=',err
      if err?.message
        res.send([{message:messages[err.message]}])
      else   
        res.send(messages['server.error'])                  

  server.post "/rest/emp/deleteEmpFileFromRoom",(req,res)->
    P.invoke(empCtrl,"deleteEmpFileFromRoom",req.session.user.companyuid,req.session.user.uuid,req.body.fileRoomId,req.body.fileId)
    .then (empFileRoomDocList) ->
      res.send(empFileRoomDocList)
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])

  server.get "/rest/emp/downloadDocFromFileRoom",(req,res)->
    P.invoke(empCtrl,"downloadDocFromFileRoom",req.session.user.companyuid,req.session.user.uuid,req.query)
    .then (fileObj) ->
      res.setHeader('Content-disposition', 'attachment; filename=' + fileObj.fileRoomDoc.orginalName)
      res.setHeader('Content-type', fileObj.fileRoomDoc.mimeType)
      res.end(fileObj.fileData, "binary")
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])    
