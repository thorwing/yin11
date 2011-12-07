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
                    + '<img width="200" height="200" border="0" src="' + responseJSON.picture_url + '" alt="image_thumbnail"></a><br>'
                    + responseJSON.picture_url
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