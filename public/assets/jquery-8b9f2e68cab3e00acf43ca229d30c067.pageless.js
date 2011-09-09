// =======================================================================
// PageLess - endless page
//
// Pageless is a jQuery plugin.
// As you scroll down you see more results coming back at you automatically.
// It provides an automatic pagination in an accessible way : if javascript 
// is disabled your standard pagination is supposed to work.
//
// Licensed under the MIT:
// http://www.opensource.org/licenses/mit-license.php
//
// Parameters:
//    currentPage: current page (params[:page])
//    distance: distance to the end of page in px when ajax query is fired
//    loader: selector of the loader div (ajax activity indicator)
//    loaderHtml: html code of the div if loader not used
//    loaderImage: image inside the loader
//    loaderMsg: displayed ajax message
//    pagination: selector of the paginator divs. 
//                if javascript is disabled paginator is provided
//    params: paramaters for the ajax query, you can pass auth_token here
//    totalPages: total number of pages
//    url: URL used to request more data
//
// Callback Parameters:
//    scrape: A function to modify the incoming data.
//    complete: A function to call when a new page has been loaded (optional)
//    end: A function to call when the last page has been loaded (optional)
//
// Usage:
//   $('#results').pageless({ totalPages: 10
//                          , url: '/articles/'
//                          , loaderMsg: 'Loading more results'
//                          });
//
// Requires: jquery
//
// Author: Jean-S��bastien Ney (https://github.com/jney)
//
// Contributors:
//   Alexander Lang (https://github.com/langalex)
//   Lukas Rieder (https://github.com/Overbryd)
//
// Thanks to:
//  * codemonky.com/post/34940898
//  * www.unspace.ca/discover/pageless/
//  * famspam.com/facebox
// =======================================================================
(function(a){var b=!1,c=!b,d,e=b,f,g=".pageless",h="scroll"+g,i="resize"+g,j={container:window,currentPage:1,distance:100,pagination:".pagination",params:{},url:location.href,loaderImage:"/images/pageless/load.gif"},k,l;a.pageless=function(b){a.isFunction(b)?j.call():n(b)};var m=function(){return j.loaderHtml||'<div id="pageless-loader" style="display:none;text-align:center;width:100%;">  <div class="msg" style="color:#e9e9e9;font-size:2em"></div>  <img src="'+j.loaderImage+'" alt="loading more results" style="margin:10px auto" /></div>'},n=function(b){if(j.inited)return;j.inited=c,b&&a.extend(j,b),k=j.container,l=a(k),j.pagination&&a(j.pagination).remove(),r()};a.fn.pageless=function(b){var c=a(this),e=a(b.loader,c);n(b),d=c,b.loader&&e.length?f=e:(f=a(m()),c.append(f),b.loaderHtml||a("#pageless-loader .msg").html(b.loaderMsg))};var o=function(a){(e=a)?f&&f.fadeIn("normal"):f&&f.fadeOut("normal")},p=function(){return k===window?a(document).height()-l.scrollTop()-l.height():l[0].scrollHeight-l.scrollTop()-l.height()},q=function(){l.unbind(g)},r=function(){l.bind(h+" "+i,s).trigger(h)},s=function(){if(j.totalPages<=j.currentPage){q(),j.end&&j.end.call();return}!e&&p()<j.distance&&(o(c),j.currentPage++,a.extend(j.params,{page:j.currentPage}),a.get(j.url,j.params,function(c){a.isFunction(j.scrape)?j.scrape(c):c,f?f.before(c):d.append(c),o(b),j.complete&&j.complete.call()},"html"))}})(jQuery)