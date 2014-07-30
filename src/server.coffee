http = require 'http'
express = require 'express'
path = require 'path'
session = require('express-session')
bodyParser = require('body-parser')
factory = require("./factory")()

class Application
  constructor: ->
    @app = @
    @initServer()
    @startServer()

  startServer: -> 
    http.createServer(@server).listen 3000,->
  	  console.log "server started"

  initServer: ->
    @server = express()
    @server.set('trust proxy', 1)
    @server.set 'views', __dirname + '/views'
    @server.set 'view engine', 'jade'
    @server.use session
      secret: 'kqsdjfmlksdhfhzirzeoibrzecrbzuzefcuercazeafxzeokwdfzeijfxcerig',
      name:'mysystem',
      rolling :true,
      cookie:
        secure: false
    @server.use bodyParser() 
    @server.use express.static __dirname+'/public'
    @server.locals.basedir = path.join __dirname, 'views'
    @namespaces =
      models: factory.db.models
      mail: factory.mail 
    require('./routes')(@app)
module.exports = new Application()      
    
