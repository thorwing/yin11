//When Dom is ready:
$(document).ready(function(){
    $('#s3slider').s3Slider({
        timeOut: 4000
    });

    $('#pagination').pageless({ totalPages: 3
       , url: '/home/more_items'
       , loaderImage: "/images/pageless/load.gif"
    });

    $('.tip').each( function(intIndex) {
        $(this).CreateBubblePopup({ innerHtml: $(this).data('content') });
    });
    //$('.tip')

    $('.clear_default').click(function(){
        $(this).val('');
        $(this).removeClass('not_cleared');
    });

    $('.close_panel_link').click(function() {
        $(this).parents('.panel').slideUp();
    });
});