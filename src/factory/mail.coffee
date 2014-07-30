nodemailer = require('nodemailer')

class Mail
  constructor:->
    @mail = @
    @transporter = nodemailer.createTransport
      service: 'Gmail'
      auth:
        user: 'support@smallslate.com' 
    return @mail

  getNewUserEmailObj: ->
    from: 'support@smallslate.com'
    to: ''
    subject: 'New Account Verification from {{company}}'
    html: 'Testing email. Please click on below link to verify. <a href="http://localhost:3000/{{companyId}}/verifyEmail?email={{email}}&verify={{verificationCode}}"></a>'

module.exports = new Mail()       
