var inputmask = require('maskedinput/dist/inputmask/jquery.inputmask');

$(function() {
  $(".date").inputmask("99/99/9999");
  $(".hour").inputmask("99:99");
});
