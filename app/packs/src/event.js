var event_id;

$(function() {
  event_id = $('#event_id').val();

  $(".btn-event-enrollment").on("click", function(e) {
    e.preventDefault();
    upsertEventEnrollment(this)
  });

  $(".btn-presence").on("click", function(e) {
    e.preventDefault();
    addPresence(this)
  });

  $(".btn-user-presence").on("click", function(e) {
    e.preventDefault();
    addUserPresence(this)
  });

  $("#event_online").on("click", function(e) {
    if ($("#event-address").is(":visible")) {
      $("#event-address").hide();
    } else {
      $("#event-address").show();
    }
  });
});

var upsertEventEnrollment = function(obj) {
  $.ajax({
    url: "/events/" + event_id + "/enrollments",
    type: "post",
    dataType: "json",
    success: function(result) {
      if (result.active == true) {
        $(obj).removeClass("btn-primary").addClass("btn-danger");
        $(obj).text($(obj).attr("data_cancel"));
        $(".btn-present").show();
      } else {
        $(obj).removeClass("btn-danger").addClass("btn-primary");
        $(obj).text($(obj).attr("data_add"));

        $(".btn-present").hide();
        $(".btn-present").removeClass("btn-info disabled").addClass("btn-primary");
        $(".btn-present").text($(".btn-present").attr("data_checkin"));
      }
    }
  })
}

var addPresence = function(obj) {
  $.ajax({
    url: "/events/" + event_id + "/presences",
    type: "post",
    dataType: "json",
    success: function(result) {
      $(obj).addClass("btn-info disabled");
      $(obj).text($(obj).attr("data_presence"));
    }
  })
}

var addUserPresence = function(obj) {
  var user_id = $(obj).attr("id");

  $.ajax({
    url: "/events/" + event_id + "/presences/" + user_id,
    type: "put",
    dataType: "json",
    success: function(result) {
      if (result.present == true) {
        $(obj).removeClass("btn-primary").addClass("btn-danger");
        $(obj).text($(obj).attr("data_undo"));
      } else {
        $(obj).removeClass("btn-danger").addClass("btn-primary");
        $(obj).text($(obj).attr("data_add"));
      }
    }
  })
}
