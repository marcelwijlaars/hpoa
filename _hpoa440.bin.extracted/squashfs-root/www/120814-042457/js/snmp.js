/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var alertDestinations=new Array();
function AlertDestination(){
this.action=-1;
this.version=1;
this.community='';
this.ipAddress='';
this.user='';
this.engineid='';
}
var DestinationActions={
ADD:0,
REMOVE:1
};
function resetAlertDestinations(){
alertDestinations=new Array();
}
function clearCallEntry(ipAddress){
var destinationList=document.getElementById('selectedAddresses');
if(destinationList){
for(var i=destinationList.options.length-1;i>=0;i--){
if(destinationList.options[i].value==ipAddress){
destinationList.options[i]=null;
}
}
}
}
function removeTrapDestinations(){
doRemoveTrapDestinations([hpem]);
}
function addSnmpTrap(){
var activeOaNetowrkInfo=hpem.getOaNetworkInfoByMode(ACTIVE(),null,false);
var ipv6Enabled=getElementValueXpath(activeOaNetowrkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6Enabled"]');
doAddSnmpTrap([hpem],ipv6Enabled,hpem.hasSNMPv3(),addSnmpTrapSuccess);
}
function addSnmpTrapSuccess(success){
if(success){
snmpUpdatePageTitle();
location='/120814-042457/html/snmp.html?encNum='+encNum+'&tab=snmpSettings';
}
}
function doAddSnmpTrap(hpems,ipv6Enabled,hasSNMPv3,successFcn){
ourInputValidator.clearMessages();
if(ourInputValidator.allInputsValidate()){
var ipAddress=getInputValue("IPAddress");
var community=getInputValue("destinationString");
if(community==''){
community='public';
}
var user="";
var engineid="";
var security="";
var inform=false;
var snmp_version=1;
if(hasSNMPv3){
var userString=getInputValue("snmpUser");
engineid=userString.substring(0,userString.indexOf(';'));
user=userString.substring(userString.indexOf(';')+1);
security=getInputValue("snmpSecurity");
inform=getInputValue("chkInform");
snmp_version=getInputValue("chkSNMPv3")?3:1;
}
if(_isValidIPv6Address(ipAddress)&&!(_isValidIPv6Address(ipAddress,'NO'))){
ourInputValidator.showCustomMessage(top.getString("networkPrefixNotRequiredForAlerts"));
return;
}
var formMgr=new FormManager(function(success){
if(successFcn!=null){
successFcn(success);
}
},false,'errorDisplay',getContainerID(),'waitContainer');
formMgr.createWaitContainer(top.getString('addingTrap'));
formMgr.batchEventDelay=3;
formMgr.startBatch();
var acceptableErrors=(hpems.length>1)?['27']:[];
for(var i=0;i<hpems.length;i++){
if(hpems.length>1){
formMgr.setCurrentEnclosureName(hpems[i].getEnclosureName());
}
if(snmp_version==1){
formMgr.queueCall(hpems[i].addSnmpTrapReceiver,[ipAddress,community],[],acceptableErrors);
}else if(hpems[i].hasSNMPv3()){
formMgr.queueCall(hpems[i].addSnmpTrapReceiver3,[ipAddress,user,engineid,security,inform],[],acceptableErrors);
}
}
formMgr.endBatch();
}else{
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
}
}
function doRemoveTrapDestinations(hpems){
var trapsToRemove=new Array();
trapsToRemove=getSelectedSnmpTraps();
if(trapsToRemove.length>0&&confirm(top.getString("reallyDeleteSnmpTraps"))){
var formMgr=new FormManager(function(success){
if(success){
}
},false,'snmpErrorDisplay',getContainerID(),'waitContainer');
formMgr.startBatch();
formMgr.batchEventDelay=5;
formMgr.createWaitContainer(top.getString('removingTrap'));
for(var i=0;i<hpems.length;i++){
if(hpems.length>1){
formMgr.setCurrentEnclosureName(hpems[i].getEnclosureName());
}
for(var j=0;j<trapsToRemove.length;j++){
if(trapsToRemove[j].version==1){
if(hpems[i].getActiveFirmwareVersion()>=2.10){
formMgr.queueCall(hpems[i].removeSnmpTrapReceiverEx,[trapsToRemove[j].ipAddress,trapsToRemove[j].community],[],['230']);
}else{
formMgr.queueCall(hpems[i].removeSnmpTrapReceiver,[trapsToRemove[j].ipAddress],[],['230']);
}
}else if(trapsToRemove[j].version==3){
formMgr.queueCall(hpems[i].removeSnmpTrapReceiver3,[trapsToRemove[j].ipAddress,trapsToRemove[j].user,trapsToRemove[j].engineid],[],['230']);
}
}
}
formMgr.endBatch();
}
}
function toggleTrapFormEnabled(enabled){
var ipText=document.getElementById('IPAddress');
var communityText=document.getElementById('destinationString');
if(enabled){
ourButtonManager.enableButtonById('ipTransfer_Add');
ourButtonManager.enableButtonById('ipTransfer_Remove');
ipText.removeAttribute('disabled');
communityText.removeAttribute('disabled');
}else{
ourButtonManager.disableButtonById('ipTransfer_Add');
ourButtonManager.disableButtonById('ipTransfer_Remove');
ipText.setAttribute('disabled','true');
communityText.setAttribute('disabled','true');
}
}
function addSnmpUser(){
return doAddSnmpUser([hpem],null);
}
function doAddSnmpUser(hpems,successFcn){
ourInputValidator.clearMessages();
var validated=false;
if(ourInputValidator.allInputsValidate()){
var username=getInputValue("username");
var authPassphrase=getInputValue("authPassphrase");
var authAlgorithm=getInputValue("authAlgorithm");
var privPassphrase=getInputValue("privPassphrase");
var privAlgorithm=getInputValue("privAlgorithm");
var minimumSecurity=getInputValue("minimumSecurity");
var readWrite=getInputValue("accessMode")==1;
var engineId=getInputValue("engineid");
user=username;
var formMgr=new FormManager(function(success){
if(success){
if(successFcn!=null){
successFcn(success);
}
}
},false,'errorDisplay',getContainerID(),'waitContainer');
formMgr.createWaitContainer(top.getString('addingSnmpUser'));
formMgr.batchEventDelay=3;
formMgr.startBatch();
for(var i=0;i<hpems.length;i++){
if(hpems.length>1){
formMgr.setCurrentEnclosureName(hpems[i].getEnclosureName());
}
formMgr.queueCall(hpems[i].addSnmpUser,[username,authAlgorithm,authPassphrase,privAlgorithm,privPassphrase,engineId,minimumSecurity,readWrite]);
}
formMgr.endBatch();
validated=true;
}else{
ourInputValidator.updateMessages(true);
ourInputValidator.autoFocus();
}
return validated;
}
function checkListPopulated(){
var selectedAddresses=document.getElementById('selectedAddresses');
if(selectedAddresses){
if(selectedAddresses.options.length>0){
ourButtonManager.enableButtonById('ipTransfer_Remove');
}else{
ourButtonManager.disableButtonById('ipTransfer_Remove');
}
}
}
function getSelectedSnmpUsers(){
var selectedObjects=new Array();
var userOverviewTable=document.getElementById('snmpUserTable');
if(userOverviewTable){
inputCollection=userOverviewTable.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
if(inputCollection[i].checked&&inputCollection[i].getAttribute('secObjId')){
var secObjId=inputCollection[i].getAttribute('secObjId');
var secObjEngineId=inputCollection[i].getAttribute('secObjEngineId');
var user=new Object();
user.username=secObjId;
user.engineid=secObjEngineId;
selectedObjects.push(user);
}
}
}
return selectedObjects;
}
function deleteSnmpUsers(callback){
doDeleteSnmpUsers([hpem],callback);
}
function doDeleteSnmpUsers(hpems,successFcn){
var users=getSelectedSnmpUsers();
if(users.length>0){
var confirmString=top.getString('reallyDeleteSnmpUsers');
if(confirm(confirmString)){
var formMgr=new FormManager(function(success){
if(isFunction(successFcn)){
successFcn(success);
}
},false,'errorDisplay',getContainerID(),'waitContainer');
formMgr.createWaitContainer(top.getString('deletingSnmpUsers'));
formMgr.startBatch();
for(var j=0;j<hpems.length;j++){
if(hpems.length>1){
formMgr.setCurrentEnclosureName(hpems[j].getEnclosureName());
}
for(var i=0;i<users.length;i++){
formMgr.queueCall(hpems[j].removeSnmpUser,[users[i].username,users[i].engineid]);
}
}
formMgr.endBatch();
}
}else{
containerCheckboxToggle('snmpUserContainer',false);
}
}
function getSelectedSnmpTraps(){
var selectedObjects=new Array();
var userOverviewTable=document.getElementById('snmpTrapTable');
if(userOverviewTable){
inputCollection=userOverviewTable.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
if(inputCollection[i].checked&&inputCollection[i].getAttribute('secObjVersion')){
var dest=new AlertDestination();
var ver=inputCollection[i].getAttribute('secObjVersion');
if(ver=='v1'){
dest.version=1;
dest.community=inputCollection[i].getAttribute('secObjCommunity');
dest.ipAddress=inputCollection[i].getAttribute('secObjHost');
}else{
dest.version=3;
dest.user=inputCollection[i].getAttribute('secObjUser');
dest.engineid=inputCollection[i].getAttribute('secObjEngineId');
dest.ipAddress=inputCollection[i].getAttribute('secObjHost');
}
selectedObjects.push(dest);
}
}
}
return selectedObjects;
}
function enableSNMPv3Controls(enable){
toggleFormEnabled('snmpv1_container_1',!enable);
toggleFormEnabled('snmpv3_container_1',enable);
toggleFormEnabled('snmpv3_container_2',enable);
toggleFormEnabled('snmpv3_container_3',enable);
}
function snmpUpdatePageTitle(){
var enclosureName=top.getTopology().getProxy(encNum).getEnclosureName();
if(enclosureName==null||enclosureName==''){
top.mainPage.setMainTitle(enclosureName);
}else{
top.mainPage.setMainTitle(top.getString('enclosureSettings')+' - '+enclosureName);
}
}
function updateSnmpTables(hpemObj,userTableId,trapTableId){
var selectedHpem=(hpemObj?hpemObj:top.getTopology().getProxyLocal());
var userTable=document.getElementById(userTableId);
var trapTable=document.getElementById(trapTableId);
if(trapTable||userTable){
var formMgr=new FormManager(function(success){
if(success){
var snmpInfo=formMgr.getDataByCallName("getSnmpInfo");
var snmpInfo3=formMgr.getDataByCallName("getSnmpInfo3");
var netInfo=formMgr.getDataByCallName("getEnclosureNetworkInfo");
var isWizard=(""+selectedHpem.getIsWizardSelected());
if(trapTable){
var processor=new XsltProcessor('../Templates/snmpTrapExternalTable.xsl');
processor.addParameter('snmpInfo3Doc',snmpInfo3);
processor.addParameter('snmpInfoDoc',snmpInfo);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('serviceUserAcl',selectedHpem.getUserAccessLevel());
processor.addParameter('snmpv3Supported',(""+selectedHpem.hasSNMPv3()));
processor.addParameter('testSupported',(selectedHpem.getActiveFirmwareVersion()>=2.10));
processor.addParameter('networkInfoDoc',netInfo);
processor.addParameter('isWizard',isWizard);
trapTable.innerHTML=processor.getOutput();
}
if(userTable){
var processor=new XsltProcessor('../Templates/snmpUsersTableExternal.xsl');
processor.addParameter('snmpInfo3Doc',snmpInfo3);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('serviceUserAcl',selectedHpem.getUserAccessLevel());
processor.addParameter('networkInfoDoc',netInfo);
processor.addParameter('isWizard',isWizard);
userTable.innerHTML=processor.getOutput();
}
reconcilePage();
}
});
formMgr.startTransactionBatch();
formMgr.queueCall(selectedHpem.getSnmpInfo)
formMgr.queueCall(selectedHpem.getEnclosureNetworkInfo);
if(selectedHpem.getActiveFirmwareVersion()>=3.80){
formMgr.queueCall(selectedHpem.getSnmpInfo3);
}
formMgr.endBatch();
}
};
function getAlertDestinations(hpemObj){
if(hpemObj){
var v1Traps=getArrayXpath(hpemObj.getSnmpInfo(),"//hpoa:trapInfo/hpoa:ipAddress");
var v3Traps=(hpemObj.hasSNMPv3()?getArrayXpath(hpemObj.getSnmpInfo3(),"//hpoa:trapInfo/hpoa:ipAddress"):[]);
return(v1Traps.concat(v3Traps).toString().replace(/,/g,"\n"));
}
return "";
};
