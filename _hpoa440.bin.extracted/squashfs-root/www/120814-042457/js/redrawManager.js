/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function RedrawManager(){
var redrawObjects=new Object();
function echo(msg,level,severity,extraData){
var entry="Redraw Manager: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function containsRedrawObject(methodOrId){
if(isFunction(methodOrId)){
return(typeof(redrawObjects[methodOrId.toString()])!=undefined);
}else{
for(var key in redrawObjects){
if(redrawObjects[key].id==methodOrId){
return true;
}
}
}
return false;
}
this.addRedrawObject=function(sleepInterval,method,id,updateLimit){
if(isFunction(method)&&!containsRedrawObject(method)){
redrawObjects[method.toString()]=new RedrawObject(sleepInterval,method,id,updateLimit);
echo("Added new redraw object ("+(id?id:"w/o ID")+").",1,1,this.getRedrawObject(method).getObjectInfo());
}
}
this.removeRedrawObject=function(methodOrId){
var redrawObj=this.getRedrawObject(methodOrId);
if(redrawObj){
delete redrawObjects[redrawObj.updateHandler.toString()];
echo("Removed redraw object.",1,5,["Identifier: "+methodOrId.toString()," "].concat(this.getObjectInfo()));
}
}
this.getIsSleeping=function(methodOrId){
if(containsRedrawObject(methodOrId)){
return this.getRedrawObject(methodOrId).sleeping;
}
return false;
}
this.startSleeping=function(methodOrId){
if(containsRedrawObject(methodOrId)){
echo("Starting sleep cycle.",1,1,["Identifier: "+methodOrId.toString()]);
this.getRedrawObject(methodOrId).sleep();
}
}
this.addRequest=function(methodOrId,payload){
if(containsRedrawObject(methodOrId)){
this.getRedrawObject(methodOrId).addRequest(payload);
echo("Added redraw request.",8,4,["Identifier: "+methodOrId.toString()]);
}
}
this.getRedrawObject=function(methodOrId){
if(containsRedrawObject(methodOrId)){
if(isFunction(methodOrId)){
return redrawObjects[methodOrId.toString()];
}else{
for(var key in redrawObjects){
if(redrawObjects[key].id==methodOrId){
return redrawObjects[key];
}
}
}
}
return null;
}
this.reset=function(){
echo("Reset called (entry).",1,3,this.getObjectInfo());
for(var key in redrawObjects){
redrawObjects[key].reset();
}
redrawObjects=new Object();
echo("Reset called (exit).",1,3,this.getObjectInfo());
}
this.getObjectInfo=function(){
var list=new Array("Redraw Objects:","-----------------");
for(var key in redrawObjects){
list=list.concat(redrawObjects[key].getObjectInfo());
}
return list;
}
};
function RedrawObject(sleepInterval,updateHandler,id,updateLimit){
var me=this;
this.id=(exists(id)?id:null);
this.sleepInterval=sleepInterval;
this.idleInterval=5000;
this.updateHandler=updateHandler;
this.highlightElements=new Array();
this.idleTimerId=0;
this.sleepTimerId=0;
this.highlightTimerId=0;
this.sleeping=false;
this.updateLimit=(exists(updateLimit)?Nz(updateLimit):1);
this.updateRequests=0;
this.updates=0;
this.payload=null;
function echo(msg,level,severity,extraData){
var entry="Redraw Object ("+me.id+"): "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
this.updateHighlights=function(){
for(var index in this.highlightElements){
this.highlightElements[index].highlight();
}
if(this.highlightTimerId!=0){
window.clearTimeout(this.highlightTimerId);
}
this.highlightTimerId=window.setTimeout(function(){me.restoreHighlights();},1000);
}
this.restoreHighlights=function(){
this.highlightTimerId=0;
for(var index in this.highlightElements){
this.highlightElements[index].restore();
}
}
this.addRequest=function(payload){
this.updateRequests++;
this.payload=(exists(payload)?payload:null);
}
this.sleep=function(){
this.updates++;
if(this.idleTimerId!=0){
window.clearTimeout(this.idleTimerId);
}
if(this.updates<this.updateLimit){
echo("sleep requested; updates: "+this.updates+" needed: "+this.updateLimit,8,1);
this.idleTimerId=window.setTimeout(function(){me.updates=0;echo("resetting due to idle time.",8,3);},this.idleInterval);
}else{
if(this.sleepTimerId!=0){
window.clearTimeout(this.sleepTimerId);
}
this.sleeping=true;
echo("sleeping now with "+this.updates+" update(s) of "+this.updateLimit,8,1);
this.updateHighlights();
this.sleepTimerId=window.setTimeout(function(){me.awaken();},this.sleepInterval);
}
}
this.awaken=function(){
this.sleepTimerId=0;
this.sleeping=false;
this.updates=0;
if(this.updateRequests>0){
echo("awakened with "+this.updateRequests+" request(s); REDRAW.",8,3,this.getObjectInfo());
this.updateRequests=0;
this.updateHandler(this.payload);
}else{
echo("awakened with "+this.updateRequests+" request(s); IDLE.",8,2,this.getObjectInfo());
}
}
this.addHighlightElement=function(elem,highlightStyle,type){
if(elem){
this.highlightElements.push(new HighlightElement(elem,highlightStyle,type));
}
}
this.reset=function(){
this.restoreHighlights();
this.highlightElements=new Array();
if(this.sleepTimerId!=0){
window.clearTimeout(this.sleepTimerId);
this.sleepTimerId=0;
}
this.sleeping=false;
}
this.getObjectInfo=function(){
var list=[
"-----------------",
"Redraw Object 1.0",
"-----------------",
"ID: "+this.id,
"Interval: "+this.sleepInterval,
"Sleeping: "+this.sleeping,
"Update Limit: "+this.updateLimit,
"Update Requests: "+this.updateRequests,
"Method: "+this.updateHandler.toString(),
"Payload: "+(this.payload?(this.payload.xml?this.payload.xml:this.payload.toString()):"Null")
];
return list;
}
};
HighlightElement.Text=1;
HighlightElement.Image=2;
function HighlightElement(elem,highlightStyle,type){
this.element=elem;
this.type=type;
this.highlightStyle=highlightStyle;
this.style=null;
this.init=function(){
switch(this.type){
case HighlightElement.Text:
this.style=this.element.style.color;
break;
case HighlightElement.Image:
this.style=this.element.src;
break;
}
}
this.init();
this.highlight=function(){
switch(this.type){
case HighlightElement.Text:
this.element.style.color=this.highlightStyle;
break;
case HighlightElement.Image:
this.element.src=this.highlightStyle;
break;
}
}
this.restore=function(){
switch(this.type){
case HighlightElement.Text:
this.element.style.color=this.style;
break;
case HighlightElement.Image:
this.element.src=this.style;
break;
}
}
};
