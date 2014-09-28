var editFileRoomApp = angular.module('editFileRoom',['ngResource']);

editFileRoomApp.controller('editFileRoomCtrl', ['$scope','editFileRoomService', function($scope,editFileRoomService) {
	idIndex = location.pathname.indexOf("/id/");
	selectedFileRoom = null;
	if(idIndex>5) {
      selectedFileRoom = location.pathname.substring(idIndex+4,location.pathname.indexOf("/hr/updateFileRoom"));
	}

    if(selectedFileRoom) {
	  editFileRoomService.getFileRoomDetails({fileRoomId:selectedFileRoom},function(result) {
	  	if(result && result.id) {
	  	  $scope.fileRoomObj = result;
	  	} else {
	  	  $scope.fileRoomObj = {};
	  	}
	  });
	}

	$scope.saveFileRoomDetails = function() {
	  if(!$scope.fileRoomObj || !$scope.fileRoomObj.roomName || $scope.fileRoomObj.roomName.length<2) {
	  	alert('File Room Name name must be minimum 2 characters');
	  } else {
		editFileRoomService.saveFileRoomDetails({fileRoomObj:$scope.fileRoomObj},function(result) {
	  	  if(result && result.id) {
	  	    $scope.fileRoomObj = result;
	  	    $scope.successMsg = "File Room Data saved successfully.";
	  	    $scope.errMsg = null;
	  	  } else {
	  	  	$scope.errMsg = "Failed to save data. Please try again.";
	  	  	$scope.successMsg = null;
	  	  }
	    });
	  }
	}
}]);

editFileRoomApp.factory('editFileRoomService',['$resource', function($resource) {
	return $resource('#', {}, {
	  getFileRoomDetails : {method : 'POST',url:'/rest/hr/getFileRoomDetails'},
	  saveFileRoomDetails : {method : 'POST',url:'/rest/hr/saveFileRoomDetails'}
	});
}]);