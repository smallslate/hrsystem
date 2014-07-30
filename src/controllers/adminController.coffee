UserDao = require('../dao/userDao')
S = require('string')
uuid = require('node-uuid');

module.exports = (app)-> 
  server = app.server
  userDaoObj = new UserDao(app) 
  mail =  app.namespaces.mail 

  server.get "/:companyId/adduser",(req,res)->
    res.render("company/admin/addUser")

  server.post "/saveUser",(req,res)->
    userObj = req.body.userObj
    userObj.companyuid = req.session.company.companyuid
    userDaoObj.addUser(userObj)
    .then (user)->
      console.log  mail.getNewUserEmailObj()
      mailOptions = mail.getNewUserEmailObj()
      mailOptions.subject = S(mailOptions.subject).template({'company':req.session.company.companyName}).s
      mailOptions.to = user.email
      mail.transporter.sendMail mailOptions, (error, info)=>
        if error
          console.log(error);
        else
          res.send(user)
     ,(error)->
        console.log 'error inserting user'
        res.send(error)

        
