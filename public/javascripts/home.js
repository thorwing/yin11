//When Dom is ready:
$(document).ready(function(){
    $('#s3slider').s3Slider({
        timeOut: 4000
    });

    $('#reviews_page').pageless({ totalPages: 3
       , url: '/home/reviews'
       , loaderImage: "/images/pageless/load.gif"
    });
});