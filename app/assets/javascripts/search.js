$(function(){
    var keywords = $("#keywords");
    if (keywords.length > 0)
    {
        var key_text = keywords.text();
        if(key_text && key_text.length > 0)
        {
            $('#search_results').highlight(key_text);
        }
    }
});