/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Module("xml","1.1.2",function(mod){
var discoveredType="";
var types=["Msxml2.DomDocument.3.0","Msxml2.DomDocument.6.0",
"Msxml2.DomDocument.4.0","Msxml2.DomDocument"];
function getParser(){
var obj=null;
switch(discoveredType){
case types[0]:
case types[1]:
case types[2]:
case types[3]:
obj=getComParser(discoveredType);
break;
case "DOMParser":
obj=getNativeParser();
break;
default:
if(window.ActiveXObject){
for(var i in types){
obj=getComParser(types[i]);
if(obj!=null){
break;
}
}
}else if(typeof(DOMParser)!="undefined"){
obj=getNativeParser();
}else{
top.logEvent("Dom Parser support not found.",null,1,6);
}
break;
}
return obj;
}
function getNativeParser(){
var obj=new DOMParser();
discoveredType="DOMParser";
return obj;
}
function getComParser(type){
var obj=null;
try{
obj=new ActiveXObject(type);
discoveredType=type;
try{obj.setProperty("NewParser",true);}catch(e){}
try{obj.preserveWhiteSpace=true;}catch(e){}
}catch(e){
top.logEvent("Dom Parser creation error: "+e.message,null,1,6);
}
return obj;
}
mod.NoXMLParser=Class("NoXMLParser",mod.Exception,function(publ,supr){
publ.init=function(trace){
supr(this).init("Could not create an XML parser.",trace);
}
})
mod.ParsingFailed=Class("ParsingFailed",mod.Exception,function(publ,supr){
publ.init=function(xml,trace){
supr(this).init("Failed parsing XML document.",trace);
this.xml=xml;
}
publ.xml;
})
mod.parseXML=function(xml){
var parser=getParser();
switch(discoveredType){
case types[0]:
case types[1]:
case types[2]:
case types[3]:
parser.loadXML(xml);
if(parser.parseError.reason!=""){
top.logEvent(["XML: Parse failed (IE).",parser.parseError.reason],null,1,6);
}
break;
case "DOMParser":
parser=parser.parseFromString(xml,"text/xml");
break;
default:
}
return parser;
}
mod.importNode=function(importedNode,deep){
deep=(deep==null)?true:deep;
var ELEMENT_NODE=1;
var ATTRIBUTE_NODE=2;
var TEXT_NODE=3;
var CDATA_SECTION_NODE=4;
var ENTITY_REFERENCE_NODE=5;
var ENTITY_NODE=6;
var PROCESSING_INSTRUCTION_NODE=7;
var COMMENT_NODE=8;
var DOCUMENT_NODE=9;
var DOCUMENT_TYPE_NODE=10;
var DOCUMENT_FRAGMENT_NODE=11;
var NOTATION_NODE=12;
var importChildren=function(srcNode,parent){
if(deep){
for(var i=0;i<srcNode.childNodes.length;i++){
var n=mod.importNode(srcNode.childNodes.item(i),true);
parent.appendChild(n);
}
}
}
var node=null;
switch(importedNode.nodeType){
case ATTRIBUTE_NODE:
node=document.createAttributeNS(importedNode.namespaceURI,importedNode.nodeName);
node.value=importedNode.value;
break;
case DOCUMENT_FRAGMENT_NODE:
node=document.createDocumentFragment();
importChildren(importedNode,node);
break;
case ELEMENT_NODE:
node=document.createElementNS(importedNode.namespaceURI,importedNode.tagName);
for(var i=0;i<importedNode.attributes.length;i++){
var attr=this.importNode(importedNode.attributes.item(i),deep);
node.setAttributeNodeNS(attr);
}
importChildren(importedNode,node);
break;
case ENTITY_REFERENCE_NODE:
node=importedNode;
break;
case PROCESSING_INSTRUCTION_NODE:
node=document.createProcessingInstruction(importedNode.target,importedNode.data);
break;
case TEXT_NODE:
case CDATA_SECTION_NODE:
case COMMENT_NODE:
node=document.createTextNode(importedNode.nodeValue);
break;
case DOCUMENT_NODE:
case DOCUMENT_TYPE_NODE:
case NOTATION_NODE:
case ENTITY_NODE:
throw "not supported in DOM2";
break;
}
return node;
}
mod.node2XML=function(node){
var ELEMENT_NODE=1;
var ATTRIBUTE_NODE=2;
var TEXT_NODE=3;
var CDATA_SECTION_NODE=4;
var ENTITY_REFERENCE_NODE=5;
var ENTITY_NODE=6;
var PROCESSING_INSTRUCTION_NODE=7;
var COMMENT_NODE=8;
var DOCUMENT_NODE=9;
var DOCUMENT_TYPE_NODE=10;
var DOCUMENT_FRAGMENT_NODE=11;
var NOTATION_NODE=12;
var s="";
switch(node.nodeType){
case ATTRIBUTE_NODE:
if(node.value!=undefined&&node.value!=null&&node.value!="null"&&node.value!=""){
s+=" "+node.nodeName+'="'+node.value+'"';
}
break;
case DOCUMENT_NODE:
s+=this.node2XML(node.documentElement);
break;
case ELEMENT_NODE:
s+="<"+node.tagName;
for(var i=0;i<node.attributes.length;i++){
s+=this.node2XML(node.attributes.item(i));
}
if(node.childNodes.length==0){
s+="/>\n";
}else{
s+=">";
for(var i=0;i<node.childNodes.length;i++){
s+=this.node2XML(node.childNodes.item(i));
}
s+="</"+node.tagName+">\n";
}
break;
case PROCESSING_INSTRUCTION_NODE:
s+="<?"+node.target+" "+node.data+" ?>";
break;
case TEXT_NODE:
s+=node.nodeValue;
break;
case CDATA_SECTION_NODE:
s+="<"+"![CDATA["+node.nodeValue+"]"+"]>";
break;
case COMMENT_NODE:
s+="<!--"+node.nodeValue+"-->";
break;
case ENTITY_REFERENCE_NODE:
case DOCUMENT_FRAGMENT_NODE:
case DOCUMENT_TYPE_NODE:
case NOTATION_NODE:
case ENTITY_NODE:
throw new mod.Exception("Nodetype(%s) not supported.".format(node.nodeType));
break;
}
return s;
}
});
