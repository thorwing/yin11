function reset_city(province_id) {
    $.getJSON('/locations/cities.json?province_id=' + province_id, function(data) {
        var select = $('#select_city');
        select.empty();

        if(select.prop) {
            var options = select.prop('options');
        }
        else {
            var options = select.attr('options');
        }

        $.each(data, function(key, val) {
            options[options.length] = new Option(val["name"], val["id"]);
        });
    });
}

$('#select_province').change(function() {
    reset_city($(this).val());
});