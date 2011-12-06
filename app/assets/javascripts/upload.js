// Use Valums Ajax Upload
$(function() {
    var tokentag = $('#tokentag').val();
    var images_limit = 5;

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
                + '<a onclick="delete_image(this, 5); return false;" href="#"><img border="0" src="/assets/cancel.png" alt="delete_image"></a><br>'
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
});

//$(function () {
//	var input = document.getElementById("input_file"),
//	formdata = false;
//
//    // If browser support form-data, then the submit button will trigger the "browse"
//	if (window.FormData) {
//		formdata = new FormData();
//        var upload_button = document.getElementById("upload_btn");
//        if(upload_button) {
//            upload_button.addEventListener("click", function(e){
//                e.preventDefault();
//                input.click();
//            });
//        }
//    }
//
//    //If a file is selected
//    if (input) {
//        input.addEventListener("change", function (evt) {
//            var i = 0, len = this.files.length, img, reader, file;
//
//            //show some loading effects
//            $("#uploader #loading").show();
//
//            //Do something here...
//            for ( ; i < len; i++ ) {
//                file = this.files[i];
//
//                if (!!file.type.match(/image.*/)) {
//
//                }
//            }
//
//            if ( window.FileReader ) {
//                reader = new FileReader();
//                //reader.onloadend = function (e) {};
//                reader.readAsDataURL(file);
//            }
//            if (formdata) {
//                formdata.append("images[]", file);
//            }
//
//            //send the ajax request
//            if (formdata) {
//                $.ajax({
//                    url: "/images/upload",
//                    type: "POST",
//                    data: formdata,
//                    processData: false,
//                    contentType: false,
//                    success: function (res) {
////                        $("#uploader #loading").hide();
//                    }
//                });
//            }
//
//        }, false);
//    }
//});