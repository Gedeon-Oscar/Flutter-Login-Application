/*

  -------------------------------------------------------------------
  The regular expression pattern.
  -------------------------------------------------------------------
  r'^
  (?=.*[A-Z])       // should contain at least one upper case
  (?=.*[a-z])       // should contain at least one lower case
  (?=.*?[0-9])      // should contain at least one digit
  (?=.*?[!@#\$&*~]) // should contain at least one Special character
  .{8,}             // Must be at least 8 characters in length
  $

*/

RegExp regexPassword = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
RegExp regexNumber = RegExp(r'^(?=.*?[0-9])(?=.*?[+-])$');