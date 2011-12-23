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
}

function hide_user_info(link) {
    var infos = $(link).find('.more_user_info');
    infos.hide();
}