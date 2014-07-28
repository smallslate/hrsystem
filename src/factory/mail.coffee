nodemailer = require('nodemailer')

class Mail
  constructor:->
  	@mail = @
    @transporter = nodemailer.createTransport
      service: 'Gmail'
      auth:
        user: 'support@smallslate.com',
        pass: 'lionking'   
    return @mail

    getNewUserEmailObj: ->
      newUserEmailObj['mailOptions'] = 
        from: 'support@smallslate.com'
        to: ''
        subject: 'New Account Verification from ::company::'
        html: 'Testing email'

    

module.exports = new Mail()       
