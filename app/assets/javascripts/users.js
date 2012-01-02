function show_more_info(container) {
    var infos = $(container).find('.more_info');
    infos.show();

    var current_user_id = $('#current_user_id');
        if(current_user_id.length > 0) {
            // 用户不可以关注自己
            var selector = '.follow_field.' + current_user_id.val();
            $(selector).remove();
    }
}

function hide_more_info(container) {
    var infos = $(container).find('.more_info');
    infos.hide();
}