//= require jquery
//= require jquery_ujs
//= require_self
//= require jquery.tokeninput
//= require jquery.metadata
//= require jquery.jgrowl
//= require facebox
//= require coda-slider.1.1.1.pack
//= require tinymce-jquery
//= require jquery.highlight-3
//= require kissy/kissy
//= require fileuploader
//= require_tree .

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// for Silder
var theInt = null;
var $crosslink, $navthumb;
var curclicked = 0;

theInterval = function(cur){
        clearInterval(theInt);

        if( typeof cur != 'undefined' )
                curclicked = cur;

        $crosslink.removeClass("active-thumb");
        $navthumb.eq(curclicked).parent().addClass("active-thumb");
                $(".stripNav ul li a").eq(curclicked).trigger('click');

        theInt = setInterval(function(){
                $crosslink.removeClass("active-thumb");
                $navthumb.eq(curclicked).parent().addClass("active-thumb");
                $(".stripNav ul li a").eq(curclicked).trigger('click');
                curclicked++;
                if( 6 == curclicked )
                        curclicked = 0;

        }, 3000);
};

$(function(){

        $("#main-photo-slider").codaSlider();

        $navthumb = $(".nav-thumb");
        $crosslink = $(".cross-link");

        $navthumb
        .click(function() {
                var $this = $(this);
                theInterval($this.parent().attr('href').slice(1) - 1);
                return false;
        });

        theInterval();
});


//Add fields to DOM
function add_fields(link, association, content, divname) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(divname).append(content.replace(regexp, new_id));
    char_aware();
//    alert($(link).html());
    step_uploader();

    var count= $(divname).find(".addedclass").length;
//    alert(count);
    max = parseInt ($(link).data('max_len'));
//    alert($(link).data('ingredients_max_len'));
    if (max) {
//              var max = parseInt(data.max);
          if(count >= max) {
            $(link).hide();
          }
      }


}

//Remove fields from DOM
function remove_fields(link, removefield, showfield) {
  $(link).prev("input[type=hidden]").val("1");
    alert(showfield);
    alert(removefield);

//    show the add link when the existing items < max
    var button = $(link).parents(showfield).next();
//    alert(button.html());
//    change
    if (button.hasClass("add_fields"))
    {
        button.show();
    }

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

    tokenize_input("#article_tags_string", "/tags.json", 10);
    tokenize_input("#topic_tags_string", "/tags.json", 10);
    tokenize_input("#product_tags_string", "/tags.json", 10);
    tokenize_input("#group_tags_string", "/tags.json", 10);
    tokenize_input("#vendor_fields #product_vendor_token", "/vendors.json", 1);
});


//Apply Tinymce
$(function() {
    $('.rich_editor').tinymce({
        theme : "advanced",
        theme_advanced_toolbar_location : "top",
        theme_advanced_toolbar_align : "left",
        theme_advanced_statusbar_location : "bottom",
        theme_advanced_resizing : true
    });
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

    //$(".button" ).button();
});

//Remove tips from search box
jQuery(function() {
  $('.clear_default').click(function() {
    $(this).val('');
    return $(this).removeClass('not_cleared');
  });
  return $('.close_panel_link').click(function() {
    return $(this).parents('.panel').slideUp();
  });
});

//Add comment
$(function() {
    $('.reply_comment_link').live('click', function() {
        $(this).nextAll('.new_reply_comment').toggle('fast');
        return false;
    });
});

//Reply comment
$(function() {
    $('.add_comment_link').live('click', function() {
        $('#comments_block').toggle();
        return false;
    });
});

//Validates user's registration information
$(function () {
    $("#new_user").validate({
        rules: {
            "user[email]": {required: true, email: true, remote: "/users/check_email"},
            "user[password]": {required: true, minlength: 6},
            "user[password_confirmation]": {required: true, equalTo: "#user_password"}
        }
    });
});

//Provide hints for how many chars left
$(function() {
//     char_aware();
});


function char_aware()
{
    var bind_name = '';
    if (navigator.userAgent.indexOf("MSIE") != -1) { bind_name = 'propertychange'; }
    else { bind_name = 'input'; }

    $('.char_aware').bind(bind_name, function()
    {
        var max = parseInt ($(this).data('comment_max_len'));
        var mystring = $(this).val();
        var chineseRegex = /[^\x00-\xff]/g;
        var strLength = mystring.replace(chineseRegex,"**").length;
        var remaining = max - strLength;
       $(this).next('.char_counter').html('您还可输入' + parseInt(remaining/2) + '字' );
    });
}





