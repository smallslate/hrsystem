var empFileRoomDocsApp = angular.module('empFileRoomDocs',['ngResource']);

empFileRoomDocsApp.controller('empFileRoomDocsCtrl', ['$scope','empFileRoomDocsService', function($scope,empFileRoomDocsService) {
    idIndex = location.pathname.indexOf("/id/");
    selectedFileRoom = null;
    if(idIndex>5) {
      selectedFileRoom = location.pathname.substring(idIndex+4,location.pathname.indexOf("/emp/empFileRoomDocs"));
    }

    if(selectedFileRoom) {
	  empFileRoomDocsService.getEmpFileRoomDocs({fileRoomId:selectedFileRoom},function(result) {
	  	$scope.fileRoomObj = result;
	  });
	}

    $scope.deleteEmpFileFromRoom = function(fileId) {
      var r = confirm("Delete this document from file room?");
      if (r == true) {
        empFileRoomDocsService.deleteEmpFileFromRoom({fileRoomId:selectedFileRoom,fileId:fileId},function(result) {
	  	  $scope.fileRoomObj = result;
	    });
      }
    }

	$('#fileupload').fileupload({
      dataType: 'json',
      url: '/rest/emp/empUploadToFileRoom',
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
        data.formData = {fileRoomId: selectedFileRoom};
      });
    });

}]);

empFileRoomDocsApp.factory('empFileRoomDocsService',['$resource', function($resource) {
	return $resource('#', {}, {
	  getEmpFileRoomDocs : {method : 'POST',url:'/rest/emp/getEmpFileRoomDocs'},
	  deleteEmpFileFromRoom : {method : 'POST',url:'/rest/emp/deleteEmpFileFromRoom'}
	});
}]);