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
function FormManager(loadedHandler,isWizard,errorContainerId,bodyContainerId,waitContainerId){
var me=this;
this.enclosureName="";
this.enclosureId="";
this.loadedHandler=loadedHandler;
this.isWizard=parseBool(isWizard);
this.isTransaction=false;
this.displayManager=new DisplayManager(bodyContainerId,waitContainerId,errorContainerId);
this.debug=false;
this.debugLog=[this.toString()+": Debug Log"];
this.alertOnFailure=false;
this.useErrorLabels=false;
this.useErrorContainer=true;
this.batchEventDelay=0;
this.notifyLoadedResponse=function(errors,delayed){
me.logEntry("notifyLoadedResponse() called - verified errors: "+errors.length);
if(!delayed&&(me.batchEventDelay>0&&me.batchEventDelay<=15)){
window.setTimeout(function(){me.notifyLoadedResponse(errors,true);},me.batchEventDelay*1000);
return;
}
var success=(errors.length==0);
if(!success){
if(!me.isTransaction){
me.displayManager.showMainScreen();
if(me.useErrorContainer==true){
me.showErrorContainer(true,me.getErrorList(true));
}
}
if(me.useErrorLabels==true){
me.callManager.formatErrorLabels();
}
}else{
if(!me.isWizard){
me.showErrorContainer(false);
if(!me.isTransaction){
if(delayed){
window.setTimeout(function(){me.displayManager.showMainScreen();reconcilePage();},50);
}else{
me.displayManager.showMainScreen();
}
}
}
}
if(typeof(me.loadedHandler)=='function'){
try{
me.loadedHandler(success);
}catch(e){
me.logEntry('Could not call final callback: '+e.message);
}
}else if(!success){
if(me.alertOnFailure){
alert(top.getString('genericFailedMessage'));
}
}
if(me.debug==true){
me.displayDebugLog();
}
removeBatchInProgress();
}
this.callManager=new CallManager(this.notifyLoadedResponse);
};
function _setTimeoutEnabled(enable,milliseconds,enablePrompt){
this.callManager.enableTimeout=parseBool(enable);
if(typeof(milliseconds)!='undefined'){
var ms=parseInt(milliseconds);
if(!isNaN(ms)&&ms>0){
this.callManager.MaxLoadTime=parseInt(ms);
}
}
if(typeof(enablePrompt)!='undefined'){
this.callManager.enableTimeoutPrompt=parseBool(enablePrompt);
}
};
function _setLoadedCallback(callback){
if(typeof(callback)=='function'){
this.loadedHandler=callback;
}
};
function _getDataByCallName(methodName,args,xpath,nodeOnly){
return this.callManager.getCallbackResultByName(methodName,args,xpath,nodeOnly);
};
function _getDataByCallIndex(index,xpath,nodeOnly){
return this.callManager.getCallbackResultByIndex(index,xpath,nodeOnly);
};
function _setErrorContainer(errorContainerId){
if(isValidString(errorContainerId)){
this.displayManager.setErrorContainer(errorContainerId);
this.useErrorContainer=true;
}else{
this.displayManager.setErrorContainer('');
this.useErrorContainer=false;
}
};
function _createWaitContainer(waitText,waitDescription){
this.displayManager.createWaitContainer(waitText,waitDescription);
};
function _reset(){
this.useErrorLabels=false;
this.debugLog=[this.toString()+": Debug Log"];
this.callManager.reset();
};
function _showErrorContainer(show,msg){
if(show==true){
this.displayManager.showErrors(msg);
}else{
this.displayManager.hideErrors(this.isTransaction);
}
};
function _startTransactionBatch(fresh,sequential){
this.logEntry("Transaction Batch started");
this.isTransaction=true;
this.callManager.reset();
this.callManager.enableTimeoutPrompt=false;
this.callManager.startBatch(fresh,sequential);
};
function _startBatch(loading,fresh,newLoadedHandler){
this.logEntry("Batch started, mode="+(loading?'Loading':'Default')+
" fresh="+(fresh?parseBool(fresh):'false'));
if(newLoadedHandler!=null){
this.loadedHandler=newLoadedHandler;
}
if(loading){
this.displayManager.createLoadContainer();
}else{
this.displayManager.hideErrors();
this.displayManager.showWaitScreen();
}
this.callManager.reset();
this.callManager.startBatch(parseBool(fresh));
};
function _endBatch(){
this.logEntry("Batch ended ...");
addBatchInProgress();
this.callManager.endBatch();
};
function _queueCall(call,args,labels,okErrors,callback,pendingCallback){
if(isArray(labels)){
this.useErrorLabels=true;
}
this.callManager.makeCall(call,args,labels,okErrors,callback,pendingCallback,
this.enclosureName,this.enclosureId);
};
function _makeCallDirect(call,args,labels,okErrors,callback){
this.logEntry("making direct call - batch state:"+this.callManager.batchState);
if(isArray(labels)){
this.useErrorLabels=true;
}
this.displayManager.hideErrors();
this.displayManager.showWaitScreen();
addBatchInProgress();
this.callManager.reset();
this.callManager.makeCall(call,args,labels,okErrors,callback,
this.enclosureName,this.enclosureId);
};
function _setCurrentEnclosureName(name,id){
this.enclosureName=name;
if(id!=null){
this.enclosureId=id;
}
};
function _usePercentMode(percentHandler){
this.callManager.setReportMode(ReportMode.Percent,percentHandler);
};
function _useNormalMode(){
this.callManager.setReportMode(ReportMode.Normal);
};
function _toggleDebugMode(debugOn,recursive){
this.debug=parseBool(debugOn);
if(recursive){
this.callManager.debug=parseBool(debugOn);
}
};
function _getErrorList(useHtml){
return this.callManager.getErrorList(useHtml);
};
function _getErrorsArray(){
return this.callManager.getErrorStrings();
};
function _getDebugLog(useHtml,recursive){
var log="";
var lineBreak=(useHtml?"<br /><br />":"\n\n");
log=(formatLog(this.debugLog,useHtml)+(this.debug?"":"-Not in debug mode."));
if(recursive){
log+=lineBreak+this.callManager.getCallLog(useHtml);
}
return log;
}
function _displayDebugLog(){
var debugWin=null;
var winName='formMgrDebugLog'+(Math.random().toString().split(".")[1]);
if(this.debug==true){
var optionsList="width=750,height=600,status=no,resizable=yes,scrollbars=yes";
var style="\"font-family:monospace;background-color:#222222;color:lime;font-size:12px;\"";
try{
debugWin=window.open("",winName,optionsList);
debugWin.document.write("<html><body style="+style+">");
debugWin.document.write(this.getDebugLog(true,true));
debugWin.document.write("</body></html>");
debugWin.document.title="HP Debugger";
debugWin.document.close();
}catch(err){
if(debugWin){
try{debugWin.close();}catch(e){}
}
alert(this.getDebugLog(false,true));
}
}
};
function _logMainEntry(logText){
if(this.debug){this.debugLog.push(logText);}
};
FormManager.prototype.toString=function(){return 'Form Manager 1.0';}
FormManager.prototype.setTimeoutEnabled=_setTimeoutEnabled;
FormManager.prototype.startTransactionBatch=_startTransactionBatch;
FormManager.prototype.startBatch=_startBatch;
FormManager.prototype.endBatch=_endBatch;
FormManager.prototype.queueCall=_queueCall;
FormManager.prototype.makeCall=_makeCallDirect;
FormManager.prototype.getDataByCallName=_getDataByCallName;
FormManager.prototype.getDataByCallIndex=_getDataByCallIndex;
FormManager.prototype.setLoadedCallback=_setLoadedCallback;
FormManager.prototype.setErrorContainer=_setErrorContainer;
FormManager.prototype.setCurrentEnclosureName=_setCurrentEnclosureName;
FormManager.prototype.usePercentMode=_usePercentMode;
FormManager.prototype.useNormalMode=_useNormalMode;
FormManager.prototype.toggleDebugMode=_toggleDebugMode;
FormManager.prototype.getDebugLog=_getDebugLog;
FormManager.prototype.displayDebugLog=_displayDebugLog;
FormManager.prototype.logEntry=_logMainEntry;
FormManager.prototype.showErrorContainer=_showErrorContainer;
FormManager.prototype.createWaitContainer=_createWaitContainer;
FormManager.prototype.getErrorList=_getErrorList;
FormManager.prototype.getErrorsArray=_getErrorsArray;
FormManager.prototype.reset=_reset;
function CallManager(loadedHandler){
var me=this;
this.loadedHandler=loadedHandler;
this.batchState=BatchState.None;
this.getFresh=false;
this.sequential=false;
this.allowDuplicateErrors=false;
this.callsQueued=new Array();
this.callsIssued=new Array();
this.debugLog=[this.toString()+": Debug Log"];
this.debug=false;
this.reportMode=ReportMode.Normal;
this.percentHandler=null;
this.enableTimeout=true;
this.enableTimeoutPrompt=false;
this.MaxLoadTime=300000
this.timerId=0;
this.finishLoad=function(){
this.stopLoadTimer();
this.logEntry("finishLoad() called");
var result=this.getCallbackErrorCodes();
if(this.batchState!=BatchState.None&&this.reportMode==ReportMode.Percent){
window.setTimeout(function(){me.finalCallback(result)},1000);
}else{
this.finalCallback(result);
}
}
this.finalCallback=function(result){
if(me.loadedHandler){
me.logEntry("calling final callback - errors:"+(isArray(result)?result.length:'no data'));
if(me.batchState==BatchState.TimedOut){
result=[ErrorCode.BatchTimedOut];
}else if(me.batchState==BatchState.Aborted){
result=[ErrorCode.Aborted];
}
try{
me.loadedHandler(result);
}catch(e){
me.logEntry("Could not call final callback: "+e.message);
}
}
}
this.setReportMode=function(mode,percentCallback){
switch(mode){
case ReportMode.Percent:
this.reportMode=ReportMode.Percent;
this.percentHandler=percentCallback;
break;
case ReportMode.Normal:
default:
this.reportMode=ReportMode.Normal;
this.percentHandler=null;
break;
}
}
this.getErrorList=function(useHtml){
var errorText="";
var lineBreak=(useHtml?"<br />":"\n");
if(this.batchState==BatchState.Aborted||this.batchState==BatchState.TimedOut){
var errCode=(this.batchState==BatchState.Aborted?ErrorCode.Aborted:ErrorCode.BatchTimedOut);
var errMsg=top.getErrorString(errCode,ErrorType.FormManager);
return(errMsg==""?"Result code "+errCode+" not found in the strings file.":errMsg);
}
var errors=this.getErrorStrings();
for(var i=0;i<errors.length;i++){
errorText+=errors[i]+(i==errors.length-1?"":lineBreak);
}
return errorText;
}
this.restartLoadTimer=function(){
this.stopLoadTimer();
if(parseBool(this.enableTimeout)==true){
this.timerId=window.setTimeout(function(){me.timedOut()},this.MaxLoadTime);
}
}
this.stopLoadTimer=function(){
if(this.timerId>0){
window.clearTimeout(this.timerId);
this.timerId=0;
}
}
this.timedOut=function(){
this.logEntry("timedOut()");
if(parseBool(this.enableTimeoutPrompt)==true){
if(confirm(top.getString('confirmContinueWait'))){
this.logEntry("timer restarted after timeout");
this.restartLoadTimer();
return;
}else{
this.batchState=BatchState.Aborted;
}
}else{
this.batchState=BatchState.TimedOut;
}
this.cancelCalls();
this.finishLoad();
}
this.startBatch=function(fresh,sequential){
this.batchState=BatchState.Queue;
this.getFresh=parseBool(fresh);
this.sequential=parseBool(sequential);
}
this.endBatch=function(){
this.batchState=BatchState.Loading;
this.loadQueue();
}
};
function _makeCall(call,args,labels,okErrors,callback,pendingCallback,encName,encId){
if(this.batchState==BatchState.Queue){
this.addQueuedCall(call,args,labels,okErrors,callback,pendingCallback,encName,encId);
return;
}else{
var thisCallback=new Callback(call,args,labels,okErrors,callback,pendingCallback,encName,encId,this);
thisCallback.getFresh=this.getFresh;
}
this.addCallback(thisCallback);
if(!this.sequential){
thisCallback.submitNow();
}
};
function _addCallback(callObject){
this.callsIssued.push(callObject);
if(this.enableTimeout){
this.restartLoadTimer();
}
};
function _addQueuedCall(call,args,labels,okErrors,callback,pendingCallback,encName,encId){
this.callsQueued.push(new QueuedCall(call,args,labels,okErrors,callback,pendingCallback,encName,encId));
};
function _loadQueue(){
for(var index in this.callsQueued){
var callObj=this.callsQueued[index];
this.makeCall(callObj.call,callObj.args,callObj.labels,callObj.okErrors,
callObj.callback,callObj.pendingCallback,callObj.enclosureName,callObj.enclosureId);
callObj.loaded=true;
}
this.batchState=BatchState.Complete;
this.assertLoaded();
};
function _assertLoaded(){
var percent=this.percentComplete();
this.logEntry("assertLoaded() - complete:"+percent+"%  state:"+this.batchState+"  mode:"+this.reportMode);
if(this.sequential){
for(var index in this.callsIssued){
var call=this.callsIssued[index];
if(call.callState==CallState.None){
call.submitNow();
break;
}
}
}
switch(this.reportMode){
case ReportMode.Percent:
if(this.batchState!=BatchState.None){
this.reportPercent(percent);
}
default:
if(percent==100&&this.batchState!=BatchState.Loading){
this.finishLoad();
}
}
};
function _reportPercent(percent){
this.logEntry("reportPercent("+percent+")");
if(this.percentHandler&&this.reportMode==ReportMode.Percent){
this.percentHandler(percent);
}
};
function _percentComplete(){
var total=(this.batchState==BatchState.None?
this.callsIssued.length:
this.callsQueued.length);
var errors=0;
var recd=0;
var percent=0;
for(var index in this.callsIssued){
var call=this.callsIssued[index];
if(call.callState==CallState.Error){
errors++;
}else{
if(call.completed==true){
recd++;
}
}
}
this.logEntry("calls:"+total+" invalid:"+errors+" recd:"+recd);
if(total>0){
percent=(total==(errors+recd)?100:parseInt(((recd+errors)/total)*100));
}else{
percent=100;
}
return percent;
};
function _cancelCalls(){
this.logEntry("cancelCalls() called - state: "+this.batchState);
for(var index in this.callsIssued){
if(this.callsIssued[index].completed==false){
this.callsIssued[index].cancel();
}
}
};
function _resetCalls(){
this.logEntry("reset() called - batch state: "+this.batchState);
this.callsIssued=new Array();
this.callsQueued=new Array();
this.batchState=BatchState.None;
this.getFresh=false;
};
function _getCallbackResultByName(methodName,args,xpath,nodeOnly){
var hits=new Array();
var call=null;
for(var index in this.callsIssued){
if(methodName==this.callsIssued[index].methodName){
hits.push(this.callsIssued[index]);
}
}
if(hits.length==1){
call=hits[0];
}else if(hits.length>1){
if(!existsNonNull(args)){
call=hits[0];
}else{
for(var j in hits){
var found=true;
if(args.length!=hits[j].args.length){
found=false;
}else{
for(var i in args){
if(!(typeof(args[i])=='object'&&typeof(hits[j].args[i])=='object')){
if(args[i]!=hits[j].args[i]){
found=false;
break;
}
}
}
}
if(found){
call=hits[j];
break;
}
}
}
}
return(call==null?'':call.getResult(xpath,nodeOnly));
};
function _getCallbackResultByIndex(index,xpath,nodeOnly){
if(isValidIndex(index,this.callsIssued)){
return(this.callsIssued[index].getResult(xpath,nodeOnly));
}
return '';
};
function _getTotalFailures(){
return(this.getCallbackErrorCodes().length);
};
function _getCallbackErrorCodes(){
var codes=new Array();
for(var index in this.callsIssued){
var call=this.callsIssued[index];
if(call.errorNumber!=""&&call.allowError==false){
codes.push(call.errorNumber);
}
}
return codes;
};
function _getErrorStrings(){
var errors=new Array();
var errMsg='';
for(var index in this.callsIssued){
var call=this.callsIssued[index];
errMsg=this.getErrorString(call);
if(errMsg!=''){
errors.push(errMsg);
}
}
return(this.allowDuplicateErrors?errors:removeDuplicates(errors));
};
function _getErrorString(call){
var errMsg='';
try{
if(call.errorNumber!=""&&call.allowError==false){
errMsg=(call.errorString==""?top.getErrorString(call.errorNumber,call.errorType):call.errorString);
if(errMsg==""&&call.rawString!=""){
errMsg=call.rawString;
}
if(call.appendString!=""){
errMsg+=" "+top.getString(call.appendString);
}
if(errMsg==""){
this.logEntry("Result code "+call.errorNumber+" of type "+call.errorType+" not found in the strings file.");
errMsg="Error "+call.errorNumber+" occurred."
}else{
errMsg+=(isValidString(call.enclosureName)?' ('+call.enclosureName+')':'');
}
}
}catch(e){this.logEntry('getErrorString(): '+e.message);}
return errMsg;
};
function _formatErrorLabels(){
for(var index in this.callsIssued){
call=this.callsIssued[index];
var clsName=((call.errorNumber!=""&&call.allowError==false)?'invalidFormLabel':'');
for(var j=0;j<call.labels.length;j++){
try{
if(clsName!=""){this.logEntry('formatting label '+call.labels[j]);}
document.getElementById(call.labels[j]).className=clsName;
}catch(err){
this.logEntry('error formatting label '+call.labels[j]+' for '+call.methodName);
}
}
}
};
function _logDataEntry(logText){
if(this.debug){
this.debugLog.push(logText);
}
};
function _getCallLog(useHtml){
var lineBreak=(useHtml?"<br />":"\n");
var space=(useHtml?"&nbsp;":" ");
var logText=formatLog(this.debugLog,useHtml)+(this.debug?"":"-Not in debug mode.");
logText+=lineBreak+'Callback Log:'+lineBreak;
for(var index in this.callsIssued){
logText+=space+this.callsIssued[index].toString(useHtml)+lineBreak;
}
return logText;
};
function _displayCallLog(){
var debugWin=null;
var winName='callMgrDebugLog'+Math.random().toString();
if(this.debug==true){
var optionsList="width=550,height=600,status=no,resizable=yes,scrollbars=yes";
var style="\"font-family:monospace;background-color:#222222;color:lime;font-size:12px;\"";
try{
debugWin=window.open("",winName,optionsList);
debugWin.document.write("<html><body style="+style+">");
debugWin.document.write(this.getCallLog(true));
debugWin.document.write("</body></html>");
debugWin.document.title="HP Debugger";
debugWin.document.close();
}catch(err){
if(debugWin){
try{debugWin.close();}catch(e){}
}
alert(this.getCallLog(false));
}
}
};
CallManager.prototype.toString=function(){return "Call Manager 1.0";}
CallManager.prototype.logEntry=_logDataEntry;
CallManager.prototype.getCallLog=_getCallLog;
CallManager.prototype.displayCallLog=_displayCallLog;
CallManager.prototype.getErrorString=_getErrorString;
CallManager.prototype.getErrorStrings=_getErrorStrings;
CallManager.prototype.getCallbackResultByName=_getCallbackResultByName;
CallManager.prototype.getCallbackResultByIndex=_getCallbackResultByIndex;
CallManager.prototype.getCallbackErrorCodes=_getCallbackErrorCodes;
CallManager.prototype.getTotalFailures=_getTotalFailures;
CallManager.prototype.formatErrorLabels=_formatErrorLabels;
CallManager.prototype.makeCall=_makeCall;
CallManager.prototype.addCallback=_addCallback;
CallManager.prototype.addQueuedCall=_addQueuedCall;
CallManager.prototype.loadQueue=_loadQueue;
CallManager.prototype.percentComplete=_percentComplete;
CallManager.prototype.reportPercent=_reportPercent;
CallManager.prototype.assertLoaded=_assertLoaded;
CallManager.prototype.cancelCalls=_cancelCalls;
CallManager.prototype.reset=_resetCalls;
function Callback(call,args,labels,okErrors,callback,pendingCallback,encName,encId,master){
var me=this;
this.master=master;
this.enableTimeout=false;
this.maxLoadTime=150000;
this.callState=CallState.None;
this.call=call;
this.args=(isArray(args)?args:new Array());
this.okErrors=(isArray(okErrors)?okErrors:new Array());
this.callback=callback;
this.pendingCallback=pendingCallback;
this.getFresh=false;
this.labels=(isArray(labels)?labels:new Array());
this.enclosureName=encName;
this.enclosureId=encId;
this.received=false;
this.completed=false;
this.allowError=false;
this.methodName="";
this.errorNumber="";
this.errorType="";
this.errorString="";
this.result=null;
this.timerId=0;
this.submitNow=function(){
if(typeof(this.call)=='function'||typeof(this.call)=='object'){
var args="";
for(var i=0;i<this.args.length;i++){
args+="this.args["+i+"],";
}
if(this.enableTimeout){
this.timerId=window.setTimeout(function(){me.timedOut()},this.maxLoadTime);
}
if(typeof(this.pendingCallback)=='function'){
this.pendingCallback();
}
this.callState=CallState.Pending;
try{
eval('this.call('+args+'me.resultHandler,'+this.getFresh+');');
}catch(err){
this.errorString=err.message;
this.setState(CallState.Error,ErrorCode.Unexpected);
}
}else{
this.setState(CallState.Error,ErrorCode.InvalidMethod);
}
}
this.timedOut=function(){
me.callState=CallState.TimedOut;
me.errorNumber=ErrorCode.TimedOut;
me.notifyCaller(null);
}
this.setState=function(callstate,errorCode){
if(callstate!=CallState.Pending){
window.clearTimeout(this.timerId);
}
this.callState=callstate;
switch(this.callState){
case CallState.Error:
this.errorNumber=errorCode;
this.errorType=ErrorType.FormManager;
this.notifyCaller(null);
break;
case CallState.Failed:
var errorInfo=top.getCallAnalyzer().extractErrorInfo(this.result);
this.errorNumber=errorInfo.errorNumber;
this.errorType=errorInfo.errorType;
this.rawString=errorInfo.rawString;
this.appendString=errorInfo.appendString;
if(errorInfo.errorString!=""){
this.errorString=top.getCallAnalyzer().getErrorString(errorInfo);
}
break;
}
this.validateError();
}
this.validateError=function(){
for(var i=0;i<this.okErrors.length;i++){
if(this.errorNumber==this.okErrors[i]){
this.allowError=true;
break;
}
}
}
this.resultHandler=function(result,methodName){
if(me.received==false){
if(typeof(me.master.logEntry)=='function'){
me.master.logEntry(methodName+" received!");
}
me.methodName=methodName;
me.result=result;
if(me.callState!=CallState.Cancel){
me.setState(me.isExpectedResult(result)?'Success':'Failed');
}
me.received=true;
me.notifyCaller(result);
}
}
this.isExpectedResult=function(result){
return(getCallSuccess(result));
}
this.notifyCaller=function(result){
this.completed=true;
if(this.callState!=CallState.Cancel){
if(typeof(this.callback)=='function'){
this.callback(result);
}
if(this.master&&typeof(this.master.assertLoaded)=='function'){
this.master.assertLoaded();
}
}
}
this.cancel=function(){
this.callState=CallState.Cancel;
}
this.getResult=function(xpath,nodeOnly){
if(existsNonNull(xpath)){
return(getElementValueXpath(this.result,xpath,assertFalse(nodeOnly)));
}else{
return this.result;
}
}
this.logEntry=function(logText){
if(typeof(this.master.logEntry)=='function'){
this.master.logEntry("ALERT  "+logText);
}
}
this.toString=function(useHtml){
var space=(useHtml?'&nbsp;&nbsp;':'  ');
var lineBreak=(useHtml?'<br />':'\n');
var style="\"font-family:monospace;background-color:black;color:lime;"+
"font-size:12px;border:1px solid lime;width:100%;padding:2px;\"";
var result="Null";
try{
if(typeof(this.result)=='boolean'){
result=this.result;
}else{
result=this.result.xml;
}
}catch(e){};
return "Callback Class - owner:"+this.enclosureName+space+"method["+this.methodName+
"]"+lineBreak+space+"state:"+this.callState+space+"received:"+this.received+space+
"completed:"+this.completed+(this.errorNumber==""?"":space+"error:"+
this.errorNumber+space)+(this.allowError?"(ignored)":"")+lineBreak+
(useHtml?"<textarea rows='20' style="+style+">"+result+"</textarea><br />":"");
}
};
function QueuedCall(call,args,labels,okErrors,callback,pendingCallback,encName,encId){
this.call=call;
this.args=args;
this.labels=labels;
this.okErrors=okErrors;
this.callback=callback;
this.pendingCallback=pendingCallback;
this.enclosureName=encName;
this.enclosureId=encId;
this.loaded=false;
};
function formatLog(debugLog,useHtml){
var listText="";
var lineBreak=(useHtml?"<br />":"\n");
var space=(useHtml?"&nbsp;":" ");
for(var i=0;i<debugLog.length;i++){
listText+=debugLog[i]+lineBreak+space;
}
return listText;
};
