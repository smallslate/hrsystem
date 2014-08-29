P = require("q")
uuid = require("node-uuid")
EmployeeDao = require('../dao/employeeDao')
mail = require('../factory/mail')

class EmployeeCtrl
  constructor: ()->
    @employeeDao = new EmployeeDao()
    
  saveNewEmployee: (empObj)->
    P.invoke(@employeeDao, "saveNewEmployee", empObj)
  	  .then(@sendVerificationEmail empObj)
      .then (newEmpObj)->
  	    return newEmpObj
  	  ,(err)->
        console.log err
        return empObj
        
  sendVerificationEmail: (empObj)->
    verificationId = uuid.v4()
    P.invoke(@employeeDao, "saveNewVerification",{'displayName':empObj.displayName,'verificationId':verificationId,'signInId':empObj.signInId,'companyId':empObj.companyId})
    .then (verificationObj) ->
      valuesObj = 
        'to':empObj.email
        'companyName':empObj.companyName
        'userName':empObj.displayName.toUpperCase()
        'companyId':empObj.companyId
        'signInId': empObj.signInId
        'verificationId':verificationId
      mailOptions = mail.getNewUserEmailObj(valuesObj)
      mail.transporter.sendMail mailOptions
      return empObj
    ,(err)->
      console.log err    


module.exports = EmployeeCtrl

    
  