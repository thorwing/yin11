//function auto_load()
$(function(){
   var the_tabs = $('.mytab .tabContainer .tab'); // the current selected tab
   the_tabs.click(function(e)
   {

        /* "this" points to the clicked tab hyperlink: */
        var element = $(this);
//        alert(element.data('page'));
        if(!element.data('cache'))
        {

            /* If no cache is present, show the gif preloader and run an AJAX request: */
            $('#contentHolder').html('<img src="assets/loading_big.gif" width="64" height="64" class="preloader" />');
            $.get(element.data('page'),function(msg){
                $('#contentHolder').html(msg);
                /* After page was received, add it to the cache for the current hyperlink: */
                element.data('cache',msg);
//                $('a[rel*=lightbox]').slimbox();   must be in the callback function, because
                $('a[rel*=lightbox]').slimbox();
            });
//            $('a[rel*=lightbox]').slimbox();  this is wrong, because it is outside the call back function, and may be executed  before the call back function
        }
        else
        {
            $('#contentHolder').html(element.data('cache'));
            $('a[rel*=lightbox]').slimbox();

        }
        e.preventDefault();
   });

   the_tabs.eq(0).click();
});

$(function(){     //change the background of the tabs when
     $(".mytab .tabContainer > div").click(function(e){
          $(".tabContainer .selected").addClass("unselected");
          $(".tabContainer .selected").removeClass("selected");

          $(this).removeClass("unselected");
          $(this).addClass("selected");
          $(this).addClass("color: #ffffff;")
     })
})

