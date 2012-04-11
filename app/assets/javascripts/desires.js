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
    $('#desire_fields #submit_desire').bind("click keyup", function (e){
        if($('#desire_fields #images_container').length > 0)
        {
            var count = $('#desire_fields #images_container .uploaded_image').size();
            if (count < 1) {
                alert("要想馋到人，上传一张图片比较好哦");
                e.preventDefault();
                return;
            }
        }
        var content_input = $('#desire_fields #desire_content');
        if(content_input.length > 0)
        {
            if (content_input.val() == "") {
                alert("写得描述吧，让美食变得更诱人～");
                e.preventDefault();
                return;
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


    $(".solution_option").removeClass("selected");
    var first_option = $(".solutions_group." + new_index).find(".solution_option:first");
    first_option.addClass("selected");
    $(".solution_detail").hide();
    $(".new_solution_area").hide();
    first_option.find(".solution_detail").show();
}

$(function(){
    if($('#solution_submit').length > 0) {
        //    check if all the necessory info is given
        $('#solution_submit').click(function(e){

        });
    }
});

$(function() {
    $('.solution_option:not(.add_new)').click(
        function(e){
            $(".solution_option").removeClass("selected");
            $(this).addClass("selected");
            $(".solution_detail").hide();
            $(this).find(".solution_detail").show();
            $(".new_solution_area").hide();
        }
    );

    $('.solution_option.add_new').click(
        function(e){
            $(".solution_option").removeClass("selected");
            $(this).addClass("selected");
            $(".solution_detail").hide();
            $(".new_solution_area").show();
        }
    );
});


//link product

function link_product()
{
//    var count = $('#images_container .product').size();
//    if (count >= products_limit) {
//        alert("最多只能添加3件商品");
//        return;
//    }

    jQuery.facebox($('#product_linker').html());
};

function pre_link_product(link)
{
    $("div.popup #link_spinner").show();
    return true;
};

//link tuan

function link_tuan()
{
    jQuery.facebox($('#tuan_linker').html());

};

function pre_link_tuan(link)
{
    $("div.popup #link_spinner").show();
    return true;
};


//link recipe
function listen_recipe_name() {
    var timerid;
    jQuery("" +
        " #recipe_name").keyup(function() {
      var input = this;
      clearTimeout(timerid);
      timerid = setTimeout(function() {
        $(input).nextAll('#link_spinner').show();
//        $(input).nextAll("div").html('');

        var name = $(input).val();
        $.ajax({
          url: "/recipes/browse",
          data: {name: name}
        });
      }, 500);
    });
};

function link_recipe()
{
//    var count = $('#images_container .recipe').size();
//    if (count >= recipes_limit) {
//        alert("最多只能添加3份菜谱");
//        return;
//    }

    jQuery.facebox($('#recipe_linker').html());
    listen_recipe_name();
};


function pick_recipe(link, id) {
    $(document).trigger('close.facebox');
    var content = $(link).parents(".recipe_hint").find(".recipe_solution").html();
    $('#image_container').html(content);
    $('#recipe_id').val(id);
};

//link place

function listen_place_name() {
    var timerid;
    jQuery("" +
        " #place_name").keyup(function() {
      var input = this;
      clearTimeout(timerid);
      timerid = setTimeout(function() {
        $(input).nextAll('#link_spinner').show();
//        $(input).nextAll("div").html('');

        var name = $(input).val();
        $.ajax({
          url: "/places/browse",
          data: {name: name}
        });
      }, 500);
    });
};

function link_place()
{
    jQuery.facebox($('#place_linker').html());
    listen_place_name();
};

function pick_place(link, id) {
    $(document).trigger('close.facebox');
    var content = $(link).parents(".place_hint").find(".place_solution").html();
    $('#image_container').html(content);
    $('#place_id').val(id);
};


function review_solution()
{
    var solution_content = $('.solution_fields #solution_content').val();

    if(solution_content == "说说解馋理由吧..." || solution_content == "") {
        alert("说说解馋理由吧");
        return false;
    }

    var has_one_recipe = false;
    var has_one_product = false;
    var has_one_place = false;
    var has_one_tuan = false;

    var recipe_id = String($('.solution_fields #recipe_id').val());
    if(recipe_id && recipe_id != "") {
        has_one_recipe = true;
    }

    var product_id = String($('.solution_fields #product_id').val());
    if(product_id && product_id != "") {
        has_one_product = true;
    }

    var place_id = String($('.solution_fields #place_id').val());
    if(place_id && place_id != "") {
        has_one_place = true;
    }

    var tuan_id = String($('.solution_fields #tuan_id').val());
    if(tuan_id && tuan_id != "") {
        has_one_tuan = true;
    }

    if(has_one_product == false && has_one_recipe == false && has_one_place == false && has_one_tuan == false) {
        alert("请添加至少一个商品、菜谱、餐馆或团购吧");
        return false;
    }

    var new_item_id = $(".solution_fields .new_solution_item_id").text();

    var existed_items = $(".listed_item .existed_solution_item_id." + new_item_id);

    if(existed_items.length > 0){
        alert("已存在类似的解馋攻略哦");
        return false;
    }
    else{
        return true;
    }
}