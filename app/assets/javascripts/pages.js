$(function(){
    $(".box").hover(
        function(){
            $(this).find(".hint").css("display", "block")
        },
        function(){
            $(this).find(".hint").slideUp('fast');
        }
    );
});