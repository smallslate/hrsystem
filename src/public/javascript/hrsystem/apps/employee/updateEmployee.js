var updateEmployeeApp = angular.module('updateEmployee',['ngResource']);

updateEmployeeApp.controller('updateEmployeeCtrl', ['$scope','employeeHrService', function($scope,employeeHrService) {
	employeeHrService.getCompanyRoles(function(roleList) {
	  $scope.companyRoles = roleList;
	  $scope.selectedAddRoleObj = $scope.companyRoles[0];
	});

	$scope.updateEmployee = function() {
	  if(!$scope.empObj || !$scope.empObj.firstName || $scope.empObj.firstName.length<2) {
	  	alert('First name must be minimum 2 characters')
	  } else if(!$scope.empObj.lastName || $scope.empObj.lastName.length<2) {
	  	alert('Last name must be minimum 2 characters')
	  } else if(!$scope.empObj.signInId || $scope.empObj.signInId.length<2) {
	  	alert('SignIn Id must be minimum 2 characters')
	  } else if(!$scope.empObj.email || !IsEmail($scope.empObj.email)) {
	  	alert('Please enter valid email')
	  } else if(!$scope.empObj.emplId || $scope.empObj.emplId.length<1) {
	  	alert('Please enter valid employee id')
	  } else {
	  	console.log($scope.empObj);	
	  }
	}

	$scope.checkSigninIdAvailability = function() {
	  if(!$scope.empObj || !$scope.empObj.signInId || $scope.empObj.signInId.length<2) {
	  	alert('SignIn Id must be minimum 2 characters')
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
	    if(!$scope.empObj) {
      	  $scope.empObj = new Object();
      	  $scope.empObj.roleList = new Array();
        }
        if(!$scope.empObj.roleList){
      	  $scope.empObj.roleList = new Array();
        }
        var isExist = false;
        for(i=0;i<$scope.empObj.roleList.length;i++) {
      	  if($scope.empObj.roleList[i].roleId == $scope.selectedAddRoleObj.roleId) {
      		isExist = true;
      	  }
        }
        if(!isExist) {
      	  $scope.empObj.roleList.push($scope.selectedAddRoleObj);
      	  $scope.selectedRemoveRoleObj = $scope.empObj.roleList[0];
        } else {
      	  alert('Role already added to employee. Please save employee data if updated.');
        }
      } 
	}

	$scope.removeRole = function() {
      if(!$scope.selectedRemoveRoleObj) {
		alert('Please select valid role.');
      } else { 	
        for(i=0;i<$scope.empObj.roleList.length;i++) {
      	  if($scope.empObj.roleList[i].roleId == $scope.selectedRemoveRoleObj.roleId) {
      	    $scope.empObj.roleList.splice(i, 1);
      	    $scope.selectedRemoveRoleObj = $scope.empObj.roleList[0];
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
		getCompanyRoles : {method : 'POST',url:'/rest/hr/getCompanyRoles',isArray:true}
	});
}]);

function IsEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}