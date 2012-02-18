//= require jquery
//= require jquery_ujs
//= require_self
//= require jquery.tokeninput
//= require jquery.metadata
//= require jquery.jgrowl
//= require facebox
//= require jquery.highlight-3
//= require fileuploader
//= require jquery.Jcrop.min
//= require jquery.lazyload
//= require jquery.timer
//= require liteaccordion.jquery.min
//= require jquery.masonary
//= require jquery.infinitescroll
//= require jquery-ui.min
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
    setup_step_img_uploader(false);
    change_back_img(false);

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
//    tokenize_input("#recipe_tags_string", "/tags/query.json", 10);
    tokenize_input("#group_tags_string", "/tags/query.json", 10);
//    tokenize_input("#desire_tags_string", "/tags/query.json", 10);
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
//$(document).ready(function() {
//    $(".date_picker").datepicker({ maxDate: +0, minDate: -7 });
//    $(".radio_group" ).buttonset();
//    $(".checkbox").button();
//    $(".checkbox_group").buttonset();
//});

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
//            $(this).nextAll('.char_saver').val(content);
        }
        else {
            $(this).nextAll('.char_counter').html('超过了<b class="f15 red">' + parseInt(-1 * remaining/2) + '字</b>' );
            //  restore the cached content
//            $(this).val($(this).nextAll('.char_saver').val());
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

function setup_lazy() {
    $("img.lazy").lazyload({
        skip_invisible : true,
        threshold : 500,
        failure_limit : 10}
    );
}

$(function(){
    setup_lazy();
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

function fill_desire_tag(link) {
    var name = $(link).text();
    var input = $(".tags_to_fill");
    if(input.length > 0)
    {
        var value = input.val().trim();
        var tags = value.split(" ");
        if(tags.length >= 10) {
            alert("已经打了10个标签啦！");
        }
        else {
            tags.push(name);
            input.val(tags.join(" ").replace(/^\s\s*/, '').replace(/\s\s*$/, ''));
        }
    }
}

$(function(){
    $("#desire_tags_string_with_spaces").change(function(){
        var value = $(this).val().trim();
        var tags = value.split(" ");
        if(tags.length > 10) {
            alert("打了超过10个标签啦！");
              $(this).val(tags.slice(0, 10).join(" ").replace(/^\s\s*/, '').replace(/\s\s*$/, ''));
        }
    });
});

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



$(function(){

    var $container = $('#masonry_container');

//    $container.imagesLoaded(function(){
      $container.masonry({
//        cornerStampSelector: '.coner_stamp',
        itemSelector: '.masonary_item',
        columnWidth: 10
      });
//    });

    $container.infinitescroll({
      debug: false,
      navSelector  : '#page_nav',    // selector for the paged navigation
      nextSelector : '#page_nav a:first',  // selector for the NEXT link (to page 2)
      itemSelector : '.masonary_item',     // selector for all items you'll retrieve
      bufferPx: 300,
      errorCallback : function(){
          $('#infscr-loading').hide();
          $('#more_nav').show();
      },
      loading: {
          finishedMsg: '到底啦！去看看其他的吧～',
          img: '../assets/loading_big.gif',
          msgText : '正在加载更多...'
        }
      },
      // trigger Masonry as a callback
      function( newElements ) {
        // hide new items while they are loading
        var $newElems = $( newElements ).css({ opacity: 0 });
        // ensure that images load before adding to masonry layout
//        $newElems.imagesLoaded(function(){
          // show elems now they're ready
          $newElems.animate({ opacity: 1 });
          $container.masonry( 'appended', $newElems, true );
//        });

//        setup_lazy();

        if($('#back_to_top').length > 0) {
            $('#back_to_top').show();
            // scrollTo
            $('#back_to_top').on('click', function(e) {
                e.halt();
                e.preventDefault();
//                $('#back_to_top').hide();
                $(window).stop();
                $(window).animate({
                    scrollTop:0
                },1,"easeOut");
            });
        }
      }
    );
});