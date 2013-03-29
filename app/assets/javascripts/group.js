$(function() {
    $("#searching_group").hide();
    $("#group_not_found").hide();

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