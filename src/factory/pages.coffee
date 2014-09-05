module.exports = 
  authorizedUrl : ['/a/home','/a/signOut','/a/accountSetting','/a/changePassword']
  pages:
    hr:
      1      : {'type':'hrManagement','name':'HR Management Home','url':['/hr/hrHome'],'descr':'HR Management Home Page','parent':true}
      2      : {'type':'hrManagement','name':'Add/Edit Employee','url':['/rest/hr/getEmpAccountDetails','/hr/updateEmployee','/rest/hr/checkSigninIdAvailability','/rest/hr/getNextEmplid','/rest/hr/getCompanyRoles','/rest/hr/updateEmpAccount'],'descr':'Add/Edit employee details'}