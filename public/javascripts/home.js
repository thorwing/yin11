//When Dom is ready:
$(document).ready(function(){
    $('#s3slider').s3Slider({
        timeOut: 4000
    });

    $('#pagination').pageless({ totalPages: 3
       , url: '/home/more_items'
       , loaderImage: "/images/pageless/load.gif"
    });

    $("dl.tab").KandyTabs({
        classes: "kandyFold",
        type: "fold",
        trigger:"mouseover",
        action: "fade"
    });

    $('.tip').each( function(intIndex) {
        $(this).CreateBubblePopup({ innerHtml: $(this).data('content') });
    });
    //$('.tip')
});