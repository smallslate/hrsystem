var employeeListApp = angular.module('employeeList',['ngResource']);

employeeListApp.controller('employeeListCtrl', ['$scope','employeeListService', function($scope,employeeListService) {
	employeeListService.getEmployeeList(function(empList) {
		if(empList && empList.length>0) {
		  $scope.empList = empList;
		} else {
			$scope.empList=[];
		}
	});
}]);

employeeListApp.factory('employeeListService',['$resource', function($resource) {
	return $resource('#', {}, {
		getEmployeeList : {method : 'POST',url:'/rest/hr/getAllEmployeeList',isArray:true}
	});
}]);