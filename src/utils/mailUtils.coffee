P = require("q")
mailFactory = require('../factory/mail')
uuid = require("node-uuid")
accountDao = require('../dao/accountDao')
employeeDao = require('../dao/employeeDao')

class MailUtils
  sendAccountActivationEmail: (userDetails,empDetails) ->
    P.invoke(accountDao,"getCompanyByuid",userDetails.CompanyId)
    .then (cmpDetails) ->
      verificationId = uuid.v4()
      P.invoke(accountDao,"saveNewVerification",{'lastName':userDetails.lastName,'verificationId':verificationId,'signInId':userDetails.signInId,'companyId':cmpDetails.companyId})
      .then (verificationObj) ->
        mailOptions = mailFactory.getNewUserEmailObj({to:userDetails.email,companyName:cmpDetails.companyName,userName:userDetails.lastName,signInId:userDetails.signInId,companyId:cmpDetails.companyId,verificationId:verificationId})
        mailFactory.transporter.sendMail mailOptions, (error, info) ->
          console.log 'error = ',error

  sendTimesheetSubmitEmail: (emplObj,timesheetObj) ->
    P.invoke(employeeDao,"getEmployeeSupervisorDetails",emplObj.CompanyId,emplObj.emplId)
    .then (supervisorDetails) ->
      accountDao.getUserByUuid(emplObj.UserId,true,emplObj.CompanyId)
      .then (userObj) ->
        accountDao.getCompanyByuid(emplObj.CompanyId)
        .then (cmpDetails) ->
          emplName = ''
          if userObj.firstName && userObj.firstName.length>0
            emplName = userObj.firstName
          if userObj.middleName && userObj.middleName.length>0
            emplName = emplName+' '+userObj.middleName
          if userObj.lastName && userObj.lastName.length>0
            emplName = emplName+' '+userObj.lastName
          emplIdWeekId = emplObj.emplId+'WID'+timesheetObj.weekId.replace(new RegExp('/','g'),'-')   
          mailOptions = mailFactory.getTimesheetSubmitEmailObj({supervisorEmail:supervisorDetails.email,employeeName:emplName,weekId:timesheetObj.weekId,companyName:cmpDetails.companyName,companyId:cmpDetails.companyId,emplIdWeekId:emplIdWeekId})
          mailFactory.transporter.sendMail mailOptions, (error, info) ->
            console.log 'error = ',error
    .fail (err) ->
      console.log 'failed',err 

module.exports = new MailUtils()