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
            onSubmit: function(id, fileName) {
                $('#upload_spinner').show();
            },
            onComplete: function(id, fileName, responseJSON){
              $('#upload_spinner').hide();
              if (responseJSON.success) {
                var image_field = '<input id="images_" type="hidden" value="' + responseJSON.image_id + '" name="images[]"/>';
                append_image(responseJSON.image_id, responseJSON.thumb_url, responseJSON.origin_url, image_field);
              }
            }
        });
    }
});

//Append the image, it could belong to Image or Product
function append_image(id, thumb_url, original_url, post_params) {
     var new_image = '<div class="image fl">'
                + post_params
                + '<a onclick="delete_image(this, 5); return false;" class="del_img_link lighter_touch" href="#" data-image_id="' + id +'"><img border="0" src="/assets/close_x.png" alt="delete_image"></a><br>'
                + '<a class="thumbnail" rel="facebox" href="' + original_url + '">'
                + '<img src="' + thumb_url + '" alt="image_thumbnail"></a>'
    var debug = $('#uploader').data("debug");
    if(debug == true)
    {
        new_image += '<p>' + original_url + '</p>'
    }
    new_image += '</div>'


    $('#images_container').append(new_image);
    //Apply facebox
    $('a[rel*=facebox]').facebox();
    // var image_count = $('#images_container .image').size();
    //  if (image_count >= images_limit) { $('#image_uploaderUploader').hide(); }
}

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
    var length = $('.step_uploader').find('.qq-upload-button').length;
//    alert(length);
    if(url==null||url=="")
    {
        url = "/assets/default_step.png";
    }
//    alert(url);
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
                $('.step_uploader').eq(length-1).find('.qq-upload-button').css("background-image", "url("+ responseJSON.thumb_url +")");
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


