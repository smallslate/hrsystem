S = require('string')
nodemailer = require('nodemailer')

class Mail
  constructor:->
    @mail = @
    @transporter = nodemailer.createTransport
      service: 'Gmail'
      auth:
        user: 'support@smallslate.com' 
    return @mail

  getNewUserEmailObj: (valuesObj)->
    newUserEmail = 
      from: 'support@smallslate.com'
      to: '{{to}}'
      subject: 'New Account Verification from {{companyName}}'
      html: 'Testing email. Please click on below link to verify. <a href="http://localhost:3000/c/{{companyId}}/{{signInId}}/{{verificationId}}/new/createPassword>Create Password</a>'
    keys = Object.keys(newUserEmail)
    for prop in keys
      newUserEmail[prop] = S(newUserEmail[prop]).template(valuesObj).s
    return newUserEmail  


module.exports = new Mail()       
