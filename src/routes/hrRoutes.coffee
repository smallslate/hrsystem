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

  server.get "/c/:companyId/hr/updateDepartment",(req,res)->
    res.render("employee/hr/company/updateDepartment")

  server.get "/c/:companyId/id/:id/hr/updateDepartment",(req,res)->
    res.render("employee/hr/company/updateDepartment")

  server.get "/c/:companyId/hr/listAccounts",(req,res)->
    res.render("employee/hr/listAccounts")

  server.get "/c/:companyId/hr/listTimesheets",(req,res)->
    res.render("employee/hr/timesheets/listTimesheets")  

  server.get "/c/:companyId/emplid/:emplid/hr/approveTimesheet",(req,res)->
    res.render("employee/hr/timesheets/approveTimesheet")

  server.get "/c/:companyId/hr/listTsTasks",(req,res)->
    res.render("employee/hr/timesheets/listTsTasks")

  server.get "/c/:companyId/hr/listDepartments",(req,res)->
    res.render("employee/hr/company/listDepartments")

  server.get "/c/:companyId/hr/updateTsTask",(req,res)->
    res.render("employee/hr/timesheets/updateTsTasks")

  server.get "/c/:companyId/id/:id/hr/updateTsTask",(req,res)->
    res.render("employee/hr/timesheets/updateTsTasks")

  server.get "/c/:companyId/hr/updateRole",(req,res)->
    res.render("employee/hr/company/updateRole")

  server.get "/c/:companyId/id/:id/hr/updateRole",(req,res)->
    res.render("employee/hr/company/updateRole")

  server.get "/c/:companyId/hr/listRoles",(req,res)->
    res.render("employee/hr/company/listRoles")

  server.get "/c/:companyId/hr/listHrFileRooms",(req,res)->
    res.render("employee/hr/company/hrFileRoomList")

  server.get "/c/:companyId/hr/updateFileRoom",(req,res)->
    res.render("employee/hr/company/updateFileRoom")

  server.get "/c/:companyId/id/:id/hr/updateFileRoom",(req,res)->
    res.render("employee/hr/company/updateFileRoom")

  server.get "/c/:companyId/hr/listFileRoomEmps",(req,res)->
    res.render("employee/hr/fileRoom/listFileRoomEmps")

  server.get "/c/:companyId/id/:id/hr/employeeFileRoom",(req,res)->
    res.render("employee/hr/fileRoom/employeeFileRoom")

  server.post "/rest/hr/getNextEmplid",(req,res)->
    P.invoke(hrCtrl,"getNextEmplid",req.session.user.companyuid)
    .then (nextEmplid)->
      res.send({"nextEmplid":nextEmplid})
    ,(err) ->
      console.log 'err is ',err
      res.send(null)    

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
    ,(err) ->
      console.log 'err is ',err
      res.send(null)    

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

  server.post "/rest/hr/getDepartmentList",(req,res)->
    P.invoke(hrCtrl,"getDepartmentList",req.session.user.companyuid)
    .then (departmentList) ->
      res.send(departmentList)
    ,(err) ->
      res.send(messages['server.error']) 

  server.post "/rest/hr/getDeptDetails",(req,res)->
    P.invoke(hrCtrl,"getDeptDetails",req.session.user.companyuid,req.body.deptId)
    .then (deptDetails) ->
      res.send(deptDetails)
    ,(err) ->
      res.send(messages['server.error']) 

  server.post "/rest/hr/saveDeptDetails",(req,res)->
    P.invoke(hrCtrl,"saveDeptDetails",req.session.user.companyuid,req.body.deptObj)
    .then (deptDetails) ->
      res.send(deptDetails)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])  

  server.post "/rest/hr/getTsTasksList",(req,res)->
    P.invoke(hrCtrl,"getTsTasksList",req.session.user.companyuid,req.body.deptId)
    .then (tsTasksList) ->
      res.send(tsTasksList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/hr/getTsTaskDetails",(req,res)->
    P.invoke(hrCtrl,"getTsTaskDetails",req.session.user.companyuid,req.body.taskId)
    .then (tsTaskDetails) ->
      res.send(tsTaskDetails)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])  

  server.post "/rest/hr/saveTsTaskDetails",(req,res)->
    P.invoke(hrCtrl,"saveTsTaskDetails",req.session.user.companyuid,req.body.taskObj)
    .then (tsTaskDetails) ->
      res.send(tsTaskDetails)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/hr/getRoleList",(req,res)->
    P.invoke(hrCtrl,"getRoleList",req.session.user.companyuid)
    .then (roleList) ->
      res.send(roleList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/hr/getRoleDetails",(req,res)->
    P.invoke(hrCtrl,"getRoleDetails",req.session.user.companyuid,req.body.roleId)
    .then (roleDetails) ->
      res.send(roleDetails)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error']) 

  server.post "/rest/hr/saveRoleDetails",(req,res)->
    P.invoke(hrCtrl,"saveRoleDetails",req.session.user.companyuid,req.body.roleObj)
    .then (roleDetails) ->
      res.send(roleDetails)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])
      
  server.post "/rest/hr/getCompanyAccessPageIds",(req,res)->
    P.invoke(hrCtrl,"getCompanyAccessPageIds",req.session.user.companyuid)
    .then (pageIdList) ->
      res.send(pageIdList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])   

  server.post "/rest/hr/getHrFileRooms",(req,res)->
    P.invoke(hrCtrl,"getHrFileRooms",req.session.user.companyuid)
    .then (fileRoomList) ->
      res.send(fileRoomList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])                                         

  server.post "/rest/hr/getFileRoomDetails",(req,res)->
    P.invoke(hrCtrl,"getFileRoomDetails",req.session.user.companyuid,req.body.fileRoomId)
    .then (fileRoomDetails) ->
      res.send(fileRoomDetails)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])

  server.post "/rest/hr/saveFileRoomDetails",(req,res)->
    P.invoke(hrCtrl,"saveFileRoomDetails",req.session.user.companyuid,req.body.fileRoomObj)
    .then (fileRoomDetails) ->
      res.send(fileRoomDetails)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])

  server.post "/rest/hr/getAllFileRooms",(req,res)->
    P.invoke(hrCtrl,"getAllFileRooms",req.session.user.companyuid)
    .then (employeeFileRoomList) ->
      res.send(employeeFileRoomList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])

  server.post "/rest/hr/getEmployeeFileRoomDocs",(req,res)->
    P.invoke(hrCtrl,"getEmployeeFileRoomDocs",req.session.user.companyuid,req.body.emplId,req.body.fileRoomId)
    .then (empFileRoomDocList) ->
      res.send(empFileRoomDocList)
    ,(err) ->
      console.log 'err=',err
      res.send(messages['server.error'])

  server.post "/rest/hr/uploadEmpFilesToFileRoom",(req,res)->
    P.invoke(hrCtrl,"uploadEmpFilesToFileRoom",req.session.user.companyuid,req.body,req.files)
    .then (empFileRoomDocList) ->
      res.send(empFileRoomDocList)
    ,(err) -> 
      console.log 'err=',err
      if err?.message
        res.send([{message:messages[err.message]}])
      else   
        res.send(messages['server.error'])

  server.post "/rest/hr/deleteEmpFileFromRoom",(req,res)->
    P.invoke(hrCtrl,"deleteEmpFileFromRoom",req.session.user.companyuid,req.body.emplId,req.body.fileRoomId,req.body.fileId)
    .then (empFileRoomDocList) ->
      res.send(empFileRoomDocList)
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])

  server.get "/rest/hr/downloadDocFromFileRoom",(req,res)->
    P.invoke(hrCtrl,"downloadDocFromFileRoom",req.session.user.companyuid,req.query)
    .then (fileObj) ->
      res.setHeader('Content-disposition', 'attachment; filename=' + fileObj.fileRoomDoc.orginalName)
      res.setHeader('Content-type', fileObj.fileRoomDoc.mimeType)
      res.end(fileObj.fileData, "binary")
    ,(err) -> 
      console.log 'err=',err 
      res.send(messages['server.error'])                       



    