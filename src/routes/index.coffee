module.exports = (app)->
  accountRoutes: require('./accountRoutes')(app)
  hrRoutes: require('./hrRoutes')(app)
  empRoutes: require('./empRoutes')(app)