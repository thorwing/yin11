//Add comment
$(function() {
    $('.reply_comment_link').live('click', function() {

        $(this).siblings('.new_reply_comment').toggle('fast');
        return false;
    });
});

//Reply comment
$(function() {
    $('.add_comment_link').live('click', function() {
        $('#comments_block').toggle();
        return false;
    });
});

function show_embedded_comments(link) {
    $(link).parents(".commentable").find(".embedded_comments").toggle();
}