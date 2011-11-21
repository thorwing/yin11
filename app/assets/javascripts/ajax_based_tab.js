//function auto_load()
$(function(){
    var element = $(this);
    var Tabs =
    {
        'All Feeds'   : '/personal/all_feeds',
        'My Feeds'   : '/personal/my_feeds'
    }

     var colors = ['blue','green'];
     var topLineColor =
     {
        blue:'lightblue',
        green:'lightgreen'
     }

     var z=0;
//     $.each(Tabs,function(i,j){
//            /* Sequentially creating the tabs and assigning a color from the array: */
//            var tmp = $('<li><a href="#" class="tab '+colors[(z++%4)]+'">'+i+' <span class="left" /><span class="right" /></a></li>');
//            /* Setting the page data for each hyperlink: */
//            tmp.find('a').data('page',j);
//            /* Adding the tab to the UL container: */
//            $('ul.tabContainer').append(tmp);
//     })


     var the_tabs = $('.tab');

	 the_tabs.click(function(e){
	        /* "this" points to the clicked tab hyperlink: */
	        var element = $(this);
            if(!element.data('cache'))
	        {
	            /* If no cache is present, show the gif preloader and run an AJAX request: */
                $('#contentHolder').html('<img src="assets/loading.gif" width="64" height="64" class="preloader" />');
	           $.get(element.data('page'),function(msg){
	                $('#contentHolder').html(msg);

	               /* After page was received, add it to the cache for the current hyperlink: */
	                element.data('cache',msg);
	            });
	        }
	        else $('#contentHolder').html(element.data('cache'));

	        e.preventDefault();

     });
     the_tabs.eq(0).click();

});