function waterfall(url) {
    KISSY.use("waterfall,ajax,template,node,button", function(S, Waterfall, io, Template, Node, Button) {
        var $ = Node.all;
        var tpl = S.Template($('#tpl').html()),
            nextpage = 0,
            waterfall = new Waterfall.Loader({
            container:"#waterfall_container",
            load:function(success, end) {
                $('#loading_pins').show();
                S.ajax({
                    data:{ 'page': nextpage },
                    url: url, //'http://api.flickr.com/services/rest/',
                    dataType: "json",
                    json: "jsoncallback",
                    success: function(d) {
                        // 拼装每页数据
                        var items = [];
                        S.each(d.items, function(item) {
                            item.height = Math.round(Math.random()*(300 - 180) + 180); // fake height
                            items.push(new S.Node(tpl.render(item)));
                        });

                        // 如果到最后一页了, 也结束加载
                        nextpage = parseInt(d.page) + 1;
                        if (nextpage > parseInt(d.pages)) {
                            end();
                            return;
                        }

                        success(items);
                    },
                    complete: function() {
                        $('#loading_pins').hide();
                    }
                });
            },
            minColCount:4,
            colWidth:240
        });

        // scrollTo
        $('#BackToTop').on('click', function(e) {
            e.halt();
            e.preventDefault();
            $(window).stop();
            $(window).animate({
                scrollTop:0
            },1,"easeOut");
        });

        var b1 = new Button({
            content: "停止加载",
            render: "#button_container",
            prefixCls: "goog-"
        });

        // 点击按钮后, 停止瀑布图效果
        b1.render();
        b1.on("click", function() {
            waterfall.destroy();
        });
    });
};