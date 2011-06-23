// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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
    var image_count = $('.image').size();
    if (image_count < 5) {
        $('#image_upload_container').show();
    }
}

$(function() {
    function tokenize_input(element_selector, data_source, tokenLimit) {
        $(element_selector).tokenInput(data_source, {
            crossDomain: false,
            prePopulate: $(element_selector).data("pre"),
            theme: "facebook",
            tokenLimit: tokenLimit,
            hintText: "输入关键词",
            noResultsText: "没有结果",
            searchingText: "搜索中"
        });
    }

    tokenize_input("#article_city_tokens", "/cities.json", 10);
    tokenize_input("#article_food_tokens", "/foods.json", 10);
    tokenize_input("#article_vendor_token", "/vendors.json", 1);
    tokenize_input("#review_food_tokens", "/foods.json", 10);
    tokenize_input("#review_vendor_token", "/vendors.json", 1);
    tokenize_input("#recommendation_food_tokens", "/foods.json", 10);
    tokenize_input("#recommendation_vendor_token", "/vendors.json", 1);
    tokenize_input("#added_foods", "/foods.json", 10);
    tokenize_input("#profile_address_attributes_city_token", "/cities.json", 1);
    //tokenize_input(".one_token .one_tip", "/tips.json", 1);
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

$(document).ready(function(){
    $(".severity_radio").change(function(){
        $("label.severity_image").removeClass("severity_0");
        $("label.severity_image").removeClass("severity_1");
        $("label.severity_image").removeClass("severity_2");
        $("label.severity_image").removeClass("severity_3");

        var value = $(".severity_radio:checked").val();
        $("label.severity_image").addClass("severity_" + value);
    });
});

//JQuery UI
$(document).ready(function() {
    $(".date_picker").datepicker({ maxDate: +0, minDate: -7 });
    $(".radio_group" ).buttonset();
    $(".checkbox").button();
    $(".checkbox_group").buttonset();

    //$(".button" ).button();
});

