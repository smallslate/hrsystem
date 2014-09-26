var updateTsTasksApp = angular.module('updateTsTasks',['ngResource']);

updateTsTasksApp.controller('updateTsTasksCtrl', ['$scope','updateTsTasksService', function($scope,updateTsTasksService) {
	$scope.taskObj = {};
	idIndex = location.pathname.indexOf("/id/");
	selectedId = null;
	if(idIndex>5) {
      selectedId = location.pathname.substring(idIndex+4,location.pathname.indexOf("/hr/updateTsTask"));
	}

	updateTsTasksService.getDeptDetails(function(result) {
  	  if(result && result.length>0) {
  	    $scope.deptList = result;
  	  } else {
  	    $scope.deptList = []
  	  }
    });

    if(selectedId) {
	  updateTsTasksService.getTsTaskDetails({taskId:selectedId},function(result) {
  	    if(result && result.id>0) {
  	      $scope.taskObj = result;
  	    } else {
  	      $scope.taskObj = {}
  	    }
      });
	}

    $scope.addDept = function() {
      if(!$scope.selectedAddDeptObj) {
		alert('Please select valid Department.');
      } else { 	
	    if(!$scope.taskObj.deptList) {
      	  $scope.taskObj.deptList = [];
        }

        var isExist = false;
        for(i=0;i<$scope.taskObj.deptList.length;i++) {
      	  if($scope.taskObj.deptList[i].id == $scope.selectedAddDeptObj.id) {
      		isExist = true;
      	  }
        }
  
        if(!isExist) {
      	  $scope.taskObj.deptList.push($scope.selectedAddDeptObj);
      	  $scope.selectedRemoveDeptObj = $scope.taskObj.deptList[0];
        } else {
      	  alert('Department already added.');
        }
      } 
	}

    $scope.saveTsTask = function() {
      var r = confirm("Do you want to save task details? Department added cannot be removed again.");
      if (r == true) {
	    updateTsTasksService.saveTsTaskDetails({taskObj:$scope.taskObj},function(result) {
  	      if(result && result.id>0) {
  	        $scope.taskObj = result;
  	        $scope.successMsg = "Task details saved successfully.";
  	      } else {
  	        $scope.taskObj = {}
  	        $scope.errMsg = "Task details cannot be saved. Please try again.";
  	      }
        });
      }
	}
}]);

updateTsTasksApp.factory('updateTsTasksService',['$resource', function($resource) {
	return $resource('#', {}, {
		getDeptDetails : {method : 'POST',url:'/rest/hr/getDepartmentList',isArray:true},
		getTsTaskDetails : {method : 'POST',url:'/rest/hr/getTsTaskDetails'},
		saveTsTaskDetails : {method : 'POST',url:'/rest/hr/saveTsTaskDetails'}
	});
}]);