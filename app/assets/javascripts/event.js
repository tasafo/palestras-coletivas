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
    issueCertificatesParticipants('attendees');
  });

  $("#issue_certificates_all_participants").on("click", function(e) {
    e.preventDefault();
    issueCertificatesParticipants('all');
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

  var records = null;

  $('#issuing_certificates').show();

  $.ajax({
    url: '/event_certificates/' + event_id + '/speakers',
    type: 'get',
    dataType: 'json',
    success: function(result) {
      records = 'code=PC' + event_id + '&profile=2';
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
    }
  });

  console.log(records);

  if (records != null) {
    $.ajax({
      url: certifico_url,
      type: 'post',
      dataType: 'text',
      data: records,
      statusCode: {
        200: function() {
          alert('> Certificados enviados com sucesso!');
        },
        404: function() {
          alert('página não encontrada');
        }
      },
      success: function(response) {
        alert('>> Certificados enviados com sucesso!');
      }
    });

    $('#issuing_certificates').hide();

    alert('Certificados enviados com sucesso!');
  }
}

var issueCertificatesOrganizers = function() {
  if (!confirmsSending('organizadores'))
    return false;

  records = 'code=PC' + event_id + '&profile=1';

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

      $.ajax({
        url: certifico_url,
        type: 'post',
        data: records,
        success: function(response) {
        }
      });

      $('#issuing_certificates').hide();

      alert('Certificados enviados com sucesso!');
    }
  });
}

var issueCertificatesParticipants = function(kind, user_id = 0) {
  if (!confirmsSending('participantes'))
    return false;

  records = 'code=PC' + event_id + '&profile=3';

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

      $.ajax({
        url: certifico_url,
        type: 'post',
        data: records,
        success: function(response) {

        }
      });

      $('#issuing_certificates').hide();

      alert('Certificados enviados com sucesso!');
    }
  });
}

var confirmsSending = function(profile) {
  return confirm('Você confirma a geração dos certificados para os ' + profile + '?');
}
