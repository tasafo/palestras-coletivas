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
    titles_talks_select = $("#titles_talks_select").val();

    talks = "";

    if (search_text.length > 0) {
        $.getJSON('/schedules/search-talks/' + search_text, function(json) {
            if (json) {
                for (var i in json) {
                    talks += '<hr class="featurette-divider>';

                    talks += '<div id="div_' + json[i]._id + '" class="featurette">';

                    thumb = json[i].thumbnail ? json[i].thumbnail : '/assets/without_presentation.jpg';

                    talks += '<img src="' + thumb + '" class="featurette-image pull-left img-polaroid" />';

                    talks += '<h3 class="featurette-heading"><a href="/talks/' + json[i]._slugs[0] + '" target="_blank">' + json[i].title +'</a></h3>';

                    talks += '<p class="lead">';

                    talks += json[i].description + '<br/>';

                    talks += json[i].tags + '<br/><br/>';

                    talks += '<input type="button" id="' + json[i]._id + '" title="' + json[i].title + '" class="btn btn-success btn-select-talk" value="' + titles_talks_select + '" />';

                    talks += '</div>';
                }

                $("#search_result").html(talks);

                $(".btn-select-talk").click(function() {
                    talk_id = $(this).attr("id");
                    talk_title = $(this).attr("title");
                    
                    $(".featurette").each(function(index) {
                        $(this).css("background-color", "white");
                    });

                    $("#div_" + talk_id).css("background-color", "#CCFF99");
                    
                    $("#schedule_talk_id").val(talk_id);
                    $("#talk_title").text(talk_title);
                    $("#div_talk").show();
                });
            }
        });
    } else {
        $("#search_result").html(talks);
    }
}