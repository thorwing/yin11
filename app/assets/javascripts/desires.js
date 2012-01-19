//Desires Box
function shift_masonry(link) {
    var $container = $('#masonry_container');
    $('#filters a.selected').removeClass('selected');
    $(link).addClass('selected');
    var selector = $(link).attr('data-filter');
    $container.isotope({ filter: selector });
    return false;
}

$(function(){
    var $container = $('#masonry_container');

    $('#filters a').click(function(e){
        e.preventDefault();
        shift_masonry(this);
    });

    $('#filters a').hover(
        function(){
            shift_masonry(this);
        },
        function(){
        }
    );

    $.Isotope.prototype._masonryReset = function() {
        // layout-specific props
        this.masonry = {};
        this._getSegments();
        var i = this.masonry.cols;
        this.masonry.colYs = [];
        while (i--) {
          this.masonry.colYs.push( 0 );
        }

        if ( this.options.masonry.cornerStampSelector ) {
          var $cornerStamp = this.element.find( this.options.masonry.cornerStampSelector ),
              stampWidth = $cornerStamp.outerWidth(true) - ( this.element.width() % this.masonry.columnWidth ),
              cornerCols = Math.ceil( stampWidth / this.masonry.columnWidth ),
              cornerStampHeight = $cornerStamp.outerHeight(true);
          for ( i = Math.max( this.masonry.cols - cornerCols, cornerCols ); i < this.masonry.cols; i++ ) {
            this.masonry.colYs[i] = cornerStampHeight;
          }
        }
    };

    var first_tag = $('#filters a:first');
    first_tag.addClass('selected');

    $container.imagesLoaded( function(){
        $container.isotope({
            // options
            itemSelector : '.item',
            masonry: {
                cornerStampSelector: '.corner-stamp'
            },
            filter: first_tag.attr('data-filter')
        });
    });

//    $('#filters').everyTime(10000, 'controlled', function() {
//        var length = $(this).find('a').length;
//        var index = Math.floor((length) * (Math.random() % 1));
//        $('#filters a.selected').removeClass('selected');
//        var tag = $('#filters a:eq(' + index + ')');
//        tag.addClass('selected');
//        tag.click();
//    });
});


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
            var count = $('#desire_fields #images_container .uploaded_image').size();
            if (count < 1) {
                alert("要想馋到人，上传一张图片比较好哦");
                e.preventDefault();
            }
        }
    });
});