P = require("q")
EmployeeCtrl = require('../controllers/employeeCtrl')

module.exports = (app)->
  server = app.server
  employeeCtrl = new EmployeeCtrl()
 
  server.get "/c/:companyId/u/addEmployee",(req,res)->
    res.render("employee/addEmployee")

  server.post "/u/addEmployee",(req,res)->
  	emplObj = req.body.empObj
  	emplObj.companyId = req.session.company.companyId
  	emplObj.companyName = req.session.company.companyName

  	P.invoke(employeeCtrl, "saveNewEmployee", emplObj)
    .then (newEmplObj) ->
      res.send newEmplObj
    .done() 
    