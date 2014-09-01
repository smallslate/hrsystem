P = require("q")
hrCtrl = require('../controllers/hrCtrl')
messages = require('../utils/messages').code

module.exports = (app)->
  server = app.server

  server.get "/c/:companyId/hr/hrHome",(req,res)->
    res.render("employee/hr/hrHome")

  server.get "/c/:companyId/hr/updateEmployee",(req,res)->
    res.render("employee/hr/updateEmployee")  

  server.post "/rest/hr/getNextEmplid",(req,res)->
    P.invoke(hrCtrl,"getNextEmplid",req.session.user.companyuid)
    .then (nextEmplid)->
      res.send({"nextEmplid":nextEmplid})

  server.post "/rest/hr/getCompanyRoles",(req,res)->
    P.invoke(hrCtrl,"getCompanyRoles",req.session.user.companyuid)
    .then (roleList)->
      res.send(roleList) 

  server.post "/rest/hr/addNewEmployee",(req,res)->
    P.invoke(hrCtrl,"addNewEmployee",req.session.user.companyuid,req.body)
    .then (userObj)->
      res.send(userObj)
    ,(err) ->
      console.log err
      res.send({"err":"falied to save employee"})   



    