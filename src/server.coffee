http = require 'http'
express = require 'express'
path = require 'path'
session = require('express-session')
bodyParser = require('body-parser')
passport = require('passport')
cookieParser = require('cookie-parser')

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
    @server.locals.basedir = path.join __dirname, 'views'
    @server.use express.static __dirname+'/public'
    @server.use(cookieParser())
    @server.use bodyParser.json()
    @server.use(bodyParser.urlencoded({extended: false}))
    @server.use session
      secret: 'kqsdjfmlksdhfhzirzeoibrzecrbzuzefcuercazeafxzeokwdfzeijfxcerig',
      name:'mysystem',
      rolling :true,
      resave: true,
      saveUninitialized: true,
      cookie:
        secure: false

    require('./routes')(@app)
module.exports = new Application()      
    
