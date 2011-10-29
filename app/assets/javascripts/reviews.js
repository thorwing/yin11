$(function() {
    $('.add_comment_link').live('click', function() {
        $('#comments_block').toggle();
        return false;
    });
});