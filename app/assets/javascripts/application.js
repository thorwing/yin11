//= require jquery
//= require jquery_ujs
//= require_self
//= require jquery.tokeninput
//= require jquery.metadata
//= require jquery.jgrowl
//= require facebox
//= require jquery.highlight-3
//= require fileuploader
//= require kissy/kissy
//= require jquery.Jcrop.min
//= require lazyload
//= require jquery.ui.core.min
//= require jquery.ui.widget.min
//= require jquery.ui.rcarousel.min
//= require jquery.isotope.min
//= require jquery.timer
//= require_tree .

var products_limit = 3;
var recipes_limit = 3;
var images_limit = 3;


//Add fields to DOM
function add_fields(link, association, content, divname, count_range) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(divname).append(content.replace(regexp, new_id));
    char_aware();
    step_uploader(count_range);
    change_back_img(count_range);

    var count= $(count_range).find(".addedclass").length;
    max = parseInt ($(link).data('max_len'));
    if (max) {
        if(count >= max) {
        $(count_range).find(".add_fields").hide();
        }
    }
}

//Remove fields from DOM
function remove_fields(link, removefield, showfield) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).parents(showfield).find(".add_fields").show();
    $(link).parents(removefield).remove();
}

//Autocomplete input
$(function() {
    function tokenize_input(element_selector, data_source, tokenLimit) {
        $(element_selector).tokenInput(data_source, {
            crossDomain: false,
            preventDuplicates: true,
            prePopulate: $(element_selector).data("pre"),
            theme: "facebook",
            tokenLimit: tokenLimit,
            hintText: "输入关键词",
            noResultsText: "没有结果",
            searchingText: "搜索中"
        });
    }

    tokenize_input("#topic_tags_string", "/tags/query.json", 10);
    tokenize_input("#product_tags_string", "/tags/query.json", 10);
    tokenize_input("#recipe_tags_string", "/tags/query.json", 10);
    tokenize_input("#group_tags_string", "/tags/query.json", 10);
    tokenize_input("#desire_tags_string", "/tags/query.json", 10);
    tokenize_input("#vendor_fields #product_vendor_token", "/vendors.json", 1);
    tokenize_input("#message_fields .token #user_id", "/users/fans.json", 1);
});

//Apply facebox
$(document).ready(function(){
    //    $.facebox.settings.closeImage = url('/images/facebox/closelabel.png');
    //    $.facebox.settings.loadingImage = url('/images/facebox/loading.gif');
    $('a[rel*=facebox]').facebox();
});

//Apply some JQuery UI
$(document).ready(function() {
    $(".date_picker").datepicker({ maxDate: +0, minDate: -7 });
    $(".radio_group" ).buttonset();
    $(".checkbox").button();
    $(".checkbox_group").buttonset();
});

//Remove tips from search box
jQuery(function() {
  $('#search_btn').click(function(){
    $('#query.not_cleared').val('');
  });

  $('#query.not_cleared').click(function() {
    if($(this).hasClass('not_cleared')) {
      $(this).val('');
      $(this).removeClass('not_cleared');
    }
  });
});

//$(function()) {
//    return $('.close_panel_link').click(function() {
//    return $(this).parents('.panel').slideUp();
//  });
//}


//Validates user's registration information
$(function () {
    $("#new_user").validate({
        rules: {
            "user[email]": {required: true, email: true, remote: "/users/validates_email"},
            "user[login_name]": {required: true, remote: "/users/validates_login_name"},
            "user[password]": {required: true, minlength: 6},
            "user[password_confirmation]": {required: true, equalTo: "#user_password"}
        }
    });
});

$(function(){
    $(".hint_box").hover(
        function(){
            var hint = $(this).find(".flex_hint");
            hint.css("display", "block");
        },
        function(){
            var hint = $(this).find(".flex_hint");
            hint.slideUp('fast');
        }
    );
});

//Provide hints for how many chars left
$(function() {
     char_aware();
});


function char_aware()
{
    var bind_name = '';
    if (navigator.userAgent.indexOf("MSIE") != -1) { bind_name = 'propertychange'; }
    else { bind_name = 'input'; }

    $('.char_aware').bind(bind_name, function(e)
    {
        var max = parseInt ($(this).data('comment_max_len'));
        var content = $(this).val();
        var chineseRegex = /[^\x00-\xff]/g;
        var strLength = content.replace(chineseRegex,"**").length;
        var remaining = max - strLength;
        if(remaining >= 0) {
            //  cache the content
            $(this).nextAll('.char_counter').html('还可以输入' + parseInt(remaining/2) + '字' );
            $(this).nextAll('.char_saver').val(content);
        }
        else {
            //  restore the cached content
            $(this).val($(this).nextAll('.char_saver').val());
        }
    });
}


$(function(){
    $('.more_info_container').hover(
    function(){
        $(this).find('.more_info').removeClass('display_none');
        $(this).find('.more_info').removeClass('display_block');
    },
    function(){
        $(this).find('.more_info').addClass('display_none');
    });
});

$(function(){
    $("img.lazy").lazyload();
});

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

    $('#filters a').click(function(){
       shift_masonry(this);
    });

    $('#filters a').hover(function(){
       shift_masonry(this);
    });

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



//    $container.imagesLoaded( function(){
//    });
    var first_tag = $('#filters a:first');
    first_tag.addClass('selected');

    $container.isotope({
        // options
        itemSelector : '.item',
        layoutMode : 'masonry',
        masonry: {
            columnWidth: 220,
            cornerStampSelector: '.corner-stamp'
        },
        filter: first_tag.attr('data-filter')
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
