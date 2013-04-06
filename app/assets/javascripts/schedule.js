$(function() {
    $("#schedule_activity_id").change(function() {
        activity_id = $("#schedule_activity_id").val();
        activity_desc = $("#schedule_activity_id").find("option:selected").text();
        
        if (activity_id) {
            $.ajax({
                url : "/activities/get-type/",
                data : {
                    id : activity_id
                },
                async : false,
                type : "post",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },
                dataType : "json",
                success : function(result) {
                    if (!result.error) {
                        if (result.type_activity == "talk") {
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

    $("#schedule_activity_id").trigger("change");
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
        dataType : "text",
        success : function(respond) {
            if (respond)
                $("#search_result").html(respond);
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