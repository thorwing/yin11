//Desires Box
//function shift_masonry(filter) {
//    $('#filters .filter_tab.selected').removeClass('selected');
//    $(filter).parents(".filter_tab").addClass('selected');
////    $('#filters .filter_tab .small_bar').width(0);
////
////    var small_bar = $(filter).parents(".filter_tab").find(".small_bar");
////    small_bar.animate ({
////        width: '100%'
////    }, 500, function(){
////    // TODO  make sure if a new tab selected during the duration, the old one is cleared
////        $('#filters .filter_tab .small_bar').width(0);
////        $('#filters .filter_tab.selected .small_bar').width('100%');
////    });
//
//    var $container = $('#masonry_container');
//    var selector = $(filter).attr('data-filter');
//    $container.isotope({filter: selector});
//    return false;
//}

//$(function(){
//    var $container = $('#masonry_container');
//    $('#filters .filter').click(function(e){
//        e.preventDefault();
//        shift_masonry(this);
//    });
//
//    $('#filters .filter').hover(
//        function(e){
//            shift_masonry(this);
//        },
//        function(){
//        }
//    );
//
//    $.Isotope.prototype._masonryReset = function() {
//        // layout-specific props
//        this.masonry = {};
//        this._getSegments();
//        var i = this.masonry.cols;
//        this.masonry.colYs = [];
//        while (i--) {
//          this.masonry.colYs.push( 0 );
//        }
//
//        if ( this.options.masonry.cornerStampSelector ) {
//          var $cornerStamp = this.element.find( this.options.masonry.cornerStampSelector ),
//              stampWidth = $cornerStamp.outerWidth(true) - ( this.element.width() % this.masonry.columnWidth ),
//              cornerCols = Math.ceil( stampWidth / this.masonry.columnWidth ),
//              cornerStampHeight = $cornerStamp.outerHeight(true);
//          for ( i = Math.max( this.masonry.cols - cornerCols, cornerCols ); i < this.masonry.cols; i++ ) {
//            this.masonry.colYs[i] = cornerStampHeight;
//          }
//        }
//    };
//
//    var first_tab = $('#filters .filter_tab:first');
//    first_tab.addClass('selected');
//    first_tag = first_tab.find('.filter').attr('data-filter');
//
//    $container.imagesLoaded( function(){
//        $container.isotope({
//            // options
//            itemSelector : '.item',
//            masonry: {
//                cornerStampSelector: '.corner-stamp'
//            },
//            filter: first_tag
//        });
//    });
//
////    $('#filters').everyTime(10000, 'controlled', function() {
////        var length = $(this).find('a').length;
////        var index = Math.floor((length) * (Math.random() % 1));
////        $('#filters a.selected').removeClass('selected');
////        var tag = $('#filters a:eq(' + index + ')');
////        tag.addClass('selected');
////        tag.click();
////    });
//});


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

$(function(){
    $('.solution_option').hover(
        function(e){
            $(this).find('.solution_hint').show();
        },
        function(e){
            $(this).find('.solution_hint').hide();
        }
    );
});


function shift_solutions_group(link) {
    var current_index = parseInt($(link).data('current_index'));
    var max_index = parseInt($(link).data('max_index'));

    var new_index = (current_index < max_index) ? current_index + 1 : 0;
    $(".solutions_group.display_block").addClass("display_none");
    $(".solutions_group.display_block").removeClass("display_block");

    $(".solutions_group." + new_index).addClass("display_block");
    $(".solutions_group." + new_index).removeClass("display_none");
    $(link).data('current_index', new_index);
}

$(function(){
    if($('#solution_submit').length > 0) {
        //    check if all the necessory info is given
        $('#solution_submit').click(function(e){
            var verify_passed = false;
            var has_one_recipe = false;
            var has_one_product = false;

            var message = "您忘了添加:\n";
            //   check if all the neccessary info are given

            if($('.solution_fields #solution_content').text() == "说说解馋理由吧...") {
                $('.solution_fields #solution_content').text('');
            }


            //        1 recipe name should be given
            if(String($('.solution_fields #recipe_id').val()) != "") {
                has_one_recipe = true;
            }

            if(String($('.solution_fields #product_id').val()) != "") {
                has_one_product = true;
            }

            if(has_one_product == false && has_one_recipe == false) {
                e.preventDefault();
                alert("请添加至少一个商品或菜谱吧");
            }
        });
    }
});

$(function() {
    $('.solution_option:not(.add_new)').click(
        function(e){
            e.preventDefault();
            $(".solution_option").removeClass("selected");
            $(this).addClass("selected");
            $(".solution_detail").hide();
            $(this).find(".solution_detail").show();
            $(".new_solution_area").hide();
        }
    );

    $('.solution_option.add_new').click(
        function(e){
            e.preventDefault();
            $(".solution_option").removeClass("selected");
            $(this).addClass("selected");
            $(".solution_detail").hide();
            $(".new_solution_area").show();
        }
    );
});
