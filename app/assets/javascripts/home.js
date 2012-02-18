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


//$(function(){
//    $('#primary_tags').liteAccordion({
//        containerWidth : 920,                   // fixed (px)
//        containerHeight : 170,                  // fixed (px)
//        headerWidth: 40,                        // fixed (px)
//
//        activateOn : 'mouseover',               // click or mouseover
//        firstSlide : 1,                         // displays slide (n) on page load
//        slideSpeed : 800,                       // slide animation speed
//        easing : 'swing',                       // custom easing function
//
//        theme : 'stitch',                        // basic, dark, light, or stitch
//        rounded : false,                        // square or rounded corners
//        enumerateSlides : false,                // put numbers on slides
//        linkable : false                        // link slides via hash
//    });
//
//    $(".primary_tag").hover(
//        function(){
//            $(this).find(".tag_summary").show();
//        },
//        function(){
//            $(this).find(".tag_summary").hide();
//        }
//    );
//});


//function shift_masonry(filter) {
//    $('#filters .filter_tab.selected').removeClass('selected');
//    $(filter).parents(".filter_tab").addClass('selected');
//    $('#filters .filter_tab .small_bar').width(0);
////
//    var small_bar = $(filter).parents(".filter_tab").find(".small_bar");
//    small_bar.animate ({
//        width: '100%'
//    }, 300, function(){
//    // TODO  make sure if a new tab selected during the duration, the old one is cleared
//
//    });

//    var $container = $('#masonry_container');
//    var selector = $(filter).attr('data-filter');
//    $container.isotope({filter: selector});
//    return false;
//}

$(function(){
//    var $container = $('#masonry_container');
//    $('#filters .filter').click(function(e){
//        e.preventDefault();
//        shift_masonry(this);
//    });

    if($('#filters').length > 0) {
        $('#filters .filter').hover(
            function(e){
                $('#filters .filter_tab.hovered').removeClass('hovered');
                $(this).parents(".filter_tab").addClass('hovered');
                $('#filters .filter_tab:not(.hovered) .small_bar').width(0);
                var small_bar = $(this).parents(".filter_tab").find(".small_bar");

                small_bar.animate ({
                    width: '100%'
                }, 500, function(){
                    $('#filters .filter_tab:not(.hovered) .small_bar').width(0);
                });
            },
            function(){}
        );

        $('#filters').hover(
            function(){},
            function(e){
                $('#filters .filter_tab:not(.selected)').removeClass('hovered');
                $('#filters .filter_tab:not(.selected) .small_bar').width(0);
                $('#filters .filter_tab.selected').addClass('hovered');
                $('#filters .filter_tab.selected .small_bar').width('100%');
            }
        );
    }
});