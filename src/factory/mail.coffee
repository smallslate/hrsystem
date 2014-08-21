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
      subject: '{{companyName}} - New Account Created'
      html:'<html>
              <body>
                <div style="border-radius: 4px;background-color:#f1f1f1;height:200px;padding:5px;font-family:Helvetica,Arial,sans-serif;">
                  <div style="margin:10px;"> 
                    <h3>Dear {{userName}},</h3>
                    <h3>Welcome to {{companyName}}</h3>
                    <div>Your {{companyName}} account has been created.</div>
                    <div>User Id : <b>{{userId}}</b></div>
                    <div>Employee Id : <b>{{emplId}}</b></div>
                    <p>Use above mentioned User Id to signin and maintain all your information including your time sheets and other important day to day activities at {{companyName}}</p>
                    <p>Click <a href="http://localhost:3000/c/{{companyId}}/{{signInId}}/{{verificationId}}/new/createPassword">Here </a> or below button to verify your account</p>
                    <div><a href="http://localhost:3000/c/{{companyId}}/{{signInId}}/{{verificationId}}/new/createPassword" style="text-align:center;color:black;text-decoration: none;padding-top:10px;border-radius: 4px;background-color:orange;display: block;height: 30px;width: 150px;"><b> Verify My Account</a></b></div>
                    <br/>
                    Sincerely,
                    <div>Teknest Team</div>
                  </div>  
                </div>
              </body>
            </html>'
    keys = Object.keys(newUserEmail)
    for prop in keys
      newUserEmail[prop] = S(newUserEmail[prop]).template(valuesObj).s
    return newUserEmail  

  getForgotPasswordObj: (valuesObj)->
    forgotPasswordEmail = 
      from: 'support@smallslate.com'
      to: '{{to}}'
      subject: 'Reset Your Password'
      html: 'Testing reset password email. Please click on below link to verify. <a href="http://localhost:3000/c/{{companyId}}/{{signInId}}/{{verificationId}}/reset/createPassword>Reset Password</a>'
    keys = Object.keys(forgotPasswordEmail)
    for prop in keys
      forgotPasswordEmail[prop] = S(forgotPasswordEmail[prop]).template(valuesObj).s
    return forgotPasswordEmail  

  getForgotUserIdObj: (valuesObj)->
    forgotUserId = 
      from: 'support@smallslate.com'
      to: '{{to}}'
      subject: 'Your Sign Id'
      html: 'Testing forgot Signin ID email. Your Signid is {{signInId}}'
    keys = Object.keys(forgotUserId)
    for prop in keys
      forgotUserId[prop] = S(forgotUserId[prop]).template(valuesObj).s
    return forgotUserId 

module.exports = new Mail()       
