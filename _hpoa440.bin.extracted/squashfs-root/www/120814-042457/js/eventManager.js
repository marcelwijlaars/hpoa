/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Module("EventManager","1.2.0",function(mod){
var MAX_LOOP_STOP=(1000*(3*60));
var pauseTimerId=0;
var currentMode=-1;
var currentThrottle=EventThrottle.Auto;
var currentRunState=EventRunStates.Ready;
var focusId=0;
var transport=null;
var topology=null;
var formMgr=null;
var debugging=top.debugIsActive();
function eventManagerDebug(debugState){
debugging=debugState;
};
function echo(msg,level,severity,extraData){
if(debugging==true){
var entry="Event Manager: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
}
};
function focusChangeEvent(enclosureNumber){
echo("Focus change listener notified.\tSELECTED ENCLOSURE: "+enclosureNumber,3,3);
switch(currentMode){
case connectionEnum.defaultMode:
case connectionEnum.extraMode:
if(focusId!=enclosureNumber){
var hpemObj=(currentRunState==EventRunStates.Started?topology.getProxy(focusId):null);
focusId=enclosureNumber;
if(hpemObj!=null&&hpemObj.getEventsOn()==true){
hpemObj.generateHeartbeat(null);
}
}
break;
case connectionEnum.tweakMode:
default:
break;
}
};
function startPauseTimer(){
stopPauseTimer();
pauseTimerId=window.setTimeout(assertLoopStarted,MAX_LOOP_STOP);
echo("Event loop safeguard activated.",1,4,["Delay ms: "+MAX_LOOP_STOP]);
};
function stopPauseTimer(){
if(pauseTimerId>0){
window.clearTimeout(pauseTimerId);
pauseTimerId=0;
echo("Event loop safeguard timer reset.",1,4);
}
};
function assertLoopStarted(){
pauseTimerId=0;
echo("Event loop safeguard triggered.",1,4,["Current Run State: "+currentRunState]);
if(currentRunState==EventRunStates.Paused){
echo("Restoring event loop after max delay.",1,6,["Delay ms: "+MAX_LOOP_STOP]);
modeChangeEvent(currentMode,true);
}
};
function topologyPendingEvent(){
if(currentRunState==EventRunStates.Started){
echo("Topology pending, pausing event loop.",1,2);
currentRunState=EventRunStates.Paused;
startPauseTimer();
}
};
function topologyUpdatedEvent(){
if(currentMode==connectionEnum.tweakMode){
transport.updateDedicatedEventStacks(topology.getUuidArray());
}
if(currentRunState==EventRunStates.Paused){
echo("Topology update complete, restarting event loop.",1,2);
modeChangeEvent(currentMode,true);
}
};
function modeChangeEvent(newMode,startLoop){
echo("Event mode set: "+newMode,2,1,["Param (startLoop): "+assertFalse(startLoop)]);
switch(newMode){
case connectionEnum.defaultMode:
case connectionEnum.extraMode:
currentMode=newMode;
if(startLoop&&currentRunState!=EventRunStates.Started){
echo("Hybrid event loop STARTED.",1,1);
currentRunState=EventRunStates.Started;
processNormalModes();
}
return true;
case connectionEnum.tweakMode:
currentMode=newMode;
if(startLoop){
currentRunState=EventRunStates.Started;
echo("Full-Blocking event loop STARTED.",1,1);
processTweakMode();
}
return true;
default:
echo("Unknown connection mode: "+newMode,1);
break;
}
return false;
};
function processNormalModes(){
if(currentRunState==EventRunStates.Started){
if(debugging==true){
echo("Sending blocking event call for Enc: "+focusId,4,1);
}
var selectedProxy=topology.getSelectedProxy();
if(selectedProxy.getIsLocal()==false&&selectedProxy.getEventsOn()==false){
echo("A linked enclosure was unloaded while in focus.",1,5);
topology.selectPrimaryEnclosure();
}
try{
topology.getSelectedProxy().getNextEvent(true,processNonBlockingEvents);
}catch(e){
echo("Unable to reference a valid proxy.",1,7,[e.message]);
}
}else{
echo("Cannot process event calls: Invalid Run State: "+currentRunState,1,5);
}
};
function processNonBlockingEvents(){
if(currentRunState==EventRunStates.Started){
var hpemObjects=topology.getProxies();
formMgr.startTransactionBatch(true);
for(var index in hpemObjects){
if(hpemObjects[index].getEventsOn()==true&&hpemObjects[index].getEnclosureNumber()!=focusId){
if(hpemObjects[index].getEvents().sleeping==false||currentThrottle==EventThrottle.None){
if(debugging==true){
echo("Queueing non-blocking event call for Enc: "+hpemObjects[index].getEnclosureNumber(),4,1);
}
formMgr.queueCall(hpemObjects[index].getNextEventNoWait);
}else{
if(debugging==true){
echo("Sleeping - wait until next loop. Enc: "+hpemObjects[index].getEnclosureNumber(),4,1);
}
}
}
}
formMgr.endBatch();
}else{
echo("Cannot process non-blocking event calls: Invalid Run State: "+currentRunState,1,5);
}
};
function processTweakMode(){
var hpemObjects=topology.getProxies();
for(var index in hpemObjects){
if(hpemObjects[index].getEventsOn()==true&&hpemObjects[index].getEnclosureNumber!=focusId){
echo("Starting tweak mode for enc"+hpemObjects[index].getEnclosureNumber(),1,2);
hpemObjects[index].getNextEvent(true,tweakModeCallback);
}
}
};
function tweakModeCallback(result,methodName,hpemObj){
if(currentRunState==EventRunStates.Started&&hpemObj.getEventsOn()==true){
hpemObj.getNextEvent(true,tweakModeCallback);
}
};
mod.init=function(){
echo("Initializing the Event Manager class.",4,1);
top.registerDebugListener(eventManagerDebug);
currentThrottle=EventThrottle.Auto;
formMgr=new FormManager(processNormalModes);
formMgr.setTimeoutEnabled(true,90000,false);
try{
topology=importModule("topology");
topology.addFocusChangeListener(focusChangeEvent);
topology.addTopologyPendingListener(topologyPendingEvent);
topology.addTopologyCompleteListener(topologyUpdatedEvent);
}catch(e1){
echo("Error initializing topology!",1,7,[e1.message]);
}
try{
transport=importModule("Transport");
currentMode=transport.getConnectionMode();
transport.addModeChangeListener(modeChangeEvent);
}catch(e2){
echo("Error initializing Transport!",1,7,[e2.message]);
}
};
mod.unload=function(){
echo("Unloading Module.",3,1);
stopPauseTimer();
formMgr=null;
try{
topology.removeListener(focusChangeEvent);
topology.removeListener(topologyPendingEvent);
topology.removeListener(topologyUpdatedEvent);
topology=null;
}catch(e1){}
try{
transport.removeListener(modeChangeEvent);
transport=null;
}catch(e2){}
};
mod.setEventThrottle=function(type){
currentThrottle=type;
echo("Throttle set to "+type,1,1);
};
mod.getEventThrottle=function(){
return currentThrottle;
};
mod.setEventMode=function(mode){
return modeChangeEvent(mode);
};
mod.startEventLoop=function(){
return modeChangeEvent(currentMode,true);
};
mod.stopEventLoop=function(){
if(currentRunState!=EventRunStates.Stopped){
echo("Event loop STOPPED.",1,1);
currentRunState=EventRunStates.Stopped;
}
};
mod.init();
});
