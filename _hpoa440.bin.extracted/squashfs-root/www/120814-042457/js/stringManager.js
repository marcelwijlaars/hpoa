/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Module("StringManager","1.0",function(mod){
var EMBED_LANGUAGE="en";
var EMBED_EXTENSION=".en.xml";
var syncGet=null;
var domParser=null;
var stringsDOM=null;
var acceptLanguage="";
var debugging=function(){return top.debugIsActive()};
function echo(msg,level,severity,extraData){
var entry="String Manager: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function getStringsXML(force){
if(debugging()||force==true){
return(typeof(XMLSerializer)!="undefined"?new XMLSerializer().serializeToString(stringsDOM):stringsDOM.xml);
}else{
return "";
}
};
function loadXML(url,urlAttribute){
var langPref=getCookieValue('UserPref-Language');
var file=null;
try{
if(langPref!=''){
file=syncGet.sendRequest("GET",url,null,null,null,[["Accept-Language",langPref]]);
}else{
file=syncGet.sendRequest("GET",url);
}
if(typeof(file.responseXML.xml)!="undefined"){
file=domParser.parseXML(file.responseXML.xml);
}else{
file=file.responseXML;
}
file.documentElement.setAttribute("url",(urlAttribute?urlAttribute:url));
if(acceptLanguage==""){
acceptLanguage=file.documentElement.getAttribute("xml:lang");
}
}catch(e){
echo("Could not load "+url,1,6,[e.message]);
}
return file;
};
function createStringsDocument(){
stringsDOM=domParser.parseXML('<?xml version="1.0"?><string-documents />');
};
function getDataFiles(url){
var childDocs=stringsDOM.documentElement.childNodes;
var matches=[];
for(var i=0;i<childDocs.length;i++){
if(childDocs[i].getAttribute("url")==url){
matches.push(childDocs[i]);
}
}
return matches;
};
mod.init=function(){
syncGet=top.getUrlLib();
domParser=top.getXml();
createStringsDocument();
echo("Initialized.",1,1,[getStringsXML()]);
};
mod.addDataFile=function(url){
var loadedFiles=getDataFiles(url);
if(loadedFiles.length==0){
var dataFile1=loadXML(url);
var dataFile2=null;
if(acceptLanguage!=EMBED_LANGUAGE&&(url.indexOf(".var")>-1)){
dataFile2=loadXML(url.replace(".var",EMBED_EXTENSION),url);
}
echo("Loading new data file(s).",1,1,[url]);
try{
stringsDOM.documentElement.appendChild(dataFile1.documentElement.cloneNode(true));
if(dataFile2){
stringsDOM.documentElement.appendChild(dataFile2.documentElement.cloneNode(true));
}
echo("Success.",1,2,[getStringsXML()]);
}catch(e){
echo("Error adding data file(s).",1,6,[e.message]);
}
}
};
mod.removeDataFile=function(url){
var loadedFiles=getDataFiles(url);
if(loadedFiles.length>0){
echo("Unloading data file(s).",1,3,[url]);
for(var i=0;i<loadedFiles.length;i++){
try{
stringsDOM.documentElement.removeChild(loadedFiles[i]);
echo("Success.",1,2,[getStringsXML()]);
}catch(e){
echo("Error unloading data file.",1,6,[e.message]);
}
}
}
};
mod.unload=function(){
createStringsDocument();
acceptLanguage="";
echo("Unloaded. Strings document is empty.",1,1);
};
mod.getString=function(xpath){
return getElementValueXpath(stringsDOM,xpath);
};
mod.getStringsDOM=function(){
return stringsDOM;
};
mod.getProperty=function(propName){
switch(propName){
case "AcceptLanguage":
return acceptLanguage;
case "EmbeddedLanguage":
return EMBED_LANGUAGE;
case "StringsXML":
return getStringsXML(true);
default:
return "Unknown property '"+propName+"'";
}
};
mod.init();
});
