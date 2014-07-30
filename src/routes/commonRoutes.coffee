CommonController = require('../controllers/commonController')

module.exports = (app)->
  server = app.server
  commonControllerObj = new CommonController(app)

  server.all '/:companyId/*',commonControllerObj.updateCompanyInSession

  server.get '/:companyId/signin',(req,res)->
    res.render("company/signin")
