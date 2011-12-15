$(function(){
   $('.tab_control .tab').click(function(e)
   {
        e.preventDefault();
   });
   $('.tab_control .tab.selected').eq(0).click();
});

$(function(){     //change the background of the tabs when
    $(".tab_control .tabContainer > div").click(function(e){
        $(".tab_control .selected").addClass("unselected");
        $(".tab_control .selected").removeClass("selected");

        $(this).removeClass("unselected");
        $(this).addClass("selected");

        var tab_control = $(this).parents(".tab_control");
        if(tab_control.hasClass("dynamic")) {
            var element = $(this).find('.tab');
            /* "this" points to the clicked tab hyperlink: */
            if(!element.data('cache'))
            {
                /* If no cache is present, show the gif preloader and run an AJAX request: */
                $('#contentHolder').html('<img src="assets/loading_big.gif" width="64" height="64" class="preloader" />');
                $.get(element.data('page'),function(msg)
                {
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
        }
        else {
            var element = $(this).find('.tab');

            $(tab_control).find(".tabContent .display").addClass("display_none");
            $(tab_control).find(".tabContent .display").removeClass("display");
            tmp =  $(tab_control).find(".tabContent");
            tmp.find(element.data('page')).removeClass("display_none");
            tmp.find(element.data('page')).addClass("display");
        }
    })
})

