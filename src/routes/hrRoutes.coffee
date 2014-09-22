P = require("q")
hrCtrl = require('../controllers/hrCtrl')
messages = require('../utils/messages').code
empCtrl = require('../controllers/empCtrl')

module.exports = (app)->
  server = app.server

  server.get "/c/:companyId/hr/hrHome",(req,res)->
    res.render("employee/hr/hrHome")

  server.get "/c/:companyId/hr/updateEmployee",(req,res)->
    res.render("employee/hr/updateEmployee")

  server.get "/c/:companyId/emplid/:emplid/hr/updateEmployee",(req,res)->
    res.render("employee/hr/updateEmployee")  

  server.get "/c/:companyId/hr/listAccounts",(req,res)->
    res.render("employee/hr/listAccounts")

  server.get "/c/:companyId/hr/listTimesheets",(req,res)->
    res.render("employee/hr/listTimesheets")  

  server.get "/c/:companyId/emplid/:emplid/hr/approveTimesheet",(req,res)->
    res.render("employee/hr/approveTimesheet")

  server.post "/rest/hr/getNextEmplid",(req,res)->
    P.invoke(hrCtrl,"getNextEmplid",req.session.user.companyuid)
    .then (nextEmplid)->
      res.send({"nextEmplid":nextEmplid})

  server.post "/rest/hr/getEmployeeHeader",(req,res)->
    P.invoke(hrCtrl,"getEmployeeHeader",req.session.user.companyuid,req.body.emplid)
    .then (employeeHeaderDetails) ->
      res.send(employeeHeaderDetails)
    ,(err) ->
      console.log 'err is ',err
      res.send(null)  

  server.post "/rest/hr/getCompanyRoles",(req,res)->
    P.invoke(hrCtrl,"getCompanyRoles",req.session.user.companyuid)
    .then (roleList)->
      res.send(roleList) 

  server.post "/rest/hr/updateEmpAccount",(req,res)->
    P.invoke(hrCtrl,"updateEmpAccount",req.session.user.companyuid,req.body)
    .then (userObj)->
      res.send(userObj)
    ,(err) ->
      if err.message in ['user.signin.not.available','employee.exist.with.emplid']
        res.send(messages[err.message])
      else
        console.log 'err=',err
        res.send(messages['server.error']) 

  server.post "/rest/hr/getEmpAccountDetails",(req,res)->
    P.invoke(hrCtrl,"getEmpAccountDetails",req.session.user.companyuid,req.body.emplId)
    .then (userObj) ->
      res.send(userObj)
    ,(err) ->
      console.log 'err',err
      res.send(messages['server.error'])

  server.post "/rest/hr/getAllEmployeeList",(req,res)->
    P.invoke(hrCtrl,"getAllEmployeeList",req.session.user.companyuid)
    .then (allEmployeeList) ->
      res.send(allEmployeeList)
    ,(err) ->
      console.log err
      res.send(messages['server.error']) 

  server.post "/rest/hr/getAllActiveEmployeeList",(req,res)->
    P.invoke(hrCtrl,"getAllActiveEmployeeList",req.session.user.companyuid)
    .then (allEmployeeList) ->
      res.send(allEmployeeList)
    ,(err) ->
      res.send(messages['server.error']) 

  server.post "/rest/hr/getEmpTimesheet",(req,res)->
    P.invoke(hrCtrl,"getEmpTimesheet",req.session.user.companyuid,req.body.emplid,req.body.weekId)
    .then (timeSheetObj) ->
      res.send(timeSheetObj)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/hr/getEmpTimesheetDocs",(req,res)->
    P.invoke(hrCtrl,"getEmpTimesheetDocs",req.session.user.companyuid,req.body.emplid,req.body.weekId)
    .then (timeSheetDocList) ->
      res.send(timeSheetDocList)
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])

  server.get "/rest/hr/downloadEmpTimesheetDoc",(req,res)->
    P.invoke(hrCtrl,"downloadEmpTimesheetDoc",req.session.user.companyuid,req.query)
    .then (fileObj) ->
      res.setHeader('Content-disposition', 'attachment; filename=' + fileObj.timeSheetDoc.orginalName)
      res.setHeader('Content-type', fileObj.timeSheetDoc.mimeType)
      res.end(fileObj.fileData, "binary")
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])

  server.post "/rest/hr/approveTimeSheet",(req,res)->
    P.invoke(hrCtrl,"approveTimeSheet",req.session.user.companyuid,req.session.user.uuid,req.body.emplid,req.body.weekId)
    .then (timeSheetObj) ->
      res.send(timeSheetObj)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])       




    