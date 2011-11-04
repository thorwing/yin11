//= require jquery
//= require jquery_ujs
//= require_self
//= require swfobject
//= require slimbox2
//= require kandytabs.pack
//= require jquery-easing-compatibility.1.2.pack
//= require jquery-easing-1.3.pack
//= require jquery.tokeninput
//= require jquery.pageless.min
//= require jquery.metadata
//= require jquery.jgrowl
//= require jquery.bubblepopup.v2.3.1.min
//= require facebox
//= require coda-slider.1.1.1.pack
//= require jquery.uploadify.v2.1.4.min
//= require tinymce-jquery
//= require_tree .

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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


function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).after(content.replace(regexp, new_id));
  var counter = $(link).prev("input[id$='counter']");
  if(counter) {
    var count = parseInt(counter.val()) + 1;
    counter.val(count);
    //TODO
      $.metadata.setType("html5");
      var data = counter.metadata();
      if (data.max) {
          var max = parseInt(data.max);
          if(count >= max) {
            $(link).hide();
          }
      }
  }
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).parent().hide();
}

function show_tab_content(link, content) {
  $(link).parents(".tab_header").find(".active").removeClass("active");
  $(link).parent().addClass("active");
  $(link).parents(".tab_control").children("div.tab_content").replaceWith(content);
}

function delete_image(link) {
    $(link).parent().remove();
    var image_count = $('#images_container .image').size();
    if (image_count < 5) {
        $('#image_uploader').show();
    }
}

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

    tokenize_input("#watch_tags", "/tags.json", 5);
    tokenize_input("#article_region_tokens", "/locations/regions.json", 5);
    tokenize_input("#article_tags_string", "/tags.json", 5);
    tokenize_input("#article_vendor_token", "/vendors.json", 1);
    tokenize_input("#review_tags_string", "/tags.json", 5);
    tokenize_input("#vendor_fields #review_vendor_token", "/vendors.json", 1);
    tokenize_input("#vendor_fields #product_vendor_token", "/vendors.json", 1);
    tokenize_input("#tip_tags_string", "/tags.json", 5);
    tokenize_input("#group_tags_string", "/tags.json", 5);
    tokenize_input("#added_foods", "/tags.json", 5);
    //tokenize_input(".one_token .one_tip", "/tips.json", 1);
});

$(function() {
    $('.rich_editor').tinymce({
        theme : "advanced",
        theme_advanced_toolbar_location : "top",
        theme_advanced_toolbar_align : "left",
        theme_advanced_statusbar_location : "bottom",
        theme_advanced_resizing : true
    });

//    tinyMCE.init({
//        mode : "textareas",
//        theme : "advanced",
//        editor_selector : "rich_editor"
//    });
//     if ($('textarea').length > 0) {
//       var data = $('.rich_editor');
//       $.each(data, function(i) {
//         CKEDITOR.replace(data[i].id);
//       });
//     }
  });

//When Dom is ready:
$(document).ready(function(){
//    $.facebox.settings.closeImage = url('/images/facebox/closelabel.png');
//    $.facebox.settings.loadingImage = url('/images/facebox/loading.gif');
    $('a[rel*=facebox]').facebox();
    $('a[rel*=lightbox]').slimbox();

    /*if (!/android|iphone|ipod|series60|symbian|windows ce|blackberry/i.test(navigator.userAgent)) {
	jQuery(function($) {
		$("a[rel^='lightbox']").slimbox({*//* Put custom options here *//*}, null, function(el) {
			return (this == el) || ((this.rel.length > 8) && (this.rel == el.rel));
		});
	});
}*/
});

//$(document).ready(function(){
//    $(".severity_radio").change(function(){
//        $("label.severity_image").removeClass("severity_0");
//        $("label.severity_image").removeClass("severity_1");
//        $("label.severity_image").removeClass("severity_2");
//        $("label.severity_image").removeClass("severity_3");
//
//        var value = $(".severity_radio:checked").val();
//        $("label.severity_image").addClass("severity_" + value);
//    });
//});

//JQuery UI
$(document).ready(function() {
    $(".date_picker").datepicker({ maxDate: +0, minDate: -7 });
    $(".radio_group" ).buttonset();
    $(".checkbox").button();
    $(".checkbox_group").buttonset();

    //$(".button" ).button();
});


$(function() {
    $('.reply_comment_link').live('click', function() {
        $(this).nextAll('.new_reply_comment').toggle();
        return false;
    });
});

$(function () {
    $("#new_user").validate({
        rules: {
            "user[email]": {required: true, email: true, remote: "/users/check_email"},
            "user[password]": {required: true, minlength: 6},
            "user[password_confirmation]": {required: true, equalTo: "#user_password"}
        }
    });
});

$(function() {
    $("dl.tab").KandyTabs({
        classes: "kandyTabs",
        trigger:"click"
    });
});


//$(function() {
//    $("ul.thumb li").hover(function() {
//        $(this).css({'z-index' : '10'}); /*Add a higher z-index value so this image stays on top*/
//        $(this).find('img').addClass("hover").stop() /* Add class of "hover", then stop animation queue buildup*/
//            .animate({
//                marginTop: '-110px', /* The next 4 lines will vertically align this image */
//                marginLeft: '-110px',
//                top: '50%',
//                left: '50%',
//                width: '174px', /* Set new width */
//                height: '174px', /* Set new height */
//                padding: '20px'
//            }, 200); /* this value of "200" is the speed of how fast/slow this hover animates */
//        } , function() {
//        $(this).css({'z-index' : '0'}); /* Set z-index back to 0 */
//        $(this).find('img').removeClass("hover").stop()  /* Remove the "hover" class , then stop animation queue buildup*/
//            .animate({
//                marginTop: '0', /* Set alignment back to default */
//                marginLeft: '0',
//                top: '0',
//                left: '0',
//                width: '100px', /* Set width back to default */
//                height: '100px', /* Set height back to default */
//                padding: '5px'
//            }, 400);
//    });
//});

//$(function() {
//    $(':checkbox[id^="review_faults"]').change(function(){
//        var n = $(".checkbox_group input:checked").length;
//        var severity = $(".severity");
//        severity.removeClass("zero one two three");
//        if (n == 0) {
//            severity.addClass("zero");
//        }
//        else if(n == 1) {
//            severity.addClass("one");
//        }
//        else if(n == 2) {
//            severity.addClass("two");
//        }
//        else{
//            severity.addClass("three");
//        }
//    });
//});

$(function() {
    $('.tip').each( function(intIndex) {
        $(this).CreateBubblePopup({
            position : 'top',
            align	 : 'left',
            themePath: 	'images/jquerybubblepopup-theme',
            innerHtml: $(this).data('content') });
    });
    //$('.tip')
});

$(function() {
    $('.char_aware').keyup(function() {
        var count = $(this).val().length;
        $('span.char_counter').html('已输入' + count + '字符');
    });
});

