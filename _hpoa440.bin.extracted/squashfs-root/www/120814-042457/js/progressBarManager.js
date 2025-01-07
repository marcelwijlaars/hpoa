/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function ProgressBarManager(){
this.progressBars=null;
};
function _getProgressBar(indexOrId){
var index=this.getIndexFromArg(indexOrId);
if(this.isValidIndex(index)){
return this.progressBars[index];
}
};
function _getProgressBars(){
return this.progressBars;
};
function _getCurrentValueByIndex(indexOrId){
var index=this.getIndexFromArg(indexOrId);
if(this.isValidIndex(index)){
return this.progressBars[index].getCurrentValue();
}
};
function _init(){
this.progressBars=new Array();
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
if(divs[i].className.indexOf("progressWrapper")>-1){
var newBar=new ProgressBar(divs[i]);
this.progressBars.push(newBar);
}
}
};
function _resetProgressBar(indexOrId){
this.updateProgressBar(indexOrId,0);
};
function _resetAllProgressBars(){
this.updateAllProgressBars(0);
};
function _updateAllProgressBars(percent){
for(var i=0;i<this.progressBars.length;i++){
this.updateProgressBar(i,percent);
}
};
function _updateProgressBar(indexOrId,percent){
var index=this.getIndexFromArg(indexOrId);
if(this.isValidIndex(index)){
return(this.progressBars[index].update(percent));
}else{
return false;
}
};
function _hideAllProgressBars(){
for(var i=0;i<this.progressBars.length;i++){
this.progressBars[i].display(false);
}
};
function _killAllProgressBars(){
for(var i=0;i<this.progressBars.length;i++){
this.progressBars[i].destroyBar();
this.progressBars[i]=null;
}
this.progressBars=null;
};
function _showAllProgressBars(){
for(var i=0;i<this.progressBars.length;i++){
this.progressBars[i].display(true);
}
};
function _hideProgressBar(indexOrId){
var index=this.getIndexFromArg(indexOrId);
if(this.isValidIndex(index)){
this.progressBars[index].display(false);
}
};
function _showProgressBar(indexOrId){
var index=this.getIndexFromArg(indexOrId);
if(this.isValidIndex(index)){
this.progressBars[index].display(true);
}
};
function _getIndexFromArg(indexOrId){
var temp=parseInt(indexOrId);
if(!isNaN(temp)){
return(this.isValidIndex(temp)?temp:-1);
}else{
for(var i=0;i<this.progressBars.length;i++){
if(this.progressBars[i].element.id==indexOrId){
return i;
}
}
}
return-1;
};
function _isValidIndex(index){
if(isNaN(index)){
return false;
}
var size=this.progressBars.length;
return(size>0?(index>=0&&index<size):false);
};
ProgressBarManager.prototype.init=_init;
ProgressBarManager.prototype.getProgressBar=_getProgressBar;
ProgressBarManager.prototype.getProgressBars=_getProgressBars;
ProgressBarManager.prototype.getCurrentValue=_getCurrentValueByIndex;
ProgressBarManager.prototype.resetProgressBar=_resetProgressBar;
ProgressBarManager.prototype.resetAllProgressBars=_resetAllProgressBars;
ProgressBarManager.prototype.updateAllProgressBars=_updateAllProgressBars;
ProgressBarManager.prototype.updateProgressBar=_updateProgressBar;
ProgressBarManager.prototype.hideAllProgressBars=_hideAllProgressBars;
ProgressBarManager.prototype.killAllProgressBars=_killAllProgressBars;
ProgressBarManager.prototype.hideProgressBar=_hideProgressBar;
ProgressBarManager.prototype.showAllProgressBars=_showAllProgressBars;
ProgressBarManager.prototype.showProgressBar=_showProgressBar;
ProgressBarManager.prototype.getIndexFromArg=_getIndexFromArg;
ProgressBarManager.prototype.isValidIndex=_isValidIndex;
function ProgressBar(elem){
this.element=elem;
this.currentValue=null;
};
function _getId(){
return this.element.id;
};
function _getCurrentValue(){
if(this.currentValue){
return this.currentValue;
}else{
var current=0;
var divs=this.element.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
if(divs[i].className=="progressMade"){
current=parseInt(divs[i].style.width);
break;
}
}
return(isNaN(current)?0:this.currentValue=current);
}
};
function _update(percent){
var progress=parseInt(percent);
var applied=0;
if(progress>=0&&progress<=100){
var divs=this.element.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
switch(divs[i].className){
case "progressMade":
divs[i].style.width=progress+"%";
applied++;
break;
case "progressLeft":
divs[i].style.width=(100-progress)+"%";
applied++;
break;
case "progressPercentage":
divs[i].getElementsByTagName("span")[0].innerHTML=progress+"%";
applied++;
break;
}
}
}
if(applied==3){
this.currentValue=progress;
return true;
}else{
return false;
}
};
function _display(visible){
this.element.className="progressWrapper"+(visible?"On":"Off");
};
function _destroyBar(){
this.element=null;
this.currentValue=null;
};
ProgressBar.prototype.getCurrentValue=_getCurrentValue;
ProgressBar.prototype.update=_update;
ProgressBar.prototype.destroyBar=_destroyBar;
ProgressBar.prototype.display=_display;
ProgressBar.prototype.getId=_getId;
