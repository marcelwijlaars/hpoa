/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var dbgWin=false;
var wizardTop=window.parent;
var previousNavigateFunction;
var nextNavigateFunction;
var formMgr=null;
var ourInputValidator=null;
function getNextNavigateFunction(){
var nextLocationInput=document.getElementById('nextStepLink');
if(nextLocationInput){
return function(){
eval(nextLocationInput.value);
}
}
else{
return function(){}
}
}
function doNextStep(){
var nextNavigateFunction=getNextNavigateFunction();
nextNavigateFunction();
}
function stdSuccessCallback(success){
if(success){
doNextStep();
}
else{
setWizardButtonSetEnabled(true);
}
}
var useSoftValidation=false;
function inputIsValid(preserveDisplayedErrors){
if(!(preserveDisplayedErrors==true)){
var displayMgr=new DisplayManager();
displayMgr.clearErrorContainers();
}
if(ourInputValidator.allInputsValidate()){
return true;
}else{
ourInputValidator.updateMessages(true);
if(useSoftValidation==true){
if(confirm(top.getString('confirmForceSubmit'))){
return true;
}
}
ourInputValidator.autoFocus();
return false;
}
}
function getNextButton(){
return document.getElementById('nextButton');
}
function getCancelButton(){
return document.getElementById('cancelButton');
}
function getPreviousButton(){
return document.getElementById('previousButton');
}
function getSkipButton(){
return document.getElementById('skipButton');
}
function getStepInformation(stepNumber,stepsDocument){
var stepInfo=new Object();
var nodeList;
var xpathString="//steps/step[number="+stepNumber+"]";
nodeList=getElementValueXpath(stepsDocument,xpathString,true);
if(nodeList!=null){
for(var i=0;i<nodeList.childNodes.length;i++){
if(nodeList.childNodes[i].tagName=="eventListeners"){
var listeners=nodeList.childNodes[i];
stepInfo["eventListeners"]=new Array();
for(var j=0;j<listeners.childNodes.length;j++){
if(listeners.childNodes[j].nodeType==1){
stepInfo["eventListeners"].push(getListenerInformation(listeners.childNodes[j]));
}
}
}else if(nodeList.childNodes[i].childNodes.length==1){
stepInfo[nodeList.childNodes[i].tagName]=nodeList.childNodes[i].childNodes[0].nodeValue;
}
}
}
return stepInfo;
};
function getListenerInformation(node){
var listener=new Object();
for(var i=0;i<node.attributes.length;i++){
listener[node.attributes[i].nodeName]=node.attributes[i].nodeValue;
}
listener["events"]=new Array();
listener["params"]=new Array();
var nodes=node.childNodes;
for(var j=0;j<nodes.length;j++){
for(var k=0;k<nodes[j].childNodes.length;k++){
if(nodes[j].childNodes[k].nodeType==1){
var value=nodes[j].childNodes[k].firstChild.nodeValue;
switch(nodes[j].tagName){
case "events":
listener["events"].push(value);
break;
case "params":
listener["params"].push(value);
break;
}
}
}
}
listener.func=createStepsFunction(listener);
return listener;
};
function createStepsFunction(listener){
if(listener.body){
var params=(listener.params?listener.params:new Array());
var body=listener.body;
switch(params.length){
case 0:
return new Function(body);
case 1:
return new Function(params[0],body);
case 2:
return new Function(params[0],params[1],body);
case 3:
return new Function(params[0],params[1],params[2],body);
}
}
return null;
};
function initWelcome(contentLocation){
var processor=new XsltProcessor(contentLocation);
var enclosureStatus=top.getTopology().getProxyLocal().getEnclosureStatus();
var wizardComplete=getElementValueXpath(enclosureStatus,'//hpoa:wizardStatus');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('wizardComplete',wizardComplete);
document.getElementById('stepContent').innerHTML=processor.getOutput();
getNextButton().onclick=function(){setWizardFlagWelcome(doNextStep,false);}
getCancelButton().onclick=function(){setWizardFlagWelcome(exitWizard,true);}
}
function initFinish(contentLocation){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
var hpemLocal=top.getTopology().getProxyLocal();
processor.addParameter('oaSessionKey',(hpemLocal.getActiveFirmwareVersion()<2.00?hpemLocal.getSessionKey():""));
document.getElementById('stepContent').innerHTML=processor.getOutput();
var finishButton=document.getElementById('finishButton');
if(finishButton){
finishButton.onclick=function(){setWizardFlagWelcome(exitWizard,false);}
}
}
function setWizardFlagWelcome(successFunction,confirmIfExit){
var hpemLocal=top.getTopology().getProxyLocal();
var doNotShow=document.getElementById('doNotShow');
var complete=(doNotShow.checked?'WIZARD_SETUP_COMPLETE':'WIZARD_NOT_COMPLETED');
hpemLocal.setWizardComplete(complete);
try{
successFunction(confirmIfExit);
}catch(e){}
}
function fwVersionCallback(tagName,value,isLocal){
if(value!=""&&tagName.indexOf("fw")>-1){
var cell=document.getElementById(tagName);
if(cell){
if(cell.innerHTML!=value){
top.logEvent("FTSW: firmware version updated: current: "+cell.innerHTML+" new: "+value,null,1,5);
redrawEnclosureSelectTable();
}
}
}
}
function getEnclosureSelections(){
var selections=new Array();
var elems=document.getElementsByTagName("input");
for(var i=0;i<elems.length;i++){
if(elems[i].getAttribute("type")=="checkbox"){
if(elems[i].getAttribute("rowselector")){
top.logEvent("FTSW: "+elems[i].id+" checked: "+elems[i].checked,null,8,1);
selections.push({checked:elems[i].checked,id:elems[i].getAttribute("id")});
}
}
}
return selections;
}
function restoreEnclosureSelections(selections){
var elems=document.getElementsByTagName("input");
for(var index in selections){
var chkbox=document.getElementById(selections[index].id);
if(chkbox&&chkbox.disabled==false&&(chkbox.checked!=selections[index].checked)){
try{
top.logEvent("FTSW: updating enclosure selection for "+chkbox.id,null,1,2);
chkbox.checked=!chkbox.checked;
if(chkbox.checked){
chkbox.parentNode.parentNode.className="rowHighlight";
}else{
chkbox.parentNode.parentNode.removeAttribute("class");
}
}catch(e){}
}
}
}
function redrawEnclosureSelectTable(){
var encSelectContainer=document.getElementById('encSelectContainer');
if(encSelectContainer){
var selections=getEnclosureSelections();
var processor=new XsltProcessor('../Wizards/wizardForms/EnclosureSelect.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('maxConnectionsExceeded',top.getTopology().getMaxConnectionsExceeded());
processor.addParameter('allowFirmwareMismatch',(wizardTop.getWizardStepAttribute('allowFirmwareMismatch')=='true'));
processor.addParameter('allowPrimaryExclusion',(wizardTop.getWizardStepAttribute('allowPrimaryExclusion')=='true'));
encSelectContainer.innerHTML=processor.getOutput();
restoreEnclosureSelections(selections);
reconcilePage();
}
}
function initFipsPage(contentLocation){
var hpem=top.getTopology().getProxyLocal();
var formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('networkInfoDoc',hpem.getEnclosureNetworkInfo());
processor.addParameter('serviceUserAcl',hpem.getUserAccessLevel());
processor.addParameter('vcmMode',hpem.getOaVcmMode());
processor.addParameter('fwVersion',hpem.getActiveFirmwareVersion());
processor.addParameter('inWizard','true');
document.getElementById('stepContent').innerHTML=processor.getOutput();
reconcilePage();
},true,'','stepContent');
formMgr.startBatch(true,assertFalse(true));
formMgr.queueCall(hpem.getEnclosureNetworkInfo);
formMgr.endBatch();
getNextButton().onclick=setFipsMode;
}
function fipsRadioOnChange(fipsSelected){
var hpem=top.getTopology().getProxyLocal();
var fwVersion=hpem.getActiveFirmwareVersion();
if(fwVersion>=4.35){
return;
}
var controlElements=['password','passwordConfirm','passContainer'];
if(fipsSelected.value==OA_FIPS_MODE_OFF()){
for(var el in controlElements){
toggleFormEnabled(controlElements[el],false);
}
}
else{
for(var el in controlElements){
toggleFormEnabled(controlElements[el],true);
}
}
}
function setFipsMode(){
var hpemLocal=top.getTopology().getProxyLocal();
var fwVersion=hpemLocal.getActiveFirmwareVersion();
var newFipsMode=getOptionGroupValue("fipsMode");
if(hpemLocal.getProperty("FipsMode")==newFipsMode){
doNextStep();
return;
}
if(newFipsMode!=OA_FIPS_MODE_OFF()||fwVersion>=4.35){
var ourfipsInputValidator=new InputValidator(null,'fipsErrorDisplay',true);
if(!ourfipsInputValidator.allInputsValidate()){
ourfipsInputValidator.updateMessages(true);
ourfipsInputValidator.autoFocus();
return;
}
}
if(confirm(top.getString(newFipsMode+'-confirmation'))){
setWizardButtonSetEnabled(false);
var formMgr=new FormManager(stdSuccessCallback,true,'fipsErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('fipsModeWait'));
formMgr.makeCall(hpemLocal.setFipsMode,[newFipsMode,getInputValue('password')]);
}
}
function clearVcmMode(){
if(confirm(top.getString('clearVcConfirm'))){
var hpemLocal=top.getTopology().getProxyLocal();
setWizardButtonSetEnabled(false);
var formMgr=new FormManager(function(success){
if(success)
alert(top.getString('vcCleared'),AlertMsgTypes.Information);
top.mainPage.getPortalFrame().gotoStepNumber(1);
},true,'clearVcErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('vcClearWaitMsg'));
formMgr.makeCall(hpemLocal.clearOaVcmMode);
}
}
function initEncSelect(contentLocation){
var selections=getEnclosureSelections();
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('allowFirmwareMismatch',(wizardTop.getWizardStepAttribute('allowFirmwareMismatch')=='true'));
processor.addParameter('traditionalWizard',(wizardTop.getWizardAttribute('wizardTraditionalSteps')=='true'));
document.getElementById('stepContent').innerHTML=processor.getOutput();
ourButtonManager.disableButtonById('skipButton');
getNextButton().onclick=selectEnclosures;
redrawEnclosureSelectTable();
}
function selectEnclosures(){
setWizardButtonSetEnabled(false);
wizardTop.initServiceObjects(wizardTop.getWizardStepAttribute('allowPrimaryExclusion')=='true');
var encSelectTable=document.getElementById('enclosureSelectTable');
var inputCollection=encSelectTable.getElementsByTagName('input');
var hasUnAuthenticated=false;
for(var i=0;i<inputCollection.length;i++){
var local=inputCollection[i].getAttribute('local');
if(inputCollection[i].getAttribute('type')=='checkbox'&&inputCollection[i].checked){
if(!inputCollection[i].getAttribute('tableid')){
wizardTop.addEnclosure(inputCollection[i].getAttribute('encNum'));
if(inputCollection[i].getAttribute('authenticated')=='false'){
hasUnAuthenticated=true;
}
}
}
}
var hpems=top.getTopology().getSelectedProxies();
if(hpems.length==0){
alert(top.getString('mustSelectOneEnclosure'));
setWizardButtonSetEnabled(true);
return false;
}
if(!hasUnAuthenticated){
loadEnclosureCache();
}else{
ourInputValidator=new InputValidator(null,"errorDisplay",true);
if(!inputIsValid()){
setWizardButtonSetEnabled(true);
wizardTop.initServiceObjects();
return;
}
var batchMgr=new BatchManager(function(success){
if(success){
loadEnclosureCache();
}else{
for(var index in hpems){
if(hpems[index].getEnclosureType()==EnclosureTypes.Unknown){
hpems[index].setIsAuthenticated(false);
}
}
setWizardButtonSetEnabled(true);
var encSelectContainer=document.getElementById('encSelectContainer');
if(encSelectContainer){
var processor=new XsltProcessor('../Wizards/wizardForms/EnclosureSelect.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('allowFirmwareMismatch',(wizardTop.getWizardStepAttribute('allowFirmwareMismatch')=='true'));
processor.addParameter('allowPrimaryExclusion',(wizardTop.getWizardStepAttribute('allowPrimaryExclusion')=='true'));
encSelectContainer.innerHTML=processor.getOutput();
reconcilePage();
}
wizardTop.initServiceObjects();
}
},false,'errorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('signingLinkedEnc'));
batchMgr.formattedReport=false;
for(var i=0;i<hpems.length;i++){
if(!hpems[i].getIsAuthenticated()){
var batch=batchMgr.addBatch('Sign In Batch',hpems[i].getEnclosureName());
var trans1=batch.addTransaction("Sign In",new FormManager(),true);
if(hpems[i].getTwoFactorEnabled()==true){
trans1.formMgr.queueCall(hpems[i].isValidSession);
}else{
var passwordInput=document.getElementById('enc'+hpems[i].getEnclosureNumber()+'password');
var password=(passwordInput?passwordInput.value:'');
trans1.formMgr.queueCall(hpems[i].userLogIn,['Administrator',password]);
}
var trans2=batch.addTransaction("Get Enclosure Info",new FormManager(),false,true);
trans2.formMgr.queueCall(hpems[i].getEnclosureInfo);
}
}
batchMgr.runBatches();
}
}
function loadEnclosureCache(){
var hpems=top.getTopology().getSelectedProxies();
var objectsToLoad=0;
var objectsLoaded=0;
var allLoaded=true;
var minimumLoad=(getWizardTop().getWizardAttribute("wizardMinimumLoad")=='true');
var displayMgr=new DisplayManager('stepInnerContent','waitContainer');
var updateFunction=function(){
objectsLoaded++;
if(objectsLoaded==objectsToLoad){
var hpemsUpdate=top.getTopology().getSelectedProxies();
var noPermsList="";
for(var i=0;i<hpemsUpdate.length;i++){
if(!hpemsUpdate[i].getIsLoaded()){
hpemsUpdate[i].setIsLoaded(true);
if(hpemsUpdate[i].getUserOaPermission()!=true||hpemsUpdate[i].getUserAccessLevel()!='ADMINISTRATOR'){
hpemsUpdate[i].setIsWizardSelected(false);
noPermsList+=hpemsUpdate[i].getEnclosureName()+"\n";
}
}
}
if(noPermsList!=""){
top.mainPage.displayNotice(top.getString("invalidWizardPermissions")+"\n\n"+noPermsList,"Wizard Notice",AlertMsgTypes.Warning,null,10);
}
doNextStep();
}
}
var formMgr=new FormManager(function(success){
for(var i=0;i<hpems.length;i++){
if(hpems[i].getIsLoaded()==false){
objectsToLoad+=hpems[i].loadCache(updateFunction,minimumLoad);
}
}
},true,'','');
formMgr.startTransactionBatch(true);
for(var i=0;i<hpems.length;i++){
if(hpems[i].getIsLoaded()==false){
allLoaded=false;
formMgr.queueCall(hpems[i].registerForEvents);
}
}
if(allLoaded){
doNextStep();
}else{
formMgr.endBatch();
displayMgr.createWaitContainer(top.getString('loadingEncInfo')+' '+top.getString('ellipsis'));
displayMgr.showWaitScreen();
}
}
function initEncSettings(contentLocation){
var hpems=top.getTopology().getSelectedProxies();
var hpemLocal=top.getTopology().getProxyLocal();
formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('enclosureInfoDoc',hpemLocal.getEnclosureInfo());
processor.addParameter('networkInfoDoc',hpemLocal.getEnclosureNetworkInfo());
processor.addParameter('dateTimeDoc',formMgr.getDataByCallIndex(0));
processor.setSourceDocument(formMgr.getDataByCallIndex(1));
document.getElementById('stepContent').innerHTML=processor.getOutput();
for(var i=0;i<hpems.length;i++){
processor=new XsltProcessor('/120814-042457/Wizards/wizardForms/EnclosureInfo.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureInfoDoc',hpems[i].getEnclosureInfo());
processor.addParameter('enclosureNumber',hpems[i].getEnclosureNumber());
processor.addParameter('totalEnclosures',hpems.length);
document.getElementById('enc'+hpems[i].getEnclosureNumber()).innerHTML=processor.getOutput();
}
getNextButton().onclick=setEncSettings;
},true,'','stepContent');
formMgr.startBatch(true);
formMgr.queueCall(hpemLocal.getEnclosureTime);
formMgr.queueCall(hpemLocal.getTimeZones);
formMgr.queueCall(hpemLocal.getEnclosureNetworkInfo);
formMgr.endBatch();
}
function setEncSettings(){
var timeUseManual=document.getElementById('manualOrNtp_manual').checked;
var displayMgr=new DisplayManager();
displayMgr.clearErrorContainers();
ourInputValidator=new InputValidator('validate-rackname','rackSettingsErrorDisplay',true);
if(!inputIsValid()){return;}
var hpems=top.getTopology().getSelectedProxies();
var rackName=document.getElementById('rackName').value;
if(timeUseManual){
ourInputValidator.setNewInputGroup('validate-datetime','dateTimeErrorDisplay');
if(!inputIsValid()){return;}
var date=document.getElementById('date').value;
var time=document.getElementById('time').value;
var timeZone='';
if(document.getElementById('timeZone')!=null){
timeZone=document.getElementById('timeZone').value;
}
else{
var tz_list=document.getElementById('tz_list');
if(tz_list!=null){
timeZone=tz_list.options[tz_list.selectedIndex].value;
}
}
var dateTime=date+'T'+time+':00';
if(date.match(REGEX_DATE())==null){
displayMgr.setErrorContainer('dateTimeErrorDisplay');
displayMgr.showErrors(top.getString('invalidDateMessage'));
return;
}
if(time.match(REGEX_TIME())==null){
displayMgr.setErrorContainer('dateTimeErrorDisplay');
displayMgr.showErrors(top.getString('invalidTimeMessage'));
return;
}
}else{
var ntpServer1=document.getElementById('ntp1').value;
var ntpServer2=document.getElementById('ntp2').value;
var pollInterval=document.getElementById('pollInterval').value;
var timeZone='';
ourInputValidator.setNewInputGroup('validate-ntp','dateTimeErrorDisplay');
if(!inputIsValid()){return;}
if(ntpServer1!=''&&ntpServer2!=''){
if(ntpServer1==ntpServer2){
displayMgr.setErrorContainer('dateTimeErrorDisplay');
displayMgr.showErrors(top.getString('duplicateNtpMsg'));
return;
}
}
ntpServer2=(ntpServer2=='')?'0.0.0.0':ntpServer2;
if(document.getElementById('timeZone_ntp')!=null){
timeZone=document.getElementById('timeZone_ntp').value;
}
else{
var tz_list=document.getElementById('tz_list_ntp');
if(tz_list!=null){
timeZone=tz_list.options[tz_list.selectedIndex].value;
}
}
}
ourInputValidator.setNewInputGroup('validate-me','encSettingsErrorDisplay');
if(!inputIsValid()){return;}
setWizardButtonSetEnabled(false);
formMgr=new FormManager(stdSuccessCallback,true,'encSettingsErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('completingEnclosureSettings'));
formMgr.toggleDebugMode(dbgWin,dbgWin);
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
var encName=document.getElementById('encName:'+hpems[i].getEnclosureNumber()).value;
var assetTag=document.getElementById('assetTag:'+hpems[i].getEnclosureNumber()).value;
formMgr.setCurrentEnclosureName(hpems[i].getEnclosureName(),hpems[i].getEnclosureNumber());
if(hpems[i].getIsLocal()==true){
formMgr.queueCall(hpems[i].setRackName,[rackName],['rackNameLabel'],['200']);
}
if(timeUseManual){
formMgr.queueCall(hpems[i].setEnclosureTime,[dateTime],['dateLabel','timeLabel'],['220']);
formMgr.queueCall(hpems[i].setEnclosureTimeZone,[timeZone],['timeZoneLabel']);
formMgr.queueCall(hpems[i].setEnclosureName,[encName],['enclosureNameLabel'+hpems[i].getEnclosureNumber()]);
formMgr.queueCall(hpems[i].setEnclosureAssetTag,[assetTag],['assetTagLabel'+hpems[i].getEnclosureNumber()]);
formMgr.queueCall(hpems[i].setNetworkProtocol,[NET_PROTO_NTP(),false],[],['83','84']);
}
else{
if(hpems[i].getActiveFirmwareVersion()>=2.10){
formMgr.queueCall(hpems[i].configureNtp,[ntpServer1,ntpServer2,pollInterval],['','','']);
}
else{
formMgr.queueCall(hpems[i].setNtpPrimary,[ntpServer1],['ntpLabel1']);
formMgr.queueCall(hpems[i].setNtpSecondary,[ntpServer2],['ntpLabel2']);
}
formMgr.queueCall(hpems[i].setEnclosureTimeZone,[timeZone],['timeZoneLabel']);
formMgr.queueCall(hpems[i].setNetworkProtocol,[NET_PROTO_NTP(),true],[],['83','84']);
formMgr.queueCall(hpems[i].setEnclosureName,[encName],['enclosureNameLabel'+hpems[i].getEnclosureNumber()]);
formMgr.queueCall(hpems[i].setEnclosureAssetTag,[assetTag],['assetTagLabel'+hpems[i].getEnclosureNumber()]);
}
}
formMgr.endBatch();
}
function initConfigManagement(contentLocation){
var hpems=top.getTopology().getSelectedProxies();
var formMgr=new FormManager(function(success){
setWizardButtonSetEnabled(true);
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
var hpem=top.getTopology().getProxyLocal();
processor.addParameter('oaSessionKey',(hpem.getActiveFirmwareVersion()<2.00?hpem.getSessionKey():""));
document.getElementById('stepContent').innerHTML=ipv6UrlFix(processor.getOutput());
transformUsbConfigForm(hpem.getEnclosureNumber());
reconcilePage();
getNextButton().onclick=doNextStep;
},false,'','stepContent');
setWizardButtonSetEnabled(false);
formMgr.startBatch(true,true);
for(var i=0;i<hpems.length;i++){
var bayNum=hpems[i].getOaBayNumber('ACTIVE');
formMgr.queueCall(hpems[i].getOaMediaDeviceArray,[bayNum]);
formMgr.queueCall(hpems[i].getUsbMediaConfigScripts);
}
formMgr.endBatch();
}
function transformUsbConfigForm(encNum){
var hpem=top.getTopology().getProxy(encNum);
if(hpem!=null){
var processor=new XsltProcessor('../Forms/UsbConfigForm.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('isWizard','true');
processor.addParameter('usbConfigScriptDoc',hpem.getUsbMediaConfigScripts());
processor.addParameter('oaMediaDeviceDoc',hpem.getOaMediaDeviceDOM());
processor.addParameter('usbConfigSupported',(hpem.getActiveFirmwareVersion()>=2.30));
document.getElementById('usbFormContainer').innerHTML=processor.getOutput();
setTimeout('reconcilePage();',200);
}
}
function submitConfigScript(){
ourInputValidator=new InputValidator('validate-upload-script','uploadErrorDisplay',true);
if(!inputIsValid()){return false;}
var displayMgr=new DisplayManager('stepInnerContent','waitContainer','uploadErrorDisplay');
var selectBox=document.getElementById('selectedEnclosure');
var hpem=null;
if(selectBox){
var encNum=selectBox.options[selectBox.selectedIndex].getAttribute('encNum');
hpem=top.getTopology().getProxy(encNum);
}else{
hpem=top.getTopology().getProxyLocal();
}
if(hpem!=null){
hpem.setProperty("ConfigScriptInProgress",true);
top.getTopology().setSelectedEnclosureNumber(hpem.getEnclosureNumber());
}
try{
document.getElementById('scriptUploadForm').submit();
displayMgr.createWaitContainer(top.getString('completingScriptUploadExec'));
displayMgr.showWaitScreen();
}catch(e){
var errMsg=e.message;
if(e.number==-2147024891){
errMsg=top.getString('invalidFilename');
}
displayMgr.showErrors(errMsg);
hpem.setProperty("ConfigScriptInProgress",false);
}
return false;
}
function postFrameLoaded(targetDocument){
var postBackMgr=new PostBackManager(targetDocument,"scriptUploadForm","scriptLog");
if(postBackMgr.getIsPostBack()){
var selectBox=document.getElementById('selectedEnclosure');
var hpem=null;
if(selectBox){
var encNum=selectBox.options[selectBox.selectedIndex].getAttribute('encNum');
hpem=top.getTopology().getProxy(encNum);
}else{
hpem=top.getTopology().getProxyLocal();
}
if(hpem!=null){
hpem.setProperty("ConfigScriptInProgress",false);
}
var displayMgr=new DisplayManager('stepInnerContent','waitContainer','uploadErrorDisplay');
displayMgr.showMainScreen();
if(postBackMgr.getSuccess()){
displayMgr.openLogWindow(postBackMgr.getResponseValue('scriptLog'),top.getString('configurationResults'),false);
if(browserDOM7011==true){
window.setTimeout(function(){initConfigManagement('/120814-042457/Wizards/SetupContent_ManageConfig.xsl');},500);
}
}else{
displayMgr.showErrors(postBackMgr.getErrorString());
}
}
}
function downloadConfigScript(){
ourInputValidator=new InputValidator('validate-download-script','downloadErrorDisplay',true);
if(!inputIsValid()){return false;}
var url=document.getElementById('configUrl').value;
var selectBox=document.getElementById('selectedEnclosure');
var encNum=null;
var hpem=null;
if(selectBox){
var encNum=selectBox.options[selectBox.selectedIndex].getAttribute('encNum');
hpem=top.getTopology().getProxy(encNum);
}else{
hpem=top.getTopology().getProxyLocal();
}
if(hpem){
hpem.setProperty("ConfigScriptInProgress",true);
top.getTopology().setSelectedEnclosureNumber(hpem.getEnclosureNumber());
formMgr=new FormManager(function(success){
hpem.setProperty("ConfigScriptInProgress",false);
if(success){
var resultLog=formMgr.getDataByCallIndex(0,'//hpoa:scriptLog');
formMgr.displayManager.openLogWindow(resultLog,top.getString('configurationResults'),false);
}
},false,'downloadErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('completingScriptDownloadExec'));
formMgr.makeCall(hpem.downloadConfigScript,[url]);
}else{
displayContentFailed('downloadErrorDisplay',[top.getString('noOnboardAdmin')]);
}
return false;
}
function executeScriptFromUsb(){
var selectBox=document.getElementById('selectedEnclosure');
var usbFileList=document.getElementById('usbFileList');
var url=usbFileList.options[usbFileList.selectedIndex].value;
var encNum=null;
var hpem=null;
if(selectBox){
var encNum=selectBox.options[selectBox.selectedIndex].getAttribute('encNum');
hpem=top.getTopology().getProxy(encNum);
}else{
hpem=top.getTopology().getProxyLocal();
}
if(hpem){
hpem.setProperty("ConfigScriptInProgress",true);
top.getTopology().setSelectedEnclosureNumber(hpem.getEnclosureNumber());
formMgr=new FormManager(function(success){
hpem.setProperty("ConfigScriptInProgress",false);
if(success){
var resultLog=formMgr.getDataByCallIndex(0,'//hpoa:scriptLog');
formMgr.displayManager.openLogWindow(resultLog,top.getString('configurationResults'),false);
}
},false,'downloadErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('completingScriptDownloadExec'));
formMgr.makeCall(hpem.downloadConfigScript,[url]);
}else{
displayContentFailed('downloadErrorDisplay',[top.getString('noOnboardAdmin')]);
}
return false;
}
function initAdminAccountSetup(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('enclosureInfoDoc',hpemLocal.getEnclosureInfo());
processor.addParameter('userInfoDoc',hpemLocal.getUserInfo('Administrator',null,false));
processor.addParameter('lcdStatusDoc',hpemLocal.getLcdStatus());
processor.addParameter('enclosureNetworkInfoDoc',hpemLocal.getEnclosureNetworkInfo());
processor.addParameter('lcdInfoDoc',hpemLocal.getLcdInfo());
processor.addParameter('isTower',hpemLocal.getIsTower()+"");
processor.addParameter('numDeviceBays',hpemLocal.getNumBlades());
processor.addParameter('numIoBays',hpemLocal.getNumTrays());
processor.addParameter('passwordSettingsDoc',hpemLocal.getPasswordSettings());
document.getElementById('stepContent').innerHTML=processor.getOutput();
},false,'','stepContent');
formMgr.startBatch(true);
formMgr.queueCall(hpemLocal.getLcdStatus,[]);
formMgr.queueCall(hpemLocal.getPasswordSettings);
formMgr.queueCall(hpemLocal.getEnclosureNetworkInfo);
formMgr.endBatch();
getNextButton().onclick=setupAdminAccount;
}
function setupAdminAccount(){
ourInputValidator=new InputValidator(null,'adminErrorDisplay',true);
if(!inputIsValid()){return;}
var lcdPinEnabled=document.getElementById('enablePinProtection').checked;
var lcdPin=document.getElementById('lcdPin').value;
var alreadyEnabled=(document.getElementById('lcdPin').getAttribute('alreadyEnabled')=='true');
var skipPinSetting=(lcdPinEnabled&&alreadyEnabled&&lcdPin=='');
if(lcdPinEnabled&&!skipPinSetting){
ourInputValidator.setNewInputGroup('validate-pin');
if(!inputIsValid()){return;}
}
setWizardButtonSetEnabled(false);
var hpems=top.getTopology().getSelectedProxies();
var fullName=document.getElementById('fullName').value;
var contact=document.getElementById('contact').value;
var password=document.getElementById('password').value;
var adminAccountName='Administrator';
formMgr=new FormManager(stdSuccessCallback,true,'adminErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('completingAdminAcctSettings'));
formMgr.toggleDebugMode(dbgWin,dbgWin);
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
formMgr.setCurrentEnclosureName(hpems[i].getEnclosureName(),hpems[i].getEnclosureNumber());
formMgr.queueCall(hpems[i].setUserFullname,[adminAccountName,fullName],['lblFullName']);
formMgr.queueCall(hpems[i].setUserContact,[adminAccountName,contact],['lblContact']);
if(password!=''){
formMgr.queueCall(hpems[i].setUserPassword,[adminAccountName,password],['lblPassword']);
}
if(!skipPinSetting){
if(lcdPinEnabled){
formMgr.queueCall(hpems[i].setLcdProtectionPin,[lcdPin],['lblLcdPin']);
}else{
formMgr.queueCall(hpems[i].setLcdProtectionPin,[''],['lblLcdPin']);
}
}
}
formMgr.endBatch();
}
function initUserOverviewPage(contentLocation){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
var hpemLocal=top.getTopology().getProxyLocal();
processor.addParameter('usersDoc',hpemLocal.getUsersDOM());
processor.addParameter('enclosureInfoDoc',hpemLocal.getEnclosureInfo());
document.getElementById('stepContent').innerHTML=processor.getOutput();
getNextButton().onclick=getSkipButton().onclick;
initUserOverview(startEditUser,startAddUser,deleteUsers);
}
function startAddUser(){
wizardTop.setParam('userAction','add');
var nextFunction=getNextNavigateFunction();
nextFunction();
}
function startEditUser(){
var username=getSelectedSecObjects()[0];
wizardTop.setParam('userAction','edit');
wizardTop.setParam('username',username);
var nextFunction=getNextNavigateFunction();
nextFunction();
}
function initUserSettings(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var hpems=top.getTopology().getSelectedProxies();
var formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
var userAction=wizardTop.getParam('userAction');
var username=wizardTop.getParam('username');
var userActionButton=null;
var userInfoDoc=null;
var linkHasMixed=false;
var currentEncType=hpemLocal.getEnclosureType();
for(var i=0;i<hpems.length;i++){
if(!hpems[i].getIsLocal()){
if((hpems[i].getEnclosureType()!=EnclosureTypes.Unknown)&&(hpems[i].getEnclosureType()!=currentEncType)){
linkHasMixed=true;
break;
}
}
}
if(userAction=='add'){
var xml=importModule('xml');
var userInfoDoc=xml.parseXML('<hpoa:bayPermissions xmlns:hpoa="hpoa.xsd" />');
addUserResults=new Object();
userActionButton=getHPButton('userActionButton',top.getString('addUser'),addUser,true);
}
else if(userAction=='edit'){
var userInfoDoc=hpemLocal.getUserInfo(username);
userActionButton=getHPButton('userActionButton',top.getString('updateUser'),updateUser,true);
}
processor.addParameter('action',userAction);
processor.addParameter('userInfoDoc',userInfoDoc);
processor.addParameter('username',getElementValueXpath(userInfoDoc,'//hpoa:userInfo/hpoa:username'));
processor.addParameter('linkHasMixed',""+linkHasMixed);
processor.addParameter('lcdInfoDoc',hpemLocal.getLcdInfo());
processor.addParameter('isTower',hpemLocal.getIsTower()+"");
processor.addParameter('numDeviceBays',hpemLocal.getNumBlades());
processor.addParameter('numIoBays',hpemLocal.getNumTrays());
processor.addParameter('passwordSettingsDoc',hpemLocal.getPasswordSettings());
if(!linkHasMixed){
processor.addParameter('enclosureType',hpemLocal.getEnclosureType());
}
if(hpemLocal.getCurrentServiceUser()==username){
processor.addParameter('isCurrentUser','true');
}
document.getElementById('stepContent').innerHTML=processor.getOutput();
loadCurrentSettings('1');
var previousButton=getPreviousButton();
previousButton.onclick=function(){
top.mainPage.getPortalFrame().gotoStepNumber(6);
};
var nextButtonWrapper=document.getElementById('nextButtonWrapper');
var wizardButtonSet=document.getElementById('wizardButtonSet');
wizardButtonSet.replaceChild(userActionButton,nextButtonWrapper);
var cancelButton=document.getElementById('cancelButton');
cancelButton.innerHTML=top.getString('skip');
cancelButton.onclick=function(){
if(confirm(top.getString('reallySkip'))){
top.mainPage.getPortalFrame().gotoStepNumber(7);
}
};
},false,'','stepContent');
formMgr.startBatch(true);
formMgr.queueCall(hpemLocal.getPasswordSettings);
formMgr.endBatch();
}
function deleteUsers(){
var secObjects=getSelectedSecObjects();
var hpemLocal=top.getTopology().getProxyLocal();
var triedAdministrator=false;
var triedSelf=false;
for(var i=secObjects.length-1;i>=0;i--){
if(secObjects[i]==ADMINISTRATOR()){
triedAdministrator=true;
secObjects.splice(i,1);
}else if(secObjects[i].toLowerCase()==hpemLocal.getCurrentServiceUser().toLowerCase()){
triedSelf=true;
secObjects.splice(i,1);
}
}
if(secObjects.length>0){
var confirmString=top.getString('reallyDeleteUsers');
var note='\n'+top.getString('note:')+' ';
if(triedAdministrator&&!triedSelf){
confirmString+=note+top.getString('adminAccountCannotBeDeleted');
}
else if(triedSelf&&!triedAdministrator){
confirmString+=note+top.getString('currentAccountCannotBeDeleted');
}
else{
confirmString+=note+top.getString('neitherAccountCanBeDeleted');
}
formMgr=new FormManager(function(){},false,'userErrorDisplay','stepInnerContent','waitContainer');
formMgr.toggleDebugMode(dbgWin,dbgWin);
formMgr.createWaitContainer(top.getString('completingUserSettings'));
if(confirm(confirmString)){
formMgr.startBatch();
for(var i=0;i<secObjects.length;i++){
formMgr.queueCall(hpemLocal.removeUser,[secObjects[i]]);
}
formMgr.endBatch();
}
}else{
containerCheckboxToggle('secObjectContainer',false);
userSelected();
if(triedSelf){
alert(top.getString('currentAccountCannotBeDeleted'));
}
}
}
function usersChangedHandler(result){
var hpemLocal=top.getTopology().getProxyLocal();
var processor=new XsltProcessor('../Templates/userOverviewTableExternal.xsl');
processor.addParameter('usersDoc',hpemLocal.getUsersDOM());
processor.addParameter('stringsDoc',top.getStringsDoc());
document.getElementById('userOverviewTableContainer').innerHTML=processor.getOutput();
initUserOverview(startEditUser,startAddUser,deleteUsers);
}
function addUser(){
ourInputValidator=new InputValidator(null,'userErrorDisplay',true);
if(!inputIsValid()){return;}
var addToAllCheck=document.getElementById('addToAllEnclosures');
var overwriteCheck=document.getElementById('overwriteExisting');
var addToAll=false;
var overwrite=false;
var hpems=null;
uInfo=getUserInfo('1',true);
if(addToAllCheck){
addToAll=addToAllCheck.checked;
}
if(overwriteCheck){
overwrite=overwriteCheck.checked;
}
if(addToAll){
hpems=top.getTopology().getSelectedProxies();
}else{
hpems=new Array();
hpems.push(top.getTopology().getProxyLocal());
}
var batchMgr=new BatchManager(function(success){
if(success){
top.mainPage.getPortalFrame().gotoStepNumber(6);
}else{
for(var b=0;b<batchMgr.getTotalBatches();b++){
var thisBatch=batchMgr.getBatch(b);
var thisTrans=thisBatch.getTransaction(0);
if(thisTrans.name=="Add New User"){
top.logEvent("Wizard: Add New User success: "+thisTrans.success,null,1,4);
addUserResults[thisBatch.name]=thisTrans.success;
}
}
}
},true,'userErrorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('completingUserSettings'));
for(var i=0;i<hpems.length;i++){
var batchName='NewUserEnc'+hpems[i].getUuid();
var batch=batchMgr.addBatch(batchName,hpems[i].getEnclosureName());
var trans1=batch.addTransaction('Add New User',new FormManager(),true);
if(addUserResults[batchName]!=true){
trans1.formMgr.queueCall(hpems[i].addUser,[uInfo['username'],uInfo['password']],['lblUsername','lblPwd'],(overwrite?['1']:[]));
}
var trans2=batch.addTransaction('Set User Information',new FormManager());
trans2.formMgr.queueCall(hpems[i].setUserFullname,[uInfo['username'],uInfo['fullName']],['lblFullname']);
trans2.formMgr.queueCall(hpems[i].setUserContact,[uInfo['username'],uInfo['contact']],['lblContact']);
trans2.formMgr.queueCall(hpems[i].setUserBayAcl,[uInfo['username'],uInfo['userBayAcl']]);
trans2.formMgr.queueCall(hpems[i].setUserPassword,[uInfo['username'],uInfo['password']],['lblPwd']);
if(uInfo['userEnabled']&&uInfo['userEnabled']==true){
trans2.formMgr.queueCall(hpems[i].enableUser,[uInfo['username']],[],['10','11']);
}else{
trans2.formMgr.queueCall(hpems[i].disableUser,[uInfo['username']],[],['10','11']);
}
var trans3=batch.addTransaction('Set User Permissions',new FormManager());
trans3.formMgr.queueCall(hpems[i].addUserBayAccess,[uInfo['username'],uInfo['permissionsToAdd']]);
if(uInfo['permissionsToRemove']!=null){
trans3.formMgr.queueCall(hpems[i].removeUserBayAccess,[uInfo['username'],uInfo['permissionsToRemove']],[],['316']);
}
}
batchMgr.runBatches();
}
function updateUser(callback){
ourInputValidator=new InputValidator(null,'userErrorDisplay',true);
if(!inputIsValid()){
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
return;
}
var addToAllCheck=document.getElementById('addToAllEnclosures');
var addToAll=false;
var hpems=null;
if(addToAllCheck){
addToAll=addToAllCheck.checked;
}
if(addToAll){
hpems=top.getTopology().getSelectedProxies();
}
else{
hpems=new Array();
hpems.push(top.getTopology().getProxyLocal());
}
if(typeof(callback)=='undefined'||callback==null){
var callback=function(success){
if(success){
top.mainPage.getPortalFrame().gotoStepNumber(6);
}
};
}
if(uInfo==null){
uInfo=getUserInfo('1');
}
formMgr=new FormManager(function(success){
if(success){
try{callback(success);}catch(e){}
}else{
uInfo=null;
}
},true,'userErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('completingUserSettings'));
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
if(hpems[i].getUserInfo(uInfo['username'],null,false)!=null){
}
formMgr.queueCall(hpems[i].setUserFullname,[uInfo['username'],uInfo['fullName']],['lblFullname']);
formMgr.queueCall(hpems[i].setUserContact,[uInfo['username'],uInfo['contact']],['lblContact']);
if(uInfo['userBayAcl']!=null){
formMgr.queueCall(hpems[i].setUserBayAcl,[uInfo['username'],uInfo['userBayAcl']]);
}
if(uInfo['permissionsToAdd']!=null){
formMgr.queueCall(hpems[i].addUserBayAccess,[uInfo['username'],uInfo['permissionsToAdd']]);
}
if(uInfo['permissionsToRemove']!=null){
formMgr.queueCall(hpems[i].removeUserBayAccess,[uInfo['username'],uInfo['permissionsToRemove']],[],['316']);
}
if(uInfo['userEnabled']!=null){
if(uInfo['userEnabled']==true){
formMgr.queueCall(hpems[i].enableUser,[uInfo['username']],[],['10','11']);
}
else{
formMgr.queueCall(hpems[i].disableUser,[uInfo['username']],[],['10','11']);
}
}
if(uInfo['password']!=''){
formMgr.queueCall(hpems[i].setUserPassword,[uInfo['username'],uInfo['password']],['lblPwd']);
}
}
formMgr.endBatch();
}
function initEBIPAIntro(contentLocation){
var setupType='Express';
wizardTop.setParam('EBIPAType','Express');
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('setupType',setupType);
document.getElementById('stepContent').innerHTML=processor.getOutput();
getNextButton().onclick=doNextStep;
}
function initEBIPASettings(contentLocation){
var hpems=top.getTopology().getSelectedProxies();
try{
var formMgrDev=new FormManager(function(success){
formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('ebipaInfoDoc',hpems[0].getEbipaInfoEx());
document.getElementById('stepContent').innerHTML=processor.getOutput();
transformDeviceList(hpems,[0,1,2]);
transformInterconnectList(hpems);
},true,'','stepContent');
formMgr.startBatch(true);
for(var i=0;i<hpems.length;i++){
formMgr.queueCall(hpems[i].getBladeMpInfoAll);
formMgr.queueCall(hpems[i].getVlanInfo);
}
formMgr.endBatch();
},true,'','stepContent');
formMgrDev.startBatch(true,true);
for(var i=0;i<hpems.length;i++){
formMgrDev.queueCall(hpems[i].getEbipaDevInfo);
}
formMgrDev.endBatch();
}catch(e){
displayContentFailed('stepContent',[e.message]);
}
}
function saveEbipaAllSettings(){
var confirmMsg=top.getString('saveEBIPASettingDesc');
confirmMsg+=top.getString('noteEbipaEnabledBaysAddr');
confirmMsg+=top.getString('areYouSureProceed');
var hpems=top.getTopology().getSelectedProxies();
if(!confirm(confirmMsg)){
setWizardButtonSetEnabled(true);
return;
}
setWizardButtonSetEnabled(false);
var batchMgr=new BatchManager(function(success){
setWizardButtonSetEnabled(true);
if(success){
var completeErrorText='';
for(var i=0;i<batchMgr.batches.length;i++){
var errorText='';
for(var j=0;j<batchMgr.batches[i].transactions.length;j++){
var formMgrTrans=batchMgr.batches[i].transactions[j].formMgr;
var result=formMgrTrans.getDataByCallIndex(0);
var processor=new XsltProcessor('../Templates/ebipaErrors.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('errorsDoc',result);
errorText+=processor.getOutput();
}
if(errorText!=''){
completeErrorText+='<img src="/120814-042457/images/icon_status_critical.gif" style="border:0px;margin:3px 0px -2px 3px;" alt="" />';
completeErrorText+='<span style="font-weight:normal;color:black;padding-left:3px;">'+batchMgr.batches[i].enclosureName+'</span><br />';
completeErrorText+=errorText+'<br />';
}
}
if(completeErrorText==''){
doNextStep();
}else{
document.getElementById('ebipaErrorDisplay').innerHTML=completeErrorText;
document.getElementById('ebipaErrorDisplay').style.display='block';
batchMgr.displayManager.showMainScreen();
}
}
},true,'ebipaErrorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('completingEBIPASetting'),top.getString('completingEBIPASettingDesc'));
for(var i=0;i<hpems.length;i++){
var uuid=hpems[i].getUuid();
var ebipaConfig=getEbipaConfig(hpems[i],uuid);
var nameStr=top.getString('enclosure:')+' '+hpems[i].getEnclosureName();
var batchEnc=batchMgr.addBatch('ebipaSettings',nameStr);
var transEnc=batchEnc.addTransaction(top.getString('completingEbipaDevSetting'),new FormManager());
transEnc.formMgr.queueCall(hpems[i].configureEbipaDev,[ebipaConfig]);
}
batchMgr.runBatches();
}
function initEBIPAv6Settings(contentLocation){
var hpems=top.getTopology().getSelectedProxies();
try{
var formMgrDev=new FormManager(function(success){
formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
document.getElementById('stepContent').innerHTML=processor.getOutput();
transformDevicev6List(hpems,[0,1,2]);
transformInterconnectv6List(hpems);
},true,'','stepContent');
formMgr.startBatch(true);
for(var i=0;i<hpems.length;i++){
formMgr.queueCall(hpems[i].getBladeMpInfoAll);
formMgr.queueCall(hpems[i].getVlanInfo);
}
formMgr.endBatch();
},true,'','stepContent');
formMgrDev.startBatch(true,true);
for(var i=0;i<hpems.length;i++){
if(hpems[i].getActiveFirmwareVersion()>=4.20){
formMgrDev.queueCall(hpems[i].getEbipav6InfoEx);
}else{
formMgrDev.queueCall(hpems[i].getEbipav6Info);
}
}
formMgrDev.endBatch();
}catch(e){
displayContentFailed('stepContent',[e.message]);
}
}
function saveEbipav6AllSettings(){
var confirmMsg=top.getString('saveEBIPAv6SettingDesc');
confirmMsg+=top.getString('noteEbipav6EnabledBaysAddr');
confirmMsg+=top.getString('areYouSureProceed');
var hpems=top.getTopology().getSelectedProxies();
if(!confirm(confirmMsg)){
setWizardButtonSetEnabled(true);
return;
}
setWizardButtonSetEnabled(false);
var batchMgr=new BatchManager(function(success){
setWizardButtonSetEnabled(true);
if(success){
var completeErrorText='';
for(var i=0;i<batchMgr.batches.length;i++){
var errorText='';
for(var j=0;j<batchMgr.batches[i].transactions.length;j++){
var formMgrTrans=batchMgr.batches[i].transactions[j].formMgr;
var result=formMgrTrans.getDataByCallIndex(0);
var processor=new XsltProcessor('../Templates/ebipav6Errors.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('errorsDoc',result);
errorText+=processor.getOutput();
}
if(errorText!=''){
completeErrorText+='<img src="/120814-042457/images/icon_status_critical.gif" style="border:0px;margin:3px 0px -2px 3px;" alt="" />';
completeErrorText+='<span style="font-weight:normal;color:black;padding-left:3px;">'+batchMgr.batches[i].enclosureName+'</span><br />';
completeErrorText+=errorText+'<br />';
}
}
if(completeErrorText==''){
doNextStep();
}else{
document.getElementById('ebipaErrorDisplay').innerHTML=completeErrorText;
document.getElementById('ebipaErrorDisplay').style.display='block';
batchMgr.displayManager.showMainScreen();
}
}
},true,'ebipaErrorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('completingEBIPAv6Setting'),top.getString('completingEBIPAv6SettingDesc'));
for(var i=0;i<hpems.length;i++){
var uuid=hpems[i].getUuid();
var ebipav6Config=getEbipav6Config(hpems[i],uuid);
var nameStr=top.getString('enclosure:')+' '+hpems[i].getEnclosureName();
var batchEnc=batchMgr.addBatch('ebipav6Settings',nameStr);
var transEnc=batchEnc.addTransaction(top.getString('completingEbipav6DevSetting'),new FormManager());
if(hpems[i].getActiveFirmwareVersion()>=4.20){
transEnc.formMgr.queueCall(hpems[i].setEbipav6InfoEx,[ebipav6Config]);
}else{
transEnc.formMgr.queueCall(hpems[i].setEbipav6Info,[ebipav6Config]);
}
}
batchMgr.runBatches();
}
function initPowerManagement(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
formMgr=new FormManager(function(success){
if(success){
var powerSubsystemInfoDoc=hpemLocal.getPowerSubsystemInfo();
var minVa=parseInt(getElementValueXpath(powerSubsystemInfoDoc,'//hpoa:powerSubsystemInfo/hpoa:extraData[@hpoa:name="ACLimitLow"]'));
var maxVa=parseInt(getElementValueXpath(powerSubsystemInfoDoc,'//hpoa:powerSubsystemInfo/hpoa:extraData[@hpoa:name="ACLimitHigh"]'));
wizardTop.setParam('minVa',minVa);
wizardTop.setParam('maxVa',maxVa);
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('powerConfigInfoDoc',hpemLocal.getPowerConfigInfo());
processor.addParameter('powerSubsystemInfoDoc',powerSubsystemInfoDoc);
processor.addParameter('powerSupplyInfoDoc',hpemLocal.getPsInfoDOM());
processor.addParameter('minVa',minVa);
processor.addParameter('maxVa',maxVa);
processor.addParameter('enclosureType',hpemLocal.getEnclosureType());
processor.addParameter('isTower',hpemLocal.getIsTower());
processor.addParameter('powerCapConfigDoc',hpemLocal.getPowerCapConfig());
processor.addParameter('powerCapExtConfigDoc',hpemLocal.getPowerCapExtConfig());
processor.addParameter('powerCapBladeStatusDoc',hpemLocal.getPowerCapBladeStatus());
document.getElementById('stepContent').innerHTML=processor.getOutput();
getNextButton().onclick=setPowerManagement;
}
else{
displayContentFailed('stepContent',formMgr.getErrorsArray());
}
},true,'','stepContent','waitContainer');
formMgr.startBatch(true);
formMgr.queueCall(hpemLocal.getPowerConfigInfo);
formMgr.queueCall(hpemLocal.getPowerSubsystemInfo);
formMgr.queueCall(hpemLocal.getPowerCapConfig);
formMgr.queueCall(hpemLocal.getPowerCapExtConfig);
formMgr.queueCall(hpemLocal.getPowerCapBladeStatus,[],[],['305']);
formMgr.endBatch();
}
function setPowerManagement(){
setWizardButtonSetEnabled(false);
var hpems=top.getTopology().getSelectedProxies();
formMgr=new FormManager(stdSuccessCallback,true,'powerErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('completingPowerMgmtSettings'));
var redundancyMode='';
var powerCeiling='';
var powerCap='';
var deratedCircuit='';
var ratedCircuit='';
var dynamicPowerSaver=false;
if(document.getElementById('redundancyAC').checked){
redundancyMode='AC_REDUNDANT';
}else if(document.getElementById('redundancyPS').checked){
redundancyMode='POWER_SUPPLY_REDUNDANT';
}else if(document.getElementById('redundancyNone').checked){
redundancyMode='NON_REDUNDANT';
}
if(document.getElementById('staticPowerLimit').checked){
powerCeiling=document.getElementById('powerCeiling').value;
if(powerCeiling==''){
powerCeiling=0;
}else{
powerCeiling=parseInt(powerCeiling);
}
ourInputValidator=new InputValidator("validate-power-limit","powerLimitError",true);
if(!inputIsValid()){
setWizardButtonSetEnabled(true);
return;
}
powerCap=0;
}else if(document.getElementById('dynamicPowerCap').checked){
powerCap=document.getElementById('powerCap').value;
deratedCircuit=document.getElementById('deratedCircuit').value;
ratedCircuit=document.getElementById('ratedCircuit').value;
if(powerCap==''){
powerCap=0;
}else{
powerCap=parseInt(powerCap);
}
if(deratedCircuit==''){
deratedCircuit=0;
}else{
deratedCircuit=parseInt(deratedCircuit);
}
if(ratedCircuit==''){
ratedCircuit=0;
}else{
ratedCircuit=parseInt(ratedCircuit);
}
ourInputValidator=new InputValidator("validate-power-cap","powerCapError",true);
if(!inputIsValid()){
setWizardButtonSetEnabled(true);
return;
}
powerCeiling=0;
}else if(document.getElementById('powerLimitNone').checked){
powerCeiling=0;
powerCap=0;
deratedCircuit=0;
ratedCircuit=0;
}
dynamicPowerSaver=document.getElementById('dpsEnabled').checked;
var powerCapConfig=getPowerCapConfigDocument(powerCap,deratedCircuit,ratedCircuit);
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
formMgr.setCurrentEnclosureName(hpems[i].getEnclosureName());
if(powerCap!=0){
formMgr.queueCall(hpems[i].setPowerConfig,[redundancyMode,powerCeiling,dynamicPowerSaver]);
formMgr.queueCall(hpems[i].setPowerCapConfig,[powerCapConfig]);
}else{
if(powerCeiling==0){
formMgr.queueCall(hpems[i].setPowerCapConfig,[powerCapConfig]);
}
formMgr.queueCall(hpems[i].setPowerConfig,[redundancyMode,powerCeiling,dynamicPowerSaver]);
}
}
formMgr.endBatch();
}
function getPowerCapConfigDocument(powerCap,deratedCircuit,ratedCircuit){
var domBuilder=new DomBuilder();
domBuilder.addDocument("hpoa:config",['xmlns:'+OA_NAMESPACE(),OA_NAMESPACE_URI()]);
domBuilder.appendChild("hpoa:powerCap",[],powerCap);
domBuilder.appendChild("hpoa:extraData",["hpoa:name","deratedCircuit"],deratedCircuit);
domBuilder.appendChild("hpoa:extraData",["hpoa:name","ratedCircuit"],ratedCircuit);
domBuilder.appendChild("hpoa:extraData",["hpoa:name","rdpcAware"],1);
return domBuilder.getDocument().documentElement.cloneNode(true);
}
function enablePowerLimitInput(state){
toggleFormEnabled('vaLimitContainer',state);
if(!state){
document.getElementById('powerCeiling').value='';
}
}
function enablePowerCapInput(state){
toggleFormEnabled('powerCapContainer',state);
if(!state){
document.getElementById('powerCap').value='';
document.getElementById('deratedCircuit').value='';
document.getElementById('ratedCircuit').value='';
}
}
function toggleDpsAvailable(radio){
if(radio.getAttribute('id')=='redundancyOver'){
document.getElementById('dpsEnabled').setAttribute('disabled','true');
}
else{
document.getElementById('dpsEnabled').removeAttribute('disabled','true');
}
}
function checkVaRange(vaInput){
var minVa=wizardTop.getParam('minVa');
var maxVa=wizardTop.getParam('maxVa');
return(vaInput>=minVa)&&(vaInput<=maxVa);
}
function initDirectorySettings(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var encNum=hpemLocal.getEnclosureNumber();
formMgr=new FormManager(function(success){
if(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('encNum',encNum);
processor.addParameter('isWizard','true');
processor.addParameter('ldapInfoDoc',hpemLocal.getLdapInfo());
document.getElementById('stepContent').innerHTML=processor.getOutput();
}else{
displayContentFailed('stepContent');
}
getNextButton().onclick=setupDirectorySettings;
showLDAPIPv6DisabledNote('true',encNum);
},true,'','stepContent');
with(formMgr){
toggleDebugMode(dbgWin,dbgWin);
startBatch(true);
queueCall(hpemLocal.getLdapInfo);
endBatch();
}
}
function setupDirectorySettings(){
var ldapEnabled=document.getElementById('ldapEnabled').checked;
var localEnabled=document.getElementById('localEnabled').checked;
if(ldapEnabled){
ourInputValidator=new InputValidator(null,'ldapErrorDisplay',true);
if(!inputIsValid()){return;}
}
if(ldapEnabled||localEnabled){
setWizardButtonSetEnabled(false);
var hpems=top.getTopology().getSelectedProxies();
var labels=new Array();
var dsAddress=document.getElementById('dsAddress').value
var port=document.getElementById('ldapPort').value;
var gcPort=document.getElementById('gcPort').value;
if(port==""||isNaN(port)){
port=0;
}
if(gcPort==""||isNaN(gcPort)){
gcPort=0;
}
var ntAccountMapping=document.getElementById('ntAccountMapping').checked
labels.push('lblDsAddress');
labels.push('lblLdapPort');
labels.push('lblNtAccount');
var domBuilder=new DomBuilder();
domBuilder.addDocument("hpoa:searchContexts",['xmlns:'+OA_NAMESPACE(),OA_NAMESPACE_URI()]);
var inputs=document.getElementsByTagName("input");
for(var i=0;i<inputs.length;i++){
if(inputs[i].getAttribute("type")=="text"&&
inputs[i].getAttribute("id").indexOf("searchContext")>-1){
domBuilder.appendChild("hpoa:searchContext",null,inputs[i].value);
labels.push('lblSearch'+(i+1));
}
}
var searchContexts=domBuilder.getDocument().documentElement.cloneNode(true);
var batchMgr=new BatchManager(stdSuccessCallback,true,'ldapErrorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('completingLdapSettings'));
for(var i=0;i<hpems.length;i++){
var encNum=hpems[i].getEnclosureNumber();
var batch=batchMgr.addBatch('LdapSettings'+encNum,hpems[i].getEnclosureName());
if(ldapEnabled){
var trans1=batch.addTransaction('Set LDAP Information',new FormManager(),true);
trans1.formMgr.queueCall(hpems[i].setLdapInfo3,[dsAddress,port,gcPort,ntAccountMapping,searchContexts],labels);
}
var trans2=batch.addTransaction('Enable LDAP Authentication',new FormManager());
trans2.formMgr.queueCall(hpems[i].enableLdapAuthentication,[ldapEnabled,localEnabled],['lblEnableLdap','lblEnableLocal']);
}
batchMgr.runBatches();
}else{
alert(top.getString('mustEnableLeastOneAuth'));
}
}
function initDirectoryGroups(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('groupsDoc',hpemLocal.getGroupsDOM());
processor.addParameter('enclosureInfoDoc',hpemLocal.getEnclosureInfo());
processor.addParameter('numDeviceBays',hpemLocal.getNumBlades());
processor.addParameter('numIoBays',hpemLocal.getNumTrays());
document.getElementById('stepContent').innerHTML=processor.getOutput();
getNextButton().onclick=function(){
top.mainPage.getPortalFrame().gotoStepNumber(9);
};
initUserOverview(startEditGroup,startAddGroup,deleteGroups);
}
function startEditGroup(){
var groupName=getSelectedSecObjects()[0];
wizardTop.setParam('groupAction','edit');
wizardTop.setParam('groupName',groupName);
wizardTop.setParam('helpContext',"WIZ_LDAP_GROUPS_EDIT");
var nextFunction=getNextNavigateFunction();
nextFunction();
}
function startAddGroup(){
wizardTop.setParam('groupAction','add');
wizardTop.setParam('helpContext',"WIZ_LDAP_GROUPS_ADD");
var nextFunction=getNextNavigateFunction();
nextFunction();
}
function deleteGroups(){
var secObjects=getSelectedSecObjects();
var hpemLocal=top.getTopology().getProxyLocal();
if(secObjects.length>0){
formMgr=new FormManager(function(){},false,'groupErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('deletingGrps'));
formMgr.startBatch();
for(var i=0;i<secObjects.length;i++){
formMgr.queueCall(hpemLocal.removeLdapGroup,[secObjects[i]]);
}
formMgr.endBatch();
}
else{
containerCheckboxToggle('secObjectContainer',false);
userSelected();
}
}
function initDirectoryGroupSettings(contentLocation){
var processor=new XsltProcessor(contentLocation);
var hpemLocal=top.getTopology().getProxyLocal();
var hpems=top.getTopology().getSelectedProxies();
var groupAction=wizardTop.getParam('groupAction');
var groupName=wizardTop.getParam('groupName');
var groupActionButton=null;
var groupInfoDoc=null;
var linkHasMixed=false;
var currentEncType=hpemLocal.getEnclosureType();
for(var i=0;i<hpems.length;i++){
if(!hpems[i].getIsLocal()){
if((hpems[i].getEnclosureType()!=EnclosureTypes.Unknown)&&(hpems[i].getEnclosureType()!=currentEncType)){
linkHasMixed=true;
break;
}
}
}
if(groupAction=='add'){
var xml=importModule('xml');
groupInfoDoc=xml.parseXML('<hpoa:bayPermissions xmlns:hpoa="hpoa.xsd" />');
addGroupResults=new Object();
groupActionButton=getHPButton('groupActionButton',top.getString('addGroup'),addGroup,true);
}
else if(groupAction=='edit'){
groupInfoDoc=hpemLocal.getLdapGroupInfo(groupName);
groupActionButton=getHPButton('groupActionButton',top.getString('updateGroup'),updateGroup,true);
}
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('action',groupAction);
processor.addParameter('groupInfoDoc',groupInfoDoc);
processor.addParameter('linkHasMixed',""+linkHasMixed);
processor.addParameter('lcdInfoDoc',hpemLocal.getLcdInfo());
processor.addParameter('isTower',hpemLocal.getIsTower());
processor.addParameter('numDeviceBays',hpemLocal.getNumBlades());
processor.addParameter('numIoBays',hpemLocal.getNumTrays());
if(!linkHasMixed){
processor.addParameter('enclosureType',hpemLocal.getEnclosureType());
}
document.getElementById('stepContent').innerHTML=processor.getOutput();
loadCurrentSettings('1');
var previousButtonWrapper=document.getElementById('previousButtonWrapper');
previousButtonWrapper.style['display']='none';
var nextButtonWrapper=document.getElementById('nextButtonWrapper');
var wizardButtonSet=document.getElementById('wizardButtonSet');
wizardButtonSet.replaceChild(groupActionButton,nextButtonWrapper);
var cancelButton=document.getElementById('cancelButton');
var previousButton=document.getElementById('previousButton');
cancelButton.onclick=function(){
if(confirm(top.getString('confirmWantCancel'))){
top.mainPage.getPortalFrame().gotoStepNumber(8);
}
};
}
function addGroup(){
ourInputValidator=new InputValidator(null,'groupErrorDisplay',true);
if(!inputIsValid()){return;}
var addToAllCheck=document.getElementById('addToAllEnclosures');
var overwriteCheck=document.getElementById('overwriteExisting');
var addToAll=false;
var overwrite=false;
var hpems=null;
gInfo=getGroupInfo('1',true);
if(addToAllCheck){
addToAll=addToAllCheck.checked;
}
if(overwriteCheck){
overwrite=overwriteCheck.checked;
}
if(addToAll){
hpems=top.getTopology().getSelectedProxies();
}
else{
hpems=new Array();
hpems.push(top.getTopology().getProxyLocal());
}
var batchMgr=new BatchManager(function(success){
if(success){
top.mainPage.getPortalFrame().gotoStepNumber(8);
}else{
for(var b=0;b<batchMgr.getTotalBatches();b++){
var thisBatch=batchMgr.getBatch(b);
var thisTrans=thisBatch.getTransaction(0);
if(thisTrans.name=="Add New Group"){
top.logEvent("Wizard: Add New Group success: "+thisTrans.success,null,1,4);
addUserResults[thisBatch.name]=thisTrans.success;
}
}
}
},true,'groupErrorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('completingGrpSettings'));
for(var i=0;i<hpems.length;i++){
var batchName='NewGroupEnc'+hpems[i].getUuid();
var batch=batchMgr.addBatch(batchName,hpems[i].getEnclosureName());
var trans1=batch.addTransaction('Add New Group',new FormManager(),true);
if(addGroupResults[batchName]!=true){
trans1.formMgr.queueCall(hpems[i].addLdapGroup,[gInfo['groupName']],['lblGroupName'],(overwrite?['6','122']:[]));
}
var trans2=batch.addTransaction('Set Group Information',new FormManager());
trans2.formMgr.queueCall(hpems[i].setLdapGroupDescription,[gInfo['groupName'],gInfo['description']],['groupDescription']);
if(gInfo['groupBayAcl']!=null){
trans2.formMgr.queueCall(hpems[i].setLdapGroupBayAcl,[gInfo['groupName'],gInfo['groupBayAcl']]);
}
var trans3=batch.addTransaction('Set Group Permissions',new FormManager());
if(gInfo['permissionsToAdd']!=null){
trans3.formMgr.queueCall(hpems[i].addLdapGroupBayAccess,[gInfo['groupName'],gInfo['permissionsToAdd']]);
}
if(gInfo['permissionsToRemove']!=null){
trans3.formMgr.queueCall(hpems[i].removeLdapGroupBayAccess,[gInfo['groupName'],gInfo['permissionsToRemove']],[],['316']);
}
}
batchMgr.runBatches();
}
function updateGroup(callback){
ourInputValidator=new InputValidator(null,'groupErrorDisplay',true);
if(!inputIsValid()){
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
return;
}
var addToAllCheck=document.getElementById('addToAllEnclosures');
var addToAll=false;
var hpems=null;
if(addToAllCheck){
addToAll=addToAllCheck.checked;
}
if(addToAll){
hpems=top.getTopology().getSelectedProxies();
}
else{
hpems=new Array();
hpems.push(top.getTopology().getProxyLocal());
}
if(typeof(callback)=='undefined'||callback==null){
var callback=function(success){
if(success){
top.mainPage.getPortalFrame().gotoStepNumber(8);
}
};
}
if(gInfo==null){
gInfo=getGroupInfo('1');
}
formMgr=new FormManager(callback,true,'groupErrorDisplay','stepInnerContent','waitContainer');
formMgr.createWaitContainer(top.getString('completingGrpSettings'));
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
formMgr.queueCall(hpems[i].setLdapGroupDescription,[gInfo['groupName'],gInfo['description']],['groupDescription']);
if(gInfo['groupBayAcl']!=null){
formMgr.queueCall(hpems[i].setLdapGroupBayAcl,[gInfo['groupName'],gInfo['groupBayAcl']]);
}
if(gInfo['permissionsToAdd']!=null){
formMgr.queueCall(hpems[i].addLdapGroupBayAccess,[gInfo['groupName'],gInfo['permissionsToAdd']]);
}
if(gInfo['permissionsToRemove']!=null){
formMgr.queueCall(hpems[i].removeLdapGroupBayAccess,[gInfo['groupName'],gInfo['permissionsToRemove']],[],['316']);
}
}
formMgr.endBatch();
}
function groupChangedHandler(result){
var hpemLocal=top.getTopology().getProxyLocal();
var processor=new XsltProcessor('../Templates/groupOverviewTableExternal.xsl');
processor.addParameter('groupsDoc',hpemLocal.getGroupsDOM());
processor.addParameter('stringsDoc',top.getStringsDoc());
try{
document.getElementById('groupOverviewTableContainer').innerHTML=processor.getOutput();
}catch(e){
}
initUserOverview(startEditGroup,startAddGroup,deleteGroups);
}
function initSnmp(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var hpems=top.getTopology().getSelectedProxies();
formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
processor.addParameter('networkInfoDoc',hpemLocal.getEnclosureNetworkInfo());
processor.addParameter('snmpInfoDoc',hpemLocal.getSnmpInfo());
if(hpemLocal.hasSNMPv3()){
processor.addParameter('snmpInfo3Doc',hpemLocal.getSnmpInfo3());
}
processor.addParameter('serviceUserAcl',hpemLocal.getUserAccessLevel());
processor.addParameter('serviceUsername',hpemLocal.getCurrentServiceUser());
processor.addParameter('testSupported',(hpemLocal.getActiveFirmwareVersion()>=2.10));
processor.addParameter('snmpv3Supported',(""+hpemLocal.hasSNMPv3()));
processor.addParameter('isWizard','true');
document.getElementById('stepContent').innerHTML=processor.getOutput();
for(var i=0;i<hpems.length;i++){
processor=new XsltProcessor('/120814-042457/Wizards/wizardForms/SnmpInfo.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('networkInfoDoc',hpems[i].getEnclosureNetworkInfo());
processor.addParameter('snmpInfoDoc',hpems[i].getSnmpInfo());
processor.addParameter('serviceUserAcl',hpems[i].getUserAccessLevel());
processor.addParameter('serviceUsername',hpems[i].getCurrentServiceUser());
if(hpems[i].hasSNMPv3()){
processor.addParameter('snmpInfo3Doc',hpems[i].getSnmpInfo3());
}
processor.addParameter('encNum',hpems[i].getEnclosureNumber());
var containerId='enc'+hpems[i].getEnclosureNumber()+'snmpSettings';
var container=document.getElementById(containerId);
if(container){
var output=processor.getOutput();
if(!processor.hasErrors()){
container.innerHTML=output;
}else{
displayContentFailed(containerId,['Unable to retrieve SNMP information from enclosure '+hpems[i].getEnclosureName()]);
}
}
reconcilePage();
}
var allDisabled=true;
for(var i=0;i<hpems.length;++i){
var encNum=hpems[i].getEnclosureNumber();
if(document.getElementById('SNMPEnabled:'+encNum).disabled!=true){
allDisabled=false;
break;
}
}
getNextButton().onclick=allDisabled?getSkipButton().onclick:setupSnmp;
},true,'','stepContent');
formMgr.startBatch(true);
for(var i=0;i<hpems.length;i++){
formMgr.queueCall(hpems[i].getSnmpInfo);
formMgr.queueCall(hpems[i].getSnmpInfo3);
formMgr.queueCall(hpems[i].getEnclosureNetworkInfo);
}
formMgr.endBatch();
}
function setupSnmpSuccessCallback(success){
if(success){
top.mainPage.getPortalFrame().gotoStepNumber(12);
}else{
setWizardButtonSetEnabled(true);
}
}
function snmpInfoChangedHandler(result){
if(setupSnmpBatchInProgress==false){
initSnmp('/120814-042457/Wizards/SetupContent_SNMP.xsl');
}
}
function wizAddSnmpUser(){
top.mainPage.getPortalFrame().gotoStepNumber(11.1);
}
function wizDelSnmpUser(){
var hpems=top.getTopology().getSelectedProxies();
doDeleteSnmpUsers(hpems,function(){reconcilePage();});
}
function addSnmpUserWiz(){
ourInputValidator=new InputValidator(null,'errorDisplay',true);
if(!inputIsValid()){
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
return;
}
var hpems=top.getTopology().getSelectedProxies();
doAddSnmpUser(hpems,addSnmpUserSuccessCallback);
}
function addSnmpUserSuccessCallback(success){
if(success){
top.mainPage.getPortalFrame().gotoStepNumber(11);
}else{
setWizardButtonSetEnabled(true);
}
}
function wizAddSnmpTrapPage(){
top.mainPage.getPortalFrame().gotoStepNumber(11.2);
}
function wizRemoveTrapDestinations(){
var hpems=top.getTopology().getSelectedProxies();
doRemoveTrapDestinations(hpems);
}
function initNewSnmpUserSettings(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var hpems=top.getTopology().getSelectedProxies();
var formMgr=new FormManager(function(success){
ourInputValidator=new InputValidator(null,"errorDisplay",true);
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('networkInfoDoc',formMgr.getDataByCallName("getEnclosureNetworkInfo"));
processor.addParameter('snmpInfo3Doc',formMgr.getDataByCallName("getSnmpInfo3"));
processor.addParameter('isWizard','true');
var linkHasMixed=false;
var currentEncType=hpemLocal.getEnclosureType();
for(var i=0;i<hpems.length;i++){
if(!hpems[i].getIsLocal()){
if((hpems[i].getEnclosureType()!=EnclosureTypes.Unknown)&&(hpems[i].getEnclosureType()!=currentEncType)){
linkHasMixed=true;
break;
}
}
}
processor.addParameter('linkHasMixed',linkHasMixed);
if(!linkHasMixed){
processor.addParameter('enclosureType',hpemLocal.getEnclosureType());
}
document.getElementById('stepContent').innerHTML=processor.getOutput();
focusTextbox("username");
},false,'errorDisplay','tabContent','waitContainer');
formMgr.startBatch(true);
formMgr.queueCall(hpemLocal.getEnclosureNetworkInfo);
formMgr.queueCall(hpemLocal.getSnmpInfo3);
formMgr.endBatch();
var previousButton=getPreviousButton();
previousButton.onclick=function(){
top.mainPage.getPortalFrame().gotoStepNumber(11);
};
var userActionButton=getHPButton('userActionButton',top.getString('addUser'),addSnmpUserWiz,true);
var nextButtonWrapper=document.getElementById('nextButtonWrapper');
var wizardButtonSet=document.getElementById('wizardButtonSet');
wizardButtonSet.replaceChild(userActionButton,nextButtonWrapper);
var cancelButton=document.getElementById('cancelButton');
cancelButton.innerHTML=top.getString('skip');
cancelButton.onclick=function(){
if(confirm(top.getString('reallySkip'))){
top.mainPage.getPortalFrame().gotoStepNumber(11);
}
};
}
function initNewSnmpTrapSettings(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var hpems=top.getTopology().getSelectedProxies();
ourInputValidator=new InputValidator(null,"errorDisplay",true);
var formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('isWizard','true');
processor.addParameter('snmpInfo3Doc',formMgr.getDataByCallName("getSnmpInfo3"));
processor.addParameter('snmpv3Supported',(""+hpemLocal.hasSNMPv3()));
processor.addParameter('networkInfoDoc',formMgr.getDataByCallName("getEnclosureNetworkInfo"));
var linkHasMixed=false;
var currentEncType=hpemLocal.getEnclosureType();
for(var i=0;i<hpems.length;i++){
if(!hpems[i].getIsLocal()){
if((hpems[i].getEnclosureType()!=EnclosureTypes.Unknown)&&(hpems[i].getEnclosureType()!=currentEncType)){
linkHasMixed=true;
break;
}
}
}
processor.addParameter('linkHasMixed',linkHasMixed);
if(!linkHasMixed){
processor.addParameter('enclosureType',hpemLocal.getEnclosureType());
}
document.getElementById('stepContent').innerHTML=processor.getOutput();
var previousButton=getPreviousButton();
previousButton.onclick=function(){
top.mainPage.getPortalFrame().gotoStepNumber(11);
};
var userActionButton=getHPButton('trapActionButton',top.getString('addTrap'),addSnmpTrapWiz,true);
var nextButtonWrapper=document.getElementById('nextButtonWrapper');
var wizardButtonSet=document.getElementById('wizardButtonSet');
wizardButtonSet.replaceChild(userActionButton,nextButtonWrapper);
var cancelButton=document.getElementById('cancelButton');
cancelButton.innerHTML=top.getString('skip');
cancelButton.onclick=function(){
if(confirm(top.getString('reallySkip'))){
top.mainPage.getPortalFrame().gotoStepNumber(11);
}
};
focusTextbox("IPAddress");
var fipsMode=hpemLocal.getProperty("FipsEnabled");
var user=null;
if(hpemLocal.hasSNMPv3()){
user=getElementValueXpath(formMgr.getDataByCallName("getSnmpInfo3"),'//hpoa:userInfo',true);
}
enableSNMPv3Controls(fipsMode&&user!=null);
if(fipsMode&&user==null){
ourButtonManager.disableButtonById('trapActionButton');
}
},false,'','stepContent');
formMgr.startBatch(true);
formMgr.queueCall(hpemLocal.getSnmpInfo3);
formMgr.queueCall(hpemLocal.getEnclosureNetworkInfo);
formMgr.endBatch();
}
function addSnmpTrapWiz(){
ourInputValidator=new InputValidator(null,'errorDisplay',true);
if(!inputIsValid()){
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
return;
}
var hpems=top.getTopology().getSelectedProxies();
var hpemLocal=top.getTopology().getProxyLocal();
var activeOaNetowrkInfo=hpemLocal.getOaNetworkInfoByMode(ACTIVE(),null,false);
var ipv6Enabled=getElementValueXpath(activeOaNetowrkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6Enabled"]');
doAddSnmpTrap(hpems,ipv6Enabled,hpemLocal.hasSNMPv3(),addSnmpTrapSuccessCallback);
}
function addSnmpTrapSuccessCallback(success){
if(success){
top.mainPage.getPortalFrame().gotoStepNumber(11);
}else{
setWizardButtonSetEnabled(true);
}
}
var setupSnmpBatchInProgress=false;
function setupSnmp(){
var hpems=top.getTopology().getSelectedProxies();
setWizardButtonSetEnabled(false);
setupSnmpBatchInProgress=true;
var batchMgr=new BatchManager(function(success){
setupSnmpBatchInProgress=false;
setupSnmpSuccessCallback(success);
},true,'snmpErrorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('completingSnmpSettings'));
for(var i=0;i<hpems.length;i++){
var encNum=hpems[i].getEnclosureNumber();
if(document.getElementById('SNMPEnabled:'+encNum).disabled!=true){
var snmpEnabled=document.getElementById('SNMPEnabled:'+encNum).checked;
var systemLocation=document.getElementById('systemLocation:'+encNum).value;
var systemContact=document.getElementById('systemContact:'+encNum).value;
var readCommunity=document.getElementById('readCommunity:'+encNum).value;
var writeCommunity=document.getElementById('writeCommunity:'+encNum).value;
var engineIdString=document.getElementById('engineIdString:'+encNum).value;
var batchSettings=batchMgr.addBatch('snmpSettings',top.getString('enclosure:')+' '+hpems[i].getEnclosureName(),true);
var transSettings=batchSettings.addTransaction('Setting up SNMP Settings',new FormManager());
if(snmpEnabled){
transSettings.formMgr.queueCall(hpems[i].setSnmpLocation,[systemLocation]);
transSettings.formMgr.queueCall(hpems[i].setSnmpContact,[systemContact]);
var fipsMode=hpems[i].getProperty("FipsEnabled");
if(!fipsMode){
transSettings.formMgr.queueCall(hpems[i].setSnmpReadCommunity,[readCommunity]);
transSettings.formMgr.queueCall(hpems[i].setSnmpWriteCommunity,[writeCommunity]);
}
if(engineIdString.length>0){
transSettings.formMgr.queueCall(hpems[i].setSnmpEngineId,[engineIdString]);
}
}}
transSettings.formMgr.queueCall(hpems[i].setNetworkProtocol,[NET_PROTO_SNMP(),snmpEnabled],[],['83','84']);
}
batchMgr.runBatches();
}
function initOaNetworkSettingsIpv4(contentLocation){
try{
initOaNetworkSettings('ipv4',contentLocation);
}catch(e){
displayContentFailed('stepContent',[e.message]);
}
}
function initOaNetworkSettingsIpv6(contentLocation){
try{
initOaNetworkSettings('ipv6',contentLocation);
}catch(e){
displayContentFailed('stepContent',[e.message]);
}
}
function initOaNetworkSettings(type,contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var hpems=top.getTopology().getSelectedProxies();
var currentXslPage;
if(type=="ipv6")
{
top.mainPage.getHelpLauncher().setCurrentTopic("WIZ_OA_NETWORK_SETTINGSv6");
currentXslPage='../Wizards/wizardForms/OANetworkSettingsIpv6.xsl';
}
else
{
top.mainPage.getHelpLauncher().setCurrentTopic("WIZ_OA_NETWORK_SETTINGS");
currentXslPage='../Wizards/wizardForms/OANetworkSettings.xsl';
}
formMgr=new FormManager(function(success){
if(success){
var hasStandby=checkHasStandby(hpems);
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('enclosureList',getWizardTop().getSelectedEnclosures());
var standbyOaNetworkInfoDoc=hpemLocal.getOaNetworkInfoByMode(STANDBY(),null,false);
if(standbyOaNetworkInfoDoc==null){
standbyOaNetworkInfoDoc=top.getXml().parseXML("<br />");
}
processor.addParameter('activeOaNetworkInfo',hpemLocal.getOaNetworkInfoByMode(ACTIVE(),null,false));
processor.addParameter('standbyOaNetworkInfo',standbyOaNetworkInfoDoc);
processor.addParameter('hasStandby',hasStandby);
if(type=="ipv6"){
processor.addParameter('currentTab',"ipv6Tab");
}else{
processor.addParameter('currentTab',"ipv4Tab");
}
processor.addParameter('enclosureVersion',hpemLocal.getActiveFirmwareVersion());
document.getElementById('stepContent').innerHTML=processor.getOutput();
for(var i=0;i<hpems.length;i++){
processor=new XsltProcessor(currentXslPage);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('encName',hpems[i].getEnclosureName());
processor.addParameter('encNum',hpems[i].getEnclosureNumber());
processor.addParameter('oaNetworkInfoDoc',hpems[i].getOaNetworkInfoByMode(ACTIVE(),null,false));
processor.addParameter('oaStatusDoc',hpems[i].getOaStatusByMode(ACTIVE(),null,false));
processor.addParameter('bayNum',hpems[i].getOaBayNumber(ACTIVE()));
processor.addParameter('oaMode',ACTIVE());
processor.addParameter('isWizard','true');
if(type=="ipv4"){
processor.addParameter("masterMode",getOptionGroupValue("activeIPType"));
}
processor.addParameter('enclosureVersion',hpems[i].getActiveFirmwareVersion());
var containerId='enc'+hpems[i].getEnclosureNumber()+'activeNetSettingsContainer';
var container=document.getElementById(containerId);
if(container){
container.innerHTML=processor.getOutput();
}
if(getElementValueXpath(hpems[i].getOaStatusDOM(),'//hpoa:oaStatus[hpoa:oaRole="STANDBY"]/hpoa:bayNumber')!=''){
processor=new XsltProcessor(currentXslPage);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('encName',hpems[i].getEnclosureName());
processor.addParameter('encNum',hpems[i].getEnclosureNumber());
processor.addParameter('oaNetworkInfoDoc',hpems[i].getOaNetworkInfoByMode(STANDBY(),null,false));
processor.addParameter('oaStatusDoc',hpems[i].getOaStatusByMode(STANDBY(),null,false));
processor.addParameter('bayNum',hpems[i].getOaBayNumber(STANDBY()));
processor.addParameter('oaMode',STANDBY());
processor.addParameter('isWizard','true');
if(type=="ipv4"){
processor.addParameter("masterMode",getOptionGroupValue("standbyIPType"));
}
processor.addParameter('enclosureVersion',hpems[i].getActiveFirmwareVersion());
var containerId='enc'+hpems[i].getEnclosureNumber()+'standbyNetSettingsContainer';
var container=document.getElementById(containerId);
if(container){
container.innerHTML=processor.getOutput();
}
}
else{
var standbyOuterContainer=document.getElementById('enc'+hpems[i].getEnclosureNumber()+'standbyOuterContainer');
if(standbyOuterContainer){
standbyOuterContainer.style.display='none';
}
}
}
if(type=="ipv6")
{
updateCheckAllIpv6DynDns(ACTIVE());
if(hasStandby)
updateCheckAllIpv6DynDns(STANDBY());
}
}
else{
displayContentFailed('stepContent',formMgr.getErrorsArray());
getNextButton().onclick=doNextStep;
}
},true,'','stepContent');
formMgr.startBatch(true,true);
for(var i=0;i<hpems.length;i++){
formMgr.queueCall(hpems[i].getOaNetworkInfoAll);
}
formMgr.endBatch();
}
function setOaDnsFieldsEnabled(containerId){
var container=document.getElementById(containerId);
if(container){
var inputCollection=container.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
if(inputCollection[i].getAttribute('id')&&inputCollection[i].getAttribute('id').indexOf('DnsName')>-1){
inputCollection[i].removeAttribute('disabled');
inputCollection[i].className='stdInput';
}
}
}
}
function checkHasStandby(hpems){
var hasStandby=false;
for(var i=0;i<hpems.length;i++){
if(getElementValueXpath(hpems[i].getOaStatusDOM(),'//hpoa:oaStatus[hpoa:oaRole="STANDBY"]',true)!=null){
hasStandby=true;
break;
}
}
return hasStandby;
}
function setupOaNetSettings(useSelected,callbackFunction){
var hpems=top.getTopology().getSelectedProxies();
var hpemLocal=top.getTopology().getProxyLocal();
if(assertFalse(useSelected)){
hpemLocal=top.getTopology().getSelectedProxy();
hpems=[hpemLocal];
}
var hasStandby=checkHasStandby(hpems);
var callback;
if(isFunction(callbackFunction)){
callback=callbackFunction;
}else{
callback=stdSuccessCallback;
}
var activeIpModeStatic=getInputValue('activeIPSettingStatic');
var activeIpModeDHCP=getInputValue('activeIPSettingDHCP');
if(hasStandby){
var standbyIpModeStatic=getInputValue('standbyIPSettingStatic');
var standbyIpModeDHCP=getInputValue('standbyIPSettingDHCP');
}
ourInputValidator=new InputValidator('validate-dns','oaNetSettingsErrorDisplay',true);
if(!inputIsValid()){return;}
if(activeIpModeStatic||activeIpModeDHCP){
if(activeIpModeStatic){
ourInputValidator.setNewInputGroup('validate-ip-static-active');
if(!inputIsValid()){return;}
}
}else{
alert(top.getString('noOptionSelected'));
return;
}
if(hasStandby){
if(standbyIpModeStatic||standbyIpModeDHCP){
if(standbyIpModeStatic){
ourInputValidator.setNewInputGroup('validate-ip-static-standby');
if(!inputIsValid()){return;}
}
var encIpMode=getInputValue('encIpMode');
if(encIpMode){
var standbyIpAddress;
if(standbyIpModeStatic){
standbyIpAddress=getInputValue(STANDBY()+'Ip'+hpemLocal.getEnclosureNumber());
}else{
var standbyOaNetworkInfo=hpemLocal.getOaNetworkInfoByMode(STANDBY(),null,false);
standbyIpAddress=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:ipAddress');
}
var activeIpAddress=getInputValue(ACTIVE()+'Ip'+hpemLocal.getEnclosureNumber());
if(activeIpAddress==standbyIpAddress){
var errDisplay=document.getElementById('oaNetSettingsErrorDisplay');
var errorString=top.getString('429');
errDisplay.innerHTML=errorString;
errDisplay.style.display='block';
return;
}
}
}else{
alert(top.getString('noOptionSelected'));
return;
}
}
if((activeIpModeStatic||activeIpModeDHCP)){
try{
setWizardButtonSetEnabled(false);
}catch(e){}
var requiresConfirm=(top.getTopology().getEnclosureCountByProperty("getIsLocal",true,hpems)>0);
var confirmString=top.getString('chgOANetSettingDesc1')+' ';
confirmString+=top.getString('chgOANetSettingDesc2')+' ';
confirmString+=top.getString('chgOANetSettingDesc3');
if((requiresConfirm&&confirm(confirmString))||(!requiresConfirm)){
if(hpems.length>1){
var contentId='';
if(document.getElementById("bodyContent")!=null){
contentId="bodyContent";
}else{
contentId="stepInnerContent";
}
var formMgr=new FormManager(function(success){
if(success){
var formMgrFinish=new FormManager(callback,true,'oaNetSettingsErrorDisplay','stepInnerContent','waitContainer');
formMgrFinish.createWaitContainer(top.getString('completingOaNetworkSettings'));
formMgrFinish.startBatch();
formMgrFinish.setCurrentEnclosureName(hpemLocal.getEnclosureName(),hpemLocal.getEnclosureNumber());
queueOaNetSettingsCalls(hpemLocal,formMgrFinish);
formMgrFinish.endBatch();
}else{
setWizardButtonSetEnabled(true);
}
},true,'oaNetSettingsErrorDisplay',contentId,'waitContainer');
formMgr.createWaitContainer(top.getString('completingOaNetworkSettings'));
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
if(hpems[i].getIsLocal()==false){
queueOaNetSettingsCalls(hpems[i],formMgr);
}
}
formMgr.endBatch();
}else{
var contentId='';
if(document.getElementById("bodyContent")!=null){
contentId="bodyContent";
}else{
contentId="stepInnerContent";
}
var formMgr=new FormManager(callback,true,'oaNetSettingsErrorDisplay',contentId,'waitContainer');
formMgr.createWaitContainer(top.getString('completingOaNetworkSettings'));
formMgr.startBatch();
formMgr.setCurrentEnclosureName(hpemLocal.getEnclosureName(),hpemLocal.getEnclosureNumber());
queueOaNetSettingsCalls(hpemLocal,formMgr);
formMgr.endBatch();
}
}else{
try{
setWizardButtonSetEnabled(true);
}catch(e){}
}
}
}
function checkAllIpv6DynDns(state,mode){
var hpems=top.getTopology().getSelectedProxies();
for(var idx in hpems){
var hpem_ip6ddns=document.getElementById(mode+"ipv6DynDns"+
hpems[idx].getEnclosureNumber());
if(hpem_ip6ddns)
hpem_ip6ddns.checked=state;
}
}
function updateCheckAllIpv6DynDns(mode){
var input_id="enableAllIpv6Ddns";
var state=true;
if(mode==ACTIVE()){
input_id+="Active";
}else{
input_id+="Standby";
}
var checkall=document.getElementById(input_id);
if(checkall){
var hpems=top.getTopology().getSelectedProxies();
for(var idx in hpems){
var hpem_ip6ddns=document.getElementById(mode+"ipv6DynDns"+
hpems[idx].getEnclosureNumber());
if(hpem_ip6ddns)
state=state&&hpem_ip6ddns.checked;
}
checkall.checked=state;
}
}
function setupOaNetSettingsIpv6(useSelected,callbackFunction){
if(document.getElementById('activeEnableIPv6')==null){
return;
}
var hpems=top.getTopology().getSelectedProxies();
var hpemLocal=top.getTopology().getProxyLocal();
if(assertFalse(useSelected)){
hpemLocal=top.getTopology().getSelectedProxy();
hpems=[hpemLocal];
}
var hasStandby=checkHasStandby(hpems);
var callback;
if(isFunction(callbackFunction)){
callback=callbackFunction;
}else{
callback=stdSuccessCallback;
}
var active_staticIpv6Dns1=getInputValue(ACTIVE()+'ipv6dns1'+hpemLocal.getEnclosureNumber());
var active_staticIpv6Dns2=getInputValue(ACTIVE()+'ipv6dns2'+hpemLocal.getEnclosureNumber());
var active_staticIpv6Gw=getInputValue(ACTIVE()+'staticipv6gw'+hpemLocal.getEnclosureNumber());
var active_staticIpv6RouteGateway1=getInputValue(ACTIVE()+'staticipv6routegateway1'+hpemLocal.getEnclosureNumber());
var active_staticIpv6RouteGateway2=getInputValue(ACTIVE()+'staticipv6routegateway2'+hpemLocal.getEnclosureNumber());
var active_staticIpv6RouteGateway3=getInputValue(ACTIVE()+'staticipv6routegateway3'+hpemLocal.getEnclosureNumber());
setInputValue(ACTIVE()+'ipv6dns1'+hpemLocal.getEnclosureNumber(),active_staticIpv6Dns1.split('/')[0]);
setInputValue(ACTIVE()+'ipv6dns2'+hpemLocal.getEnclosureNumber(),active_staticIpv6Dns2.split('/')[0]);
setInputValue(ACTIVE()+'staticipv6gw'+hpemLocal.getEnclosureNumber(),active_staticIpv6Gw.split('/')[0]);
setInputValue(ACTIVE()+'staticipv6routegateway1'+hpemLocal.getEnclosureNumber(),active_staticIpv6RouteGateway1.split('/')[0]);
setInputValue(ACTIVE()+'staticipv6routegateway2'+hpemLocal.getEnclosureNumber(),active_staticIpv6RouteGateway2.split('/')[0]);
setInputValue(ACTIVE()+'staticipv6routegateway3'+hpemLocal.getEnclosureNumber(),active_staticIpv6RouteGateway3.split('/')[0]);
ourInputValidator=new InputValidator(null,'oaNetSettingsErrorDisplay',true);
if(!ourInputValidator.allInputsValidate()){
ourInputValidator.updateFirstMessage(true);
ourInputValidator.autoFocus();
return;
}else{
ourInputValidator.setNewInputGroup('validate-ip-static-active');
if(!inputIsValid()){return;}
}
if(hasStandby){
var standby_staticIpv6Dns1=getInputValue(STANDBY()+'ipv6dns1'+hpemLocal.getEnclosureNumber());
var standby_staticIpv6Dns2=getInputValue(STANDBY()+'ipv6dns2'+hpemLocal.getEnclosureNumber());
var standby_staticIpv6Gw=getInputValue(STANDBY()+'staticipv6gw'+hpemLocal.getEnclosureNumber());
var standby_staticIpv6RouteGateway1=getInputValue(STANDBY()+'staticipv6routegateway1'+hpemLocal.getEnclosureNumber());
var standby_staticIpv6RouteGateway2=getInputValue(STANDBY()+'staticipv6routegateway2'+hpemLocal.getEnclosureNumber());
var standby_staticIpv6RouteGateway3=getInputValue(STANDBY()+'staticipv6routegateway3'+hpemLocal.getEnclosureNumber());
setInputValue(STANDBY()+'ipv6dns1'+hpemLocal.getEnclosureNumber(),standby_staticIpv6Dns1.split('/')[0]);
setInputValue(STANDBY()+'ipv6dns2'+hpemLocal.getEnclosureNumber(),standby_staticIpv6Dns2.split('/')[0]);
setInputValue(STANDBY()+'staticipv6gw'+hpemLocal.getEnclosureNumber(),standby_staticIpv6Gw.split('/')[0]);
setInputValue(STANDBY()+'staticipv6routegateway1'+hpemLocal.getEnclosureNumber(),standby_staticIpv6RouteGateway1.split('/')[0]);
setInputValue(STANDBY()+'staticipv6routegateway2'+hpemLocal.getEnclosureNumber(),standby_staticIpv6RouteGateway2.split('/')[0]);
setInputValue(STANDBY()+'staticipv6routegateway3'+hpemLocal.getEnclosureNumber(),standby_staticIpv6RouteGateway3.split('/')[0]);
ourInputValidator=new InputValidator(null,'oaNetSettingsErrorDisplay',true);
if(!ourInputValidator.allInputsValidate()){
ourInputValidator.updateFirstMessage(true);
ourInputValidator.autoFocus();
return;
}else{
ourInputValidator.setNewInputGroup('validate-ip-static-standby');
if(!inputIsValid()){return;}
}
var encIpMode=getInputValue('encIpMode');
if(encIpMode){
var standbyIpAddresses=[];
var activeIpAddresses=[];
activeIpAddresses[0]=getInputValue(ACTIVE()+'StaticAddrIpv61'+hpemLocal.getEnclosureNumber()).split('/')[0];
activeIpAddresses[1]=getInputValue(ACTIVE()+'StaticAddrIpv62'+hpemLocal.getEnclosureNumber()).split('/')[0];
activeIpAddresses[2]=getInputValue(ACTIVE()+'StaticAddrIpv63'+hpemLocal.getEnclosureNumber()).split('/')[0];
standbyIpAddresses[0]=getInputValue(STANDBY()+'StaticAddrIpv61'+hpemLocal.getEnclosureNumber()).split('/')[0];
standbyIpAddresses[1]=getInputValue(STANDBY()+'StaticAddrIpv62'+hpemLocal.getEnclosureNumber()).split('/')[0];
standbyIpAddresses[2]=getInputValue(STANDBY()+'StaticAddrIpv63'+hpemLocal.getEnclosureNumber()).split('/')[0];
if(((standbyIpAddresses[0]!="")&&arrayContains(activeIpAddresses,standbyIpAddresses[0]))||
((standbyIpAddresses[1]!="")&&arrayContains(activeIpAddresses,standbyIpAddresses[1]))||
((standbyIpAddresses[2]!="")&&arrayContains(activeIpAddresses,standbyIpAddresses[2]))){
var errDisplay=document.getElementById('oaNetSettingsErrorDisplay');
var errorString=top.getString('429');
errDisplay.innerHTML=errorString;
errDisplay.style.display='block';
return;
}
}
}
var requiresConfirm=(top.getTopology().getEnclosureCountByProperty("getIsLocal",true,hpems)>0);
var confirmString=top.getString('chgOANetSettingDesc1')+'\n';
confirmString+=top.getString('chgOANetSettingDesc2')+'\n';
confirmString+=top.getString('chgOANetSettingDesc3');
var contentId='';
if(document.getElementById("bodyContent")!=null){
contentId="bodyContent";
}else{
contentId="stepInnerContent";
}
if((requiresConfirm&&confirm(confirmString))||(!requiresConfirm)){
var confirms=[];
if(hpems.length>1){
for(var j=0;j<hpems.length;j++){
confirms=confirms.concat(queueOaNetSettingsCallsIpv6(hpems[j],null,true));
}
confirms=removeDuplicates(confirms);
}else{
confirms=queueOaNetSettingsCallsIpv6(hpems[0],null,true);
}
if(confirms.length>0){
confirmString="";
for(j=0;j<confirms.length;j++){
confirmString+=(top.getString(confirms[j])+"\n\n");
}
confirmString+=(top.getString("clickOkToContinue")+"\n\n");
if(!confirm(confirmString)){
return;
}
}
try{
setWizardButtonSetEnabled(false);
}catch(e){}
if(hpems.length>1){
var formMgr=new FormManager(function(success){
if(success){
var formMgrFinish=new FormManager(callback,true,'oaNetSettingsErrorDisplay',contentId,'waitContainer');
formMgrFinish.createWaitContainer(top.getString('completingOaNetworkSettings'));
formMgrFinish.startBatch();
formMgrFinish.setCurrentEnclosureName(hpemLocal.getEnclosureName(),hpemLocal.getEnclosureNumber());
queueOaNetSettingsCallsIpv6(hpemLocal,formMgrFinish);
formMgrFinish.endBatch();
}else{
setWizardButtonSetEnabled(true);
}
},true,'oaNetSettingsErrorDisplay',contentId,'waitContainer');
formMgr.createWaitContainer(top.getString('completingOaNetworkSettings'));
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
if(hpems[i].getIsLocal()==false){
queueOaNetSettingsCallsIpv6(hpems[i],formMgr);
}
}
formMgr.endBatch();
}else{
var formMgr=new FormManager(callback,true,'oaNetSettingsErrorDisplay',contentId,'waitContainer');
formMgr.createWaitContainer(top.getString('completingOaNetworkSettings'));
formMgr.batchEventDelay=3;
formMgr.startBatch();
formMgr.setCurrentEnclosureName(hpemLocal.getEnclosureName(),hpemLocal.getEnclosureNumber());
queueOaNetSettingsCallsIpv6(hpemLocal,formMgr);
formMgr.endBatch();
}
}
}
function getOaNetSettingsIpv6AddrByIndex(enc,addrType,idx){
var tmpType;
for(var i=0;i<16;i++){
tmpType=getElementValueXpath(enc,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6AddressType'+i+'"]');
if(tmpType==addrType){
if(idx==0){
var addr=getElementValueXpath(enc,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6Address'+i+'"]')
return addr;
}
idx--;
}
}
return '';
}
function queueOaNetSettingsCallsIpv6(hpem,formManager,confirmOnly){
var confirms=[];
var activeFirmwareVersion=hpem.getActiveFirmwareVersion();
var standbyOaNetworkInfo=hpem.getOaNetworkInfoByMode(STANDBY(),null,false);
if((activeFirmwareVersion<3.6)&&(standbyOaNetworkInfo)){
var standbyEnableIpv6=getInputValue('standbyEnableIPv6');
var standbyEnableRA=getInputValue('standbyEnableRA');
var standbyEnableDHCPv6=getInputValue('standbyEnableDHCPv6');
var old_standbyEnableIpv6=(getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6Enabled"]')=='true');
var old_standbyEnableRA=(getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6RouterAdvEnabled"]')=='true');
var old_standbyEnableDHCPv6=(getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DhcpEnabled"]')=='true');
if(((standbyEnableIpv6!=old_standbyEnableIpv6)&&(!standbyEnableIpv6))||
((standbyEnableRA!=old_standbyEnableRA)&&(!standbyEnableRA))||
((standbyEnableDHCPv6!=old_standbyEnableDHCPv6)&&(!standbyEnableDHCPv6))){
confirms.push('standbyConfirmIPv6Disabling');
}
}
var activeEnableIpv6=getInputValue('activeEnableIPv6');
var activeEnableRA=getInputValue('activeEnableRA');
var activeEnableRaTraffic=getInputValue('activeEnableRaTraffic');
var activeEnableDHCPv6=getInputValue('activeEnableDHCPv6');
var activeOaNetworkInfo=hpem.getOaNetworkInfoByMode(ACTIVE(),null,false);
var old_activeEnableIpv6=(getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6Enabled"]')=='true');
var old_activeEnableRA=(getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6RouterAdvEnabled"]')=='true');
var old_activeEnableRaTraffic=(getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6RaTrafficEnabled"]')=='true');
var old_activeEnableDHCPv6=(getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DhcpEnabled"]')=='true');
if(((activeEnableIpv6!=old_activeEnableIpv6)&&(!activeEnableIpv6))||
((activeEnableRA!=old_activeEnableRA)&&(!activeEnableRA))||
((activeEnableDHCPv6!=old_activeEnableDHCPv6)&&(!activeEnableDHCPv6))){
confirms.push('activeConfirmIPv6Disabling');
}
if(confirmOnly){
return confirms;
}
if(standbyOaNetworkInfo){
var standby_old_staticIpv6Address1=getOaNetSettingsIpv6AddrByIndex(standbyOaNetworkInfo,'STATIC',0);
var standby_staticIpv6Address1=getInputValue(STANDBY()+'StaticAddrIpv61'+hpem.getEnclosureNumber());
var standby_old_staticIpv6Address2=getOaNetSettingsIpv6AddrByIndex(standbyOaNetworkInfo,'STATIC',1);
var standby_staticIpv6Address2=getInputValue(STANDBY()+'StaticAddrIpv62'+hpem.getEnclosureNumber());
var standby_old_staticIpv6Address3=getOaNetSettingsIpv6AddrByIndex(standbyOaNetworkInfo,'STATIC',2);
var standby_staticIpv6Address3=getInputValue(STANDBY()+'StaticAddrIpv63'+hpem.getEnclosureNumber());
var standby_staticIpv6Dns1=getInputValue(STANDBY()+'ipv6dns1'+hpem.getEnclosureNumber());
var standby_staticIpv6Dns2=getInputValue(STANDBY()+'ipv6dns2'+hpem.getEnclosureNumber());
var standby_staticIpv6Gw=getInputValue(STANDBY()+'staticipv6gw'+hpem.getEnclosureNumber());
var standby_staticIpv6RouteDestination1=getInputValue(STANDBY()+'staticipv6routedestination1'+hpem.getEnclosureNumber());
var standby_staticIpv6RouteDestination2=getInputValue(STANDBY()+'staticipv6routedestination2'+hpem.getEnclosureNumber());
var standby_staticIpv6RouteDestination3=getInputValue(STANDBY()+'staticipv6routedestination3'+hpem.getEnclosureNumber());
var standby_staticIpv6RouteGateway1=getInputValue(STANDBY()+'staticipv6routegateway1'+hpem.getEnclosureNumber());
var standby_staticIpv6RouteGateway2=getInputValue(STANDBY()+'staticipv6routegateway2'+hpem.getEnclosureNumber());
var standby_staticIpv6RouteGateway3=getInputValue(STANDBY()+'staticipv6routegateway3'+hpem.getEnclosureNumber());
var standby_ipv6_dyndns=getInputValue(STANDBY()+"ipv6DynDns"+hpem.getEnclosureNumber());
var standby_old_ipv6_dyndns=(getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DynamicDns"]')=='true');
var standbyBayNumber=getInputValue(STANDBY()+'BayNumber'+hpem.getEnclosureNumber());
if(activeFirmwareVersion<3.6){
if(standbyEnableIpv6!=old_standbyEnableIpv6){
formManager.queueCall(hpem.setIpConfigIpv6,[standbyBayNumber,standbyEnableIpv6]);
}
if(standbyEnableDHCPv6!=old_standbyEnableDHCPv6){
formManager.queueCall(hpem.setIpConfigDhcpIpv6,[standbyBayNumber,standbyEnableDHCPv6]);
}
if(standbyEnableRA!=old_standbyEnableRA){
formManager.queueCall(hpem.setRouterAdvertisementIpv6,[standbyBayNumber,standbyEnableRA]);
}
update_ipv6Address(standby_old_staticIpv6Address1,standby_staticIpv6Address1,standbyBayNumber,formManager);
update_ipv6Address(standby_old_staticIpv6Address2,standby_staticIpv6Address2,standbyBayNumber,formManager);
update_ipv6Address(standby_old_staticIpv6Address3,standby_staticIpv6Address3,standbyBayNumber,formManager);
if(standby_staticIpv6Dns1==standby_staticIpv6Dns2){
formManager.queueCall(hpem.setOaDnsIpv6,[standbyBayNumber,standby_staticIpv6Dns1,'0000:0000:0000:0000:0000:0000:0000:0000/0']);
}else{
formManager.queueCall(hpem.setOaDnsIpv6,[standbyBayNumber,standby_staticIpv6Dns1,standby_staticIpv6Dns2]);
}
}else{
var standby_old_staticIpv6Dns1=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DnsStatic1"]');
var standby_old_staticIpv6Dns2=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DnsStatic2"]');
var standby_old_staticIpv6Gw=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticDefaultGateway"]');
var standby_old_staticIpv6RouteDestination1=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteDestination1"]');
var standby_old_staticIpv6RouteDestination2=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteDestination2"]');
var standby_old_staticIpv6RouteDestination3=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteDestination3"]');
var standby_old_staticIpv6RouteGateway1=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteGateway1"]');
var standby_old_staticIpv6RouteGateway2=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteGateway2"]');
var standby_old_staticIpv6RouteGateway3=getElementValueXpath(standbyOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteGateway3"]');
if((standby_staticIpv6Address1!=standby_old_staticIpv6Address1)||
(standby_staticIpv6Address2!=standby_old_staticIpv6Address2)||
(standby_staticIpv6Address3!=standby_old_staticIpv6Address3)||
(standby_staticIpv6Dns1!=standby_old_staticIpv6Dns1)||
(standby_staticIpv6Dns2!=standby_old_staticIpv6Dns2)){
formManager.queueCall(hpem.setOaNetworkStaticIpv6,[standbyBayNumber,standby_staticIpv6Address1,standby_staticIpv6Address2,standby_staticIpv6Address3,standby_staticIpv6Dns1,standby_staticIpv6Dns2]);
}
if(activeFirmwareVersion>=4.1){
if(standby_ipv6_dyndns!=standby_old_ipv6_dyndns){
formManager.queueCall(hpem.configureOaIpv6DyndnsBay,[standbyBayNumber,standby_ipv6_dyndns]);
}
}
if(activeFirmwareVersion>=4.2){
if(standby_staticIpv6Gw!=standby_old_staticIpv6Gw)
formManager.queueCall(hpem.setOaIpv6StaticDefaultGateway,[standbyBayNumber,standby_staticIpv6Gw]);
}
if(activeFirmwareVersion>=4.3){
if(standby_staticIpv6RouteDestination1!=standby_old_staticIpv6RouteDestination1||
standby_staticIpv6RouteDestination2!=standby_old_staticIpv6RouteDestination2||
standby_staticIpv6RouteDestination3!=standby_old_staticIpv6RouteDestination3||
standby_staticIpv6RouteGateway1!=standby_old_staticIpv6RouteGateway1||
standby_staticIpv6RouteGateway2!=standby_old_staticIpv6RouteGateway2||
standby_staticIpv6RouteGateway3!=standby_old_staticIpv6RouteGateway3){
formManager.queueCall(hpem.setOaIpv6StaticRoutes,[standbyBayNumber,standby_staticIpv6RouteDestination1,standby_staticIpv6RouteDestination2,standby_staticIpv6RouteDestination3,standby_staticIpv6RouteGateway1,standby_staticIpv6RouteGateway2,standby_staticIpv6RouteGateway3]);
}
}
}
}
var active_old_staticIpv6Address1=getOaNetSettingsIpv6AddrByIndex(activeOaNetworkInfo,'STATIC',0);
var active_staticIpv6Address1=getInputValue(ACTIVE()+'StaticAddrIpv61'+hpem.getEnclosureNumber());
var active_old_staticIpv6Address2=getOaNetSettingsIpv6AddrByIndex(activeOaNetworkInfo,'STATIC',1);
var active_staticIpv6Address2=getInputValue(ACTIVE()+'StaticAddrIpv62'+hpem.getEnclosureNumber());
var active_old_staticIpv6Address3=getOaNetSettingsIpv6AddrByIndex(activeOaNetworkInfo,'STATIC',2);
var active_staticIpv6Address3=getInputValue(ACTIVE()+'StaticAddrIpv63'+hpem.getEnclosureNumber());
var active_staticIpv6Dns1=getInputValue(ACTIVE()+'ipv6dns1'+hpem.getEnclosureNumber());
var active_staticIpv6Dns2=getInputValue(ACTIVE()+'ipv6dns2'+hpem.getEnclosureNumber());
var active_staticIpv6Gw=getInputValue(ACTIVE()+'staticipv6gw'+hpem.getEnclosureNumber());
var active_staticIpv6RouteDestination1=getInputValue(ACTIVE()+'staticipv6routedestination1'+hpem.getEnclosureNumber());
var active_staticIpv6RouteDestination2=getInputValue(ACTIVE()+'staticipv6routedestination2'+hpem.getEnclosureNumber());
var active_staticIpv6RouteDestination3=getInputValue(ACTIVE()+'staticipv6routedestination3'+hpem.getEnclosureNumber());
var active_staticIpv6RouteGateway1=getInputValue(ACTIVE()+'staticipv6routegateway1'+hpem.getEnclosureNumber());
var active_staticIpv6RouteGateway2=getInputValue(ACTIVE()+'staticipv6routegateway2'+hpem.getEnclosureNumber());
var active_staticIpv6RouteGateway3=getInputValue(ACTIVE()+'staticipv6routegateway3'+hpem.getEnclosureNumber());
var active_ipv6_dyndns=getInputValue(ACTIVE()+"ipv6DynDns"+hpem.getEnclosureNumber());
var active_old_ipv6_dyndns=(getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DynamicDns"]')=='true');
var activeBayNumber=getInputValue(ACTIVE()+'BayNumber'+hpem.getEnclosureNumber());
if(activeFirmwareVersion<3.6){
if(old_activeEnableIpv6!=activeEnableIpv6){
formManager.queueCall(hpem.setIpConfigIpv6,[activeBayNumber,activeEnableIpv6]);
}
if(old_activeEnableDHCPv6!=activeEnableDHCPv6){
formManager.queueCall(hpem.setIpConfigDhcpIpv6,[activeBayNumber,activeEnableDHCPv6]);
}
if(old_activeEnableRA!=activeEnableRA){
formManager.queueCall(hpem.setRouterAdvertisementIpv6,[activeBayNumber,activeEnableRA]);
}
update_ipv6Address(active_old_staticIpv6Address1,active_staticIpv6Address1,activeBayNumber,formManager);
update_ipv6Address(active_old_staticIpv6Address2,active_staticIpv6Address2,activeBayNumber,formManager);
update_ipv6Address(active_old_staticIpv6Address3,active_staticIpv6Address3,activeBayNumber,formManager);
if(active_staticIpv6Dns1==active_staticIpv6Dns2){
formManager.queueCall(hpem.setOaDnsIpv6,[activeBayNumber,active_staticIpv6Dns1,'0000:0000:0000:0000:0000:0000:0000:0000/0']);
}else{
formManager.queueCall(hpem.setOaDnsIpv6,[activeBayNumber,active_staticIpv6Dns1,active_staticIpv6Dns2]);
}
}else{
var active_old_staticIpv6Dns1=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DnsStatic1"]');
var active_old_staticIpv6Dns2=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6DnsStatic2"]');
var active_old_staticIpv6Gw=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticDefaultGateway"]');
var active_old_staticIpv6RouteDestination1=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteDestination1"]');
var active_old_staticIpv6RouteDestination2=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteDestination2"]');
var active_old_staticIpv6RouteDestination3=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteDestination3"]');
var active_old_staticIpv6RouteGateway1=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteGateway1"]');
var active_old_staticIpv6RouteGateway2=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteGateway2"]');
var active_old_staticIpv6RouteGateway3=getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6StaticRouteGateway3"]');
if((active_staticIpv6Address1!=active_old_staticIpv6Address1)||
(active_staticIpv6Address2!=active_old_staticIpv6Address2)||
(active_staticIpv6Address3!=active_old_staticIpv6Address3)||
(active_staticIpv6Dns1!=active_old_staticIpv6Dns1)||
(active_staticIpv6Dns2!=active_old_staticIpv6Dns2)){
formManager.queueCall(hpem.setOaNetworkStaticIpv6,[activeBayNumber,active_staticIpv6Address1,active_staticIpv6Address2,active_staticIpv6Address3,active_staticIpv6Dns1,active_staticIpv6Dns2]);
}
if(activeFirmwareVersion>=4.1){
if(active_ipv6_dyndns!=active_old_ipv6_dyndns){
formManager.queueCall(hpem.configureOaIpv6DyndnsBay,[activeBayNumber,active_ipv6_dyndns]);
}
}
if(activeFirmwareVersion>=4.2){
if(active_staticIpv6Gw!=active_old_staticIpv6Gw)
formManager.queueCall(hpem.setOaIpv6StaticDefaultGateway,[activeBayNumber,active_staticIpv6Gw]);
}
if(activeFirmwareVersion>=4.3){
if(active_staticIpv6RouteDestination1!=active_old_staticIpv6RouteDestination1||
active_staticIpv6RouteDestination2!=active_old_staticIpv6RouteDestination2||
active_staticIpv6RouteDestination3!=active_old_staticIpv6RouteDestination3||
active_staticIpv6RouteGateway1!=active_old_staticIpv6RouteGateway1||
active_staticIpv6RouteGateway2!=active_old_staticIpv6RouteGateway2||
active_staticIpv6RouteGateway3!=active_old_staticIpv6RouteGateway3){
formManager.queueCall(hpem.setOaIpv6StaticRoutes,[activeBayNumber,active_staticIpv6RouteDestination1,active_staticIpv6RouteDestination2,active_staticIpv6RouteDestination3,active_staticIpv6RouteGateway1,active_staticIpv6RouteGateway2,active_staticIpv6RouteGateway3]);
}
if((old_activeEnableIpv6!=activeEnableIpv6)||(activeEnableRaTraffic!=old_activeEnableRaTraffic)||(activeEnableRA!=old_activeEnableRA)||(activeEnableDHCPv6!=old_activeEnableDHCPv6)){
formManager.queueCall(hpem.setEnclosureIpv6Settings,[activeEnableIpv6,activeEnableDHCPv6,activeEnableRaTraffic,activeEnableRA]);
}
}else{
if((old_activeEnableIpv6!=activeEnableIpv6)||(activeEnableRA!=old_activeEnableRA)||(activeEnableDHCPv6!=old_activeEnableDHCPv6)){
formManager.queueCall(hpem.setOaIpv6Settings,[activeBayNumber,activeEnableIpv6,activeEnableDHCPv6,activeEnableRA]);
}
}
}
var old_encIpMode=(getElementValueXpath(hpem.getEnclosureNetworkInfo(),"//hpoa:enclosureNetworkInfo/hpoa:extraData[@hpoa:name='IpSwap']")=='true');
var encIpMode=document.getElementById('encIpMode');
if((encIpMode)&&(encIpMode.checked!=old_encIpMode)){
formManager.queueCall(hpem.setNetworkProtocol,[NET_PROTO_IPSWAP(),encIpMode.checked],[],['83','84']);
}
}
function update_ipv6Address(old_staticIpv6Address,staticIpv6Address,BayNumber,formManager){
if(old_staticIpv6Address!=''){
var mySplitResult=old_staticIpv6Address.split("/");
formManager.queueCall(hpem.setStaticIpv6,[BayNumber,mySplitResult[0],mySplitResult[1],0]);
}
if(staticIpv6Address!=''){
var mySplitResult=staticIpv6Address.split("/");
formManager.queueCall(hpem.setStaticIpv6,[BayNumber,mySplitResult[0],mySplitResult[1],1]);
}
}
function queueOaNetSettingsCallsNIC(hpem,formManager){
var activeBayNumber=hpem.getOaBayNumber(ACTIVE());
formManager.setCurrentEnclosureName(hpem.getEnclosureName()+' (Active)',hpem.getEnclosureNumber());
if(getElementValueXpath(hpem.getOaStatusDOM(),'//hpoa:oaStatus[hpoa:oaRole="STANDBY"]',true)!=null){
formManager.setCurrentEnclosureName(hpem.getEnclosureName()+' (Standby)',hpem.getEnclosureNumber());
var standbyBayNumber=hpem.getOaBayNumber(STANDBY());
try{
var forcedFull=document.getElementById(STANDBY()+'fullAutoSetting_Full'+hpem.getEnclosureNumber()).checked;
if(forcedFull){
var nicSpeed='';
var nicDuplex='NIC_DUPLEX_FULL';
var nicSpeedSelect=document.getElementById(STANDBY()+'nicSpeedSelect'+hpem.getEnclosureNumber());
if(nicSpeedSelect){
nicSpeed=nicSpeedSelect.options[nicSpeedSelect.selectedIndex].value;
}
var nicDuplexSelect=document.getElementById(STANDBY()+'nicDuplexSelect'+hpem.getEnclosureNumber());
if(nicDuplexSelect){
nicDuplex=nicDuplexSelect.options[nicDuplexSelect.selectedIndex].value;
}
formManager.queueCall(hpem.configureOaNicForced,[standbyBayNumber,nicSpeed,nicDuplex]);
}else{
formManager.queueCall(hpem.configureOaNicAuto,[standbyBayNumber]);
}
}catch(e){}
}
formManager.setCurrentEnclosureName(hpem.getEnclosureName()+' (Active)',hpem.getEnclosureNumber());
try{
var forcedFull=document.getElementById(ACTIVE()+'fullAutoSetting_Full'+hpem.getEnclosureNumber()).checked;
if(forcedFull){
var nicSpeed='';
var nicDuplex='NIC_DUPLEX_FULL';
var nicSpeedSelect=document.getElementById(ACTIVE()+'nicSpeedSelect'+hpem.getEnclosureNumber());
if(nicSpeedSelect){
nicSpeed=nicSpeedSelect.options[nicSpeedSelect.selectedIndex].value;
}
formManager.queueCall(hpem.configureOaNicForced,[activeBayNumber,nicSpeed,nicDuplex]);
}
else{
formManager.queueCall(hpem.configureOaNicAuto,[activeBayNumber]);
}
}catch(e){}
}
function queueOaNetSettingsCalls(hpem,formManager){
var activeBayNumber=getInputValue(ACTIVE()+'BayNumber'+hpem.getEnclosureNumber());
var activeIpModeStatic=getInputValue('activeIPSettingStatic');
var activeIpModeDHCP=getInputValue('activeIPSettingDHCP');
formManager.setCurrentEnclosureName(hpem.getEnclosureName()+' (Active)',hpem.getEnclosureNumber());
if(getElementValueXpath(hpem.getOaStatusDOM(),'//hpoa:oaStatus[hpoa:oaRole="STANDBY"]',true)!=null){
formManager.setCurrentEnclosureName(hpem.getEnclosureName()+' (Standby)',hpem.getEnclosureNumber());
var standbyBayNumber=getInputValue(STANDBY()+'BayNumber'+hpem.getEnclosureNumber());
var standbyIpModeStatic=getInputValue('standbyIPSettingStatic');
var standbyIpModeDHCP=getInputValue('standbyIPSettingDHCP');
var standbyOaName=getInputValue(STANDBY()+'DnsName'+hpem.getEnclosureNumber());
if(standbyIpModeStatic){
var ipAddress=getInputValue(STANDBY()+'Ip'+hpem.getEnclosureNumber());
var netmask=getInputValue(STANDBY()+'Netmask'+hpem.getEnclosureNumber());
var gateway=getInputValue(STANDBY()+'Gateway'+hpem.getEnclosureNumber());
var dns1=assertEmptyIpAddress(getInputValue(STANDBY()+'Dns1'+hpem.getEnclosureNumber()));
var dns2=assertEmptyIpAddress(getInputValue(STANDBY()+'Dns2'+hpem.getEnclosureNumber()));
var oaName=getInputValue(STANDBY()+'DnsName'+hpem.getEnclosureNumber());
formManager.queueCall(hpem.setIpConfigStatic,[standbyBayNumber,ipAddress,netmask,gateway,dns1,dns2]);
formManager.queueCall(hpem.setOaName,[standbyBayNumber,oaName]);
}
else if(standbyIpModeDHCP){
var standbyDynDns=getInputValue('standbyDDNS');
formManager.queueCall(hpem.configureOaDhcp,[standbyBayNumber,standbyDynDns],[],['85']);
formManager.queueCall(hpem.setNetworkProtocol,[NET_PROTO_DYNDNS(),standbyDynDns],[],['83','84']);
formManager.queueCall(hpem.setOaName,[standbyBayNumber,standbyOaName]);
}
}
formManager.setCurrentEnclosureName(hpem.getEnclosureName()+' (Active)',hpem.getEnclosureNumber());
var activeOaName=getInputValue(ACTIVE()+'DnsName'+hpem.getEnclosureNumber());
if(activeIpModeStatic){
var ipAddress=getInputValue(ACTIVE()+'Ip'+hpem.getEnclosureNumber());
var netmask=getInputValue(ACTIVE()+'Netmask'+hpem.getEnclosureNumber());
var gateway=getInputValue(ACTIVE()+'Gateway'+hpem.getEnclosureNumber());
var activeDns1=assertEmptyIpAddress(getInputValue(ACTIVE()+'Dns1'+hpem.getEnclosureNumber()));
var activeDns2=assertEmptyIpAddress(getInputValue(ACTIVE()+'Dns2'+hpem.getEnclosureNumber()));
var oaName=getInputValue(ACTIVE()+'DnsName'+hpem.getEnclosureNumber());
formManager.queueCall(hpem.setIpConfigStatic,[activeBayNumber,ipAddress,netmask,gateway,activeDns1,activeDns2]);
formManager.queueCall(hpem.setOaName,[activeBayNumber,oaName]);
}
else if(activeIpModeDHCP){
var activeDynDns=getInputValue('activeDDNS');
formManager.queueCall(hpem.configureOaDhcp,[activeBayNumber,activeDynDns],[],['85']);
formManager.queueCall(hpem.setNetworkProtocol,[NET_PROTO_DYNDNS(),activeDynDns],[],['83','84']);
formManager.queueCall(hpem.setOaName,[activeBayNumber,activeOaName]);
}
var encIpMode=document.getElementById('encIpMode');
if(encIpMode){
formManager.queueCall(hpem.setNetworkProtocol,[NET_PROTO_IPSWAP(),getInputValue('encIpMode')],[],['83','84']);
}
}
function initFirmwareManagement(contentLocation){
var hpemLocal=top.getTopology().getProxyLocal();
var formMgr=new FormManager(function(success){
var processor=new XsltProcessor(contentLocation);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('encNum',hpemLocal.getEnclosureNumber());
processor.addParameter('fwManagementSettings',hpemLocal.getFirmwareManagementSettings());
document.getElementById('stepContent').innerHTML=processor.getOutput();
reconcilePage();
new tcal({
'formname':'scheduleForm',
'controlname':'scheduleDate'
});
getNextButton().onclick=setFirmwareManagement;
},true,'','stepContent');
formMgr.startBatch(true,true);
formMgr.queueCall(hpemLocal.getFirmwareManagementSettings);
formMgr.endBatch();
}
function setFirmwareManagement(){
var hpems=top.getTopology().getSelectedProxies();
var formMgr=new FormManager(null,false,'generalErrorDisplay','stepInnerContent','waitContainer');
var displayMgr=new DisplayManager(null,null,'generalErrorDisplay');
var isoUrl='';
var srcSelect_Local=document.getElementById('srcSelect_Local');
if(srcSelect_Local&&srcSelect_Local.checked){
var isoUrlLocal=document.getElementById('isoUrlLocal');
isoUrl=isoUrlLocal.options[isoUrlLocal.selectedIndex].value;
if(isoUrl=='-'){
displayMgr.showErrors(top.getString('validLocalMedia'));
return;
}
}else{
isoUrl=document.getElementById('isoUrl').value;
}
var enabled=document.getElementById('fwManagementEnabled').checked;
var policy=0;
if(document.getElementById('policy1').checked){
policy=1;
}else if(document.getElementById('policy2').checked){
policy=2;
}
var scheduleDate=document.getElementById('scheduleDate').value;
var scheduleTime=document.getElementById('scheduleTime').value;
if(scheduleDate!=''&&scheduleDate.match(REGEX_DATE())==null){
displayMgr.showErrors(top.getString('invalidDateMessage'));
return;
}
if(scheduleTime!=''&&scheduleTime.match(REGEX_TIME())==null){
displayMgr.showErrors(top.getString('invalidTimeMessage'));
return;
}
var batchMgr=new BatchManager(stdSuccessCallback,false,'generalErrorDisplay','stepInnerContent','waitContainer');
batchMgr.createWaitContainer(top.getString('applyingFwSettings'));
for(var i=0;i<hpems.length;i++){
var batchName='FWMgmt'+hpems[i].getUuid();
var batch=batchMgr.addBatch(batchName,hpems[i].getEnclosureName());
var transaction=batch.addTransaction('Firmware Management Settings',new FormManager(),true);
transaction.formMgr.queueCall(hpems[i].setFirmwareManagementIsoUrl,[isoUrl],['lblFirmwareIso']);
transaction.formMgr.queueCall(hpems[i].setFirmwareManagementPolicy,[policy],['lblPolicy0','lblPolicy1','lblPolicy2']);
transaction.formMgr.queueCall(hpems[i].setFirmwareManagementEnabled,[enabled],[],['286','287']);
transaction.formMgr.queueCall(hpems[i].setFirmwareManagementSchedule,[scheduleDate,scheduleTime],['lblScheduleDate','lblScheduleTime']);
}
batchMgr.runBatches();
setWizardButtonSetEnabled(false);
}
