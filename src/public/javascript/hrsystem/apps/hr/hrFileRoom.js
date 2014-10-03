var hrFileRoomApp = angular.module('hrFileRoom',['ngResource']);

hrFileRoomApp.controller('hrFileRoomCtrl', ['$scope','hrFileRoomService', function($scope,hrFileRoomService) {
    idIndex = location.pathname.indexOf("/id/");
	selectedEmplid = null;
	if(idIndex>5) {
      $scope.selectedEmplid = location.pathname.substring(idIndex+4,location.pathname.indexOf("/hr/employeeFileRoom"));
	}

    $scope.getEmployeeHeader = function() {
      hrFileRoomService.getEmployeeHeader({emplid:$scope.selectedEmplid}, function(result) {
        $scope.employeeHeader = result;
      });
    }; 

    $scope.getFileRooms= function() {
      hrFileRoomService.getFileRooms(function(result) {
        $scope.fileRooms = result;
        $scope.selectedFileRoom = $scope.fileRooms[0].id;
        $scope.onChangeFileRoom();
      });
    };

    $scope.onChangeFileRoom = function() {
      hrFileRoomService.getEmployeeFileRoomDocs({emplId:$scope.selectedEmplid,fileRoomId:$scope.selectedFileRoom},function(result) {
        $scope.fileRoomObj = result;
      });
    };

    $scope.initPage = function() {
      $scope.getEmployeeHeader();
      $scope.getFileRooms();
    }

    $scope.deleteEmpFileFromRoom = function(fileId) {
      var r = confirm("Delete this document from file room?");
      if (r == true) {
        hrFileRoomService.deleteEmpFileFromRoom({emplId:$scope.selectedEmplid,fileRoomId:$scope.selectedFileRoom,fileId:fileId},function(result) {
	  	  $scope.fileRoomObj = result;
	    });
      }
    }

    $scope.initPage();

    $('#fileupload').fileupload({
      dataType: 'json',
      url: '/rest/hr/uploadEmpFilesToFileRoom',
      done: function (e, data) {
        $scope.$apply(function() {
          if(data.result && data.result.length >0 && data.result[0].message) {
            alert(data.result[0].message.errMsg);
          } else {
            $scope.fileRoomObj = data.result;
          }
        });
      }
    });

    $('#fileupload').bind('fileuploadsubmit', function (e, data) {
      $scope.$apply(function() {
        data.formData = {emplId:$scope.selectedEmplid,fileRoomId:$scope.selectedFileRoom};
      });
    });

}]);

hrFileRoomApp.factory('hrFileRoomService',['$resource', function($resource) {
	return $resource('#', {}, {
	  getEmployeeHeader : {method : 'POST',url:'/rest/hr/getEmployeeHeader'},
	  getFileRooms : {method : 'POST',url:'/rest/hr/getAllFileRooms',isArray:true},
	  getEmployeeFileRoomDocs : {method : 'POST',url:'/rest/hr/getEmployeeFileRoomDocs'},
	  deleteEmpFileFromRoom : {method : 'POST',url:'/rest/hr/deleteEmpFileFromRoom'}
	});
}]);