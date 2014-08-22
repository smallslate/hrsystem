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
                    <p>Use your User Id to Signin and maintain all your information including timesheets and other important day to day activities at {{companyName}}</p>
                    <p>Click <a href="http://localhost:3000/c/{{companyId}}/{{signInId}}/{{verificationId}}/new/createPassword">Here </a> or below button to verify your account</p>
                    <div><a href="http://localhost:3000/c/{{companyId}}/{{signInId}}/{{verificationId}}/new/createPassword" style="text-align:center;color:black;text-decoration: none;padding-top:10px;border-radius: 4px;background-color:orange;display: block;height: 30px;width: 150px;"><b> Verify My Account</b></a></div>
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
                    <div><a href="http://localhost:3000/c/{{companyId}}/{{signInId}}/{{verificationId}}/reset/createPassword" style="text-align:center;color:black;text-decoration: none;padding-top:10px;border-radius: 4px;background-color:orange;display: block;height: 30px;width: 150px;"><b>Reset Password</b></a></div>
                    <p>If you\'ve received this mail in error, it\'s likely that another user entered your user id by mistake while trying to reset a password. If you didn\'t initiate the request, you don\'t need to take any further action and can safely disregard this email.</p>
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

  getForgotUserIdObj: (valuesObj)->
    forgotUserId = 
      from: 'support@smallslate.com'
      to: '{{to}}'
      subject: '{{companyName}} Account Assistance'
      html:'<html>
              <body>
                <div style="border-radius: 4px;background-color:#f1f1f1;height:200px;padding:5px;font-family:Helvetica,Arial,sans-serif;">
                  <div style="margin:10px;"> 
                    <h3>Dear User,</h3>
                    <div>You have requested for your {{companyName}} account details. Please find your account details below.</div>
                    <div>User Id : <b>{{userId}}</b></div>
                    <br/>
                    <p>If you\'ve received this mail in error, it\'s likely that another user entered your email by mistake while trying to get account assistance. If you didn\'t initiate the request, you don\'t need to take any further action and can safely disregard this email.</p>
                    <br/>
                    Sincerely,
                    <div>{{companyName}} Team</div>
                  </div>  
                </div>
              </body>
            </html>'
    keys = Object.keys(forgotUserId)
    for prop in keys
      forgotUserId[prop] = S(forgotUserId[prop]).template(valuesObj).s
    return forgotUserId 

module.exports = new Mail()       
