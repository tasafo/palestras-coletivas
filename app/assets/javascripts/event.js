var event_id;

$(function() {
  var menuEl = document.querySelector('#event-menu');
  if  ( menuEl ){
    var menu = new mdc.menu.MDCMenu(menuEl);
    var menuButtonEl = document.querySelector('#event-menu-button');

    menuButtonEl.addEventListener('click', function() {
      menu.open = !menu.open;
    });

    menu.quickOpen = true;
  }

  event_id = $('#event_id').val();

  $(".btn-present").on("click", function(e) {
    e.preventDefault();
    addPresence(this)
  });

  $('#subscription-button').click(function(e){
    e.preventDefault();
    var eventId = $('#event_id').val();

    $.ajax({
      url: '/events/' + eventId + '/enrollments',
      type: 'post',
      dataType : "json",
      beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      success: function(res){
        console.log(res);
      }
    })

  })

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
