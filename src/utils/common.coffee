class CommonUtils
  getFullName: (userObj) ->
    name = ''
    if userObj.firstName
      name=userObj.firstName
    if userObj.middleName 
      name= name+','+userObj.firstName
    if userObj.lastName
      name= name+','+userObj.lastName
    return name  

module.exports = new CommonUtils()