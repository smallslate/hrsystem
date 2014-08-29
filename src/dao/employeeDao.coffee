db = require('../factory/db')

class EmployeeDao
  constructor: ()->
    @models = db.models

  saveNewEmployee: (emplObj) ->
    @models['User'].create(emplObj)  

  saveNewVerification: (verificationObj) ->
    @models['Verification'].create(verificationObj)     	

module.exports = EmployeeDao