var map = null;

function add_fields_with_map(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).before(content.replace(regexp, new_id));

  alert("helo");
  parepare_map();
}

$(document).ready(function(){
    parepare_map();
});

function parepare_map() {
    map = new BMap.Map("map_container");          // 创建地图实例

    var place = $(".map_place").val();
    var street = $(".map_street").val();
    var city = $(".map_city :selected").text();
    update_map(city, street, place); // 初始化地图

    map.enableScrollWheelZoom();  // 开启鼠标滚轮缩放
    map.enableKeyboard();         // 开启键盘控制
    map.enableContinuousZoom();   // 开启连续缩放效果
    map.enableInertialDragging(); // 开启惯性拖拽效果

    $(".map_city").change(function(){
        var place = $(".map_place").val();
        var street = $(".map_street").val();
        var city = $(".map_city :selected").text();
        update_map(city, street, place);
    });

    $(".map_street").change(function(){
        var place = $(".map_place").val();
        var street = $(".map_street").val();
        var city = $(".map_city :selected").text();
        update_map(city, street, place);
    });

    $(".map_place").change(function(){
        var place = $(".map_place").val();
        var street = $(".map_street").val();
        var city = $(".map_city :selected").text();
        update_map(city, street, place);
    });
}

function update_map(city, street, place) {
    if (street != null || place != null)
    {
        var myGeo = new BMap.Geocoder(); // 创建地址解析器实例
        // 将地址解析结果显示在地图上,并调整地图视野
        myGeo.getPoint( city +  " " + street + " " + place, function(point){
            if (point) {
                map.centerAndZoom(point, 16);
                map.addOverlay(new BMap.Marker(point));

                $(".map_point").val(point.lng + "," + point.lat);
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