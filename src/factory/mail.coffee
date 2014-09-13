S = require('string')
nodemailer = require('nodemailer')
config = require('./config')

class Mail
  constructor:->
    @mail = @
    @transporter = nodemailer.createTransport
      service: 'Gmail'
      auth:
        user: config.mail.user
        pass: config.mail.pass
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
                    <div>SignIn Id : <b>{{signInId}}</b></div>
                    <p>Use your SignIn Id to access your account and maintain all your information including timesheets and other important day to day activities at {{companyName}}</p>
                    <p>Click <a href="'+config.server.serverUrl+'/c/{{companyId}}/{{signInId}}/{{verificationId}}/new/createPassword">Here </a> or below button to verify your account</p>
                    <div><a href="'+config.server.serverUrl+'/c/{{companyId}}/{{signInId}}/{{verificationId}}/new/createPassword" style="text-align:center;color:black;text-decoration: none;padding-top:15px;border-radius: 4px;background-color:orange;display: block;height: 30px;width: 150px;"><b> Verify My Account</b></a></div>
                    <br/>
                    Sincerely,
                    <div>{{companyName}} Team</div>
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
      subject: '{{companyName}} Password Assistance'
      html:'<html>
              <body>
                <div style="border-radius: 4px;background-color:#f1f1f1;height:200px;padding:5px;font-family:Helvetica,Arial,sans-serif;">
                  <div style="margin:10px;"> 
                    <h3>Dear User,</h3>
                    <p>To initiate the password reset process for your {{companyName}} Account, click the link below.</p>
                    <div><a href="'+config.server.serverUrl+'/c/{{companyId}}/{{signInId}}/{{verificationId}}/reset/createPassword" style="text-align:center;color:black;text-decoration: none;padding-top:15px;border-radius: 4px;background-color:orange;display: block;height: 30px;width: 150px;"><b>Reset Password</b></a></div>
                    <p>If you\'ve received this mail in error, it\'s likely that another user entered your SignIn Id by mistake while trying to reset a password. If you didn\'t initiate the request, you don\'t need to take any further action and can safely disregard this email.</p>
                    <br/>
                    Sincerely,
                    <div>{{companyName}} Team</div>
                  </div>  
                </div>
              </body>
            </html>'
    keys = Object.keys(forgotPasswordEmail)
    for prop in keys
      forgotPasswordEmail[prop] = S(forgotPasswordEmail[prop]).template(valuesObj).s
    return forgotPasswordEmail  

  getForgotSignInIdObj: (valuesObj)->
    forgotSignInId = 
      from: 'support@smallslate.com'
      to: '{{to}}'
      subject: '{{companyName}} Account Assistance'
      html:'<html>
              <body>
                <div style="border-radius: 4px;background-color:#f1f1f1;height:200px;padding:5px;font-family:Helvetica,Arial,sans-serif;">
                  <div style="margin:10px;"> 
                    <h3>Dear User,</h3>
                    <div>You have requested for your {{companyName}} account details. Please find your account details below.</div>
                    <div>SignIn Id : <b>{{signInId}}</b></div>
                    <br/>
                    <p>If you\'ve received this mail in error, it\'s likely that another user entered your email by mistake while trying to get account assistance. If you didn\'t initiate the request, you don\'t need to take any further action and can safely disregard this email.</p>
                    <br/>
                    Sincerely,
                    <div>{{companyName}} Team</div>
                  </div>  
                </div>
              </body>
            </html>'
    keys = Object.keys(forgotSignInId)
    for prop in keys
      forgotSignInId[prop] = S(forgotSignInId[prop]).template(valuesObj).s
    return forgotSignInId 

module.exports = new Mail()       
