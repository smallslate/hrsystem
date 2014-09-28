var empFileRoomDocsApp = angular.module('empFileRoomDocs',['ngResource']);

empFileRoomDocsApp.controller('empFileRoomDocsCtrl', ['$scope','empFileRoomDocsService', function($scope,empFileRoomDocsService) {
 






}]);

empFileRoomDocsApp.factory('empFileRoomDocsService',['$resource', function($resource) {
	return $resource('#', {}, {
		
	});
}]);