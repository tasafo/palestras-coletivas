require('jquery-ui/themes/base/core.css');
require('jquery-ui/themes/base/menu.css');
require('jquery-ui/themes/base/autocomplete.css');
require('jquery-ui/themes/base/theme.css');
var autocomplete = require('jquery-ui/ui/widgets/autocomplete');

$(function() {
    $("#add_user").click(add_user);

    $(".btn-remove-user").on("click", function(e) {
      e.preventDefault();
      remove_user($(this).attr("user-id"));
    });

    $("#invitee_username").autocomplete({
        minLength: 3,
        select: function( event, ui ) {
            $("#invitee_username").val( ui.item.label );
            $("#user_id").val( ui.item.value );
            return false;
        },
        change: function( event, ui ) {
            if (!ui.item) { $("#user_id").val(""); }
            return false;
        },
        focus: function( event, ui ) {
            $("#invitee_username").val( ui.item.label );
            return false;
        },
        source: $("#invitee_username").data("invitees")
    }).keypress(function(e) {
        if (e.which == 13) { // enter
            e.preventDefault();
            add_user();
        }
    });
});

function add_user() {
    var userId       = $("#user_id").val();
    var userDisplay  = $("#invitee_username").val();

    if (canInvite(userDisplay, userId)) {
        var tableRow = "<tr id=\"row_" + userId + "\">";
        tableRow += "<td>" + userDisplay + "<input type=\"hidden\" name=\"users[]\" value=\"" + userId + "\" /></td>";
        tableRow += "<td><button type=\"button\" class=\"btn btn-danger btn-remove-user\" id=\"remove_user_id_" + userId + "\" ";
        tableRow += "user-id=\"" + userId + "\" onclick=\"$(\'#row_" + userId + "').remove();\">" + $("#remove").text() + "</button></td></tr>";

        $('#table_users > tbody:last').append(tableRow);
    }

    $("#user_id").val('');
    $("#invitee_username").val('');
    $("#invitee_username").focus();
}

function remove_user(id) {
    $("#row_" + id).remove();
}

function canInvite(userDisplay, userId) {
    return userDisplay != "" && !inviteePresent(userId) && validInvitee(userId);
}

function inviteePresent(userId) {
    var present = false;
    if ( $('#table_users tbody tr#row_' + userId).length > 0 ) {
        alert($("#user_in_the_list").text());
        present = true;
    }
    return present;
}

function validInvitee(userId) {
    var valid = false;
    var users = $("#invitee_username").data("invitees");

    for (var i = 0, x = users.length; i < x; i++) {
        if (users[i].value === userId) {
            valid = true;
        }
    }

    if (!valid) { alert($("#user_invalid").text()); }

    return valid;
}
