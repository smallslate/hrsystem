#1.Add here
#2.Add to respective menu and sub menu
#3.Add to edit roles page
#4.Script to assign new page to company
module.exports = 
  authorizedUrl : ['/a/home','/a/signOut','/a/accountSetting','/a/changePassword']
  pages:
    1      : {'name':'HR','url':['/hr/hrHome']}
    2      : {'name':'Add/Edit Accounts','parentId':'1','url':['/hr/listAccounts','/rest/hr/getAllEmployeeList','/rest/hr/getEmpAccountDetails','/hr/updateEmployee','/rest/hr/checkSigninIdAvailability','/rest/hr/getNextEmplid','/rest/hr/getCompanyRoles','/rest/hr/updateEmpAccount']}
    3      : {'name':'Approve Timesheets','parentId':'1','url':['/rest/emp/getCompanyTasksByDept','/hr/listTimesheets','/rest/hr/getAllActiveEmployeeList','/rest/hr/getEmployeeHeader','/rest/hr/getEmpTimesheetDocs','/rest/hr/downloadEmpTimesheetDoc','/rest/emp/getCompanyTasks','/hr/approveTimesheet','/rest/hr/getEmpTimesheet','/rest/hr/approveTimeSheet']}
    4      : {'name':'Add/Edit Timesheet Tasks','parentId':'1','url':['/rest/hr/saveTsTaskDetails','/rest/hr/getTsTaskDetails','/hr/updateTsTask','/rest/hr/getTsTasksList','/hr/listTsTasks']}
    5      : {'name':'Add/Edit Departments','parentId':'1','url':['/rest/hr/saveDeptDetails','/rest/hr/getDeptDetails','/hr/updateDepartment','/hr/listDepartments','/rest/hr/getDepartmentList']}
    6      : {'name':'Add/Edit Roles','parentId':'1','url':['/rest/hr/getCompanyAccessPageIds','/rest/hr/saveRoleDetails','/rest/hr/getRoleDetails','/hr/listRoles','/rest/hr/getRoleList','/hr/updateRole']}
    7      : {'name':'Add/Edit File Rooms','parentId':'1','url':['/hr/listHrFileRooms','/rest/hr/getHrFileRooms','/hr/updateFileRoom','/rest/hr/getFileRoomDetails','/rest/hr/saveFileRoomDetails']}

    1000   : {'name':'My Tasks','url':['/emp/empHome']}
    1001   : {'name':'Timesheets','parentId':'1000','url':['/rest/emp/getCompanyTasks','/rest/emp/downloadTimesheetDoc','/rest/emp/deleteTimesheetDoc','/rest/emp/getTimesheetDocs','/emp/timesheet','/rest/emp/saveTimeSheet','/rest/emp/uploadTimeSheetDoc','/rest/emp/getTimeSheet']}
    1002   : {'name':'File Rooms','parentId':'1000','url':['/emp/fileRooms','/rest/emp/getEmployeeFileRooms','/emp/empFileRoomDocs']}
  
    

