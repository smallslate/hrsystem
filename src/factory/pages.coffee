module.exports = 
  authorizedUrl : ['/a/home','/a/signOut','/a/accountSetting','/a/changePassword']
  pages:
    1      : {'type':'hrManagement','name':'HR Management Home','url':['/hr/hrHome'],'parent':true}
    2      : {'type':'hrManagement','name':'Add/Edit Accounts','url':['/hr/listAccounts','/rest/hr/getAllEmployeeList','/rest/hr/getEmpAccountDetails','/hr/updateEmployee','/rest/hr/checkSigninIdAvailability','/rest/hr/getNextEmplid','/rest/hr/getCompanyRoles','/rest/hr/updateEmpAccount']}
    3      : {'type':'hrManagement','name':'Approve Timesheets','url':['/rest/emp/getCompanyTasksByDept','/hr/listTimesheets','/rest/hr/getAllActiveEmployeeList','/rest/hr/getEmployeeHeader','/rest/hr/getEmpTimesheetDocs','/rest/hr/downloadEmpTimesheetDoc','/rest/emp/getCompanyTasks','/hr/approveTimesheet','/rest/hr/getEmpTimesheet','/rest/hr/approveTimeSheet']}
    4      : {'type':'hrManagement','name':'Add/Edit Timesheet Tasks','url':['/rest/hr/saveTsTaskDetails','/rest/hr/getTsTaskDetails','/hr/updateTsTask','/rest/hr/getTsTasksList','/hr/listTsTasks']}
    5      : {'type':'hrManagement','name':'Add/Edit Departments','url':['/rest/hr/saveDeptDetails','/rest/hr/getDeptDetails','/hr/updateDepartment','/hr/listDepartments','/rest/hr/getDepartmentList']}
    

    1000   : {'type':'empManagement','name':'My Tasks Home','url':['/emp/empHome'],'parent':true}
    1001   : {'type':'empManagement','name':'Time Sheets','url':['/rest/emp/getCompanyTasks','/rest/emp/downloadTimesheetDoc','/rest/emp/deleteTimesheetDoc','/rest/emp/getTimesheetDocs','/emp/timesheet','/rest/emp/saveTimeSheet','/rest/emp/uploadTimeSheetDoc','/rest/emp/getTimeSheet']}
  
    

