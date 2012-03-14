//$(function(){
//    $('.mark_recipe').click(function(e){
//        e.preventDefault();
//
//        var behavior = $(this).data("behavior");
//        $('#review_linker #behavior').val(behavior);
//        var msg = $(this).data("msg");
//        $('#review_linker #content').text(msg);
//        jQuery.facebox($('#review_linker').html());
//
//        char_aware();
//    });
//});

$(function(){
//    TODO
//    $( "#sortable" ).sortable({
//    			placeholder: "place_holder"
//    });
//    $( "#sortable" ).disableSelection();
});

//check before submit a recipe
$(function(){
    if($('#recipe_submit').length > 0) {
        //    check if all the necessory info is given
        $('#recipe_submit').click(function(e){
            var has_one_ingredient = false;
            var has_one_step = false;
            var has_final_image =false;
            var has_one_image =false;
            var has_one_content =false;
            var message = "您忘了添加:\n";
            //   check if all the neccessary info are given

            // 1 image is provided
            if($('#new_image').length > 0) {
                if($('#new_image').val()){
                    has_final_image = true;
                }
                else {
                    message += '     - 效果图\n';
                }
            }
            else {
                if($('#existed_image').length > 0) {
                    has_final_image = true;
                }
            }

            //      2 at least one ingredient name is given
            var name_inputs = $(".ingredients").find('.ingredient_name');
            name_inputs.each(function(index, name_input){
                if(String($(name_input).val()) != ""){
                      has_one_ingredient = true;
                }
            });
            if(has_one_ingredient == false){
                message += "     - 至少一个食材\n";
            }

            //        3 at least one step is given
            var contents = $(".steps").find('.step_content');
            contents.each(function(index, content){
                if(String($(content).val()) != ""){
                      has_one_content = true;
                }
            });

            var images = $(".steps").find('.img_id');
            images.each(function(index, image){
                if(String($(image).val()) != ""){
                      has_one_image = true;
                }
            });

            if(has_one_image == false && has_one_content == false){
                message += "     - 至少一个步骤\n";
            }
            else {
                has_one_step = true;
            }

            if(has_final_image && has_one_ingredient && has_one_step) {
                //    make all the ingredients in minor part stored as Is_major_ingredient = false
                $(".minor_ingredients").find('[type=checkbox]').prop("checked", false);
            }
            else {
                e.preventDefault();
                alert(message);
            }
        });
    }
});


