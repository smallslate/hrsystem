class UserDao
  constructor: (app)->
    @models = app.namespaces.models

  addUser: (userObj) ->
      @models['Users'].create userObj,['useruid','userId','companyuid','email']

module.exports = UserDao


