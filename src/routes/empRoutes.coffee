P = require("q")
messages = require('../utils/messages').code

module.exports = (app)->
  server = app.server

  server.get "/c/:companyId/emp/empHome",(req,res)->
    res.render("employee/emp/empHome")

  server.get "/c/:companyId/emp/timesheet",(req,res)->
    res.render("employee/emp/timesheet")   