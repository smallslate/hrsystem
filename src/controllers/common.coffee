commonDao = require('../dao/commonDao')

module.exports = (app)->
  commonDaoObj = new commonDao(app)  
  server = app.server

  server.all '/:companyId/*', (req,res,next) ->
    if req.session.company && req.session.company.companyuid > 0
      res.locals.company = req.session.company
    next()

  server.get "/:companyId/signin",(req,res)->
    commonDaoObj.getCompanyById(req.params.companyId,true,['companyuid','companyId','companyName','companyImg'])
    .then (company)->
        if company 
          req.session.company = company
          res.locals.company = company
          res.render("company/signin")
        else
          res.render("company/notValid")
     ,(error)->
        console.log error
        res.render("company/error")


