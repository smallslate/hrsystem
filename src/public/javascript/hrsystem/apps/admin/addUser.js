var addUserApp = angular.module('addUser',['ngResource']);

addUserApp.controller('addUserCtrl', ['$scope','addUserService', function($scope,addUserService) {
	$scope.addUser = function() {
      $scope.userObj = addUserService.addUser({userObj:$scope.userObj});
	}
}]);

addUserApp.factory('addUserService',['$resource', function($resource) {
	return $resource('/saveUser', {}, {
		addUser : {method : 'POST'}
	});
}]);