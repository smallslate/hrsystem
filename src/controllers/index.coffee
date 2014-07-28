module.exports = (app)->
  common : require("./common")(app)
  admin : require("./admin")(app)
  
  