$(document).ready(function() {
  $('#profile').mouseover(function(e) {
    e.preventDefault();

    $('#commit').removeAttr('disabled');
  });
});
