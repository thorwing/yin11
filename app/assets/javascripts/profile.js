//function auto_load()
$(function(){
   var the_tabs = $('.statictab .tabContainer .tab'); // the current selected tab
   the_tabs.click(function(e)
   {
        /* "this" points to the clicked tab hyperlink: */

        e.preventDefault();
   });

});

$(function(){     //change the background of the tabs when
     $(".statictab .tabContainer > div").click(function(e){
          $(".statictab .tabContainer .selected").addClass("unselected");
          $(".statictab .tabContainer .selected").removeClass("selected");
//          display the selected
          $(this).removeClass("unselected");
          $(this).addClass("selected");
//          e.preventDefault();

          var element = $(this).find('.tab');
        $(".statictab .tabContent .display").addClass("display_none");
        $(".statictab .tabContent .display").removeClass("display");
        tmp =  $(".statictab .tabContent");
        tmp.find(element.data('page')).removeClass("display_none");
        tmp.find(element.data('page')).addClass("display");
     })
})

