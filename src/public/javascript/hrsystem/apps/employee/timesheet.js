var timeSheetApp = angular.module('timeSheet',['ngResource']);

timeSheetApp.controller('timeSheetCtrl', ['$scope', function($scope) {
  $('#selectedDate').datepicker({
  	format: 'mm/dd/yyyy',
    autoclose:true,
    todayBtn:'linked',
    endDate: new Date()
  })
  $('#selectedDate').datepicker('setDate', (new Date().getMonth()+1)+'/'+new Date().getDate()+'/'+new Date().getFullYear());
  $scope.timeSheetObj = {};

  $scope.updateTableHeader = function() {
  	var selectedDate = $('#selectedDate').datepicker('getDate');
  	if(selectedDate && selectedDate!='Invalid Date') {
  	  curr = $('#selectedDate').datepicker('getDate');
      var first = curr.getDate() - curr.getDay();
	  var firstday = new Date(curr.setDate(first));
	  $scope.tableHeader= [];
	  for(var i=0;i<7;i++) {
	  	$scope.tableHeader.push((firstday.getMonth()+1)+'/'+firstday.getDate());
        firstday.setDate(firstday.getDate() + 1);
	  }
      $scope.timeSheetObj = {};
      $scope.timeSheetObj.tasks = [];
      $scope.timeSheetObj.selectedDate = curr;
  	} else {
  		alert('Please select valid date');
  	}
  };

  $scope.updateValues = function() {
  	$scope.timeSheetObj.totalHrs = 0;
  	$scope.subTotals = {};
  	for(var i=0;i<$scope.timeSheetObj.tasks.length;i++) {
  		task = $scope.timeSheetObj.tasks[i];
		for(var j=0;j<$scope.tableHeader.length;j++) {
			cValue = parseFloat(task[$scope.tableHeader[j]]);
			if(!isNaN(cValue)) {
				$scope.timeSheetObj.totalHrs =  $scope.timeSheetObj.totalHrs+cValue;
			} else {
				task[$scope.tableHeader[j]] = cValue = 0;
				alert('Please enter valid value');
			}
			if(!$scope.subTotals[$scope.tableHeader[j]]) {
			  $scope.subTotals[$scope.tableHeader[j]] = 0;
			}
			$scope.subTotals[$scope.tableHeader[j]] = $scope.subTotals[$scope.tableHeader[j]]+cValue;
	  	}
  	}
  };

  $scope.addNewTask = function() {
    task = {};
    task["name"] = ' ';
    for(var i=0;i<7;i++) {
      task[$scope.tableHeader[i]] = 0;
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
  $scope.updateTableHeader();
  $scope.addNewTask();

  $('.datepicker').datepicker().on('changeDate', function(e) {
  	$scope.$apply(function(){
      $scope.updateTableHeader();
    });
   });
}]);