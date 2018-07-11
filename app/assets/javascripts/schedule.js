$(function() {
    var activity_id = $("#schedule_activity_id").val();
    var activityType  = $(this).find(':selected').data('activity-type');
    var dialog = new mdc.dialog.MDCDialog(document.querySelector('#mdc-dialog-with-list'));
    var dynamicTabBar = window.dynamicTabBar = new mdc.tabs.MDCTabBar(document.querySelector('#dynamic-tab-bar'));
    var dots = document.querySelector('.dots');
    var panels = document.querySelector('.panels');

    $("#schedule_activity_id").change(function() {
        if (activityType === 'talk'){
          $("#container-search-talks").show()
        }
        else{
          $("#container-search-talks").hide()
          $('#schedule_talk_id').val( "" )
          $("#container-selected-talk").html("")
        }
    });

    $("#search_talk").on('keyup', search_talk);

    $("#result-talks-search").on('click', 'li', function(){
      var $el = $(this);

      $("#container-selected-talk").html($el.html());
      $('#schedule_talk_id').val( $el.data('talk-id') )
    });

    $("#schedule_activity_id").trigger("change");

    var snackbar = new mdc.snackbar.MDCSnackbar(document.querySelector('.mdc-snackbar'));

    const dataObj = {
      message: 'É necessário selecionar uma palestra'
    };

    $('#btn-save-schedule').on('click', function(e){
      e.preventDefault();
      if ( $('#schedule_talk_id').val() === ''  && activityType  === 'talk' ){
        snackbar.show(dataObj);
        return;
      }
      $('#form-schedule').submit();
    });

    // dialog.show();

    document.getElementById('btn-new-schedule').addEventListener('click', function(){
      dialog.show();
    });

    $('.btn-close-dialog').click(function(){
      dialog.close();
    })

    dynamicTabBar.tabs.forEach(function(tab) {
      tab.preventDefaultOnClick = true;
    });

    function updateDot(index) {
      var activeDot = dots.querySelector('.dot.active');
      if (activeDot) {
        activeDot.classList.remove('active');
      }
      var newActiveDot = dots.querySelector('.dot:nth-child(' + (index + 1) + ')');
      if (newActiveDot) {
        newActiveDot.classList.add('active');
      }
    }

    function updatePanel(index) {
      var activePanel = panels.querySelector('.panel.active');
      if (activePanel) {
        activePanel.classList.remove('active');
      }
      var newActivePanel = panels.querySelector('.panel:nth-child(' + (index + 1) + ')');
      if (newActivePanel) {
        newActivePanel.classList.add('active');
      }
    }

    dynamicTabBar.listen('MDCTabBar:change', function ({detail: tabs}) {
      var nthChildIndex = tabs.activeTabIndex;

      updateDay(nthChildIndex);
      updatePanel(nthChildIndex);
      updateDot(nthChildIndex);
    });

    dots.addEventListener('click', function (evt) {
      if (!evt.target.classList.contains('dot')) {
        return;
      }

      evt.preventDefault();

      var dotIndex = [].slice.call(dots.querySelectorAll('.dot')).indexOf(evt.target);

      console.log(dotIndex);

      if (dotIndex >= 0) {
        dynamicTabBar.activeTabIndex = dotIndex;
      }

      updatePanel(dotIndex);
      updateDot(dotIndex);
    })
});

function updateDay(index){
  var day = index +  1;
  $('#schedule_day').val(day);
}

function search_talk() {
    search_text = $("#search_talk").val();

    talks = "";

    if (search_text.length > 3) {
        $.ajax({
            url : "/talk_search",
            data : {
                search : search_text
            },
            async : true,
            type : "post",
            beforeSend: function(xhr) {
                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            dataType : "json",
            success : function(json) {
                for (var i in json) {
                    thumb = json[i].thumbnail ? json[i].thumbnail : '/without_presentation.jpg';

                    talks += '<li class="mdc-list-item" data-talk-id="' + json[i]._id['$oid'] + '">';
                    talks += '<span class="mdc-list-item__graphic"><img src="' + thumb + '" width="80", height="50" /></span>';
                    talks += '<span class="mdc-list-item__text">'+ json[i].title +'</span>';
                    talks += '</li>';
                }

                $("#result-talks-search").html(talks);
            }
        });

    } else {
        $("#result-talks-search").html(talks);
    }
}
