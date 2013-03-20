$(function() {
    $("#searching_talk").hide();
    $("#talk_not_found").hide();
    $("#autor_in_the_list").hide();
    $("#remove_author").hide();

    $("#add_author").click(add_author);

    $("#talk_presentation_url").focusout(function() {
        var link = $("#talk_presentation_url").val();
        
        if (link) {
            $("#searching_talk").show();

            $.ajax({
                url : "/talks/info-url/",
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
                        alert($("#talk_not_found").text());
                        $("#talk_presentation_url").val("");
                        $("#talk_presentation_url").focus();
                    } else {
                        $("#talk_not_found").hide();
                        $("#talk_title").val(result.title);
                        $("#talk_code").val(result.code);
                        $("#talk_thumbnail").val(result.thumbnail);
                    }
                }
            });

            $("#searching_talk").hide("slow");
        }
    });
});

function add_author() {
    user_id = $("#user_id").val();
    user_desc = $("#user_id").find("option:selected").text();

    if (user_desc != "") {
        found = false
        $('#table_authors tbody tr').each(function() {
        if ( $(this).attr('id') == "row_" + user_id ) {
            alert($("#autor_in_the_list").text());
            found = true;
        }
        });

        if (!found) {
            $('#table_authors > tbody:last').append(
                '<tr id="row_' + user_id + '"><td>' + user_desc + '<input type="hidden" name="authors[]" value="' + user_id + '" /></td><td><a onclick="remove_author(\'' + user_id + '\')">' + $("#remove_author").text() + '</a></td></tr>'
            );
        }
    }
}

function remove_author(id) {
    $("#row_" + id).remove();
}