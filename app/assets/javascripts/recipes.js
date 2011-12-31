$(function(){
    $('.mark_recipe').click(function(e){
        e.preventDefault();

        var behavior = $(this).data("behavior");
        $('#review_linker #behavior').val(behavior);
        var msg = $(this).data("msg");
        $('#review_linker #content').text(msg);
        jQuery.facebox($('#review_linker').html());

        char_aware();
    });
});


function consistency_check(range)
{
//    alert(range);
    var result = -1;
    var addedclasses = $(range).find('.addedclass');
    addedclasses.each(function(index, addedclass){
        var amount = String($(addedclass).find('.ingredient_amount').val());
        var name = String($(addedclass).find('.ingredient_name').val());

        if(amount != "" && name == "")
        {
//             alert("return is " + (index+1));
             result = index + 1;
        }
    });
    return result;
}

$(function(){
//    check if all the necessory info is given
    $('#recipe_submit').click(function(e){
        var verify_passed = false;
        var has_recipe_name = false;
        var has_one_ingredient = false;
        var has_one_step = false;
        var has_one_image =false;
        var has_one_content =false;
        var warning = false;
        var message = "您忘了添加:\n";
//   check if all the neccessary info are given

//        1 recipe name should be given
        if(String($('#recipe_name').val()) != ""){
            has_recipe_name = true;
        }
        else{
            message += '     - 菜谱名\n';
        }

//          user may forget to give ingredient name but not amount
        var pos = 0;

        var ranges = new Array(".minor_ingredients", ".major_ingredients");
        var displays = new Array("主料", "辅料")
        for (var i = 0; i < ranges.length; i++)
        {
            pos = consistency_check(ranges[i]);
            if(pos !=  -1)
            {
                 warning = true;
                 message += "     -您忘记填写第" + pos + "个"+ displays[i] +"的名称了\n";
            }
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

        if(has_one_step == true && has_one_ingredient == true && has_recipe_name == true && warning == false)
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
});
