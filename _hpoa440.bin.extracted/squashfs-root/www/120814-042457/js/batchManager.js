/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function BatchManager(finalCallback,isWizard,errorContainerId,bodyContainerId,waitContainerId){
var me=this;
this.finalCallback=finalCallback;
this.isWizard=parseBool(isWizard);
this.displayManager=new DisplayManager(bodyContainerId,waitContainerId,errorContainerId);
this.batches=new Array();
this.completed=false;
this.success=false;
this.isMasterReportAgent=false;
this.formattedReport=true;
this.debugLog=[this.toString()+": Debug Log"];
this.debug=false;
if(typeof(errorContainerId)!='undefined'){
this.isMasterReportAgent=true;
}
this.notifyBatchCompleted=function(batchName,success){
me.logEntry('Notified by batch ['+batchName+']  success='+success);
var failedCount=0;
var completedCount=0;
for(var index in me.batches){
var batch=me.batches[index];
failedCount+=(batch.success==true?0:1);
completedCount+=(batch.completed==true?1:0);
}
if(completedCount==me.getTotalBatches()){
me.completed=true;
me.success=(failedCount==0);
me.finishUp();
}
}
this.finishUp=function(){
this.logEntry('Done. Success='+this.success);
if(!this.success){
this.displayManager.showMainScreen();
if(this.isMasterReportAgent){
this.displayReport();
}
}else if(!this.isWizard){
this.displayManager.showMainScreen();
}
if(typeof(this.finalCallback)=='function'){
this.finalCallback(this.success);
}
if(this.debug){
this.displayDebugLog();
}
}
};
function _addBatch(batchName,enclosureName){
this.batches.push(new Batch(batchName,enclosureName,this));
this.logEntry('Added batch ['+batchName+']');
var batch=(this.batches[this.batches.length-1]);
batch.debug=this.debug;
return batch;
};
function _removeBatch(indexOrName){
for(var index in this.batches){
var batch=this.batches[index];
if(index==indexOrName||batch.name==indexOrName){
this.logEntry('Removing batch ['+indexOrName+']');
this.batches.splice(index,1);
return true;
}
}
return false;
};
function _getBatch(indexOrName){
for(var index in this.batches){
var batch=this.batches[index];
if(index==indexOrName||batch.name==indexOrName){
return batch;
}
}
return null;
};
function _getTotalBatches(){
return(this.batches.length);
};
function _runBatches(){
this.displayManager.showWaitScreen();
this.displayManager.hideErrors();
this.logEntry('Starting '+this.getTotalBatches()+' batch(es).');
for(var index in this.batches){
this.batches[index].runBatch();
}
};
function _displayReport(){
var report='';
for(var index in this.batches){
var batch=this.batches[index];
if(this.formattedReport==true){
report+=batch.getReportString()+'<br />';
}else{
report+=batch.getErrorList(true);
}
}
this.logEntry('Displaying report.');
this.displayManager.showErrors(report);
}
function _createBatchWaitContainer(waitText,waitDesc){
this.displayManager.createWaitContainer(waitText,waitDesc);
this.logEntry('Wait container added.');
};
function _logEntry(logText){
if(this.debug){this.debugLog.push(logText);}
};
function _displayBatchDebugLog(){
var debugWin=null;
if(this.debug==true){
var optionsList="width=550,height=600,status=no,resizable=yes,scrollbars=yes";
var style="\"font-family:monospace;background-color:#222222;color:lime;font-size:12px;\"";
try{
debugWin=window.open("","batchDebugLog",optionsList);
debugWin.document.write("<html><body style="+style+">");
debugWin.document.write(this.getDebugLog(true));
debugWin.document.write("</body></html>");
debugWin.document.title="HP Debugger";
debugWin.document.close();
}catch(err){
if(debugWin){
try{debugWin.close();}catch(e){}
}
alert(this.getDebugLog(false));
}
}
};
function _getBatchMgrLog(useHtml){
var lineBreak=(useHtml?"<br />":"\n");
var space=(useHtml?"&nbsp;":" ");
var logText=formatLog(this.debugLog,useHtml)+(this.debug?"":"-Not in debug mode.");
logText+=lineBreak;
for(var index in this.batches){
logText+=this.batches[index].getDebugLog(useHtml)+lineBreak;
}
return logText;
};
BatchManager.prototype.toString=function(){return "Batch Manager Class 1.0";}
BatchManager.prototype.createWaitContainer=_createBatchWaitContainer;
BatchManager.prototype.getTotalBatches=_getTotalBatches;
BatchManager.prototype.runBatches=_runBatches;
BatchManager.prototype.addBatch=_addBatch;
BatchManager.prototype.removeBatch=_removeBatch;
BatchManager.prototype.getBatch=_getBatch;
BatchManager.prototype.displayReport=_displayReport;
BatchManager.prototype.displayDebugLog=_displayBatchDebugLog;
BatchManager.prototype.logEntry=_logEntry;
BatchManager.prototype.getDebugLog=_getBatchMgrLog;
function Batch(batchName,enclosureName,owner){
var me=this;
this.name=batchName;
this.owner=owner;
this.enclosureName=(enclosureName?enclosureName:'');
this.currentTrans=0;
this.transactions=new Array();
this.completed=false;
this.success=false;
this.debugLog=[this.toString()+': Debug Log',
'Enclosure name: '+this.enclosureName,
'Batch name: '+this.name];
this.debug=false;
this.notifyTransactionCompleted=function(transName,success){
me.logEntry('Notified by transaction ['+transName+']  success='+success);
var forceFail=false;
var failedCount=0;
var completedCount=0;
for(var index in me.transactions){
var trans=me.transactions[index];
if(trans.name==transName){
forceFail=(trans.success==false&&trans.mustSucceed==true);
}
failedCount+=(trans.success==true?0:1);
completedCount+=(trans.completed==true?1:0);
}
if(completedCount==me.getTotalTransactions()||forceFail==true){
me.completed=true;
me.success=(failedCount==0);
me.logEntry('Done. Success='+me.success+
(me.success?'':' Force-Fail='+forceFail));
me.finishUp();
}else{
me.runNextTransaction();
}
}
this.runBatch=function(){
this.runFirstTransaction();
}
this.finishUp=function(){
if(typeof(this.owner.notifyBatchCompleted)=='function'){
this.owner.notifyBatchCompleted(this.name,this.success);
}
}
};
function _addTransaction(transName,formManager,mustSucceed,fresh){
if(this.owner.formattedReport==false){
if(this.enclosureName!=""){
formManager.setCurrentEnclosureName(this.enclosureName,null);
}
}
this.transactions.push(new Transaction(transName,formManager,mustSucceed,fresh,this));
this.logEntry('Added transaction ['+transName+']');
var trans=(this.transactions[this.transactions.length-1]);
trans.debug=this.debug;
return trans;
};
function _getTransaction(indexOrName){
for(var index in this.transactions){
var trans=this.transactions[index];
if(index==indexOrName||trans.name==indexOrName){
return trans;
}
}
return null;
};
function _runFirstTransaction(){
if(this.getTotalTransactions()>0&&this.currentTrans==0){
this.logEntry('Running first transaction ['+this.transactions[this.currentTrans].name+']');
this.transactions[this.currentTrans++].run();
}
};
function _runNextTransaction(){
if(this.currentTrans<this.getTotalTransactions()){
this.logEntry('Running next transaction ['+this.transactions[this.currentTrans].name+']');
this.transactions[this.currentTrans++].run();
}
};
function _getTotalTransactions(){
return(this.transactions.length);
};
function _getBatchReportString(){
var report='';
if(this.enclosureName!=null&&this.enclosureName!=''){
report='<span style="color:black;font-weight:bold;font-size:11px;">'+
this.enclosureName+'</span><br />';
}
for(var index in this.transactions){
report+=this.transactions[index].getReportString();
}
return report;
};
function _getBatchErrorList(useHtml){
var report='';
var lineBrk=(useHtml?"<br />":"\n");
for(var index in this.transactions){
var thisList=this.transactions[index].formMgr.getErrorList(useHtml);
if(thisList!=""){
report+=this.transactions[index].formMgr.getErrorList(useHtml)+lineBrk;
}
}
return report;
};
function _getBatchLog(useHtml){
var lineBreak=(useHtml?"<br />":"\n");
var space=(useHtml?"&nbsp;":" ");
var logText=formatLog(this.debugLog,useHtml)+(this.debug?"":"-Not in debug mode.");
logText+=lineBreak;
for(var index in this.transactions){
logText+=this.transactions[index].getDebugLog(useHtml)+lineBreak;
}
return logText;
};
Batch.prototype.toString=function(){return "Batch Class 1.0";}
Batch.prototype.addTransaction=_addTransaction;
Batch.prototype.getTransaction=_getTransaction;
Batch.prototype.runFirstTransaction=_runFirstTransaction;
Batch.prototype.runNextTransaction=_runNextTransaction;
Batch.prototype.getTotalTransactions=_getTotalTransactions;
Batch.prototype.getReportString=_getBatchReportString;
Batch.prototype.getErrorList=_getBatchErrorList;
Batch.prototype.getDebugLog=_getBatchLog;
Batch.prototype.logEntry=_logEntry;
function Transaction(transName,formManager,mustSucceed,fresh,owner){
var me=this;
this.name=transName;
this.formMgr=formManager;
this.mustSucceed=parseBool(mustSucceed);
this.owner=owner;
this.completed=false;
this.success=false;
this.debug=false;
this.debugLog=[this.toString()+': Debug Log',
'Transaction name: '+this.name,
'Awaiting start...'];
this.resultHandler=function(success){
me.completed=true;
me.success=success;
me.logEntry('Done. Success='+success);
me.finishUp();
}
this.finishUp=function(){
if(typeof(this.owner.notifyTransactionCompleted)=='function'){
this.owner.notifyTransactionCompleted(this.name,this.success);
}
}
this.formMgr.setLoadedCallback(this.resultHandler);
this.formMgr.startTransactionBatch(fresh);
};
function _run(){
this.formMgr.endBatch();
this.logEntry('Started.  Must succeed='+this.mustSucceed);
};
function _getTotalErrors(){
return(this.completed==false?-1:this.formMgr.callManager.getTotalFailures());
};
function _getTransReportString(){
var report='';
if(this.completed==true){
if(this.formMgr.callManager.getTotalFailures()==0){
report+='<img src="/120814-042457/images/icon_status_normal.gif" '+
'style="border:0px;margin:3px 0px -2px 3px;" alt="" />';
report+='<span style="font-weight:normal;color:black;padding-left:3px;">'+this.name+'</span><br />';
}else{
if(this.mustSucceed==true){
report+='<span style="color:#CC0000;padding-left:3px;display:block;">'+this.formMgr.getErrorList(true)+'</span>';
}else{
report+='<img src="/120814-042457/images/icon_status_critical.gif" '+
'style="border:0px;margin:3px 0px -2px 3px;" alt="" />';
report+='<span style="font-weight:normal;color:black;padding-left:3px;">'+this.name+'</span><br />';
report+='<span style="color:#CC0000;padding-left:25px;display:block;">'+
this.formMgr.getErrorList(true)+'</span>';
}
}
}
return report;
};
function _getTransLog(useHtml){
var lineBreak=(useHtml?"<br />":"\n");
var space=(useHtml?"&nbsp;":" ");
var logText=formatLog(this.debugLog,useHtml)+(this.debug?"":"-Not in debug mode.");
return logText;
};
Transaction.prototype.toString=function(){return "Transaction Class 1.0";}
Transaction.prototype.run=_run;
Transaction.prototype.getTotalErrors=_getTotalErrors;
Transaction.prototype.getReportString=_getTransReportString;
Transaction.prototype.getDebugLog=_getTransLog;
Transaction.prototype.logEntry=_logEntry;
