/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function HttpWrapper(type,stackHandler){
var me=this;
this.stackHandler=stackHandler;
this.defaultWait=60000;
this.xhrObject=null;
this.supportedXhrType=type;
this.resultHandler=function(){
try{
me.stackHandler(me.xhrObject.callObj);
}catch(e){
top.logEvent(["HttpWrapper: Failed to notify CallStack.",e.message],null,1,6);
}
}
};
function _getXhrCallTag(){
return(!existsNonNull(this.xhrObject)?0:this.xhrObject.getCallTag());
};
function _abortCall(callTag){
if(existsNonNull(this.xhrObject)&&this.xhrObject.callObj.callTag==callTag){
if(this.xhrObject.completed==false){
top.logEvent("HttpWrapper: aborting call ("+callTag+")",null,1,3);
this.xhrObject.abort();
return true;
}else{
top.logEvent("HttpWrapper: call ("+callTag+") already completed.",null,1,3);
return false;
}
}
top.logEvent("HttpWrapper: no call to abort ("+callTag+").",null,1,2);
return false;
};
function _sendRequest(callObject){
if(this.xhrObject==null){
var xhr=getXhrInstance(this.supportedXhrType);
this.xhrObject=new XhrObject(xhr,this.resultHandler);
}
if(!existsNonNull(callObject.maxWait)){
callObject.maxWait=this.defaultWait;
}
this.xhrObject.init(callObject);
this.xhrObject.openCall();
this.xhrObject.sendNow();
};
HttpWrapper.prototype.getCallTag=_getXhrCallTag;
HttpWrapper.prototype.abortCall=_abortCall;
HttpWrapper.prototype.sendRequest=_sendRequest;
function XhrObject(xhr,resultHandler){
var me=this;
this.xhr=xhr;
this.resultHandler=resultHandler;
this.completed=false;
this.callObj=null;
this.timerId=0;
this.async=true;
this.debugging=function(){return top.debugIsActive();}
this.startTimer=function(){
if(this.timerId>0){
this.stopTimer();
}
if(!isNaN(this.callObj.maxWait)&&this.callObj.maxWait>0){
if(this.debugging()==true){
top.logEvent("XHR: Starting call timer ["+this.callObj.maxWait+"] for call "+this.callObj.callName+"("+this.callObj.callTag+")",null,10,4);
}
this.timerId=window.setTimeout(function(){me.timedOut();},this.callObj.maxWait);
}
}
this.onreadystatechange=function(){
if(me.xhr.readyState==ReadyStates.Complete){
try{
var status=me.xhr.status;
}catch(e){
status=XhrErrors.Incomplete;
top.logEvent(["XHR: Status missing - possible abort.","ReadyState: "+me.xhr.readyState,e.toString()].concat(me.callObj.getProperties()),null,1,5);
}
try{
var serverCookie=me.xhr.getResponseHeader("Linked-Key");
if(serverCookie&&serverCookie!=""){
me.callObj.serverCookie=serverCookie.split(": ")[0];
}
}catch(e){}
me.finish(status);
}
}
};
function _timedOut(){
top.logEvent("XHR: Timed out call: "+this.callObj.callName,this.callObj.encId,1,5);
this.timerId=0;
this.abort(XhrErrors.TimedOut);
}
function _stopTimer(){
if(this.timerId>0){
window.clearTimeout(this.timerId);
}
this.timerId=0;
}
function _init(callObj){
this.stopTimer();
this.completed=false;
this.callObj=callObj;
this.async=existsNonNull(callObj.callback);
};
function _getCallTag(){
if(this.completed==false&&existsNonNull(this.callObj)){
return this.callObj.callTag;
}
return 0;
};
function _openCall(){
try{
this.xhr.open(this.callObj.sendType,this.callObj.url,this.async);
this.xhr.onreadystatechange=this.onreadystatechange;
}catch(e){
this.callObj.errorType=ErrorType.XhrError;
this.callObj.error=XhrErrors.OpenError;
this.callObj.errorString=e.message;
top.logEvent(["XHR: openCall failed!"].concat(this.callObj.getProperties()),this.callObj.encId,1,7);
this.finish();
}
};
function _sendNow(){
if(this.xhr&&this.xhr.readyState==ReadyStates.Open){
try{
this.startTimer();
this.xhr.send(this.callObj.data);
}catch(e){
this.callObj.errorType=ErrorType.XhrError;
this.callObj.error=XhrErrors.SendError;
this.callObj.errorString=e.message;
top.logEvent(["XHR: sendNow failed!"].concat(this.callObj.getProperties()),this.callObj.encId,1,7);
this.finish();
}
}
};
function _abort(xhrError){
this.callObj.errorType=ErrorType.XhrError;
this.callObj.error=(exists(xhrError)?xhrError:XhrErrors.Aborted);
if(this.xhr!=null&&this.xhr.readyState>=ReadyStates.Open){
this.xhr.onreadystatechange=function(){}
this.xhr.abort();
if(!window.ActiveXObject){
this.xhr=getXhrInstance(getSupportedXhrType());
}
top.logEvent(["XHR: Aborted: "+this.callObj.callName].concat(this.callObj.getProperties()),this.callObj.encId,1,5);
}
this.finish();
};
function _finish(status){
this.stopTimer();
this.completed=true;
try{
this.callObj.responseText=this.xhr.responseText;
if(this.debugging()==true){
top.logEvent(["XHR: ResponseText for "+this.callObj.callName+"("+this.callObj.callTag+").",this.callObj.responseText],this.callObj.encId,6,8);
}
}catch(e){
top.logEvent(["XHR: ReponseText not available."].concat(this.callObj.getProperties()),this.callObj.encId,1,5);
}
if(exists(status)){
switch(status){
case HttpErrors.None:
case HttpErrors.NotModified:
break;
case XhrErrors.Incomplete:
this.callObj.errorType=ErrorType.XhrError;
this.callObj.error=status;
var msg=["XHR: Status for "+this.callObj.callName+"=["+status+"]"];
top.logEvent(msg.concat(this.callObj.getProperties()),this.callObj.encId,1,4);
break;
default:
this.callObj.errorType=ErrorType.HttpError;
this.callObj.error=status;
var msg=["XHR: Status for "+this.callObj.callName+"=["+status+"]"];
top.logEvent(msg.concat(this.callObj.getProperties()),this.callObj.encId,1,4);
break;
}
}
try{
this.resultHandler();
}catch(e){
top.logEvent(["XHR: Failed to notify HttpWrapper.",e.message],this.callObj.encId,1,6);
}
};
XhrObject.prototype.toString=function(){return 'XhrObject 1.0';}
XhrObject.prototype.getCallTag=_getCallTag;
XhrObject.prototype.stopTimer=_stopTimer;
XhrObject.prototype.openCall=_openCall;
XhrObject.prototype.timedOut=_timedOut;
XhrObject.prototype.sendNow=_sendNow;
XhrObject.prototype.finish=_finish;
XhrObject.prototype.abort=_abort;
XhrObject.prototype.init=_init;
function getSupportedXhrType(){
if(window.ActiveXObject){
return SupportedXhrTypes.ActiveX;
}else if(window.XMLHttpRequest){
return SupportedXhrTypes.Native;
}else{
return SupportedXhrTypes.NoSupport;
}
};
function getXhrInstance(supportedXhrType){
var obj=null;
var types=["Msxml2.XMLHTTP.6.0","Msxml2.XMLHTTP","microsoft.XMLHTTP"];
var type="";
switch(supportedXhrType){
case SupportedXhrTypes.ActiveX:
for(var i in types){
try{
obj=new ActiveXObject(types[i]);
type=types[i];
break;
}catch(e){}
}
break;
case SupportedXhrTypes.Native:
obj=new XMLHttpRequest();
type="Native XmlHttpRequest.";
break;
default:
break;
}
top.logEvent("XHR: Using type "+type,null,1,1);
return obj;
};
