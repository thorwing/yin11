function link_product()
{
    var count = $('#images_container .product').size();
    if (count >= products_limit) {
        alert("最多只能添加3件商品");
        return;
    }

    jQuery.facebox($('#product_linker').html());
};

function pre_link_product(link)
{
    $(link).nextAll("#link_spinner").show();
    return true;
};

function link_recipe()
{
    var count = $('#images_container .recipe').size();
    if (count >= recipes_limit) {
        alert("最多只能添加3份菜谱");
        return;
    }

    jQuery.facebox($('#recipe_linker').html());
};


$(function(){
    $('#submit_review').click(function(e){
        var text = $('#review_content').val();
        if(text == null || text.trim() == '')
        {
            e.preventDefault();
            alert("写点什么吧");
        }
    });
});


function pick_recipe(link, id, name, image_url) {
    $(document).trigger('close.facebox');

    if(document.getElementById("recipe_" + id)) {
      alert("已添加了该菜谱");
    }
    else {
        var new_recipe = '<div class="recipe fl mr5"><div class="hint_box">'
            + '<a href="/recipes/' + id + '">'
            + '<img class="thumbnail" src="' + image_url + '" alt="thumbnail"></a>'
            + '<span class="fix_hint b_black white f11">' + name + '</span></div>'
            + '<a onclick="delete_related_item(this); return false;" class="del_link lighter_touch" href="#"><img border="0" src="/assets/close_x.png" alt="delete_recipe"></a>'
            + '<input type="hidden" value="' + id + '" name="review[recipe_ids][]" id="recipe_' + id + '"/>'
            + '</div>';

        $('#images_container').append(new_recipe);
    }
};

//
////Delete image
//function delete_image(link) {
////    var image_id = $(link).data('image_id');
////
////    $.ajax({
////        url: "/images/" + image_id,
////        type: "DELETE",
////        processData: false,
////        contentType: false,
////        success: function (res) {
////            $(link).parent().remove();
////        }
////    });
//    $(link).parent().remove();
//}
//
////Delete product
//function delete_product(link) {
////    var product_id = $(link).data('product_id');
////    $('#product_' + product_id).remove();
//    $(link).parent().remove();
//}

//Delete product, recipe or image
function delete_related_item(link) {
    $(link).parent().remove();
}