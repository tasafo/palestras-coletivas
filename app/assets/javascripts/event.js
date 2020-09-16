var event_id;

$(function() {
  event_id = $('#event_id').val();

  if ($("#event_online").is(":checked")) {
    $("#event-address").hide();
  }

  $("#event_start_date").datepicker();

  $("#event_end_date").datepicker();

  $("#event_deadline_date_enrollment").datepicker();

  $(".btn-present").on("click", function(e) {
    e.preventDefault();
    addPresence(this)
  });

  $("#event_online").on("click", function(e) {
    if ($("#event-address").is(":visible")) {
      $("#event-address").hide();
    } else {
      $("#event-address").show();
    }
  });

  $("form.rating .rating").rating({
    callback: function (value, link) {
      $(this.form).submit();
    },
    required: true,
    half:     true
  });

  $(".rating.readonly").rating({required: true, readOnly: true, half: true});
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
