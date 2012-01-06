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
