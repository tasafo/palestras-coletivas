$(function() {
    $("#talk_presentation_url").focusout(function() {
        var link = $("#talk_presentation_url").val();
        
        $.ajax({
            url : "/talks/get-info-url/",
            data : {
                link : link
            },
            async : false,
            type : "post",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            dataType : "json",
            success : function(result) {
                $("#talk_title").val(result.title);
                $("#talk_code").val(result.code);
                $("#talk_thumbnail").val(result.thumbnail);
            }
        }); 
    });
});