P = require("q")
mailFactory = require('../factory/mail')
uuid = require("node-uuid")
accountDao = require('../dao/accountDao')

class MailUtils
  sendAccountActivationEmail: (userDetails,empDetails) ->
    P.invoke(accountDao,"getCompanyByuid",userDetails.CompanyId)
    .then (cmpDetails) ->
      verificationId = uuid.v4()
      P.invoke(accountDao,"saveNewVerification",{'lastName':userDetails.lastName,'verificationId':verificationId,'signInId':userDetails.signInId,'companyId':cmpDetails.companyId})
      .then (verificationObj) ->
        mailOptions = mailFactory.getNewUserEmailObj({to:userDetails.email,companyName:cmpDetails.companyName,userName:userDetails.lastName,signInId:userDetails.signInId,companyId:cmpDetails.companyId,verificationId:verificationId})
        console.log 'mailOptions=',mailOptions
        mailFactory.transporter.sendMail mailOptions, (error, info) ->
          console.log 'error = ',error
          console.log 'info = ',info
module.exports = new MailUtils()