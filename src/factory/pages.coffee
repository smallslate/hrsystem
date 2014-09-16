module.exports = 
  authorizedUrl : ['/a/home','/a/signOut','/a/accountSetting','/a/changePassword']
  pages:
    1      : {'type':'hrManagement','name':'HR Management Home','url':['/hr/hrHome'],'descr':'HR Management Home Page','parent':true}
    2      : {'type':'hrManagement','name':'Add/Edit Accounts','url':['/rest/hr/getEmpAccountDetails','/hr/updateEmployee','/rest/hr/checkSigninIdAvailability','/rest/hr/getNextEmplid','/rest/hr/getCompanyRoles','/rest/hr/updateEmpAccount'],'descr':'Add/Edit employee details'}
    3      : {'type':'hrManagement','name':'View All Accounts','url':['/hr/listAccounts','/rest/hr/getAllEmployeeList'],'descr':'View All Accounts'}
    4      : {'type':'hrManagement','name':'View All Timesheets','url':['/hr/listTimesheets','/rest/hr/getAllActiveEmployeeList'],'descr':'View All Timesheets'}
    5      : {'type':'hrManagement','name':'Approve Timesheets','url':['/hr/approveTimesheet','/rest/hr/getEmpTimesheet','/rest/hr/approveTimeSheet'],'descr':'Approve Timesheets'}
    1000   : {'type':'empManagement','name':'My Tasks Home','url':['/emp/empHome'],'descr':'My Tasks Home','parent':true}
    1001   : {'type':'empManagement','name':'Enter Time Sheets','url':['/emp/timesheet','/rest/emp/saveTimeSheet','/rest/emp/getTimeSheet'],'descr':'Enter Time Sheet'}
  


