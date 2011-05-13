// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).before(content.replace(regexp, new_id));
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).parent().hide();
}

$(function() {
    $("#article_city_tokens").tokenInput("/cities.json", {
        crossDomain: false,
        prePopulate: $("#article_city_tokens").data("pre"),
        theme: "facebook"
    });
    $("#article_food_tokens").tokenInput("/foods.json", {
        crossDomain: false,
        prePopulate: $("#article_food_tokens").data("pre"),
        theme: "facebook"
    });
    $("#article_food_tokens").tokenInput("/foods.json", {
        crossDomain: false,
        prePopulate: $("#article_food_tokens").data("pre"),
        theme: "facebook"
    });
    $("#review_reference_tokens").tokenInput("/wiki/page_list.json", {
        crossDomain: false,
        prePopulate: $("#review_reference_tokens").data("pre"),
        theme: "facebook"
    });
});