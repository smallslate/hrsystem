class CommonDao
  constructor: (app)->
    @models = app.namespaces.models

  getCompanyById: (companyId,isActive=true,attributes = null) ->
      @models['Companies'].find 
      	where:
      	  companyId:companyId
      	  isActive:true
      	attributes:attributes

module.exports = CommonDao


