/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function ListenerCollection(){
this.masterListeners=null;
this.listeners=null;
this.debugging=top.debugIsActive();
};
function _addListenerToCollection(listener,eventTypes,isMaster){
if(this.listeners==null){
this.listeners=new Object();
}
if(this.masterListeners==null&&isMaster==true){
this.masterListeners=new Object();
}
var collection=(isMaster==true?this.masterListeners:this.listeners);
if(this.debugging==true){
top.logEvent(["Listener Collection: Adding "+(isMaster==true?"master":"normal")+" listener.","Master: "+assertFalse(isMaster)].concat(eventTypes),null,8,1);
}
if(isFunction(listener)){
collection[listener.toString()]=new Object();
collection[listener.toString()].callback=listener;
collection[listener.toString()].eventTypes=(eventTypes?eventTypes:new Array());
return true;
}
return false;
};
function _removeListenerFromCollection(listener){
if(this.getListener(listener,this.masterListeners)!=false){
if(this.debugging==true){
top.logEvent(["Listener Collection: Removing master listener.",listener.toString()],null,8,1);
}
delete this.masterListeners[listener.toString()];
return true;
}
if(this.getListener(listener,this.listeners)!=false){
if(this.debugging==true){
top.logEvent(["Listener Collection: Removing normal listener.",listener.toString()],null,8,1);
}
delete this.listeners[listener.toString()];
return true;
}
return false;
};
function _resetListenerCollection(){
for(var index in this.listeners){
delete this.listeners[index];
}
for(var index in this.masterListeners){
delete this.masterListeners[index];
}
this.listeners=null;
this.masterListeners=null;
};
function _getListenerObject(listener,collection){
if(collection!=null){
if(typeof(collection[listener.toString()])!='undefined'){
return collection[listener.toString()];
}
}
return false;
};
function _callListeners(eventType,eventValue,optionalValue){
this._callListenersInCollection(this.masterListeners,eventType,eventValue,optionalValue);
this._callListenersInCollection(this.listeners,eventType,eventValue,optionalValue);
};
function _callListenersInCollection(collection,eventType,eventValue,optionalValue){
for(var index in collection){
try{
var listenerObj=collection[index];
if(listenerObj.eventTypes!=null&&listenerObj.eventTypes.length>0){
for(var i=0;i<listenerObj.eventTypes.length;i++){
if(listenerObj.eventTypes[i]==eventType){
listenerObj.callback(eventValue,optionalValue);
break;
}
}
}else{
listenerObj.callback(eventValue,optionalValue);
}
}catch(err){
continue;
}
}
};
function _containsEvent(collection,eventType){
for(var index in collection){
try{
var listenerObj=collection[index];
if(listenerObj.eventTypes!=null&&listenerObj.eventTypes.length>0){
for(var i=0;i<listenerObj.eventTypes.length;i++){
if(listenerObj.eventTypes[i]==eventType){
return true;
}
}
}
}catch(err){
continue;
}
}
return false;
};
function _eventTypeExists(eventType){
return(this.containsEvent(this.masterListeners,eventType)||
this.containsEvent(this.listeners,eventType));
};
function _getTotalListeners(){
var total=0;
for(var l in this.listeners){
total++;
}
for(var m in this.masterListeners){
total++;
}
return total;
};
function _getListenerInfo(){
var output=new Array();
for(var l in this.listeners){
output.push("Normal: "+this.listeners[l].callback.toString());
}
for(var m in this.masterListeners){
output.push("Master: "+this.masterListeners[m].callback.toString());
}
return output;
};
ListenerCollection.prototype.callListeners=_callListeners;
ListenerCollection.prototype.containsEvent=_containsEvent;
ListenerCollection.prototype.reset=_resetListenerCollection;
ListenerCollection.prototype.getListener=_getListenerObject;
ListenerCollection.prototype.getListenerInfo=_getListenerInfo;
ListenerCollection.prototype.eventTypeExists=_eventTypeExists;
ListenerCollection.prototype.getTotalListeners=_getTotalListeners;
ListenerCollection.prototype.addListener=_addListenerToCollection;
ListenerCollection.prototype.removeListener=_removeListenerFromCollection;
ListenerCollection.prototype._callListenersInCollection=_callListenersInCollection;
