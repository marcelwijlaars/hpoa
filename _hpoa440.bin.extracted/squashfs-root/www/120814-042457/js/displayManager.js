/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
DisplayManager.BodyContainer='bodyContent';
DisplayManager.WaitContainer='waitContainer';
DisplayManager.ErrorContainer='errorDisplay';
function DisplayManager(bodyContainerId,waitContainerId,errorContainerId){
this.errorBox=null;
this.bodyBox=null;
this.waitBox=null;
var bodyId=(parseArg(bodyContainerId)==null?DisplayManager.BodyContainer:bodyContainerId);
var waitId=(parseArg(waitContainerId)==null?DisplayManager.WaitContainer:waitContainerId);
var errorId=(parseArg(errorContainerId)==null?DisplayManager.ErrorContainer:errorContainerId);
this.createWaitContainer=function(waitText,waitDescription){
try{
this.waitBox=document.getElementById(waitId);
if(typeof(this.waitBox)!='undefined'){
var processor=new XsltProcessor('../Templates/waitContainer.xsl');
processor.addParameter('waitText',waitText);
if(waitDescription&&waitDescription!=''){
processor.addParameter('waitDescription',waitDescription);
}
this.waitBox.innerHTML=processor.getOutput();
}
}catch(err){}
}
this.createLoadContainer=function(waitText,waitDescription){
try{
this.bodyBox=document.getElementById(bodyId);
if(typeof(this.bodyBox)!='undefined'){
var processor=new XsltProcessor('../Templates/waitContainer.xsl');
processor.addParameter('waitText',(waitText?waitText:top.getString('loading...')));
if(waitDescription&&waitDescription!=''){
processor.addParameter('waitDescription',waitDescription);
}
this.bodyBox.innerHTML=processor.getOutput();
this.showMainScreen();
}
}catch(err){}
}
this.setErrorContainer=function(errorContainerId){
errorId=(parseArg(errorContainerId)==null?DisplayManager.ErrorContainer:errorContainerId);
}
this.setWaitContainer=function(waitContainerId){
waitId=(parseArg(waitContainerId)==null?DisplayManager.WaitContainer:waitContainerId);
}
this.setBodyContainer=function(bodyContainerId){
bodyId=(parseArg(bodyContainerId)==null?DisplayManager.BodyContainer:bodyContainerId);
}
this.showMainScreen=function(){
this.bodyBox=document.getElementById(bodyId);
this.waitBox=document.getElementById(waitId);
if(this.bodyBox){this.bodyBox.style.display="block";}
if(this.waitBox){this.waitBox.style.display="none";}
}
this.showWaitScreen=function(){
this.bodyBox=document.getElementById(bodyId);
this.waitBox=document.getElementById(waitId);
if(this.waitBox){this.waitBox.style.display="block";}
if(this.bodyBox){this.bodyBox.style.display="none";}
}
this.clearErrorContainers=function(){
var elems=document.getElementsByTagName("DIV");
for(var i=0;i<elems.length;i++){
try{
if(elems[i].className=='errorDisplay'){
elems[i].innerHTML='';
elems[i].style.display='none';
}
}catch(e){}
}
}
this.hideStatusContainers=function(){
var elems=document.getElementsByTagName("DIV");
for(var i=0;i<elems.length;i++){
try{
if(elems[i].className=='statusDisplay'){
elems[i].style.display='none';
}
}catch(e){}
}
}
this.hideErrors=function(ignoreLabels){
this.errorBox=document.getElementById(errorId);
if(this.errorBox){
this.errorBox.innerHTML="";
this.errorBox.style.display="none";
this.errorBox.className='errorDisplay';
}
if(!(ignoreLabels==true)){
var elems=document.getElementsByTagName("*");
for(var i=0;i<elems.length;i++){
try{
if(elems[i].className=='invalidFormLabel'){
elems[i].className='validFormLabel';
}
}catch(e){}
}
}
}
this.showErrors=function(errorList){
this.errorBox=document.getElementById(errorId);
if(this.errorBox){
this.errorBox.innerHTML=errorList;
this.errorBox.style.display="block";
}
}
this.openLogWindow=function(content,title,isHtml,showToolbar){
var logWin=null;
var winName='LogWin';
var optionsList="top=0,left=0,width=740,height=550,status=no,resizable=yes,scrollbars=yes"+(showToolbar==true?",menubar=yes":"");
var txtStyle="\"font-family:monospace;font-size:11px;width:100%;height:490px;padding:2px;\"";
var pathFix=(window.location.protocol.indexOf("http")>-1?"":"..");
var logDataItem={
"titleText":title,
"txtStyle":txtStyle,
"isHtml":isHtml,
"content":content
}
var logIndex=top.addLogDataItem(logDataItem);
try{
logWin=window.open(pathFix+"/120814-042457/html/log.html?log-index="+logIndex,winName,optionsList);
}catch(err){
if(logWin){
try{logWin.close();}catch(e){}
}
alert('Unable to open popup windows. Please check browser settings.');
}
}
};
function _dialogCallback(win){
if(win){
try{
var doc=win.document;
var body=doc.getElementById('bodyContent');
if(win.titleText){
doc.getElementById('mastheadTitle').innerHTML=win.titleText;
}
if(!(win.isHtml)){
body.innerHTML=("<textarea id='txtLog' rows='32' class='stdInputDisabled'"+
" style="+win.txtStyle+" readonly=\"readonly\" /><br />");
doc.getElementById('txtLog').value=win.content;
}else{
body.innerHTML=win.content;
}
win.myOnResize();
win.focus();
}catch(e){
if(doc){
doc.write(win.content.replace(/\r\n/g,"<br />").replace(/\n/g,"<br />"));
}
}
}
};
function parseArg(argument){
return(typeof(argument)=='undefined'?null:argument);
};
