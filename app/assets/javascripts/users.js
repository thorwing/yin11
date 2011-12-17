$(function(){
    $('.star').hover(function(){
        $(this).find('.attent').removeClass('none');
    },
    function(){
        $(this).find('.attent').addClass('none');
    });
});

function show_user_info(link) {
    var infos = $(link).parents(".waterfall").find('.more_user_info');
    if(infos.css('display') == "none") {
        infos.show();
    }
}

function hide_user_info(link) {
    $(link).nextAll('.more_user_info').hide();
}