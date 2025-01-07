/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var connectionEnum={
defaultMode:'DefaultMode',
extraMode:'ExtraMode',
tweakMode:'TweakMode'
};
var numMaxConnections=MAX_CONNECTIONS();
var _browserInfo={
agent:"",
platform:"",
browserName:"",
browserVersion:"",
mobileBrowser:false,
supportsDocParam:true,
supportsIncludes:true,
browserList:[
["msie","Internet Explorer"],
["trident","Internet Explorer"],
["firefox","Firefox"],
["seamonkey","SeaMonkey"],
["chrome","Chrome"],
["safari","Safari"],
["opera","Opera"],
["konqueror","Konqueror"],
["omniweb","OmniWeb"],
["gecko","Gecko Based"],
["webtv","WebTV"],
["icab","iCab"]
],
agentContains:function(text){
return(this.agent.indexOf(text)!=-1);
},
compatCheck:function(version,agentArray){
if(parseFloat(version)>=7.0){
for(var i=0;i<agentArray.length;i++){
if(agentArray[i].indexOf("trident/")>-1){
var triVersion=parseFloat(agentArray[i].split("/")[1]);
if(triVersion>=4.0){
var trueVersion=parseFloat(triVersion+4.0);
if(trueVersion!=version){
return trueVersion.toFixed(1)+" (Compatibility)";
}
}
break;
}
}
}
return version;
},
getBrowserVersion:function(){
var slashParts=this.agent.split("/");
var spaceParts=this.agent.split(" ");
var semiParts=this.agent.split(";");
var i;
switch(this.browserName){
case "Internet Explorer":
for(i=0;i<semiParts.length;i++){
if(semiParts[i].indexOf("msie")!=-1){
this.browserVersion=this.compatCheck(semiParts[i].substring(6),semiParts);
break;
}else if(semiParts[i].indexOf("rv:")!=-1){
this.browserVersion=this.compatCheck(semiParts[i].substring(4,8),semiParts);
break;
}
}
break;
case "Firefox":
case "Seamonkey":
this.browserVersion=slashParts[slashParts.length-1];
break;
case "Chrome":
for(i=0;i<spaceParts.length;i++){
if(spaceParts[i].indexOf("chrome")!=-1){
this.browserVersion=spaceParts[i].substring(7);
break;
}
}
break;
case "Safari":
for(i=0;i<spaceParts.length;i++){
if(spaceParts[i].indexOf("version")!=-1){
this.browserVersion=spaceParts[i].substring(8);
break;
}
}
break;
default:
}
return this.browserVersion;
},
getPlatform:function(){
if(this.platform==""){
if(this.agentContains('linux'))this.platform="Linux";
else if(this.agentContains('x11'))this.platform="Unix";
else if(this.agentContains('mac'))this.platform="Mac";
else if(this.agentContains('win'))this.platform=this.getWindowsVersion();
else this.platform="Unknown";
}
return this.platform;
},
getWindowsVersion:function(){
if(this.platform==""){
this.platform="Windows";
if(this.agentContains("windows nt 6.3")){
if(this.agentContains("wow64")||this.agentContains("win64")){
this.platform+=" 8.1 64-bit or Server 2012";
}else{
this.platform+=" 8.1";
}
}else if(this.agentContains("windows nt 6.2")){
if(this.agentContains("wow64")||this.agentContains("win64")){
this.platform+=" 8 64-bit or Server 2012";
}else{
this.platform+=" 8";
}
}else if(this.agentContains("windows nt 6.1")){
this.platform+=" 7";
}else if(this.agentContains("windows nt 6.0")){
this.platform+=" Vista";
}else if(this.agentContains("windows nt 5.1")){
this.platform+=" XP";
if(this.agentContains("; sv1")||this.agentContains("; ypc")){
this.platform+=" (SP2)";
}
}else if(this.agentContains("windows nt 5.2")){
this.platform+=" NT 5.2 (XP 64-bit or Server 2003)";
if(this.agentContains("; sv1")){
this.platform+=" (SP1)";
}
}else if(this.agentContains("windows nt 6.0")){
this.platform+=" Vista";
}else if(this.agentContains("windows ce")){
this.platform+=" CE";
}else if(this.agentContains("windows nt 5.0")){
this.platform+=" 2000";
}
}
return this.platform;
},
setXslSupport:function(){
if(this.agent.indexOf("webkit")>-1){
this.supportsDocParam=false;
this.supportsIncludes=false;
}
},
init:function(){
this.agent=navigator.userAgent.toLowerCase();
this.mobileBrowser=this.agent.match(/(ipad)|(iphone)|(ipod)|(android)|(webos)/i);
for(var i=0;i<this.browserList.length;i++){
if(this.agentContains(this.browserList[i][0])){
this.browserName=this.browserList[i][1];
break;
}
}
if(this.browserName==""&&!this.agentContains("compatible")){
this.browserName="Netscape Navigator";
this.browserVersion=this.agent.charAt(8);
}
this.getBrowserVersion();
this.getPlatform();
this.setXslSupport();
}
};
function getConnectionMode(numEnclosures){
var loadedEnclosures=1;
if(exists(numEnclosures)&&!isNaN(numEnclosures)){
loadedEnclosures=numEnclosures;
}
if(numMaxConnections<=MAX_CONNECTIONS()){
return connectionEnum.defaultMode;
}else if(numMaxConnections>loadedEnclosures){
return connectionEnum.tweakMode;
}else{
return connectionEnum.extraMode;
}
};
function getBrowserInfo(){
if(_browserInfo.agent==""){
_browserInfo.init();
}
return _browserInfo;
}
var logDataItems=[];
function addLogDataItem(logDataItem){
logDataItems.push(logDataItem);
return(logDataItems.length-1);
};
function removeLogDataItem(index){
if(isValidIndex(index,logDataItems)){
logDataItems.splice(index,1);
}
};
function resetLogData(){
logDataItems=[];
};
function getLogDataItem(index){
if(isValidIndex(index,logDataItems)){
return logDataItems[index];
}
return null;
};
