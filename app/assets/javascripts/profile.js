//function auto_load()
$(function(){
   var the_tabs = $('.profile_mytab .tabContainer .tab'); // the current selected tab
   the_tabs.click(function(e)
   {
        /* "this" points to the clicked tab hyperlink: */
        var element = $(this);
//        alert(element.data('page'));
        $(".profile_mytab .tabContent .display").addClass("display_none");
        $(".profile_mytab .tabContent .display").removeClass("display");
        tmp =  $(".profile_mytab .tabContent");
//       alert( tmp.find(element.data('page')))

        tmp.find(element.data('page')).removeClass("display_none");
        tmp.find(element.data('page')).addClass("display");
//                 $(".profile_mytab #tabContent .basic_info").addClass("display_none");
//          $(".profile_mytab #tabContent .my_groups").removeClass("display_none");
        e.preventDefault();
   });

});

$(function(){     //change the background of the tabs when
     $(".profile_mytab .tabContainer > div").click(function(e){
          $(".profile_mytab .tabContainer .selected").addClass("unselected");
          $(".profile_mytab .tabContainer .selected").removeClass("selected");
//          display the selected
          $(this).removeClass("unselected");
          $(this).addClass("selected");
          e.preventDefault();
     })
})

