//TODO   change via env
//var base_url = 'http://localhost:3000';
//var base_url = 'http://192.168.75.131:3000';
//var base_url = 'http://www.meishikezhan.com';
//var base_url = 'http://www.yinkuaizi.com';
var base_url = 'http://www.chixinbugai.com';
var afar_url = base_url + '/desires/afar';
var close_img_url = base_url + '/assets/close.png';

(function (myWindow, myDocument) {
    if (myDocument.MEISHI_COLLECT) {
        return
    }
    myDocument.MEISHI_COLLECT = 1;
    var current_url = myWindow.location.href,
        browser = navigator.userAgent,
        body = myDocument.body,
        q = body.parentNode,
        T = browser.indexOf("MSIE") >= 0 && browser.indexOf("Opera") < 0,
        O = T ? navigator.appVersion.split(";")[1].replace(/[ ]/g, "") : "",
        C = O == "MSIE6.0",
        w = O == "MSIE7.0",
        u = O == "MSIE8.0",
        X = browser.indexOf("Opera") >= 0 ? true : false,
        h = /(webkit)[ \/]([\w.]+)/.exec(browser.toLowerCase()),
        s;

    function listen(object, event, func) {
        if (object.addEventListener) {
            object.addEventListener(event, func, false)
        } else {
            if (object.attachEvent) {
                object.attachEvent("on" + event, func)
            } else {
                object["on" + event] = func
            }
        }
    }

    function extract(str, length) {
        var result = str.slice(0, length),
            size = result.replace(/[^\x00-\xff]/g, "**").length;
        if (size <= length) {
            return result
        }
        size -= result.length;
        switch (size) {
        case 0:
            return result;
        case length:
            return str.slice(0, length >> 1);
        default:
            var offset = length - size,
                remain = str.slice(offset, length),
                remain_size = remain.replace(/[\x00-\xff]/g, "").length;
            return remain_size ? str.slice(0, offset) + extract(remain, remain_size) : str.slice(0, offset)
        }
    }

    function allocate_size() {
        var i, b, d, A, z = myDocument.documentElement;
        if (myWindow.innerHeight && myWindow.scrollMaxY) {
            i = body.scrollWidth;
            b = myWindow.innerHeight + myWindow.scrollMaxY
        } else {
            if (body.scrollHeight > body.offsetHeight) {
                i = body.scrollWidth;
                b = body.scrollHeight
            } else {
                i = body.offsetWidth;
                b = body.offsetHeight
            }
        }
        if (self.innerHeight) {
            d = self.innerWidth;
            A = self.innerHeight
        } else {
            if (z && z.clientHeight) {
                d = z.clientWidth;
                A = z.clientHeight
            } else {
                if (v) {
                    d = body.clientWidth;
                    A = body.clientHeight
                }
            }
        }
        if (b < A) {
            pageHeight = A;
            y = pageHeight
        } else {
            pageHeight = b;
            y = pageHeight
        }
        if (i < d) {
            pageWidth = d
        } else {
            pageWidth = i
        }
        return [pageWidth, pageHeight, d, A]
    }

    function crop(i, d) {
        if (i[0] && i[1] && d[0]) {
            if (!d[1]) {
                d[1] = d[0]
            }
            if (i[0] > d[0] || i[1] > d[1]) {
                var A = i[0] / i[1],
                    z = A >= d[0] / d[1];
                return z ? [d[0], parseInt(d[0] / A)] : [parseInt(d[1] * A), d[1]]
            }
        }
        return i
    }
    function sort_images(images, b) {
        b = b || 100000000;
        if (images[0].w && images[0].h) {
            for (var i = 0, j = i.length; i < j; i++) {
                images[i].power = -1 / b * Math.abs(images[i].w * images[i].h - b) + 1
            }
        } else {
            var a, w, h;
            for (var i = 0, j = i.length; i < j; i++) {
                a = new Image();
                a.src = images[D].src;
                w = a.width;
                h = a.height;
                images[i].power = -1 / b * Math.abs(w * h - b) + 1
            }
        }
        images.sort(function (x, y) {
            if (x.power > y.power) {
                return -1
            } else {
                return 1
            }
        });
        return images
    }

    function get_image(img) {
        var source = img.getAttribute("data-src"),
            href = source ? source : img.src,
            i = new Image(),
            small = [150, 150],
            large = [200, 200];
        i.src = href;
        var d = crop([i.width, i.height], small),
            b = crop([i.width, i.height], large);
        return {
            w: i.width,
            h: i.height,
            sw: d[0],
            sh: d[1],
            ssw: b[0],
            ssh: b[1],
            st: (small[1] - d[1]) / 2,
            sst: (large[1] - b[1]) / 2,
            src: href,
            img: img,
            alt: img.alt
        }
    }

    function get_images() {
        var result = [],
            list = myDocument.getElementsByTagName("img");
        for (var i = 0; i < list.length; i++) {
            var image = get_image(list[i]);
            if (image.w >= 80 && image.h >= 80) {
                result.push(image)
            }
        }
        if (result.length) {
            return sort_images(result)
        } else {
            return []
        }
    }

    function transfer_image(img_src, img_alt) {
        var url = afar_url;
        url += "?img=" + encodeURIComponent(img_src) + "&url=" + encodeURIComponent((img_src == current_url ? myDocument.referrer || current_url : current_url).replace(/&ref=[^&]+/ig, "").replace(/&ali_trackid=[^&]+/ig, "")) + "&alt=" + encodeURI(extract(img_alt, 60)) + "&title=" + encodeURI(extract(myDocument.title, 80));
        myWindow.open(url, "chixinbugai" + new Date().getTime(), "status=no,resizable=no,scrollbars=no,personalbar=no,directories=no,location=no,toolbar=no,menubar=no,width=850,height=550,left=60,top=80")
    }
    function check() {
        var regs = [
            [/^https?:\/\/.*?\.?chixinbugai\.com\//, "很抱歉，不能收集本站的图片，请去其他网站把美食收集过来吧～"],
            [/^file/, "很抱歉，不支持这种方式的收集"]
        ];
        for (var i = 0; i < regs.length; i++) {
            if (regs[i][0].test(current_url)) {
                alert(regs[i][1]);
                return false
            }
        }
        return true
    }
    if (!check()) {
        myDocument.MEISHI_COLLECT = 0;
        return
    }
    var images = get_images();
    if (images.length <= 0) {
        alert("本页面没有适合的图片，请换一个页面试试吧~");
        myDocument.MEISHI_COLLECT = 0;
        return
    }
    function close() {
        var b = mask.parentNode;
        b.removeChild(mask);
        b.removeChild(main_panel);
        myDocument.MEISHI_COLLECT = 0;
        if (!C) {
            body.style.paddingRight = I;
            q.style.overflowX = V;
            q.style.overflowY = S;
            body.style.overflowX = ac;
            body.style.overflowY = ab
        }
        return false
    }
    var prefix = "chixinbugai_",
        o = "#" + prefix + "main",
        ao = "background",
        r = "position:relative",
        ap = ao + "-color:",
        p = "url(" + close_img_url + ")",
        Z = "z-index:90000000",
        styles = [" #", prefix, "mask{position:fixed;", Z, "0;top:0;right:0;bottom:0;left:0;", ap, " #fff;opacity:.8;filter:alpha(opacity=80);} ", o, "{position: absolute;width:100%;line-height:1.2;padding:0;", Z, "1;top:0;left:0;", ap, "transparent;} #", prefix, "container{zoom:1;width:1040px;margin:0 auto;padding-bottom:24px;color:#666} #", prefix, "container:after{content:'\\0020';display:block;height:0;overflow:hidden;clear:both;} #", prefix, "panel{", r, ";float:right;", Z, "4;height:0px;width:0px;} #", prefix, "panel a:link,#", prefix, "panel a:visited{position:fixed;_position:absolute;top:12px;right:30px;_right:12px;width:80px;height:80px;padding:0;margin:0;", ap, "transparent;", ao, "-image:", p, "} #", prefix, "panel a:hover{", ao, "-position:0 -80px} ", o, " .", prefix, "unit{", r, ";float:left;+display:inline;padding:0;margin:0;height:200px;width:200px;overflow:hidden;margin:6px 3px 0;", Z, "2;border:1px solid #e7e7e7;text-align: center;", ap, "#fff;} ", o, " .", prefix, "unit .tpmImg{", r, ";width:100%;height:100%;margin:0;padding:0;} ", o, " .", prefix, "unit a{display:block;overflow:hidden;width:200px;height:200px;margin:0;padding:0;text-align:center;", ao, ":none !important} ", o, " .", prefix, "unit img{display:block;padding:0;margin:0 auto;border:0 none;vertical-align:top;} ", o, " .", prefix, "unit a *{cursor:pointer} ", o, " .", prefix, "unit_sm,", o, " .", prefix, "unit_sm a{width:150px;height:150px;} ", o, " .", prefix, "dimen{", r, ";width:56px;margin:-16px auto 0;padding:0 2px 1px;text-align:center;font-size:10px;font-family:tahoma,arial,sans-serif;", Z, "3;", ao, ":#7A2127;opacity:.7;filter:alpha(opacity=70);border-radius:5px;color:#fff} ", o, " .", prefix, "cover{position:absolute;width:200px;height:200px;top:0;left:0;", ap, "#000;opacity:.15;filter:alpha(opacity=15);display:none} ", o, " .", prefix, "cross{position:absolute;width:100px;height:59px;line-height:16px;padding:41px 0 0;top:50px;left:50px;", ao, ":", p, " no-repeat 0 -160px;border:0 none;} ", o, " .", prefix, "action:link .", prefix, "cross,", o, " .", prefix, "action:visited .", prefix, "cross{display:none;} ", o, " .", prefix, "action:hover .", prefix, "cross,", o, " .", prefix, "action:hover .", prefix, "cover{display:block;} ", o, " .", prefix, "unit_sm .", prefix, "cross{top:25px;left:25px;} ", o, " .", prefix, "seper{float:left;border-top:1px solid #eaeaea;padding:24px 0 0;margin:24px 0 0;color:#ebebeb;font:normal 16px/20px verdana;} ", o, " img{margin:0 auto} "].join(""),
        rectangle = allocate_size(),
        ak = (rectangle[0] - 1040) / 2,
        style_sheet = myDocument.getElementById("MEISHISHEET"),
        mask = myDocument.createElement("div"),
        main_panel = myDocument.createElement("div"),
        container = myDocument.createElement("div"),
        sub_panel = myDocument.createElement("div");
    styles += "#chixinbugai_main{width:auto}#chixinbugai_main .chixinbugai_seper{width:" + rectangle[0] + "px;margin-left:-" + ak + "px;padding-left:" + (ak + 12) + "px}";
    if (C) {
        styles += "#chixinbugai_mask{position:absolute;width:" + rectangle[0] + "px;height:" + rectangle[1] + "px;}"
    }
    if (!style_sheet || style_sheet.tagName.toLowerCase() !== "style") {
        style_sheet = myDocument.createElement("style");
        style_sheet.id = "MEISHISHEET";
        if (T) {
            style_sheet.type = "text/css";
            style_sheet.styleSheet.cssText = styles;
            myDocument.getElementsByTagName("head")[0].appendChild(style_sheet)
        } else {
            if ((browser.lastIndexOf("Safari/") > 0) && parseInt(browser.substr(browser.lastIndexOf("Safari/") + 7, 7)) < 533) {
                style_sheet.innerText = styles;
                body.appendChild(style_sheet)
            } else {
                style_sheet.innerHTML = styles;
                body.appendChild(style_sheet)
            }
        }
    }
    mask.setAttribute("id", "chixinbugai_mask");
    listen(mask, "click", close);
    body.appendChild(mask);
    if (myDocument.defaultView) {
        var I = myDocument.defaultView.getComputedStyle(body).paddingRight,
            V = myDocument.defaultView.getComputedStyle(q).overflowX,
            S = myDocument.defaultView.getComputedStyle(q).overflowY,
            ac = myDocument.defaultView.getComputedStyle(body).overflowX,
            ab = myDocument.defaultView.getComputedStyle(body).overflowY
    } else {
        if (q.currentStyle) {
            var I = body.currentStyle.paddingRight,
                V = q.currentStyle.overflowX,
                S = q.currentStyle.overflowY,
                ac = body.currentStyle.overflowX,
                ab = body.currentStyle.overflowY
        }
    }
    if (!C) {
        var N = main_panel.style;
        body.style.paddingRight = "17px";
        body.style.overflowY = body.style.overflowX = N.overflowX = "hidden";
        if (T || X) {
            q.style.overflowY = q.style.overflowX = "hidden"
        }
        N.overflowY = "scroll";
        N.top = Math.max(body.scrollTop || 0, myDocument.documentElement.scrollTop || 0) + "px";
        N.width = (rectangle[0] + (w ? 17 : u ? 17 : 0)) + "px";
        N.height = rectangle[3] + "px"
    }
    main_panel.setAttribute("id", "chixinbugai_main");
    listen(main_panel, "click", function (z) {
        var i = z.srcElement || z.target,
            b = i.tagName.toLowerCase(),
            d = i.parentNode.tagName.toLowerCase();
        if (b !== "a" && b !== "img" && d !== "a" && i.className !== "chixinbugai_dimen") {
            close()
        }
    });
    body.appendChild(main_panel);
    container.setAttribute("id", "chixinbugai_container");
    main_panel.appendChild(container);
    var f = {},
        af = ['<div class="chixinbugai_unit"><span style="float:left;margin-top:90px;margin-left:15px;font-size:24px;color:#7A2127">收集到吃心不改</span></div>'].join(""),
        aj = "",
        E = 0,
        aa = 0;
    for (var i = 0; i < images.length; i++) {
        if (!f[images[i].src]) {
            aa = s;
            E = images[i].st;
            imw = images[i].sw;
            imh = images[i].sh;

            af += [aa, '<div class="chixinbugai_unit ', aj, '"><div class="tpmImg"><a class="chixinbugai_action" href="javascript:;"><img style="margin-top:', E, 'px" width="', imw, '" height="', imh, '" src="', images[i].src, '" alt="', images[i].alt, '" /><div class="chixinbugai_cover"></div><div class="chixinbugai_cross"></div></a></div><div class="chixinbugai_dimen">', images[i].w, "x", images[i].h, "</div></div>"].join("");
            f[images[i].src] = 1;
            if (aa) {
                aa = ""
            }
        }
    }
    container.innerHTML = af;
    listen(container, "click", function (A) {
        A = A || myWindow.event;
        var z = A.srcElement || A.target,
            b = z.tagName.toLowerCase(),
            i = z.parentNode.tagName.toLowerCase(),
            d;
        if (i === "a" || b === "a") {
            if (i === "a") {
                z = z.parentNode
}
d = z.getElementsByTagName("img")[0];
if (d) {
    transfer_image(d.src, d.getAttribute("alt"))
}
}
});
sub_panel.id = "chixinbugai_panel";
sub_panel.innerHTML = '<a id="chixinbugai_closelink" href="javascript:;" target="_self" title="关闭"></a>';
main_panel.insertBefore(sub_panel, container);
myDocument.getElementById("chixinbugai_closelink").onclick = close;
})(window, document);