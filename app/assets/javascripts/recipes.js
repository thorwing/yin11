$(function(){
    $('.mark_recipe').click(function(e){
        e.preventDefault();

        var behavior = $(this).data("behavior");
        $('#review_linker #behavior').val(behavior);
        var msg = $(this).data("msg");
        $('#review_linker #content').text(msg);
        jQuery.facebox($('#review_linker').html());

        char_aware();
    });
});