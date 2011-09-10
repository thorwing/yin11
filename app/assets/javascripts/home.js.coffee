jQuery ->
  if $('#s3slider').length > 0
    $('#s3slider').s3Slider(timeOut: 4000)

  $('.clear_default').click ->
    $(this).val ''
    $(this).removeClass 'not_cleared'

  $('.close_panel_link').click ->
    $(this).parents('.panel').slideUp()

  $('#pagination').pageless(totalPages: 3, url: '/home/more_items', loaderImage: '../assets/pageless/loading.gif')