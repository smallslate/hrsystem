class UserDao
  constructor: (app)->
    @models = app.namespaces.models

  addUser: (userObj) ->
      @models['Users'].create userObj,['useruid','userId','companyuid','email']

  addUserVerification: (userVerificationObj) ->
      @models['UserVerifications'].create userVerificationObj,['verificationId','userId','companyuid','email']    

module.exports = UserDao


