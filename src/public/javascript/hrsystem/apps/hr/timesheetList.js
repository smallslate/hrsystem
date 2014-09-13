var timesheetListApp = angular.module('timesheetList',['ngResource']);

timesheetListApp.controller('timesheetListCtrl', ['$scope','timesheetListService', function($scope,timesheetListService) {
	timesheetListService.getAllActiveEmployeeList(function(empList) {
		if(empList && empList.length>0) {
		  $scope.empList = empList;
		} else {
			$scope.empList=[];
		}
	});
}]);

timesheetListApp.factory('timesheetListService',['$resource', function($resource) {
	return $resource('#', {}, {
		getAllActiveEmployeeList : {method : 'POST',url:'/rest/hr/getAllActiveEmployeeList',isArray:true}
	});
}]);