module.exports = (app)->
  accountRoutes: require('./accountRoutes')(app)
  employeeRoutes: require('./employeeRoutes')(app)