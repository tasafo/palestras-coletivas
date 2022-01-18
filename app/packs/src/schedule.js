$(function() {
    $("#attach_talk").on("click", function(e) {
        if ($("#attach_talk").is(":checked")) {
            $("#search_result").show();
            $("#search_talks").show();
            $("#search_text").focus();
        } else {
            $("#schedule_talk_id").val("");
            $("#talk_title").text("");
            $("#div_talk").hide();
            $("#search_talks").hide();
            $("#search_result").hide();
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

    $('#edit_schedule_' + $('#schedule_schedule_id').val()).submit(function() {
        if ($("#search_talks").is(":visible")) {
            if ($("#schedule_talk_id").val() == "") {
                alert($("#alert_enter_talks").val());
                $("#search_text").focus();
                return false;
            }
        }
    });
});

function search_talk() {
    var search_text = $("#search_text").val();
    var titles_talks_select = $("#titles_talks_select").val();
    var talks = "";

    if (search_text.length > 0) {
        $.ajax({
            url : "/talk_search",
            data : {
                search : search_text
            },
            async : true,
            type : "post",
            beforeSend: function(xhr) {
                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            dataType : "json",
            success : function(result) {
                for (var i = 0; i < result.meta.total; i++) {
                    var record = result.data[i].attributes;
                    var thumb;

                    if (record.thumbnail) {
                        thumb = '<img src="' + record.thumbnail + '" class="img-thumbnail" />';
                    } else {
                        thumb = '<div class="img-thumbnail thumb-talk"></div>';
                    }

                    talks += '<hr />';
                    talks += '<div id="div_' + record.id['$oid'] + '" class="talk">';
                    talks += '  <div class="container">';
                    talks += '    <div class="row">';
                    talks += '      <div class="col-md-2 text-center">';
                    talks += '        ' + thumb;
                    talks += '        <input type="button" id="' + record.id['$oid'] + '" title="' + record.title + '" class="btn btn-success btn-select-talk" value="' + titles_talks_select + '" />';
                    talks += '      </div>';
                    talks += '      <div class="col-md-10">';
                    talks += '        <h4><a href="/talks/' + record.slug + '" target="_blank">' + record.title +'</a></h4>';
                    talks += '        <p>' + record.description + '</p>';
                    talks += '        <p><b>Tags:</b> ' + record.tags + '</p>';
                    talks += '      </div>';
                    talks += '    </div>';
                    talks += '  </div>';
                    talks += '</div>';
                }

                $("#search_result").html(talks);

                $(".btn-select-talk").click(function() {
                    var talk_id = $(this).attr("id");
                    var talk_title = $(this).attr("title");

                    $(".talk").each(function(index) {
                        $(this).css("background-color", "white");
                    });

                    $("#div_" + talk_id).css("background-color", "#8ce6b8");

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
