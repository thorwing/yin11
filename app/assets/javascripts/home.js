jQuery(function($) {
      $( "#carousel" ).rcarousel({
          auto: {enabled: true},
//            start: generatePages,
//            pageLoaded: pageLoaded,
          step: 1,
          speed: 1000,
          visible: 1,
          width: 453,
          height: 200
      });

  });

   $(function() {
      $(".sliders").hover(function(event){
            pos = $(this).attr('id');
            $( "#carousel" ).rcarousel( "goToPage", parseInt(pos) );
            event.preventDefault();
        });
  });
