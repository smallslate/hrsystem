var timeSheetApp = angular.module('timeSheet',['ngResource']);

timeSheetApp.controller('timeSheetCtrl', ['$scope','timesheetService', function($scope,timesheetService) {
  $scope.weekDays = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

  $('#selectedDate').datepicker({
  	format: 'mm/dd/yyyy',
    autoclose:true,
    todayBtn:'linked'
  })
  $scope.timeSheetObj = {};
  $scope.timeSheetDocs = [];
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
  			if(isNaN(cValue)) {
  				task[$scope.days[j]] = cValue = 0;
  			} else {
          $scope.totalHrs =  $scope.totalHrs+parseFloat(cValue);
          task[$scope.days[j]] = cValue;
  			}
  			if(!$scope.subTotals[$scope.days[j]]) {
  			  $scope.subTotals[$scope.days[j]] = 0;
  			}
  			$scope.subTotals[$scope.days[j]] = $scope.subTotals[$scope.days[j]]+cValue; 
  	  }
  	}
  };

  $scope.addNewTask = function() {
    task = {};
    task["name"] = ' ';
    task["comments"] = ' ';
    for(var i=0;i<7;i++) {
      task[$scope.days[i]] = 0;
	  }
	  $scope.timeSheetObj.tasks.push(task);
	  $scope.updateValues();
  };

  $scope.removeTask = function(index) {
  	if($scope.timeSheetObj.tasks.length < 2) {
  	  alert('You cannot remove all tasks.');
  	} else {
  	  $scope.timeSheetObj.tasks.splice(index,1);
	  $scope.updateValues();
  	}
  };

  $scope.saveTimeSheet = function() {
  	timesheetService.saveTimeSheet($scope.timeSheetObj, function(result) {
		  $scope.timeSheetObj = result;
		  $scope.updateValues();
		  alert('Timesheet saved successfully.');
	  });
  };

  $scope.setEmptyTimesheet = function() {
  	$scope.timeSheetObj.tasks = [];
    if($scope.timeSheetObj.status == 'new') {
      $scope.timeSheetObj.tasks.push({name:'',comments:'',Sun:0,Mon:8,Tue:8,Wed:8,Thu:8,Fri:8,Sat:0});
    } else {
      $scope.timeSheetObj.tasks.push({name:'',comments:'',Sun:0,Mon:0,Tue:0,Wed:0,Thu:0,Fri:0,Sat:0});
    }
  }; 

  $scope.getTimeSheet = function() {
  	timesheetService.getTimeSheet({weekId:$scope.timeSheetObj.weekId}, function(result) {
  	  $scope.timeSheetObj = result;
  	  if(!(result && result.tasks && result.tasks.length>0)) {
  		  $scope.setEmptyTimesheet();
  	  }
  	  $scope.updateValues();
      if($scope.timeSheetObj.status=='approved') {
        $('#fileupload').hide();
      } else {
        $('#fileupload').show();
      }
	  });
  };  

  $scope.getTimesheetDocs = function() {
    $scope.timeSheetDocs = [];
    timesheetService.getTimesheetDocs({weekId:$scope.timeSheetObj.weekId}, function(result) {
      $scope.timeSheetDocs = result;
    });
  }; 

  $scope.deleteTimesheetDoc = function(timesheetDocId) {
    var r = confirm("Delete this timesheet document?");
    if (r == true) {
      timesheetService.deleteTimesheetDoc({weekId:$scope.timeSheetObj.weekId,timesheetDocId:timesheetDocId}, function(result) {
        $scope.timeSheetDocs = result;
      });
    } 
  }; 

  $scope.getCompanyTasks = function() {
    timesheetService.getCompanyTasks(function(result) {
      $scope.companyTasks = result;
    });
  }; 

  $scope.initPage = function() {
    $scope.getCompanyTasks();
    $scope.updateTableHeader();
    $scope.getTimeSheet();
    $scope.getTimesheetDocs();
  }

  $scope.initPage();

  $('.datepicker').datepicker().on('changeDate', function(e) {
    $scope.$apply(function() {
      $scope.updateTableHeader();
      $scope.getTimeSheet();
      $scope.getTimesheetDocs();
    });
  });

  $('#fileupload').fileupload({
    dataType: 'json',
    url: '/rest/emp/uploadTimeSheetDoc',
    done: function (e, data) {
      $scope.$apply(function() {
        if(data.result && data.result.length >0 && data.result[0].message) {
          alert(data.result[0].message.errMsg);
        } else {
          $scope.timeSheetDocs = data.result;
        }
      });
    }
  });

  $('#fileupload').bind('fileuploadsubmit', function (e, data) {
     $scope.$apply(function() {
      data.formData = {weekId: $scope.timeSheetObj.weekId};
       $('#progress .progress-bar').css('width','0%');
       $('#progress-bar').text('0%');
    });
  });

}]);

timeSheetApp.factory('timesheetService',['$resource', function($resource) {
	return $resource('#', {}, {
		saveTimeSheet : {method : 'POST',url:'/rest/emp/saveTimeSheet'},
		getTimeSheet : {method : 'POST',url:'/rest/emp/getTimeSheet'},
    getTimesheetDocs : {method : 'POST',url:'/rest/emp/getTimesheetDocs',isArray:true},
    deleteTimesheetDoc : {method : 'POST',url:'/rest/emp/deleteTimesheetDoc',isArray:true},
    getCompanyTasks : {method : 'POST',url:'/rest/emp/getCompanyTasksByDept',isArray:true}
	});
}]);