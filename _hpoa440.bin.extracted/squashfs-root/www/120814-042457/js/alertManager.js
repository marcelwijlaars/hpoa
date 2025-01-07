/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function AlertManager(sourceFile){
var winNum=1;
var WIN_HEIGHT=140;
var STD_MSG_HEIGHT=62;
var MAX_MSG_HEIGHT=200;
var MOZ_WIDTH=325;
var IE_WIDTH=325;
var windowArguments='width='+MOZ_WIDTH+',location=no,status=no,address=yes,modal=yes';
var windowUrl=(sourceFile?sourceFile:'/120814-042457/html/alertManager.html');
var windowName='AlertManager';
var message='';
var messageType=0;
var timeout=0;
function echo(msg,level,severity,extraData){
var entry="Alert Manager: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function getMessageHeight(){
var msgHeight=STD_MSG_HEIGHT;
try{
var sizer=top.MX_HIDDEN.document.getElementById("sizerDiv");
if(sizer!=null){
sizer.innerHTML=message;
if(sizer.offsetHeight>STD_MSG_HEIGHT){
msgHeight=(sizer.offsetHeight>MAX_MSG_HEIGHT?MAX_MSG_HEIGHT:sizer.offsetHeight);
}
sizer.innerHTML='';
}
}catch(e){
echo(e.message,1,5);
}
return msgHeight;
};
function assertSourceAvailable(url){
var commSuccess=false;
var msg="";
if(top.getTopology().getProxyLocal().getIsConnected()==true){
try{
var testDoc=top.getUrlLib().sendRequest("GET",url);
commSuccess=(testDoc.status==200);
}catch(e){
commSuccess=false;
}
msg+="source file"+(commSuccess?" ":" not ")+"available.";
}else{
msg+="the primary enclosure is not connected.";
}
echo(msg,2,(commSuccess?2:5));
return commSuccess;
};
function openAlertWin(){
var win=null;
var alertWin=null;
var coords=null;
var alertWinUrl=windowUrl+'?msg='+escape(message);
var msgHeight=getMessageHeight();
alertWinUrl+='&msgType='+messageType+"&msgHeight="+msgHeight;
if(timeout>0){
alertWinUrl+="&timeout="+timeout;
}
var isConnected=assertSourceAvailable(alertWinUrl);
var winHeight=WIN_HEIGHT+(msgHeight-STD_MSG_HEIGHT);
try{
if(typeof(window.showModelessDialog)!='undefined'){
coords=getCenteredOffset(IE_WIDTH,winHeight);
var features='center:yes;status:no;help:no;';
var argsArray=[message,messageType,msgHeight,timeout,"Attention",window];
features+='dialogHeight: '+(winHeight+30)+'px;';
features+='dialogWidth: '+IE_WIDTH+'px;';
if(isConnected==true){
win=window.showModelessDialog(alertWinUrl,argsArray,features);
}else{
win=window.showModelessDialog('_blank',argsArray,features);
try{
win.document.open();
win.document.write("<title>Attention</title>");
win.document.write("<div style='padding:5px;font-family:arial;font-size:11px;padding:5px;'>"+message+"</div><br /><br />");
win.document.write("<center><button style='width:83px;' onclick='self.close()'>OK</button></center>");
win.document.close();
}catch(ie){
echo(ie.message,1,5);
try{win.close();}catch(ie2){}
defaultAlert(fixupMessage(false));
}
}
}else{
coords=getCenteredOffset(MOZ_WIDTH,winHeight);
var dynamicArguments="top="+coords.y+",left="+coords.x+",height="+winHeight+",";
if(isConnected==true){
alertWin=window.open(alertWinUrl,windowName+(winNum++),dynamicArguments+windowArguments);
}else{
alertWin=window.open('',windowName+(winNum++),dynamicArguments+windowArguments);
try{
alertWin.document.open();
alertWin.document.write("<div style='font-family:arial;font-size:11px;padding:5px;'>"+message+"</div><br /><br />");
alertWin.document.write("<center><button style='width:83px;' onclick='self.close()'>OK</button></center>");
alertWin.document.close();
}catch(moz){
echo(moz.message,1,5);
try{alertWin.close();}catch(moz2){}
defaultAlert(fixupMessage(false));
}
}
if(alertWin){
alertWin.focus();
alertWin.defaultStatus='';
}else{
echo("unable to open alert window.",4,5,[alertWinUrl]);
}
}
}catch(e){
echo("unknown error opening alert window.",4,5,[alertWinUrl]);
}
};
function getCenteredOffset(w,h){
var coords=new Object();
coords.x=50;
coords.y=50;
w=parseInt(w);
h=parseInt(h);
if(!isNaN(w)){
if(screen.availWidth){
coords.x=((screen.availWidth-w)/2);
}
}
if(!isNaN(h)){
if(screen.availHeight){
coords.y=((screen.availHeight-h)/2);
}
}
return coords;
};
function isValidMessageType(type){
var isValid=false;
for(var msgType in AlertMsgTypes){
if(type==AlertMsgTypes[msgType]){
isValid=true;
break;
}
}
return isValid;
};
function fixupMessage(useHtml){
if(useHtml){
message=message.replace(/\n/g,'<br>');
}else{
message=message.replace(/<br>/g,'\n');
}
return message;
};
this.alert=function(msg,type,seconds){
timeout=0;
if(typeof(type)=='undefined'){
var type=AlertMsgTypes.Default;
}
if(typeof(seconds)!='undefined'&&!isNaN(parseInt(seconds))){
timeout=seconds*1000;
}
message=msg;
messageType=(isValidMessageType(type))?type:AlertMsgTypes.Default;
if(messageType==AlertMsgTypes.Default){
defaultAlert(msg);
}else{
fixupMessage(true);
try{
openAlertWin();
}catch(e){
echo("Could not open window.",1,5,[e]);
defaultAlert(msg);
}
}
};
}
