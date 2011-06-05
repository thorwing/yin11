var map = null;

function add_fields_with_map(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).before(content.replace(regexp, new_id));

  $("#map_container").show();
  add_listeners();
}

$(document).ready(function(){
    initialize_map();

    var place = $(".map_place").val();
    var street = $(".map_street").val();
    var city = $(".map_city :selected").text();
    update_map(city, street, place);

    add_listeners();
});

function initialize_map() {
    map = new BMap.Map("map_container");          // 创建地图实例
    map.centerAndZoom("北京");    // 初始化地图
    map.enableScrollWheelZoom();  // 开启鼠标滚轮缩放
    map.enableKeyboard();         // 开启键盘控制
    map.enableContinuousZoom();   // 开启连续缩放效果
    map.enableInertialDragging(); // 开启惯性拖拽效果
}

function add_listeners() {
    $(".map_city").change(function(){
        update_map_from_listener(this);
    });

    $(".map_street").change(function(){
        update_map_from_listener(this);
    });

    $(".map_place").change(function(){
        update_map_from_listener(this);
    });
}

function update_map_from_listener(control) {
    var parent = $(control).parents("div.map_address");
    var place = parent.find(".map_place").val();
    var street = parent.find(".map_street").val();
    var city = parent.find(".map_city").find("option:selected").text();
    update_map(city, street, place, control);
}

function update_map(city, street, place, control) {
    if (street != null || place != null)
    {
        var myGeo = new BMap.Geocoder(); // 创建地址解析器实例
        // 将地址解析结果显示在地图上,并调整地图视野
        myGeo.getPoint( city +  " " + street + " " + place, function(point){
            if (point) {
                map.centerAndZoom(point, 16);
                map.addOverlay(new BMap.Marker(point));

                if(control)
                {
                    $(control).parents("div.map_address").find(".map_point").val(point.lng + "," + point.lat);
                }
            }
            else
            {
                map.centerAndZoom(city);
            }
        }, city);
    }
    else
    {
        map.centerAndZoom(city);
    }
}