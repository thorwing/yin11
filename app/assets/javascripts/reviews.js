function link_product()
{
    jQuery.facebox($('#product_linker').html());
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