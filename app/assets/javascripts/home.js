function pageLoaded(event, data) {
    $("#home_slider #silder_tabs .navigator.selected").removeClass('selected');
    $("#home_slider #silder_tabs #navigator_" + data.page).addClass('selected');
}

jQuery(function($) {
      $( "#home_slider #carousel" ).rcarousel({
          auto: {enabled: true,
          direction:"next",
          interval:5000},
//          start: generatePages,
          pageLoaded: pageLoaded,
          step: 1,
          speed: 700,
          visible: 1,
          width: 450,
          height: 200
      });

  });

$(function() {
    $("#home_slider #silder_tabs .navigator").hover(
        function(){
            pos = $(this).data('page');
            $("#home_slider #silder_tabs .navigator.selected").removeClass('selected');
            $(this).addClass('selected');

            $( "#home_header #carousel").rcarousel( "goToPage", parseInt(pos) );
        },
        function(){});
});
