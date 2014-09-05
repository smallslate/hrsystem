var updateEmployeeApp = angular.module('updateEmployee',['ngResource']);

updateEmployeeApp.controller('updateEmployeeCtrl', ['$scope','employeeHrService', function($scope,employeeHrService) {
	emplidIndex = location.pathname.indexOf("/emplid/");
	selectedEmplid = null;
	if(emplidIndex>5) {
      selectedEmplid = location.pathname.substring(emplidIndex+8,location.pathname.indexOf("/hr/updateEmployee"))
	}

	employeeHrService.getCompanyRoles(function(roleList) {
	  $scope.companyRoles = roleList;
	  $scope.selectedAddRoleObj = $scope.companyRoles[0];
	  if(selectedEmplid) {
		employeeHrService.getEmpAccountDetails({emplId:selectedEmplid},function(result) {
          $scope.empObj = result;
		  $scope.empRoleList =[];
  	  	  for(var i=0;i<$scope.companyRoles.length;i++) {
  	  	    if(result.roleIds.indexOf($scope.companyRoles[i].roleId)>=0) {
			  $scope.empRoleList.push($scope.companyRoles[i]);
  	  	    }
  	  	  }
  	  	  $scope.selectedRemoveRoleObj = $scope.empRoleList[0];
		});
	  }
	});

	$scope.updateEmployee = function() {
	  if(!$scope.empObj || !$scope.empObj.firstName || $scope.empObj.firstName.length<2) {
	  	alert('First name must be minimum 2 characters');
	  } else if(!$scope.empObj.lastName || $scope.empObj.lastName.length<2) {
	  	alert('Last name must be minimum 2 characters');
	  } else if(!$scope.empObj.signInId || $scope.empObj.signInId.length<2) {
	  	alert('SignIn Id must be minimum 2 characters');
	  } else if(!$scope.empObj.email || !IsEmail($scope.empObj.email)) {
	  	alert('Please enter valid email');
	  } else if(!$scope.empObj.emplId || $scope.empObj.emplId.length<1) {
	  	alert('Please enter valid employee id');
	  } else {
	  	$scope.empObj.roleIds = []
	  	for(var i=0;i<$scope.empRoleList.length;i++) {
      	  $scope.empObj.roleIds.push($scope.empRoleList[i].roleId)
        }

	  	employeeHrService.updateEmpAccount($scope.empObj,function(result) {
	  	  if(result.errMsg) {
	  	  	alert(result.errMsg)
	  	  	$scope.errMsg = result.errMsg;
	  	  	$scope.successMsg=null;
	  	  } else {
	  	  	alert("Employee data saved successfully.")
	  	  	$scope.successMsg = "Employee data saved successfully.";
	  	  	$scope.errMsg = null;
	  	  	$scope.empObj = result;
			$scope.empRoleList =[];
	  	  	for(var i=0;i<$scope.companyRoles.length;i++) {
	  	  	  if(result.roleIds.indexOf($scope.companyRoles[i].roleId)>=0) {
				$scope.empRoleList.push($scope.companyRoles[i]);
	  	  	  }
	  	  	}
	  	  }
		});
	  }
	}

	$scope.checkSigninIdAvailability = function() {
	  if(!$scope.empObj || !$scope.empObj.signInId || $scope.empObj.signInId.length<2) {
	  	alert('SignIn Id must be minimum 2 characters');
	  } else {
		employeeHrService.checkSigninIdAvailability({signInId:$scope.empObj.signInId},function(result) {
		  if(result.successMsg) {
		  	alert(result.successMsg);
		  } else {
		  	$scope.empObj.signInId =''; 
		  	alert(result.errMsg);
		  }
		});
	  }
	}

    $scope.getNextEmplid = function() {
	  employeeHrService.getNextEmplid(function(result) {
	    if(result.nextEmplid) {
	      if(!$scope.empObj) {
	      	$scope.empObj = new Object();
	      }
	  	  $scope.empObj.emplId = result.nextEmplid;
	    } else {
	  	  alert('Error communicating with server');
	    }
	  });
	}

    $scope.addRole = function() {
      if(!$scope.selectedAddRoleObj) {
		alert('Please select valid role.');
      } else { 	
	    if(!$scope.empRoleList) {
      	  $scope.empRoleList = [];
        }
        var isExist = false;
        for(i=0;i<$scope.empRoleList.length;i++) {
      	  if($scope.empRoleList[i].roleId == $scope.selectedAddRoleObj.roleId) {
      		isExist = true;
      	  }
        }
  
        if(!isExist) {
      	  $scope.empRoleList.push($scope.selectedAddRoleObj);
      	  $scope.selectedRemoveRoleObj = $scope.empRoleList[0];
        } else {
      	  alert('Role already added to employee. Please save employee data if updated.');
        }
      } 
	}

	$scope.removeRole = function() {
      if(!$scope.selectedRemoveRoleObj) {
		alert('Please select valid role.');
      } else { 	
        for(i=0;i<$scope.empRoleList.length;i++) {
      	  if($scope.empRoleList[i].roleId == $scope.selectedRemoveRoleObj.roleId) {
      	    $scope.empRoleList.splice(i, 1);
      	    $scope.selectedRemoveRoleObj = $scope.empRoleList[0];
      	    break;
      	  }
        }
      } 
	}
}]);

updateEmployeeApp.factory('employeeHrService',['$resource', function($resource) {
	return $resource('#', {}, {
		checkSigninIdAvailability : {method : 'POST',url:'/rest/hr/checkSigninIdAvailability'},
		getNextEmplid : {method : 'POST',url:'/rest/hr/getNextEmplid'},
		getCompanyRoles : {method : 'POST',url:'/rest/hr/getCompanyRoles',isArray:true},
		updateEmpAccount : {method : 'POST',url:'/rest/hr/updateEmpAccount'},
		getEmpAccountDetails : {method : 'POST',url:'/rest/hr/getEmpAccountDetails'}
	});
}]);

function IsEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}