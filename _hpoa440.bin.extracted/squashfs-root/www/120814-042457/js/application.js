/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var transport=null;
var foundActiveSession=false;
var stringsDoc;
var graphicsMap;
var STRINGS_DOC_PATH='/120814-042457/Strings/strings.var';
var DIAG_STRINGS_PATH='/120814-042457/Strings/diagnosticStrings.var';
var WIZ_STRINGS_DOC_PATH='/120814-042457/Strings/wizardStrings.var';
var GRAPHICS_MAP_PATH='/120814-042457/Strings/graphics-map.xml';
var STANDBY_XML_PATH='/standby.xml';
function getTransport(){
return transport;
}
var standalone=false;
try{
if(typeof(top.mainPage)=='undefined'){
standalone=true;
top=this;
window.top=this;
}
}catch(e){
standalone=true;
try{
top=this;
window.top=this;
}catch(e){}
}
function getStringsDoc(){
return getStringManager().getStringsDOM();
}
function getGraphicsMap(){
return graphicsMap;
}
function initStrings(){
getStringManager().unload();
getStringManager().addDataFile(STRINGS_DOC_PATH);
getStringManager().addDataFile(DIAG_STRINGS_PATH);
}
function initGraphicsMap(){
graphicsMap=getUrlLib().sendRequest("GET",GRAPHICS_MAP_PATH);
if(typeof(graphicsMap.responseXML.xml)!='undefined'){
graphicsMap=getXml().parseXML(graphicsMap.responseXML.xml);
}else{
graphicsMap=graphicsMap.responseXML;
}
}
function getString(key){
return getStringManager().getString('//strings/value[@key="'+key+'"]');
}
function initStandaloneApplication(){
initStrings();
initGraphicsMap();
transport=importModule("Transport");
transport.getCallAnalyzer().toggleEnabled(false);
}
