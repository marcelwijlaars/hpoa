/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var ourProgressBarManager=new ProgressBarManager();
var ourDisplayManager=new DisplayManager('stepInnerContent','waitContainer','uploadErrorDisplay');
var timerSeconds=90;
function getFirmwareMgr(){
return getWizardTop().getFwUpdateManager();
};
function initFwWelcome(contentLocation){
var titleKey=getElementValueXpath(getWizardTop().getStepsDocument(),"//wizardTitle");
var processor=new XsltProcessor(contentLocation);
processor.addParameter('title',top.getString(titleKey));
document.getElementById('stepContent').innerHTML=processor.getOutput();
};
function initFwSource(contentLocation){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('oaUrl',removeTrailingSlash(getServiceUrl('',true)));
processor.addParameter("force",getFirmwareMgr().getProperty("ForceDowngradeOption"));
processor.addParameter("source",getFirmwareMgr().getProperty("FirmwareSourceLocation"));
processor.addParameter("type",getFirmwareMgr().getProperty("FirmwareSourceType"));
document.getElementById('stepContent').innerHTML=processor.getOutput();
if(getFirmwareMgr().getProperty("FirmwareSourceToken")!=""){
toggleButtonEnabled("nextButton",true);
}
};
function uploadFirmware(){
ourDisplayManager.clearErrorContainers();
ourInputValidator=new InputValidator("validate-upload","uploadErrorDisplay",true);
if(!ourInputValidator.allInputsValidate()){
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
return;
}
if(getFirmwareMgr().getProperty("FirmwareSourceType")!=SourceTypes.None){
if(!confirm(top.getString("confirmReplaceImage"))){
return;
}
}
ourDisplayManager.hideStatusContainers();
setWizardButtonSetEnabled(false);
try{
document.getElementById('firmwareUploadForm').submit();
ourDisplayManager.createWaitContainer('Uploading file, please wait...');
ourDisplayManager.showWaitScreen();
}catch(e){
var errMsg=e.message;
if(e.number==-2147024891){
errMsg=top.getString('invalidFilename');
}
ourDisplayManager.showErrors(errMsg);
toggleButtonsEnabled(['nextButton',false,'cancelButton',true,'previousButton',true]);
}
return false;
};
function postFirmwareFrameLoaded(targetDocument){
var postBackMgr=new PostBackManager(targetDocument,"firmwareUploadForm","oaFileToken");
if(postBackMgr.getIsPostBack()){
if(postBackMgr.getSuccess()){
ourDisplayManager.showMainScreen();
var oaFileToken=postBackMgr.getResponseValue("oaFileToken");
if(oaFileToken!=''){
getFirmwareMgr().setFirmwareImage(oaFileToken,getInputValue("file"),SourceTypes.Upload);
toggleElementVisible("uploadSuccess",true);
setWizardButtonSetEnabled(true);
}else{
ourDisplayManager.showErrors(top.getString("noUploadedFileToken"));
getFirmwareMgr().setFirmwareImage("");
toggleButtonsEnabled(['nextButton',false,'cancelButton',true,'previousButton',true]);
}
}else{
ourDisplayManager.showErrors(postBackMgr.getErrorString());
ourDisplayManager.showMainScreen();
toggleButtonsEnabled(['nextButton',false,'cancelButton',true,'previousButton',true]);
}
}
};
function downloadFirmware(){
ourDisplayManager.clearErrorContainers();
ourInputValidator=new InputValidator("validate-url","urlErrorDisplay",true);
if(!ourInputValidator.allInputsValidate()){
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
return;
}
if(getFirmwareMgr().getProperty("FirmwareSourceType")!=SourceTypes.None){
if(!confirm(top.getString("confirmReplaceImage"))){
return;
}
}
ourDisplayManager.hideStatusContainers();
setWizardButtonSetEnabled(false);
getFirmwareMgr().setForceDowngrade(parseBool(getInputValue("chkForceDowngrade")));
var proxyLocal=top.getTopology().getProxyLocal();
var urlSource=getInputValue("fileUpdateUrl");
var formMgr=new FormManager(function(success){
if(success){
getFirmwareMgr().setFirmwareImage(formMgr.getDataByCallName("downloadFile",null,"//hpoa:oaFileToken"),urlSource,SourceTypes.Download);
toggleElementVisible("downloadSuccess",true);
setWizardButtonSetEnabled(true);
}else{
getFirmwareMgr().setFirmwareImage("");
toggleButtonsEnabled(['nextButton',false,'cancelButton',true,'previousButton',true]);
}
},false,'urlErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer("Downloading file, please wait...");
formMgr.makeCall(proxyLocal.downloadFile,[FIRMWARE_IMAGE(),urlSource]);
};
function confirmDowngradeChoice(){
if(getFirmwareMgr().getProperty("ForceDowngradeOption")==true){
if(!confirm(top.getString('confirmForceDowngrade'))){
return;
}
}
doNextStep();
}
function initPerformUpdate(contentLocation){
getFirmwareMgr().loadQueue(ourProgressBarManager);
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
document.getElementById('stepContent').innerHTML=processor.getOutput();
ourProgressBarManager.init();
getFirmwareMgr().beginFirmwareUpdates();
};
function updateComplete(){
ourDisplayManager.createWaitContainer(top.getString("updatesComplete"));
setInnerHTML('waitDescriptionContainer',"<span id='lblSeconds'>"+timerSeconds+"</span> "+top.getString("secondsRemaining"));
ourDisplayManager.showWaitScreen();
window.setTimeout("updateCountdown()",1000);
};
function updateCountdown(){
if(timerSeconds>1){
setInnerHTML('lblSeconds',--timerSeconds);
window.setTimeout("updateCountdown()",1000);
}else{
resetComplete();
}
};
function resetComplete(){
setInnerHTML("updateText",top.getString("clickNextToViewSummary"));
ourDisplayManager.showMainScreen();
toggleButtonEnabled("nextButton",true);
};
function initFwFinish(contentLocation){
ourDisplayManager.setBodyContainer("stepContent");
ourDisplayManager.createLoadContainer(top.getString("refreshingTopology"));
top.getTopology().setTopologyMode(TopologyModes.DisplayOn);
top.getTopology().clearCache();
top.getTopology().getProxyLocal().setIsConnected(true);
top.getTopology().getTopology(function(result,callName,changed){
if(getCallSuccess(result)){
window.setTimeout("drawUpdateSummary('"+contentLocation+"')",10000);
}else{
window.setTimeout("initFwFinish('"+contentLocation+"')",10000);
}
},true,null,30000);
};
function drawUpdateSummary(contentLocation){
var hpems=top.getTopology().getProxies();
var infoList=getFirmwareMgr().getMessages("*");
for(var i=0;i<hpems.length;i++){
hpems[i].setIsWizardSelected(getElementValueXpath(infoList,"//updateInfo[@uuid='"+hpems[i].getUuid()+"']",true)!=null);
}
var processor=new XsltProcessor(contentLocation);
processor.addParameter("enclosureList",getWizardTop().getSelectedEnclosures());
processor.addParameter("updateInfoList",infoList);
processor.addParameter("flashTime",getFirmwareMgr().getProperty("FlashTime"));
processor.addParameter("requiresLogin",""+(top.getTopology().getProxyLocal().getIsAuthenticated()==false));
processor.addParameter("stringsDoc",top.getStringsDoc());
document.getElementById('stepContent').innerHTML=processor.getOutput();
reconcilePage();
reconcileEventHandlers();
};
function finishWizard(){
getFirmwareMgr().exitWizard(top.getTopology().getProxyLocal().getIsAuthenticated()==false);
};
function toggleButtonEnabled(id,enabled){
if(enabled==true){
ourButtonManager.enableButtonById(id);
}else{
ourButtonManager.disableButtonById(id);
}
}
function toggleButtonsEnabled(argsArray){
if(isArray(argsArray)&&argsArray.length>0&&argsArray.length%2==0){
for(var i=0;i<argsArray.length-1;i+=2){
toggleButtonEnabled(argsArray[i],argsArray[i+1]);
}
}
}
