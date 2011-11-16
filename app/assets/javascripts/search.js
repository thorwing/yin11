$(function(){
    var keywords = $("#keywords");
    if (keywords.length > 0)
    {
        $('#search_results').highlight(keywords.text());
    }
});