$(function(){
    $(".large_topic .cube.small").hover(
        function(){
            $(this).find("p").slideDown();
        },
        function(){
            $(this).find("p").slideUp();
        }
    );
});