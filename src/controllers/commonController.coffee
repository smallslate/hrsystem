CommonDao = require('../dao/commonDao')

class CommonController
  constructor: (app)->
    @commonDaoObj = new CommonDao(app)

  updateCompanyInSession:(req,res,next)=>
    if req.session?.company?.companyuid > 0
      res.locals.company = req.session.company
      next()
    else
      @commonDaoObj.getCompanyById(req.params.companyId,true,['companyuid','companyId','companyName','companyImg'])
      .then (company)->
        if company 
          req.session.company = res.locals.company = company
          next()
        else
          res.render("company/notValidUrl")
      ,(error)->
        res.render("company/error")

module.exports = CommonController


