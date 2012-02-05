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

$(function(){

    var $container = $('#masonry_container');

    $container.imagesLoaded(function(){
      $container.masonry({
//        cornerStampSelector: '.coner_stamp',
        itemSelector: '.masonary_item',
        columnWidth: 10
      });
    });

    $container.infinitescroll({
      debug: true,
      navSelector  : '#page_nav',    // selector for the paged navigation
      nextSelector : '#page_nav a:first',  // selector for the NEXT link (to page 2)
      itemSelector : '.masonary_item',     // selector for all items you'll retrieve
      loading: {
          finishedMsg: '暂时就这么多图片啦！去看看其他的吧～',
          img: '/assets/loading_big.gif',
          msgText : '正在加载更多图片...'
        }
      },
      // trigger Masonry as a callback
      function( newElements ) {
        // hide new items while they are loading
        var $newElems = $( newElements ).css({ opacity: 0 });
        // ensure that images load before adding to masonry layout
        $newElems.imagesLoaded(function(){
          // show elems now they're ready
          $newElems.animate({ opacity: 1 });
          $container.masonry( 'appended', $newElems, true );
        });
      }
    );

});

function shift_masonry(filter) {
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
    return false;
}

$(function(){
    var $container = $('#masonry_container');
//    $('#filters .filter').click(function(e){
//        e.preventDefault();
//        shift_masonry(this);
//    });

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
});