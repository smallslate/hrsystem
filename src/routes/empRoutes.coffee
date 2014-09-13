P = require("q")
messages = require('../utils/messages').code
empCtrl = require('../controllers/empCtrl')

module.exports = (app)->
  server = app.server

  server.get "/c/:companyId/emp/empHome",(req,res)->
    res.render("employee/emp/empHome")

  server.get "/c/:companyId/emp/timesheet",(req,res)->
    res.render("employee/emp/timesheet")  

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


