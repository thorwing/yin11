$(function () {
	var input = document.getElementById("input_file"),
	formdata = false;

    // If browser support form-data, then the submit button will trigger the "browse"
	if (window.FormData) {
		formdata = new FormData();
        var upload_button = document.getElementById("upload_btn");
        if(upload_button) {
            upload_button.addEventListener("click", function(e){
                e.preventDefault();
                input.click();
            });
        }
    }

    //If a file is selected
    if (input) {
        input.addEventListener("change", function (evt) {
            var i = 0, len = this.files.length, img, reader, file;

            //show some loading effects
            $("#uploader #loading").show();

            //Do something here...
            for ( ; i < len; i++ ) {
                file = this.files[i];

                if (!!file.type.match(/image.*/)) {

                }
            }

            if ( window.FileReader ) {
                reader = new FileReader();
                //reader.onloadend = function (e) {};
                reader.readAsDataURL(file);
            }
            if (formdata) {
                formdata.append("images[]", file);
            }

            //send the ajax request
            if (formdata) {
                $.ajax({
                    url: "/images/upload",
                    type: "POST",
                    data: formdata,
                    processData: false,
                    contentType: false,
                    success: function (res) {
//                        $("#uploader #loading").hide();
                    }
                });
            }

        }, false);
    }
});