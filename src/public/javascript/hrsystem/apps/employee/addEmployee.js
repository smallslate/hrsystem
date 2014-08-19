var addUserApp = angular.module('addEmployee',['ngResource']);

addUserApp.controller('addEmployeeCtrl', ['$scope','addEmployeeService', function($scope,addEmployeeService) {
	$scope.addEmployee = function() {
      $scope.empObj = addEmployeeService.addEmployee({empObj:$scope.empObj});
	}
}]);

addUserApp.factory('addEmployeeService',['$resource', function($resource) {
	return $resource('/u/addEmployee', {}, {
		addEmployee : {method : 'POST'}
	});
}]);