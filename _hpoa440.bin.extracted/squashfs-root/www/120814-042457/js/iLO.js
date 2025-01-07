/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function doiLoPage(url){
var iloIpAddr=getOptionGroupValue("iloIpAddress");
doiLoPageIPAddress(url,iloIpAddr);
}
function doiLoPageIPAddress(url,ipAddress){
if(ipAddress){
url=replaceUrlAddress(url,ipAddress);
}
window.open(url);
}
function doiLoSso(bayNumber,loginUrl,optionUrl,newAddr){
if(!existsNonNull(hpem)){
alert(top.getString('noOnboardAdmin'),AlertMsgTypes.Warning);
return;
}
if('undefined'===typeof newAddr){
newAddr="";
}
if(loginUrl==''){
alert(top.getString('iLoNotReady'),AlertMsgTypes.Warning);
return;
}else{
var encNum=hpem.getEnclosureNumber();
var windowArgs='';
var windowName='iLO_SSO_bay_'+bayNumber+'_enc_'+encNum;
if(top.name&&top.name==windowName){
windowName+="_1";
}
if(optionUrl.indexOf('HRemCons')>-1||optionUrl.indexOf('IRC')>-1){
if(optionUrl.indexOf('fullscreen=1')>-1){
windowName+='_IRC_Full';
windowArgs='fullscreen=yes,location=no,menubar=no,status=yes,toolbar=no,titlebar=yes,resizable=yes';
}else{
windowName+='_IRC';
windowArgs='fullscreen=no,location=no,menubar=no,status=yes,toolbar=no,titlebar=yes,resizable=yes';
}
}else if(optionUrl.indexOf('drc2fram')>-1||optionUrl.indexOf('RSC')>-1||optionUrl.indexOf('REMCONS')>-1){
windowName+='_RC';
windowArgs='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=800,height=600';
}else if(optionUrl.indexOf('dems')>-1){
windowName+='_RS';
windowArgs='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=800,height=600';
}else if(optionUrl.indexOf('index')>-1||optionUrl.indexOf('HOME')>-1){
windowName+='_Web';
}else if(optionUrl.indexOf('VMEDIA')>-1){
windowName+='_Vmedia';
}
var ssoWin=window.open('/120814-042457/html/sso.html',windowName,windowArgs);
hpem.getBladeMpCredentials(bayNumber,function(result){
if(result.xml==''||result.xml.indexOf(SOAP_FAULT_TEST())>-1){
var errorInfo=top.getCallAnalyzer().extractErrorInfo(result);
var errorString=errorInfo.errorString;
if(errorString==''){
errorString=top.getString('autoLoginFailed');
}
errorString=top.getString('autoLoginFailTitle')+' '+errorString;
alert(errorString,AlertMsgTypes.Information);
try{
ssoWin.close();
}catch(e){}
}else{
var username=getElementValueXpath(result,'//hpoa:username');
var password=getElementValueXpath(result,'//hpoa:password');
if(newAddr==null||newAddr==''){
newAddr=getOptionGroupValue('iloIpAddress');
}
if(newAddr){
loginUrl=replaceUrlAddress(loginUrl,newAddr);
optionUrl=replaceUrlAddress(optionUrl,newAddr);
}
var processor=new XsltProcessor('/120814-042457/Templates/iLOSso.xsl');
processor.addParameter('username',username);
processor.addParameter('password',password);
processor.addParameter('iLoUrl',loginUrl);
processor.addParameter('optionUrl',optionUrl);
processor.addParameter('windowName',windowName);
document.getElementById('iLoSsoContent').innerHTML=processor.getOutput();
var autoLoginForm=document.getElementById('autologin');
autoLoginForm.submit();
document.getElementById('iLoSsoContent').innerHTML='';
if(document.all&&optionUrl=="IRC"&&ssoWin){
var retryElem=ssoWin.document.getElementById("retryContent");
if(retryElem){
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('showRetry','true');
window.setTimeout(function(){try{retryElem.innerHTML=processor.getOutput();ssoWin.showRetry();}catch(e){}},20000);
}
}
try{
ssoWin.focus();
}catch(e){}
}
});
}
}
function callDoIloSso(bayNumber,loginUrl,optionUrl,ipAddress,productId){
var url="";
if(productId=="8224"||productId=="33282"){
if(ipAddress){
url=replaceUrlAddress(loginUrl,ipAddress);
}
else{
url=loginUrl;
}
doiLoSso(bayNumber,url,optionUrl,ipAddress);
}
else if(productId=="8213"){
doiLoPageIPAddress(optionUrl,ipAddress);
}
else{
if(ipAddress){
url=replaceUrlAddress(loginUrl,ipAddress);
}
else{
url=loginUrl;
}
doiLoSso(bayNumber,url,"");
}
}
function doiLoSsoHelper(elem,bayNumber,loginUrl,optionUrl,productId,ipv4Address){
var ipAddress=elem.innerText?elem.innerText:elem.textContent;
if(ipAddress==null||ipAddress==""){
return false;
}
var isIPv4=elem.getAttribute("isIPv4");
var isFqdn=elem.getAttribute("isFqdn");
if(isFqdn=="true"){
ipAddress=trimString(ipAddress);
}
else if(isIPv4!="true"){
ipAddress=trimString(ipAddress);
if(!isValidIPv6Address(ipAddress)){
return false;
}
if(ipAddress.indexOf("/")>=0){
ipAddress=ipAddress.substring(0,ipAddress.indexOf("/"));
}
if(ipAddress.indexOf("[")<0){
ipAddress="["+ipAddress+"]";
}
}
else{
ipAddress=ipv4Address;
}
callDoIloSso(bayNumber,loginUrl,optionUrl,ipAddress,productId);
return false;
}
