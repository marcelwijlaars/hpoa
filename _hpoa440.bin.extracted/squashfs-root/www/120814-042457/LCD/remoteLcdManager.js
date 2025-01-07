/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var _batchesInProgress=0;
function getBatchCount(){
return _batchesInProgress;
}
function addBatchInProgress(){
_batchesInProgress++;
if(_batchesInProgress==1&&typeof(TabManager)!="undefined"&&ourTabManager!=null){
ourTabManager.notifyBusy();
}
}
function removeBatchInProgress(){
if(_batchesInProgress>0){
_batchesInProgress--;
}
if(_batchesInProgress==0&&typeof(TabManager)!="undefined"&&ourTabManager!=null){
ourTabManager.notifyReady();
}
}
LcdDataManager.ScreenInfo=OA_NAMESPACE()+':lcdScreenInfo';
LcdDataManager.PinInfo=OA_NAMESPACE()+':lcdPinInfo';
LcdDataManager.UserNoteInfo=OA_NAMESPACE()+':lcdUserNoteInfo';
LcdDataManager.ChatInfo=OA_NAMESPACE()+':lcdChatInfo';
LcdDataManager.ScreenUrl='/cgi-bin/getLCDImage';
var RemoteLcdEvents=[
"EVENT_LCD_SCREEN_REFRESH",
"EVENT_LCD_STATUS",
"EVENT_LCD_INFO",
"EVENT_LCD_BUTTON",
"EVENT_LCD_BUTTONS_LOCKED"];
var RemoteLcdPinEvents=[
"EVENT_LCDPIN"];
var RemoteLcdUserNoteEvents=[
"EVENT_LCD_USER_NOTES_CHANGED",
"EVENT_LCD_USER_NOTES_IMAGE_CHANGED"];
var RemoteLcdChatEvents=[
"EVENT_LCD_SCREEN_CHAT_REQUESTED",
"EVENT_LCD_SCREEN_CHAT_ANSWERED",
"EVENT_LCD_SCREEN_CHAT_WITHDRAWN"];
var ScreenColors=
[[['Red'],['#FF0000']],
[['Amber'],['#FF8C00']],
[['Black'],['#333333']],
[['Blue'],['#0000FF']]];
function RemoteLcdManager(onboardAdmin,bayNumber,loadedHandler){
var me=this;
this.oa=onboardAdmin;
this.oaBayNumber=bayNumber;
this.sessionKey='';
this.oaUrl='';
this.lcdStatus=null;
this.lcdInfo=null;
this.screenImage=null;
this.textNode=null;
this.buttonsLocked=false;
this.hibernating=false;
this.timerId=0;
this.screenRequests=0;
this.screenRefreshLimit=600;
this.notifyLoadedResponse=function(errors){
var success=(errors.length==0);
if(!success){
me.callManager.formatErrorLabels();
}
if(typeof(me.loadedHandler)=='function'){
try{
me.loadedHandler(success);
}catch(e){}
}else if(!success){
alert(me.callManager.getErrorList(false));
}
me.callManager.reset();
removeBatchInProgress();
}
this.statusLoadedResponse=function(payload){
if(isSoapError(payload)){
me.logEntry("statusLoadedResponse error: ",6,5,[getSoapError(payload)]);
}else{
me.lcdStatus=payload;
me.hibernating=(getElementValueXpath(payload,"//hpoa:display")=='UID_OFF');
me.buttonsLocked=parseBool(getElementValueXpath(payload,"//hpoa:buttonLock"));
me.getPinSecurity().getPinEnabledResponse(payload);
me.dataManager.updateDomNodeValue(addNS("status"),getElementValueXpath(payload,'//hpoa:status'));
me.dataManager.updateDomNodeValue(addNS("display"),me.hibernating.toString());
me.dataManager.updateDomNodeValue(addNS("buttonLock"),me.buttonsLocked.toString());
me.toggleButtonsLockedDisplay(me.buttonsLocked);
}
}
this.infoLoadedResponse=function(payload){
if(isSoapError(payload)){
me.logEntry("infoLoadedResponse error: ",6,5,[getSoapError(payload)]);
}else{
me.dataManager.updateDomNodeValue(addNS("fwVersion"),getElementValueXpath(payload,'//hpoa:fwVersion'));
me.dataManager.updateDomNodeValue(addNS("partNumber"),getElementValueXpath(payload,'//hpoa:partNumber'));
me.lcdInfo=payload;
}
}
this.eventHandler=function(payload){
var eventType=getElementValueXpath(payload,'//hpoa:event');
switch(eventType){
case RemoteLcdEvents[0]:
me.requestScreenUpdate(false);
break;
case RemoteLcdEvents[1]:
case RemoteLcdEvents[4]:
me.statusLoadedResponse(payload);
break;
case RemoteLcdEvents[2]:
me.infoLoadedResponse(payload);
break;
case RemoteLcdEvents[3]:
break;
default:
me.logEntry("Unsupported event: "+eventType,6,6);
}
}
this.requestScreenUpdate=function(refreshNow){
this.screenRequests++;
if(this.timerId>0){
window.clearTimeout(this.timerId);
}
if(refreshNow){
this.timerResponse();
}else{
this.timerId=window.setTimeout(function(){me.timerResponse();},this.screenRefreshLimit);
}
}
this.timerResponse=function(){
this.timerId=0;
this.screenRequests=0;
if(this.hibernating){
this.reset('Black');
}else{
this.reset(null,true);
}
}
this.imageContainer=null;
this.layers=new Array();
this.loadedHandler=loadedHandler;
this.dataManager=new LcdDataManager(this.oa);
this.dataManager.createDomDocument();
this.callManager=new CallManager(this.notifyLoadedResponse);
this.userNotes=new UserNotes(this.oa,this.callManager,this.dataManager,this);
this.pinSecurity=new PinSecurity(this.oa,this.callManager,this.dataManager,this);
this.chatSession=new ChatSession(this.oa,this.callManager,this.dataManager,this);
};
function _init(){
this.oaUrl=removeTrailingSlash(getServiceUrl(this.oa.getIsLocal()?'':this.oa.getProxyUrl(),true));
this.sessionKey=this.oa.getSessionKey();
this.oa.setLcdEventsEnabled(true);
this.startEvents(this.eventHandler,RemoteLcdEvents);
this.userNotes.init();
this.pinSecurity.init();
this.chatSession.init();
this.startBatch(null);
this.callManager.makeCall(this.oa.getLcdStatus,null,null,null,this.statusLoadedResponse);
this.callManager.makeCall(this.oa.getLcdInfo,null,null,null,this.infoLoadedResponse);
this.endBatch();
};
function _unload(){
this.oa.setLcdEventsEnabled(false);
this.stopEvents(this.eventHandler);
this.userNotes.unload();
this.pinSecurity.unload();
this.chatSession.unload();
};
function _setCallback(newCallback){
this.loadedHandler=newCallback;
};
function _startBatch(newCallback){
if(newCallback!=null){
this.loadedHandler=newCallback;
}
this.callManager.reset();
this.callManager.batchState=BatchState.Queue;
};
function _endBatch(){
addBatchInProgress();
this.callManager.batchState=BatchState.Loading;
this.callManager.loadQueue();
};
function _startEvents(eventHandler,eventList){
try{
this.oa.registerEventHandler(eventHandler,eventList);
}catch(err){
this.logEntry("startEvents(): "+err.message,1,6);
}
};
function _stopEvents(eventHandler){
try{
this.oa.removeRegisteredHandler(eventHandler);
}catch(err){
this.logEntry("stopEvents(): "+err.message,1,6);
}
};
function _usePercentMode(percentCallback){
this.callManager.reportMode=ReportMode.Percent;
this.callManager.percentHandler=percentCallback;
};
function _useNormalMode(){
this.callManager.reportMode=ReportMode.Normal;
this.callManager.percentHandler=null;
};
function _getScreenInfo(){
return this.dataManager.getDomFragment(LcdDataManager.ScreenInfo);
};
function _getPinInfo(){
return this.dataManager.getDomFragment(LcdDataManager.PinInfo);
};
function _getUserNoteInfo(){
return this.dataManager.getDomFragment(LcdDataManager.UserNoteInfo);
};
function _getChatInfo(){
return this.dataManager.getDomFragment(LcdDataManager.ChatInfo);
};
function _getDataManager(){
return this.dataManager;
};
function _getCallManager(){
return this.callManager;
};
function _getUserNotesClass(){
return this.userNotes;
};
function _getPinSecurityClass(){
return this.pinSecurity;
};
function _getChatSessionClass(){
return this.chatSession;
};
function _logLcdEntry(msg,level,severity,extraData){
var entry="Insight Display: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function _pressButton(button,state){
var status=getElementValueXpath(this.lcdStatus,"//hpoa:display");
if(status=="UID_BLINK"||(status=="UID_OFF"&&button=="LCD_USERNOTES")){
this.oa.pressLcdButton('LCD_OK',state,function(){return true;});
}
this.oa.pressLcdButton(button,state,function(){return true;});
};
function _setLcdButtonsLocked(locked){
this.callManager.makeCall(this.oa.setLcdButtonLock,[locked]);
};
function _toggleButtonsLockedDisplay(locked){
this.getPinSecurity().updateHostControl("BUTTON_LOCK_ENABLE",locked);
};
function _setImageContainer(imageContainer){
if(imageContainer){
this.imageContainer=imageContainer;
this.requestScreenUpdate(true);
}
};
function _setScreenImage(image,txtNode){
if(image){
this.screenImage=image;
this.screenImage.onload=screenOnLoad;
this.screenImage.onerror=screenOnError;
this.textNode=txtNode;
}
};
function _getLayers(){
return this.layers;
};
function _getLayer(index){
if(index==null){
index=this.layers.length-1;
}
if(isValidIndex(index,this.layers)){
return this.layers[index];
}
return null;
};
function _addLayer(path,x,y,zOrder){
if(zOrder==null){
zOrder=this.layers.length+1;
}
var img=new ImageLayer(this.imageContainer,path,x,y,zOrder);
this.layers.push(img);
};
function _removeLayer(index){
if(index==null){
index=this.layers.length-1;
}
if(isValidIndex(index,this.layers)){
if(this.layers[index].span.parentNode==this.imageContainer){
this.imageContainer.removeChild(this.layers[index].span);
}
this.layers.splice(index,1);
}
};
function _refreshLayer(index){
if(index==null){
index=this.layers.length-1;
}
if(isValidIndex(index,this.layers)){
this.layers[index].reLoad(this.layers[index].img.src);
}
};
function _reset(newImagePath,useRandomUrl){
if(this.imageContainer!=null&&newImagePath!=null){
for(var j=0;j<ScreenColors.length;j++){
if(newImagePath==(ScreenColors[j][0]+"")){
this.toggleActivateText(true);
this.imageContainer.style.background=ScreenColors[j][1];
break;
}
}
}
if(this.hibernating){
return;
}else{
this.toggleActivateText(false);
}
for(var i=this.layers.length-1;i>=0;i--){
this.removeLayer(i);
}
if(useRandomUrl){
var now=new Date();
var sessionKey="";
var filename="filename="+now.getMilliseconds()+Math.random().toString()+".png";
if(this.oa.getActiveFirmwareVersion()<2.00){
sessionKey="oaSessionKey="+this.sessionKey+"&";
}
newImagePath=this.oaUrl+LcdDataManager.ScreenUrl+"?"+sessionKey+filename;
}
if(newImagePath==null||newImagePath==""){
newImagePath=this.screenImage.src;
}
this.screenImage.src=newImagePath;
};
function parseResult(result,startNodeString,endNodeString){
var start=result.indexOf(startNodeString);
var end=result.indexOf(endNodeString);
if(start>-1&&end>-1){
return(result.substring(start+(startNodeString.length),end));
}
return "";
};
function _toggleActivateText(show){
try{
if(show){
this.screenImage.style.display="none";
this.textNode.style.display="block";
}else{
this.textNode.style.display="none";
}
}catch(e){
this.logEntry('toggleActivateText() error: '+e.message,1,6);
}
};
function screenOnLoad(){
if(this.style.display!="block"){
this.style.display="block";
}
window.status="";
};
function screenOnError(){
if(top.debugIsActive()&&this.src.indexOf('http')>-1){
try{
var result=top.getUrlLib().sendRequest("GET",this.src);
if(result.responseText.indexOf('hpoa:errorText')>-1){
var error=parseResult(result.responseText,'<hpoa:errorText>','</hpoa:errorText>');
top.logEvent(["Insight Display: screenshot load error.","Error: "+error,"Cookie: "+document.cookie],null,1,6);
}
}catch(e){}
}
}
RemoteLcdManager.prototype.toString=function(){return "Virtual Insight Display Manager";};
RemoteLcdManager.prototype.init=_init;
RemoteLcdManager.prototype.logEntry=_logLcdEntry;
RemoteLcdManager.prototype.reset=_reset;
RemoteLcdManager.prototype.unload=_unload;
RemoteLcdManager.prototype.setCallback=_setCallback;
RemoteLcdManager.prototype.startBatch=_startBatch;
RemoteLcdManager.prototype.endBatch=_endBatch;
RemoteLcdManager.prototype.startEvents=_startEvents;
RemoteLcdManager.prototype.stopEvents=_stopEvents;
RemoteLcdManager.prototype.usePercentMode=_usePercentMode;
RemoteLcdManager.prototype.useNormalMode=_useNormalMode;
RemoteLcdManager.prototype.setImageContainer=_setImageContainer;
RemoteLcdManager.prototype.setScreenImage=_setScreenImage;
RemoteLcdManager.prototype.toggleActivateText=_toggleActivateText;
RemoteLcdManager.prototype.setLcdButtonsLocked=_setLcdButtonsLocked;
RemoteLcdManager.prototype.toggleButtonsLockedDisplay=_toggleButtonsLockedDisplay;
RemoteLcdManager.prototype.pressButton=_pressButton;
RemoteLcdManager.prototype.getScreenInfo=_getScreenInfo;
RemoteLcdManager.prototype.getPinInfo=_getPinInfo;
RemoteLcdManager.prototype.getUserNoteInfo=_getUserNoteInfo;
RemoteLcdManager.prototype.getChatInfo=_getChatInfo;
RemoteLcdManager.prototype.getDataManager=_getDataManager;
RemoteLcdManager.prototype.getCallManager=_getCallManager;
RemoteLcdManager.prototype.getUserNotes=_getUserNotesClass;
RemoteLcdManager.prototype.getPinSecurity=_getPinSecurityClass;
RemoteLcdManager.prototype.getChatSession=_getChatSessionClass;
RemoteLcdManager.prototype.getLayer=_getLayer;
RemoteLcdManager.prototype.getLayers=_getLayers;
RemoteLcdManager.prototype.addLayer=_addLayer;
RemoteLcdManager.prototype.removeLayer=_removeLayer;
RemoteLcdManager.prototype.refreshLayer=_refreshLayer;
function UserNotes(onboardAdmin,callManager,dataManager,owner){
var me=this;
this.oa=onboardAdmin;
this.callManager=callManager;
this.dataManager=dataManager;
this.owner=owner;
this.userNotes=null;
this.setUserNotesResponse=function(result){
if(isSoapError(result)){
var errMsg=getSoapError(result);
alert("Update failed:\n\n"+errMsg);
}
}
this.getUserNotesResponse=function(result){
if(isSoapError(result)){
me.logEntry("getUserNotesResponse error.",1,6,[getSoapError(result)]);
}else{
for(var i=0;i<me.userNotes.length;i++){
var tagName=addNS("lcdUserNotesLine"+(i+1));
me.userNotes[i]=getElementValueXpath(result,"//"+tagName);
me.dataManager.updateDomNodeValue(tagName,me.userNotes[i]);
}
}
}
this.userImageChangedResponse=function(result){
if(isSoapError(result)){
me.logEntry("userImageChangedResponse(): "+getSoapError(result),1,6);
}
}
this.eventHandler=function(payload){
var eventType=getElementValueXpath(payload,"//"+addNS("event"));
switch(eventType){
case RemoteLcdUserNoteEvents[0]:
me.getUserNotesResponse(payload);
break;
case RemoteLcdUserNoteEvents[1]:
me.userImageChangedResponse(payload);
break;
default:
me.logEntry("Unsupported event: "+eventType,1,6);
}
}
};
function _initUserNotes(){
this.userNotes=new Array(6);
this.getUserNotes();
this.owner.startEvents(this.eventHandler,RemoteLcdUserNoteEvents);
};
function _unloadUserNotes(){
this.owner.stopEvents(this.eventHandler);
};
function _setUserNotes(args){
this.callManager.makeCall(this.oa.setLcdUserNotes,[args[0],args[1],args[2],args[3],args[4],args[5]]);
};
function _getUserNotes(){
this.callManager.makeCall(this.oa.getLcdUserNotes,null,null,null,this.getUserNotesResponse);
};
function _removeUserNotes(){
this.callManager.makeCall(this.oa.resetLcdUserNotes);
};
function _getUserNoteLine(lineNumber){
if(lineNumber>=1&&lineNumber<=this.userNotes.length){
return this.userNotes[lineNumber-1];
}
return "";
};
function _removeUserImage(){
this.callManager.makeCall(this.oa.resetLcdUserNotesImage);
};
function _logUserNoteEntry(msg,level,severity,extraData){
var entry="User Notes: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
UserNotes.prototype.toString=function(){return "UserNotes Class";}
UserNotes.prototype.init=_initUserNotes;
UserNotes.prototype.unload=_unloadUserNotes;
UserNotes.prototype.logEntry=_logUserNoteEntry;
UserNotes.prototype.setUserNotes=_setUserNotes;
UserNotes.prototype.getUserNotes=_getUserNotes;
UserNotes.prototype.removeUserNotes=_removeUserNotes;
UserNotes.prototype.getUserNoteLine=_getUserNoteLine;
UserNotes.prototype.removeUserImage=_removeUserImage;
function ChatSession(onboardAdmin,callManager,dataManager,owner){
var me=this;
this.oa=onboardAdmin;
this.dataManager=dataManager;
this.callManager=callManager;
this.owner=owner;
this.chatLogUpdateMethod=null;
this.withdrawButtonMethod=null;
this.chatName=null;
this.chatMessage=null;
this.chatMenus=null;
this.menuStrings=null;
this.chatInputBox=null;
this.eventHandler=function(payload){
var eventType=getElementValueXpath(payload,"//"+addNS("event"));
var msg='';
var usr=getElementValueXpath(payload,"//"+addNS("screenName"));
switch(eventType){
case RemoteLcdChatEvents[0]:
msg=getElementValueXpath(payload,"//"+addNS("questionText"));
break;
case RemoteLcdChatEvents[1]:
msg=getElementValueXpath(payload,"//"+addNS("customAnswerText"));
if(msg==''){
msg=getElementValueXpath(payload,"//"+addNS("selectedAnswerText"));
}
me.toggleWithdrawButton(false);
break;
case RemoteLcdChatEvents[2]:
me.toggleWithdrawButton(false);
break;
default:
me.logEntry("Unsupported event: "+eventType,1,6);
}
if(usr!=""){
me.updateChatLog(usr+": "+unescape(replaceChar(escape(msg),"%5E"," ")));
}
}
};
function _initChatSession(){
this.debugLog=[this.toString()+": Error Log"];
this.chatName=(this.oa?this.oa.getCurrentServiceUser():"User");
this.chatMessage="";
this.chatMenus=new Array();
this.menuStrings=new Array();
this.menuStrings.push("Yes");
this.menuStrings.push("No");
this.menuStrings.push("Not sure");
this.menuStrings.push("Other");
this.chatMenus.push(new ChatMenu(this.menuStrings[0],true));
this.chatMenus.push(new ChatMenu(this.menuStrings[1],true));
this.chatMenus.push(new ChatMenu(this.menuStrings[2],true));
this.chatMenus.push(new ChatMenu(this.menuStrings[3],true));
this.owner.startEvents(this.eventHandler,RemoteLcdChatEvents);
};
function _setChatInputBox(elemTextarea){
if(elemTextarea){
this.chatInputBox=elemTextarea;
this.chatInputBox.MaxRows=elemTextarea.getAttribute('rows');
this.chatInputBox.MaxChars=elemTextarea.getAttribute('cols');
if(this.chatInputBox.attachEvent){
this.chatInputBox.attachEvent("onkeyup",this.manageChatInput);
this.chatInputBox.attachEvent("onkeydown",this.manageChatInput);
this.chatInputBox.attachEvent("onchange",this.killPaste);
}else{
this.chatInputBox.onkeyup=this.manageChatInput;
this.chatInputBox.onkeydown=this.manageChatInput;
this.chatInputBox.onchange=this.killPaste;
}
}
};
function _killPaste(e){
var elem=(e.target?e.target:e.srcElement);
var brk=(document.all?'\r\n':'\n');
var text=elem.value;
var charLimit=(elem.MaxRows*elem.MaxChars)+(3*brk.length);
if(text.length>charLimit||totalRows(text)>elem.MaxRows){
elem.value='';
}
};
function _manageChatInput(e){
var acceptedChars=[8,16,17,18,20,27,33,34,35,36,37,38,39,40,46];
var elem=(e.target?e.target:e.srcElement);
var charCode=(e.which?e.which:e.keyCode);
var text=replaceChar(elem.value,'\r','');
var selStart=getSelectionRange(elem).start;
try{
if(e.ctrlKey&&charCode==118){
return false;
}
if(arrayContains(acceptedChars,charCode)){
return true;
}
if(charCode==13){
return(totalRows(text)>=elem.MaxRows?false:totalCharsOnLine(text,selStart)>0);
}
if(!(totalCharsOnLine(text,selStart)<elem.MaxChars)){
return false;
}
}catch(err){
return true;
}
return true;
};
function _unloadChatSession(){
this.owner.stopEvents(this.eventHandler);
};
function _setWithdrawButtonMethod(method){
this.withdrawButtonMethod=method;
};
function _toggleWithdrawButton(enabled){
if(typeof(this.withdrawButtonMethod)=='function'){
this.withdrawButtonMethod(enabled);
}
};
function _setChatLogUpdateMethod(method){
this.chatLogUpdateMethod=method;
};
function _updateChatLog(msg){
if(this.chatLogUpdateMethod){
this.chatLogUpdateMethod(msg);
}
};
function _setDefaultMenus(){
for(var i=0;i<this.chatMenus.length;i++){
this.chatMenus[i].menuText=this.menuStrings[i];
this.chatMenus[i].selected=true;
this.dataManager.updateDomNodeValue(addNS("menu"+(i+1)),
this.menuStrings[i],["checked","checked"]);
}
};
function _setMenuItem(index,text,selected){
if(isValidIndex(index,this.chatMenus)){
this.chatMenus[index].menuText=text;
this.chatMenus[index].selected=selected;
this.dataManager.updateDomNodeValue(addNS("menu"+(index+1)),
this.menuStrings[index],["checked",(selected==true?"checked":null)]);
}
};
function _getMenuItemText(index){
if(isValidIndex(index,this.chatMenus)){
return this.chatMenus[index].menuText;
}
};
function _getMenuItemSelected(index){
if(isValidIndex(index,this.chatMenus)){
return this.chatMenus[index].selected;
}
};
function _askChatQuestion(user,msg,menus){
this.chatName=user;
this.chatMessage=msg;
this.updateMenus(menus);
var maxLen=10;
var parsedMsg=unescape(replaceChar(escape(msg),"%0D%0A",'^'));
parsedMsg=unescape(replaceChar(escape(parsedMsg),"%0A",'^'));
this.dataManager.updateDomNodeValue(addNS("lcdChatName"),this.chatName);
this.dataManager.updateDomNodeValue(addNS("lcdChatMessage"),this.chatMessage);
this.callManager.makeCall(this.oa.askLcdCustomQuestion,[user,parsedMsg,this.getMenuString(),maxLen]);
this.withdrawButtonMethod(true);
};
function _withdrawChatQuestion(user,msg,menus){
this.callManager.makeCall(this.oa.withdrawLcdQuestion);
};
function _updateMenus(menus){
for(var i=0;i<menus.length;i++){
this.chatMenus[i].selected=menus[i].selected;
this.chatMenus[i].menuText=menus[i].menuText;
this.dataManager.updateDomNodeValue(addNS("menu"+(i+1)),
menus[i].menuText,["checked",(menus[i].selected==true?"checked":null)]);
}
};
function _getMenuString(){
var LINE_BREAK="^";
var menu="";
for(i=0;i<this.chatMenus.length;i++){
if(this.chatMenus[i].selected){
menu+=this.chatMenus[i].menuText+LINE_BREAK;
}
}
if(menu.charAt(menu.length-1)==LINE_BREAK){
menu=menu.substring(0,menu.length-1);
}
return menu;
};
function _logChatEntry(msg,level,severity,extraData){
var entry="Chat Session: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
ChatSession.prototype.toString=function(){return "ChatSession Class";}
ChatSession.prototype.init=_initChatSession;
ChatSession.prototype.unload=_unloadChatSession
ChatSession.prototype.logEntry=_logChatEntry;
ChatSession.prototype.updateMenus=_updateMenus;
ChatSession.prototype.setMenuItem=_setMenuItem;
ChatSession.prototype.getMenuItemText=_getMenuItemText;
ChatSession.prototype.setWithdrawButtonMethod=_setWithdrawButtonMethod;
ChatSession.prototype.toggleWithdrawButton=_toggleWithdrawButton;
ChatSession.prototype.setChatLogUpdateMethod=_setChatLogUpdateMethod;
ChatSession.prototype.setChatInputBox=_setChatInputBox;
ChatSession.prototype.killPaste=_killPaste;
ChatSession.prototype.manageChatInput=_manageChatInput;
ChatSession.prototype.updateChatLog=_updateChatLog;
ChatSession.prototype.getMenuItemSelected=_getMenuItemSelected;
ChatSession.prototype.getMenuString=_getMenuString;
ChatSession.prototype.setDefaultMenus=_setDefaultMenus;
ChatSession.prototype.askChatQuestion=_askChatQuestion;
ChatSession.prototype.withdrawChatQuestion=_withdrawChatQuestion;
function ChatMenu(menuText,selected){
this.menuText=menuText;
this.selected=selected;
};
function PinSecurity(onboardAdmin,callManager,dataManager,owner){
var me=this;
this.oa=onboardAdmin;
this.dataManager=dataManager;
this.callManager=callManager;
this.owner=owner;
this.enabled=null;
this.pinEnableControl=null;
this.pinEnableMethod=null;
this.buttonLockControl=null;
this.getPinEnabledResponse=function(result){
if(isSoapError(result)&&me.debug){
me.logEntry("getPinEnabledResponse(): "+getSoapError(result),1,6);
}else{
me.enabled=parseBool(getElementValueXpath(result,"//"+addNS("lcdPin")));
me.dataManager.updateDomNodeValue(addNS("lcdPinEnabled"),me.enabled.toString());
me.updateHostControl("PIN_CODE_ENABLE",me.enabled);
}
}
this.eventHandler=function(payload){
var eventType=getElementValueXpath(payload,'//'+addNS('event'));
switch(eventType){
case RemoteLcdPinEvents[0]:
me.getPinEnabledResponse(payload);
break;
default:
me.logEntry("Unsupported event: "+eventType,1,6);
}
}
};
function _initPinSecurity(){
this.owner.startEvents(this.eventHandler,RemoteLcdPinEvents);
};
function _updateHostControl(type,value){
switch(type){
case "PIN_CODE_ENABLE":
if(this.pinEnableControl){
this.pinEnableControl.checked=parseBool(value);
}
if(isFunction(this.pinEnableMethod)){
this.pinEnableMethod(parseBool(value));
}
break;
case "BUTTON_LOCK_ENABLE":
if(this.buttonLockControl){
this.buttonLockControl.checked=parseBool(value);
}
break;
}
}
function _unloadPinSecurity(){
this.owner.stopEvents(this.eventHandler);
};
function _setPinCode(code){
this.callManager.makeCall(this.oa.setLcdProtectionPin,[code],null,['25']);
};
function _logPinEntry(msg,level,severity,extraData){
var entry="Pin Security: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
PinSecurity.prototype.toString=function(){return "PinSecurity Class";}
PinSecurity.prototype.init=_initPinSecurity;
PinSecurity.prototype.updateHostControl=_updateHostControl;
PinSecurity.prototype.unload=_unloadPinSecurity;
PinSecurity.prototype.logEntry=_logPinEntry;
PinSecurity.prototype.setPinCode=_setPinCode;
function LcdDataManager(onboardAdmin){
var me=this;
this.oa=onboardAdmin;
this.xml=null;
this.domInfo=null;
};
function _debugDomMsg(){
if(this.debug){
if(typeof(XMLSerializer)!='undefined'){
return(new XMLSerializer().serializeToString(this.domInfo));
}else{
return(this.domInfo.xml);
}
}
};
function _getXml(){
if(typeof(this.xml)!="undefined"&&this.xml==null){
try{
this.xml=importModule("xml");
}catch(err){
this.logEntry("getXml(): "+err.message,1,6);
}
}
return this.xml;
};
function _assertParseable(fragment){
var isMoz=false;
var docString='';
var parsedDoc=null;
if(typeof(XMLSerializer)!='undefined'){
docString=(new XMLSerializer().serializeToString(fragment));
isMoz=true;
}else{
docString=fragment.xml;
}
parsedDoc=(this.getXml().parseXML(docString));
if(isMoz){
parsedDoc.xml=docString;
}
return parsedDoc;
};
function _createDomDocument(){
this.domInfo=this.createRootNode();
this.updateDomInfo(this.createDomScreenInfo());
this.updateDomInfo(this.createDomPinInfo());
this.updateDomInfo(this.createDomUserNoteInfo());
this.updateDomInfo(this.createDomChatInfo());
};
function _createRootNode(){
return this.getXml().parseXML('<'+addNS("lcdInfo")+' xmlns:'+OA_NAMESPACE()+'=\"'+OA_NAMESPACE()+'.xsd\" />');
};
function _createDomScreenInfo(){
var frag=this.createFragment();
frag=this.appendNodeToFragment(frag,addNS("lcdScreenInfo"));
frag=this.appendNodeToFragment(frag,addNS("status"),"",addNS("lcdScreenInfo"));
frag=this.appendNodeToFragment(frag,addNS("buttonLock"),"",addNS("lcdScreenInfo"));
frag=this.appendNodeToFragment(frag,addNS("fwVersion"),"",addNS("lcdScreenInfo"));
frag=this.appendNodeToFragment(frag,addNS("partNumber"),"",addNS("lcdScreenInfo"));
return this.appendNodeToFragment(frag,addNS("display"),"",addNS("lcdScreenInfo"));
};
function _createDomPinInfo(){
var frag=this.createFragment();
frag=this.appendNodeToFragment(frag,addNS("lcdPinInfo"));
return this.appendNodeToFragment(frag,addNS("lcdPinEnabled"),"",addNS("lcdPinInfo"));
};
function _createDomUserNoteInfo(){
var frag=this.createFragment();
frag=this.appendNodeToFragment(frag,addNS("lcdUserNoteInfo"));
frag=this.appendNodeToFragment(frag,addNS("lcdUserNotes"),null,addNS("lcdUserNoteInfo"));
frag=this.appendNodeToFragment(frag,addNS("lcdUserNotesLine1"),"",addNS("lcdUserNotes"));
frag=this.appendNodeToFragment(frag,addNS("lcdUserNotesLine2"),"",addNS("lcdUserNotes"));
frag=this.appendNodeToFragment(frag,addNS("lcdUserNotesLine3"),"",addNS("lcdUserNotes"));
frag=this.appendNodeToFragment(frag,addNS("lcdUserNotesLine4"),"",addNS("lcdUserNotes"));
frag=this.appendNodeToFragment(frag,addNS("lcdUserNotesLine5"),"",addNS("lcdUserNotes"));
return this.appendNodeToFragment(frag,addNS("lcdUserNotesLine6"),"",addNS("lcdUserNotes"));
};
function _createDomChatInfo(){
var attribs=["checked","checked"];
var chatName=this.oa.getCurrentServiceUser();
var frag=this.createFragment();
frag=this.appendNodeToFragment(frag,addNS("lcdChatInfo"));
frag=this.appendNodeToFragment(frag,addNS("lcdChatName"),chatName,addNS("lcdChatInfo"));
frag=this.appendNodeToFragment(frag,addNS("lcdChatMessage"),"",addNS("lcdChatInfo"));
frag=this.appendNodeToFragment(frag,addNS("lcdChatMenus"),null,addNS("lcdChatInfo"));
frag=this.appendNodeToFragment(frag,addNS("menu1"),"Yes",addNS("lcdChatMenus"),attribs);
frag=this.appendNodeToFragment(frag,addNS("menu2"),"No",addNS("lcdChatMenus"),attribs);
frag=this.appendNodeToFragment(frag,addNS("menu3"),"Not sure",addNS("lcdChatMenus"),attribs);
return this.appendNodeToFragment(frag,addNS("menu4"),"Other",addNS("lcdChatMenus"),attribs);
};
function _createFragment(){
try{
return this.domInfo.createDocumentFragment();
}catch(err){
this.logEntry("this.createFragment(): "+err.message,1,6);
}
};
function _getDomFragment(fragmentRoot){
var tempDoc=null;
try{
tempDoc=this.createRootNode();
tempDoc.documentElement.appendChild(this.domInfo.getElementsByTagName(fragmentRoot)[0].cloneNode(true));
}catch(err){
this.logEntry("getDomFragment("+fragmentRoot+"): "+err.message,1,6);
}
return(this.assertParseable(tempDoc));
};
function _updateDomNodeValue(nodeName,nodeValue,attribs){
try{
var node=this.domInfo.getElementsByTagName(nodeName)[0];
if(node){
this.logEntry("Update Dom: "+nodeName+" to ["+nodeValue+"]",8,1);
node.firstChild.nodeValue=nodeValue;
if(attribs!=null){
for(var i=0;i<attribs.length;i+=2){
if(attribs[i+1]==null){
node.removeAttribute(attribs[i]);
}else{
node.setAttribute(attribs[i],attribs[i+1]);
}
}
}
}else{
this.logEntry("Update Dom - Invalid node name: "+nodeName,6,5);
}
}catch(err){
this.logEntry("updateDomNodeValue("+nodeName+"): "+err.message,1,6);
}
};
function _updateDomInfo(fragment){
try{
if(this.domInfo.getElementsByTagName(fragment.firstChild.nodeName)[0]==null){
this.domInfo.documentElement.appendChild(fragment);
}else{
var node=this.domInfo.getElementsByTagName(fragment.firstChild.nodeName)[0];
node.parentNode.replaceChild(fragment.firstChild,node);
}
}catch(err){
this.logEntry("updateDomInfo(): "+err.message,1,6);
}
};
function _appendNodeToFragment(fragment,nodeName,nodeValue,parentName,attribs){
try{
var node=this.domInfo.createElement(nodeName);
var parent=null;
if(attribs!=null){
for(var i=0;i<attribs.length;i+=2){
node.setAttribute(attribs[i],attribs[i+1]);
}
}
if(nodeValue!=null){
var val=this.domInfo.createTextNode(nodeValue);
node.appendChild(val);
}
if(parentName!=null){
if((parent=getFragmentElementsByTagName(fragment,parentName)).length!=0){
parent[0].appendChild(node);
}
}else{
fragment.appendChild(node);
}
}catch(err){
this.logEntry("appendNodeToFragment("+nodeName+"): "+err.message,1,6);
}
return fragment;
};
function _logDataEntry(msg,level,severity,extraData){
var entry="Insight Display DOM: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
LcdDataManager.prototype.toString=function(){return "Insight Display DOM Manager Class";}
LcdDataManager.prototype.logEntry=_logDataEntry;
LcdDataManager.prototype.debugDomMsg=_debugDomMsg;
LcdDataManager.prototype.getXml=_getXml;
LcdDataManager.prototype.assertParseable=_assertParseable;
LcdDataManager.prototype.createRootNode=_createRootNode;
LcdDataManager.prototype.createDomDocument=_createDomDocument;
LcdDataManager.prototype.createDomScreenInfo=_createDomScreenInfo;
LcdDataManager.prototype.createDomPinInfo=_createDomPinInfo;
LcdDataManager.prototype.createDomUserNoteInfo=_createDomUserNoteInfo;
LcdDataManager.prototype.createDomChatInfo=_createDomChatInfo;
LcdDataManager.prototype.createFragment=_createFragment;
LcdDataManager.prototype.updateDomNodeValue=_updateDomNodeValue;
LcdDataManager.prototype.updateDomInfo=_updateDomInfo;
LcdDataManager.prototype.appendNodeToFragment=_appendNodeToFragment;
LcdDataManager.prototype.getDomFragment=_getDomFragment;
ImageLayer.LoadSuccess=0;
ImageLayer.LoadAborted=1;
ImageLayer.LoadError=2;
function ImageLayer(owner,path,x,y,zOrder){
this.loadState=null;
this.owner=owner;
this.span=document.createElement("SPAN");
this.span.style.position="absolute";
this.span.style.visibility="hidden";
this.span.style.top=y;
this.span.style.left=x;
this.span.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+path+"')";
this.span.wrapper=this;
this.img=new Image();
this.img.style.top=0;
this.img.style.left=0;
this.img.style.border="0px";
this.img.style.position="absolute";
this.img.style.filter="progid:DXImageTransform.Microsoft.Alpha(opacity=0)";
this.img.zIndex=zOrder;
this.img.wrapper=this.span;
this.attachHandlers();
this.span.appendChild(this.img);
this.owner.appendChild(this.span);
this.img.src=path;
};
function _attachHandlers(){
this.img.onload=ImageLayer.prototype.onLoad;
this.img.onerror=ImageLayer.prototype.onError;
this.img.onabort=ImageLayer.prototype.onAbort;
};
function _addClickHandler(handler){
this.span.onclick=handler;
};
function _removeClickHandler(){
this.span.onclick=null;
};
function _onLoad(){
this.wrapper.wrapper.loadState=ImageLayer.LoadSuccess;
this.wrapper.style.width=this.width;
this.wrapper.style.height=this.height;
this.wrapper.wrapper.paint();
};
function _onError(){
this.wrapper.wrapper.loadState=ImageLayer.LoadError;
this.wrapper.wrapper.owner.removeChild(this.wrapper);
};
function _onAbort(){
this.wrapper.wrapper.loadState=ImageLayer.LoadAborted;
this.wrapper.wrapper.owner.removeChild(this.wrapper);
};
function _reLoad(url){
if(url&&url!=""){
this.img.src=url;
}
};
function _paint(){
if(this.inBounds(this.span.style.left,this.span.style.top)){
this.span.style.visibility="visible";
}
};
function _move(x,y){
if(this.img&&this.inBounds(x,y)){
this.span.style.left=x;
this.span.style.top=y;
}
};
function _hide(){
this.span.style.visibility="hidden";
};
function _inBounds(x,y){
var boxWidth=parseInt(this.owner.style.width);
var boxHeight=parseInt(this.owner.style.height);
var imgLeft=parseInt(x);
var imgTop=parseInt(y);
var imgWidth=parseInt(this.img.width);
var imgHeight=parseInt(this.img.height);
return(imgLeft<boxWidth&&imgTop<boxHeight&&
imgLeft+imgWidth>0&&imgTop+imgHeight>0);
};
ImageLayer.prototype.toString=function(){return "ImageLayer"};
ImageLayer.prototype.attachHandlers=_attachHandlers;
ImageLayer.prototype.addClickHandler=_addClickHandler;
ImageLayer.prototype.removeClickHandler=_removeClickHandler;
ImageLayer.prototype.onLoad=_onLoad;
ImageLayer.prototype.onError=_onError;
ImageLayer.prototype.onAbort=_onAbort;
ImageLayer.prototype.reLoad=_reLoad;
ImageLayer.prototype.paint=_paint;
ImageLayer.prototype.move=_move;
ImageLayer.prototype.hide=_hide;
ImageLayer.prototype.inBounds=_inBounds;
function addNS(tag){
return OA_NAMESPACE()+":"+tag;
};
function getFragmentElementsByTagName(fragment,nodeName,matches){
if(matches==null){matches=new Array();}
if(fragment.hasChildNodes()){
for(var i=0;i<fragment.childNodes.length;i++){
if(fragment.childNodes[i].nodeName==nodeName){
matches.push(fragment.childNodes[i]);
}
getFragmentElementsByTagName(fragment.childNodes[i],nodeName,matches);
}
}
return matches;
};
function isSoapError(result){
return(getCallSuccess(result)==false);
};
function getSoapError(result){
return(top.getCallAnalyzer().getErrorString(null,result));
};
function getMethodName(result){
if(result){
return getElementValueXpath(result,'//functionName');
}
};
function getSelectionRange(elem){
var selection=new Object();
selection.start=0;
selection.end=0;
if(elem){
if(elem.selectionStart&&elem.selectionEnd){
selection.start=elem.selectionStart;
selection.end=elem.selectionEnd;
}else if(elem.createTextRange){
var newLines=countChars(elem.value,'\r\n');
var position=elem.value.length;
var cursor=document.selection.createRange().duplicate();
while(cursor.parentElement()==elem&&cursor.move('character',1)){
var c=elem.value.charAt(position);
if(c=='\n'){
position--;
newLines--;
}
position--;
}
selection.start=(position+1)-newLines;
selection.end=selection.start+cursor.text.length;
}
}
return selection;
};
function replaceChar(source,replaceChar,replaceWith){
if(isValidString(source)){
var regexp=new RegExp(replaceChar,"g");
source=source.replace(regexp,replaceWith);
}
return source;
};
function countChars(text,searchString){
var total=0;
var done=false;
if(isValidString(text)){
while(!done){
var index=text.indexOf(searchString);
if(index>-1){
total++;
text=text.substring(index+(searchString.length));
}else{
done=true;
}
}
}
return total;
};
function totalRows(text,lineBreakChar){
return(countChars(text,(lineBreakChar?lineBreakChar:'\n'))+1);
};
function getRowNumber(text,selectionStart){
if(!isValidString(text)){
return 1;
}
return(totalRows(text.substr(0,(selectionStart?selectionStart+1:text.length))));
};
function totalCharsOnLine(text,selectionStart){
var rows=totalRows(text);
var chars=0;
if(rows==1){
chars=text.length;
}else{
chars=text.split('\n')[getRowNumber(text,selectionStart)-1].length
}
return chars;
};
function nthIndexOf(text,searchChar,nth){
var index=0;
var total=0;
if(isValidString(text)){
for(var i=0;i<text.length;i++){
if(text.charAt(i)==searchChar){
if(++total==nth){
index=i;
break;
}
}
}
}
return index;
};
