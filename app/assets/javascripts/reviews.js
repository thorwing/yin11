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

function listen_recipe_name() {
    var bind_name = '';
    if (navigator.userAgent.indexOf("MSIE") != -1) { bind_name = 'propertychange'; }
    else { bind_name = 'input'; }

    $('div.popup #recipe_name').bind(bind_name, function(e) {
        $(this).nextAll('#link_spinner').show();
        $(this).nextAll("div").html('');

        var name = $(this).val();
        $.ajax({
            url: "/recipes/browse",
            data: {name: name}
        });
    });
};

function link_recipe()
{
    var count = $('#images_container .recipe').size();
    if (count >= recipes_limit) {
        alert("最多只能添加3份菜谱");
        return;
    }

    jQuery.facebox($('#recipe_linker').html());
    listen_recipe_name();
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

$(function(){
    var bind_name = '';
    if (navigator.userAgent.indexOf("MSIE") != -1) { bind_name = 'propertychange'; }
    else { bind_name = 'input'; }

    $('#recipe_linker #recipe_name').bind(bind_name, function(e) {
        $(this).nextAll('#link_spinner').show();
        $(this).nextAll("div").html('');

        var name = $(this).val();
        $.ajax({
            url: "/recipes/browse",
            data: {name: name}
        });
    });
});