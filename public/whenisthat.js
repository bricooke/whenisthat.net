$(document).ready(function() {
  $("form input[name=q]").focus();
  $("form input[name=q]").select();

  $("form input[name=zone]").val(new Date().getTimezoneOffset()/60);
});
