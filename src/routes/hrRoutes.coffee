P = require("q")
hrCtrl = require('../controllers/hrCtrl')
messages = require('../utils/messages').code

module.exports = (app)->
  server = app.server

  server.get "/c/:companyId/hr/hrHome",(req,res)->
    res.render("employee/hr/hrHome")

  server.get "/c/:companyId/hr/updateEmployee",(req,res)->
    res.render("employee/hr/updateEmployee")

  server.get "/c/:companyId/emplid/:emplid/hr/updateEmployee",(req,res)->
    res.render("employee/hr/updateEmployee")  

  server.post "/rest/hr/getNextEmplid",(req,res)->
    P.invoke(hrCtrl,"getNextEmplid",req.session.user.companyuid)
    .then (nextEmplid)->
      res.send({"nextEmplid":nextEmplid})

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



    