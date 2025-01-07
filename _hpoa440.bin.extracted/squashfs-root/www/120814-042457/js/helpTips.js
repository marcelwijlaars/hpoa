/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Tooltip.ShadowImage="/120814-042457/images/shadow-opacity-40.png";
Tooltip.DELAY_TIME=500;
var theHelpTooltip=null;
var theNotice=null;
var theTooltip=null;
var tipDelayTime=Tooltip.DELAY_TIME;
var hideTimerId=0;
var xOffset=20;
var yOffset=-25;
var deluxeTooltips=new DeluxeTooltips();
var cacheImage=new Image();
cacheImage.src=Tooltip.ShadowImage;
function getPointerCoords(e){
var coords=new Object();
coords.x=0;
coords.y=0;
if(!e){
var e=window.event;
}
if(e.pageX||e.pageY){
coords.x=e.pageX;
coords.y=e.pageY;
}
else if(e.clientX||e.clientY){
coords.x=e.clientX+(document.documentElement.scrollLeft?
document.documentElement.scrollLeft:
document.body.scrollLeft);
coords.y=e.clientY+(document.documentElement.scrollTop?
document.documentElement.scrollTop:
document.body.scrollTop);
}
return coords;
}
function showHelpTip(evt,elem,show,key,width){
if(!theHelpTooltip){
theHelpTooltip=document.getElementById("helpTooltip");
}
if(show){
var helpText=top.getString(key);
if(elem.getAttribute("onclick")!=null){
helpText+="<br /><br />For additional help, click the help icon.";
}
document.getElementById("tooltipText").innerHTML=helpText;
var coords=getPointerCoords(evt);
var page=getDocumentCoords(elem);
var tipWidth=200;
if(exists(width)){
tipWidth=parseInt(width);
}
theHelpTooltip.style.width=tipWidth+"px";
var height=theHelpTooltip.offsetHeight;
var x=coords.x+xOffset;
var y=coords.y+yOffset;
if(page.height>0&&page.width>0){
if(x+tipWidth>=page.right){
x=((coords.x-xOffset)-tipWidth);
}
if(x<=page.left){
x=page.left+1;
if(x+tipWidth>=(coords.x-xOffset)){
y+=height;
}
}
if(y+height>=page.bottom){
y=((page.bottom-height)-10);
}
if(y<=page.top){
y=coords.y+yOffset;
}
}
theHelpTooltip.style.left=x+"px";
theHelpTooltip.style.top=y+"px";
theHelpTooltip.style.visibility="visible";
}else{
theHelpTooltip.style.visibility="hidden";
}
}
function showTooltip(evt,elem,show,width){
clearTooltipTimer();
if(show){
try{
theTooltip=document.getElementById("tooltip");
theTooltip.style.display="block";
if(!exists(width)){
var width=200;
}
var max_width=width-20;
theTooltip.style.width=width+"px";
var titleText=elem.getAttribute('data-titleText');
var bodyText=elem.getAttribute('bodyText');
var html="";
if(bodyText){
if(titleText&&titleText!=""){
html+="<div style='padding-top: 5px; width: 100%; text-align: center;'>"+titleText+"</div>";
}
html+="<div style='padding-top: 5px; padding-left: 5px; padding-bottom: 5px; padding-right: 0px; width: 100%; '>"+bodyText+"</div>";
}else{
html+=titleText;
}
theTooltip.getElementsByTagName("div")[0].innerHTML=html;
var coords=getPointerCoords(evt);
var page=getDocumentCoords(elem);
var height=theTooltip.offsetHeight;
var tooltipULObj=document.getElementById("urlTooltipUL");
if(tooltipULObj){
var ulWidth=max_width;
if(page.width<(width+20)){
ulWidth=page.width-50;
}
tooltipULObj.style.width=ulWidth+"px";
tooltipULObj.style.maxWidth=ulWidth+"px";
}
if(page.width<(width+20)){
theTooltip.style.left=page.left+"px";
theTooltip.style.width=(page.width-12)+"px";
theTooltip.style.maxWidth=(page.width-12)+"px";
document.getElementById("internalTooltipDiv").style.width=(page.width-20)+"px";
document.getElementById("internalTooltipDiv").style.maxWidth=(page.width-20)+"px";
var tooltipULObj=document.getElementById("urlTooltipUL");
if(tooltipULObj){
tooltipULObj.style.width=(theTooltip.offsetWidth-10)+"px";
tooltipULObj.style.maxWidth=(theTooltip.offsetWidth-10)+"px";
}
}else if(((coords.x-30)+(width+10))>=page.right){
theTooltip.style.left=(page.right-width-30)+"px";
}else if(coords.x-30-2<=page.left){
theTooltip.style.left=page.left+2+"px";
}else{
theTooltip.style.left=(coords.x-30)+"px";
}
if(coords.y+6+height>page.bottom){
if(coords.y-10-height<page.top){
theTooltip.style.top=page.top+"px";
}else{
theTooltip.style.top=(coords.y-10-height)+"px";
}
}else{
theTooltip.style.top=coords.y+6+"px";
}
theTooltip.style.visibility="visible";
}catch(e){
}
}else{
killToolTip();
}
}
var TOOLTIP_HIDE_DELAY=1000;
function updateTooltipTimer(){
clearTooltipTimer();
hideTimerId=window.setTimeout(killToolTip,TOOLTIP_HIDE_DELAY);
}
function clearTooltipTimer(){
if(hideTimerId>0){
window.clearTimeout(hideTimerId);
hideTimerId=0;
}
}
function showNotice(text,title,type,width,seconds){
killNotice();
theNotice=new Notice(text,title,type,width,seconds);
theNotice.elem=document.getElementById("divNotice");
theNotice.frame=document.getElementById("notice");
theNotice.formatMessage(getDocumentCoords(theNotice.elem));
theNotice.show();
}
function killNotice(){
if(theNotice){
theNotice.hide();
}
}
function killToolTip(){
hideTimerId=0;
if(theTooltip){
theTooltip.style.visibility="hidden";
theTooltip.style.display="none";
}
}
function loadDeviceInfoTip(evt,elem,width,type){
deluxeTooltips.addTooltip(elem,width,getPointerCoords(evt),getDataFunction(type));
}
function removeDeviceInfoTip(evt,elem,force){
if(!force&&deluxeTooltips.isTooltipOpen(elem)==false){
deluxeTooltips.getTooltip(elem).coords=getPointerCoords(evt);
}else{
deluxeTooltips.removeTooltip(elem,force);
}
}
function getDataFunction(type){
var types=["device","oabay","ps","fan","zone_fan","iobay","lcd","dvd"];
var methods=[_deviceInfoTip,_oaInfoTip,_psInfoTip,_fanInfoTip,_zoneFanInfoTip,_ioInfoTip,_lcdInfoTip,_dvdInfoTip];
for(var i=0;i<types.length;i++){
if(types[i]==type){
return methods[i];
}
}
return null;
}
function generateTooltip(element,type,paramArray){
var output='';
var processor=new XsltProcessor('../Templates/tooltipContent.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('deviceType',type);
processor.addParameter('bayNumber',element.getAttribute("bayNum"));
for(var i=0;i<paramArray.length;i++){
processor.addParameter(paramArray[i][0],paramArray[i][1]);
}
output=processor.getOutput();
return(processor.hasErrors()?"":output);
}
function getHpem(element){
if(typeof(hpemObj)!='undefined'&&hpemObj){
return hpemObj;
}else{
return hpem=top.getTopology().getProxy(element.getAttribute("encNum"));
}
}
function _deviceInfoTip(element){
var hpem=getHpem(element);
var paramArray=[
['bladeInfoDOM',hpem.getBladeInfoDOM()],
['bladeMpInfo',hpem.getBladeMpInfo(element.getAttribute("bayNum"))],
['mpIpAddress',getElementValueXpath(hpem.getBladeMpInfo(element.getAttribute("bayNum")),"//hpoa:ipAddress")]
];
return generateTooltip(element,'device',paramArray);
}
function _oaInfoTip(element){
var hpem=getHpem(element);
var enclosureNumber=hpem.getEnclosureNumber();
var oaIp=getElementValueXpath(top.getTopology().getTopologyDOM(),'//hpoa:rackTopology2/hpoa:enclosures/hpoa:enclosure[hpoa:enclosureNumber="'+enclosureNumber+'"]//hpoa:encLinkOa[hpoa:activeOa="true"]/hpoa:ipAddress');
var paramArray=[
['oaInfoDoc',hpem.getOaInfoDOM()],
['oaStatusDoc',hpem.getOaStatusDOM()],
['oaNetworkInfoDoc',hpem.getOaNetworkInfoDOM(true)],
['oaIp',oaIp]
];
return generateTooltip(element,'oabay',paramArray);
}
function _psInfoTip(element){
var hpem=getHpem(element);
var paramArray=[
['psInfoDoc',hpem.getPsInfoDOM()],
['psStatusDoc',hpem.getPsStatusDOM()]
];
return generateTooltip(element,'ps',paramArray);
}
function _fanInfoTip(element,fanZone){
var hpem=getHpem(element);
var paramArray=[
['fanInfoDoc',hpem.getFanInfoDOM()],
['fanZone',assertFalse(fanZone)]
];
return generateTooltip(element,'fan',paramArray);
}
function _zoneFanInfoTip(element){
return _fanInfoTip(element,true);
}
function _ioInfoTip(element){
var hpem=getHpem(element);
var paramArray=[
['oaInfoDoc',hpem.getOaInfoDOM()],
['oaStatusDoc',hpem.getOaStatusDOM()],
['oaNetworkInfoDoc',hpem.getOaNetworkInfoDOM(true)]
];
return generateTooltip(element,'oabay',paramArray);
}
function _lcdInfoTip(element){
return "";
}
function _dvdInfoTip(element){
var encNum=element.getAttribute("encNum");
var hpem=top.getTopology().getProxy(encNum);
var paramArray=[
["encNum",encNum],
["oaMediaDeviceList",hpem.getOaMediaDeviceDOM()]
];
return generateTooltip(element,"dvd",paramArray);
}
function Notice(text,title,type,width,seconds){
var me=this;
var timerId=0;
this.top=0;
this.currHeight=0;
this.text=replaceCharacter(text,"\n","<br />");
this.title=(existsNonNull(title)&&title!=""?title:null);
this.width=(existsNonNull(width)?width:300);
this.ms=(!isNaN(seconds)&&seconds<=60?(seconds*1000):10000);
this.icon=getIcon(type);
this.autoExit=true;
this.elem=null;
this.frame=null;
function getIcon(type){
var types={0:'unknown',1:'informational',2:'normal',3:'minor',
4:'disabled',5:'critical',6:'question'};
return "/120814-042457/images/icon_status_"+(existsNonNull(type)?types[type]:"informational")+".gif";
}
function stopNoticeTimer(){
if(timerId>0){
window.clearTimeout(timerId);
timerId=0;
}
}
function startAutoExit(){
stopNoticeTimer();
me.autoExit=true;
timerId=window.setTimeout(slideDown,me.ms);
}
function stopAutoExit(){
me.autoExit=false;
stopNoticeTimer();
}
function slideUp(){
try{
if(me.frame.style.visibility=='visible'){
if(me.frame.offsetHeight<me.height){
me.top--;
me.frame.style.top=me.top+"px";
me.currHeight++;
me.frame.style.height=me.currHeight+"px";
window.setTimeout(slideUp,5);
}else{
me.frame.style.filter="progid:DXImageTransform.Microsoft.Shadow(opacity=30,color=#333333,direction=120,strength=2);";
timerId=window.setTimeout(slideDown,me.ms);
}
}
}catch(e){
top.logEvent("Notice: slideUp error: "+e.message,null,1,5);
}
}
function slideDown(){
if(me.autoExit==false){
return;
}
try{
me.frame.style.filter="";
if(me.currHeight>0){
me.top++;
me.currHeight--;
me.frame.style.height=me.currHeight+"px";
me.frame.style.top=me.top+"px";
if(me.currHeight<=0){
me.hide();
}else{
window.setTimeout(slideDown,5);
}
}
}catch(e){
top.logEvent("Notice: slideDown error: "+e.message,null,1,5);
}
}
this.formatMessage=function(pageProps){
var html="<table style='border:0px;padding:1px;margin:0px;overflow:hidden;'>";
if(pageProps.width<50){
return;
}
try{
if(this.title){
html+="<tr><td><img src='"+this.icon+"' style='border:0px;height:13px;width:13px;' /></td>";
html+="<td valign='top' style='width:100%;'><b>"+title+"</b></td><td valign='top'>";
html+="<a href='javascript:void(0);' title='"+top.getString('close')+"'>";
html+="<img src='/120814-042457/images/icon_close.gif' onmouseover='this.src=\"/120814-042457/images/icon_close_hover.gif\"'";
html+=" onmouseout='this.src=\"/120814-042457/images/icon_close.gif\"' width='11' height='11' border='0' /></a></td></tr>";
html+="<tr><td colspan='3'><br />"+this.text+"</td></tr></table>";
}else{
html+="<tr><td valign='top'><img src='"+this.icon+"' style='margin-bottom:-2px;border:0px;height:13px;width:13px;' />";
html+="&nbsp;&nbsp;"+this.text+"</td></tr></table>";
}
this.elem.style.height="auto";
this.elem.innerHTML=html;
if(this.width>pageProps.width){
this.width=pageProps.width-20;
}
this.elem.style.width=this.width+"px";
this.height=this.elem.offsetHeight;
this.elem.innerHTML="";
this.elem.style.width="0px";
this.elem.style.height="0px";
this.currHeight=2;
this.frame.style.width=this.width+"px";
this.frame.style.height="2px";
this.frame.style.left=((pageProps.right-this.width)-10)+"px";
this.top=(pageProps.bottom-12);
this.frame.style.top=this.top+"px";
this.frame.contentWindow.document.body.innerHTML=html;
}catch(e){
top.logEvent("Notice: formatMessage error: "+e.message,null,1,5);
}
}
this.show=function(){
this.frame.style.visibility="visible";
this.frame.onmouseover=stopAutoExit;
this.frame.onmouseout=startAutoExit;
this.frame.contentWindow.document.body.onclick=function(){me.hide();}
slideUp();
}
this.hide=function(){
stopNoticeTimer();
try{
me.frame.style.visibility="hidden";
me.frame.onmouseover="";
me.frame.onmouseout="";
me.frame.contentWindow.document.body.onclick="";
me.frame.contentWindow.document.body.innerHTML="";
me.frame.style.top="0px";
me.frame.style.left="0px";
me.frame.style.width="0px";
me.frame.style.height="0px";
me.frame.style.filter="";
}catch(e){}
}
}
function DeluxeTooltips(){
this.tooltips=new Array();
this.isTooltipOpen=function(elem){
if(this.tooltipExists(elem)){
var tip=this.getTooltip(elem);
if(tip!=null){
return(tip.canvas.style.display=="block");
}
}
}
this.getTooltip=function(elem){
for(var index in this.tooltips){
var tip=this.tooltips[index];
if(elem.id==tip.owner.id){
return tip;
}
}
return null;
}
this.tooltipExists=function(elem){
for(var index in this.tooltips){
var tip=this.tooltips[index];
if(elem.id==tip.owner.id){
return true;
}
}
return false;
}
this.addTooltip=function(elem,width,coords,dataFunction){
if(!(this.tooltipExists(elem))){
this.removeAllTooltips();
this.tooltips.push(new Tooltip(elem,width,coords,dataFunction));
}
}
this.removeAllTooltips=function(){
for(var index in this.tooltips){
this.tooltips[index].hide();
}
this.tooltips=new Array();
}
this.removeTooltip=function(elem,force){
for(var index in this.tooltips){
var tip=this.tooltips[index];
if(elem.id==tip.owner.id){
if(this.isTooltipOpen(elem)||force==true){
tip.hide();
this.tooltips.splice(index,1);
break;
}
}
}
}
}
function Tooltip(elem,width,coords,dataRender){
var me=this;
this.owner=elem;
this.width=width;
this.height=0;
this.coords=coords;
this.dataRender=existsNonNull(dataRender)?dataRender:null;
function getCanvas(){
var canvas=document.getElementById("deviceTooltip");
var canvasContent=document.getElementById(me.owner.id+"InfoTip");
if(!canvas){
canvas=document.createElement("div");
canvas.className="deviceInfo";
canvas.style.background="transparent";
canvas.style.border="0px";
canvas.style.padding="0px";
canvas.style.overflow="hidden";
canvas.id="deviceTooltip";
addListener(canvas,"onmouseout",function(){me.hide()});
document.getElementsByTagName("body")[0].appendChild(canvas);
}
if(canvasContent){
canvas.innerHTML=canvasContent.innerHTML;
}
return canvas;
}
this.init=function(){
this.canvas=getCanvas();
this.setPosition(this.coords);
this.timerId=window.setTimeout(function(){me.show();},tipDelayTime);
}
this.setPosition=function(coords){
var page=getDocumentCoords(this.canvas);
var shadow=document.getElementById("tooltipShadowImage");
if(shadow){
shadow.style.display="none";
}
this.canvas.style.visibility="hidden";
this.canvas.style.display="block";
this.width=(this.width>0?this.width:
(this.canvas.offsetWidth?this.canvas.offsetWidth:
this.canvas.clientWidth+2));
this.canvas.style.width=this.width+"px";
this.height=(this.height>0?this.height:
(this.canvas.offsetHeight?
this.canvas.offsetHeight:
this.canvas.clientHeight+2));
this.canvas.style.height=this.height+"px";
this.canvas.style.display="none";
this.canvas.style.visibility="visible";
var x=coords.x+18;
var y=coords.y-12;
if(page.height>0&&page.width>0){
if(x+this.width>=page.right){
x=((coords.x-10)-this.width);
}
if(x<=page.left){
x=page.left+1;
if(x+this.width>=(coords.x-10)){
y+=36;
}
}
if(y+this.height>=page.bottom){
y=((coords.y-this.height)-10);
}
if(y<=page.top){
y=page.top+1;
}
}
this.canvas.style.left=x+"px";
this.canvas.style.top=y+"px";
}
this.show=function(){
if(this.dataRender!=null){
var tooltipContent=this.dataRender(this.owner);
if(tooltipContent!=""){
this.canvas.style.height="";
this.height=0;
this.canvas.innerHTML=tooltipContent;
}
}
this.timerId=0;
this.setPosition(this.coords);
this.canvas.style.display="block";
if(!document.all){
this.createShadow();
}
}
this.hide=function(){
if(this.timerId>0){
window.clearTimeout(this.timerId);
}
var shadow=document.getElementById("tooltipShadowImage");
if(shadow){
shadow.style.height="";
shadow.style.display="none";
}
this.canvas.style.height="";
this.canvas.style.display="none";
}
this.createShadow=function(){
var shadow=document.getElementById("tooltipShadowImage");
if(!shadow){
shadow=document.createElement("IMG");
shadow.src=Tooltip.ShadowImage;
shadow.className="deviceInfoShadow";
shadow.id="tooltipShadowImage";
this.canvas.parentNode.appendChild(shadow);
}
shadow.style.left=(parseInt(this.canvas.style.left)+2)+"px";
shadow.style.top=(parseInt(this.canvas.style.top)+2)+"px";
shadow.style.zIndex=parseInt(this.canvas.parentNode.style.zIndex)+1;
shadow.style.width=this.canvas.offsetWidth+"px";
shadow.style.height=this.canvas.offsetHeight+"px";
shadow.style.display="block";
}
this.toString=function(){
return "Tooltip Class";
}
this.init();
}
