/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function PollManager(){
var MIN_INTERVAL=10;
var pollObjects=new Object();
function echo(msg,level,severity,extraData){
var entry="Poll Manager: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function pollClientExists(callback){
return(typeof(pollObjects[callback.toString()])!='undefined');
};
this.addPollClient=function(callback,seconds,auto){
if(isNaN(seconds)||seconds<MIN_INTERVAL){
seconds=MIN_INTERVAL;
}
if(pollClientExists(callback)){
echo("Existing client detected, initializing.",8,3,[callback.toString()]);
pollObjects[callback.toString()].init();
}else{
echo("Adding new poll client.",4,1,[callback.toString()]);
pollObjects[callback.toString()]=new PollObject(callback,seconds,auto);
}
};
this.removePollClient=function(callback){
if(pollClientExists(callback)){
echo("Removing poll client.",4,1,[callback.toString()]);
pollObjects[callback.toString()].stopPolling();
delete pollObjects[callback.toString()];
return true;
}
echo("Could not remove poll client: not found.",1,4,[callback.toString()]);
return false;
};
this.togglePollClient=function(callback,toggleOn){
if(pollClientExists(callback)){
echo("Toggling poll state to "+(toggleOn?"on.":"off."),4,1);
if(toggleOn==true){
pollObjects[callback.toString()].startPolling();
}else{
pollObjects[callback.toString()].stopPolling();
}
}
};
this.stopPollingAll=function(remove){
echo("Stopping polling on all poll objects.",1,2,this.toString());
for(var index in pollObjects){
pollObjects[index].stopPolling();
if(remove==true){
echo("Deleting poll object.",4,1,[index]);
delete pollObjects[index];
}
}
};
this.startPollingAll=function(){
echo("Starting polling on all poll objects.",1,2,this.toString());
for(var index in pollObjects){
pollObjects[index].startPolling();
}
};
this.unload=function(){
this.stopPollingAll(true);
};
this.toString=function(){
var output=new Array();
for(var index in pollObjects){
var pollObj=pollObjects[index];
output.push("Polling: "+pollObj.isPolling());
output.push("Auto Cycle: "+pollObj.isAuto());
output.push("Callback: "+index);
output.push("______________________________");
}
return output;
}
};
function PollObject(callback,seconds,auto){
var me=this;
var pollingCallback=callback;
var interval=seconds*1000;
var autoCycle=assertTrue(auto);
var timerId=0;
function echo(msg,level,severity,extraData){
var entry="Poll Object: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function stopTimer(){
if(timerId>0){
echo("Polling stopped.",1,2);
window.clearTimeout(timerId);
}
timerId=0;
};
this.isPolling=function(){
return(timerId>0);
};
this.isAuto=function(){
return(autoCycle==true);
};
this.startPolling=function(){
stopTimer();
echo("Starting poll cycle for "+(interval/1000)+" seconds.",4,1);
timerId=window.setTimeout(me.notifyClient,interval);
};
this.stopPolling=function(){
stopTimer();
};
this.init=function(){
if(autoCycle==true){
this.startPolling();
}
};
this.notifyClient=function(){
timerId=0;
try{
echo("Notifying poll client.",4,2,[pollingCallback.toString()]);
pollingCallback();
}catch(e){
echo("Could not notify client.",1,5,[e.message]);
}finally{
if(autoCycle==true){
me.startPolling();
}
}
};
this.init();
};
