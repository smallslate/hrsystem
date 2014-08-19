db = require('../factory/db')

class CommonDao
  constructor: ()->
    @models = db.models

  getCompanyById: (companyId,isActive=true,attributes = null) ->
    @models['Companies'].find 
  	  where:
  	    companyId:companyId
  	    isActive:isActive
  	  attributes:attributes    	

module.exports = CommonDao


