/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Module("Soap","1.2.0",function(mod){
var xml=null
var serializer=null;
var soapDoc=null;
var soapNS="";
var soapNSUri="";
var regExp=null;
var soapSuds=null;
var debugging=top.debugIsActive();
var debugMode=true;
function soapDebug(debugState){
debugging=debugState;
};
function echo(msg,level,severity,extraData){
if(debugging==true){
var entry="Global Soap: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
}
};
function echoSoapRequest(soapRequestText,methodName){
var displayElement=document.getElementById('soapRequest');
if(!existsNonNull(displayElement)){
debugMode=false;
return;
}
if(regExp==null){
regExp=new RegExp(">","g");
}
if(methodName.indexOf("getAllEvents")==0){
displayElement.value+="\n\n"+soapRequestText.replace(regExp,">\n");
}else{
displayElement.value=soapRequestText.replace(regExp,">\n");
}
};
function createNode(container,nodeName,nodeValue){
var node=container.createElement(nodeName);
if(exists(nodeValue)){
var text=container.createTextNode(''+nodeValue);
node.appendChild(text);
}
return node;
};
function getCleanDocument(){
if(soapDoc==null){
soapDoc=xml.parseXML('<soapContainer />');
}else{
var doc=soapDoc.documentElement;
while(doc.hasChildNodes()){
doc.removeChild(doc.firstChild);
}
}
return soapDoc;
};
function cacheSoapEnvelope(){
var doc=getCleanDocument();
var envelopeElement=doc.createElement('SOAP-ENV:Envelope');
envelopeElement.setAttribute('xmlns:SOAP-ENV','http://www.w3.org/2003/05/soap-envelope');
envelopeElement.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
envelopeElement.setAttribute('xmlns:xsd','http://www.w3.org/2001/XMLSchema');
envelopeElement.setAttribute('xmlns:wsu','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');
envelopeElement.setAttribute('xmlns:wsse','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
envelopeElement.setAttribute('xmlns:'+soapNS,soapNSUri);
var dummy=doc.createElement("dummy");
envelopeElement.appendChild(dummy);
doc.documentElement.appendChild(envelopeElement);
var envString=serializeToString(doc.documentElement.firstChild);
soapSuds[1]=envString.substr(0,envString.indexOf("<dummy/>"));
echo("Soap envelope added to cache.",2,1,[soapSuds[1]+soapSuds[6]]);
};
function createSecurityHeader(sessionKey){
if(!existsNonNull(sessionKey)){
return "";
}
var doc=getCleanDocument();
var headerElement=doc.createElement('SOAP-ENV:Header');
var securityElement=doc.createElement('wsse:Security');
securityElement.setAttribute('SOAP-ENV:mustUnderstand','true');
var hpoaSessionTokenElement=doc.createElement(soapNS+":HpOaSessionKeyToken");
hpoaSessionTokenElement.appendChild(createNode(doc,soapNS+":oaSessionKey",sessionKey));
securityElement.appendChild(hpoaSessionTokenElement);
headerElement.appendChild(securityElement);
doc.documentElement.appendChild(headerElement);
echo("Security header returned to client.",2,1,["Key: "+sessionKey]);
return serializeToString(doc.documentElement.firstChild);
};
function getFunctionString(functionName,paramNames,paramValues){
var doc=getCleanDocument();
var functionElement=doc.createElement(soapNS+':'+functionName);
for(var i=0;(i<paramNames.length&&i<paramValues.length);i++){
var paramName;
var paramValue;
var paramType;
if(paramNames[i].indexOf(':')>-1){
var paramParts=paramNames[i].split(':');
paramType=paramParts[1];
paramName=soapNS+':'+paramParts[0];
paramValue=getParamValue(paramType,paramValues[i]);
}else{
paramName=paramNames[i];
paramValue=getParamValue('string',paramValues[i]);
}
if(paramValue.childNodes){
echo(paramName+" is a document fragment.",8,3);
functionElement.appendChild(paramValue);
}else{
functionElement.appendChild(createNode(doc,paramName,paramValue));
}
}
doc.documentElement.appendChild(functionElement);
return serializeToString(doc.documentElement.firstChild);
};
function createSoapFaultResponse(args,errorCodeType){
var doc=getCleanDocument();
var codeNode=doc.createElement("SOAP-ENV:Code");
var faultNode=doc.createElement("SOAP-ENV:Fault");
var detailNode=doc.createElement("SOAP-ENV:Detail");
var faultInfo=doc.createElement(soapNS+":faultInfo");
if(exists(args.length)){
if(existsNonNull(args[0])){
faultInfo.appendChild(createNode(doc,soapNS+":errorType",args[0]));
}
if(existsNonNull(args[1])){
var nodeName=(exists(errorCodeType)?errorCodeType:"errorCode");
faultInfo.appendChild(createNode(doc,soapNS+":"+nodeName,args[1]));
}
if(existsNonNull(args[2])){
faultInfo.appendChild(createNode(doc,soapNS+":operationName",args[2]));
}
if(existsNonNull(args[3])){
faultInfo.appendChild(createNode(doc,soapNS+":operationBayNumber",args[3]));
}
if(existsNonNull(args[4])){
faultInfo.appendChild(createNode(doc,soapNS+":errorText",args[4]));
}
if(existsNonNull(args[5])){
faultInfo.appendChild(createNode(doc,"SOAP-ENV:Text",args[5]));
}
}
detailNode.appendChild(faultInfo);
faultNode.appendChild(codeNode);
faultNode.appendChild(detailNode);
doc.documentElement.appendChild(faultNode);
soapSuds[2]="";
soapSuds[4]=serializeToString(doc.documentElement.firstChild);
echo("Clone soap fault response created.",2,2,[soapSuds.join("")]);
return parseText(soapSuds.join(""));
};
function createNormalResponse(args){
var doc=getCleanDocument();
var returnCodeOk=doc.createElement(soapNS+":returnCodeOk");
if(existsNonNull(args[0])){
var responseNode=doc.createElement(soapNS+":"+args[0]);
responseNode.appendChild(returnCodeOk);
doc.documentElement.appendChild(responseNode);
}else{
doc.documentElement.appendChild(returnCodeOk);
}
soapSuds[2]="";
soapSuds[4]=serializeToString(doc.documentElement.firstChild);
echo("Clone normal response created.",2,2,[soapSuds.join("")]);
return parseText(soapSuds.join(""));
};
function createEventResponse(args){
var doc=getCleanDocument();
var eventInfo=doc.createElement(soapNS+":eventInfo");
if(existsNonNull(args[0])){
eventInfo.appendChild(createNode(doc,soapNS+":event",args[0]));
}
doc.documentElement.appendChild(eventInfo);
if(existsNonNull(args[1])){
if(existsNonNull(args[2])){
eventInfo.appendChild(getElementValueXpath(args[1],'//'+args[2],true));
}else{
eventInfo.appendChild(args[1]);
}
}
soapSuds[2]="";
soapSuds[4]=serializeToString(doc.documentElement.firstChild);
echo("Clone event response created.",2,2,[soapSuds.join("")]);
return parseText(soapSuds.join(""));
};
function getParamValue(type,value){
switch(type){
case 'string':
return(new String(value));
case 'int':
return(parseInt(value,10));
case 'float':
return(parseFloat(value));
default:
return value;
}
};
function assertValidXmlDocument(xmlDoc,text){
var tempString=(""+text);
if(tempString.indexOf("<!DOCTYPE HTML PUBLIC")>-1){
if(tempString.indexOf("Authentication attempt failed")>-1){
return createSoapFaultResponse([ErrorType.FormManager,'308']);
}else{
}
}
return xmlDoc;
};
function parseText(text){
var xmlDoc=null;
if(existsNonNull(text)&&text!=""){
xmlDoc=xml.parseXML(text);
if(!exists(xmlDoc.xml)){
try{
xmlDoc.xml=serializer.serializeToString(xmlDoc);
}catch(e){
xmlDoc.xml="";
}
}
if(xmlDoc.xml==""){
xmlDoc=assertValidXmlDocument(xmlDoc,text);
}
}
return xmlDoc;
};
function serializeToString(xmlNode){
var xmlString="";
if(existsNonNull(xmlNode.xml)){
xmlString+=xmlNode.xml;
}else{
try{
xmlString+=serializer.serializeToString(xmlNode);
}catch(e){}
}
return xmlString;
};
mod.init=function(nameSpace,nameSpaceUri){
try{
xml=importModule('xml');
}catch(e){echo("could not import the xml library.",1,7,[e.message]);}
top.registerDebugListener(soapDebug);
serializer=(typeof(XMLSerializer)=='undefined'?null:new XMLSerializer());
soapSuds=new Array(7);
soapSuds[0]="<?xml version=\"1.0\"?>";
soapSuds[1]="";
soapSuds[2]="";
soapSuds[3]="<SOAP-ENV:Body>";
soapSuds[4]="";
soapSuds[5]="</SOAP-ENV:Body>";
soapSuds[6]="</SOAP-ENV:Envelope>";
soapNS=(existsNonNull(nameSpace)?nameSpace:OA_NAMESPACE());
soapNSUri=(existsNonNull(nameSpaceUri)?nameSpaceUri:OA_NAMESPACE_URI());
cacheSoapEnvelope();
};
mod.createSoapResponse=function(type,args){
var response=null;
switch(type){
case ResponseClones.SoapError:
response=createSoapFaultResponse(args);
break;
case ResponseClones.InternalError:
response=createSoapFaultResponse(args,"internalErrorCode");
break;
case ResponseClones.Event:
response=createEventResponse(args);
break;
case ResponseClones.Normal:
default:
response=createNormalResponse(args);
break;
}
return response;
};
mod.parseResponseText=function(responseText){
return parseText(responseText);
};
mod.setNameSpace=function(soapNameSpace,soapNameSpaceUri){
soapNS=soapNameSpace;
soapNSUri=soapNameSpaceUri;
cacheSoapEnvelope();
};
mod.getSecurityHeader=function(sessionKey){
return createSecurityHeader(sessionKey);
};
mod.createSoapRequest=function(callDescriptor,params,securityHeader){
if(!exists(params)){
var params=new Array();
}
soapSuds[2]=(existsNonNull(securityHeader)?securityHeader:"");
soapSuds[4]=getFunctionString(callDescriptor.fname,callDescriptor.params,params);
var soapRequest=soapSuds.join("");
if(debugMode){
echoSoapRequest(callDescriptor.fname=="userLogIn"?"Permission Denied.":soapRequest,callDescriptor.fname);
}
return soapRequest;
};
mod.init();
});
