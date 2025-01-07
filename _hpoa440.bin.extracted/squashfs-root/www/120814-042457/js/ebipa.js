/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function EbipaBay(){
this.bayNumber=0;
this.enabled=false;
this.ipAddress='';
this.netmask='';
this.gateway='';
this.dns1='';
this.dns2='';
this.dns3='';
this.ntp1='';
this.ntp2='';
}
function getDeviceBayList(hpems,sides){
var domBuilder=new DomBuilder();
domBuilder.addDocument("enclosureBayList",['xmlns:'+OA_NAMESPACE(),OA_NAMESPACE_URI()]);
for(var k=0;k<hpems.length;k++){
var hpem=hpems[k];
domBuilder.appendChild("enclosure",['encNum',hpem.getEnclosureNumber(),'encName',hpem.getEnclosureName(),'uuid',hpem.getUuid(),'encType',hpem.getEnclosureType(),'isTower',''+hpem.getIsTower(),'vlanEnabled',vlanEnabled]);
for(var i=0;i<sides.length;i++){
var offset=0+16*sides[i];
var bayCount=hpem.getNumBays();
var ebipaInfo=hpem.getEbipaDevInfo(null,false);
var vlanInfoDoc=hpem.getVlanInfo();
var vlanEnabled=getElementValueXpath(vlanInfoDoc,'//hpoa:vlanInfo/hpoa:vlanEnable');
var side=1;
for(var j=1;j<=bayCount;j++){
var bay=j+offset;
var mpInfo=hpem.getBladeMpInfo(bay);
var bladeInfo=hpem.getBladeInfo(bay);
var bayDisplayNumber='';
var ipAddress='';
var presence='';
var bladeType='';
var productId='';
var vlanId='';
var normalizedBayNumber='';
if(mpInfo!=null){
ipAddress=getElementValueXpath(mpInfo,'//hpoa:bladeMpInfo/hpoa:ipAddress');
}
if(bladeInfo!=null){
bayDisplayNumber=getElementValueXpath(bladeInfo,"//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']");
presence=getElementValueXpath(bladeInfo,'//hpoa:bladeInfo/hpoa:presence');
bladeType=getElementValueXpath(bladeInfo,'//hpoa:bladeInfo/hpoa:bladeType');
productId=getElementValueXpath(bladeInfo,'//hpoa:bladeInfo/hpoa:productId');
normalizedBayNumber=getElementValueXpath(bladeInfo,"//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='NormalizedBayNumber']");
}
if(vlanInfoDoc!=null){
vlanId=getElementValueXpath(vlanInfoDoc,'//hpoa:vlanInfo/hpoa:portArray/hpoa:port[@hpoa:deviceType="SERVER" and @hpoa:bayNumber='+normalizedBayNumber+']/hpoa:portVlanId');
}
var attributes=[
'number',bay,
'currentIp',ipAddress,
'presence',presence,
'bladeType',bladeType,
'bayDisplayNumber',bayDisplayNumber,
'productId',productId,
'vlanId',vlanId
];
var bayNode=domBuilder.appendChild("bay",attributes,'','//enclosure[@encNum='+hpem.getEnclosureNumber()+']');
var ebipaBayInfoNode=getElementValueXpath(ebipaInfo,'//hpoa:ebipaInfo/hpoa:deviceBays/hpoa:bay[hpoa:bayNumber='+bay+']',true);
if(ebipaBayInfoNode){
bayNode.appendChild(ebipaBayInfoNode.cloneNode(true));
}
}
}
}
return domBuilder.getDocument();
}
function getInterconnectBayList(hpems){
var domBuilder=new DomBuilder();
domBuilder.addDocument("enclosureBayList");
for(var i=0;i<hpems.length;i++){
var bayCount=hpems[i].getNumTrays();
var ebipaInfo=hpems[i].getEbipaDevInfo(null,false);
domBuilder.appendChild("enclosure",['encNum',hpems[i].getEnclosureNumber(),'encName',hpems[i].getEnclosureName(),'uuid',hpems[i].getUuid(),'encType',hpems[i].getEnclosureType(),'isTower',''+hpems[i].getIsTower()]);
for(var j=1;j<=bayCount;j++){
var interconnectInfo=hpems[i].getInterconnectTrayInfo(j);
var interconnectStatus=hpems[i].getInterconnectTrayStatus(j);
var ipAddress='';
var presence='';
var trayType='';
if(interconnectInfo!=null){
trayType=getElementValueXpath(interconnectInfo,'//hpoa:interconnectTrayInfo/hpoa:interconnectTrayType');
var extendedType=getElementValueXpath(interconnectInfo,'//hpoa:interconnectTrayInfo/hpoa:extraData[@hpoa:name="ExtendedFabricType"]');
if(extendedType!=null&&extendedType!=''){
trayType=extendedType;
}
ipAddress=getElementValueXpath(interconnectInfo,'//hpoa:interconnectTrayInfo/hpoa:inBandIpAddress');
if(ipAddress==''){
ipAddress=top.getString('n/a');
}
}
if(interconnectStatus!=null){
presence=getElementValueXpath(interconnectStatus,'//hpoa:interconnectTrayStatus/hpoa:presence');
}
var attributes=[
'number',j,
'currentIp',ipAddress,
'presence',presence,
'trayType',trayType,
'bayDisplayNumber',j
];
var bayNode=domBuilder.appendChild("bay",attributes,'','//enclosure[@encNum='+hpems[i].getEnclosureNumber()+']');
var ebipaBayInfoNode=getElementValueXpath(ebipaInfo,'//hpoa:ebipaInfo/hpoa:interconnectBays/hpoa:bay[hpoa:bayNumber='+j+']',true);
if(ebipaBayInfoNode){
bayNode.appendChild(ebipaBayInfoNode.cloneNode(true));
}
}
}
return domBuilder.getDocument();
}
function getAddressList(beginAddress,addressCount,netmask,callback){
var hpem=top.getTopology().getProxyLocal();
var addressList=new Array();
if(hpem){
toggleEbipaListEnabled(false);
hpem.getEbipaAddressList(beginAddress,netmask,getXmlBayArray(getAllArray(1,addressCount)),function(result){
toggleEbipaListEnabled(true);
var responseElement=getElementValueXpath(result,'//hpoa:getEbipaAddressListResponse',true);
for(var i=0;i<responseElement.childNodes.length;i++){
if(responseElement.childNodes[i].nodeType==1&&responseElement.childNodes[i].firstChild!=null){
var address=responseElement.childNodes[i].firstChild.nodeValue;
if(address=="255.255.255.255"){
address=top.getString('invalidIpAddress');
}
addressList.push(address);
}
}
callback(addressList);
});
}
}
function toggleEbipaListEnabled(enabled){
if(document.getElementById('ebipaDeviceSummary')){
toggleFormEnabled('ebipaDeviceSummary',enabled);
}else if(document.getElementById('ebipaInterconnectSummary')){
toggleFormEnabled('ebipaInterconnectSummary',enabled);
}
}
function transformDeviceList(hpems,sides,serviceUserAcl){
var processor=new XsltProcessor('../Forms/EbipaList.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('bayListDoc',getDeviceBayList(hpems,sides));
processor.addParameter('deviceType','server');
processor.addParameter('invalidIpString',top.getString('invalidIpAddress'));
if(typeof(serviceUserAcl)!='undefined'){
processor.addParameter('serviceUserAcl',serviceUserAcl);
}
document.getElementById('ebipaDeviceListContainer').innerHTML=processor.getOutput();
}
function transformInterconnectList(hpems,serviceUserAcl){
var processor=new XsltProcessor('../Forms/EbipaList.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('bayListDoc',getInterconnectBayList(hpems));
processor.addParameter('deviceType','interconnect');
processor.addParameter('invalidIpString',top.getString('invalidIpAddress'));
if(typeof(serviceUserAcl)!='undefined'){
processor.addParameter('serviceUserAcl',serviceUserAcl);
}
document.getElementById('ebipaInterconnectListContainer').innerHTML=processor.getOutput();
}
function checkRangeValid(containerId){
var ebipaTable=document.getElementById(containerId);
var rangeValid=true;
var invalidAddressString=top.getString('invalidIpAddress');
if(ebipaTable){
var inputCollection=ebipaTable.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var input=inputCollection[i];
if(input.getAttribute('type')&&input.getAttribute('type')=='text'){
if(input.value==invalidAddressString){
rangeValid=false;
break;
}
}
}
}
else{
rangeValid=false;
}
return rangeValid;
}
function checkRangeValidDevice(){
return checkRangeValid('ebipaDeviceSummary');
}
function checkRangeValidInterconnect(){
return checkRangeValid('ebipaInterconnectSummary');
}
function toggleBayFormEnabled(deviceType,encNum,bayNumber,enabled){
var addressWrapperId='enc'+encNum+deviceType+bayNumber+'AddressWrapper';
var fieldTextId='enc'+encNum+deviceType+bayNumber+'EbipaBayAddress';
var autofillImgId='enc'+encNum+deviceType+bayNumber+'AutofillImage';
if(deviceType=='server'){
var containerId='ebipaDeviceSummary';
}
else{
var containerId='ebipaInterconnectSummary';
}
toggleAutofillImg(containerId,encNum,bayNumber,deviceType);
}
function getEbipaBayList(summaryTableId,encUuid){
var bayList=new Array();
var enclosureAddressLists=new Object();
var summaryTable=document.getElementById(summaryTableId);
if(summaryTable){
var tbodyCollection=summaryTable.getElementsByTagName('tbody');
for(var i=0;i<tbodyCollection.length;i++){
var tbody=tbodyCollection[i];
var uuid=tbody.getAttribute('encUuid');
if((tbody&&uuid)&&(uuid==encUuid)){
var rowCollection=tbody.getElementsByTagName('tr');
for(var j=0;j<rowCollection.length;j++){
if(rowCollection[j].getAttribute('bayNumber')){
var row=rowCollection[j];
var bayNumber=row.getAttribute('bayNumber');
var inputCollection=row.getElementsByTagName('input');
var bay=new EbipaBay();
bay.bayNumber=bayNumber;
for(var k=0;k<inputCollection.length;k++){
var input=inputCollection[k];
if(input.getAttribute('id').indexOf('EbipaBayEnabled')>-1){
bay.enabled=input.checked;
}else if(input.getAttribute('id').indexOf('EbipaBayAddress')>-1){
bay.ipAddress=input.value;
}else if(input.getAttribute('id').indexOf('EbipaNetmask')>-1){
bay.netmask=input.value;
}else if(input.getAttribute('id').indexOf('EbipaGateway')>-1){
bay.gateway=input.value;
}else if(input.getAttribute('id').indexOf('EbipaDomain')>-1){
bay.domain=input.value;
}else if(input.getAttribute('id').indexOf('EbipaDns1')>-1){
bay.dns1=input.value;
}else if(input.getAttribute('id').indexOf('EbipaDns2')>-1){
bay.dns2=input.value;
}else if(input.getAttribute('id').indexOf('EbipaDns3')>-1){
bay.dns3=input.value;
}else if(input.getAttribute('id').indexOf('EbipaNtp1')>-1){
bay.ntp1=input.value;
}else if(input.getAttribute('id').indexOf('EbipaNtp2')>-1){
bay.ntp2=input.value;
}
}
bayList.push(bay);
}
}
}
}
}
return bayList;
}
function getEbipaConfig(hpemObj,encUuid){
var devInfo=hpemObj.getEbipaDevInfo(null,false).cloneNode(true);
var tableIds=['ebipaDeviceSummary','ebipaInterconnectSummary'];
for(var i=0;i<tableIds.length;i++){
var bayList=getEbipaBayList(tableIds[i],encUuid);
if(bayList.length==0){
continue;
}
for(var j=0;j<bayList.length;j++){
var bayObj=bayList[j];
var finalize=(j==bayList.length-1)?true:false;
var dev_element=(tableIds[i].indexOf('ebipaDevice')>-1)?'deviceBays':'interconnectBays';
var xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:ipAddress';
setNodeValueXpath(devInfo,xpath,bayObj.ipAddress,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:enabled';
setNodeValueXpath(devInfo,xpath,(bayObj.enabled)?'true':'false',false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:netmask';
setNodeValueXpath(devInfo,xpath,bayObj.netmask,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:gateway';
setNodeValueXpath(devInfo,xpath,bayObj.gateway,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:domain';
setNodeValueXpath(devInfo,xpath,bayObj.domain,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:dns1';
setNodeValueXpath(devInfo,xpath,bayObj.dns1,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:dns2';
setNodeValueXpath(devInfo,xpath,bayObj.dns2,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:dns3';
setNodeValueXpath(devInfo,xpath,bayObj.dns3,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:ntp1';
setNodeValueXpath(devInfo,xpath,bayObj.ntp1,false);
xpath='//hpoa:ebipaInfo/hpoa:'+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:ntp2';
setNodeValueXpath(devInfo,xpath,bayObj.ntp2,finalize);
}
}
return getElementValueXpath(devInfo,'//hpoa:ebipaInfo',true);
}
function hasEnabledBays(bayPrefix){
var tableId='';
var hasEnabled=false;
if(bayPrefix=='svb'){
tableId='ebipaDeviceSummary';
}
else if(bayPrefix=='swm'){
tableId='ebipaInterconnectSummary';
}
var container=document.getElementById(tableId);
if(container){
var inputCollection=container.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var input=inputCollection[i];
if(input.getAttribute('type')&&input.getAttribute('type')=='checkbox'){
if(input.checked){
hasEnabled=true;
break;
}
}
}
}
else{
}
return hasEnabled;
}
function toggleAutofillImg(containerId,encNum,bayNumber,deviceType){
var container=document.getElementById(containerId);
if(container){
var imgId='enc'+encNum+deviceType+bayNumber+'AutofillImage';
var imgCollection=container.getElementsByTagName('img');
for(var i=0;i<imgCollection.length;i++){
var img=imgCollection[i];
var curId=img.getAttribute('id');
var curSrc=img.src;
if(curSrc&&curSrc.indexOf('icon_tray_expand')>-1){
if(curId==imgId){
var inputId=img.getAttribute('relatedInputId');
var enclosureCount=img.getAttribute('enclosureCount');
var relatedInput=document.getElementById(inputId);
if(relatedInput){
if(relatedInput.getAttribute('readonly')){
break;
}
if(relatedInput.getAttribute('disabled')&&relatedInput.getAttribute('disabled').toString()=='true'){
img.src='/120814-042457/images/icon_tray_expand_down.gif';
img.className='autoFillDisabled';
img.alt=''
img.onclick=null;
}
else{
img.src='/120814-042457/images/icon_tray_expand_down_filled.gif';
img.className='autoFill';
img.alt='Automatically fill addresses down'
img.onclick=function(){
doAutoFill(containerId,encNum,bayNumber,deviceType);
};
}
}
break;
}
}
}
}
}
function doAutoFill(containerId,encNum,bayNumber,deviceType,enclosureCount){
var container=document.getElementById(containerId);
var ipMgr=new IPv4Manager();
var beginInputId='enc'+encNum+deviceType+bayNumber+'EbipaBayAddress';
var netmaskInputId='enc'+encNum+deviceType+bayNumber+'EbipaNetmask';
if(typeof(enclosureCount)=='undefined'){
enclosureCount=7;
}
if(!container){
return;
}
if(!confirm(top.getString('confirmAutofill')))
return;
var netmaskInput=document.getElementById(netmaskInputId);
if(!netmaskInput){
alert(top.getString('invalidNetmask'));
return;
}
netmaskValue=netmaskInput.value;
if(!ipMgr.isValidNetmask(netmaskValue)){
alert(top.getString('invalidNetmask'));
return;
}
var inputCollection=container.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var input=inputCollection[i];
if(input.getAttribute('type')=='text'){
if(input.getAttribute('id')==beginInputId){
var beginAddress=input.value;
if(!isValidIPAddress(beginAddress)){
alert(top.getString('invalidIpMessage'));
try{
document.getElementById(beginInputId).focus();
document.getElementById(beginInputId).select();
}catch(e){}
return;
}
var addressCount=EM_MAX_BLADE_ARRAY()*enclosureCount;
toggleFormEnabled(containerId,false);
getAddressList(beginAddress,addressCount,netmaskValue,function(list){
toggleFormEnabled(containerId,true);
autoFillCallback(containerId,encNum,bayNumber,deviceType,list);
});
}
}
}
}
function autoFillCallback(containerId,encNum,bayNumber,deviceType,addressList){
var beginAddressId='enc'+encNum+deviceType+bayNumber+'EbipaBayAddress';
var netmaskInputId='enc'+encNum+deviceType+bayNumber+'EbipaNetmask';
var gatewayInputId='enc'+encNum+deviceType+bayNumber+'EbipaGateway';
var domainInputId='enc'+encNum+deviceType+bayNumber+'EbipaDomain';
var dnsInput1Id='enc'+encNum+deviceType+bayNumber+'EbipaDns1';
var dnsInput2Id='enc'+encNum+deviceType+bayNumber+'EbipaDns2';
var dnsInput3Id='enc'+encNum+deviceType+bayNumber+'EbipaDns3';
var ntpInput1Id='enc'+encNum+deviceType+bayNumber+'EbipaNtp1';
var ntpInput2Id='enc'+encNum+deviceType+bayNumber+'EbipaNtp2';
var netmaskValue=document.getElementById(netmaskInputId).value;
var gatewayValue=document.getElementById(gatewayInputId).value;
var domainValue=document.getElementById(domainInputId).value;
var dns1Value=document.getElementById(dnsInput1Id).value;
var dns2Value=document.getElementById(dnsInput2Id).value;
var dns3Value=document.getElementById(dnsInput3Id).value;
var ntp1Value='';
var ntp2Value='';
if(document.getElementById(ntpInput1Id)){
ntp1Value=document.getElementById(ntpInput1Id).value
}
if(document.getElementById(ntpInput2Id)){
ntp2Value=document.getElementById(ntpInput2Id).value
}
var found=false;
var addr_index=1;
var container=document.getElementById(containerId);
if(!container)
return;
var rowCollection=container.getElementsByTagName('tr');
for(var i=0;i<rowCollection.length;i++){
if(!found){
var inputs=rowCollection[i].getElementsByTagName('input');
for(var j=0;j<inputs.length;j++){
var inputId=inputs[j].getAttribute('id');
if(inputId==beginAddressId){
found=true;
break;
}
}
}else{
var inputs=rowCollection[i].getElementsByTagName('input');
for(var j=0;j<inputs.length;j++){
var inputId=inputs[j].getAttribute('id');
if(inputId.indexOf('EbipaGateway')>-1){
inputs[j].value=gatewayValue;
}else if(inputId.indexOf('EbipaDomain')>-1){
inputs[j].value=domainValue;
}else if(inputId.indexOf('EbipaNetmask')>-1){
inputs[j].value=netmaskValue;
}else if(inputId.indexOf('EbipaDns1')>-1){
inputs[j].value=dns1Value;
}else if(inputId.indexOf('EbipaDns2')>-1){
inputs[j].value=dns2Value;
}else if(inputId.indexOf('EbipaDns3')>-1){
inputs[j].value=dns3Value;
}else if(inputId.indexOf('EbipaBayAddress')>-1){
inputs[j].value=addressList[addr_index];
addr_index++;
}else if(inputId.indexOf('EbipaNtp1')>-1){
inputs[j].value=ntp1Value;
}else if(inputId.indexOf('EbipaNtp2')>-1){
inputs[j].value=ntp2Value;
}
}
}
}
}
function displayWarnings(warningArray,errorID,enclosureName){
var errorStringArray=new Array();
var htmlString="";
var errorString="";
var processor=new XsltProcessor('../Templates/statusIconExternal.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('statusCode','OP_STATUS_OK');
errorString=processor.getOutput();
errorString+='&nbsp;'+top.getString('genericSuccessMessage');
errorStringArray.push(errorString);
errorStringArray.push(top.getString('EM_ERR_DUP_BAY_IPADDRESS'));
for(var i=0;i<warningArray.length;i++){
for(var prop in warningArray[i].MaskCodes()){
if(warningArray[i].Warnings&warningArray[i].MaskCodes()[prop]){
prop=prop.replace("EM_ERR_EBIPA_BAY","EM_ERR_DUP_BAY");
var errString='';
if(warningArray[i].EnclosureDescription!=''){
errString+=warningArray[i].EnclosureDescription+' - ';
}
errString+=top.getString(prop);
errorStringArray.push(errString==""?"Bitmask code: "+prop:errString);
}
}
}
for(var i=0;i<errorStringArray.length;i++){
htmlString+=errorStringArray[i];
if(i!=errorStringArray.length-1){
htmlString+='<br />';
}
}
document.getElementById(errorID).innerHTML=htmlString;
document.getElementById(errorID).className='warningDisplay';
document.getElementById(errorID).style.display='block';
}
function WarningObject(warnings,maskCodes,enclosureDescription){
this.Warnings=warnings;
this.MaskCodes=maskCodes;
this.EnclosureDescription=enclosureDescription;
}
