var certifico_url;
var event_id;

$(function() {
  certifico_url = $('#certifico_url').val();
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

  $("#event_thumbnail").keyup(function(e) {
    e.preventDefault();
    selectIcon($(this).val());
  });

  $("#event_thumbnail").click(function(e) {
    e.preventDefault();
    selectIcon($(this).val());
  });

  $(".rating.readonly").rating({required: true,readOnly: true, half: true});

  $("#issue_certificates_speakers").on("click", function(e) {
    e.preventDefault();
    issueCertificatesSpeakers();
  });

  $("#issue_certificates_organizers").on("click", function(e) {
    e.preventDefault();
    issueCertificatesOrganizers();
  });

  $("#issue_certificates_attendees").on("click", function(e) {
    e.preventDefault();
    issueCertificatesParticipants('attendees', 0);
  });

  $("#issue_certificates_all_participants").on("click", function(e) {
    e.preventDefault();
    issueCertificatesParticipants('all', 0);
  });

  $(".issue-certificate").on("click", function(e) {
    e.preventDefault();
    issueCertificatesParticipants('user', $(this).attr('user-id'));
  });
});

var selectIcon = function(icon) {
  $("#event_thumbnail_icon").html('<i class="fa fa-' + icon + ' fa-2x"></i>');
}

var addPresence = function(obj) {
  $.ajax({
    url: "/event/presence",
    data: {
      event_id: $("#event_id").val()
    },
    type: "put",
    dataType: "json",
    success: function(res) {
      $(obj).addClass("btn-info disabled");
      $(obj).text($(obj).attr("data"));
    }
  })
}

var issueCertificatesSpeakers = function() {
  if (!confirmsSending('palestrantes'))
    return false;

  var records = 'code=PC' + event_id + '&profile=2';

  $('#issuing_certificates').show();

  $.ajax({
    url: '/event_certificates/' + event_id + '/speakers',
    type: 'get',
    dataType: 'json',
    success: function(result) {
      c = 0;

      for(i = 0; i < result.length; i++) {
        user = result[i]['user'];

        for(j = 0; j < user.length; j++) {
          records += '&user['+c+'][name]=' + user[j]['name'] +
                     '&user['+c+'][email]=' + user[j]['email'] +
                     '&user['+c+'][talk]=' + user[j]['talk'];
          c++;
        }
      }

      sendToCertify(records);
    }
  });
}

var issueCertificatesOrganizers = function() {
  if (!confirmsSending('organizadores'))
    return false;

  var records = 'code=PC' + event_id + '&profile=1';

  $('#issuing_certificates').show();

  $.ajax({
    url: '/event_certificates/' + event_id + '/organizers',
    type: 'get',
    dataType: 'json',
    success: function(result) {
      for(i = 0; i < result.length; i++) {
        user = result[i];

        records += '&user['+i+'][name]=' + user['name'] +
                   '&user['+i+'][email]=' + user['email'];
      }

      sendToCertify(records);
    }
  });
}

var issueCertificatesParticipants = function(kind, user_id) {
  if (!confirmsSending('participantes'))
    return false;

  var records = 'code=PC' + event_id + '&profile=3';

  $('#issuing_certificates').show();

  $.ajax({
    url: '/event_certificates/' + event_id + '/participants/' + kind + '/' + user_id,
    type: 'get',
    dataType: 'json',
    success: function(result) {
      for(i = 0; i < result.length; i++) {
        user = result[i];

        records += '&user['+i+'][name]=' + user['name'] +
                   '&user['+i+'][email]=' + user['email'];
      }

      sendToCertify(records);
    }
  });
}

var confirmsSending = function(profile) {
  return confirm('Você confirma a geração dos certificados para os ' + profile + '?');
}

var sendToCertify = function(_records) {
  $.ajax({
    url: certifico_url,
    type: 'post',
    data: _records,
    success: function(response) {
      alert(response);
    },
    error: function (request, status, error) {
      alert(status);
    }
  });

  $('#issuing_certificates').hide();
}
