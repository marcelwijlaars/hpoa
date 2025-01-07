/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Module("maxconnections","1.2.0",function(mod){
var maxConnections=MAX_CONNECTIONS();
var prefType=null;
var persistentConPerServer;
var persistentConPerProxy;
var maxConPerServer;
var mzMaxCon;
var WshShell;
mod.test=function(){
alert("in maxconnections.test!");
}
mod.getMaxConnectionValue=function(){
var errorMessage="";
try{
if(typeof netscape!='undefined'&&typeof netscape.security!='undefined'){
try{
netscape.security.PrivilegeManager.enablePrivilege("UniversalPreferencesRead");
persistentConPerServer=navigator.preference("network.http.max-persistent-connections-per-server");
persistentConPerProxy=navigator.preference("network.http.max-persistent-connections-per-proxy");
maxConPerServer=navigator.preference("network.http.max-connections-per-server");
mzMaxCon=navigator.preference("network.http.max-connections");
var min=Math.min(persistentConPerServer,persistentConPerProxy,maxConPerServer,mzMaxCon);
if(min>MAX_CONNECTIONS())maxConnections=min;
}catch(e){
alert("To enable codebase principals, add this line to the prefs.js file \n"+
"in the Mozilla user profile directory:\n"+
'user_pref("signed.applets.codebase_principal_support", true);');
errorMessage="mozilla: "+e.message;
}finally{
prefType="navigator.preference";
}
}
}catch(e){errorMessage="mozilla: "+e.message;}
if(prefType==null||prefType=="registry"){
try{
if(WshShell==null){
WshShell=new ActiveXObject("WScript.Shell");
}
var str;
try{
str=WshShell.RegRead("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\MaxConnectionsPerServer");
}catch(e1){
try{
if((e1.number&0xFFFF)==2){
str=WshShell.RegRead("HKEY_USERS\\.DEFAULT\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\MaxConnectionsPerServer");
}
}catch(e2){
if((e2.number&0xFFFF)==2){
str=2;
}
}
}
if(str!=null&&str>=MAX_CONNECTIONS())maxConnections=str;
prefType="registry";
}catch(e){errorMessage+="\n\nie: "+e.message;
}
}
if(prefType==null){
alert("unable to fetch maximum connection settings:\n\n"+errorMessage);
return null;
}else{
return maxConnections;
}
}
mod.setMaxConnectionValue=function(value){
var errorMessage="";
value=parseInt(value);
if(value==maxConnections){
alert("this value is the same as the previouslly fetched value, please enter a unique value");
return false;
}
if(value<2){
alert("this value is lower than 2, please enter a unique value greater than 1, 8 is recommended");
return false;
}
else if(value>10){
alert("Warning, this value of "+value+" is high, 8 is recommended");
if(value>255){
alert("Error, this value of "+value+" is too high, 8 is recommended");
return false;
}
}else if(value!=2){
}else{
}
if(prefType=="navigator.preference"){
try{
netscape.security.PrivilegeManager.enablePrivilege("UniversalPreferencesWrite");
navigator.preference("network.http.max-persistent-connections-per-server",value);
if(value>persistentConPerProxy){navigator.preference("network.http.max-persistent-connections-per-proxy",value);}
if(value>maxConPerServer){navigator.preference("network.http.max-connections-per-server",value);}
if(value>mzMaxCon){navigator.preference("network.http.max-connections",value);}
}catch(e){errorMessage="mozilla: "+e.message;
alert("unable to set maximum connection settings:\n\n"+errorMessage);
return false;
}
}
else if(prefType=="registry"){
try{
if(WshShell==null){
WshShell=new ActiveXObject("WScript.Shell");
}
try{
WshShell.RegWrite("HKEY_USERS\\.DEFAULT\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\MaxConnectionsPerServer",value,"REG_DWORD");
WshShell.RegWrite("HKEY_USERS\\.DEFAULT\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\MaxConnectionsPer1_0Server",value,"REG_DWORD");
}catch(e){
errorMessage="ie: "+e.message;
alert("unable to set maximum connection settings in .DEFAULT registry:\n\n"+errorMessage);
}
try{
WshShell.RegWrite("HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\MaxConnectionsPerServer",value,"REG_DWORD");
WshShell.RegWrite("HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\MaxConnectionsPer1_0Server",value,"REG_DWORD");
}catch(e){
errorMessage="ie: "+e.message;
alert("unable to set maximum connection settings in registry:\n\n"+errorMessage);
}
}catch(e){
errorMessage="ie: "+e.message;
alert("unable to open shell :\n\n"+errorMessage);
return false;
}
}
else{
return false;
}
return true;
}
});
