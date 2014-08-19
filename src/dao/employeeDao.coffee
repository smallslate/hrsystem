db = require('../factory/db')

class EmployeeDao
  constructor: ()->
    @models = db.models

  saveNewEmployee: (emplObj) ->
    @models['Employees'].create(emplObj)  

  saveNewVerification: (verificationObj) ->
    @models['Verification'].create(verificationObj)     	

module.exports = EmployeeDao