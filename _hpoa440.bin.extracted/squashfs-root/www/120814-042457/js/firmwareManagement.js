/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function getBaySelectionDOM(){
var xml=top.getXml();
var baySelection=xml.parseXML('<hpoa:baySelection xmlns:hpoa="hpoa.xsd" />');
var oaSelect=document.getElementById('oaSelect');
if(oaSelect){
var oaAccessElement=baySelection.createElement('hpoa:oaAccess');
var oaAccessValue=baySelection.createTextNode(''+oaSelect.checked);
oaAccessElement.appendChild(oaAccessValue);
baySelection.documentElement.appendChild(oaAccessElement);
}
var bladeBaysElement=baySelection.createElement('hpoa:bladeBays');
var baySelectContainer=document.getElementById('svbSelectEnc'+encNum);
if(baySelectContainer){
svbSelections=new Array();
var inputCollection=baySelectContainer.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var currentInput=inputCollection[i];
if(currentInput.getAttribute('type')=='checkbox'&&currentInput.getAttribute('bayId')){
var bayNum=currentInput.getAttribute('bayId');
svbSelections[bayNum]=currentInput.checked;
}
}
for(var i=0;i<svbSelections.length;i++){
if(svbSelections[i]!=null){
var bladeDoc=xml.parseXML('<hpoa:blade xmlns:hpoa="hpoa.xsd" />');
var bayNumElement=bladeDoc.createElement('hpoa:bayNumber');
var bayNumValue=bladeDoc.createTextNode(''+i);
bayNumElement.appendChild(bayNumValue);
var bayAccessElement=bladeDoc.createElement('hpoa:access');
var bayAccessValue=bladeDoc.createTextNode(''+svbSelections[i]);
bayAccessElement.appendChild(bayAccessValue);
bladeDoc.documentElement.appendChild(bayNumElement);
bladeDoc.documentElement.appendChild(bayAccessElement);
bladeBaysElement.appendChild(bladeDoc.documentElement.cloneNode(true));
}
}
}
baySelection.documentElement.appendChild(bladeBaysElement);
baySelectContainer=document.getElementById('swmSelectEnc'+encNum);
var swmBaysElement=baySelection.createElement('hpoa:interconnectTrayBays');
if(baySelectContainer){
swmSelections=new Array();
var inputCollection=baySelectContainer.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var currentInput=inputCollection[i];
if(currentInput.getAttribute('type')=='checkbox'&&currentInput.getAttribute('bayId')){
var bayNum=currentInput.getAttribute('bayId');
swmSelections[bayNum]=currentInput.checked;
}
}
for(var i=0;i<swmSelections.length;i++){
if(swmSelections[i]!=null){
var swmDoc=xml.parseXML('<hpoa:interconnectTray xmlns:hpoa="hpoa.xsd" />');
var bayNumElement=swmDoc.createElement('hpoa:bayNumber');
var bayNumValue=swmDoc.createTextNode(''+i);
bayNumElement.appendChild(bayNumValue);
var bayAccessElement=swmDoc.createElement('hpoa:access');
var bayAccessValue=swmDoc.createTextNode(''+swmSelections[i]);
bayAccessElement.appendChild(bayAccessValue);
swmDoc.documentElement.appendChild(bayNumElement);
swmDoc.documentElement.appendChild(bayAccessElement);
swmBaysElement.appendChild(swmDoc.documentElement.cloneNode(true));
}
}
}
baySelection.documentElement.appendChild(swmBaysElement);
return baySelection.documentElement.cloneNode(true);
}
function hasSelections(){
var baySelectContainer=document.getElementById('svbSelectEnc'+encNum);
if(baySelectContainer){
var inputCollection=baySelectContainer.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var currentInput=inputCollection[i];
if(currentInput.getAttribute('type')=='checkbox'&&currentInput.getAttribute('bayId')){
if(currentInput.checked)
return true;
}
}
}
baySelectContainer=document.getElementById('swmSelectEnc'+encNum);
if(baySelectContainer){
var inputCollection=baySelectContainer.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var currentInput=inputCollection[i];
if(currentInput.getAttribute('type')=='checkbox'&&currentInput.getAttribute('bayId')){
if(currentInput.checked)
return true;
}
}
}
return false;
}
function doManualDiscoveryOrUpdate(action){
var confirmString='';
var startMessage='';
if(action=='DISCOVERY'){
confirmString=top.getString('discConfirm')+'\n\n'+top.getString('efmSupportNotice')+'\n\n'+top.getString('clickOkToContinue');
startMessage=top.getString('startingDisc');
}else{
confirmString=top.getString('warningUpdateConfirm')+'\n\n'+top.getString('efmSupportNotice')+'\n\n'+top.getString('clickOkToContinue');
startMessage=top.getString('startingUpdate');
}
if(!hasSelections()){
alert(top.getString('noDeviceSelected'));
return;
}
if(!confirm(confirmString)){
return;
}
var tabContent=document.getElementById('tabContent');
var baySelection=getBaySelectionDOM();
var formMgr=new FormManager(function(success){
if(success){
var processor=new XsltProcessor('../Templates/firmwareMgmtErrors.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('errorsDoc',formMgr.getDataByCallIndex(0));
var errorContainer=document.getElementById('errorDisplay');
errorContainer.innerHTML=processor.getOutput();
errorContainer.style.display='block';
}
},false,'errorDisplay',(tabContent?'tabContent':'bodyContent'),'waitContainer');
formMgr.createWaitContainer(startMessage);
formMgr.startBatch();
if(action=='DISCOVERY'){
formMgr.queueCall(hpem.bladeManualDiscovery,[baySelection]);
}else{
formMgr.queueCall(hpem.bladeManualUpdate,[baySelection]);
}
formMgr.endBatch();
}
function doManualUpdate(){
if(!hasSelections()){
alert(top.getString('noDeviceSelected'));
return;
}
var confirmString=top.getString('warningUpdateConfirm')+'\n\n'+top.getString('efmSupportNotice')+'\n\n'+top.getString('clickOkToContinue');
if(!confirm(confirmString)){
return;
}
var baySelection=getBaySelectionDOM();
var formMgr=new FormManager(function(success){
if(success){
alert(top.getString('updateStarted'));
}
},false,'errorDisplay','tabContent');
formMgr.createWaitContainer(top.getString('startingUpdate'));
formMgr.startBatch();
formMgr.queueCall(hpem.bladeManualUpdate,[baySelection]);
formMgr.endBatch();
}
function setBayInclusion(){
var baySelection=getBaySelectionDOM();
var formMgr=new FormManager(function(success){
if(success){
location='/120814-042457/html/encFirmwareManagement.html?encNum='+encNum;
}
},false,'','tabContent');
formMgr.createWaitContainer(top.getString('applyingIncBays'));
formMgr.startBatch();
formMgr.queueCall(hpem.setFirmwareManagementBays,[baySelection]);
formMgr.endBatch();
}
function updateCheckboxes(){
var inputCollection=document.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var input=inputCollection[i];
if(input.getAttribute('type')!='checkbox')
continue;
if(input.getAttribute('type')=='checkbox'&&input.getAttribute('bayId')){
var bayNumber=parseInt(input.getAttribute('bayId'));
if(bayNumber>16){
input.setAttribute('disabled','true');
}
if(bayNumber<=16){
input.onclick=new Function('toggle2xBaysEnabled('+bayNumber+')');
}
}
}
}
function toggle2xBaysEnabled(baseBayNum){
var sideABay=baseBayNum+16;
var sideBBay=baseBayNum+32;
var checked=false;
var inputCollection=document.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var input=inputCollection[i];
if(input.getAttribute('type')!='checkbox')
continue;
if(input.getAttribute('type')=='checkbox'&&input.getAttribute('bayId')){
var bayId=parseInt(input.getAttribute('bayId'));
if(bayId==baseBayNum){
checked=input.checked;
}
if(bayId==sideABay||bayId==sideBBay){
input.checked=checked;
}
}
}
}
