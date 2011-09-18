function reset_city(province_id) {
    $.getJSON('/locations/cities.json?province_id=' + province_id, function(data) {
        var select = $('.select_city');
        select.empty();

        if(select.prop) {
            var options = select.prop('options');
        }
        else {
            var options = select.attr('options');
        }

        var index = 0;
        $.each(data, function(key, val) {
            options[options.length] = new Option(val["name"], val["id"]);
            if (index == 0) {
                $('.hidden_city').val(val["name"]);
            }
            index++;
        });
    });
}

$(function(){
    $('.select_province').change(function() {
        reset_city($(this).val());
    });

    $('.select_city').change(function() {
        $('.hidden_city').val($('select.select_city option:selected').text());
    });
});