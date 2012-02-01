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
//= require jquery.isotope.min
//= require jquery.timer
//= require liteaccordion.jquery.min
//= require_tree .

//not included
// require jquery.ui.core.min
// require jquery.ui.widget.min
//require jquery.ui.rcarousel.min

var products_limit = 3;
var recipes_limit = 3;
var images_limit = 3;


//Add fields to DOM
function add_fields(link, association, content, divname, count_range) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(divname).append(content.replace(regexp, new_id));
    char_aware();
    setup_step_img_uploader(count_range);
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
    tokenize_input("#album_tags_string", "/tags/query.json", 10);
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

//Remove tips from input
$(function()
{
    $('.not_cleared').live("click", function(){
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

function fill_tag(link) {
    var name = $(link).text();
    var input = $(".tags_input");
    if(input.length > 0)
    {
        var data = {id: name, name: name};
        input.tokenInput("add", data);
    }
  }

function expand_tags(link) {
    $(link).parents(".first_level").next().toggle();
    var text = $(link).text();
    if ($(link).text() == "+展开") {
        $(link).text("-收起");
    }
    else {
        $(link).text("+展开");
    }
}