/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function PostBackManager(responseDocument,formElementId,requiredElementId){
this.responseDocument=responseDocument;
this.formElement=document.getElementById(formElementId);
this.requiredElementId=requiredElementId;
function echo(msg,level,severity,extraData){
var entry="Post Back Manager: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
this.getErrorString=function(){
if(this.getSuccess()==true){
return "";
}
if(this.responseDocument){
var errString="";
var doc=this.responseDocument;
if(doc.getElementById('errCode')!=null){
var errorCode=doc.getElementById('errCode').value;
var errorType=doc.getElementById('errType').value;
errString=top.getErrorString(errorCode,errorType);
if(errString==''){
errString=doc.getElementById('errMsg').value;
}
}else{
if(doc.documentElement.tagName=='parsererror'){
errString=doc.documentElement.textContent;
}else if(doc.documentElement.innerText){
errString=doc.documentElement.innerText;
}else{
errString=top.getErrorString('304','FORM_MANAGER');
}
}
return errString;
}else{
return "Response document not found.";
}
};
this.getResponseValue=function(elementId){
if(this.responseDocument){
try{
return(this.responseDocument.getElementById(elementId).value);
}catch(e){
echo("Could not reference a response value for "+elementId,6,5,[e.message]);
}
}
return "";
};
this.getSuccess=function(){
if(this.responseDocument){
return(this.responseDocument.getElementById(this.requiredElementId)!=null);
}
return false;
};
this.getIsPostBack=function(){
if(this.formElement&&this.responseDocument){
try{
return(this.responseDocument.location.href==this.formElement.action);
}catch(e){
echo("Error detecting post back.",6,6,[e.message]);
}
}
return false;
};
};
