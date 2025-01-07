/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function NavigationControlManager(){
}
NavigationControlManager.prototype.init=function(){
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
if(divs[i].className=="navigationControlSet"){
var navigationControls=divs[i].getElementsByTagName("DIV")
for(var j=0;j<navigationControls.length;j++){
var elem=navigationControls[j].childNodes[0];
if(elem.onclick){
eval("elem.onclick = function(mozEvent) {var hardCodedFunction = "+elem.onclick+";ourNavigationControlManager.highlightItem(this);hardCodedFunction();};");
}else{
eval("elem.onclick = function(mozEvent) {ourNavigationControlManager.highlightItem(this);};");
}
}
}
}
}
NavigationControlManager.prototype.highlightItem=function(obj){
var lookingForWrapper=obj
while((lookingForWrapper)&&(lookingForWrapper.className!="navigationControlSet")){
lookingForWrapper=lookingForWrapper.parentNode;
}
if(lookingForWrapper){
var navigationControls=lookingForWrapper.getElementsByTagName("DIV");
for(var i=0;i<navigationControls.length;i++){
if(navigationControls[i]==obj.parentNode){
navigationControls[i].className="navigationControlOn";
}
else{
navigationControls[i].className="navigationControlOff";
}
}
}
}
