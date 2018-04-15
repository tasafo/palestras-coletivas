var event_id;

$(function() {
  event_id = $('#event_id').val();

  $("#event_start_date").datepicker();

  $("#event_end_date").datepicker();

  $("#event_deadline_date_enrollment").datepicker();

  $(".btn-present").on("click", function(e) {
    e.preventDefault();
    addPresence(this)
  });

  $("form.rating .rating").rating({
    callback: function (value, link) {
      $(this.form).submit();
    },
    required: true,
    half:     true
  });

  $(".rating.readonly").rating({required: true,readOnly: true, half: true});
});

var addPresence = function(obj) {
  event_id = $("#event_id").val()

  $.ajax({
    url: "/events/" + event_id + "/presences",
    type: "post",
    dataType: "json",
    success: function(res) {
      $(obj).addClass("btn-info disabled");
      $(obj).text($(obj).attr("data"));
    }
  })
}
