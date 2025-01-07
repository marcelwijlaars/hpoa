/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function DomBuilder(){
this.xml=null;
this.serializer=null;
this.domInfo=null;
};
function _getSerializer(){
if(this.serializer==null){
if(typeof(XMLSerializer)!='undefined'){
this.serializer=new XMLSerializer();
}
}
return this.serializer;
};
function _getXml(){
if(typeof(this.xml)!="undefined"&&this.xml==null){
try{
this.xml=importModule("xml");
}catch(err){
top.logEvent("DomBuilder.getXml(): "+err.message);
}
}
return this.xml;
};
function _assertParseable(fragment){
var isMoz=false;
var docString='';
var parsedDoc=null;
if(fragment!=null){
if(this.getSerializer()!=null){
docString=this.getSerializer().serializeToString(fragment);
isMoz=true;
}else{
docString=fragment.xml;
}
parsedDoc=(this.getXml().parseXML(docString));
if(isMoz){
parsedDoc.xml=docString;
}
}
return parsedDoc;
};
function _addDocument(rootName,attribs){
this.domInfo=this.getXml().parseXML("<document />");
var rootNode=this.domInfo.createElement(rootName);
if(isArray(attribs)){
for(var i=0;i<attribs.length-1;i+=2){
rootNode.setAttribute(attribs[i],attribs[i+1]);
}
}
this.domInfo.documentElement.appendChild(rootNode);
return this.getDocument();
};
function _getDocument(cloned){
var returnDoc=null;
try{
if(cloned==true){
returnDoc=this.domInfo.documentElement.firstChild.cloneNode(true);
}else{
returnDoc=this.domInfo.documentElement.firstChild;
}
}catch(e){
top.logEvent("DomBuilder.getDocument(): "+e.message,null,1,5);
}
return this.assertParseable(returnDoc);
};
function _appendChild(nodeName,attribs,textValue,parentArg){
this.domInfo=this.assertParseable(this.domInfo);
var parent=null;
var node=null;
if(exists(parentArg)&&typeof(parentArg)=='string'){
parent=getElementValueXpath(this.domInfo,parentArg,true);
}else{
try{
parent=this.domInfo.documentElement.firstChild;
}catch(e){
top.logEvent("DomBuilder.appendChild(): "+e.message,null,1,5);
}
}
if(parent!=null){
node=this.domInfo.createElement(nodeName);
if(isArray(attribs)){
for(var i=0;i<attribs.length-1;i+=2){
node.setAttribute(attribs[i],attribs[i+1]);
}
}
if(existsNonNull(textValue)){
var t=this.domInfo.createTextNode(textValue);
node.appendChild(t);
}
parent.appendChild(node);
}
return node;
};
function _removeChild(nodeSet,parentXpath,childXpath){
if(nodeSet==null){
this.domInfo=this.assertParseable(this.domInfo);
nodeSet=this.domInfo;
}
var parentElement=getElementValueXpath(nodeSet,parentXpath,true);
var childElement=getElementValueXpath(nodeSet,childXpath,true);
try{
if(parentElement!=null&&childElement!=null){
parentElement.removeChild(childElement);
return true;
}else{
top.logEvent("DomBuilder.removeChild(): Could not locate both elements.",null,3,4);
return false;
}
}catch(err){
top.logEvent("DomBuilder.removeChild(): "+err.message,null,3,6);
return false;
}
};
function _replaceChild(nodeSet,parentXpath,childXpath,attribs,textValue){
if(nodeSet==null){
this.domInfo=this.assertParseable(this.domInfo);
nodeSet=this.domInfo;
}
var parentElement=getElementValueXpath(nodeSet,parentXpath,true);
var childElement=getElementValueXpath(nodeSet,childXpath,true);
try{
if(parentElement!=null&&childElement!=null){
var nodeName=childElement.nodeName;
parentElement.removeChild(childElement);
this.appendChild(nodeName,attribs,textValue,parentXpath);
return true;
}else{
top.logEvent("DomBuilder.replaceChild(): Could not locate both elements.",null,3,4);
return false;
}
}catch(err){
top.logEvent("DomBuilder.replaceChild(): "+err.message,null,3,3);
return false;
}
};
function _createFragment(){
try{
return this.domInfo.createDocumentFragment();
}catch(err){
top.logEvent("DomBuilder.createFragment(): "+err.message,null,3,3);
}
};
function _addFragmentToParent(parentName,idNodeName,idNodeValue,fragment){
var dataSet=getFragmentElementsByTagName(this.domInfo,parentName);
try{
for(var index in dataSet){
for(var i=0;i<dataSet[index].childNodes.length;i++){
if(dataSet[index].childNodes[i].nodeName==idNodeName){
var test=dataSet[index].childNodes[i].firstChild.nodeValue;
if(test==idNodeValue){
dataSet[index].appendChild(fragment.documentElement.cloneNode(true));
}
}
}
}
}catch(err){
top.logEvent("DomBuilder.addFragmentToParent(): "+err.message);
}
};
DomBuilder.prototype.toString=function(){return "DomBuilder Class";}
DomBuilder.prototype.getXml=_getXml;
DomBuilder.prototype.addDocument=_addDocument;
DomBuilder.prototype.getDocument=_getDocument;
DomBuilder.prototype.getSerializer=_getSerializer;
DomBuilder.prototype.assertParseable=_assertParseable;
DomBuilder.prototype.createFragment=_createFragment;
DomBuilder.prototype.appendChild=_appendChild;
DomBuilder.prototype.removeChild=_removeChild;
DomBuilder.prototype.replaceChild=_replaceChild;
DomBuilder.prototype.addFragmentToParent=_addFragmentToParent;
