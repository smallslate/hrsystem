module.exports = (app)->
  commonRoutes: require('./commonRoutes')(app)
  accountRoutes: require('./accountRoutes')(app)
  employeeRoutes: require('./employeeRoutes')(app)