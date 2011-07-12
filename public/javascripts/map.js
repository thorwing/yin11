function update_map(is_complete) {
    var city_input = $(".map_city");
    var detail_input = $(".map_detail");
    //process only if the city and detail input fields are there
    if(city_input && detail_input) {
        //display an indicator that the process is begun
        var indicator = $(".map_indicator");
        if(indicator) {
            indicator.removeClass("valid");
            indicator.removeClass("invalid");
        }

        var address = city_input.val() + " " + detail_input.val();
        $("#map_address_span").text(address);
        $.getJSON('/locations/search.json?address=' + encodeURI(address), function(data) {
            if(data && data.length ==2) {
                if(indicator && is_complete) {
                    indicator.addClass("valid");
                }
                if(is_complete){
                    Gmaps4Rails.replaceMarkers([{"longitude": data[1], "latitude": data[0] }]);
                    Gmaps4Rails.map.setZoom(15);
                }
                else{
                    Gmaps4Rails.map.setCenter(Gmaps4Rails.createLatLng(data[0], data[1]));
                    Gmaps4Rails.map.setZoom(10);
                }
            }
            else {
                if(indicator && is_complete) {
                    indicator.addClass("invalid");
                }
            }
        });
    }
}

Gmaps4Rails.geolocationFailure= function(browser_support) {
  if (browser_support === true)
    { //User refused geolocation
    }
  else
    { //Geolocation not supported by the user's browser
    }
    update_map(false);
};

Gmaps4Rails.callback = function() {
    $(".map_detail").change(function() {
        update_map(true);
    });
};

//function add_fields_with_map(link, association, content) {
//  var new_id = new Date().getTime();
//  var regexp = new RegExp("new_" + association, "g");
//  $(link).before(content.replace(regexp, new_id));
//
//  $("#map_container").show();
//  add_listeners();
//}
//    var map = null;
//
//    $(document).ready(function(){
//        initialize_map();
//
//        if ($(".map_point_lng").length != 0 && $(".map_point_lat").length != 0)
//        {
//            var lng = $(".map_point_lng").val();
//            var lat = $(".map_point_lat").val();
//            if(lng && lat)
//            {
//                var point = new BMap.Point(lng, lat);  // 创建点坐标
//                update_map_with_point(point);
//            }
//        }
//        else
//        {
//            var place = $(".map_detail").val();
//            var street = $(".map_detail").val();
//            var city = $(".map_city").val();
//
//            update_map(city, detail, place, null);
//        }
//
//        add_listeners();
//    });
//
//    function initialize_map() {
//        map = new BMap.Map("map_container");          // 创建地图实例
//        //map.centerAndZoom("北京");    // 初始化地图
//        map.enableScrollWheelZoom();  // 开启鼠标滚轮缩放
//        map.enableKeyboard();         // 开启键盘控制
//        map.enableContinuousZoom();   // 开启连续缩放效果
//        map.enableInertialDragging(); // 开启惯性拖拽效果
//    }
//
//    function add_listeners() {
//        $(".map_city").change(function(){
//            update_map_from_listener(this);
//        });
//
//        $(".map_detail").change(function(){
//            update_map_from_listener(this);
//        });
//
//        $(".map_detail").change(function(){
//            update_map_from_listener(this);
//        });
//    }
//
//    function update_map_from_listener(control) {
//        var parent = $(control).parents("div.map_address");
//        var indicator = parent.find(".map_indicator");
//        indicator.removeClass("valid");
//        indicator.removeClass("invalid");
//        indicator.addClass("checking");
//
//        var place = parent.find(".map_detail").val();
//        var street = parent.find(".map_detail").val();
//        var city = parent.find(".map_city").val();
//
//        update_map(city, detail, place, control);
//    }
//
//    function update_map_with_point(point)
//    {
//        map.centerAndZoom(point, 16);
//        map.addOverlay(new BMap.Marker(point));
//    }
//
//    function update_map(city, detail, place, control) {
//        if (detail != null || place != null)
//        {
//            var myGeo = new BMap.Geocoder(); // 创建地址解析器实例
//            // 将地址解析结果显示在地图上,并调整地图视野
//            myGeo.getPoint(detail + " " + place, function(point){
//                if (point) {
//                    update_map_with_point(point);
//
//                    if(control)
//                    {
//                        var parent = $(control).parents("div.map_address");
//                        parent.find(".map_point").val(point.lng + "," + point.lat);
//                        var indicator = parent.find(".map_indicator");
//                        indicator.removeClass("checking");
//                        indicator.addClass("valid");
//                    }
//                }
//                else
//                {
//                    map.centerAndZoom(city);
//
//                    if(control)
//                    {
//                        var parent = $(control).parents("div.map_address");
//                        var indicator = parent.find(".map_indicator");
//                        indicator.removeClass("checking");
//                        indicator.addClass("invalid");
//                    }
//                }
//            }, city);
//        }
//        else
//        {
//            map.centerAndZoom(city);
//        }
//    }
//
//
