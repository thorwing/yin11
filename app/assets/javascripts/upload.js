// Use Valums Ajax Upload
//TODO make a template for uploaded image

$(function() {
    var tokentag = $('#tokentag').val();

    var images_limit = 5;
    if($('#uploader').length > 0) {
        var uploader = new qq.FileUploader({
            // pass the dom node (ex. $(selector)[0] for jQuery users)
            element: document.getElementById('uploader'),
            // path to server-side upload script
            action: '/images',
            // validation
            allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'] ,
            // each file size limit in bytes
            // this option isn't supported in all browsers
            sizeLimit: 2097152, // max size 2MB
            minSizeLimit: 0, // min size
            // set to true to output server response to console
            debug: false,
            template: '<div class="qq-uploader">' +
                    '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' +
                    '<div class="qq-upload-button">上传图片</div>' +
                    '<ul class="qq-upload-list"></ul>' +
                 '</div>',
            fileTemplate: '<li>' +
                    '<span class="qq-upload-file"></span>' +
                    '<span class="qq-upload-spinner"></span>' +
                    '<span class="qq-upload-size"></span>' +
                    '<a class="qq-upload-cancel" href="#">取消</a>' +
                    '<span class="qq-upload-failed-text">上传失败</span>' +
                '</li>',
            params: {"authenticity_token": tokentag},
            onComplete: function(id, fileName, responseJSON){
              if (responseJSON.success) {
                var new_image = '<div class="image fl"><input id="images_" type="hidden" value="' + responseJSON.image_id + '" name="images[]"/>'
                    + '<a onclick="delete_image(this, 5); return false;" href="#" data-image_id="' + responseJSON.image_id +'"><img border="0" src="/assets/cancel.png" alt="delete_image"></a><br>'
                    + '<a class="thumbnail" rel="facebox" href="' + responseJSON.picture_url + '">'
                    + '<img width="48" height="48" border="0" src="' + responseJSON.picture_url + '" alt="image_thumbnail"></a>'
                    + '</div>'
                $('#images_container').append(new_image);
                //Apply facebox
                $('a[rel*=facebox]').facebox();
                var image_count = $('#images_container .image').size();
                if (image_count >= images_limit) { $('#image_uploaderUploader').hide(); }
              }
              else {}
            }
        });
    }
});

//Delete image
function delete_image(link, limit) {
    var image_id = $(link).data('image_id');

    $.ajax({
        url: "/images/" + image_id,
        type: "DELETE",
        processData: false,
        contentType: false,
        success: function (res) {
            $(link).parent().remove();
            var image_count = $('#images_container .image').size();
            if (image_count < limit) {
                $('#image_uploader').show();
            }
        }
    });
}
function show(url)
{
//    alert(url);
    var length = $('.step_uploader').find('.qq-upload-button').length;
    if(url==null||url=="")
    {
        url = "default_step.png";
    }
    $('.step_uploader').eq(length-1).find('.qq-upload-button').css("background-image", "url("+ url +")");

}

function step_uploader()
{
    var tokentag = $('#tokentag').val();
//    alert(tokentag);

    var images_limit = 1;
    var length = $('.step_uploader').length
    if( length > 0) {
        var uploader = new qq.FileUploader({
            // pass the dom node (ex. $(selector)[0] for jQuery users)
            element: $('.step_uploader')[length-1],
            // path to server-side upload script
            action: '/images',
            // validation
            allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'] ,
            // each file size limit in bytes
            // this option isn't supported in all browsers
            sizeLimit: 2097152, // max size 2MB
            minSizeLimit: 0, // min size
            // set to true to output server response to console
            debug: false,
            template: '<div class="qq-uploader">' +
                    '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' +
                    '<div class="qq-upload-button">上传图片</div>' +
                    '<ul class="qq-upload-list"></ul>' +
                 '</div>',
            fileTemplate: '<li>' +
                    '<span class="qq-upload-file"></span>' +
                    '<span class="qq-upload-spinner"></span>' +
                    '<span class="qq-upload-size"></span>' +
                    '<a class="qq-upload-cancel" href="#">取消</a>' +
                    '<span class="qq-upload-failed-text">上传失败</span>' +
                '</li>',
            params: {"authenticity_token": tokentag},
            onComplete: function(id, fileName, responseJSON){
              if (responseJSON.success) {
                $('.step_uploader').eq(length-1).find('.qq-upload-button').css("background-image", "url("+ responseJSON.picture_url +")");
                $('.step_uploader').eq(length-1).parent().find('.img_id').val(responseJSON.image_id);
                $('.step_uploader .qq-upload-success').hide();
                $('.step_uploader .qq-upload-file').hide();
                $('.step_uploader .qq-upload-size').hide();
              }

              else {}
            }
        });
    }
}

//$(function() {
//     step_uploader();
//});


