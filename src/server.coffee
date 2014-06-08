http = require "http"
express = require "express"
app = express()

app.set('port', process.env.PORT || 3000);



http.createServer(app).listen app.get('port'), ->
  console.log("server started")