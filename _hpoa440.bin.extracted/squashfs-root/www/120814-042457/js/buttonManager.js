/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function ButtonManager(){}
ButtonManager.prototype.updateButtonClass=function(obj,newClassName){
if(!obj){return;}
if(obj.className.indexOf("Icon")!=-1){
if(obj.className.indexOf("bEmphasized")!=-1){
obj.className=newClassName+"Icon bEmphasized";
}else{
obj.className=newClassName+"Icon";
}
}else{
if(obj.className.indexOf("bEmphasized")!=-1){
obj.className=newClassName+" bEmphasized";
}else{
obj.className=newClassName;
}
}
}
ButtonManager.prototype.getWrapperReference=function(btnWrapperObj){
var ob=btnWrapperObj;
var className=ob.className;
while(className.indexOf("bWrapper")==-1){
ob=ob.parentNode;
className=ob.className;
}
return ob;
}
ButtonManager.prototype.hpButtonOver=function(btnWrapperObj){
if(!this.getButtonChild(btnWrapperObj).disabled){
var obj=this.getWrapperReference(btnWrapperObj);
this.updateButtonClass(obj,"bWrapperOver");
}
}
ButtonManager.prototype.hpButtonUp=function(btnWrapperObj){
if(!this.getButtonChild(btnWrapperObj).disabled){
var obj=this.getWrapperReference(btnWrapperObj);
this.updateButtonClass(obj,"bWrapperUp");
}
}
ButtonManager.prototype.hpButtonDown=function(btnWrapperObj){
var obj=this.getWrapperReference(btnWrapperObj);
var childButton=this.getButtonChild(btnWrapperObj);
if(!childButton.disabled){
this.updateButtonClass(obj,"bWrapperDown");
try{
childButton.focus();
}catch(err){}
}
}
ButtonManager.prototype.disableButton=function(btnObj){
try{
btnObj.disabled=true;
var wrapper=this.getWrapperReference(btnObj);
this.updateButtonClass(wrapper,"bWrapperDisabled");
if(wrapper.onclick){
wrapper.clickHandler=wrapper.onclick;
wrapper.onclick=null;
}
wrapper.onmousedown=null;
wrapper.onmouseup=null;
wrapper.onmouseover=null;
wrapper.onmouseout=null;
}catch(e){}
}
ButtonManager.prototype.enableButton=function(btnObj){
try{
btnObj.disabled=false;
var wrapper=this.getWrapperReference(btnObj);
this.updateButtonClass(wrapper,"bWrapperUp");
if(wrapper.clickHandler){
wrapper.onclick=wrapper.clickHandler;
wrapper.clickHandler=null;
}
wrapper.onmousedown=function(){try{ourButtonManager.hpButtonDown(this);}catch(e){}}
wrapper.onmouseup=function(){try{ourButtonManager.hpButtonOver(this);}catch(e){}}
wrapper.onmouseover=function(){try{ourButtonManager.hpButtonOver(this);}catch(e){}}
wrapper.onmouseout=function(){try{ourButtonManager.hpButtonUp(this);}catch(e){}}
}catch(e){}
}
ButtonManager.prototype.disableButtonById=function(btnId){
var btnObj=document.getElementById(btnId)
if(btnObj){
this.disableButton(btnObj);
}
}
ButtonManager.prototype.enableButtonById=function(btnId){
var btnObj=document.getElementById(btnId)
this.enableButton(btnObj);
}
ButtonManager.prototype.getButtonChild=function(divObj){
var obj=divObj
while((obj.childNodes[0]!=null)&&(!(obj.tagName=="BUTTON"||obj.tagName=="INPUT"||obj.tagName=="A"||obj.tagName=="SUBMIT"))){
obj=obj.childNodes[0];
if(obj.nodeType!=1){
if(obj.nextSibling){
obj=obj.nextSibling;
}
}
}
return obj;
}
ButtonManager.prototype.getImageChild=function(divObj){
var obj=divObj
while((obj.childNodes[0]!=null)&&(!(obj.tagName=="IMG"))){
obj=obj.childNodes[0];
if(obj.nodeType!=1){
if(obj.nextSibling){
obj=obj.nextSibling;
}
}
}
if(obj.tagName!="IMG")return null;
return obj;
}
ButtonManager.prototype.init=function(){
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
if(divs[i].className.indexOf("bWrapper")!=-1){
var button=this.getButtonChild(divs[i]);
var image=this.getImageChild(divs[i]);
var lookingForVerticalButtonSet=divs[i];
while((lookingForVerticalButtonSet)&&(lookingForVerticalButtonSet.className!="verticalButtonSet")){
lookingForVerticalButtonSet=lookingForVerticalButtonSet.parentNode;
}
if(lookingForVerticalButtonSet){
button.style.width="100%";
}else if((!button.getAttribute("disableminimumwidth"))&&(button.className.indexOf("shrinkWrapButton")==-1)){
if(button.className.indexOf("hpButtonSmall")!=-1){
if(button.offsetWidth<47){
button.style.width="47px";
}
}else if(button.className.indexOf("hpButtonVerySmall")!=-1){
}else if(button.offsetWidth>0&&button.offsetWidth<83){
button.style.width="83px";
}
}
if(image!=null){
if(button.className.indexOf("hpButtonIcon")>-1){
button.style.padding="0px";
image.style.margin="0px";
image.style.marginBottom="5px";
if(!button.style.width){
button.style.width=(button.offsetWidth+(document.all?-12:12))+"px";
}
if(!button.style.height){
button.style.height=(button.offsetHeight+18)+"px";
}
}else{
button.style.width=(image.offsetWidth+10)+"px";
}
}
if(button.className&&button.className.indexOf("helpButton")!=-1){
if(!document.all){
if(button.hasChildNodes()){
var obj=button.firstChild;
if(obj.src!=undefined){
obj.style.marginBottom="1px";
}
}
}
}
if(button.offsetWidth>0){
button.style.width=button.offsetWidth+"px";
}
if(!button.disabled){
try{
divs[i].onmousedown=function(){try{ourButtonManager.hpButtonDown(this);}catch(e){}}
divs[i].onmouseup=function(){try{ourButtonManager.hpButtonOver(this);}catch(e){}}
divs[i].onmouseover=function(){try{ourButtonManager.hpButtonOver(this);}catch(e){}}
divs[i].onmouseout=function(){try{ourButtonManager.hpButtonUp(this);}catch(e){}}
if(button.onclick&&(divs[i].onclick?divs[i].onclick.toString().indexOf('hardCodedFunction')==-1:true)){
eval("divs[i].onclick = function() {var hardCodedFunction = "+button.onclick+" ;return hardCodedFunction();};");
button.onclick=function(event){};
}
var buttonChildren=divs[i].getElementsByTagName("BUTTON");
var inputChildren=divs[i].getElementsByTagName("INPUT");
for(var j=0;j<buttonChildren.length;j++){
buttonChildren[j].onfocus=function(){try{ourButtonManager.hpButtonDown(this);}catch(e){}}
buttonChildren[j].onblur=function(){try{ourButtonManager.hpButtonUp(this);}catch(e){}}
}
for(var j=0;j<inputChildren.length;j++){
inputChildren[j].onfocus=function(){try{ourButtonManager.hpButtonDown(this);}catch(e){}}
inputChildren[j].onblur=function(){try{ourButtonManager.hpButtonUp(this);}catch(e){}}
}
}
catch(e){}
}else{
this.updateButtonClass(divs[i],"bWrapperDisabled");
}
}
}
}
