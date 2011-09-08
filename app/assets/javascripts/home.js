//When Dom is ready:
$(document).ready(function(){
    if($('#s3slider').length > 0) {
        $('#s3slider').s3Slider({
            timeOut: 4000
        });
    }

    $('#pagination').pageless({ totalPages: 3
       , url: '/home/more_items'
       , loaderImage: "page_loading.gif"
    });

    $('.clear_default').click(function(){
        $(this).val('');
        $(this).removeClass('not_cleared');
    });

    $('.close_panel_link').click(function() {
        $(this).parents('.panel').slideUp();
    });
});