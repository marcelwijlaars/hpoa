/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Module("urllib","1.1.2",function(mod){
mod.NoHTTPRequestObject=Class("NoHTTPRequestObject",mod.Exception,function(publ,supr){
publ.init=function(trace){
supr(this).init("Could not create an HTTP request object",trace);
}
})
mod.RequestOpenFailed=Class("RequestOpenFailed",mod.Exception,function(publ,supr){
publ.init=function(trace){
supr(this).init("Opening of HTTP request failed.",trace);
}
})
mod.SendFailed=Class("SendFailed",mod.Exception,function(publ,supr){
publ.init=function(trace){
supr(this).init("Sending of HTTP request failed.",trace);
}
})
var getHTTP=function(){
var obj=null;
var types=["Msxml2.XMLHTTP.6.0","Msxml2.XMLHTTP","microsoft.XMLHTTP"];
if(window.ActiveXObject){
for(var i in types){
try{
obj=new ActiveXObject(types[i]);
break;
}catch(e){}
}
if(obj==null){
top.logEvent("Urllib: could not create ActiveX XHR.",null,1,5);
}
}else if(window.XMLHttpRequest){
try{
obj=new XMLHttpRequest();
}catch(e){
top.logEvent("Urllib: could not create native XHR. "+e.message,null,1,5);
}
}
return obj;
}
mod.sendRequest=function(type,url,usr,pwd,dat,headers,callback){
var user=assertNull(usr);
var pass=assertNull(pwd);
var data=assertNull(dat);
var async=isFunction(callback);
var xmlhttp=getHTTP();
try{
if(user!=null){
xmlhttp.open(type,url,async,user,pass);
}else{
xmlhttp.open(type,url,async);
}
}catch(e){
top.logEvent("Urllib: Could not open XHR. "+e.message,null,1,5);
}
if(headers){
for(var i=0;i<headers.length;i++){
xmlhttp.setRequestHeader(headers[i][0],headers[i][1]);
}
}
if(async){
xmlhttp.onreadystatechange=function(){
if(xmlhttp.readyState==4){
callback(xmlhttp);
xmlhttp=null;
}else if(xmlhttp.readyState==2){
try{
var isNetscape=netscape;
try{
var s=xmlhttp.status;
}catch(e){
callback(xmlhttp);
xmlhttp=null;
}
}catch(e){}
}
}
}
try{
xmlhttp.send(data);
}catch(e){
top.logEvent("Urllib: could not send XHR. "+e.message,null,1,5);
}
return xmlhttp;
}
})
