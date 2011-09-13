jQuery ->
  $('.clear_default').click ->
    $(this).val ''
    $(this).removeClass 'not_cleared'

  $('.close_panel_link').click ->
    $(this).parents('.panel').slideUp()

  $('#pagination').pageless(totalPages: 3, url: '/home/more_items', loaderImage: '../assets/pageless/loading.gif')

#  $("#featured").tabs( fx: opacity: "toggle").tabs("rotate", 5000, true)