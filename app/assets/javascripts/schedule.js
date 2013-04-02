$(function() {
    $("#schedule_session_id").change(function() {
        session_id = $("#schedule_session_id").val();
        session_desc = $("#schedule_session_id").find("option:selected").text();
        
        if (session_id) {
            $.ajax({
                url : "/sessions/get-type/",
                data : {
                    id : session_id
                },
                async : false,
                type : "post",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },
                dataType : "json",
                success : function(result) {
                    if (!result.error) {
                        if (result.session_type == "talk") {
                            $("#search_talks").show();
                            $("#search_text").focus();
                        } else {
                            $("#schedule_talk_id").val("");
                            $("#talk_title").text("");
                            $("#div_talk").hide();
                            $("#search_talks").hide();
                        }
                    }
                }
            });
        }
    });

    $("#search_button").click(function() {
        search_talk();
    });

    $("#search_text").keypress(function(event) {
        if (event.which == 13) {
            search_talk();
            return false;
        }
    });

    $("#schedule_session_id").trigger("change");
    $("#schedule_date").focus();
});

function search_talk() {
    search_text = $("#search_text").val();

    $.ajax({
        url : "/schedules/search-talks/",
        data : {
            search : search_text
        },
        async : false,
        type : "post",
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        dataType : "json",
        success : function(respond) {
            if (respond)
                $("#search_result").html(respond.result);
            else
                $("#search_result").html("");
        }
    });
}

function select_talk(talk_id, talk_title) {
    $(".featurette").each(function(index) {
        $(this).css("background-color", "white");
    });

    $("#div_" + talk_id).css("background-color", "#CCFF99");
    
    $("#schedule_talk_id").val(talk_id);
    $("#talk_title").text(talk_title);
    $("#div_talk").show();
}