//create a step
$(function() {
//    $('#new_recipe .steps').next('.add_fields').click();
    var i;
    for ( i =0;i<3 ;i++)
    {
//        $('#new_recipe .steps').parent().find('.add_fields').click();
        $('#new_recipe .steps').next('.add_fields').click();
    }
    $('#new_recipe .ingredients').next('.add_fields').click();
});
