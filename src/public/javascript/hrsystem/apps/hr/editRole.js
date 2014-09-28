var editRoleApp = angular.module('editRole',['ngResource']);

editRoleApp.controller('editRoleCtrl', ['$scope','editRoleService', function($scope,editRoleService) {
	idIndex = location.pathname.indexOf("/id/");
	selectedRoleId = null;
	if(idIndex>5) {
      selectedRoleId = location.pathname.substring(idIndex+4,location.pathname.indexOf("/hr/updateRole"));
	}

    editRoleService.getCompanyPages(function(accessPageIdList) {
	  if(selectedRoleId) {
	    editRoleService.getRoleDetails({roleId:selectedRoleId},function(result) {
	  	  if(result && result.roleId) {
	  	    $scope.roleObj = result;
	  	  } else {
	  	    $scope.roleObj = {};
	  	  }
	  	  $scope.updateSelectedRolePageAccess()
	    });
	  }
	  $scope.accessPageIdList = {};
	  $scope.companyAccessPageIdList = {};
	  for(var i=0;i<accessPageIdList.length;i++) {
		$scope.accessPageIdList[accessPageIdList[i].pageId] = true;
		$scope.companyAccessPageIdList[accessPageIdList[i].pageId] = accessPageIdList[i];
	  }
    });

    $scope.saveRoleDetails = function() {
	  if(!$scope.roleObj || !$scope.roleObj.roleName || $scope.roleObj.roleName.length<2) {
	  	alert('Role Name name must be minimum 2 characters');
	  } else {
	  	$scope.roleObj.pageAccessList = [];
        pageIds = $("input[name='selectedPages']");
        for(var i=0; i<pageIds.length;i++) {
      	  if(pageIds[i].checked) {
      	    $scope.roleObj.pageAccessList.push($scope.companyAccessPageIdList[pageIds[i].value]);
      	  }
        }
		editRoleService.saveRoleDetails({roleObj:$scope.roleObj},function(result) {
	  	  if(result && result.roleId) {
	  	    $scope.roleObj = result;
	  	    $scope.successMsg = "Role saved successfully.";
	  	    $scope.errMsg = null
	  	  } else {
	  	  	$scope.errMsg = "Failed to save Role data. Please try again.";
	  	  	$scope.successMsg = null;
	  	  }
	    });
	  }
	}

	$scope.updateSelectedRolePageAccess = function() {
		$scope.alreadySelectedPages = {};
		if($scope.roleObj && $scope.roleObj.pageAccessList && $scope.roleObj.pageAccessList.length>0) {
		  for(var i=0;i<$scope.roleObj.pageAccessList.length;i++) {
		    $scope.alreadySelectedPages[$scope.roleObj.pageAccessList[i].pageId] = true;
		  }
		}
		console.log('$scope.alreadySelectedPages=',$scope.alreadySelectedPages);
	}
}]);

editRoleApp.factory('editRoleService',['$resource', function($resource) {
	return $resource('#', {}, {
      getRoleDetails : {method : 'POST',url:'/rest/hr/getRoleDetails'},
      saveRoleDetails : {method : 'POST',url:'/rest/hr/saveRoleDetails'},
      getCompanyPages : {method : 'POST',url:'/rest/hr/getCompanyAccessPageIds',isArray:true}
	});
}]);