/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function MxBrowserIsGecko()
{
return(navigator.userAgent.toLowerCase().indexOf("gecko")>=0);
}
function MxBrowserGetBodyWidth(nAdjust_ie,nAdjust_ns)
{
var o=MxBrowserIsGecko()?document.getElementById("ID_BODY_PROXY"):document.body;
if(o==null)o=document.body;
var v=MxBrowserIsGecko()?o.offsetWidth+nAdjust_ns:o.offsetWidth+nAdjust_ie;
return v;
}
function MxBrowserGetBodyHeight(nAdjust_ie,nAdjust_ns)
{
var o=MxBrowserIsGecko()?document.getElementById("ID_BODY_PROXY"):document.body;
if(o==null)o=document.body;
var v=MxBrowserIsGecko()?o.offsetHeight+nAdjust_ns:o.offsetHeight+nAdjust_ie;
return v;
}
function osIsLinux(){
return(navigator.userAgent.toLowerCase().indexOf("linux")>-1);
}
function getBodyWidth(){
if(typeof(document.width)!='undefined'){
return document.width;
}
else if(typeof(document.body.offsetWidth)!='undefined'){
return document.body.offsetWidth;
}
else{
return 0;
}
}
function MxBrowserGetLastModified(szId)
{
var oDoc=null;
try{
oDoc=document.getElementById(szId).contentWindow.document;
}catch(e){
return null;
}
return oDoc.lastModified;
}
function MxBrowserRefreshFrame(oFrame)
{
if(oFrame!=null&&oFrame.contentWindow!=null)
{
var szUrl=oFrame.contentWindow.document.location.href;
if(szUrl.indexOf("#")>=0)
{
szUrl=szUrl.split("#")[0];
if(MxBrowserIsGecko())
{
oFrame.contentWindow.document.location.replace(szUrl);
}
}
oFrame.contentWindow.document.location.replace(szUrl);
}
}
function MxBrowserGetTopmost(szStopAt)
{
var w=window;
while(true)
{
if(szStopAt!=null&&w.document.location.href.indexOf(szStopAt)>0)
break;
if(w==w.top)
break;
try{
w.parent.document.lastModified;
}catch(e){
break;
}
w=w.parent;
}
return w;
}
function MxBrowserCssCheck(szCss)
{
var oLinks=document.getElementsByTagName("LINK");
for(var i=0;i<oLinks.length;i++)
{
var szHref="";
if(typeof(oLinks[i].href)!="undefined")
szHref=oLinks[i].href;
if(szHref==szCss)
return true;
if(szCss.charAt(0)=='/')
{
if(szHref.indexOf(szCss)>=0)
return true;
}
else
{
if(szHref.indexOf("/"+szCss)>=0)
return true;
}
}
return false;
}
function MxBrowserCssLink(szCss,szMedia)
{
var oHead=document.getElementsByTagName("HEAD")[0];
if(oHead==null)
return;
var oLink=document.createElement("LINK");
oLink.rel="stylesheet";
oLink.type="text/css";
if(szMedia!=null)
oLink.media=szMedia;
oLink.href=szCss;
oHead.appendChild(oLink);
}
function MxBrowserCssAdd(szCss,szMedia)
{
if(!MxBrowserCssCheck(szCss))
{
MxBrowserCssLink(szCss,szMedia);
}
}
