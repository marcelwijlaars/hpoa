/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function events(owner,callback){
var me=this;
var timerId=0;
var MIN_INTERVAL=(15*1000);
var sleepInterval=MIN_INTERVAL;
var getAllEvents="getAllEvents";
var oaFwVersion="";
this.timeStampEnabled=true;
this.hpemOwner=owner;
this.isSelected=false;
this.eventID=null;
this.masterCallback=callback;
this.listenerCollection=new ListenerCollection();
this.readyEventCallback=true;
this.fifo=new Array();
this.eventsOn=false;
this.getLcdEvents=false;
this.callMethod=null;
this.remoteDebug=false;
this.debugging=function(){return top.debugIsActive();}
this.sleeping=false;
this.callTag=0;
function getEventParams(wait){
return(oaFwVersion==""?[me.eventID,wait,me.getLcdEvents]:[me.eventID,wait,me.getLcdEvents,oaFwVersion]);
}
this.notifyFirmwareVersionChange=function(version){
if(!isNaN(version)){
getAllEvents=(version>=2.20?"getAllEventsEx":"getAllEvents");
oaFwVersion=(version>=2.20?"%0.2f".format(version):"");
top.logEvent(["Events: firmware version set to "+version,"Call: "+getAllEvents,"Version string: "+oaFwVersion],me.hpemOwner.getEnclosureNumber(),1,1);
}
}
this.eventLoopHandler=function(result,fname,callback){
var calledNextEvent=false;
if(this.debugging()==true){
top.logEvent('Events: callback received for '+fname,me.hpemOwner.getEnclosureNumber(),5,1);
}
if(!getCallSuccess(result)){
me.processError(result,fname);
}else{
try{
var eventArray=deCompileXmlArray(result,'//hpoa:eventInfoArray','hpoa:eventInfo','none');
for(var i=0;i<eventArray.length;i++){
var eventName=getElementValueXpath(eventArray[i],'//hpoa:event');
var eventObj=new EventObject(eventArray[i],fname,eventName);
if(me.hpemOwner.getHasFocus()==true){
if(i==eventArray.length-1){
try{me.processTimeStamp(eventArray[i]);}catch(e){}
}
}
me.push(eventObj);
}
callback(result,fname);
calledNextEvent=true;
if(me.readyEventCallback==true){
me.pop();
}
}catch(e){
top.logEvent(["Events: error processing result for "+fname,e.message],me.hpemOwner.getEnclosureNumber(),1,7);
}
}
if(!calledNextEvent){
callback(result,fname);
}
this.initSleep();
}
this.eventSubscriptionCallbackNoStart=function(result){
if(!getCallSuccess(result)){
me.eventID=null;
me.eventsOn=false;
me.subscriptionCallback(false,"subscribeForEvents");
}else{
me.eventID=getElementValueXpath(result,'//hpoa:pid');
me.timeStampEnabled=(isFunction(top.checkStandby)&&top.checkStandby()==false);
me.eventsOn=true;
me.subscriptionCallback(true,"subscribeForEvents");
}
}
this.eventSubscriptionCallback=function(result){
if(!getCallSuccess(result)){
me.eventID=null;
me.eventsOn=false;
me.subscriptionCallback(false);
}else{
me.eventID=getElementValueXpath(result,'//hpoa:pid');
me.timeStampEnabled=(isFunction(top.checkStandby)&&top.checkStandby()==false);
me.eventsOn=true;
me.subscriptionCallback(true);
}
}
this.getNextEvent=function(waitForEvent,callback){
if(!me.eventsOn){
top.logEvent("Events: getNextEvent called with eventsOn==false",null,3,5);
if(me.hpemOwner.getIsLocal()==true){
top.getEventManager().stopEventLoop();
}
if(isFunction(callback)){callback();}
return;
}
try{
me.callTag=me.callMethod(getAllEvents,getEventParams(true),function(result,fname){
me.eventLoopHandler(result,fname,callback);
},true,CallTypes.Event,180000);
}catch(e){}
return me.callTag;
}
this.getNextEventNoWait=function(callback){
if(!me.eventsOn){
if(isFunction(callback)){callback();}
top.logEvent("Events: getNextEventNoWait called with eventsOn==false",null,3,5);
return;
}
try{
me.callTag=me.callMethod(getAllEvents,getEventParams(false),function(result,fname){
me.eventLoopHandler(result,fname,callback);
},true,CallTypes.Event,45000);
}catch(e){
top.logEvent(["Events: error calling getNextEventNoWait!",e.message],me.hpemOwner.getEnclosureNumber(),1,6);
}
}
this.generateHeartbeat=function(callback){
top.logEvent(["Events: Generating heartbeat,","PID: "+me.eventID],me.hpemOwner.getEnclosureNumber(),1,2);
window.setTimeout(function(){try{me.callMethod("generateHeartbeat",[me.eventID],callback);}catch(e){}},10);
}
this.turnEventsOff=function(unsubscribeCallback){
if(!me.eventsOn||typeof(me.callMethod)=='undefined'||me.callMethod==null){
if(isFunction(unsubscribeCallback)){
unsubscribeCallback(false);
}
return;
}
me.eventsOn=false;
top.logEvent("Events: Turning events off.",me.hpemOwner.getEnclosureNumber(),3,1);
if(me.callTag>0){
try{
me.hpemOwner.abortCall(CallTypes.Event,me.callTag);
}catch(e){}
}
me.callTag=0;
window.setTimeout(function(){
me.callMethod("unSubscribeForEvents",[me.eventID],function(result){
me.reset();
if(isFunction(unsubscribeCallback)){
unsubscribeCallback(result);
}
},true,null,10000);
},5);
}
this.setSleepInterval=function(milliseconds,reset){
sleepInterval=parseInt(milliseconds);
if(isNaN(sleepInterval)){
sleepInterval=MIN_INTERVAL;
}
top.logEvent("Events: Sleep interval set: "+sleepInterval+"(ms)",me.hpemOwner.getEnclosureNumber(),8,1);
if(reset==true){
this.stopSleeping();
}
}
this.initSleep=function(){
((this.hpemOwner.getIsLocal()||this.hpemOwner.getHasFocus())?this.stopSleeping():this.startSleeping());
}
this.startSleeping=function(){
this.stopSleeping();
timerId=window.setTimeout(function(){me.stopSleeping(true);},sleepInterval);
this.sleeping=true;
if(this.debugging()==true){
top.logEvent("Events: Sleeping started.",me.hpemOwner.getEnclosureNumber(),8,1);
}
}
this.stopSleeping=function(timedOut){
if(timedOut==true){
if(this.debugging()==true){
top.logEvent("Events: Sleep cycle ended.",me.hpemOwner.getEnclosureNumber(),8,2);
}
}else if(timerId>0){
window.clearTimeout(timerId);
if(this.debugging()==true){
top.logEvent("Events: Sleeping stopped.",me.hpemOwner.getEnclosureNumber(),8,1);
}
}
this.sleeping=false;
timerId=0;
}
this.generateEvent=function(eventName,payloadSource,payloadElementName){
var eventDoc=top.getSoapModule().createSoapResponse(ResponseClones.Event,[eventName,payloadSource,payloadElementName]);
var eventObj=new EventObject(eventDoc,getAllEvents,eventName);
me.callListeners(eventObj);
}
};
function _setCallMethod(callMethod){
this.callMethod=callMethod;
};
function _setLcdEventsEnabled(enabled){
if(this.getLcdEvents!=enabled){
this.getLcdEvents=enabled;
if(enabled==true){
this.generateHeartbeat(function(){});
}
}
};
function _callListeners(eventObj){
this.readyEventCallback=false;
try{
this.masterCallback(eventObj.result);
this.listenerCollection.callListeners(eventObj.eventName,eventObj.result,this.hpemOwner.encNum);
}catch(e){
}finally{
this.readyEventCallback=true;
this.pop();
}
};
function _push(eventObj){
if(this.fifo==null){
this.fifo=new Array();
}
this.fifo.push(eventObj);
};
function _pop(){
if(this.fifo==null){
this.fifo=new Array();
}
if(this.fifo.length>0&&this.readyEventCallback){
var eventObj=this.fifo.shift();
this.callListeners(eventObj);
}
};
function _processTimeStamp(result){
if(this.timeStampEnabled==false||top.mainPage.getLeftSideFrame==undefined){
return;
}
var timeStamp=getElementValueXpath(result,'//hpoa:eventTimeStamp');
if(timeStamp!=''){
try{
if(isFunction(top.mainPage.getLeftSideFrame().updateTimestamp)){
top.mainPage.getLeftSideFrame().updateTimestamp(timeStamp);
}
if(this.debugging()==true){
top.logEvent("Events: timestamp updated: "+timeStamp,this.hpemOwner.getEnclosureNumber(),6,2);
}
}catch(e){
top.logEvent(["Events: could not update timestamp.","Error: "+e.message],this.hpemOwner.getEnclosureNumber(),8,5);
}
}
};
function _processError(result,fname){
var output="Null";
var unexpected=true;
try{
output=result.xml;
unexpected=(getElementValueXpath(result,'//hpoa:errorCode')!=XhrErrors.Aborted);
}catch(e){}
if(unexpected){
top.logEvent(["Events: an error was detected in the response.",output],this.hpemOwner.getEnclosureNumber(),1,6);
}
};
function _removeCallback(callback){
this.listenerCollection.removeListener(callback);
};
function _addCallback(callback,eventTypes){
this.listenerCollection.addListener(callback,eventTypes);
};
function _getCallbackCount(){
return this.listenerCollection.getTotalListeners();
};
function _turnEventsOn(masterCallback,subscriptionCallback){
if(this.eventsOn){
return;
}
this.readyEventCallback=true;
top.logEvent("Events: turning on events.",this.hpemOwner.getEnclosureNumber(),3,1);
if(masterCallback){
this.masterCallback=masterCallback;
}
if(subscriptionCallback){
this.subscriptionCallback=subscriptionCallback;
}
this.callMethod("subscribeForEvents",[],this.eventSubscriptionCallbackNoStart,true,null,45000);
};
function _resetEvents(removeListeners){
this.eventsOn=false;
this.timeStampEnabled=true;
this.eventID=null;
if(this.callTag>0){
try{
this.hpemOwner.abortCall(CallTypes.Event,this.callTag);
}catch(e){}
}
this.callTag=0;
if(removeListeners==true){
this.listenerCollection=new ListenerCollection();
}
};
function EventObject(result,fname,eventName){
this.result=result;
this.fname=fname;
this.eventName=eventName;
}
events.prototype.setCallMethod=_setCallMethod;
events.prototype.setLcdEventsEnabled=_setLcdEventsEnabled;
events.prototype.processTimeStamp=_processTimeStamp;
events.prototype.getCallbackCount=_getCallbackCount;
events.prototype.removeCallback=_removeCallback;
events.prototype.addCallback=_addCallback;
events.prototype.turnEventsOn=_turnEventsOn;
events.prototype.callListeners=_callListeners;
events.prototype.processError=_processError;
events.prototype.reset=_resetEvents;
events.prototype.pop=_pop;
events.prototype.push=_push;
