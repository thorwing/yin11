$(function(){
    $('.star').hover(function(){
        $(this).find('.attent').removeClass('none');
    },
    function(){
        $(this).find('.attent').addClass('none');
    });
});