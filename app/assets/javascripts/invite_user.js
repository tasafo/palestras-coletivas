$(function() {
    $("#add_user").click(add_user);

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
        $('#table_users > tbody:last').append(
            "<tr id=\"row_" + userId + "\"><td>" + userDisplay + "<input type=\"hidden\" name=\"users[]\" value=\"" + userId + "\" /></td><td><center><input type=\"button\" class=\"btn btn-danger\" id=\"remove_user_id_" + userId + "\" onclick=\"remove_user(\'" + userId + "\')\" value=\"" + $("#remove").text() + "\" /></center></td></tr>"
        );
    }
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
    var valid = false,
        users = $("#invitee_username").data("invitees");
    for (i = 0, x = users.length; i < x; i++) {
        if (users[i].value === userId) {
            valid = true;
        }
    }
    if (!valid) { alert($("#user_invalid").text()); }
    return valid;
};
