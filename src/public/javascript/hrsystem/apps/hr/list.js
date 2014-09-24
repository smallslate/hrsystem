var listApp = angular.module('list',['ngResource']);

listApp.controller('listCtrl', ['$scope','listService', function($scope,listService) {
	listService.getList(function(lists) {
		if(lists && lists.length>0) {
		  $scope.lists = lists;
		} else {
			$scope.lists=[];
		}
	});
}]);

listApp.factory('listService',['$resource', function($resource) {
	return $resource('#', {}, {
		getList : {method : 'POST',url:LIST_URL,isArray:true}
	});
}]);