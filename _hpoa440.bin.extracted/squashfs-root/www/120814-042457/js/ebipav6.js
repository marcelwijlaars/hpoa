/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function Ebipav6Bay(){
this.bayNumber=0;
this.enabled=false;
this.ipAddress='';
this.domain='';
this.dns1='';
this.dns2='';
this.dns3='';
}
function getDevicev6BayCurrentIPv6Address(mpInfo){
var addrList=['iLOIPv6EBIPAAddress','iLOIPv6DHCPAddress1','iLOIPv6SLAACAddress1','iLOIPv6StaticAddress1','iLOIPv6LLAddress'];
var ipAddress='::';
for(var i=0;i<addrList.length;i++){
var xPath='//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name = "'+addrList[i]+'"]';
ipAddress=getElementValueXpath(mpInfo,xPath);
if(!_isIPv6AddressZero(ipAddress))
break;
}
if(_isIPv6AddressZero(ipAddress)){
ipAddress=top.getString('n/a');
}
else{
var mySplitAddr=ipAddress.split("/");
return mySplitAddr[0];
}
return ipAddress;
}
function getDevicev6BayList(hpems,sides){
var domBuilder=new DomBuilder();
domBuilder.addDocument("enclosureBayList",['xmlns:'+OA_NAMESPACE(),OA_NAMESPACE_URI()]);
for(var k=0;k<hpems.length;k++){
var hpem=hpems[k];
domBuilder.appendChild("enclosure",['encNum',hpem.getEnclosureNumber(),'encName',hpem.getEnclosureName(),'uuid',hpem.getUuid(),'encType',hpem.getEnclosureType(),'isTower',''+hpem.getIsTower(),'vlanEnabled',vlanEnabled]);
for(var i=0;i<sides.length;i++){
var offset=0+16*sides[i];
var bayCount=hpem.getNumBays();
var ebipav6Info=(hpem.getActiveFirmwareVersion()>=4.20?hpem.getEbipav6InfoEx(null,false):hpem.getEbipav6Info(null,false));
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
ipAddress=getDevicev6BayCurrentIPv6Address(mpInfo);
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
'currentIpv6',ipAddress,
'presence',presence,
'bladeType',bladeType,
'bayDisplayNumber',bayDisplayNumber,
'productId',productId,
'vlanId',vlanId
];
var bayNode=domBuilder.appendChild("bay",attributes,'','//enclosure[@encNum='+hpem.getEnclosureNumber()+']');
var ebipav6BayInfoNode=getElementValueXpath(ebipav6Info,'//hpoa:deviceBays/hpoa:bay[hpoa:bayNumber='+bay+']',true);
if(ebipav6BayInfoNode){
bayNode.appendChild(ebipav6BayInfoNode.cloneNode(true));
}
}
}
}
return domBuilder.getDocument();
}
function getInterconnectv6BayCurrentAddress(mpInfo){
var addrList=['swmIPv6EBIPAAddress','swmIPv6DHCPAddress','swmIPv6SLAACAddress1','swmIPv6StaticAddress','swmIPv6LLAddress'];
var ipAddress='::';
for(var i=0;i<addrList.length;i++){
var xPath='//hpoa:extraData[starts-with(@hpoa:name, "'+addrList[i]+'")]';
ipAddress=getElementValueXpath(mpInfo,xPath);
if(!_isIPv6AddressZero(ipAddress))
break;
}
if(_isIPv6AddressZero(ipAddress)){
ipAddress=top.getString('n/a');
}
else{
var mySplitAddr=ipAddress.split("/");
return mySplitAddr[0];
}
return ipAddress;
}
function getInterconnectv6BayList(hpems){
var domBuilder=new DomBuilder();
domBuilder.addDocument("enclosureBayList");
for(var i=0;i<hpems.length;i++){
var bayCount=hpems[i].getNumTrays();
var ebipav6Info=(hpems[i].getActiveFirmwareVersion()>=4.20?hpems[i].getEbipav6InfoEx(null,false):hpems[i].getEbipav6Info(null,false));
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
ipAddress=getInterconnectv6BayCurrentAddress(interconnectInfo);
}
if(interconnectStatus!=null){
presence=getElementValueXpath(interconnectStatus,'//hpoa:interconnectTrayStatus/hpoa:presence');
}
var attributes=[
'number',j,
'currentIpv6',ipAddress,
'presence',presence,
'trayType',trayType,
'bayDisplayNumber',j
];
var bayNode=domBuilder.appendChild("bay",attributes,'','//enclosure[@encNum='+hpems[i].getEnclosureNumber()+']');
var ebipav6BayInfoNode=getElementValueXpath(ebipav6Info,'//hpoa:interconnectBays/hpoa:bay[hpoa:bayNumber='+j+']',true);
if(ebipav6BayInfoNode){
bayNode.appendChild(ebipav6BayInfoNode.cloneNode(true));
}
}
}
return domBuilder.getDocument();
}
function getAddressv6List(beginAddress,addressCount,callback){
var hpem=top.getTopology().getProxyLocal();
var addressList=new Array();
if(hpem){
toggleEbipav6ListEnabled(false);
hpem.getEbipav6AddressList(beginAddress,getXmlBayArray(getAllArray(1,addressCount)),function(result){
toggleEbipav6ListEnabled(true);
var responseElement=getElementValueXpath(result,'//hpoa:getEbipav6AddressListResponse',true);
if(responseElement!=null){
for(var i=0;i<responseElement.childNodes.length;i++){
if(responseElement.childNodes[i].nodeType==1&&responseElement.childNodes[i].firstChild!=null){
var address=responseElement.childNodes[i].firstChild.nodeValue;
if(address=="::/0"){
address=top.getString('invalidIpv6Address');
}
addressList.push(address);
}
}
callback(addressList,0);
}
else{
var errCode=getElementValueXpath(result,'//SOAP-ENV:Body//SOAP-ENV:Fault//SOAP-ENV:Detail//hpoa:faultInfo/hpoa:errorCode',true);
callback(null,errCode.text);
}
});
}
}
function toggleEbipav6ListEnabled(enabled){
if(document.getElementById('ebipav6DeviceSummary')){
toggleFormEnabled('ebipav6DeviceSummary',enabled);
}else if(document.getElementById('ebipav6InterconnectSummary')){
toggleFormEnabled('ebipav6InterconnectSummary',enabled);
}
}
function transformDevicev6List(hpems,sides,serviceUserAcl){
var processor=new XsltProcessor('../Forms/Ebipav6List.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('bayListDoc',getDevicev6BayList(hpems,sides));
processor.addParameter('deviceType','server');
processor.addParameter('invalidIpString',top.getString('invalidIpv6Address'));
if(typeof(serviceUserAcl)!='undefined'){
processor.addParameter('serviceUserAcl',serviceUserAcl);
}
document.getElementById('ebipav6DeviceListContainer').innerHTML=processor.getOutput();
}
function transformInterconnectv6List(hpems,serviceUserAcl){
var processor=new XsltProcessor('../Forms/Ebipav6List.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('bayListDoc',getInterconnectv6BayList(hpems));
processor.addParameter('deviceType','interconnect');
processor.addParameter('invalidIpString',top.getString('invalidIpv6Address'));
if(typeof(serviceUserAcl)!='undefined'){
processor.addParameter('serviceUserAcl',serviceUserAcl);
}
document.getElementById('ebipav6InterconnectListContainer').innerHTML=processor.getOutput();
}
function checkRangeValidv6(containerId){
var ebipav6Table=document.getElementById(containerId);
var rangeValid=true;
var invalidAddressString=top.getString('invalidIpv6Address');
if(ebipav6Table){
var inputCollection=ebipav6Table.getElementsByTagName('input');
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
function checkRangeValidDevicev6(){
return checkRangeValidv6('ebipav6DeviceSummary');
}
function checkRangeValidInterconnectv6(){
return checkRangeValidv6('ebipav6InterconnectSummary');
}
function toggleBayFormv6Enabled(deviceType,encNum,bayNumber,enabled){
var addressWrapperId='enc'+encNum+deviceType+bayNumber+'AddressWrapper';
var fieldTextId='enc'+encNum+deviceType+bayNumber+'Ebipav6BayAddress';
var autofillImgId='enc'+encNum+deviceType+bayNumber+'AutofillImage';
if(deviceType=='server'){
var containerId='ebipav6DeviceSummary';
}
else{
var containerId='ebipav6InterconnectSummary';
}
toggleAutofillImgv6(containerId,encNum,bayNumber,deviceType);
}
function getEbipav6BayList(summaryTableId,encUuid){
var bayList=new Array();
var bayItem=undefined;
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
var row=rowCollection[j];
if(row.getAttribute('bayNumber')){
var bayNumber=row.getAttribute('bayNumber');
bayItem=new Ebipav6Bay();
bayItem.bayNumber=bayNumber;
var inputCollection=row.getElementsByTagName('input');
for(var k=0;k<inputCollection.length;k++){
var input=inputCollection[k];
var inputId=input.getAttribute('id');
if(inputId.indexOf('Ebipav6BayEnabled')>-1){
bayItem.enabled=input.checked;
}
else if(inputId.indexOf('Ebipav6BayAddress')>-1){
bayItem.ipAddress=input.value;
}
else if(inputId.indexOf('Ebipav6Gateway')>-1){
bayItem.gateway=input.value;
}
else if(inputId.indexOf('Ebipav6Domain')>-1){
bayItem.domain=input.value;
}
else if(inputId.indexOf('Ebipav6Dns1')>-1){
bayItem.dns1=input.value;
}
else if(inputId.indexOf('Ebipav6Dns2')>-1){
bayItem.dns2=input.value;
}
else if(inputId.indexOf('Ebipav6Dns3')>-1){
bayItem.dns3=input.value;
}
}
bayList.push(bayItem);
}
}
}
}
}
return bayList;
}
function getEbipav6Config(hpemObj,encUuid){
var devInfo=(hpemObj.getActiveFirmwareVersion()>=4.20?hpemObj.getEbipav6InfoEx(null,false).cloneNode(true):hpemObj.getEbipav6Info(null,false).cloneNode(true));
var rootPath=(hpemObj.getActiveFirmwareVersion()>=4.20?"//hpoa:ebipav6InfoEx":"//hpoa:ebipav6Info");
var tableIds=['ebipav6DeviceSummary','ebipav6InterconnectSummary'];
for(var i=0;i<tableIds.length;i++){
var bayList=getEbipav6BayList(tableIds[i],encUuid);
if(bayList.length==0){
continue;
}
for(var j=0;j<bayList.length;j++){
var bayObj=bayList[j];
var finalize=(j==bayList.length-1)?true:false;
var dev_element=(tableIds[i].indexOf('ebipav6Device')>-1)?'/hpoa:deviceBays':'/hpoa:interconnectBays';
var xpath=rootPath+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:ipAddress';
setNodeValueXpath(devInfo,xpath,bayObj.ipAddress,false);
xpath=rootPath+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:enabled';
setNodeValueXpath(devInfo,xpath,(bayObj.enabled)?'true':'false',false);
xpath=rootPath+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:domain';
setNodeValueXpath(devInfo,xpath,bayObj.domain,false);
if(typeof(bayObj.gateway)!="undefined"){
xpath=rootPath+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:gateway';
setNodeValueXpath(devInfo,xpath,bayObj.gateway,false);
}
xpath=rootPath+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:dns1';
setNodeValueXpath(devInfo,xpath,bayObj.dns1,false);
xpath=rootPath+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:dns2';
setNodeValueXpath(devInfo,xpath,bayObj.dns2,false);
xpath=rootPath+dev_element+'/hpoa:bay[hpoa:bayNumber='+bayObj.bayNumber+']/hpoa:dns3';
setNodeValueXpath(devInfo,xpath,bayObj.dns3,false);
}
}
return getElementValueXpath(devInfo,rootPath,true);
}
function hasEnabledBaysv6(bayPrefix){
var tableId='';
var hasEnabled=false;
if(bayPrefix=='svb'){
tableId='ebipav6DeviceSummary';
}
else if(bayPrefix=='swm'){
tableId='ebipav6InterconnectSummary';
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
function toggleAutofillImgv6(containerId,encNum,bayNumber,deviceType){
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
doAutoFillv6(containerId,encNum,bayNumber,deviceType);
};
}
}
break;
}
}
}
}
}
function doAutoFillv6(containerId,encNum,bayNumber,deviceType,enclosureCount){
var container=document.getElementById(containerId);
var beginInputId='enc'+encNum+deviceType+bayNumber+'Ebipav6BayAddress';
if(typeof(enclosureCount)=='undefined'){
enclosureCount=7;
}
if(!container){
return;
}
if(!confirm(top.getString('confirmAutofill')))
return;
var inputCollection=container.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var input=inputCollection[i];
if(input.getAttribute('type')=='text'){
if(input.getAttribute('id')==beginInputId){
var beginAddress=input.value;
var mySplitAddr=beginAddress.split("/");
if((mySplitAddr.length==1)||(mySplitAddr[0]=="::")||(beginAddress=="")||(!isValidIPv6Address(beginAddress))){
if(mySplitAddr.length==1){
alert(top.getString('Ipv6WithoutPrefixMessage'));
}
else{
alert(top.getString('invalidIpMessage'));
}
try{
document.getElementById(beginInputId).focus();
document.getElementById(beginInputId).select();
}catch(e){}
return;
}
var addressCount=EM_MAX_BLADE_ARRAY()*enclosureCount;
toggleFormEnabled(containerId,false);
getAddressv6List(beginAddress,addressCount,function(list,errCode){
if(errCode==0){
toggleFormEnabled(containerId,true);
autoFillv6Callback(containerId,encNum,bayNumber,deviceType,list);
}
else{
alert(top.getString(errCode));
try{
document.getElementById(beginInputId).focus();
document.getElementById(beginInputId).select();
}catch(e){}
}
});
}
}
}
}
function autoFillv6Callback(containerId,encNum,bayNumber,deviceType,addressList){
var beginAddressId='enc'+encNum+deviceType+bayNumber+'Ebipav6BayAddress';
var gatewayInputId='enc'+encNum+deviceType+bayNumber+'Ebipav6Gateway';
var domainInputId='enc'+encNum+deviceType+bayNumber+'Ebipav6Domain';
var dnsInput1Id='enc'+encNum+deviceType+bayNumber+'Ebipav6Dns1';
var dnsInput2Id='enc'+encNum+deviceType+bayNumber+'Ebipav6Dns2';
var dnsInput3Id='enc'+encNum+deviceType+bayNumber+'Ebipav6Dns3';
var gatewayValue=getInputValue(gatewayInputId);
var domainValue=document.getElementById(domainInputId).value;
var dns1Value=document.getElementById(dnsInput1Id).value;
var dns2Value=document.getElementById(dnsInput2Id).value;
var dns3Value=document.getElementById(dnsInput3Id).value;
var i=0,ipAddressId,input;
do
{
bayNumber++;
ipAddressId='enc'+encNum+deviceType+bayNumber+'Ebipav6BayAddress';
input=document.getElementById(ipAddressId);
if(!input){
break;
}
input.value=addressList[i];
gatewayInputId='enc'+encNum+deviceType+bayNumber+'Ebipav6Gateway';
input=document.getElementById(gatewayInputId);
if(input){
input.value=gatewayValue;
}
domainInputId='enc'+encNum+deviceType+bayNumber+'Ebipav6Domain';
input=document.getElementById(domainInputId);
if(input){
input.value=domainValue;
}
dnsInput1Id='enc'+encNum+deviceType+bayNumber+'Ebipav6Dns1';
input=document.getElementById(dnsInput1Id);
if(input){
input.value=dns1Value;
}
dnsInput2Id='enc'+encNum+deviceType+bayNumber+'Ebipav6Dns2';
input=document.getElementById(dnsInput2Id);
if(input){
input.value=dns2Value;
}
dnsInput3Id='enc'+encNum+deviceType+bayNumber+'Ebipav6Dns3';
input=document.getElementById(dnsInput3Id);
if(input){
input.value=dns3Value;
}
i++;
}while(true);
}
function displayWarningsv6(warningArray,errorID,enclosureName){
var errorStringArray=new Array();
var htmlString="";
var errorString="";
var processor=new XsltProcessor('../Templates/statusIconExternal.xsl');
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('statusCode','OP_STATUS_OK');
errorString=processor.getOutput();
errorString+='&nbsp;'+top.getString('genericSuccessMessage');
errorStringArray.push(errorString);
errorStringArray.push(top.getString('EM_ERR_DUP_BAY_IPV6ADDRESS'));
for(var i=0;i<warningArray.length;i++){
for(var prop in warningArray[i].MaskCodes()){
if(warningArray[i].Warnings&warningArray[i].MaskCodes()[prop]){
prop=prop.replace("EM_ERR_EBIPAV6_BAY","EM_ERR_DUP_BAY");
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
function WarningObjectv6(warnings,maskCodes,enclosureDescription){
this.Warnings=warnings;
this.MaskCodes=maskCodes;
this.EnclosureDescription=enclosureDescription;
}
