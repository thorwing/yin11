$(function(){
   $('.tab_control:not(.no_work) .tab').click(function(e)
   {
        e.preventDefault();
   });
   $('.tab_control:not(.no_work) .tab.selected').eq(0).click();
});

$(function(){     //change the background of the tabs when
    $(".tab_control:not(.no_work) .tabContainer > .tab").click(function(e){
        var tab_control = $(this).parents(".tab_control");
        $(tab_control).find(".tab").removeClass("selected");
        $(this).addClass("selected");

        if(tab_control.hasClass("dynamic")) {
            /* "this" points to the clicked tab hyperlink: */
            if(!$(this).data('cache'))
            {
                /* If no cache is present, show the gif preloader and run an AJAX request: */
                $('#contentHolder').html('<img src="assets/loading_big.gif" width="64" height="64" class="preloader" />');
                $.get($(this).data('page'),function(msg)
                {
                    $('#contentHolder').html(msg);
                    /* After page was received, add it to the cache for the current hyperlink: */
                    $(this).data('cache',msg);
                    //must be in the callback function, because the content is newly loaded
                    $('a[rel*=facebox]').facebox();
                });
            }
            else
            {
                $('#contentHolder').html($(this).data('cache'));
                $('a[rel*=facebox]').facebox();
            }
        }
        else {
            $(tab_control).find(".tabContent .display").addClass("display_none");
            $(tab_control).find(".tabContent .display").removeClass("display");
            tmp =  $(tab_control).find(".tabContent");
            tmp.find($(this).data('page')).removeClass("display_none");
            tmp.find($(this).data('page')).addClass("display");
        }
    })
})

