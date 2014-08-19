CommonDao = require('../dao/commonDao')

class CommonCtrl
  constructor: ()->
    @commonDaoObj = new CommonDao()

  updateCompanyInSession:(req,res,next)=>
    if req.session?.company?.companyuid > 0
      if req.params.companyId == req.session.company.companyId
        res.locals.company = req.session.company
        next()
      else
        #logout
        res.locals.company = req.session.company = null
        res.render("common/urlChanged")  
    else
      console.log 1
      @commonDaoObj.getCompanyById(req.params.companyId,true,['companyuid','companyId','companyName','companyImg'])
      .then (company)->
        if company 
          req.session.company = res.locals.company = company
          next()
        else
          res.render("company/notValidUrl")
      ,(error)->
        res.render("company/error")
  
module.exports = CommonCtrl


