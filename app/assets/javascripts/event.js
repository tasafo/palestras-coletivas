var event_id;

$(function() {
  var menuEl = document.querySelector('#event-menu');
  var menu = new mdc.menu.MDCMenu(menuEl);
  var menuButtonEl = document.querySelector('#event-menu-button');
  event_id = $('#event_id').val();

  menuButtonEl.addEventListener('click', function() {
    menu.open = !menu.open;
  });

  menu.quickOpen = true;

  $(".btn-present").on("click", function(e) {
    e.preventDefault();
    addPresence(this)
  });

  // $("form.rating .rating").rating({
  //   callback: function (value, link) {
  //     $(this.form).submit();
  //   },
  //   required: true,
  //   half:     true
  // });

  // $(".rating.readonly").rating({required: true,readOnly: true, half: true});
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
