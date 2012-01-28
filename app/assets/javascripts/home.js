//Slider
//function pageLoaded(event, data) {
//    $("#home_slider #silder_tabs .navigator.selected").removeClass('selected');
//    $("#home_slider #silder_tabs #navigator_" + data.page).addClass('selected');
//}
//
//jQuery(function($) {
//      $( "#home_slider #carousel" ).rcarousel({
//          auto: {enabled: true,
//          direction:"next",
//          interval:5000},
////          start: generatePages,
//          pageLoaded: pageLoaded,
//          step: 1,
//          speed: 700,
//          visible: 1,
//          width: 450,
//          height: 200
//      });
//
//  });

//$(function() {
//    $("#home_slider #silder_tabs .navigator").hover(
//        function(){
//            pos = $(this).data('page');
//            $("#home_slider #silder_tabs .navigator.selected").removeClass('selected');
//            $(this).addClass('selected');
//
//            $( "#home_header #carousel").rcarousel( "goToPage", parseInt(pos) );
//        },
//        function(){});
//});


$(function(){
    $('#primary_tags').liteAccordion({
        containerWidth : 920,                   // fixed (px)
        containerHeight : 170,                  // fixed (px)
        headerWidth: 40,                        // fixed (px)

        activateOn : 'mouseover',               // click or mouseover
        firstSlide : 1,                         // displays slide (n) on page load
        slideSpeed : 800,                       // slide animation speed
        easing : 'swing',                       // custom easing function

        theme : 'stitch',                        // basic, dark, light, or stitch
        rounded : false,                        // square or rounded corners
        enumerateSlides : false,                // put numbers on slides
        linkable : false                        // link slides via hash
    });

    $(".primary_tag").hover(
        function(){
            $(this).find(".tag_summary").show();
        },
        function(){
            $(this).find(".tag_summary").hide();
        }
    );
});