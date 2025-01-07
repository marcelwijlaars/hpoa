/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function CallStack(type,transportCallback){
var me=this;
this.transportCallback=transportCallback;
this.readyToPop=true;
this.unloading=false;
this.uniqueId=0;
this.callQueue=new Array();
this.resultHandler=function(callObject){
try{
me.transportCallback(callObject);
}catch(e){
top.logEvent(["CallStack: Failed to notify Transport.",e.message],null,1,6);
}finally{
me.pop();
}
}
this.httpWrapper=new HttpWrapper(type,this.resultHandler);
};
function _getUniqueId(){
return this.uniqueId;
};
function _setUniqueId(uniqueId){
this.uniqueId=uniqueId;
};
function _getPendingCallTag(){
return(this.getHttpWrapper().getCallTag());
};
function _containsCallTag(callTag){
for(var index in this.callQueue){
if(this.callQueue[index].callTag==callTag){
return true;
}
}
return false;
};
function _unloadStack(modSoap){
top.logEvent("Call Stack: unloading call stack.",null,3,1);
this.unloading=true;
this.emptyQueue(modSoap);
this.getHttpWrapper().abortCall(this.getPendingCallTag());
this.unloading=false;
};
function _abortCall(callTag){
return this.getHttpWrapper().abortCall(callTag);
};
function _deleteCall(callTag){
for(var index in this.callQueue){
if(this.callQueue[index].callTag==callTag){
top.logEvent("Call Stack: deleting call ("+callTag+") before pop.",(this.uniqueId>0?this.uniqueId:null),3,1);
this.callQueue.splice(index,1);
return true;
}
}
return false;
};
function _emptyQueue(modSoap){
if(existsNonNull(modSoap)){
for(var index in this.callQueue){
var callObj=this.callQueue[index];
callObj.result=modSoap.createSoapResponse(ResponseClones.SoapError,[ErrorType.OnboardAdmin,'301']);
top.logEvent(["CallStack: removing unsent call "+callObj.callName+" from stack."].concat(callObj.getProperties()),null,1,1);
try{
callObj.callback(callObj.result,callObj.callName);
}catch(e){
top.logEvent(["Call Stack: could not callback "+callObj.callName+" during emptyQueue().",e.message],null,1,4);
}
}
}
this.callQueue=new Array();
this.readyToPop=true;
};
function _cancelCalls(modSoap,uuid){
for(var index in this.callQueue){
var callObj=this.callQueue[index];
if(callObj.encId==uuid){
callObj.result=modSoap.createSoapResponse(ResponseClones.SoapError,[ErrorType.FormManager,'301']);
top.logEvent(["CallStack: cancelling pending call "+callObj.callName+"."].concat(callObj.getProperties()),null,1,3);
}
}
};
function _getHttpWrapper(){
return this.httpWrapper;
};
function _getStackSize(){
return this.callQueue.length;
};
function _push(callObj,isPriority){
if(this.unloading==false){
if(isPriority==true){
this.callQueue.unshift(callObj);
}else{
this.callQueue.push(callObj);
}
if(this.readyToPop==true){
this.pop();
}
}
};
function _pop(){
if(this.unloading==false){
if(this.callQueue.length>0){
this.readyToPop=false;
var callObj=this.callQueue.shift();
if(callObj.result!=null){
this.resultHandler(callObj);
}else{
this.getHttpWrapper().sendRequest(callObj);
}
}else{
this.readyToPop=true;
}
}
};
function _getStackInfo(){
var info=new Array("--------------------");
info.push("UUID: "+this.getUniqueId());
info.push("Stack Size: "+this.getStackSize());
info.push("Pending Tag: "+this.getPendingCallTag());
info.push("Ready to pop: "+this.readyToPop);
return info;
};
CallStack.prototype.toString=function(){return "Call Stack 1.0";}
CallStack.prototype.getPendingCallTag=_getPendingCallTag;
CallStack.prototype.containsCallTag=_containsCallTag;
CallStack.prototype.getHttpWrapper=_getHttpWrapper;
CallStack.prototype.getStackSize=_getStackSize;
CallStack.prototype.getStackInfo=_getStackInfo;
CallStack.prototype.getUniqueId=_getUniqueId;
CallStack.prototype.setUniqueId=_setUniqueId;
CallStack.prototype.unload=_unloadStack;
CallStack.prototype.emptyQueue=_emptyQueue;
CallStack.prototype.cancelCalls=_cancelCalls;
CallStack.prototype.deleteCall=_deleteCall;
CallStack.prototype.abortCall=_abortCall;
CallStack.prototype.push=_push;
CallStack.prototype.pop=_pop;
function CallBuffer(){
this.callBuffer=new Array();
};
function _addBufferedCall(callObject){
var dupeIndex=-1;
if(dupeIndex=this.indexOfDuplicate(callObject)>-1){
top.logEvent(["Call buffer: replacing duplicate call: "+callObject.callName,"Old Tag: "+this.callBuffer[dupeIndex].callTag,"New Tag: "+callObject.callTag],null,1,5);
this.callBuffer[dupeIndex]=callObject;
}else{
top.logEvent(["Call Buffer: adding call to buffer: "+callObject.callName].concat(callObject.getProperties()),null,4,3);
this.callBuffer.push(callObject);
}
};
function _getNextBufferedCall(){
return(this.getCallCount()>0?this.callBuffer.shift():false);
};
function _getBufferedCallCount(){
return(this.callBuffer.length);
};
function _indexOfDuplicate(callObject){
for(var index in this.callBuffer){
if(this.callBuffer[index].isDuplicate(callObject)){
return index;
}
}
return-1;
};
CallBuffer.prototype.toString=function(){return "Call Buffer 1.0";}
CallBuffer.prototype.addCall=_addBufferedCall;
CallBuffer.prototype.getNextCall=_getNextBufferedCall;
CallBuffer.prototype.getCallCount=_getBufferedCallCount;
CallBuffer.prototype.indexOfDuplicate=_indexOfDuplicate;
function CallObject(callName,sendType,url,data,callback,callTag,uniqueId,callType,maxWait){
this.encId=uniqueId;
this.callTag=callTag;
this.callName=callName;
this.callType=(existsNonNull(callType)?callType:CallTypes.API);
this.sendType=sendType;
this.url=url;
this.data=data;
this.serverCookie;
this.callback=callback;
this.maxWait=maxWait;
this.attempts=0;
this.reset();
};
function _resetCallObject(){
if(this.attempts>0){
top.logEvent(["Call Object: resetting "+this.callName].concat(this.getProperties()),this.encId,3,4);
}
this.responseText="";
this.result=null;
this.resultType="";
this.errorType="";
this.error="";
this.errorString="";
this.serverCookie=null;
this.actionRequired=ActionType.None;
this.attempts++;
};
function _isDuplicate(callObj){
try{
var props1=this.getProperties(true);
var props2=callObj.getProperties(true);
}catch(e){
top.logEvent(["Call Buffer: Could not get properties for comparison.",e.message],null,2,6);
return false;
}
for(var index in props1){
if(props1[index]!=props2[index]){
return false;
}
}
return true;
};
function _getProperties(basicOnly){
var props=new Array();
if(parseBool(basicOnly)){
props.push(this.encId);
props.push(this.callName);
props.push(this.callType);
props.push(this.sendType);
props.push(this.url);
props.push(this.serverCookie);
props.push(this.data);
props.push(this.callback);
props.push(this.maxWait);
}else{
props.push("Call Name: "+this.callName);
props.push("Call Tag: "+this.callTag);
props.push("Enclosure ID: "+this.encId);
props.push("Call Type: "+this.callType);
props.push("Send Type: "+this.sendType);
props.push("URL: "+this.url);
props.push("Server Cookie: "+this.serverCookie);
props.push("Max Wait: "+(this.maxWait==0?0:this.maxWait/1000)+" seconds");
props.push("Attempts: "+this.attempts);
props.push("Result Type: "+this.resultType);
props.push("Error Type: "+this.errorType);
props.push("Error: "+this.error);
props.push("Error String: ["+this.errorString+"]");
props.push("Action Required: "+this.actionRequired);
}
return props;
};
CallObject.prototype.toString=function(){return "Call Object 1.0";}
CallObject.prototype.getProperties=_getProperties;
CallObject.prototype.isDuplicate=_isDuplicate;
CallObject.prototype.reset=_resetCallObject;
Module("Transport","1.2.0",function(mod){
var CONN_MIN=2;
var CONN_MAX=20;
var currentState=ConnectionStates.None;
var eventState=ConnectionStates.EventsStopped;
var callBuffer=new CallBuffer();
var currentMode=-1;
var currentConns=0;
var modeSettings={
mode:null,
maxConns:null,
uuidArray:null
}
var xhrType=SupportedXhrTypes.NoSupport;
var topology=null;
var analyzer=null;
var soap=null;
var apiConns=null;
var eventConns=null;
var modeChangeListeners=new ListenerCollection();
var untimedCalls=new Array();
var callTagCounter=0;
var debugging=top.debugIsActive();
function transportDebug(debugState){
debugging=debugState;
};
function stateChangeEvent(newState){
var previousState=currentState;
echo("State change event: "+newState,2,1);
switch(newState){
case ConnectionStates.Initializing:
case ConnectionStates.Waiting:
currentState=newState;
break;
case ConnectionStates.Ready:
currentState=newState;
if(previousState==ConnectionStates.Waiting){
assertBufferEmptied();
}
break;
case ConnectionStates.EventsStarted:
case ConnectionStates.EventsStopped:
eventState=newState;
break;
case ConnectionStates.Unloading:
currentState=newState;
eventState=ConnectionStates.EventsStopped;
break;
case ConnectionStates.None:
default:
currentState=newState;
break;
}
};
function echo(msg,level,severity,extraData){
if(true){
var entry="Transport: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
}
};
function getStackInformation(){
var stackInfo=new Array(" ","API Connections:");
for(var i in apiConns){
stackInfo=stackInfo.concat(apiConns[i].getStackInfo());
}
stackInfo.push(" ","Event Connections:");
for(var j in eventConns){
stackInfo=stackInfo.concat(eventConns[j].getStackInfo());
}
return stackInfo;
};
function getModeInformation(){
var modeInfo=new Array();
modeInfo.push("Mode: "+modeSettings.mode);
modeInfo.push("Max Connections: "+modeSettings.maxConns);
for(var index in modeSettings.uuidArray){
modeInfo.push("Event stack UUID: "+modeSettings.uuidArray[index]);
}
return modeInfo;
};
function applyModeSettings(modeSettings){
switch(modeSettings.mode){
case connectionEnum.defaultMode:
case connectionEnum.extraMode:
if(currentMode!=modeSettings.mode||currentConns!=modeSettings.maxConns){
createConnections(modeSettings);
}
break;
case connectionEnum.tweakMode:
if(currentMode==connectionEnum.tweakMode){
updateConnections(modeSettings);
}else{
createConnections(modeSettings);
}
break;
}
echo("Connection Mode set.",1,3,getModeInformation().concat(getStackInformation()));
modeSettings.mode=null;
modeSettings.maxConns=null;
modeSettings.uuidArray=null;
stateChangeEvent(ConnectionStates.Ready);
};
function createConnections(modeSettings){
var i=0;
apiConns=new Array();
eventConns=new Array();
currentMode=modeSettings.mode;
currentConns=modeSettings.maxConns;
switch(modeSettings.mode){
case connectionEnum.defaultMode:
eventConns.push(new CallStack(xhrType,transportHandler));
apiConns.push(new CallStack(xhrType,transportHandler));
break;
case connectionEnum.extraMode:
eventConns.push(new CallStack(xhrType,transportHandler));
for(i=0;i<modeSettings.maxConns-1;i++){
apiConns.push(new CallStack(xhrType,transportHandler));
}
break;
case connectionEnum.tweakMode:
for(i=0;i<modeSettings.uuidArray.length;i++){
addDedicatedEventStack(modeSettings.uuidArray[i]);
}
for(i=0;i<(modeSettings.maxConns-modeSettings.uuidArray.length);i++){
apiConns.push(new CallStack(xhrType,transportHandler));
}
break;
default:
break;
}
modeChangeListeners.callListeners("CONNECTION_MODE_CHANGE",currentMode);
};
function updateConnections(modeSettings){
if(modeSettings.mode==connectionEnum.tweakMode){
currentConns=modeSettings.maxConns;
echo("Connection update pending.",2,4,getModeInformation().concat(getStackInformation()));
var i=0;
var apiCount=modeSettings.maxConns-modeSettings.uuidArray.length;
echo("Scanning "+apiConns.length+" api stacks.",4,2);
if(apiConns.length!=apiCount&&apiCount>0){
while(apiConns.length<apiCount){
echo("Adding api stack,",4,1);
apiConns.push(new CallStack(xhrType,transportHandler));
}
while(apiConns.length>apiCount){
echo("Removing api stack.",4,1);
apiConns.pop();
}
}
echo("Scanning "+eventConns.length+" event stacks",4,2);
for(i=eventConns.length-1;i>=0;i--){
if(!arrayContains(modeSettings.uuidArray,eventConns[i].getUniqueId())){
echo("Removing dedicated event stack for UUID: "+eventConns[i].getUniqueId(),2,1);
removeDedicatedEventStack(eventConns[i].getUniqueId());
}
}
for(i=0;i<modeSettings.uuidArray.length;i++){
if(getEventConnection(modeSettings.uuidArray[i])==false){
echo("Adding dedicated event stack for UUID: "+eventConns[i].getUniqueId(),2,1);
addDedicatedEventStack(modeSettings.uuidArray[i]);
}
}
echo("Connection update complete.",2,4,getModeInformation().concat(getStackInformation()));
}
};
function addDedicatedEventStack(uuid){
if(currentMode==connectionEnum.tweakMode){
for(var index in eventConns){
if(eventConns[index].getUniqueId()==uuid){
return true;
}
}
echo("Adding dedicated event stack for "+uuid,3,4);
var stack=new CallStack(xhrType,transportHandler);
stack.setUniqueId(uuid);
eventConns.push(stack);
return true;
}
return false;
};
function removeDedicatedEventStack(uuid){
for(var index in eventConns){
if(eventConns[index].getUniqueId()==uuid){
echo("Removing dedicated event stack for "+uuid,3,4);
eventConns.splice(index,1);
return true;
}
}
return false;
};
function queueCall(callObj){
if(currentState==ConnectionStates.Ready){
switch(callObj.callType){
case CallTypes.Event:
if(callObj.encId!=0&&topology.getProxyConnected(callObj.encId)==false){
echo("Enclosure can't get events now - creating clone event response.",1,6,callObj.getProperties());
callObj.result=soap.createSoapResponse(ResponseClones.Event,["EVENT_HEARTBEAT"]);
transportHandler(callObj);
return;
}
try{
getEventConnection(callObj.encId).push(callObj);
}catch(e1){
echo("Could not locate an event stack!",2,6,["UUID: "+callObj.encId].concat(getStackInformation()));
}
break;
case CallTypes.API:
default:
if(callObj.encId!=0&&topology.getProxyConnected(callObj.encId)==false){
echo("Enclosure can't make API calls now - creating clone API response.",1,6,callObj.getProperties());
callObj.result=soap.createSoapResponse(ResponseClones.Normal,[callObj.callName+"Response"]);
transportHandler(callObj);
return;
}
try{
if(callObj.maxWait==0){
addUntimedCall(callObj.callTag);
}
switch(callObj.callName){
case "ping":
echo("Adding priority call ("+callObj.callName+").",8,2);
getBestApiConnection().push(callObj,true);
break;
default:
getBestApiConnection().push(callObj);
break;
}
}catch(e2){
echo("Could not locate an api stack!",2,6,getStackInformation());
}
break;
}
}else{
callBuffer.addCall(callObj);
}
};
function assertBufferEmptied(){
while(callBuffer.getCallCount()>0&&currentState==ConnectionStates.Ready){
var callObj=callBuffer.getNextCall();
if(debugging==true){
echo("Removing "+callObj.callName+" from buffer.",2,1);
}
queueCall(callObj);
}
};
function assertStackClean(stack){
stack.unload(currentState==ConnectionStates.Unloading?null:soap);
};
function getLeastStack(stackArray){
var min=10000;
var minIndex=0;
var leastStack=null;
if(stackArray.length>0){
for(var index in stackArray){
var size=stackArray[index].getStackSize();
if(size==0){
minIndex=index;
break;
}else if(size<min){
min=size;
minIndex=index;
}
}
leastStack=stackArray[minIndex];
}
return(existsNonNull(leastStack)?leastStack:false);
};
function getBestApiConnection(){
switch(eventState){
case ConnectionStates.EventsStopped:
var eventStack=getLeastStack(eventConns);
var apiStack=getLeastStack(apiConns);
if(eventStack.getStackSize()<apiStack.getStackSize()){
echo("Using an EVENT stack for an API call.",8,1);
return eventStack;
}else{
echo("Using an API stack for an API call.",8,1);
return apiStack;
}
break;
case ConnectionStates.EventsStarted:
default:
echo("Events started, using an API stack for an API call.",8,1);
return getLeastStack(apiConns);
break;
}
};
function getEventConnection(uniqueId){
var eventConn=null;
if(eventConns.length>0){
if(currentMode==connectionEnum.tweakMode){
for(var index in eventConns){
if(eventConns[index].getUniqueId()==uniqueId){
echo("Using EVENT stack "+uniqueId+" for eventing in tweak mode.",8,1);
eventConn=eventConns[index];
break;
}
}
}else{
echo("Using an EVENT stack for eventing in "+currentMode,8,1);
eventConn=eventConns[0];
}
}
return(existsNonNull(eventConn)?eventConn:false);
};
function getPendingCallCount(){
var index=0;
var apiCount=0;
var eventCount=0;
if(existsNonNull(apiConns)){
for(index in apiConns){
apiCount+=apiConns[index].getStackSize();
}
}
if(existsNonNull(eventConns)){
for(index in eventConns){
eventCount+=eventConns[index].getStackSize();
}
}
return(apiCount+eventCount);
};
function abortCall(stackArray,callTag){
for(var index in stackArray){
if(stackArray[index].getPendingCallTag()==callTag){
return stackArray[index].abortCall(callTag);
echo("Aborted call ("+callTag+")",1,6);
}else if(stackArray[index].containsCallTag(callTag)){
return stackArray[index].deleteCall(callTag);
echo("Deleted call ("+callTag+")",1,6);
}
}
return false;
};
function getCallTag(){
if(callTagCounter>20480){
callTagCounter=0;
}
return++callTagCounter;
};
function analyzeResponse(callObject){
return(analyzer.analyze(callObject));
};
function getUntimedCallIndex(callTag){
for(var i=0;i<untimedCalls.length;i++){
if(untimedCalls[i]==callTag){
return i;
}
}
return-1;
};
function addUntimedCall(callTag){
if(getUntimedCallIndex(callTag)==-1){
untimedCalls.push(callTag);
echo("Added an untimed call ("+callTag+") to the collection.",1,3,["Total: "+untimedCalls.length]);
}
};
function removeUntimedCall(callTag){
var index=getUntimedCallIndex(callTag);
if(index>-1){
untimedCalls.splice(index,1);
echo("Removed an untimed call ("+callTag+") from the collection.",1,2,["Total: "+untimedCalls.length]);
}
};
function performAction(callObject){
var destroyOk=true;
switch(callObject.actionRequired){
case ActionType.UpdateTopology:
echo("ActionType.UpdateTopology",1,3,callObject.getProperties());
topology.updateTopology();
break;
case ActionType.NotifyCommLoss:
echo("ActionType.NotifyCommLoss - UUID: "+callObject.encId,1,6,callObject.getProperties());
topology.notifyCommLoss(callObject.encId,callObject.url);
break;
case ActionType.NotifyAuthFailed:
echo("ActionType.NotifyAuthFailed - UUID: "+callObject.encId,1,6,callObject.getProperties());
topology.notifyAuthenticationFailed(callObject.encId,callObject.callName,callObject.url);
break;
case ActionType.RetryRequest:
echo("Retrying request for "+callObject.callName,1,5,callObject.getProperties());
destroyOk=false;
var delayMS=(callObject.error==HttpErrors.BadGateway||callObject.error==HttpErrors.InService?3000:1000);
echo("Setting retry delay to "+delayMS+" milliseconds.",8,4);
callObject.reset();
window.setTimeout(function(){queueCall(callObject)},delayMS);
break;
case ActionType.NotifyPipeLoss:
echo("ActionType.NotifyPipeLoss - UUID: "+callObject.encId,1,6,callObject.getProperties());
topology.notifyEventPipeLoss(callObject.encId);
break;
case ActionType.UseLocalOnly:
echo("ActionType.UseLocalOnly",1,3,callObject.getProperties());
topology.setTopologyMode(TopologyModes.Local);
break;
case ActionType.UseStandbyMode:
echo("ActionType.UseStandbyMode",1,3,callObject.getProperties());
topology.notifyStandbyMode();
break;
case ActionType.CreateApiResponse:
echo("Creating an api response clone for "+callObject.callName,2,5,callObject.getProperties());
callObject.result=soap.createSoapResponse(ResponseClones.Normal,[callObject.callName+"Response"]);
break;
case ActionType.CreateEventResponse:
echo("Creating an event heartbeat response clone.",1,6,callObject.getProperties());
callObject.result=soap.createSoapResponse(ResponseClones.Event,["EVENT_HEARTBEAT"]);
break;
case ActionType.CreateSoapError:
echo("Creating a soap fault response clone for "+callObject.callName,2,5,callObject.getProperties());
callObject.result=soap.createSoapResponse(ResponseClones.SoapError,[ErrorType.OnboardAdmin,callObject.error]);
break;
case ActionType.CreateTimedOutError:
echo("Creating a timed out response for "+callObject.callName,2,5,callObject.getProperties());
callObject.result=soap.createSoapResponse(ResponseClones.SoapError,[ErrorType.FormManager,ErrorCode.TimedOut]);
break;
default:
break;
}
return destroyOk;
};
function transportHandler(callObj){
if(callObj.serverCookie!=null){
echo("Server cookie received.",1,4,[callObj.serverCookie]);
topology.notifyCookieSet(callObj.encId,callObj.serverCookie);
}
if(callObj.result==null){
callObj.result=soap.parseResponseText(callObj.responseText);
}
var callbackOk=analyzeResponse(callObj);
var destroyOk=true;
if(callObj.actionRequired!=ActionType.None){
destroyOk=performAction(callObj);
}
if(debugging==true){
echo("callbackOk flag set to "+callbackOk,8,1);
}
if(callbackOk==true){
try{
callObj.callback(callObj.result,callObj.callName);
}catch(e){
echo("Unsuccessful callback for "+callObj.callName,1,6,[e.message]);
}
}
if(destroyOk){callObj=null;}
if(currentState==ConnectionStates.Waiting&&getPendingCallCount()==0){
applyModeSettings(modeSettings);
}
};
mod.getCallAnalyzer=function(){
return analyzer;
};
mod.getSoap=function(){
return soap;
};
mod.init=function(){
xhrType=getSupportedXhrType();
top.registerDebugListener(transportDebug);
if(currentState==ConnectionStates.None){
mod.setConnectionMode(connectionEnum.defaultMode,CONN_MIN);
}
try{
topology=importModule("topology");
}catch(e1){echo('could not import the topology module.',1,7,[e1.message]);}
try{
analyzer=importModule("CallAnalyzer");
}catch(e2){echo('could not import the call analyzer module.',1,7,[e2.message]);}
try{
soap=importModule("Soap");
}catch(e3){echo('could not import the soap module.',1,7,[e3.message]);}
};
mod.clearCallStacks=function(){
for(var i in eventConns){
assertStackClean(eventConns[i]);
}
for(var j in apiConns){
assertStackClean(apiConns[j]);
}
};
mod.unload=function(){
stateChangeEvent(ConnectionStates.Unloading);
mod.clearCallStacks();
eventConns=null;
apiConns=null;
untimedCalls=new Array();
stateChangeEvent(ConnectionStates.None);
};
mod.notifySessionReset=function(){
stateChangeEvent(ConnectionStates.EventsStopped);
};
mod.addModeChangeListener=function(listener,isMaster){
return modeChangeListeners.addListener(listener,["CONNECTION_MODE_CHANGE"],isMaster);
};
mod.removeModeChangeListener=function(listener){
return modeChangeListeners.removeListener(listener);
};
mod.assertUntimedCallsEnded=function(uniqueId){
var callTags=new Array();
for(var i=0;i<untimedCalls.length;i++){
for(var index in apiConns){
if(apiConns[index].getPendingCallTag()==untimedCalls[i]){
var callObj=apiConns[index].getHttpWrapper().xhrObject.callObj;
if(exists(uniqueId)?callObj.encId==uniqueId:true){
echo("Ending an untimed call.",1,5,callObj.getProperties());
apiConns[index].abortCall(untimedCalls[i]);
callTags.push(untimedCalls[i]);
}
}
}
}
for(var j=0;j<callTags.length;j++){
removeUntimedCall(callTags[j]);
}
};
mod.updateDedicatedEventStacks=function(uuids){
echo("updateDedicatedEventStacks called.",1,3,uuids);
if(currentMode==connectionEnum.tweakMode&&isArray(uuids)){
mod.setConnectionMode(currentMode,currentConns,uuids);
}
};
mod.setConnectionMode=function(mode,maxConns,uuidArray){
stateChangeEvent(ConnectionStates.Initializing);
var conns=assertNumericRange(maxConns,CONN_MIN,CONN_MAX);
var uuids=assertArray(uuidArray);
if(mode==connectionEnum.tweakMode){
if(uuids.length==0||conns<=uuids.length||arrayContains(uuids,null)){
mode=connectionEnum.extraMode;
}
}
if(mode==connectionEnum.extraMode&&!(conns>CONN_MIN)){
mode=connectionEnum.defaultMode;
}
modeSettings.mode=mode;
modeSettings.maxConns=(mode==connectionEnum.defaultMode?2:conns);
modeSettings.uuidArray=uuids;
if(getPendingCallCount()>0){
stateChangeEvent(ConnectionStates.Waiting);
return;
}
applyModeSettings(modeSettings);
};
mod.getConnectionMode=function(){
return currentMode;
};
mod.containsEventStack=function(uuid){
return(getEventConnection(uuid)==false?false:true);
};
mod.getTotalApiConnections=function(){
return(existsNonNull(apiConns)?apiConns.length:0);
};
mod.getTotalEventConnections=function(){
return(existsNonNull(eventConns)?eventConns.length:0);
};
mod.cancelCalls=function(uuid){
for(var i in apiConns){
apiConns[i].cancelCalls(soap,uuid);
}
for(var j in eventConns){
eventConns[j].cancelCalls(soap,uuid);
}
};
mod.abortRequest=function(callTag,callType){
var success=false;
switch(callType){
case CallTypes.Event:
success=abortCall(eventConns,callTag);
break;
case CallTypes.API:
default:
success=abortCall(apiConns,callTag);
if(!success&&eventState==ConnectionStates.EventsStopped){
success=abortCall(eventConns,callTag);
}
break;
}
echo("Client Requested abort on call ("+callTag+") - "+(success?"done.":"not active."),1,(success?2:4));
return success;
};
mod.sendRequest=function(callDescriptor,params,url,securityHdr,callback,uniqueId,type,maxWait){
if(currentState==ConnectionStates.Unloading||currentState==ConnectionStates.None){
return 0;
}
var callTag=getCallTag();
var data=soap.createSoapRequest(callDescriptor,params,securityHdr);
if(true){
echo("Adding call to queue: "+callDescriptor.fname+"("+callTag+")",6,8,[data]);
}
if(eventState!=ConnectionStates.EventsStarted&&type==CallTypes.Event){
stateChangeEvent(ConnectionStates.EventsStarted);
}
queueCall(new CallObject(callDescriptor.fname,"POST",url,data,callback,callTag,uniqueId,type,maxWait));
return callTag;
};
mod.init();
});
