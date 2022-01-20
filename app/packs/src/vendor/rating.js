require('jquery-star-rating-plugin/jquery.rating.css');
var rating = require('jquery-star-rating-plugin/jquery.rating');

$(function() {
  $("form.rating .rating").rating({
    callback: function (value, link) {
      $(this.form).submit();
    },
    required: true,
    half: true
  });

  $(".rating.readonly").rating({required: true, readOnly: true, half: true});
});
