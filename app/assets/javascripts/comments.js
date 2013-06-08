$(document).ready(function() {
  $(".answer_comment").on("click", function(e) {
    e.preventDefault();
    var form = $(this).parent().find("form.answer_form");
    form.show();
    form.find("textarea").focus();
  });
});