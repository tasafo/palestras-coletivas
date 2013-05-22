$(function() {
  $("#event_start_date").datepicker();

  $("#event_end_date").datepicker();

  $("#event_deadline_date_enrollment").datepicker();

  $(".btn-present").on("click", function(e){
    e.preventDefault();
    addPresence(this)

  });
});

var addPresence = function(obj){

  $.ajax({
    url: "/events/presence",
    data: {
      event_id: $("#event_id").val()
    },
    type: "put",
    dataType: "json",
    success: function(res){
      $(obj).addClass("btn-success");
      $(obj).text($(obj).attr("data"));
    }
  })
}