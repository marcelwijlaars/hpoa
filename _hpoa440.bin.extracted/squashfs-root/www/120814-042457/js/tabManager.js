/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function TabManager(){
this.tabs=[];
}
TabManager.prototype.init=function(){
this.tabs=[];
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
if((divs[i].className=="tabOn")||(divs[i].className=="tabOff")){
this.tabs.push(divs[i]);
if(divs[i].className=="tabOff"){
var tabId=divs[i].getAttribute('tabid');
if(tabId){
eval("divs[i].onclick = function() {if (this.style.cursor == 'wait'){return;} ourTabManager.toggleTabs('"+tabId+"'); setTabContent('"+tabId+"');}");
}
}
if(document.all){
if(divs[i].parentNode.className=="secondaryTabSet"){
if(divs[i].className=="tabOn"){
if(divs[i].offsetWidth<83)divs[i].style.width="60px";
}
else if(divs[i].className=="tabOff"){
if(divs[i].offsetWidth<85)divs[i].style.width="62px";
}
}
else{
if(divs[i].className=="tabOn"){
if(divs[i].offsetWidth<111)divs[i].style.width="88px";
}
else if(divs[i].className=="tabOff"){
if(divs[i].offsetWidth<113)divs[i].style.width="90px";
}
}
}
}
}
}
TabManager.prototype.toggleTabs=function(tabRef){
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
var tabId=divs[i].getAttribute('tabid');
if(tabId==tabRef){
if(divs[i].className=="tabOff"){
divs[i].className="tabOn";
}
}
else if(divs[i].className=="tabOn"){
divs[i].className="tabOff";
}
}
}
TabManager.prototype.notifyBusy=function(){
for(var i=0;i<this.tabs.length;i++){
this.tabs[i].style.cursor='wait';
}
}
TabManager.prototype.notifyReady=function(){
for(var i=0;i<this.tabs.length;i++){
this.tabs[i].style.cursor='';
}
}
TabManager.prototype.getCurrentTab=function(){
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
var tabId=divs[i].getAttribute('tabid');
if(divs[i].className=="tabOn"){
return tabId;
}
}
return null;
}
