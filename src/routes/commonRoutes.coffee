CommonCtrl = require('../controllers/commonCtrl')
module.exports = (app)->
  server = app.server
  commonCtrl = new CommonCtrl(app)

  server.all '/c/:companyId/*',commonCtrl.updateCompanyInSession

