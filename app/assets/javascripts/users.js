$(function(){
    $('.master .user_info').hover(function(){
        $(this).find('.more_user_info').removeClass('display_none');
        $(this).find('.more_user_info').removeClass('display_block');
    },
    function(){
        $(this).find('.more_user_info').addClass('display_none');
    });
});


function show_user_info(link) {
    var infos = $(link).find('.more_user_info');
    infos.show();

    var current_user_id = $('#current_user_id');
        if(current_user_id.length > 0) {
            // 用户不可以关注自己
            var selector = '.follow_field.' + current_user_id.val();
            $(selector).remove();
    }
}

function hide_user_info(link) {
    var infos = $(link).find('.more_user_info');
    infos.hide();
}