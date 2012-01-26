//TODO   change via env
//var base_url = 'http://192.168.75.131:3000';
var base_url = 'http://www.meishikezhan.com';
var afar_url = base_url + '/desires/afar';
var close_img_url = base_url + '/assets/collout.gif';

(function (c, t) {
    if (t.MEISHI_COLLECT) {
        return
    }
    t.MEISHI_COLLECT = 1;
    var n = c.location,
        e = n.href,
        x = navigator.userAgent,
        v = t.body,
        q = v.parentNode,
        T = x.indexOf("MSIE") >= 0 && x.indexOf("Opera") < 0,
        O = T ? navigator.appVersion.split(";")[1].replace(/[ ]/g, "") : "",
        C = O == "MSIE6.0",
        w = O == "MSIE7.0",
        u = O == "MSIE8.0",
        X = x.indexOf("Opera") >= 0 ? true : false,
        h = /(webkit)[ \/]([\w.]+)/.exec(x.toLowerCase()),
        ae = afar_url,
        s;

    function m(i, b, d) {
        if (i.addEventListener) {
            i.addEventListener(b, d, false)
        } else {
            if (i.attachEvent) {
                i.attachEvent("on" + b, d)
            } else {
                i["on" + b] = d
            }
        }
    }
    function M(D, H) {
        var A = D.slice(0, H),
            B = A.replace(/[^\x00-\xff]/g, "**").length;
        if (B <= H) {
            return A
        }
        B -= A.length;
        switch (B) {
        case 0:
            return A;
        case H:
            return D.slice(0, H >> 1);
        default:
            var d = H - B,
                b = D.slice(d, H),
                z = b.replace(/[\x00-\xff]/g, "").length;
            return z ? D.slice(0, d) + M(b, z) : D.slice(0, d)
        }
    }
    function j(z, B, i, d) {
        var A = d ? z.substr(0, B) : M(z, B);
        return A == z ? A : A + (typeof i === "undefined" ? "â€¦" : i)
    }
    function R() {
        var i, b, d, A, z = t.documentElement;
        if (c.innerHeight && c.scrollMaxY) {
            i = v.scrollWidth;
            b = c.innerHeight + c.scrollMaxY
        } else {
            if (v.scrollHeight > v.offsetHeight) {
                i = v.scrollWidth;
                b = v.scrollHeight
            } else {
                i = v.offsetWidth;
                b = v.offsetHeight
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
                    d = v.clientWidth;
                    A = v.clientHeight
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
    function k(i, d) {
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
    function G(d, b) {
        b = b || 100000000;
        if (d[0].w && d[0].h) {
            for (var D = 0, B = d.length; D < B; D++) {
                d[D].power = -1 / b * Math.abs(d[D].w * d[D].h - b) + 1
            }
        } else {
            var A, H, z;
            for (var D = 0, B = d.length; D < B; D++) {
                A = new Image();
                A.src = d[D].src;
                H = A.width;
                z = A.height;
                d[D].power = -1 / b * Math.abs(H * z - b) + 1
            }
        }
        d.sort(function (L, i) {
            if (L.power > i.power) {
                return -1
            } else {
                return 1
            }
        });
        return d
    }
    function F(A) {
        var D = A.getAttribute("data-src"),
            H = D ? D : A.src,
            i = new Image(),
            B = [150, 150],
            z = [200, 200];
        i.src = H;
        var d = k([i.width, i.height], z),
            b = k([i.width, i.height], B);
        return {
            w: i.width,
            h: i.height,
            sw: d[0],
            sh: d[1],
            ssw: b[0],
            ssh: b[1],
            st: (z[1] - d[1]) / 2,
            sst: (B[1] - b[1]) / 2,
            src: H,
            img: A,
            alt: A.alt
        }
    }
    function P() {
        var A = [],
            z = t.getElementsByTagName("img");
        for (var d = 0; d < z.length; d++) {
            var b = F(z[d]);
            if (b.w >= 80 && b.h >= 80) {
                A.push(b)
            }
        }
        if (A.length) {
            return G(A)
        } else {
            return []
        }
    }
    function g(i, d) {
        var b = ae;
        b += "?img=" + encodeURIComponent(i) + "&url=" + encodeURIComponent((i == e ? t.referrer || e : e).replace(/&ref=[^&]+/ig, "").replace(/&ali_trackid=[^&]+/ig, "")) + "&alt=" + encodeURI(j(d, 60)) + "&title=" + encodeURI(j(t.title, 80));
        c.open(b, "meishikezhan" + new Date().getTime(), "status=no,resizable=no,scrollbars=no,personalbar=no,directories=no,location=no,toolbar=no,menubar=no,width=830,height=530,left=60,top=80")
    }
    function Y() {
        var b = [
            [/^https?:\/\/.*?\.?meishikezhan\.com\//, "很抱歉，不能抓取本站的图片，请去其他网站抓取吧～"],
            [/^file/, "æœ¬åœ°ç”µè„‘é‡Œçš„å›¾ç‰‡æ˜¯ä¸èƒ½æŠ“å–çš„ï¼ŒåŽ»ç½‘é¡µä¸ŠæŠ“å–å›¾ç‰‡å§~"]
        ];
        for (var d = 0; d < b.length; d++) {
            if (b[d][0].test(e)) {
                alert(b[d][1]);
                return false
            }
        }
        return true
    }
    if (!Y()) {
        t.MEISHI_COLLECT = 0;
        return
    }
    var Q = P();
    if (Q.length <= 0) {
        alert("本页面没有适合的图片，请换一个页面试试吧~");
        t.MEISHI_COLLECT = 0;
        return
    }
    function ah() {
        var b = ai.parentNode;
        b.removeChild(ai);
        b.removeChild(ad);
        t.MEISHI_COLLECT = 0;
        if (!C) {
            v.style.paddingRight = I;
            q.style.overflowX = V;
            q.style.overflowY = S;
            v.style.overflowX = ac;
            v.style.overflowY = ab
        }
        return false
    }
    var an = "meishikezhan_",
        o = "#" + an + "main",
        ao = "background",
        r = "position:relative",
        ap = ao + "-color:",
        p = "url(" + close_img_url + ")",
        Z = "z-index:90000000",
        ag = [" #", an, "mask{position:fixed;", Z, "0;top:0;right:0;bottom:0;left:0;", ap, " #000;opacity:.7;filter:alpha(opacity=70);} ", o, "{position: absolute;width:100%;line-height:1.2;padding:0;", Z, "1;top:0;left:0;", ap, "transparent;} #", an, "container{zoom:1;width:904px;margin:0 auto;padding-bottom:24px;color:#666} #", an, "container:after{content:'\\0020';display:block;height:0;overflow:hidden;clear:both;} #", an, "panel{", r, ";float:right;", Z, "4;height:0px;width:0px;} #", an, "panel a:link,#", an, "panel a:visited{position:fixed;_position:absolute;top:12px;right:30px;_right:12px;width:80px;height:80px;padding:0;margin:0;", ap, "transparent;", ao, "-image:", p, "} #", an, "panel a:hover{", ao, "-position:0 -80px} ", o, " .", an, "unit{", r, ";float:left;+display:inline;padding:0;margin:0;height:200px;width:200px;overflow:hidden;margin:24px 12px 0;", Z, "2;border:1px solid #e7e7e7;text-align: center;", ap, "#fff;} ", o, " .", an, "unit .tpmImg{", r, ";width:100%;height:100%;margin:0;padding:0;} ", o, " .", an, "unit a{display:block;overflow:hidden;width:200px;height:200px;margin:0;padding:0;text-align:center;", ao, ":none !important} ", o, " .", an, "unit img{display:block;padding:0;margin:0 auto;border:0 none;vertical-align:top;} ", o, " .", an, "unit a *{cursor:pointer} ", o, " .", an, "unit_sm,", o, " .", an, "unit_sm a{width:150px;height:150px;} ", o, " .", an, "dimen{", r, ";width:56px;margin:-16px auto 0;padding:0 2px 1px;text-align:center;font-size:10px;font-family:tahoma,arial,sans-serif;", Z, "3;", ao, ":#000;opacity:.9;filter:alpha(opacity=90);border-radius:3px;color:#fff} ", o, " .", an, "cover{position:absolute;width:200px;height:200px;top:0;left:0;", ap, "#000;opacity:.15;filter:alpha(opacity=15);display:none} ", o, " .", an, "cross{position:absolute;width:100px;height:59px;line-height:16px;padding:41px 0 0;top:50px;left:50px;", ao, ":", p, " no-repeat 0 -160px;border:0 none;} ", o, " .", an, "action:link .", an, "cross,", o, " .", an, "action:visited .", an, "cross{display:none;} ", o, " .", an, "action:hover .", an, "cross,", o, " .", an, "action:hover .", an, "cover{display:block;} ", o, " .", an, "unit_sm .", an, "cross{top:25px;left:25px;} ", o, " .", an, "seper{float:left;border-top:1px solid #eaeaea;padding:24px 0 0;margin:24px 0 0;color:#ebebeb;font:normal 16px/20px tahoma;} ", o, " img{margin:0 auto} "].join(""),
        l = R(),
        ak = (l[0] - 904) / 2,
        a = "MEISHISHEET",
        K = t.getElementById(a),
        ai = t.createElement("div"),
        ad = t.createElement("div"),
        am = t.createElement("div"),
        J = t.createElement("div");
    ag += "#meishikezhan_main{width:auto}#meishikezhan_main .meishikezhan_seper{width:" + l[0] + "px;margin-left:-" + ak + "px;padding-left:" + (ak + 12) + "px}";
    if (C) {
        ag += "#meishikezhan_mask{position:absolute;width:" + l[0] + "px;height:" + l[1] + "px;}"
    }
    if (!K || K.tagName.toLowerCase() !== "style") {
        K = t.createElement("style");
        K.id = "MEISHISHEET";
        if (T) {
            K.type = "text/css";
            K.styleSheet.cssText = ag;
            t.getElementsByTagName("head")[0].appendChild(K)
        } else {
            if ((x.lastIndexOf("Safari/") > 0) && parseInt(x.substr(x.lastIndexOf("Safari/") + 7, 7)) < 533) {
                K.innerText = ag;
                v.appendChild(K)
            } else {
                K.innerHTML = ag;
                v.appendChild(K)
            }
        }
    }
    ai.setAttribute("id", "meishikezhan_mask");
    m(ai, "click", ah);
    v.appendChild(ai);
    if (t.defaultView) {
        var I = t.defaultView.getComputedStyle(v).paddingRight,
            V = t.defaultView.getComputedStyle(q).overflowX,
            S = t.defaultView.getComputedStyle(q).overflowY,
            ac = t.defaultView.getComputedStyle(v).overflowX,
            ab = t.defaultView.getComputedStyle(v).overflowY
    } else {
        if (q.currentStyle) {
            var I = v.currentStyle.paddingRight,
                V = q.currentStyle.overflowX,
                S = q.currentStyle.overflowY,
                ac = v.currentStyle.overflowX,
                ab = v.currentStyle.overflowY
        }
    }
    if (!C) {
        var N = ad.style;
        v.style.paddingRight = "17px";
        v.style.overflowY = v.style.overflowX = N.overflowX = "hidden";
        if (T || X) {
            q.style.overflowY = q.style.overflowX = "hidden"
        }
        N.overflowY = "scroll";
        N.top = Math.max(v.scrollTop || 0, t.documentElement.scrollTop || 0) + "px";
        N.width = (l[0] + (w ? 17 : u ? 17 : 0)) + "px";
        N.height = l[3] + "px"
    }
    ad.setAttribute("id", "meishikezhan_main");
    m(ad, "click", function (z) {
        var i = z.srcElement || z.target,
            b = i.tagName.toLowerCase(),
            d = i.parentNode.tagName.toLowerCase();
        if (b !== "a" && b !== "img" && d !== "a" && i.className !== "meishikezhan_dimen") {
            ah()
        }
    });
    v.appendChild(ad);
    am.setAttribute("id", "meishikezhan_container");
    ad.appendChild(am);
    var f = {},
        af = "",
        aj = "",
        E = 0,
        aa = 0;
    for (var al = 0; al < Q.length; al++) {
        if (!f[Q[al].src]) {
            if (Q[al].power < 0.00015) {
                aj = "meishikezhan_unit_sm";
                E = Q[al].sst;
                imw = Q[al].ssw;
                imh = Q[al].ssh;
                if (typeof aa != "string") {
                    aa = '<div class="meishikezhan_seper" ' + (aa == s ? "" : 'style="border-top:0 none;margin-top:0;"') + ">这些图片太小了哦，你确定要收集吗？</div>"
                }
            } else {
                aa = s;
                E = Q[al].st;
                imw = Q[al].sw;
                imh = Q[al].sh
            }
            af += [aa, '<div class="meishikezhan_unit ', aj, '"><div class="tpmImg"><a class="meishikezhan_action" href="javascript:;"><img style="margin-top:', E, 'px" width="', imw, '" height="', imh, '" src="', Q[al].src, '" alt="', Q[al].alt, '" /><div class="meishikezhan_cover"></div><div class="meishikezhan_cross"></div></a></div><div class="meishikezhan_dimen">', Q[al].w, "x", Q[al].h, "</div></div>"].join("");
            f[Q[al].src] = 1;
            if (aa) {
                aa = ""
            }
        }
    }
    am.innerHTML = af;
    m(am, "click", function (A) {
        A = A || c.event;
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
                g(d.src, d.getAttribute("alt"))
            }
        }
    });
    J.id = "meishikezhan_panel";
    J.innerHTML = '<a id="meishikezhan_closelink" href="javascript:;" target="_self" title="å…³é—­"></a>';
    ad.insertBefore(J, am);
    t.getElementById("meishikezhan_closelink").onclick = ah
})(window, document);