//$(function(){
//    $(".desire_dialog_btn").click(function(e){
//        e.preventDefault();
//        jQuery.facebox($('#desire_dialog').html());
//        char_aware();
//        general_upload();
//    });
//});

$(function(){
    $('#desire_fields #submit_desire').click(function(e){
        if($('#desire_fields #images_container').length > 0)
        {
            var count = $('#desire_fields #images_container .image').size();
            if (count < 1) {
                alert("要想馋到人，上传一张图片比较好哦");
                e.preventDefault();
            }
        }
    });
});