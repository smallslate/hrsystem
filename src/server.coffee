http = require 'http'
express = require 'express'
utils = require './utils'

class Application
  constructor: ->
    @app = @
    @server = express()
    @namespaces =
      utils: utils
      config: utils.config
     
    @initRoutes()  
    http.createServer(@server).listen(process.env.PORT)
    
  initRoutes: ()->
    @namespaces.utils.router(@app)   

module.exports = new Application()