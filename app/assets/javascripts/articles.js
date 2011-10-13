$(function(){
    var select = $('#article_type');
    if(select.length > 0) {
        toggle_source_fields($(this))

        select.change(function(){
            toggle_source_fields(select)
        });
    }
});

function toggle_source_fields(select) {
     if(select.val() != '新闻') {
        $('#article_source_fields').hide();
    }
    else{
        $('#article_source_fields').show();
    }
}
