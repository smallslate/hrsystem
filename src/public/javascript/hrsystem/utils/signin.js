function validateForm() {
  userNameVal = $("#username").val();
  passwordVal = $("#password").val();
  if(!userNameVal || userNameVal.length<4) {
    alert('Please enter valid SignIn Id');
    return false;
  } else if(!passwordVal || passwordVal.length<4) {
    alert('Please enter valid Password');
    return false;
  } 
  return true;
}