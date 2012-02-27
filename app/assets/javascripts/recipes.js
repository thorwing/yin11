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
    $( "#sortable" ).sortable({
    			placeholder: "place_holder"
    });
    $( "#sortable" ).disableSelection();
});

//check before submit a recipe
$(function(){
    if($('#recipe_submit').length > 0) {
        //    check if all the necessory info is given
        $('#recipe_submit').click(function(e){
            var verify_passed = false;
            var has_recipe_name = false;
            var has_one_ingredient = false;
            var has_one_step = false;
            var has_one_image =false;
            var has_one_content =false;
            var message = "您忘了添加:\n";
            //   check if all the neccessary info are given

            //        1 recipe name should be given
            if(String($('#recipe_name').val()) != ""){
                has_recipe_name = true;
            }
            else{
                message += '     - 菜谱名\n';
            }

            //        1 at least one ingredient name is given
            var name_inputs = $(".ingredients").find('.ingredient_name');
            name_inputs.each(function(index, name_input){
                if(String($(name_input).val()) != ""){
                      has_one_ingredient = true;
                }
            });
            if(has_one_ingredient == false){
                message += "     - 至少一个食材\n";
            }

            //        2 at least one step is given
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

            if(has_one_content==true || has_one_image == true)
                has_one_step = true;

            if(has_one_step == true && has_one_ingredient == true && has_recipe_name == true)
                verify_passed = true;



            if(verify_passed == false){
                if(has_one_image == false ){
                    message +="建议您附上成品图"
                }
                alert(message);
            }

            //    make all the ingredients in minor part stored as Is_major_ingredient = false
            $(".minor_ingredients").find('[type=checkbox]').prop("checked", false);
            if(verify_passed == false){

                e.preventDefault();
            }
        });
    }
});


