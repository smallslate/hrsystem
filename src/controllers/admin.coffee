UserDao = require('../dao/userDao')

module.exports = (app)-> 
  server = app.server
  userDaoObj = new UserDao(app) 
  mail =  app.namespaces.mail 

  server.get "/:companyId/adduser",(req,res)->
    res.render("company/admin/addUser")

  server.post "/saveUser",(req,res)->
    userObj = req.body.userObj
    userObj.companyuid = req.session.company.companyuid
    userDaoObj.addUser(req.body.userObj)
    .then (user)->
      mailOptions = 
        from: 'support@smallslate.com'
        to: user.email
        subject: 'User Verification from '+req.session.company.companyName
        text: 'Testing email'
      mail.transporter.sendMail mailOptions, (error, info)->
        if error
          console.log(error);
        else
          res.send(user)
     ,(error)->
        console.log 'error inserting user'
        res.send(error)


