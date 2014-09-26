var timeSheetApp = angular.module('timeSheet',['ngResource']);

timeSheetApp.controller('timeSheetCtrl', ['$scope','timesheetService', function($scope,timesheetService) {
  $scope.weekDays = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

  $('#selectedDate').datepicker({
  	format: 'mm/dd/yyyy',
    autoclose:true,
    todayBtn:'linked',
    allowDeselection:false
  })

  emplidIndex = location.pathname.indexOf("/emplid/");
  $scope.selectedEmplid = null;
  if(emplidIndex>5) {
      $scope.selectedEmplid = location.pathname.substring(emplidIndex+8,location.pathname.indexOf("/hr/approveTimesheet"))
  }

  $scope.timeSheetObj = {};
  $('#selectedDate').datepicker('setDate',(new Date().getMonth()+1)+'/'+new Date().getDate()+'/'+new Date().getFullYear());
  
  $scope.updateTableHeader = function() {
  	var selectedDate = $('#selectedDate').datepicker('getDate');
  	if(selectedDate && selectedDate!='Invalid Date') {
      var first = selectedDate.getDate() - selectedDate.getDay();
	    var firstday = new Date(selectedDate.setDate(first));
	    $scope.tableHeader= [];
	    $scope.days = [];
	    for(var i=0;i<7;i++) {
	  	  $scope.tableHeader.push((firstday.getMonth()+1)+'/'+firstday.getDate());
	  	  $scope.days.push($scope.weekDays[firstday.getDay()]);
        firstday.setDate(firstday.getDate() + 1);
	    }
      $scope.timeSheetObj.weekId = (selectedDate.getMonth()+1)+'/'+selectedDate.getDate()+'/'+selectedDate.getFullYear();
  	} else {
  		alert('Please select valid date');
  	}
  };

  $scope.updateValues = function() {
  	$scope.totalHrs = 0;
  	$scope.subTotals = {};
  	for(var i=0;i<$scope.timeSheetObj.tasks.length;i++) {
  		task = $scope.timeSheetObj.tasks[i];
		for(var j=0;j<$scope.days.length;j++) {
			cValue = parseFloat(task[$scope.days[j]]);
			if(!isNaN(cValue)) {
				$scope.totalHrs =  $scope.totalHrs+cValue;
			} else {
				task[$scope.days[j]] = cValue = 0;
				alert('Please enter valid value');
			}
			if(!$scope.subTotals[$scope.days[j]]) {
			  $scope.subTotals[$scope.days[j]] = 0;
			}
			$scope.subTotals[$scope.days[j]] = $scope.subTotals[$scope.days[j]]+cValue;
	  	}
  	}
  };

  $scope.setEmptyTimesheet = function() {
  	$scope.timeSheetObj.tasks = [];
  	$scope.timeSheetObj.tasks.push({name:'',Sun:0,Mon:0,Tue:0,Wed:0,Thu:0,Fri:0,Sat:0});
  }; 

  $scope.getEmpTimesheet = function() {
  	timesheetService.getEmpTimesheet({weekId:$scope.timeSheetObj.weekId,emplid:$scope.selectedEmplid}, function(result) {
  	  $scope.timeSheetObj = result;
  	  if(!(result && result.tasks && result.tasks.length>0)) {
  		$scope.setEmptyTimesheet();
  	  }
  	  $scope.updateValues();
	  });
  };  

  $scope.getCompanyTasks = function() {
    timesheetService.getCompanyTasks(function(result) {
      $scope.companyTasks = result;
    });
  }; 

  $scope.approveTimeSheet = function() {
    var r = confirm("Do you want to approve timesheet?");
    if (r == true) {
      timesheetService.approveTimeSheet({weekId:$scope.timeSheetObj.weekId,emplid:$scope.selectedEmplid}, function(result) {
        $scope.timeSheetObj = result;
        if(!(result && result.tasks && result.tasks.length>0)) {
          $scope.setEmptyTimesheet();
        }
        $scope.updateValues();
      });
    } 
  };

  $scope.getEmpTimesheetDocs = function() {
    $scope.timeSheetDocs = [];
    timesheetService.getEmpTimesheetDocs({weekId:$scope.timeSheetObj.weekId,emplid:$scope.selectedEmplid}, function(result) {
      $scope.timeSheetDocs = result;
    });
  }; 

  $scope.getEmployeeHeader = function() {
    $scope.timeSheetDocs = [];
    timesheetService.getEmployeeHeader({emplid:$scope.selectedEmplid}, function(result) {
      $scope.employeeHeader = result;
    });
  }; 

  $scope.initPage = function() {
    $scope.getCompanyTasks();
    $scope.getEmployeeHeader();
    $scope.updateTableHeader();
    $scope.getEmpTimesheet();
    $scope.getEmpTimesheetDocs();  
  }

  $('.datepicker').datepicker().on('changeDate', function(e) {
  	$scope.$apply(function() {
      $scope.updateTableHeader();
      $scope.getEmpTimesheet();
      $scope.getEmpTimesheetDocs();
    });
   });

  $scope.initPage();
}]);


timeSheetApp.factory('timesheetService',['$resource', function($resource) {
	return $resource('#', {}, {
		getEmpTimesheet : {method : 'POST',url:'/rest/hr/getEmpTimesheet'},
    approveTimeSheet : {method : 'POST',url:'/rest/hr/approveTimeSheet'},
    getCompanyTasks : {method : 'POST',url:'/rest/emp/getCompanyTasks',isArray:true},
    getEmpTimesheetDocs : {method : 'POST',url:'/rest/hr/getEmpTimesheetDocs',isArray:true},
    getEmployeeHeader : {method : 'POST',url:'/rest/hr/getEmployeeHeader'}
	});
}]);