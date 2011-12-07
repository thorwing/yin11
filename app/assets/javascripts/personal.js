//function auto_load()
$(function(){
   var the_tabs = $('.dynamictab .tabContainer .tab'); // the current selected tab
   the_tabs.click(function(event)
   {
        /* "this" points to the clicked tab hyperlink: */
        var element = $(this);
        if(!element.data('cache'))
        {
            /* If no cache is present, show the gif preloader and run an AJAX request: */
            $('#contentHolder').html('<img src="assets/loading_big.gif" width="64" height="64" class="preloader" />');
            $.get(element.data('page'),function(msg){
                $('#contentHolder').html(msg);
                /* After page was received, add it to the cache for the current hyperlink: */
                element.data('cache',msg);
                //must be in the callback function, because the content is newly loaded
                $('a[rel*=facebox]').facebox();
            });
        }
        else
        {
            $('#contentHolder').html(element.data('cache'));
            $('a[rel*=facebox]').facebox();

        }
        event.preventDefault();
   });

   the_tabs.eq(0).click();
});

$(function(){     //change the background of the tabs when
     $(".dynamictab .tabContainer > div").click(function(e){
          $(".tabContainer .selected").addClass("unselected");
          $(".tabContainer .selected").removeClass("selected");

          $(this).removeClass("unselected");
          $(this).addClass("selected");
     })
})

