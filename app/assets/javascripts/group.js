$(function() {
    $("#searching_group").hide();
    $("#group_not_found").hide();
    $("#member_in_the_list").hide();
    $("#remove_member").hide();

    $("#add_member").click(add_member);

    $("#group_gravatar_url").focusout(function() {
        var link = $("#group_gravatar_url").val();
        
        if (link) {
            $("#searching_group").show();

            $.ajax({
                url : "/groups/info-url/",
                data : {
                    link : link
                },
                async : false,
                type : "post",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },
                dataType : "json",
                success : function(result) {
                    if (result.error) {
                        $("#searching_group").hide();
                        $("#group_not_found").show();
                        $("#group_gravatar_url").val("");
                    } else {
                        $("#group_not_found").hide();
                        $("#group_name").val(result.name);
                        $("#group_thumbnail_url").val(result.thumbnail_url);
                    }
                }
            });

            $("#searching_group").hide("slow");
        }
    });
});

function add_member() {
    user_id = $("#user_id").val();
    user_desc = $("#user_id").find("option:selected").text();

    if (user_desc != "") {
        found = false
        $('#table_members tbody tr').each(function() {
            if ( $(this).attr('id') == "row_" + user_id ) {
                alert($("#member_in_the_list").text());
                found = true;
            }
        });

        if (!found) {
            $('#table_members > tbody:last').append(
                '<tr id="row_' + user_id + '"><td>' + user_desc + '<input type="hidden" name="members[]" value="' + user_id + '" /></td><td><a onclick="remove_member(\'' + user_id + '\')">' + $("#remove_member").text() + '</a></td></tr>'
            );
        }
    }
}

function remove_member(id) {
    $("#row_" + id).remove();
}