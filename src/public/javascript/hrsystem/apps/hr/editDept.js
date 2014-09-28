var editDeptApp = angular.module('editDept',['ngResource']);

editDeptApp.controller('editDeptCtrl', ['$scope','editDeptService', function($scope,editDeptService) {
	idIndex = location.pathname.indexOf("/id/");
	selectedDept = null;
	if(idIndex>5) {
      selectedDept = location.pathname.substring(idIndex+4,location.pathname.indexOf("/hr/updateDepartment"));
	}

    if(selectedDept) {
	  editDeptService.getDeptDetails({deptId:selectedDept},function(result) {
	  	if(result && result.id) {
	  	  $scope.deptObj = result;
	  	} else {
	  	  $scope.deptObj = {};
	  	}
	  });
	}

	$scope.saveDeptDetails = function() {
	  if(!$scope.deptObj || !$scope.deptObj.departmentName || $scope.deptObj.departmentName.length<2) {
	  	alert('Department Name name must be minimum 2 characters');
	  } else if(isNaN($scope.deptObj.departmentHead)) {
	  	alert('Please enter valid department head employee id');
	  } else {
		editDeptService.saveDeptDetails({deptObj:$scope.deptObj},function(result) {
	  	  if(result && result.id) {
	  	    $scope.deptObj = result;
	  	    $scope.successMsg = "Department saved successfully.";
	  	    $scope.errMsg = null;
	  	  } else {
	  	  	$scope.errMsg = "Failed to save department data. Please try again.";
	  	  	$scope.successMsg = null;
	  	  }
	    });
	  }
	}
}]);

editDeptApp.factory('editDeptService',['$resource', function($resource) {
	return $resource('#', {}, {
		getDeptDetails : {method : 'POST',url:'/rest/hr/getDeptDetails'},
		saveDeptDetails : {method : 'POST',url:'/rest/hr/saveDeptDetails'}
	});
}]);