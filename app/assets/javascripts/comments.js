//Add comment
$(function() {
    $('.reply_comment_link').live('click', function() {

        $(this).siblings('.new_reply_comment').toggle('fast');
        return false;
    });
});

function show_embedded_comments(link) {
    var embedded_comments = $(link).parents(".commentable").find(".embedded_comments")
    $(embedded_comments).toggle('fast', function(){
        if ($(this).css('display') == "block")
        {
            $(link).text("-收起");
        }
        else {
            $(link).text("+评论");
        }
    });
}

$(function() {
    $('.btn_submit_comment').live('click', function(e) {
        var text = $(this).parents("form").find("#content").val().replace(/(^\s*)|(\s*$)/g, "");
        if(text == "" || text == "说点什么吧...")
        {
            alert("说点什么吧");
            e.preventDefault();
        }
    });
});

function shift_comments_group(link, delta) {
    var index_counter = $(".current_comments_group_index");
    var current_index = parseInt(index_counter.data('current_index'));
    var max_index = parseInt(index_counter.data('max_index'));

    var new_index = current_index + delta;
    new_index = (new_index < max_index) ? new_index : 0;
    new_index = (new_index >= 0) ? new_index : (max_index - 1)

    $(".comments_group.display_block").addClass("display_none");
    $(".comments_group.display_block").removeClass("display_block");

    $(".comments_group." + new_index).addClass("display_block");
    $(".comments_group." + new_index).removeClass("display_none");
    index_counter.text(new_index + 1);
    index_counter.data('current_index', new_index);
}
