/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var xsltDocumentType="";
var xsltTemplateType="";
var xsltSerializer=(typeof(XMLSerializer)=="undefined"?null:new XMLSerializer());
var xsltDevMode=(window.location.protocol.indexOf("https")==-1);
var xsltDocumentTypes=[
"Msxml2.FreeThreadedDOMDocument.3.0",
"Msxml2.FreeThreadedDOMDocument.6.0",
"Msxml2.FreeThreadedDOMDocument.4.0",
"Msxml2.FreeThreadedDOMDocument"
];
var xsltTemplateTypes=[
"Msxml2.XSLTemplate.3.0",
"Msxml2.XSLTemplate.6.0",
"Msxml2.XSLTemplate.4.0",
"Msxml2.XSLTemplate"
];
function xsltFailedReload(){
if(typeof(getCurrentTab)!='undefined'&&typeof(setTabContent)!='undefined'){
try{setTabContent(getCurrentTab());}catch(e){window.location.reload();}
}else{
window.location.reload();
}
}
function XsltProcessor(stylesheetUrl){
var me=this;
var xsltDocument=null;
var xsltTemplate=null;
var xsltProcessor=null;
var errorMessage='';
var hasProcessorErrors=false;
var errorType=null;
var xmlDecEnd="?>";
var browserInfo=top.getBrowserInfo();
var XsltErrorTypes={
Communication:0,
Transform:1,
Functionality:2
};
this.stylesheet=stylesheetUrl;
this.sourceDocument=null;
this.namespace=OA_NAMESPACE();
function echo(msg,level,severity,extraData){
var entry="XSLT Processor: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function getXml(){
if(typeof(top.getXml)!='undefined'){
return top.getXml();
}else{
try{
return importModule("xml");
}catch(e){
echo("XSLT Processor could not locate an XML parser.",1,6,[e.message]);
}
}
return null;
};
function getFreeThreadedDom(){
var obj=null;
switch(xsltDocumentType){
case xsltDocumentTypes[0]:
case xsltDocumentTypes[1]:
case xsltDocumentTypes[2]:
case xsltDocumentTypes[3]:
obj=createFreeThreadedDom(xsltDocumentType);
break;
default:
for(var i in xsltDocumentTypes){
obj=createFreeThreadedDom(xsltDocumentTypes[i]);
if(obj!=null){
break;
}
}
break;
}
return obj;
};
function getXsltTemplate(){
var obj=null;
switch(xsltTemplateType){
case xsltTemplateTypes[0]:
case xsltTemplateTypes[1]:
case xsltTemplateTypes[2]:
case xsltTemplateTypes[3]:
obj=createXsltTemplate(xsltTemplateType);
break;
default:
for(var i in xsltTemplateTypes){
obj=createXsltTemplate(xsltTemplateTypes[i]);
if(obj!=null){
break;
}
}
break;
}
return obj;
};
function createFreeThreadedDom(type){
var obj=null;
try{
obj=new ActiveXObject(type);
if(xsltDocumentType!=type){
xsltDocumentType=type;
}
try{
obj.setProperty("ForcedResync",false);
obj.setProperty("SelectionLanguage","XPath");
obj.setProperty("AllowDocumentFunction",true);
obj.validateOnParse=false;
obj.resolveExternals=true;
}catch(e){
echo("Dom Document property set error.",1,3,[e.message]);
}
}catch(e){
echo("Dom Document creation error.",1,6,[e.message]);
}
return obj;
};
function createXsltTemplate(type){
var obj=null;
try{
obj=new ActiveXObject(type);
if(xsltTemplateType!=type){
xsltTemplateType=type;
}
}catch(e){
echo("Xslt Template creation error.",1,6,[e.message]);
}
return obj;
};
function insertDocParam(paramName,paramValue){
if(xsltDocument!=null){
try{
for(var i=0;i<xsltDocument.documentElement.childNodes.length;i++){
var node=xsltDocument.documentElement.childNodes[i];
if(node.nodeName&&node.nodeName=="xsl:param"){
if(node.getAttribute("name")==paramName){
var newDoc=xsltDocument.createElement(me.namespace+":paramDoc"+paramName);
xsltDocument.firstChild.insertBefore(newDoc,node);
newDoc.appendChild(paramValue.documentElement.cloneNode(true));
node.setAttribute("select","document('')//"+me.namespace+":paramDoc"+paramName);
break;
}
}
}
}catch(e){
echo("insertDocParam error: "+e.messaage,1,6);
}
}
};
function insertIncludeDoc(includeNode,includeDoc,includePath){
if(xsltDocument!=null){
try{
for(var i=0;i<includeDoc.childNodes.length;i++){
if(includeDoc.childNodes[i].nodeName=="xsl:stylesheet"){
var styleSheet=includeDoc.childNodes[i];
for(var j=0;j<styleSheet.childNodes.length;j++){
xsltDocument.firstChild.insertBefore(styleSheet.childNodes[j].cloneNode(true),includeNode);
}
}
}
}catch(e){
echo("insertIncludeDoc error: "+e.message,1,6);
}
}
};
function addIncludeFiles(){
var includes=[];
if(xsltDocument!=null){
try{
if(xsltDocument.documentElement.childNodes){
for(var index=0;index<xsltDocument.documentElement.childNodes.length;index++){
var node=xsltDocument.documentElement.childNodes[index];
if(node.nodeName&&node.nodeName=="xsl:include"){
includes.push({"node":node,"path":node.getAttribute("href")});
}
}
}
for(var i=0;i<includes.length;i++){
var includeDoc=me.loadStylesheet(includes[i].path);
if(includeDoc!=null){
insertIncludeDoc(includes[i].node,includeDoc,includes[i].path);
}
xsltDocument.firstChild.removeChild(includes[i].node);
}
if(includes.length>0){
addIncludeFiles();
}
}catch(e){
echo("addIncludeFiles error: "+e.message,1,6);
}
}
}
this.hasErrors=function(){
return hasProcessorErrors;
};
this.setErrorState=function(hasErrors,msg,type){
hasProcessorErrors=hasErrors;
errorMessage=(hasErrors)?msg:'';
if(typeof(errorType)!='undefined'){
errorType=type;
}
};
this.getErrorOutput=function(){
var errOutput='<img border="0" src="/120814-042457/images/icon_status_minor.gif"/>';
errOutput+='&nbsp;&nbsp;<b>Page Load Error</b><br /><br />';
errOutput+='<ul><li>'+errorMessage+'</li></ul>'+'<br /><br /><hr />';
errOutput+='Click <a href="javascript:xsltFailedReload();">here</a> to try and reload the page.';
return errOutput;
};
this.getErrorMessage=function(){
return errorMessage;
};
this.init=function(){
me.setErrorState(false);
if(me.stylesheet!=''){
var cacheItem=(browserInfo.supportsDocParam&&isFunction(top.getCacheTemplate)?top.getCacheTemplate(me.stylesheet):null);
if(cacheItem){
xsltProcessor=cacheItem;
if(typeof(XSLTProcessor)!="undefined"){
xsltProcessor.clearParameters();
}else{
xsltProcessor=cacheItem.ownerTemplate.createProcessor();
}
}else if(typeof(window.ActiveXObject)!='undefined'){
xsltTemplate=getXsltTemplate();
if(xsltTemplate!=null){
xsltDocument=me.loadStylesheet(me.stylesheet);
try{
xsltTemplate.stylesheet=xsltDocument;
xsltProcessor=xsltTemplate.createProcessor();
}catch(e){
echo("Init error creating processor (IE).",1,6,["Stylesheet: "+me.stylesheet,e.message]);
me.setErrorState(true,e.message);
xsltProcessor=null;
}
}else{
me.setErrorState(true,'Unable to create XSLT Processor.',XsltErrorTypes.Functionality);
}
}else if(typeof(XSLTProcessor)!='undefined'){
try{
xsltProcessor=new XSLTProcessor();
xsltDocument=me.loadStylesheet(me.stylesheet);
if(!browserInfo.supportsIncludes){
addIncludeFiles();
}
xsltProcessor.importStylesheet(xsltDocument);
}catch(e){
echo("Init error creating processor (MOZ).",1,6,[e.message,me.stylesheet,arguments.callee]);
me.setErrorState(true,e.message);
xsltProcessor=null;
}
}else{
me.setErrorState(true,'Could not find the required functionality to run this application.',XsltErrorTypes.Functionality);
}
if(!hasProcessorErrors){
if(isFunction(top.addCacheItem)){
top.addCacheItem(me.stylesheet,xsltProcessor);
}
}
}else{
me.setErrorState(true,'Invalid or no stylesheet URL specified.',XsltErrorTypes.Communication);
}
};
this.loadStylesheet=function(xslPath){
var xslDoc=null;
var status=false;
if(!document.all){
if(xslPath.indexOf("../../")==0){
xslPath=xslPath.replace("../../","/120814-042457/");
}else if(xslPath.indexOf("../")==0){
xslPath=xslPath.replace("../","/120814-042457/");
}
}
if(window.ActiveXObject){
xslDoc=getFreeThreadedDom();
try{
xslDoc.async=false;
status=xslDoc.load(xslPath);
}catch(e){
echo("Stylesheet load error (IE).",1,6,[e.message]);
status=false;
}
}else if(typeof(XMLHttpRequest)!="undefined"){
if(browserInfo.browserName=="Chrome"){
var cacheItem=top.getChromeCacheItem(xslPath);
if(cacheItem){
try{
while(cacheItem.doc.hasChildNodes()){
cacheItem.doc.removeChild(cacheItem.doc.firstChild);
}
cacheItem.doc.appendChild(cacheItem.xsl.cloneNode(true));
return(cacheItem.doc);
}catch(e){
echo("loadStylesheet: error occurred: "+e.message,1,6);
}
}
}
xslDoc=new XMLHttpRequest();
try{
xslDoc.open("GET",xslPath,false);
xslDoc.send(null);
}catch(s){
echo("Unable to open/send XHR. "+s.message,1,6);
}
try{
status=(xslDoc.status==200);
if(status){
xslDoc=xslDoc.responseXML;
}
}catch(e){
echo("Stylesheet load error (MOZ-XHR).",1,6,[e.message]);
status=false;
}
}
if(!status){
me.setErrorState(true,'Unable to load the stylesheet from the server.',XsltErrorTypes.Communication);
}else{
if(browserInfo.browserName=="Chrome"){
top.addChromeCacheItem(xslPath,{"doc":xslDoc,"xsl":xslDoc.firstChild.cloneNode(true)});
}
}
return(status?xslDoc:null);
};
this.addParameter=function(paramName,paramValue){
if(hasProcessorErrors){
return;
}
if(xsltProcessor!=null){
try{
if(typeof(paramName)!='undefined'&&paramName!=null){
if(typeof(paramValue)=='undefined'){
var paramValue='';
}
if(typeof(xsltProcessor.setParameter)!='undefined'){
if(!browserInfo.supportsDocParam&&paramValue.nodeType){
insertDocParam(paramName,paramValue);
}else{
xsltProcessor.setParameter(null,paramName,paramValue);
}
}else if(typeof(xsltProcessor.addParameter)!='undefined'){
xsltProcessor.addParameter(paramName,paramValue);
}
}
}catch(e){
echo("Error adding parameter ("+paramName+").",1,6,[e.message]);
me.setErrorState(true,e.message);
}
}
};
this.setSourceDocument=function(sourceDoc){
if(hasProcessorErrors){
return;
}
if(sourceDoc!=null){
me.sourceDocument=sourceDoc;
}
};
this.getOutput=function(asDomDocument){
var output='';
if(hasProcessorErrors){
return me.getErrorOutput();
}
if(xsltProcessor!=null){
if(me.sourceDocument==null){
me.sourceDocument=getXml().parseXML("<root-node />");
}
if(typeof(xsltProcessor.transform)!='undefined'){
try{
xsltProcessor.input=me.sourceDocument;
xsltProcessor.transform();
output=xsltProcessor.output;
if(asDomDocument==true){
output=getXml().parseXML(output);
}else if(output.indexOf(xmlDecEnd)>-1){
output=output.substring(output.indexOf(xmlDecEnd)+xmlDecEnd.length);
}
}
catch(e){
echo("Transform error (IE).",1,6,["Stylesheet: "+me.stylesheet,e.message]);
me.setErrorState(true,e.message);
}
}else if(typeof(xsltProcessor.transformToFragment)!='undefined'){
try{
if(asDomDocument==true){
output=xsltProcessor.transformToDocument(me.sourceDocument);
}else{
var fragment=xsltProcessor.transformToFragment(me.sourceDocument,document);
var blankDiv=document.createElement("div");
blankDiv.appendChild(fragment);
output=blankDiv.innerHTML;
}
}catch(e){
echo("Transform error (MOZ).",1,6,["Stylesheet: "+me.stylesheet,e.message]);
me.setErrorState(true,e.message);
}
}
}
if(hasProcessorErrors){
output=me.getErrorOutput();
}
return output;
};
this.init();
};
