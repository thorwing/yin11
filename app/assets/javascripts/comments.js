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