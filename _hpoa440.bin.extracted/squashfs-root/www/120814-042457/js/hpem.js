/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function hpem(serviceUrl,enclosureNumber,isLoc,id,encName,rackname){
var me=this;
var user=null;
var pass=null;
var url=null;
var proxyUrl="";
var hasFocus=false;
var tfaEnabled=false;
var isLocal=true;
var isLoaded=false;
var isMinimumLoad=false;
var isConnected=true;
var isAuthenticated=false;
var isWizardSelected=false;
var isTower=false;
var isEfmSupported=null;
var isErsLocked=null;
var uuid=0;
var rackName="";
var enclosureName="";
var encNum=0;
var activeFwVersion=0;
var standbyFwVersion=0;
var positionHistory=new Array();
var fipsMode="FIPS-OFF";
var fipsStatus="NO_ERROR";
var configScriptInProgress=false;
var enclosureType=EnclosureTypes.Unknown;
var oaInfo=new Array();
var oaStatus=new Array();
var oaNetworkInfo=new Array();
var oaThermals=new Array();
var oaMediaDevices=new Array();
var bladeInfo=new Array();
var bladeStatus=new Array();
var bladeMpInfo=new Array();
var bladeMpCredentials=new Array();
var bladePortMap=new Array();
var bladeMezzInfoEx=new Array();
var bladeMezzDevInfoEx=new Array();
var bladeThermals=new Array();
var bladeThermalInfo=new Array();
var bladeFirmware=new Array();
var fanInfo=new Array();
var powerSupplyInfo=new Array();
var powerSupplyStatus=new Array();
var interconnectTrayInfo=new Array();
var interconnectTrayStatus=new Array();
var interconnectTrayPortMap=new Array();
var interconnectThermals=new Array();
var userList=new Array();
var groupList=new Array();
var sslSettingsInfo=null;
var soapInterfaceInfo=null;
var enclosureInfo=null;
var enclosureStatus=null;
var enclosureThermals=null;
var domainInfo=null;
var powerSubsystemInfo=null;
var powerConfigInfo=null;
var powerCapConfig=null;
var powerCapExtConfig=null;
var powerCapBladeStatus=null;
var thermalSubsystemInfo=null;
var enclosureNetworkInfo=null;
var snmpInfo=null;
var snmpInfo3=null;
var ldapInfo=null;
var ldapTestStatus=null;
var enclosureTime=null;
var timeZones=null;
var alertmailInfo=null;
var users=null;
var groups=null;
var vlanInfo=null;
var ebipaInfo=null;
var ebipaInfoEx=null;
var ebipaDevInfo=null;
var ebipav6Info=null;
var ebipav6InfoEx=null;
var lcdInfo=null;
var lcdStatus=null;
var hpSimInfo=null;
var certificateRequest=null;
var twoFactorInfo=null;
var passwordSettings=null;
var syslogSettings=null;
var usbFirmwareList=null;
var usbConfigScriptList=null;
var powerDelaySettings=null;
var firmwareManagementSettings=null;
var enclosureComponentFirmware=null;
var saPciList=null;
var ersConfigInfo=null;
var loginBannerSettings=null;
var langPackInfo=null;
var caCertInfo=null;
var ersCertInfo=null;
var accessLevel=null;
var oaPermission=null;
var currentUserInfo=null;
var oaInfoDOM=null;
var oaStatusDOM=null;
var oaThermalsDOM=null;
var oaNetworkDOM=null;
var oaMediaDeviceDOM=null;
var oaVcmMode=null;
var vcmOaMinFwVer=null;
var vcmIpv6UrlList=null;
var kvmInfo=null;
var bladeInfoDOM=null;
var bladeStatusDOM=null;
var bladeMpInfoDOM=null;
var bladePortMapDOM=null;
var bladeMezzInfoExDOM=null;
var bladeMezzDevInfoExDOM=null;
var bladeThermalDOM=null;
var bladeFirmwareDOM=null;
var fanInfoDOM=null;
var powerSupplyInfoDOM=null;
var powerSupplyStatusDOM=null;
var interconnectTrayInfoDOM=null;
var interconnectTrayStatusDOM=null;
var interconnectTrayPortMapDOM=null;
var interconnectTrayThermalDOM=null;
var usersDOM=null;
var groupsDOM=null;
var virtualMediaStatus=new Array();
var virtualMediaStatusDOM=null;
var virtualMediaUrlDoc=null;
var transport=null;
var eventsObj=new events(this,handleEvent);
var oaSessionKey="";
var securityHeader="";
var callbackObjects=new Array();
function echo(msg,level,severity,extraData){
if(top.gDebugOn==true){
var entry="Onboard Admin: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,encNum,level,severity);
}
}
this.setProperty=function(propertyName,propertyValue){
echo("Setting property '"+propertyName+"' to "+propertyValue,1,5);
switch(propertyName){
case "ConfigScriptInProgress":
configScriptInProgress=parseBool(propertyValue);
break;
default:
echo("setProperty: Unknown property: "+propertyName,1,6);
break;
}
}
this.getProperty=function(propertyName){
switch(propertyName){
case "IsLocal":
return isLocal;
case "SoapUrl":
return url;
case "ProxyUrl":
return proxyUrl;
case "IsAuthenticated":
return isAuthenticated;
case "IsConnected":
return isConnected;
case "IsWizardSelected":
return isWizardSelected;
case "IsLoaded":
return isLoaded;
case "HasFocus":
return hasFocus;
case "SessionKey":
return oaSessionKey;
case "ConfigScriptInProgress":
return configScriptInProgress;
case "RackName":
return rackName;
case "EnclosureName":
return enclosureName;
case "UUID":
return uuid;
case "LanguageCount":
return(getTotalXpath(langPackInfo,"//hpoa:languages/hpoa:language"));
case "FipsMode":
return fipsMode;
case "FipsEnabled":
return(fipsMode=="FIPS-ON"||fipsMode=="FIPS-DEBUG");
case "FipsStatus":
return fipsStatus;
case "FipsStatusEnabled":
return(fipsStatus=="SECURE-DEGRADED"||fipsStatus=="DEBUG-DEGRADED");
case "HasStandby":
return(getElementValueXpath(oaStatusDOM,'//hpoa:oaStatus[hpoa:oaRole="STANDBY"]',true)!=null);
case "ActiveBoardType":
return getElementValueXpath(oaInfoDOM,"//hpoa:oaInfo[hpoa:youAreHere = 'true']/hpoa:extraData[@hpoa:name = 'BoardType']");
case "StandbyBoardType":
return getElementValueXpath(oaInfoDOM,"//hpoa:oaInfo[(hpoa:youAreHere = 'false') and (hpoa:bayNumber != '0')]/hpoa:extraData[@hpoa:name = 'BoardType']");
case "ActiveBuildDate":
return getElementValueXpath(soapInterfaceInfo,"//hpoa:compiledDateTime");
default:
echo("getProperty: Unknown property: "+propertyName,1,6);
}
}
this.setCurrentFipsMode=function(mode){
switch(mode){
case "FIPS-ON":
case "FIPS-DEBUG":
fipsMode=mode;
break;
default:
fipsMode="FIPS-OFF";
break;
}
if(isLocal){
top.getTopology().broadcastPrimaryFipsState();
}
}
this.setCurrentFipsState=function(status){
switch(status){
case "SECURE-DEGRADED":
case "DEBUG-DEGRADED":
fipsStatus=status;
break;
default:
fipsStatus="NO_ERROR";
break;
}
if(isLocal){
top.getTopology().broadcastPrimaryFipsState();
}
}
function validateBladeStatus(statusDoc){
if(getElementValueXpath(statusDoc,"//hpoa:bladeStatus/hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='deviceFirmwareManagement']")=="NO_ERROR"){
var serverStatus=getElementValueXpath(statusDoc,"//hpoa:bladeStatus/hpoa:operationalStatus");
var statusNode=getElementValueXpath(statusDoc,"//hpoa:bladeStatus",true);
var serverStatusNode=statusDoc.createElement("hpoa:serverStatus");
serverStatusNode.appendChild(statusDoc.createTextNode(serverStatus));
statusNode.appendChild(serverStatusNode);
setNodeValueXpath(statusDoc,"//hpoa:bladeStatus/hpoa:operationalStatus",OP_STATUS_STARTING(),true);
statusDoc=makeXmlParseable(statusDoc);
}
return statusDoc;
}
this.setHasFocus=function(selected){
if(hasFocus!=selected){
echo("Focus set to "+selected+".",3,1);
hasFocus=selected;
}
}
this.getHasFocus=function(){
return hasFocus;
}
this.setSoapUrl=function(serviceUrl){
echo("gSoap Url set to "+serviceUrl+".",3,1);
url=serviceUrl;
}
this.getSoapUrl=function(){
return url;
}
this.setProxyUrl=function(proxy){
if(me.getIsLocal()==false){
echo("Proxy Url set to "+proxy+".",3,1);
proxyUrl=proxy;
}
}
this.getProxyUrl=function(removeLastSlash){
if(removeLastSlash==true){
return(removeTrailingSlash(proxyUrl));
}
return proxyUrl;
}
this.setEnclosureNumber=function(position,clearHistory){
if(encNum!=0&&encNum!=position){
echo("NEW enclosure number pending: "+position,1,5);
positionHistory.push(encNum);
}
if(clearHistory==true){
this.clearPositionHistory();
}
if(encNum==position){
return;
}
encNum=position;
this.encNum=position;
if(this.positionHasChanged()){
echo("Enclosure number changed.",2,3,this.getPositionHistory());
}else{
echo("Enclosure number initialized.",2,2,this.getPositionHistory());
}
}
this.getEnclosureNumber=function(){
if(encNum!=this.encNum&&!isNaN(this.encNum)){
echo("this.encNum: "+this.encNum+"  private encNum: "+encNum);
encNum=this.encNum;
}
return encNum;
}
this.setObjEnclosureName=function(encName){
if(enclosureName!=encName&&encName!=""){
enclosureName=encName;
}
}
this.getEnclosureName=function(){
return(enclosureName==""?'Enclosure '+me.getEnclosureNumber():enclosureName);
}
this.setObjRackName=function(rackN){
rackName=rackN;
}
this.getRackName=function(){
var myRackName='';
if(enclosureInfo!=null){
myRackName=getElementValueXpath(enclosureInfo,'//hpoa:rackName');
}
if(myRackName==''){
if(rackName!=''){
myRackName=rackName;
}else{
myRackName='UnknownRack';
}
}
return myRackName;
}
this.setIsLocal=function(isLoc){
echo("Local set to "+isLoc+".",3,1);
isLocal=isLoc;
this.isLocal=isLocal;
}
this.getIsLocal=function(){
return isLocal;
}
this.setUuid=function(id){
echo("UUID set to ["+id+"].",3,1,["Previous UUID: "+uuid]);
uuid=id;
}
this.getUuid=function(){
return uuid;
}
function assertUuid(){
if(me.getUuid()==null&&enclosureInfo!=null){
var newUuid=getElementValueXpath(enclosureInfo,"//hpoa:uuid");
if(newUuid!=""){
me.setUuid(newUuid);
}
}
}
this.setIsWizardSelected=function(selected){
echo("Wizard selected flag set to "+selected,3,1);
isWizardSelected=selected;
}
this.getIsWizardSelected=function(){
return isWizardSelected;
}
this.setTwoFactorEnabled=function(enabled){
echo("TFA enabled flag explicitly set to "+enabled+".",3,1);
tfaEnabled=parseBool(enabled);
}
this.getTwoFactorEnabled=function(){
return tfaEnabled;
}
this.setIsAuthenticated=function(authenticated){
echo("Authenticated set to "+authenticated+".",3,1);
isAuthenticated=authenticated;
if(authenticated==false){
removeCookies();
oaSessionKey='';
updateSecurityHeader('');
if(eventsObj){
eventsObj.reset(false);
}
me.clearCache();
me.setIsLoaded(false);
}
}
this.getIsAuthenticated=function(){
return isAuthenticated;
}
this.setIsLoaded=function(loaded){
echo("Loaded set to "+loaded+".",3,1);
isLoaded=loaded;
if(isLoaded==false){
this.setIsMinimumLoad(false);
}
}
this.getIsLoaded=function(){
return isLoaded;
}
this.setIsMinimumLoad=function(isMinimum){
echo("Minimum load set to "+isMinimum+".",5,1);
isMinimumLoad=isMinimum;
}
this.getIsMinimumLoad=function(){
return isMinimumLoad;
}
this.setIsConnected=function(connected){
echo("Connected set to "+connected+".",3,1);
isConnected=connected;
}
this.getIsConnected=function(){
return isConnected;
}
this.getPreviousPosition=function(){
if(positionHistory.length==0){
return encNum;
}else{
return positionHistory[positionHistory.length-1];
}
}
this.clearPositionHistory=function(){
if(positionHistory.length>0){
echo("Resetting position history.",1,3,this.getPositionHistory());
positionHistory=new Array();
}
};
this.getActiveFirmwareVersion=function(){
if(activeFwVersion==0){
me.setActiveFirmwareVersion(getElementValueXpath(me.getOaInfoByMode('ACTIVE'),"//hpoa:oaInfo/hpoa:fwVersion"));
}
return activeFwVersion;
};
this.setActiveFirmwareVersion=function(fwVersion){
setFirmwareVersion("ACTIVE",fwVersion);
};
this.getStandbyFirmwareVersion=function(){
if(standbyFwVersion==0){
me.setStandbyFirmwareVersion(getElementValueXpath(me.getOaInfoByMode('STANDBY'),"//hpoa:oaInfo/hpoa:fwVersion"));
}
return standbyFwVersion;
};
this.setStandbyFirmwareVersion=function(fwVersion){
setFirmwareVersion("STANDBY",fwVersion);
};
function setFirmwareVersion(type,value){
var version=parseFloat(value);
if(!isNaN(version)&&version>0){
echo("Setting "+type+" firmware version to "+version,1,2);
switch(type){
case "ACTIVE":
activeFwVersion=version;
try{
if(eventsObj&&!top.checkStandby()){
eventsObj.notifyFirmwareVersionChange(version);
}
}catch(e){
echo("Error notifying events class of active version change: "+e.message,1,6);
}
break;
case "STANDBY":
standbyFwVersion=version;
try{
if(eventsObj&&top.checkStandby()){
eventsObj.notifyFirmwareVersionChange(version);
}
}catch(e){
echo("Error notifying events class of standby version change: "+e.message,1,6);
}
break;
}
}else{
echo("Cannot set "+type+" firmware version to ["+value+"]",8,5);
}
}
this.setIsTower=function(value){
if(isTower==false){
if((enclosureType==EnclosureTypes.c3000)&&(value=="true"||value=="458075-001")){
echo("This enclosure is TOWER oriented.",1,1,["Value: "+value,"Type: "+enclosureType]);
isTower=true;
}
}
}
this.getIsTower=function(){
return isTower;
}
this.getPositionHistory=function(raw){
if(raw==true){
return positionHistory;
}
var list=new Array("Position History");
list.push("----------------","Current: "+encNum);
for(var index in positionHistory){
list.push("Prior: "+positionHistory[index]);
}
return list;
}
this.positionHasChanged=function(){
return(encNum!=this.getPreviousPosition());
}
this.unload=function(){
echo("unload called - this clears everything.");
this.setIsConnected(false);
this.stopEvents();
this.clearCache();
this.setIsLocal(false);
this.setIsLoaded(false);
this.setIsAuthenticated(false);
this.setIsWizardSelected(false);
this.clearPositionHistory();
}
if(exists(enclosureNumber)&&enclosureNumber!=0){
this.setEnclosureNumber(enclosureNumber);
}
if(exists(serviceUrl)){
this.setSoapUrl(serviceUrl);
}
if(exists(isLoc)){
this.setIsLocal(parseBool(isLoc));
}
if(exists(id)){
this.setUuid(id);
}
if(exists(encName)){
this.setObjEnclosureName(encName);
}
if(exists(rackname)){
this.setObjRackName(rackname);
}
this.toString=function(){
return "HP Onboard Administrator Service Object\nEnclosure: "+encNum;
}
this.destroyServiceObject=function(){
me.clearCache();
eventsObj=null;
}
this.getCurrentServiceUser=function(){
var username='[Unknown]';
if(currentUserInfo&&currentUserInfo.xml.indexOf(SOAP_FAULT_TEST())==-1){
username=getElementValueXpath(currentUserInfo,'//hpoa:getCurrentUserInfoResponse/hpoa:username');
}
return username;
}
this.getUserAccessLevel=function(){
var userAcl='';
try{
if(currentUserInfo&&currentUserInfo.xml.indexOf(SOAP_FAULT_TEST())==-1){
userAcl=getElementValueXpath(currentUserInfo,'//hpoa:acl');
}
else{
userAcl=getElementValueXpath(accessLevel,'//hpoa:acl');
}
}catch(e){}
return userAcl;
}
this.getUserOaPermission=function(){
var hasOaAccess=false;
if(currentUserInfo&&currentUserInfo.xml.indexOf(SOAP_FAULT_TEST())==-1){
hasOaAccess=(getElementValueXpath(currentUserInfo,'//hpoa:bayPermissions/hpoa:oaAccess')=='true')?true:false;
}
else{
hasOaAccess=(getElementValueXpath(oaPermission,'//hpoa:isOaAccess')=='true')?true:false;
}
return hasOaAccess;
}
this.getUserType=function(){
var userType=UserTypes.Local;
if(currentUserInfo&&currentUserInfo.xml.indexOf(SOAP_FAULT_TEST())==-1){
var type=getElementValueXpath(currentUserInfo,'//hpoa:getCurrentUserInfoResponse/hpoa:userType');
type=parseInt(type);
if(!isNaN(type)){
userType=type;
}
}
return userType;
}
function getUserInfoChanged(newInfo){
var username=getElementValueXpath(newInfo,"//hpoa:userInfo/hpoa:username");
var oldInfo=me.getUserInfo(username);
if(oldInfo!=null){
var processor=new XsltProcessor("/120814-042457/Templates/userPermsTest.xsl");
processor.addParameter('userInfoOld',oldInfo);
processor.addParameter("userInfoNew",newInfo);
var changes=processor.getOutput();
if(!processor.hasErrors()&&changes!=""){
echo("User info changed for "+username+".",1,5,changes.split("^"));
return changes;
}
}
echo("User info did not change.",1,2,["User: "+username]);
return "";
}
function updateSecurityHeader(sessionKey){
securityHeader=(sessionKey==""?"":top.getSoapModule().getSecurityHeader(oaSessionKey));
echo("Security Header updated.",2,3,[securityHeader==""?"Removed.":securityHeader]);
}
this.userLogIn=function(username,password,callback){
me.callMethod("userLogIn",[username,password],function(result){
if(getCallSuccess(result)==true){
oaSessionKey=getElementValueXpath(result,'//hpoa:userLogInResponse/hpoa:HpOaSessionKeyToken/hpoa:oaSessionKey');
if(oaSessionKey!=''){
echo("Successful Sign In.",1,2);
updateSecurityHeader(oaSessionKey);
setCookieValue(me.getCookieName(),oaSessionKey,'',(me.getIsLocal()?'':me.getProxyUrl()));
me.setIsAuthenticated(true);
if(me.getIsLocal()){
setCookieValue(LOCAL_ENC_USER_NAME(),username);
}
}
}else{
echo("Login failed.",1,4);
me.setIsAuthenticated(false);
}
callback(result);
},false,CallTypes.API,299000);
}
this.userLoginSSO=function(sessionKey,setCookie){
oaSessionKey=sessionKey;
echo("userLoginSSO called.",1,4,["Session Key: "+sessionKey,"Set New Cookie? "+setCookie]);
if(setCookie!=false){
echo("userLoginSSO - setting new cookie.",1,4);
setCookieValue(me.getCookieName(),oaSessionKey,'',(me.getIsLocal()?'':me.getProxyUrl()));
}
updateSecurityHeader(oaSessionKey);
me.setIsAuthenticated(true);
}
this.userLogOut=function(killSession,callbackFunction){
var callback=assertFunction(callbackFunction);
me.clearCache();
me.setIsLoaded(false);
me.stopEvents(function(success){
if(killSession==true){
echo("userLogOut (kill the session).");
me.callMethod("userLogOut",[],function(result){
oaSessionKey='';
updateSecurityHeader('');
removeCookies();
isAuthenticated=false;
callback(result,"userLogOut");
},true,CallTypes.API,10000);
}else{
callback(true,"userLogOut");
}
});
}
this.getSessionKey=function(){
return oaSessionKey;
}
this.getCookieName=function(){
return(me.getIsLocal()==true?LOCAL_ENC_COOKIE_NAME():LINKED_ENC_COOKIE_NAME());
}
function removeCookies(){
var existingCookie=document.cookie;
if(me.getIsLocal()==true){
setCookieValue(me.getCookieName(),"");
setCookieValue(LOCAL_ENC_USER_NAME(),"");
setCookieValue(SIM_SSO_COOKIE_NAME(),"");
setCookieValue('SSO-ERR',"");
echo("Local session cookies cleared.",1,4,["Before: "+existingCookie,"After: "+document.cookie]);
}else{
if(me.getProxyUrl()==""){
echo("Cannot remove linked session cookie due to missing path information.",me.getEnclosureNumber(),1,6);
return;
}
setCookieValue(me.getCookieName(),"","",me.getProxyUrl());
echo("Linked session cookie cleared ("+me.getProxyUrl()+")",1,4,["After: "+document.cookie]);
}
}
this.getLanguages=function(callback,fresh){
return me.getManagedData("getLanguages",[],"langPackInfo",assertNull(callback),assertFalse(fresh));
}
this.addLanguagePack=function(langFilePath,callback){
return me.callMethod("addLanguagePack",[langFilePath],callback);
}
this.removeLanguagePack=function(langCode,callback){
return me.callMethod("removeLanguagePack",[langCode],callback);
}
this.getLoginBannerSettings=function(callback,fresh){
return me.getManagedData("getLoginBannerSettings",[],'loginBannerSettings',assertNull(callback),assertFalse(fresh));
}
this.setLoginBannerSettings=function(bannerEnabled,bannerText,callback){
return me.callMethod("setLoginBannerSettings",[bannerEnabled,bannerText],callback);
}
this.handlePowerConfigInfoEvent=function(result){
var oldDPS=null;
var newDPS=getElementValueXpath(result,'//hpoa:dynamicPowerSaverEnabled');
if(powerConfigInfo==null){
oldDPS=!parseBool(newDPS);
}
else{
oldDPS=getElementValueXpath(powerConfigInfo,'//hpoa:dynamicPowerSaverEnabled');
}
if(isBool(oldDPS)&&isBool(newDPS)){
if(parseBool(oldDPS)!=(parseBool(newDPS))){
window.setTimeout(function(){
try{
me.getPowerSupplyInfoArrayAndEvents();
}catch(ex){
}
},5000);
window.setTimeout(function(){
try{
me.getPowerSupplyInfoArrayAndEvents();
}catch(ex){
}
},30000);
}
}
powerConfigInfo=result;
}
var handleEvent=function(result){
var eventName=getElementValueXpath(result,'//hpoa:event');
var bayNum=null;
var rebooting=false;
if(eventName!=''){
if(eventName=="EVENT_HEARTBEAT"){
echo("Ignoring Event: "+eventName,3,1);
return;
}
if(top.gDebugOn==true){
echo("Processing Event: "+eventName,3,1,[result.xml]);
}
switch(eventName){
case 'EVENT_OA_VCM':
case 'EVENT_VCM_FQDN_INFO_REFRESH':
oaVcmMode=result;
break;
case 'EVENT_OA_REBOOT':
rebooting=true;
case 'EVENT_FACTORY_RESET':
if(me.getIsLocal()==true){
me.setIsConnected(false);
me.stopEvents();
if(top.getCurrentUserContext()!=UserContextTypes.LoadOrFlash&&top.getTopology().getDisplayMode()!=TopologyModes.DisplayOff){
echo("Starting reset timer from hpem.",1,3,[top.getCurrentUserContext()]);
top.displayHiddenFrame();
top.MX_HIDDEN.displayResetTimer(false,null,'',
rebooting?OA_REBOOT_TIMEOUT():OA_REBOOT_TIMEOUT_FR());
}else{
echo("Display of reset timer prohibited at this time.",1,4,
["Event: "+eventName,"Context: "+top.getCurrentUserContext(),"Display Mode: "+top.getTopology().getDisplayMode()]);
}
}else{
top.getTopology().removeProxy(me.getUuid());
}
me.setIsAuthenticated(false);
top.getTransport().assertUntimedCallsEnded(me.getUuid());
break;
case 'EVENT_FLASH_COMPLETE':
if(!me.getIsLocal()==true){
if(top.getTopology().getDisplayMode()!=TopologyModes.DisplayOff){
top.getTopology().removeProxy(me.getUuid());
me.setIsAuthenticated(false);
}
}
break;
case 'EVENT_FLASH_PENDING':
if(me.getIsLocal()==true){
if(!top.MX_HIDDEN.getUserInitiatedFlash()){
if(top.getTopology().getDisplayMode()!=TopologyModes.DisplayOff){
var msg=top.getString("primOAflashed1")+"\n\n"+top.getString("primOAflashed2");
alert(msg,AlertMsgTypes.Warning,90);
top.logout();
}else{
echo("Logout for primary flash prohibited at this time.",1,4,["Display Mode: "+top.getTopology().getDisplayMode()]);
}
}
}else{
me.setLcdEventsEnabled(false);
if(top.getTopology().getDisplayMode()!=TopologyModes.DisplayOff){
if(!(me.getHasFocus()&&(top.getCurrentUserContext()==UserContextTypes.OaFirmwareUpdate))){
top.getTopology().unloadLinkedEnclosure(me.getUuid(),true,AlertReasons.LinkedFlash);
}
}
}
break;
case "EVENT_FLASH_PROGRESS":
case "EVENT_STANDBY_FLASH_PROGRESS":
top.getTransport().assertUntimedCallsEnded(me.getUuid());
break;
case 'EVENT_STANDBY_FLASH_FAILED':
if(me.getIsLocal()==true&&top.MX_HIDDEN.getUserInitiatedFlash()){
if(top.getTopology().getDisplayMode()!=TopologyModes.DisplayOff){
var msg2='The firmware update process failed because the Standby ';
msg2+='Onboard Administrator could not verify the image.\n\nPlease sign in and try again.';
alert(msg2,AlertMsgTypes.Critical);
top.logout();
}
}
break;
case 'EVENT_SNMP_INFO_CHANGED':
snmpInfo=result;
break;
case 'EVENT_SNMPV3_INFO_CHANGED':
snmpInfo3=result;
break;
case 'EVENT_LDAP_INFO_CHANGED':
case 'EVENT_LDAP_DIRECTORY_SERVER_CERTIFICATE_ADDED':
case 'EVENT_LDAP_DIRECTORY_SERVER_CERTIFICATE_REMOVED':
ldapInfo=result;
break;
case 'EVENT_VLAN_INFO_CHANGED':
vlanInfo=result;
break;
case 'EVENT_EBIPA_INFO_CHANGED':
case 'EVENT_EBIPA_INFO_CHANGED_EX':
ebipaInfo=result;
ebipaInfoEx=null;
break;
case 'EVENT_EBIPAV6_INFO_CHANGED':
ebipav6Info=result;
break;
case 'EVENT_EBIPAV6_INFO_CHANGED_EX':
ebipav6InfoEx=result;
break;
case 'EVENT_POWER_INFO':
me.handlePowerConfigInfoEvent(result);
me.getPowerSubsystemInfo(null,true);
break;
case 'EVENT_ENC_GRP_CAP':
powerCapConfig=null;
powerCapExtConfig=null;
powerCapBladeStatus=null;
powerConfigInfo=null;
powerSubsystemInfo=null;
break;
case 'EVENT_ALERTMAIL_INFO_CHANGED':
alertmailInfo=result;
break;
case 'EVENT_ENC_UID':
case 'EVENT_ENC_STATUS':
case 'EVENT_ENC_SHUTDOWN':
case 'EVENT_ENC_WIZARD_STATUS':
enclosureStatus=result;
break;
case 'EVENT_ENC_NAMES':
case 'EVENT_ENC_INFO':
enclosureInfo=result;
me.setObjEnclosureName(getElementValueXpath(result,'//hpoa:enclosureName'));
me.setIsTower(getElementValueXpath(enclosureInfo,"//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='isTower']"));
top.mainPage.getHiddenFrame().loadSystemStatusDocument();
if(existsNonNull(isEfmSupported)&&(isEfmSupported!=(parseBool(getElementValueXpath(enclosureInfo,"//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='firmwareMgmtSupported']"))))){
alert(top.getString("efmSupportChanged").replace("{%1}",me.getIsLocal()?top.getString("thePrimary"):top.getString("aLinked")).replace("{%2}",me.getEnclosureName()),AlertMsgTypes.Information,15);
top.MX_HIDDEN.resetNoDestroy(top.getString("stoppingEvents"));
top.hiddenPageLoadData(false);
}else if(existsNonNull(isErsLocked)&&(isErsLocked!=(parseBool(getElementValueXpath(enclosureInfo,"//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='ersLock']"))))){
alert(top.getString("ersSupportChanged").replace("{%1}",me.getIsLocal()?top.getString("thePrimary"):top.getString("aLinked")).replace("{%2}",me.getEnclosureName()),AlertMsgTypes.Information,15);
top.MX_HIDDEN.resetNoDestroy(top.getString("stoppingEvents"));
top.hiddenPageLoadData(false);
}
break;
case 'EVENT_OA_LOGIN_BANNER_SETTINGS_CHANGED':
loginBannerSettings=result;
break;
case 'EVENT_NETWORK_INFO_CHANGED':
enclosureNetworkInfo=result;
ebipaInfoEx=null;
break;
case 'EVENT_NET_SERVICE_RESTART':
if(me.getIsLocal()){
top.primaryWebRestart=true;
var context=top.getCurrentUserContext();
var hpems=top.getTopology().getProxies();
for(var i=0;i<hpems.length;i++){
hpems[i].setIsConnected(false);
hpems[i].stopEvents();
}
if(context!=UserContextTypes.LoadOrFlash&&top.getTopology().getDisplayMode()!=TopologyModes.DisplayOff){
try{
if(top.MX_HIDDEN.encNum==me.getEnclosureNumber()){
top.captureDeviceContext();
}
}catch(e){
echo("capture error: "+e.message,1,6);
}
top.displayHiddenFrame();
top.MX_HIDDEN.displayResetTimer(false,function(){},top.getString('oaWebServerRestartMsg')+(configScriptInProgress==true?"<br /><br /><b>"+top.getString("note:")+"</b>&nbsp;"+top.getString("oaWebServerRestartScriptMsg")+"<br />":""),90,context,true);
configScriptInProgress=false;
}else{
echo("Display of reset timer prohibited at this time.",1,4,
["Event: "+eventName,"Context: "+context,"Display Mode: "+top.getTopology().getDisplayMode()]);
}
}else{
top.getTopology().unloadLinkedEnclosure(me.getUuid(),false,AlertReasons.WebServerDown,null,(configScriptInProgress==true?top.getString("oaWebServerRestartScriptMsg"):null));
configScriptInProgress=false;
}
break;
case 'EVENT_TIME_CHANGE':
enclosureTime=result;
if(me.getRemoteSupportLocked()==false){
ersConfigInfo=null;
window.setTimeout(me.getErsConfigInfo,3000);
}
break;
case 'EVENT_USER_DELETED':
var username=getElementValueXpath(result,'//hpoa:message');
removeCachedUser(username);
me.getUsersDOM(true);
break;
case 'EVENT_USER_INFO_CHANGED':
case 'EVENT_USER_ENABLED':
case 'EVENT_USER_DISABLED':
updateUser(result);
break;
case 'EVENT_ADMIN_RIGHTS_CHANGED':
case 'EVENT_USER_PERMISSION':
if(me.getCurrentServiceUser()==getElementValueXpath(result,'//hpoa:userInfo/hpoa:username')){
var changes=getUserInfoChanged(result);
var msg3="";
if(changes!=""){
if(changes.indexOf("ACL")>-1){
msg3=replaceCharacter(top.getString("userAccessLevelChanged"),"{%1}",me.getEnclosureName());
alert(msg3+" "+top.getString("sessionWillReset")+"\n\n"+top.getString("contactAdminForFurtherInfo"),AlertMsgTypes.Information);
if(me.getIsLocal()){
top.logout();
}else{
top.getTopology().unloadLinkedEnclosure(me.getUuid(),true);
}
}else{
msg=replaceCharacter(top.getString("userAccountPermissionsChanged"),"{%1}",me.getEnclosureName());
alert(msg+" "+top.getString("userSessionMustBeRefreshed")+"\n\n"+top.getString("contactAdminForFurtherInfo"),AlertMsgTypes.Information);
top.displayHiddenFrame();
top.MX_HIDDEN.loadData((me.getIsLocal()?top.checkStandby():false),me.getUuid(),top.getCurrentUserContext());
}
return;
}
}
updateUser(result);
break;
case 'EVENT_USER_ADDED':
userList.push(result);
me.getUsersDOM(true);
break;
case 'EVENT_LDAPGROUP_ADDED':
groupList.push(result);
me.getGroupsDOM(true);
break;
case 'EVENT_LDAPGROUP_DELETED':
var groupName=getElementValueXpath(result,'//hpoa:message');
removeCachedGroup(groupName);
me.getGroupsDOM(true);
break;
case 'EVENT_TFA_CA_CERT_ADDED':
case 'EVENT_TFA_CA_CERT_REMOVED':
caCertInfo=result;
break;
case 'EVENT_LDAPGROUP_ADMIN_RIGHTS_CHANGED':
case 'EVENT_LDAPGROUP_INFO_CHANGED':
case 'EVENT_LDAPGROUP_PERMISSION':
updateGroup(result);
break;
case 'EVENT_BLADE_INFO':
case 'EVENT_BAY_CHANGED':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
var isConjoinable=getElementValueXpath(bladeInfo[bayNum],"//hpoa:extraData[@hpoa:name='isConjoinable']");
var newVal=getElementValueXpath(result,"//hpoa:extraData[@hpoa:name='isConjoinable']");
bladeInfo[bayNum]=result;
me.getBladeInfoDOM(true);
if(isConjoinable=='0'&&newVal=='1'){
eventsObj.generateEvent('EVENT_SBL_DOMAIN_INFO_CHANGED',domainInfo,'hpoa:domainInfo');
}
break;
case 'EVENT_BLADE_REMOVED':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
bladeThermals[bayNum]=null;
bladeThermalInfo[bayNum]=null;
bladeInfo[bayNum]=null;
bladeMpInfo[bayNum]=null;
bladeStatus[bayNum]=result;
me.getBladeInfoDOM(true);
me.getBladeStatusDOM(true);
me.getBladeMpInfoDOM(true);
cleanInterconnectTrayPortMap(bayNum);
break;
case 'EVENT_BLADE_STATUS':
case 'EVENT_BLADE_UID':
case 'EVENT_BLADE_POWER_STATE':
case 'EVENT_BLADE_INSERTED':
case 'EVENT_BLADE_INSERT_COMPLETED':
case 'EVENT_BLADE_POWER_MGMT':
case 'EVENT_BLADE_SHUTDOWN':
case 'EVENT_BLADE_FAULT':
case 'EVENT_BLADE_CONNECT':
case 'EVENT_BLADE_DISCONNECT':
case 'EVENT_BLADE_GRP_CAP_TIMEOUT':
case 'EVENT_ILO_READY':
case 'EVENT_ILO_DEAD':
case 'EVENT_ILO_ALIVE':
if(result.xml.indexOf('hpoa:noPayload')==-1){
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
bladeStatus[bayNum]=validateBladeStatus(result);
me.getBladeStatusDOM(true);
}
break;
case 'EVENT_BLADE_THERMAL':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
bladeThermals[bayNum]=result;
me.getBladeThermalsDOM(true);
break;
case 'EVENT_BLADE_MP_INFO':
case 'EVENT_ILO_HAS_IPADDRESS':
case 'EVENT_BLADE_FQDN_INFO_REFRESH':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
bladeMpInfo[bayNum]=result;
me.getBladeMpInfoDOM(true);
break;
case 'EVENT_BLADE_PORTMAP':
bayNum=getElementValueXpath(result,'//hpoa:bladeBayNumber');
bladePortMap[bayNum]=result;
me.getBladePortMapDOM(true);
interconnectTrayPortMapDOM=null;
break;
case 'EVENT_VIRTUAL_MEDIA_STATUS':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
virtualMediaStatus[bayNum]=result;
break;
case 'EVENT_BLADE_PERSONALITY_CHANGED':
bayNum=getElementValueXpath(result,'//hpoa:numValue');
bladeMezzInfoEx[bayNum]=null;
bladeMezzInfoExDOM=null;
break;
case 'EVENT_FAN_STATUS':
case 'EVENT_FAN_INSERTED':
case 'EVENT_FAN_REMOVED':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
fanInfo[bayNum]=result;
me.getFanInfoDOM(true);
break;
case 'EVENT_BLADE_POST_COMPLETE':
bayNum=getElementValueXpath(result,'//hpoa:numValue');
me.refreshServerIDs(bayNum);
break;
case 'EVENT_INTERCONNECT_STATUS':
case 'EVENT_INTERCONNECT_UID':
case 'EVENT_INTERCONNECT_RESET':
case 'EVENT_INTERCONNECT_REMOVED':
case 'EVENT_INTERCONNECT_INSERTED':
case 'EVENT_SWITCH_CONNECT':
case 'EVENT_SWITCH_DISCONNECT':
case 'EVENT_INTERCONNECT_HEALTH_LED':
case 'EVENT_INTERCONNECT_CPUFAULT':
case 'EVENT_INTERCONNECT_POWER':
case 'EVENT_INTERCONNECT_THERMAL':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
interconnectTrayStatus[bayNum]=result;
me.getInterconnectTrayStatusDOM(true);
break;
case 'EVENT_INTERCONNECT_INFO':
case 'EVENT_TRAY_FQDN_INFO_REFRESH':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
interconnectTrayInfo[bayNum]=result;
me.getInterconnectTrayInfoDOM(true);
break;
case 'EVENT_INTERCONNECT_PORTMAP':
bayNum=getElementValueXpath(result,'//hpoa:interconnectTrayBayNumber');
interconnectTrayPortMap[bayNum]=result;
me.getInterconnectTrayPortMapDOM(true);
bladePortMapDOM=null;
break;
case 'EVENT_PS_STATUS':
case 'EVENT_PS_INSERTED':
case 'EVENT_PS_REMOVED':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
powerSupplyStatus[bayNum]=result;
me.getPsStatusDOM(true);
break;
case 'EVENT_PS_INFO':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
powerSupplyInfo[bayNum]=result;
me.getPsInfoDOM(true);
break;
case 'EVENT_PS_REDUNDANT':
case 'EVENT_PS_OVERLOAD':
case 'EVENT_AC_FAILURE':
case 'EVENT_PS_SUBSYSTEM_STATUS':
powerSubsystemInfo=result;
break;
case 'EVENT_ENC_TOPOLOGY':
break;
case 'EVENT_ENC_TOPOLOGY_2':
case 'EVENT_RACK_SERVICE_STARTED':
echo("Topology Event Received on "+(me.getIsLocal()?"LOCAL":"LINKED")+" enclosure",1,3);
if(me.getIsLocal()==true){
top.getTopology().updateTopology(result);
}
break;
case 'EVENT_OA_INSERTED':
case 'EVENT_OA_REMOVED':
case 'EVENT_OA_NAMES':
case 'EVENT_OA_STATUS':
case 'EVENT_OA_UID':
var oaRole=getElementValueXpath(result,'//hpoa:oaRole');
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
oaStatus[bayNum]=result;
me.getOaStatusDOM(true);
if(oaRole=='ACTIVE'){
var redundancy=getElementValueXpath(result,'//hpoa:oaRedundancy');
var otherBayNum=(bayNum==1)?2:1;
if(redundancy=='false'&&eventName=='EVENT_OA_REMOVED'){
oaStatus[otherBayNum]=null;
standbyFwVersion=0;
me.getOaStatus(otherBayNum,function(oaStatusResult){
me.getOaStatusDOM(true);
if(oaStatusResult.xml.indexOf(SOAP_FAULT_TEST())>-1){
eventsObj.generateEvent('EVENT_OA_STATUS',oaStatusResult,'SOAP-ENV:Fault');
}else{
eventsObj.generateEvent('EVENT_OA_STATUS',oaStatusResult,'hpoa:oaStatus');
}
oaInfo[otherBayNum]=null;
},true);
}
}
break;
case 'EVENT_OA_INFO':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
oaInfo[bayNum]=result;
me.getOaInfoDOM(true);
if(getElementValueXpath(result,"//hpoa:oaInfo/hpoa:youAreHere")=="false"){
var version=getElementValueXpath(result,"//hpoa:oaInfo/hpoa:fwVersion");
if(me.getStandbyFirmwareVersion().toString()!=version){
me.setStandbyFirmwareVersion(version);
}
}
break;
case 'EVENT_LCD_INFO':
lcdInfo=result;
break;
case 'EVENT_LCD_STATUS':
case 'EVENT_LCDPIN':
case 'EVENT_LCD_BUTTONS_LOCKED':
lcdStatus=result;
break;
case 'EVENT_HPSIM_TRUST_MODE_CHANGED':
case 'EVENT_HPSIM_CERTIFICATE_ADDED':
case 'EVENT_HPSIM_CERTIFICATE_REMOVED':
case 'EVENT_HPSIM_XENAME_ADDED':
case 'EVENT_HPSIM_XENAME_REMOVED':
hpSimInfo=result;
break;
case 'EVENT_COOLING_STATUS':
thermalSubsystemInfo=result;
break;
case 'EVENT_PW_SETTINGS_CHANGED':
passwordSettings=result;
break;
case 'EVENT_SYSLOG_SETTINGS_CHANGED':
syslogSettings=result;
break;
case 'EVENT_POWERDELAY_SETTINGS_CHANGED':
powerDelaySettings=result;
break;
case 'EVENT_USB_OA_FW_FILES':
usbFirmwareList=result;
break;
case 'EVENT_USB_OA_CONFIG_SCRIPTS':
usbConfigScriptList=result;
break;
case 'EVENT_MEDIA_DRIVE_INSERTED':
case 'EVENT_MEDIA_DRIVE_REMOVED':
case 'EVENT_MEDIA_INSERTED':
case 'EVENT_MEDIA_REMOVED':
var devIndex=getElementValueXpath(result,'//hpoa:deviceIndex');
oaMediaDevices[devIndex]=result;
me.getOaMediaDeviceDOM(true);
virtualMediaUrlDoc=null;
break;
case 'EVENT_SESSION_TIMEOUT_CHANGED':
if(isLocal==true){
var timeout=getElementValueXpath(result,'//hpoa:numValue');
top.setSessionTimeoutValue(timeout);
}
break;
case 'EVENT_SBL_DOMAIN_INFO_CHANGED':
domainInfo=result;
break;
case 'EVENT_OA_NETWORK_CONFIG_CHANGED':
bayNum=getElementValueXpath(result,'//hpoa:bayNumber');
oaNetworkInfo[bayNum]=result;
break;
case 'EVENT_FW_MGMT_SETTINGS_CHANGED':
case 'EVENT_FW_MGMT_ISO_STATUS':
firmwareManagementSettings=result;
break;
case 'EVENT_ERS_CA_CERT_ADDED':
case 'EVENT_ERS_CA_CERT_REMOVED':
ersCertInfo=result;
break;
case 'EVENT_OA_ERS_CONFIG_CHANGED':
case 'EVENT_OA_ERS_MAINTENANCE_SET':
case 'EVENT_OA_ERS_MAINTENANCE_ENABLED':
case 'EVENT_OA_ERS_MAINTENANCE_CLEARED':
case 'EVENT_OA_ERS_EVENTS_CLEARED':
case 'EVENT_OA_ERS_TEST':
case 'EVENT_OA_ERS_TEST_MANUAL':
case 'EVENT_OA_ERS_DATACOLLECTION_MANUAL':
case 'EVENT_OA_ERS_STATUS':
ersConfigInfo=result;
break;
case 'EVENT_OA_ERS_DATACOLLECTION_FAILURE':
ersConfigInfo=result;
var errorText=assertLocalizedString(getElementValueXpath(result,"//hpoa:extraData[@hpoa:name='ersLastInventoryErrorCode']"),getElementValueXpath(result,"//hpoa:ersLastInventoryErrorStr"));
top.mainPage.displayNotice(top.getString("scheduledDataCollectionFailed:")+"<br /><div style='margin-left:5px;margin-top:2px;'><font style='color:#cc0000;'>"+errorText+"</font></div>",top.getString("remoteSupport"),AlertMsgTypes.Warning,500,5);
break;
case 'EVENT_OA_ERS_DATACOLLECTION_SUCCESS':
ersConfigInfo=result;
top.mainPage.displayNotice(top.getString("scheduledDataCollectionSuccess"),top.getString("remoteSupport"),AlertMsgTypes.Normal,null,5);
break;
case 'EVENT_LANG_PACK_ADDED':
case 'EVENT_LANG_PACK_REMOVED':
langPackInfo=result;
var currentCookieCode=getCookieValue(LANGUAGE_COOKIE_NAME());
if(me.getIsLocal()==true){
if(currentCookieCode!=""&&currentCookieCode!="en"){
if((eventName=="EVENT_LANG_PACK_REMOVED")||(getElementValueXpath(langPackInfo,"//hpoa:language[hpoa:filename != 'Embedded']/hpoa:code")!=currentCookieCode)){
deleteCookieValue(LANGUAGE_COOKIE_NAME());
}
}
if(top.getStringManager().getProperty("AcceptLanguage")!="en"){
top.refreshStrings();
}
}
break;
default:
break;
}
}
}
this.getEventsOn=function(){
try{
return eventsObj.eventsOn;
}catch(e){
return false;
}
}
this.registerForEvents=function(callback){
eventsObj.setCallMethod(me.callMethod);
eventsObj.turnEventsOn(handleEvent,function(success){
if(isFunction(callback)){
callback(success,'registerForEvents');
}
});
}
this.startEvents=function(){
eventsObj.startEvents();
}
this.getTotalEventListeners=function(){
try{
return eventsObj.getCallbackCount();
}catch(e){
return 0;
}
}
this.getNextEvent=function(waitForEvent,callback){
eventsObj.getNextEvent(waitForEvent,function(result){
callback(result,"getNextEvent",me);
});
}
this.getNextEventNoWait=function(callback){
eventsObj.getNextEventNoWait(function(result){
callback(result,"getNextEventNoWait",me);
});
}
this.getEvents=function(){
return(eventsObj?eventsObj:(eventsObj=new events(this,handleEvent)));
}
this.generateHeartbeat=function(callback){
if(existsNonNull(eventsObj)){
eventsObj.generateHeartbeat(function(result){
if(isFunction(callback)){
callback(result,"generateHeartbeat",me);
}
});
}
}
this.stopEvents=function(callback){
if(existsNonNull(eventsObj)){
eventsObj.turnEventsOff(function(result){
if(me.getIsLocal()==true){
try{top.getEventManager().stopEventLoop();}catch(e){}
}
if(isFunction(callback)){
callback(result,'stopEvents');
}
});
}else{
if(isFunction(callback)){
callback(true,'stopEvents');
}
}
}
this.registerEventHandler=function(eventHandler,eventTypes){
if(existsNonNull(eventsObj)){
eventsObj.addCallback(eventHandler,assertNull(eventTypes));
}
}
this.removeRegisteredHandler=function(callback){
if(existsNonNull(eventsObj)){
eventsObj.removeCallback(callback);
}
}
this.setLcdEventsEnabled=function(enabled){
if(existsNonNull(eventsObj)){
eventsObj.setLcdEventsEnabled(enabled);
}
}
this.toggleEventDebugMode=function(debugOn){
if(existsNonNull(eventsObj)){
eventsObj.remoteDebug=debugOn;
}
}
this.ping=function(url,callback){
return me.callMethod("pingUrl",[url,1,1000],callback);
};
this.callMethod=function(method,params,callback,useAuthentication,type,maxWait){
if(!exists(useAuthentication)){var useAuthentication=true;}
if(!existsNonNull(type)){var type=CallTypes.API;}
var callTag=0;
var securityHdr="";
var uuid=me.getUuid();
if(!isArray(params)){
var params=new Array();
}
if(useAuthentication!=false){
securityHdr=securityHeader;
}
if(exists(descriptor[method])){
if(me.getIsConnected()==true){
callTag=top.getTransport().sendRequest(descriptor[method],params,url,securityHdr,callback,uuid,type,maxWait);
}else{
if(isFunction(callback)){
callback(null,method);
}
}
}else{
if(isFunction(callback)){
callback(top.getSoapModule().createSoapResponse(ResponseClones.SoapError,[null,null,null,null,null,SOAP_METHOD_UNDEFINED(method)]),method);
}
return 0;
}
return callTag;
}
this.abortCall=function(type,callTag){
top.getTransport().abortRequest(callTag,type);
}
var startLoadAll=function(num,finalCallback,domReturnFunction){
var loadObject=new Object();
loadObject.numObjects=num;
loadObject.numReturned=0;
loadObject.finalCallback=finalCallback;
loadObject.domReturnFunction=domReturnFunction;
loadObject.loadAllCallback=function(){
loadObject.numReturned++;
if(loadObject.numObjects==loadObject.numReturned){
try{
var callbackResultString='<loadAllReturn/>';
var callbackResultDoc=top.getXml().parseXML(callbackResultString);
try{
callbackResultDoc.xml=callbackResultString;
}catch(e){}
if(typeof(loadObject.domReturnFunction)=='function'){
loadObject.finalCallback(loadObject.domReturnFunction());
}else{
loadObject.finalCallback(callbackResultDoc);
}
}catch(e){}
}
}
callbackObjects.push(loadObject);
return callbackObjects[callbackObjects.length-1];
}
function getCompiledDocument(documentArray,nodeName,sides){
var compiledDocument=null;
var i;
if(typeof(sides)=='undefined'){
sides=1;
}
if(documentArray.length<=(16*(sides-1))){
sides=1;
}
if(documentArray!=null){
compiledDocument=top.getXml().parseXML('<compiledDocumentList xmlns:'+OA_NAMESPACE()+'="'+OA_NAMESPACE_URI()+'" />');
for(var j=0;j<documentArray.length;j++){
if((sides==1)||(j==0)){
i=j;
}else{
i=1+(((j-1)/sides)>>0)+(((j-1)%sides)<<4);
}
var doc=documentArray[i];
var element;
if(doc!=null){
if(!exists(doc.xml)||doc.xml.indexOf(SOAP_FAULT_TEST())>-1){
var presenceCode=ABSENT();
var faultCode=parseInt(getElementValueXpath(doc,'//hpoa:faultInfo/hpoa:errorCode'));
var currentPresence=getElementValueXpath(doc,'//hpoa:presence');
if(faultCode==PERMISSION_DENIED()||currentPresence=='PRESENCE_NO_OP'){
presenceCode=LOCKED();
}
element=getElementForEmpty(nodeName,i,presenceCode);
}
else{
try{
if(exists(doc.getElementsByTagNameNS)){
nodeRefName=nodeName.substring(nodeName.indexOf(':')+1);
element=doc.getElementsByTagNameNS("*",nodeRefName)[0].cloneNode(true);
}else{
element=doc.getElementsByTagName(nodeName)[0].cloneNode(true);
}
}
catch(e){
element=null;
}
}
}else if(i>0){
element=getElementForEmpty(nodeName,i,ABSENT());
}
if(element!=null){
compiledDocument.documentElement.appendChild(element);
}
}
}
var xmlString='';
var returnDoc=null;
if(typeof(XMLSerializer)!='undefined'){
xmlString=new XMLSerializer().serializeToString(compiledDocument);
}else{
xmlString=compiledDocument.xml;
}
returnDoc=top.getXml().parseXML(xmlString);
try{
returnDoc.xml=xmlString;
}catch(e){}
return returnDoc;
}
function getElementForEmpty(elementName,bayNumber,presenceCode){
var hpemElement=null;
if(top.getXml()!=null){
hpemElement=top.getXml().parseXML('<'+elementName+' xmlns:'+OA_NAMESPACE()+'="'+OA_NAMESPACE_URI()+'" />');
var presenceElement=hpemElement.createElement('hpoa:presence');
var presenceValue=hpemElement.createTextNode(''+presenceCode);
presenceElement.appendChild(presenceValue);
var bayNumberElement=hpemElement.createElement('hpoa:bayNumber');
var bayNumberValue=hpemElement.createTextNode(''+bayNumber);
bayNumberElement.appendChild(bayNumberValue);
var bayWidthElement=hpemElement.createElement('hpoa:width');
var bayWidthValue=hpemElement.createTextNode('0');
bayWidthElement.appendChild(bayWidthValue);
var bayHeightElement=hpemElement.createElement('hpoa:height');
var bayHeightValue=hpemElement.createTextNode('0');
bayHeightElement.appendChild(bayHeightValue);
hpemElement.documentElement.appendChild(presenceElement);
hpemElement.documentElement.appendChild(bayNumberElement);
hpemElement.documentElement.appendChild(bayWidthElement);
hpemElement.documentElement.appendChild(bayHeightElement);
hpemElement=hpemElement.documentElement.cloneNode(true);
}
return hpemElement;
}
this.loadCache=function(updateCallback,minimumLoad){
oaInfo=new Array();
oaStatus=new Array();
var objectsToLoad=0;
if(enclosureInfo==null){
this.getEnclosureInfo(updateCallback,true);
objectsToLoad++;
}
this.getEnclosureStatus(updateCallback,true);
objectsToLoad++;
this.getEnclosureNetworkInfo(updateCallback,true);
objectsToLoad++;
this.getOaInfoArray(getXmlBayArray(getAllArray(1,me.getNumManagerBays())),updateCallback);
objectsToLoad++;
this.getOaStatusArray(getXmlBayArray(getAllArray(1,me.getNumManagerBays())),function(result){
updateCallback(result);
try{
var activeBayNum=getElementValueXpath(result,'//hpoa:oaStatus[hpoa:oaRole="ACTIVE"]/hpoa:bayNumber');
me.getOaMediaDeviceArray(activeBayNum,function(){},true);
}catch(e){}
},true);
objectsToLoad++;
this.getCurrentUserInfo(updateCallback,true);
objectsToLoad++;
this.isOaAccess(updateCallback,true);
objectsToLoad++;
this.getCurrentAccessLevel(updateCallback,true);
objectsToLoad++;
this.getTwoFactorAuthenticationConf(updateCallback,true);
objectsToLoad++;
if(this.getIsLocal()){
this.getOaSessionTimeout(updateCallback);
objectsToLoad++;
}
if(minimumLoad==true){
this.setIsMinimumLoad(true);
}else{
this.setIsMinimumLoad(false);
this.getOaNetworkInfoAll(updateCallback,true);
objectsToLoad++;
this.getBladeInfoArray(getXmlBayArray(getAllArray(1,EM_MAX_BLADE_ARRAY())),updateCallback);
objectsToLoad++;
this.getBladeStatusArray(getXmlBayArray(getAllArray(1,EM_MAX_BLADE_ARRAY())),updateCallback);
objectsToLoad++;
this.getPowerSupplyInfoArray(getXmlBayArray(getAllArray(1,me.getNumPowerSupplies())),updateCallback);
objectsToLoad++;
this.getPowerSupplyStatusArray(getXmlBayArray(getAllArray(1,me.getNumPowerSupplies())),updateCallback);
objectsToLoad++;
this.getPowerSubsystemInfo(updateCallback,true);
objectsToLoad++;
this.getThermalSubsystemInfo(updateCallback,true);
objectsToLoad++;
this.getInterconnectTrayInfoArray(getXmlBayArray(getAllArray(1,me.getNumTrays())),updateCallback);
objectsToLoad++;
this.getInterconnectTrayStatusArray(getXmlBayArray(getAllArray(1,me.getNumTrays())),updateCallback);
objectsToLoad++;
this.getFanInfoArray(getXmlBayArray(getAllArray(1,me.getNumFans())),updateCallback);
objectsToLoad++;
this.getLcdInfo(updateCallback,true);
objectsToLoad++;
this.getLcdStatus(updateCallback,true);
objectsToLoad++;
this.getUsers(updateCallback);
objectsToLoad++;
this.getLdapGroups(updateCallback);
objectsToLoad++;
this.getOaVcmMode(updateCallback,true);
objectsToLoad++;
this.getVcmOaMinFwVersion(updateCallback,true);
objectsToLoad++;
this.getVcmIpv6UrlList(updateCallback,true);
objectsToLoad++;
this.getKvmInfo(updateCallback,true);
objectsToLoad++;
this.getDomainInfo(updateCallback,true);
objectsToLoad++;
if(this.getRemoteSupportLocked()==false){
this.getErsConfigInfo(updateCallback,true);
objectsToLoad++;
}
}
return objectsToLoad;
}
this.clearCache=function(){
echo("Cache being cleared.",5,1);
isEfmSupported=null;
isErsLocked=null;
oaNetworkInfo=new Array();
oaThermals=new Array();
oaMediaDevices=new Array();
bladeInfo=new Array();
bladeStatus=new Array();
bladeMpInfo=new Array();
bladeMpCredentials=new Array();
bladePortMap=new Array();
bladeMezzInfoEx=new Array();
bladeThermals=new Array();
bladeThermalInfo=new Array();
bladeFirmware=new Array();
fanInfo=new Array();
powerSupplyInfo=new Array();
powerSupplyStatus=new Array();
interconnectTrayInfo=new Array();
interconnectTrayStatus=new Array();
interconnectTrayPortMap=new Array();
interconnectThermals=new Array();
userList=new Array();
groupList=new Array();
sslSettingsInfo=null;
soapInterfaceInfo=null;
enclosureStatus=null;
enclosureThermals=null;
domainInfo=null;
powerSubsystemInfo=null;
powerConfigInfo=null;
powerCapConfig=null;
powerCapExtConfig=null;
powerCapBladeStatus=null;
thermalSubsystemInfo=null;
enclosureNetworkInfo=null;
snmpInfo=null;
snmpInfo3=null;
ldapInfo=null;
enclosureTime=null;
timeZones=null;
alertmailInfo=null;
users=null;
groups=null;
ebipaInfo=null;
ebipaInfoEx=null;
ebipaDevInfo=null;
ebipav6Info=null;
ebipav6InfoEx=null;
lcdInfo=null;
lcdStatus=null;
hpSimInfo=null;
certificateRequest=null;
passwordSettings=null;
syslogSettings=null;
usbFirmwareList=null;
usbConfigScriptList=null;
powerDelaySettings=null;
firmwareManagementSettings=null;
enclosureComponentFirmware=null;
saPciList=null;
ersConfigInfo=null;
loginBannerSettings=null;
langPackInfo=null;
configScriptInProgress=false;
caCertInfo=null;
ersCertInfo=null;
accessLevel=null;
oaPermission=null;
currentUserInfo=null;
twoFactorInfo=null;
vlanInfo=null;
oaInfoDOM=null;
oaStatusDOM=null;
oaThermalsDOM=null;
oaNetworkDOM=null;
oaMediaDeviceDOM=null;
oaVcmMode=null;
vcmOaMinFwVer=null;
vcmIpv6UrlList=null;
bladeInfoDOM=null;
bladeStatusDOM=null;
bladeMpInfoDOM=null;
bladePortMapDOM=null;
bladeThermalDOM=null;
bladeFirmwareDOM=null;
fanInfoDOM=null;
powerSupplyInfoDOM=null;
powerSupplyStatusDOM=null;
interconnectTrayInfoDOM=null;
interconnectTrayStatusDOM=null;
interconnectTrayPortMapDOM=null;
interconnectTrayThermalDOM=null;
usersDOM=null;
groupsDOM=null;
virtualMediaStatus=new Array();
virtualMediaStatusDOM=null;
virtualMediaUrlDoc=null;
}
this.loadCacheStandby=function(bayNum,updateCallback){
oaInfo=new Array();
oaStatus=new Array();
var objectsToLoad=0;
this.getOaInfoArray(getXmlBayArray(getAllArray(1,me.getNumManagerBays())),updateCallback);
objectsToLoad++;
this.getOaStatusArray(getXmlBayArray(getAllArray(1,me.getNumManagerBays())),updateCallback);
objectsToLoad++;
this.getEnclosureNetworkInfo(updateCallback,true);
objectsToLoad++;
this.getOaNetworkInfoAll(updateCallback,true);
objectsToLoad++;
this.getCurrentUserInfo(updateCallback,true);
objectsToLoad++;
this.isOaAccess(updateCallback,true);
objectsToLoad++;
this.getCurrentAccessLevel(updateCallback,true);
objectsToLoad++;
this.getTwoFactorAuthenticationConf(updateCallback,true);
objectsToLoad++;
this.getOaSessionTimeout(updateCallback);
objectsToLoad++;
return objectsToLoad;
}
this.getManagedData=function(method,params,cacheObject,callback,fresh,useAuthentication,preserveCache,validationFunction){
var mgDataResult=eval(cacheObject);
var cachedFault=null;
try{
if(mgDataResult!=null){
cachedFault=(typeof(mgDataResult.xml)!="undefined"&&mgDataResult.xml.indexOf(SOAP_FAULT_TEST())>-1);
}
if(mgDataResult==null||fresh==true||cachedFault==true){
me.callMethod(method,params,function(result,fName){
if(preserveCache==true&&cachedFault==false&&(result.xml&&result.xml.indexOf(SOAP_FAULT_TEST())>-1)){
echo("Received soap fault for "+cacheObject+" - preserving cache.",4,5);
}else{
if(isFunction(validationFunction)){
result=validationFunction(result);
}
eval(''+cacheObject+'=result');
mgDataResult=eval(cacheObject);
}
if(isFunction(callback)){
callback(mgDataResult,fName);
}
},assertTrue(useAuthentication));
}else{
if(isFunction(callback)){
callback(mgDataResult,method);
}
return mgDataResult;
}
}catch(e){
echo("getManagedData error: "+e,1,6,["Method: "+method,"CacheObject: "+cacheObject]);
}
return(mgDataResult==null?top.getXml().parseXML('<br />'):mgDataResult);
}
this.downloadConfigScript=function(url,callback){
configScriptInProgress=true;
return me.callMethod("downloadConfigScript",[url],function(result){
configScriptInProgress=false;
if(isFunction(callback)){
callback(result);
}
},true,CallTypes.API,330000);
}
this.getSoapInterfaceInfo=function(callback,fresh){
return me.getManagedData("getSoapInterfaceInfo",[],'soapInterfaceInfo',assertNull(callback),assertFalse(fresh));
}
this.setSslSettings=function(sslSettings,callback){
return me.callMethod("setSslSettings",[sslSettings],callback);
}
this.getSslSettings=function(callback,fresh){
return me.getManagedData("getSslSettings",[],'sslSettingsInfo',assertNull(callback),assertFalse(fresh));
}
this.createCertificateRequest=function(callback){
return me.callMethod("createCertificateRequest",[],callback);
}
this.getSslCertificateInfo=function(callback){
return me.callMethod("getSslCertificateInfo",[],callback);
}
this.getUserCertificateInfo=function(username,callback){
return me.callMethod("getUserCertificateInfo",[username],callback);
}
this.getSslCertificateInfoEx=function(bayNumber,callback){
return me.callMethod("getSslCertificateInfoEx",[bayNumber],callback);
}
this.createSelfSignedCertificate=function(callback){
return me.callMethod("createSelfSignedCertificate",[],callback);
}
this.setCertificate=function(certificate,callback){
return me.callMethod("setCertificate",[certificate],callback);
}
this.addCaCertificate=function(certificate,callback){
return me.callMethod("addCaCertificate",[certificate],callback);
}
this.setUserCertificate=function(username,certificate,callback){
return me.callMethod("setUserCertificate",[username,certificate],callback);
}
this.setCertificateEx=function(bayNumber,certificate,callback){
return me.callMethod("setCertificateEx",[bayNumber,certificate],callback,true,CallTypes.API,300000);
}
this.downloadCertificate=function(url,callback){
return me.callMethod("downloadCertificate",[url],callback,true,CallTypes.API,300000);
}
this.downloadCertificateEx=function(bayNumber,url,callback){
return me.callMethod("downloadCertificateEx",[bayNumber,url],callback,true,CallTypes.API,300000);
}
this.downloadUserCertificate=function(username,url,callback){
return me.callMethod("downloadUserCertificate",[username,url],callback,true,CallTypes.API,300000);
}
this.downloadCaCertificate=function(certUrl,callback){
return me.callMethod("downloadCaCertificate",[certUrl],callback,true,CallTypes.API,300000);
}
this.generateCsr=function(bayNumber,certificateData,callback){
return me.callMethod("generateCsr",[bayNumber,certificateData],callback);
}
this.generateCsrEx=function(bayNumber,certificateDataEx,callback){
return me.callMethod("generateCsrEx",[bayNumber,certificateDataEx],callback);
}
this.generateSelfSignedCertificate=function(bayNumber,certificateData,callback){
return me.callMethod("generateSelfSignedCertificate",[bayNumber,certificateData],callback);
}
this.generateSelfSignedCertificateEx=function(bayNumber,certificateDataEx,callback){
return me.callMethod("generateSelfSignedCertificateEx",[bayNumber,certificateDataEx],callback);
}
this.getRackTopology=function(callback,maxWait){
me.callMethod("getRackTopology",[],function(result){
if(isFunction(callback)){
callback(result,"getRackTopology");
}else{
return result;
}
},false,CallTypes.API,maxWait);
}
this.getRackTopology2=function(callback,maxWait){
me.callMethod("getRackTopology2",[],function(result){
if(isFunction(callback)){
callback(result,"getRackTopology2");
}else{
return result;
}
},(isAuthenticated?true:false),CallTypes.API,maxWait);
}
this.flashOaRomFirmwareISO=function(force,callback){
return me.callMethod("flashOaRomFirmwareISO",[force],callback,true,CallTypes.API,0);
}
this.flashOaRom=function(filePath,reset,callback){
return me.callMethod("flashOaRom",[filePath,reset],callback,true,CallTypes.API,0);
}
this.flashOaRomEnhanced=function(filePath,reset,force,callback){
return me.callMethod("flashOaRomEnhanced",[filePath,reset,force],callback,true,CallTypes.API,0);
}
this.syncOaRomEnhanced=function(callback){
return me.callMethod("syncOaRomEnhanced",[],callback,true,CallTypes.API,0);
}
this.downloadFile=function(fileType,fileUrl,callback){
return me.callMethod("downloadFile",[fileType,fileUrl],callback,true,CallTypes.API,299000);
}
this.setBladePower=function(bayNumber,powerMode,callback){
return me.callMethod("setBladePower",[bayNumber,powerMode],callback);
}
this.setBladeUid=function(bayNumber,uidState,callback){
return me.callMethod("setBladeUid",[bayNumber,uidState],callback);
}
this.setBladeIplBootPriority=function(bayNumber,bladeIplArray,callback){
return me.callMethod("setBladeIplBootPriority",[bayNumber,bladeIplArray],callback);
}
this.setBladeOneTimeBoot=function(bayNumber,device,bootAgent,displayMessages,callback){
return me.callMethod("setBladeOneTimeBoot",[bayNumber,device,bootAgent,displayMessages],callback);
}
this.setBladeIplBootPriorityEx=function(bayNumber,bladeIplBootArrayEx,callback){
return me.callMethod("setBladeIplBootPriorityEx",[bayNumber,bladeIplBootArrayEx],callback);
}
this.setBladeOneTimeBootEx=function(bayNumber,device,bootAgent,bypassF1F2,toggleBootMode,callback){
return me.callMethod("setBladeOneTimeBootEx",[bayNumber,device,bootAgent,bypassF1F2,toggleBootMode],callback);
}
this.setPowerdelayServerSettings=function(powerDelaySettings,callback){
return me.callMethod("setPowerdelayServerSettings",[powerDelaySettings],callback);
}
this.setPowerdelayInterconnectSettings=function(powerDelaySettings,callback){
return me.callMethod("setPowerdelayInterconnectSettings",[powerDelaySettings],callback);
}
this.setAlertmailServer=function(server,callback){
return me.callMethod("setAlertmailServer",[server],callback);
}
this.setAlertmailReceiver=function(receiver,callback){
return me.callMethod("setAlertmailReceiver",[receiver],callback);
}
this.setAlertmailDomain=function(domain,callback){
return me.callMethod("setAlertmailDomain",[domain],callback);
}
this.setAlertmailSenderEmail=function(email,callback){
return me.callMethod("setAlertmailSenderEmail",[email],callback);
}
this.setAlertmailSenderName=function(name,callback){
return me.callMethod("setAlertmailSenderName",[name],callback);
}
this.testAlertmail=function(callback){
return me.callMethod("testAlertmail",[],callback);
}
this.testSnmp=function(callback){
return me.callMethod("testSnmp",[],callback);
}
this.setEnclosureAssetTag=function(assetTag,callback){
return me.callMethod("setEnclosureAssetTag",[assetTag],callback);
}
this.setEnclosureName=function(encName,callback){
return me.callMethod("setEnclosureName",[encName],callback);
}
this.setRackName=function(rackName,callback){
return me.callMethod("setRackName",[rackName],callback);
}
this.setNetworkProtocol=function(protocol,enabled,callback){
return me.callMethod("setNetworkProtocol",[protocol,enabled],callback);
}
this.setNetworkProtocols=function(http,ssh,telnet,xmlreply,fips,callback){
return me.callMethod("setNetworkProtocols",[http,ssh,telnet,xmlreply,fips],callback);
}
this.setFipsEnabled=function(enabled,callback){
return me.callMethod("setFipsEnabled",[enabled],callback);
}
this.setFipsMode=function(fipsMode,password,callback){
return me.callMethod("setFipsMode",[fipsMode,password],callback,true,CallTypes.API,299000);
}
this.configureOaNicForced=function(bayNumber,speed,duplex,callback){
return me.callMethod("configureOaNicForced",[bayNumber,speed,duplex],callback);
}
this.configureOaNicAuto=function(bayNumber,callback){
return me.callMethod("configureOaNicAuto",[bayNumber],callback);
}
this.setLinkFailoverEnabled=function(enabled,callback){
return me.callMethod("setLinkFailoverEnabled",[enabled],callback);
}
this.setLinkFailoverInterval=function(interval,callback){
return me.callMethod("setLinkFailoverInterval",[interval],callback);
}
this.setGuiLoginDetailEnabled=function(enabled,callback){
return me.callMethod("setGuiLoginDetailEnabled",[enabled],callback);
}
this.getRemoteSupportLocked=function(){
if(enclosureInfo==null){
return true;
}
if(isErsLocked==null){
isErsLocked=(getElementValueXpath(enclosureInfo,"//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='ersLock']")!="false");
}
return isErsLocked;
}
this.getRemoteSupportDirectLocked=function(){
if(ersConfigInfo==null){
return true;
}
return(getElementValueXpath(ersConfigInfo,"//hpoa:ersConfigInfo/hpoa:extraData[@hpoa:name = 'ersLockDirect']")!="false");
}
this.enableErs=function(mode,user,passwd,irsHostname,irsPort,optin,locale,eula,callback){
return me.callMethod("enableErs",[mode,user,passwd,irsHostname,irsPort,optin,locale,eula],callback);
}
this.disableErs=function(callback){
return me.callMethod("disableErs",[],callback);
}
this.getErsConfigInfo=function(callback,fresh){
return me.getManagedData("getErsConfigInfo",[],'ersConfigInfo',assertNull(callback),assertFalse(fresh));
}
this.getErsCertificatesInfo=function(callback,fresh){
return me.getManagedData("getErsCertificatesInfo",[],'ersCertInfo',assertNull(callback),assertFalse(fresh));
}
this.setErsProxyUrl=function(proxyUrl,proxyPort,username,password,callback){
return me.callMethod("setErsProxyUrl",[proxyUrl,proxyPort,username,password],callback);
}
this.setErsUrl=function(ersUrl,callback){
return me.callMethod("setErsUrl",[ersUrl],callback);
}
this.sendErsDataCollection=function(callback){
return me.callMethod("sendErsDataCollection",[],callback);
}
this.setErsMaintenance=function(enabled,minutes,callback){
return me.callMethod("setErsMaintenance",[enabled,minutes],callback);
}
this.setErsOnlineRegistrationComplete=function(callback){
return me.callMethod("setErsOnlineRegistrationComplete",[],callback);
}
this.testErs=function(callback){
return me.callMethod("testErs",[],callback);
}
this.clearErsServiceEventLog=function(callback){
return me.callMethod("clearErsServiceEvents",[],callback);
}
this.downloadErsCertificate=function(url,callback){
return me.callMethod("downloadErsCertificate",[url],callback);
}
this.addErsCertificate=function(certificate,callback){
return me.callMethod("addErsCertificate",[certificate],callback);
}
this.removeErsCertificate=function(fingerprint,callback){
return me.callMethod("removeErsCertificate",[fingerprint],callback);
}
this.setSnmpContact=function(contact,callback){
return me.callMethod("setSnmpContact",[contact],callback);
}
this.setSnmpLocation=function(location,callback){
return me.callMethod("setSnmpLocation",[location],callback);
}
this.setSnmpReadCommunity=function(ro,callback){
return me.callMethod("setSnmpReadCommunity",[ro],callback);
}
this.setSnmpWriteCommunity=function(rw,callback){
return me.callMethod("setSnmpWriteCommunity",[rw],callback);
}
this.addSnmpTrapReceiver=function(receiverIp,receiverCommunity,callback){
return me.callMethod("addSnmpTrapReceiver",[receiverIp,receiverCommunity],callback);
}
this.addSnmpTrapReceiver3=function(receiverIp,user,engineid,security,inform,callback){
return me.callMethod("addSnmpTrapReceiver3",[receiverIp,user,engineid,security,inform],callback);
}
this.removeSnmpTrapReceiver=function(receiverIp,callback){
return me.callMethod("removeSnmpTrapReceiver",[receiverIp],callback);
}
this.removeSnmpTrapReceiverEx=function(receiverIp,community,callback){
return me.callMethod("removeSnmpTrapReceiverEx",[receiverIp,community],callback);
}
this.removeSnmpTrapReceiver3=function(receiverIp,user,engineid,callback){
return me.callMethod("removeSnmpTrapReceiver3",[receiverIp,user,engineid],callback);
}
this.addSnmpUser=function(username,authAlgorithm,authPassword,privAlgorithm,privPassword,engineid,security,rw,callback){
return me.callMethod("addSnmpUser",[username,authAlgorithm,authPassword,privAlgorithm,privPassword,engineid,security,rw],callback);
}
this.removeSnmpUser=function(username,engineid,callback){
return me.callMethod("removeSnmpUser",[username,engineid],callback);
}
this.getSnmpInfo=function(callback,fresh){
return me.getManagedData("getSnmpInfo",[],'snmpInfo',assertNull(callback),assertFalse(fresh));
}
this.getSnmpInfo3=function(callback,fresh){
return me.getManagedData("getSnmpInfo3",[],'snmpInfo3',assertNull(callback),assertFalse(fresh));
}
this.setSnmpEngineId=function(engineid,callback){
return me.callMethod("setSnmpEngineId",[engineid],callback);
}
this.getAlertmailInfo=function(callback,fresh){
return me.getManagedData("getAlertmailInfo",[],'alertmailInfo',assertNull(callback),assertFalse(fresh));
}
this.getFirmwareManagementSupported=function(){
if(enclosureInfo==null){
return false;
}
if(isEfmSupported==null){
isEfmSupported=(getElementValueXpath(enclosureInfo,"//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='firmwareMgmtSupported']")=="true");
}
return isEfmSupported;
}
this.getFirmwareManagementSettings=function(callback,fresh){
return me.getManagedData("getFirmwareManagementSettings",[],'firmwareManagementSettings',assertNull(callback),assertFalse(fresh));
}
this.setFirmwareManagementForceDowngrade=function(enabled,callback){
return me.callMethod("setFirmwareManagementForceDowngrade",[enabled],callback);
}
this.setFirmwareManagementIsoUrl=function(isoUrl,callback){
return me.callMethod("setFirmwareManagementIsoUrl",[isoUrl],callback);
}
this.setFirmwareManagementPolicy=function(policy,callback){
return me.callMethod("setFirmwareManagementPolicy",[policy],callback);
}
this.setFirmwareManagementPowerPolicy=function(powerPolicy,callback){
return me.callMethod("setFirmwareManagementPowerPolicy",[powerPolicy],callback);
}
this.setFirmwareManagementEnabled=function(enabled,callback){
return me.callMethod("setFirmwareManagementEnabled",[enabled],callback);
}
this.setFirmwareManagementSchedule=function(date,time,callback){
return me.callMethod("setFirmwareManagementSchedule",[date,time],callback);
}
this.getSaPCIList=function(callback,fresh){
return me.getManagedData("getSaPCIList",[],'saPciList',assertNull(callback),assertFalse(fresh));
}
this.getThermalInfo=function(sensorType,bayNumber,objectName,callback,fresh){
return me.getManagedData("getThermalInfo",[sensorType,bayNumber],objectName,assertNull(callback),assertFalse(fresh));
}
this.getEnclosureThermalInfo=function(callback,fresh){
return me.getThermalInfo('SENSOR_TYPE_ENC',1,'enclosureThermals',callback,fresh);
}
this.setOaName=function(bayNumber,name,callback){
return me.callMethod("setOaName",[bayNumber,name],callback);
}
this.setOaUserDomainNameAndState=function(bayNumber,domainName,enabled,callback){
return me.callMethod("setOaUserDomainNameAndState",[bayNumber,domainName,enabled],callback);
}
this.setIpConfigStatic=function(bayNumber,ipAddress,netmask,gateway,dns1,dns2,callback){
return me.callMethod("setIpConfigStatic",[bayNumber,ipAddress,netmask,gateway,dns1,dns2],callback);
}
this.configureOaDhcp=function(bayNumber,enableDynDNS,callback){
return me.callMethod("configureOaDhcp",[bayNumber,enableDynDNS],callback);
}
this.setStaticIpv6=function(bayNumber,ipAddress,prefix,add,callback){
return me.callMethod("setStaticIpv6",[bayNumber,ipAddress,prefix,add,callback],callback);
}
this.setOaNetworkStaticIpv6=function(bayNumber,staticIpv6Address1,staticIpv6Address2,staticIpv6Address3,staticIpv6Dns1,staticIpv6Dns2,callback){
return me.callMethod("setOaNetworkStaticIpv6",[bayNumber,staticIpv6Address1,staticIpv6Address2,staticIpv6Address3,staticIpv6Dns1,staticIpv6Dns2,callback],callback);
}
this.setIpConfigIpv6=function(bayNumber,enable,callback){
return me.callMethod("setIpConfigIpv6",[bayNumber,enable],callback);
}
this.setIpConfigDhcpIpv6=function(bayNumber,enable,callback){
return me.callMethod("setIpConfigDhcpIpv6",[bayNumber,enable],callback);
}
this.setRouterAdvertisementIpv6=function(bayNumber,enable,callback){
return me.callMethod("setRouterAdvertisementIpv6",[bayNumber,enable],callback);
}
this.setOaIpv6Settings=function(bayNumber,ipv6Enable,dhcpv6Enable,routerAdvEnable,callback){
return me.callMethod("setOaIpv6Settings",[bayNumber,ipv6Enable,dhcpv6Enable,routerAdvEnable],callback,true,CallTypes.API,180000);
}
this.setEnclosureIpv6Settings=function(ipv6Enable,dhcpv6Enable,routerTrafficEnable,routerAdvEnable,callback){
return me.callMethod("setEnclosureIpv6Settings",[ipv6Enable,dhcpv6Enable,routerTrafficEnable,routerAdvEnable],callback,true,CallTypes.API,180000);
}
this.configureOaIpv6DyndnsBay=function(bayNumber,ipv6DdnsEnable,callback){
return me.callMethod("configureOaIpv6DyndnsBay",[bayNumber,ipv6DdnsEnable],callback);
}
this.setOaDnsIpv6=function(bayNumber,dns1,dns2,callback){
return me.callMethod("setOaDnsIpv6",[bayNumber,dns1,dns2,callback],callback);
}
this.configureOaStatic=function(bayNumber,ipAddress,netmask,callback){
return me.callMethod("configureOaStatic",[bayNumber,ipAddress,netmask],callback);
}
this.setOaDefaultGateway=function(bayNumber,gateway,callback){
return me.callMethod("setOaDefaultGateway",[bayNumber,gateway],callback);
}
this.setOaIpv6StaticDefaultGateway=function(bayNumber,gateway,callback){
return me.callMethod("setOaIpv6StaticDefaultGateway",[bayNumber,gateway],callback);
}
this.setOaIpv6StaticRoutes=function(bayNumber,ipv6StaticRouteDestination1,ipv6StaticRouteDestination2,ipv6StaticRouteDestination3,ipv6StaticRouteGateway1,ipv6StaticRouteGateway2,ipv6StaticRouteGateway3,callback){
return me.callMethod("setOaIpv6StaticRoutes",[bayNumber,ipv6StaticRouteDestination1,ipv6StaticRouteDestination2,ipv6StaticRouteDestination3,ipv6StaticRouteGateway1,ipv6StaticRouteGateway2,ipv6StaticRouteGateway3],callback);
}
this.setOaDns=function(bayNumber,dns1,dns2,callback){
return me.callMethod("setOaDns",[bayNumber,dns1,dns2],callback);
}
this.setNtpPrimary=function(address,callback){
return me.callMethod("setNtpPrimary",[address],callback);
}
this.setNtpSecondary=function(address,callback){
return me.callMethod("setNtpSecondary",[address],callback);
}
this.setNtpPoll=function(seconds,callback){
return me.callMethod("setNtpPoll",[seconds],callback);
}
this.configureNtp=function(ntp1,ntp2,poll,callback){
return me.callMethod("configureNtp",[ntp1,ntp2,poll],callback);
}
this.resetOa=function(bayNumber,wait,callback){
return me.callMethod("resetOa",[bayNumber,wait],callback);
}
this.setOaUid=function(bayNumber,uidState,callback){
return me.callMethod('setOaUid',[bayNumber,uidState],callback)
}
this.getOaSyslog=function(bayNumber,callback){
return me.callMethod("getOaSyslog",[bayNumber,0],callback);
}
this.setRemoteSyslogEnabled=function(enabled,callback){
return me.callMethod("setRemoteSyslogEnabled",[enabled],callback);
}
this.setRemoteSyslogServer=function(server,callback){
return me.callMethod("setRemoteSyslogServer",[server],callback);
}
this.setRemoteSyslogPort=function(port,callback){
return me.callMethod("setRemoteSyslogPort",[port],callback);
}
this.testRemoteSyslog=function(callback){
return me.callMethod("testRemoteSyslog",[],callback,true,CallTypes.API,120000);
}
this.clearOaSyslog=function(bayNumber,callback){
return me.callMethod("clearOaSyslog",[bayNumber],callback);
}
this.getSyslogSettings=function(callback,fresh){
return me.getManagedData("getSyslogSettings",[],'syslogSettings',assertNull(callback),assertFalse(fresh));
}
this.clearFirmwareManagementLog=function(callback){
return me.callMethod("clearFirmwareManagementLog",[],callback);
}
this.clearFirmwareManagementAllLogs=function(callback){
return me.callMethod("clearFirmwareManagementAllLogs",[],callback);
}
this.addTrustedIpAddress=function(ipAddress,callback){
return me.callMethod("addTrustedIpAddress",[ipAddress],callback);
}
this.removeTrustedIpAddress=function(ipAddress,callback){
return me.callMethod("removeTrustedIpAddress",[ipAddress],callback);
}
this.removeUserCertificate=function(username,callback){
return me.callMethod("removeUserCertificate",[username],callback);
}
this.removeCaCertificate=function(fingerprint,callback){
return me.callMethod("removeCaCertificate",[fingerprint],callback);
}
this.setEnclosureTime=function(dateTime,callback){
return me.callMethod("setEnclosureTime",[dateTime],callback);
}
this.setEnclosureTimeZone=function(timeZone,callback){
return me.callMethod("setEnclosureTimeZone",[timeZone],callback);
}
this.setEnclosureUid=function(uidState,callback){
return me.callMethod("setEnclosureUid",[uidState],callback);
}
this.getBladeStatus=function(bayNumber,callback,fresh){
return me.getManagedData("getBladeStatus",[bayNumber],'bladeStatus['+bayNumber+']',assertNull(callback),assertFalse(fresh),null,null,validateBladeStatus);
}
this.getBladeStatusAll=function(callback,fresh){
var numBlades=me.getNumBlades();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((bladeStatus.length-1)!=numBlades):fresh;
var loaderObject=startLoadAll(numBlades,callback,me.getBladeStatusDOM);
if(fresh){
for(var i=1;i<=numBlades;i++){
me.getBladeStatus(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getBladeStatusDOM(true));
}else{
return bladeStatus;
}
}
}
this.getBladeStatusArray=function(bayArray,callback){
me.callMethod("getBladeStatusArray",[bayArray],function(result){
bladeStatus=deCompileXmlArray(result,'//hpoa:bladeStatusArray','hpoa:bladeStatus');
for(var i=0;i<bladeStatus.length;i++){
bladeStatus[i]=validateBladeStatus(bladeStatus[i]);
}
me.getBladeStatusDOM(true);
callback(result);
},true,CallTypes.API,270000);
}
this.getBladeStatusDOM=function(fresh){
if(assertFalse(fresh)||bladeStatusDOM==null){
bladeStatusDOM=getCompiledDocument(bladeStatus,'hpoa:bladeStatus');
}
return bladeStatusDOM;
}
this.getBladeThermals=function(bayNumber,callback,fresh){
return me.getThermalInfo('SENSOR_TYPE_BLADE',bayNumber,'bladeThermals['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getBladeThermalsAll=function(callback,fresh){
var numBlades=me.getNumBlades();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((bladeThermals.length-1)!=numBlades):fresh;
var loaderObject=startLoadAll(numBlades,callback,me.getBladeThermalsDOM);
if(fresh){
for(var i=1;i<=numBlades;i++){
me.getBladeThermals(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getBladeThermalsDOM(true));
}else{
return bladeStatus;
}
}
}
this.getBladeThermalsDOM=function(fresh){
if(assertFalse(fresh)||bladeThermalDOM==null){
bladeThermalDOM=getCompiledDocument(bladeThermals,'hpoa:thermalInfo');
}
return bladeThermalDOM;
}
this.getBladeBootInfo=function(bayNumber,callback){
return me.callMethod("getBladeBootInfo",[bayNumber],callback);
}
this.getBladeBootInfoEx=function(bayNumber,callback){
return me.callMethod("getBladeBootInfoEx",[bayNumber],callback);
}
this.getBladeInfo=function(bayNumber,callback,fresh){
return me.getManagedData("getBladeInfo",[bayNumber],'bladeInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getBladeFirmwareLog=function(bayNumber,callback){
return me.callMethod("getBladeFirmwareLog",[bayNumber],callback);
}
this.getBladeFirmwareExecLog=function(bayNumber,callback){
return me.callMethod("getBladeFirmwareExecLog",[bayNumber],callback);
}
this.getBladeFirmwareHPSUMLog=function(bayNumber,callback){
return me.callMethod("getBladeFirmwareHPSUMLog",[bayNumber],callback);
}
this.getBladePostLog=function(bayNumber,callback){
return me.callMethod("getBladePostLog",[bayNumber],callback);
}
this.getFirmwareManagementLog=function(callback){
return me.callMethod("getFirmwareManagementLog",[],callback);
}
this.getBladeFirmware=function(bayNumber,callback,fresh){
return me.getManagedData("getBladeFirmware",[bayNumber],'bladeFirmware['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getBladeFirmwareDoc=function(bayNumber,callback,fresh){
var xml=top.getXml();
var firmwareText='';
var lastUpdate='';
var firmwareDoc=null;
if(bladeFirmware[bayNumber]){
firmwareText=getElementValueFromString(bladeFirmware[bayNumber].xml,'hpoa:bladeFirmwareXml');
lastUpdate=getElementValueXpath(bladeFirmware[bayNumber],'//hpoa:lastUpdateDate');
firmwareText="<bladeFirmware bayNumber=\""+bayNumber+"\" lastUpdate=\""+lastUpdate+"\">"+firmwareText+"</bladeFirmware>";
firmwareDoc=xml.parseXML(firmwareText);
if(callback)
callback(firmwareDoc);
}else{
firmwareText="<bladeFirmware bayNumber=\""+bayNumber+"\" error=\"true\"/>";
firmwareDoc=xml.parseXML(firmwareText);
}
return firmwareDoc;
}
this.getBladeFirmwareArray=function(bayArray,callback){
me.callMethod("getBladeFirmwareArray",[bayArray],function(result){
bladeFirmware=deCompileXmlArray(result,'//hpoa:bladeFirmwareArray','hpoa:bladeFirmwareInfo');
me.getBladeFirmwareDOM();
callback(result);
},true,CallTypes.API,270000);
}
this.getBladeFirmwareDOM=function(complete){
var xml=top.getXml();
var enclosureName=me.getEnclosureName();
var compiledDocument=xml.parseXML('<bladeFirmwareList enclosureName="'+enclosureName+'" />');
var firmwareDoc=null;
var firmwareText='';
var bInfo;
if(typeof(complete)=='undefined'){
var complete=false;
}
for(var i=1;i<bladeFirmware.length;i++){
bInfo=me.getBladeInfo(i);
if(getElementValueXpath(bInfo,'//hpoa:presence')!='PRESENT')
continue;
if(getElementValueXpath(bInfo,'//hpoa:bladeType')!='BLADE_TYPE_SERVER')
continue;
var bladeName=getElementValueXpath(bInfo,'//hpoa:name');
var symbolicBayNumber=getElementValueXpath(bInfo,'//hpoa:extraData[@hpoa:name="SymbolicBladeNumber"]');
var lastUpdate=getElementValueXpath(bladeFirmware[i],'//hpoa:lastUpdateDate');
var bladeFirmwareContent=getElementValueFromString(bladeFirmware[i].xml,'hpoa:bladeFirmwareXml');
var romVersion=getElementValueXpath(bInfo,'//hpoa:romVersion');
var iloModel=getElementValueXpath(bladeMpInfo[i],'//hpoa:modelName');
var iloVersion=getElementValueXpath(bladeMpInfo[i],'//hpoa:fwVersion');
var pmcVersion=getElementValueXpath(bladeMpInfo[i],'//hpoa:extraData[@hpoa:name="picFwVersion"]');
firmwareText="<bladeFirmware bayNumber=\""+i+"\" symbolicBayNumber=\""+symbolicBayNumber+"\" lastUpdate=\""+lastUpdate+"\" name=\""+bladeName+"\">";
firmwareText+=bladeFirmwareContent;
firmwareText+="<rom>"+romVersion+"</rom>";
firmwareText+="<iLO><model>"+iloModel+"</model><version>"+iloVersion+"</version></iLO>";
firmwareText+="<pmcVersion>"+pmcVersion+"</pmcVersion>";
firmwareText+="</bladeFirmware>";
firmwareDoc=xml.parseXML(firmwareText);
if(firmwareDoc.documentElement!=null)
compiledDocument.documentElement.appendChild(firmwareDoc.documentElement.cloneNode(true));
}
return compiledDocument;
}
this.bladeManualDiscovery=function(baySelection,callback){
return me.callMethod("bladeManualDiscovery",[baySelection],callback);
}
this.bladeManualUpdate=function(baySelection,callback){
return me.callMethod("bladeManualUpdate",[baySelection],callback);
}
this.setFirmwareManagementBays=function(baySelection,callback){
return me.callMethod("setFirmwareManagementBays",[baySelection],callback);
}
this.getBladeInfoAll=function(callback,fresh){
var numBlades=me.getNumBlades();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((bladeInfo.length-1)!=numBlades):fresh;
var loaderObject=startLoadAll(numBlades,callback,me.getBladeInfoDOM);
if(fresh){
for(var i=1;i<=numBlades;i++){
me.getBladeInfo(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getBladeInfoDOM(true));
}else{
return bladeInfo;
}
}
}
this.getBladeInfoArray=function(bayArray,callback){
me.callMethod("getBladeInfoArray",[bayArray],function(result){
bladeInfo=deCompileXmlArray(result,'//hpoa:bladeInfoArray','hpoa:bladeInfo');
me.getBladeInfoDOM(true);
callback(result);
},true,CallTypes.API,270000);
}
this.refreshServerIDs=function(bayNum){
var formMgr=new FormManager(function(success){
me.getEvents().generateEvent('EVENT_BLADE_INFO',bladeInfo[bayNum],'//hpoa:bladeInfo');
});
formMgr.startBatch(true,true);
formMgr.queueCall(me.getBladeInfo,[bayNum]);
formMgr.queueCall(me.getBladePortMap,[bayNum]);
formMgr.endBatch();
}
this.updateProLiantMp=function(bayArray,iLoImageUrl,crc32,callback){
return me.callMethod("updateProLiantMp",[bayArray,iLoImageUrl,crc32],callback,true,CallTypes.API,270000);
}
this.getBladeThermalInfoArray=function(bayNumber,callback,fresh){
return me.getManagedData("getBladeThermalInfoArray",[bayNumber],'bladeThermalInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getBladeThermalInfoDOM=function(fresh){
if(assertFalse(fresh)||bladeThermalInfoDOM==null){
bladeThermalInfoDOM=getCompiledDocument(bladeThermalInfo,'hpoa:bladeInfo');
}
return bladeThermalInfoDOM;
}
this.getBladeInfoDOM=function(fresh){
if(assertFalse(fresh)||bladeInfoDOM==null){
bladeInfoDOM=getCompiledDocument(bladeInfo,'hpoa:bladeInfo',3);
}
return bladeInfoDOM;
}
this.getBladePortMap=function(bayNumber,callback,fresh){
return me.getManagedData("getBladePortMap",[bayNumber],'bladePortMap['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getBladePortMapAll=function(callback,fresh){
var numBlades=me.getNumBlades();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((bladePortMap.length-1)!=numBlades):fresh;
var loaderObject=startLoadAll(numBlades,callback);
if(fresh){
for(var i=1;i<=numBlades;i++){
me.getBladePortMap(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getBladePortMapDOM(true));
}else{
return bladePortMap;
}
}
}
this.getBladePortMapArray=function(bayArray,callback,fresh){
if(assertFalse(fresh)||bladePortMapDOM==null){
me.callMethod("getBladePortMapArray",[bayArray],function(result,callname){
bladePortMap=deCompileXmlArray(result,'//hpoa:bladePortMapArray','hpoa:bladePortMap','bladeBayNumber');
me.getBladePortMapDOM(true);
callback(result,callname);
});
}else{
if(isFunction(callback)){
callback(me.getBladePortMapDOM());
}else{
return me.getBladePortMapDOM();
}
}
}
this.getBladePortMapDOM=function(fresh){
if(assertFalse(fresh)||bladePortMapDOM==null){
bladePortMapDOM=getCompiledDocument(bladePortMap,'hpoa:bladePortMap');
}
return bladePortMapDOM;
}
this.getBladeMezzInfoEx=function(bayNumber,callback,fresh){
return me.getManagedData("getBladeMezzInfoEx",[bayNumber],'bladeMezzInfoEx['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getBladeMezzInfoExArray=function(bayArray,callback,fresh){
return me.getManagedData("getBladeMezzInfoExArray",[bayArray],'bladeMezzInfoExDOM',assertNull(callback),assertFalse(fresh));
}
this.getBladeMezzDevInfoEx=function(bayNumber,callback,fresh){
return me.getManagedData("getBladeMezzDevInfoEx",[bayNumber],'bladeMezzDevInfoEx['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getBladeMezzDevInfoExArray=function(bayArray,callback,fresh){
if(assertFalse(fresh)||bladeMezzDevInfoExDOM==null){
me.callMethod("getBladeMezzDevInfoExArray",[bayArray],function(result,callname){
bladeMezzDevInfoEx=deCompileXmlArray(result,'//hpoa:bladeMezzDevInfoExArray','hpoa:bladeMezzDevInfoEx','bayNumber');
me.getBladeMezzDevInfoExArrayDOM(true);
callback(result,callname);
});
}else{
if(isFunction(callback)){
callback(me.getBladeMezzDevInfoExArrayDOM());
}else{
return me.getBladeMezzDevInfoExArrayDOM();
}
}
}
this.getBladeMezzDevInfoExArrayDOM=function(fresh){
if(assertFalse(fresh)||bladeMezzDevInfoExDOM==null){
bladeMezzDevInfoExDOM=getCompiledDocument(bladeMezzDevInfoEx,'hpoa:bladeMezzDevInfoEx');
}
return bladeMezzDevInfoExDOM;
}
this.getBladeMpInfo=function(bayNumber,callback,fresh){
var presence=getElementValueXpath(bladeInfo[bayNumber],'//hpoa:bladeInfo/hpoa:presence');
var bladeType=getElementValueXpath(bladeInfo[bayNumber],'//hpoa:bladeInfo/hpoa:bladeType');
var productId=getElementValueXpath(bladeInfo[bayNumber],'//hpoa:bladeInfo/hpoa:productId');
if(presence=='PRESENT'&&(bladeType=='BLADE_TYPE_SERVER'||parseInt(productId,10)==8213)){
return me.getManagedData("getBladeMpInfo",[bayNumber],'bladeMpInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
else{
var blankDoc=top.getSoapModule().createSoapResponse(ResponseClones.SoapError,[ErrorType.UserRequest,"401"]);
if(isFunction(callback)){
callback(blankDoc);
}else{
return blankDoc;
}
}
}
this.getBladeMpInfoAll=function(callback,fresh){
if(!exists(fresh)){var fresh=false;}
var numBlades=EM_MAX_BLADE_ARRAY();
var mpBays=[];
var numMpStructs=0;
var presence=null;
var bladeType=null;
var productId=null;
var loadNeeded=false;
for(var i=1;i<=numBlades;i++){
presence=getElementValueXpath(bladeInfo[i],'//hpoa:bladeInfo/hpoa:presence');
bladeType=getElementValueXpath(bladeInfo[i],'//hpoa:bladeInfo/hpoa:bladeType');
productId=getElementValueXpath(bladeInfo[i],'//hpoa:bladeInfo/hpoa:productId');
if(presence=='PRESENT'&&(bladeType=='BLADE_TYPE_SERVER'||parseInt(productId,10)==8213)){
mpBays.push(getElementValueXpath(bladeInfo[i],'//hpoa:bladeInfo/hpoa:bayNumber'));
}
if(bladeMpInfo[i]){
if(typeof(bladeMpInfo[i].xml)!='undefined'&&bladeMpInfo[i].xml.indexOf(SOAP_FAULT_TEST())==-1){
numMpStructs++;
}
}
}
loadNeeded=(numMpStructs!=mpBays.length);
if(mpBays.length==0){
var blankDoc=top.getXml().parseXML('<SOAP-ENV:Fault xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope" />');
if(isFunction(callback)){
callback(blankDoc);
}else{
return blankDoc;
}
}else{
if(fresh||loadNeeded){
loaderObject=startLoadAll(mpBays.length,function(result){
me.getBladeMpInfoDOM(true);
callback(result);
});
for(var s=0;s<mpBays.length;s++){
me.getBladeMpInfo(mpBays[s],loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getBladeMpInfoDOM(true));
}else{
me.getBladeMpInfoDOM(true);
return bladeMpInfo;
}
}
}
}
this.getBladeMpInfoDOM=function(fresh){
if(assertFalse(fresh)||bladeMpInfoDOM==null){
bladeMpInfoDOM=getCompiledDocument(bladeMpInfo,EM_DATA_BLADE_MP_INFO());
}
return bladeMpInfoDOM;
}
this.getBladeMpIml=function(bayNumber,callback){
return me.callMethod("getBladeMpIml",[bayNumber,0],callback,true,CallTypes.API,120000);
}
this.getBladeMpEventLog=function(bayNumber,callback){
return me.callMethod("getBladeMpEventLog",[bayNumber,0],callback);
}
this.getBladeMpCredentials=function(bayNumber,callback,fresh){
return me.callMethod("getBladeMpCredentials",[bayNumber],callback);
}
this.getPowerdelaySettings=function(callback,fresh){
return me.getManagedData("getPowerdelaySettings",[],'powerDelaySettings',assertNull(callback),assertFalse(fresh));
}
this.getPsInfo=function(bayNumber,callback,fresh){
return me.getManagedData("getPowerSupplyInfo",[bayNumber],'powerSupplyInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getPsInfoAll=function(callback,fresh){
var numSupplies=me.getNumPowerSupplies();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((powerSupplyInfo.length-1)!=numSupplies):fresh;
var loaderObject=startLoadAll(numSupplies,callback);
if(fresh){
for(var i=1;i<=numSupplies;i++){
me.getPsInfo(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getPsInfoDOM(true));
}else{
return powerSupplyInfo;
}
}
}
this.getPowerSupplyInfoArray=function(bayArray,callback){
me.callMethod("getPowerSupplyInfoArray",[bayArray],function(result){
powerSupplyInfo=deCompileXmlArray(result,'//hpoa:powerSupplyInfoArray','hpoa:powerSupplyInfo');
me.getPsInfoDOM(true);
callback(result);
});
}
this.getPowerSupplyInfoArrayAndEvents=function(callback){
me.getPowerSupplyInfoArray(getXmlBayArray(getAllArray(1,me.getNumPowerSupplies())),function(psInfoArrayResult){
if(psInfoArrayResult.xml.indexOf(SOAP_FAULT_TEST())<0){
var psInfo=me.getPsInfoAll(null,false);
for(var j=1;j<psInfo.length;j++){
var presence=getElementValueXpath(psInfo[j],'//hpoa:powerSupplyInfo/hpoa:presence');
if(presence=='PRESENT'){
try{
eventsObj.generateEvent('EVENT_PS_INFO',psInfo[j],'hpoa:powerSupplyInfo');
}catch(e){
echo("Exception while generating event: "+e.message);
}
}
}
}
if(isFunction(callback)){
callback(psInfoArrayResult);
}
},true);
}
this.getPsInfoDOM=function(fresh){
if(assertFalse(fresh)||powerSupplyInfoDOM==null){
powerSupplyInfoDOM=getCompiledDocument(powerSupplyInfo,EM_DATA_PS_INFO());
}
return powerSupplyInfoDOM;
}
this.getPsStatus=function(bayNumber,callback,fresh){
return me.getManagedData("getPowerSupplyStatus",[bayNumber],'powerSupplyStatus['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getPsStatusAll=function(callback,fresh){
var numSupplies=me.getNumPowerSupplies();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((powerSupplyStatus.length-1)!=numSupplies):fresh;
var loaderObject=startLoadAll(numSupplies,callback);
if(fresh){
for(var i=1;i<=numSupplies;i++){
me.getPsStatus(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getPsStatusDOM(true));
}else{
return powerSupplyStatus;
}
}
}
this.getPowerSupplyStatusArray=function(bayArray,callback){
me.callMethod("getPowerSupplyStatusArray",[bayArray],function(result){
powerSupplyStatus=deCompileXmlArray(result,'//hpoa:powerSupplyStatusArray','hpoa:powerSupplyStatus');
me.getPsStatusDOM(true);
callback(result);
});
}
this.getPsStatusDOM=function(fresh){
if(assertFalse(fresh)||powerSupplyStatusDOM==null){
powerSupplyStatusDOM=getCompiledDocument(powerSupplyStatus,EM_DATA_PS_STATUS());
}
return powerSupplyStatusDOM;
}
this.getPowerSubsystemInfo=function(callback,fresh){
return me.getManagedData("getPowerSubsystemInfo",[],'powerSubsystemInfo',assertNull(callback),assertFalse(fresh));
}
this.getThermalSubsystemInfo=function(callback,fresh){
return me.getManagedData("getThermalSubsystemInfo",[],'thermalSubsystemInfo',assertNull(callback),assertFalse(fresh));
}
this.getInterconnectTrayInfo=function(bayNumber,callback,fresh){
return me.getManagedData("getInterconnectTrayInfo",[bayNumber],'interconnectTrayInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getInterconnectTrayInfoAll=function(callback,fresh){
var numTrays=me.getNumTrays();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((interconnectTrayInfo.length-1)!=numTrays):fresh;
var loaderObject=startLoadAll(numTrays,callback);
if(fresh){
for(var i=1;i<=numTrays;i++){
me.getInterconnectTrayInfo(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getInterconnectTrayInfoDOM(true));
}else{
return interconnectTrayInfo;
}
}
}
this.getInterconnectTrayInfoArray=function(bayArray,callback){
me.callMethod("getInterconnectTrayInfoArray",[bayArray],function(result){
interconnectTrayInfo=deCompileXmlArray(result,'//hpoa:interconnectTrayInfoArray','hpoa:interconnectTrayInfo');
me.getInterconnectTrayInfoDOM(true);
callback(result);
},true,CallTypes.API,120000);
}
this.getInterconnectTrayInfoDOM=function(fresh){
if(assertFalse(fresh)||interconnectTrayInfoDOM==null){
interconnectTrayInfoDOM=getCompiledDocument(interconnectTrayInfo,EM_DATA_NETTRAY_INFO());
}
return interconnectTrayInfoDOM;
}
this.getInterconnectTrayStatus=function(bayNumber,callback,fresh){
return me.getManagedData("getInterconnectTrayStatus",[bayNumber],'interconnectTrayStatus['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getInterconnectTrayStatusAll=function(callback,fresh){
var numTrays=me.getNumTrays();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((interconnectTrayStatus.length-1)!=numTrays):fresh;
var loaderObject=startLoadAll(numTrays,callback);
if(fresh){
for(var i=1;i<=numTrays;i++){
me.getInterconnectTrayStatus(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getInterconnectTrayStatusDOM(true));
}else{
return interconnectTrayStatus;
}
}
}
this.getInterconnectTrayStatusArray=function(bayArray,callback){
me.callMethod("getInterconnectTrayStatusArray",[bayArray],function(result){
interconnectTrayStatus=deCompileXmlArray(result,'//hpoa:interconnectTrayStatusArray','hpoa:interconnectTrayStatus');
me.getInterconnectTrayStatusDOM(true);
callback(result);
},true,CallTypes.API,120000);
}
this.getInterconnectTrayStatusDOM=function(fresh){
if(assertFalse(fresh)||interconnectTrayStatusDOM==null){
interconnectTrayStatusDOM=getCompiledDocument(interconnectTrayStatus,EM_DATA_NETTRAY_STATUS());
}
return interconnectTrayStatusDOM;
}
this.getInterconnectTrayThermals=function(bayNumber,callback,fresh){
return me.getThermalInfo('SENSOR_TYPE_INTERCONNECT',bayNumber,'interconnectThermals['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getInterconnectTrayThermalsAll=function(callback,fresh){
var numTrays=me.getNumTrays();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((interconnectThermals.length-1)!=numTrays):fresh;
var loaderObject=startLoadAll(numTrays,callback);
if(fresh){
for(var i=1;i<=numTrays;i++){
me.getInterconnectTrayThermals(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getInterconnectTrayThermalsDOM(true));
}else{
return interconnectThermals;
}
}
}
this.getInterconnectTrayThermalsDOM=function(fresh){
if(assertFalse(fresh)||interconnectTrayThermalDOM==null){
interconnectTrayThermalDOM=getCompiledDocument(interconnectThermals,'hpoa:thermalInfo');
}
return interconnectTrayThermalDOM;
}
function cleanInterconnectTrayPortMap(removedBladeBayNumber){
var numTrays=me.getNumTrays();
var total=0;
if(removedBladeBayNumber>0&&removedBladeBayNumber<=me.getNumBlades()){
for(var i=1;i<=numTrays;i++){
if(interconnectTrayPortMap[i]!=null){
if(getTotalXpath(interconnectTrayPortMap[i],"//hpoa:port[hpoa:bladeBayNumber = "+removedBladeBayNumber+"]")>0){
total++;
interconnectTrayPortMap[i]=null;
echo("Removing interconnectTrayPortMap "+i+" due to reference to blade "+removedBladeBayNumber,1,6);
}
}
}
}
if(total>0){
interconnectTrayPortMapDOM=null;
}
}
this.getInterconnectTrayPortMap=function(bayNumber,callback,fresh){
return me.getManagedData("getInterconnectTrayPortMap",[bayNumber],'interconnectTrayPortMap['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getInterconnectTrayPortMapAll=function(callback,fresh){
var numTrays=me.getNumTrays();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((interconnectTrayPortMap.length-1)!=numTrays):fresh;
var loaderObject=startLoadAll(numTrays,callback);
if(fresh){
for(var i=1;i<=numTrays;i++){
me.getInterconnectTrayPortMap(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getInterconnectTrayPortMapDOM(true));
}else{
return interconnectTrayPortMap;
}
}
}
this.getInterconnectTrayPortMapArray=function(bayArray,callback,fresh){
if(assertFalse(fresh)||interconnectTrayPortMapDOM==null){
me.callMethod("getInterconnectTrayPortMapArray",[bayArray],function(result){
interconnectTrayPortMap=deCompileXmlArray(result,'//hpoa:interconnectTrayPortMapArray','hpoa:interconnectTrayPortMap','interconnectTrayBayNumber');
me.getInterconnectTrayPortMapDOM(true);
callback(result);
});
}else{
if(isFunction(callback)){
callback(me.getInterconnectTrayPortMapDOM());
}else{
return me.getInterconnectTrayPortMapDOM();
}
}
}
this.getInterconnectTrayPortMapDOM=function(fresh){
if(assertFalse(fresh)||interconnectTrayPortMapDOM==null){
interconnectTrayPortMapDOM=getCompiledDocument(interconnectTrayPortMap,'hpoa:interconnectTrayPortMap');
}
return interconnectTrayPortMapDOM;
}
this.resetInterconnectTray=function(bayNumber,callback){
return me.callMethod("resetInterconnectTray",[bayNumber],callback);
}
this.setInterconnectTrayPower=function(bayNumber,state,callback){
return me.callMethod("setInterconnectTrayPower",[bayNumber,state],callback);
}
this.setInterconnectTrayUid=function(bayNumber,uidState,callback){
return me.callMethod("setInterconnectTrayUid",[bayNumber,uidState],callback);
}
this.getFanInfo=function(bayNumber,callback,fresh){
return me.getManagedData("getFanInfo",[bayNumber],'fanInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getFanInfoAll=function(callback,fresh){
var numFans=me.getNumFans();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((fanInfo.length-1)!=numFans):fresh;
var loaderObject=startLoadAll(numFans,callback);
if(fresh){
for(var i=1;i<=numFans;i++){
me.getFanInfo(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getFanInfoDOM(true));
}else{
return fanInfo;
}
}
}
this.getFanInfoArray=function(bayArray,callback){
me.callMethod("getFanInfoArray",[bayArray],function(result){
fanInfo=deCompileXmlArray(result,'//hpoa:fanInfoArray','hpoa:fanInfo');
me.getFanInfoDOM(true);
callback(result);
});
}
this.getFanInfoDOM=function(fresh){
if(assertFalse(fresh)||fanInfoDOM==null){
fanInfoDOM=getCompiledDocument(fanInfo,EM_DATA_FAN_INFO());
}
return fanInfoDOM;
}
this.getFanZoneArray=function(bayArray,callback){
return me.callMethod("getFanZoneArray",[bayArray],assertNull(callback));
}
this.getEnclosureComponentFirmware=function(callback,fresh){
return me.getManagedData("hpqUpdateDevice",['SHOW'],'enclosureComponentFirmware',assertNull(callback),assertFalse(fresh));
}
this.getEnclosureInfo=function(callback,fresh){
if(enclosureInfo==null||fresh){
me.callMethod("getEnclosureInfo",[],function(result){
if(getCallSuccess(result)){
enclosureInfo=result;
assertUuid();
var encType=getElementValueXpath(enclosureInfo,'//hpoa:enclosureInfo/hpoa:name');
me.setObjEnclosureName(getElementValueXpath(enclosureInfo,'//hpoa:enclosureInfo/hpoa:enclosureName'));
me.setEnclosureType(encType);
me.setIsTower(getElementValueXpath(enclosureInfo,"//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='isTower']"));
}else{
if(enclosureInfo==null){
enclosureInfo=result;
}
}
if(isFunction(callback)){
callback(enclosureInfo,"getEnclosureInfo");
}
});
}else{
return me.getManagedData("getEnclosureInfo",[],'enclosureInfo',assertNull(callback),assertFalse(fresh),true,true);
}
}
this.getDomainInfo=function(callback,fresh){
return me.getManagedData("getDomainInfo",[],'domainInfo',assertNull(callback),assertFalse(fresh));
}
this.setEnclosureType=function(productName){
var encType=""+productName;
if(encType==''||encType=='[Not Available]'){
echo("Attempting to set enclosure type using OA name.",1,4,["Product Name: "+encType]);
if(oaInfoDOM!=null){
encType=getElementValueXpath(oaInfoDOM,'//hpoa:oaInfo[hpoa:name != ""]/hpoa:name');
}
}
if(encType.indexOf('c7000')>-1||encType.indexOf('o-Class')>-1){
enclosureType=EnclosureTypes.c7000;
}else if(encType.indexOf('c3000')>-1){
enclosureType=EnclosureTypes.c3000;
}else{
if(enclosureType!=EnclosureTypes.Unknown){
echo("Cannot revert enclosure type to unknown.",1,6,["Existing: "+enclosureType,"Param [productName]: "+productName]);
}
}
}
this.getEnclosureType=function(){
return enclosureType;
}
this.getEnclosureStatus=function(callback,fresh){
return me.getManagedData("getEnclosureStatus",[],'enclosureStatus',assertNull(callback),assertFalse(fresh));
}
this.getEnclosureNetworkInfo=function(callback,fresh){
var async=(enclosureNetworkInfo==null||fresh);
var stateCheckCallback=function(result){
if(result.xml!=''&&result.xml.indexOf(SOAP_FAULT_TEST())==-1){
var fipsStatusVar;
fipsStatusVar=getElementValueXpath(result,'//hpoa:enclosureNetworkInfo/hpoa:extraData[@hpoa:name="FipsMode"]');
var fipsStatusVariable;
fipsStatusVariable=getElementValueXpath(result,'//hpoa:enclosureNetworkInfo/hpoa:extraData[@hpoa:name="FipsSecurityStatus"]');
var fipsStatusVariable1;
fipsStatusVariable1=getElementValueXpath(result,'//hpoa:enclosureNetworkInfo/hpoa:extraData[@hpoa:name="FipsSecurityStatus1"]');
if(fipsStatusVariable!=""){
if((fipsStatusVariable=="NO_ERROR")&&(fipsStatusVar=="FIPS-ON"||fipsStatusVar=="FIPS-DEBUG")){
me.setCurrentFipsMode(getElementValueXpath(result,'//hpoa:enclosureNetworkInfo/hpoa:extraData[@hpoa:name="FipsMode"]'));
}
}
if(fipsStatusVariable1!=""){
if(fipsStatusVariable1=="FIPS_ERROR_LDAP_CERT_SIZE"&&fipsStatusVar=="FIPS-ON"){
fipsStatus="SECURE-DEGRADED";
me.setCurrentFipsState(fipsStatus);
}
if(fipsStatusVariable1=="FIPS_ERROR_LDAP_CERT_SIZE"&&fipsStatusVar=="FIPS-DEBUG"){
fipsStatus="DEBUG-DEGRADED";
me.setCurrentFipsState(fipsStatus);
}
}
}
if(isFunction(callback)){
callback(result);
}
}
return me.getManagedData("getEnclosureNetworkInfo",[],'enclosureNetworkInfo',(async?stateCheckCallback:assertNull(callback)),assertFalse(fresh));
}
this.getEnclosureTime=function(callback,fresh){
return me.getManagedData("getEnclosureTime",[],'enclosureTime',assertNull(callback),assertFalse(fresh));
}
this.getTimeZones=function(callback,fresh){
return me.getManagedData("getTimeZones",[],'timeZones',assertNull(callback),assertFalse(fresh));
}
this.getOaVcmMode=function(callback,fresh){
return me.getManagedData("getOaVcmMode",[],'oaVcmMode',assertNull(callback),assertFalse(fresh));
}
this.getVcmOaMinFwVersion=function(callback,fresh){
return me.getManagedData("getVcmOaMinFwVersion",[],'vcmOaMinFwVer',assertNull(callback),assertFalse(fresh));
}
this.getVcmIpv6UrlList=function(callback,fresh){
return me.getManagedData("getVcmIpv6UrlList",[],'vcmIpv6UrlList',assertNull(callback),assertFalse(fresh));
}
this.clearOaVcmMode=function(callback){
return me.callMethod("clearOaVcmMode",[],callback);
}
this.getOaVcmInfo=function(){
var vcmMode;
var vcmUrl;
var vcmDomainName;
vcmMode=getElementValueXpath(oaVcmMode,"//hpoa:isVcmMode");
vcmUrl=getElementValueXpath(oaVcmMode,"//hpoa:vcmUrl");
vcmDomainName=getElementValueXpath(oaVcmMode,"//hpoa:vcmDomainName");
return[vcmMode,vcmUrl,vcmDomainName];
}
this.getKvmInfo=function(callback,fresh){
return me.getManagedData("getKvmInfo",[],'kvmInfo',assertNull(callback),assertFalse(fresh));
}
this.oaManualFailover=function(callback){
return me.callMethod("oaManualFailover",[],callback);
}
this.getOaId=function(callback){
return me.callMethod("getOaId",[],callback);
}
this.getOaBayNumber=function(oaMode){
me.getOaStatusDOM(true);
return getElementValueXpath(oaStatusDOM,'//hpoa:oaStatus[hpoa:oaRole="'+oaMode+'"]/hpoa:bayNumber');
}
this.getActiveOaName=function(){
return getElementValueXpath(oaStatusDOM,'//hpoa:oaStatus[hpoa:oaRole="ACTIVE"]/hpoa:oaName');
}
this.getOaInfo=function(bayNumber,callback,fresh){
return me.getManagedData("getOaInfo",[bayNumber],'oaInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh),false,true);
}
this.getOaStatus=function(bayNumber,callback,fresh){
return me.getManagedData("getOaStatus",[bayNumber],'oaStatus['+bayNumber+']',assertNull(callback),assertFalse(fresh),false,true);
}
this.getOaThermals=function(bayNumber,callback,fresh){
return me.getThermalInfo('SENSOR_TYPE_OA',bayNumber,'oaThermals['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getOaThermalsAll=function(callback,fresh){
var numMgrs=me.getNumManagerBays();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((oaThermals.length-1)!=numMgrs):fresh;
var loaderObject=startLoadAll(numMgrs,callback,me.getOaThermalsDOM);
if(fresh){
for(var i=1;i<=numMgrs;i++){
me.getOaThermals(i,loaderObject.loadAllCallback,true);
}
}else{
if(isFunction(callback)){
callback(me.getOaThermalsDOM(true));
}else{
return oaThermals;
}
}
}
this.getOaThermalsDOM=function(fresh){
if(assertFalse(fresh)||oaThermalsDOM==null){
oaThermalsDOM=getCompiledDocument(oaThermals,'hpoa:thermalInfo');
}
return oaThermalsDOM;
}
this.getOaInfoAll=function(callback,fresh){
var numMgrs=me.getNumManagerBays();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((oaInfo.length-1)!=numMgrs):fresh;
var loaderObject=startLoadAll(numMgrs,function(result){
me.getOaInfoDOM(true);
callback(result);
});
if(fresh){
for(var i=1;i<=numMgrs;i++){
me.getOaInfo(i,loaderObject.loadAllCallback,true);
}
}else{
if(isFunction(callback)){
callback(me.getOaInfoDOM(true));
}else{
return oaInfo;
}
}
}
this.getOaInfos=function(callback,raw){
me.getOaInfoArray(getXmlBayArray(getAllArray(1,EM_MAX_MANAGERS())),function(result){
if(top.checkStandby()){
me.setActiveFirmwareVersion(getElementValueXpath(result,"//hpoa:oaInfo[hpoa:youAreHere='false']/hpoa:fwVersion"));
me.setStandbyFirmwareVersion(getElementValueXpath(result,"//hpoa:oaInfo[hpoa:youAreHere='true']/hpoa:fwVersion"));
}else{
me.setActiveFirmwareVersion(getElementValueXpath(result,"//hpoa:oaInfo[hpoa:youAreHere='true']/hpoa:fwVersion"));
me.setStandbyFirmwareVersion(getElementValueXpath(result,"//hpoa:oaInfo[hpoa:youAreHere='false']/hpoa:fwVersion"));
}
if(enclosureType==EnclosureTypes.Unknown){
var oaType=getElementValueXpath(result,"//hpoa:oaInfo[hpoa:youAreHere='true']/hpoa:name");
if(oaType!=""){
me.setEnclosureType(oaType);
}
}
if(isFunction(callback)){
callback(result,"getOaInfos");
}
},raw);
}
this.getOaInfoArray=function(bayArray,callback,raw){
me.callMethod("getOaInfoArray",[bayArray],function(result){
var success=getCallSuccess(result);
if(success==true||oaInfo==null){
oaInfo=deCompileXmlArray(result,'//hpoa:oaInfoArray','hpoa:oaInfo');
me.getOaInfoDOM(true);
}
echo("Success for getOaInfoArray: "+success,8,2);
if(isFunction(callback)){
callback(success?(raw?result:oaInfo):(raw?oaInfoDOM:oaInfo));
}
},false);
}
this.getOaInfoByMode=function(mode,callback,fresh){
var numMgrs=me.getNumManagerBays();
if(!exists(fresh)){var fresh=false;}
if(fresh){
var loaderObject=startLoadAll(numMgrs,function(result){
for(var i=0;i<oaStatus.length;i++){
var oaRole=getElementValueXpath(oaStatus[i],'//hpoa:oaRole');
if(oaRole==mode){
callback(oaInfo[i]);
}
}
});
for(var i=1;i<=numMgrs;i++){
me.getOaInfo(i,loaderObject.loadAllCallback,fresh);
}
}else{
for(var j=0;j<oaStatus.length;j++){
var oaRole=getElementValueXpath(oaStatus[j],'//hpoa:oaRole');
if(oaRole==mode){
if(isFunction(callback)){
callback(oaInfo[j]);
}else{
return oaInfo[j];
}
break;
}
}
}
}
this.getOaStatusByMode=function(mode,callback,fresh){
var numMgrs=me.getNumManagerBays();
if(!exists(fresh)){var fresh=false;}
fresh=(((oaStatus.length-1)!=numMgrs)&&isFunction(callback));
if(fresh){
var loaderObject=startLoadAll(numMgrs,function(result){
for(var i=0;i<oaStatus.length;i++){
var oaRole=getElementValueXpath(oaStatus[i],'//hpoa:oaRole');
if(oaRole==mode){
if(isFunction(callback)){
callback(oaStatus[i]);
}else{
return oaStatus[i];
}
}
}
});
for(var i=1;i<=numMgrs;i++){
me.getOaStatus(i,loaderObject.loadAllCallback,fresh);
}
}else{
for(var j=0;j<oaStatus.length;j++){
var oaRole=getElementValueXpath(oaStatus[j],'//hpoa:oaRole');
if(oaRole==mode){
if(isFunction(callback)){
callback(oaStatus[j]);
}else{
return oaStatus[j];
}
break;
}
}
}
}
this.getOaInfoDOM=function(fresh){
if(assertFalse(fresh)||oaInfoDOM==null){
oaInfoDOM=getCompiledDocument(oaInfo,'hpoa:oaInfo');
}
return oaInfoDOM;
}
this.getOaStatusAll=function(callback,fresh){
var numMgrs=me.getNumManagerBays();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((oaStatus.length-1)!=numMgrs):fresh;
var loaderObject=startLoadAll(numMgrs,function(result){
me.getOaStatusDOM(true);
callback(result);
});
if(fresh){
for(var i=1;i<=numMgrs;i++){
me.getOaStatus(i,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getOaStatusDOM(true));
}else{
return oaStatus;
}
}
}
this.getOaStatuss=function(callback,raw){
me.getOaStatusArray(getXmlBayArray(getAllArray(1,EM_MAX_MANAGERS())),function(result){
if(isFunction(callback)){
callback(result,"getOaStatuss");
}
},raw);
}
this.getOaStatusArray=function(bayArray,callback,raw){
me.callMethod("getOaStatusArray",[bayArray],function(result){
var success=getCallSuccess(result);
if(success==true||oaStatus==null){
oaStatus=deCompileXmlArray(result,'//hpoa:oaStatusArray','hpoa:oaStatus');
me.getOaStatusDOM(true);
}
if(isFunction(callback)){
callback(success?(raw?result:oaStatus):(raw?oaStatusDOM:oaStatus));
}
},false);
}
this.getOaStatusDOM=function(fresh){
if(assertFalse(fresh)||oaStatusDOM==null){
oaStatusDOM=getCompiledDocument(oaStatus,'hpoa:oaStatus');
}
return oaStatusDOM;
}
this.getOaNetworkInfo=function(bayNumber,callback,fresh){
return me.getManagedData("getOaNetworkInfo",[bayNumber],'oaNetworkInfo['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getOaNetworkInfoAll=function(callback,fresh){
var numMgrs=me.getNumManagerBays();
var loaderObject=startLoadAll(numMgrs,callback);
for(var i=1;i<=numMgrs;i++){
me.getOaNetworkInfo(i,loaderObject.loadAllCallback,assertFalse(fresh));
}
}
this.getOaNetworkInfoDOM=function(fresh){
if(assertFalse(fresh)||oaNetworkDOM==null){
oaNetworkDOM=getCompiledDocument(oaNetworkInfo,'hpoa:oaNetworkInfo');
}
return oaNetworkDOM;
}
this.getOaNetworkInfoByMode=function(mode,callback,fresh){
var numMgrs=me.getNumManagerBays();
var bayNum=0;
if(!exists(fresh)){var fresh=false;}
fresh=((oaNetworkInfo.length-1)!=numMgrs);
if(fresh){
var loaderObject=startLoadAll(numMgrs,function(result){
bayNum=getElementValueXpath(me.getOaStatusDOM(),'//hpoa:oaStatus[hpoa:oaRole="'+mode+'"]/hpoa:bayNumber');
callback(oaNetworkInfo[bayNum]);
});
for(var i=1;i<=numMgrs;i++){
me.getOaNetworkInfo(i,loaderObject.loadAllCallback,fresh);
}
}else{
bayNum=getElementValueXpath(me.getOaStatusDOM(),'//hpoa:oaStatus[hpoa:oaRole="'+mode+'"]/hpoa:bayNumber');
if(isFunction(callback)){
callback(oaNetworkInfo[bayNum]);
}else{
return oaNetworkInfo[bayNum];
}
}
}
this.isOaAccess=function(callback,fresh){
return me.getManagedData("isOaAccess",[],'oaPermission',assertNull(callback),assertFalse(fresh));
}
this.getCurrentAccessLevel=function(callback,fresh){
return me.getManagedData("getCurrentAccessLevel",[],'accessLevel',assertNull(callback),assertFalse(fresh));
}
this.getTwoFactorAuthenticationConf=function(callback,fresh){
twoFactorInfo=null;
return me.getManagedData("getTwoFactorAuthenticationConf",[],'twoFactorInfo',assertNull(callback),assertFalse(fresh));
}
this.gettwofactorflag=function(){
return getElementValueXpath(twoFactorInfo,"//hpoa:tfa-conf/hpoa:enableTwoFactor");
}
this.getcertificaterevocationflag=function(){
return getElementValueXpath(twoFactorInfo,"//hpoa:tfa-conf/hpoa:enableCrl");
}
this.getsubjectaltnameflag=function(){
return getElementValueXpath(twoFactorInfo,"//hpoa:tfa-conf/hpoa:subjectAltName");
}
this.isValidSession=function(callback){
me.callMethod("isValidSession",[],assertFunction(callback),true,CallTypes.API,30000);
}
this.checkIsValid=function(callback){
me.isValidSession(function(result){
var isValid=(getElementValueXpath(result,'//hpoa:isValidSessionResponse/hpoa:returnCodeOk',true)!=null);
if(isFunction(callback)){
callback(isValid);
}
});
}
this.getPasswordSettings=function(callback,fresh){
return me.getManagedData("getPasswordSettings",[],'passwordSettings',assertNull(callback),assertFalse(fresh));
}
this.setStrictPasswordsEnabled=function(enabled,callback){
me.callMethod("setStrictPasswordsEnabled",[enabled],callback);
}
this.setMinimumPasswordLength=function(length,callback){
me.callMethod("setMinimumPasswordLength",[length],callback);
}
this.getUsers=function(callback){
if(isFunction(callback)){
me.callMethod("getUsers",[],function(result){usersLoaded(result,callback);});
}else{
return users;
}
}
this.isMaxUsersReached=function(callback){
var maxReached=false;
return me.callMethod("isMaxUsersReached",[],function(result){
var maxReachedValue=getElementValueXpath(result,'//hpoa:isMaxUsersReachedResponse/hpoa:isMaxUsersReached');
maxReached=(maxReachedValue=='true')?true:false;
});
callback(maxReached);
}
function usersLoaded(result,callback){
users=result;
compileUserList();
callback(result);
}
function compileUserList(){
if(users!=null){
var userElements=null;
userList=new Array();
try{
if(exists(users.getElementsByTagNameNS)){
userElements=users.getElementsByTagNameNS("*",'userInfo');
}else{
userElements=users.getElementsByTagName('hpoa:userInfo');
}
for(var i=0;i<userElements.length;i++){
var userDoc=top.getXml().parseXML('<user />');
userDoc.documentElement.appendChild(userElements[i].cloneNode(true));
userList.push(userDoc);
if(typeof(XMLSerializer)!="undefined"){
userList[userList.length-1].xml=(new XMLSerializer().serializeToString(userDoc));
}
echo("Adding user in compileUserList.",8,1,[userList[userList.length-1].xml]);
}
}catch(e){
echo("Error compiling user list.",1,6,[e.message]);
}
}
}
this.getUserList=function(){
return userList;
}
function removeCachedUser(username){
for(var i=0;i<userList.length;i++){
var currentUsername=getElementValueXpath(userList[i],'//hpoa:userInfo/hpoa:username');
if(currentUsername==username){
userList.splice(i,1);
break;
}
}
me.getUsersDOM(true);
}
function updateUser(userInfo){
var username=getElementValueXpath(userInfo,'//hpoa:userInfo/hpoa:username');
for(var i=0;i<userList.length;i++){
var currentUsername=getElementValueXpath(userList[i],'//hpoa:userInfo/hpoa:username');
if(currentUsername==username){
echo("Updating user: "+username,6,1);
userList[i]=userInfo;
break;
}
}
me.getUsersDOM(true);
}
this.getUsersDOM=function(fresh){
if(assertFalse(fresh)||usersDOM==null){
sortXmlArray(userList,'hpoa:username');
usersDOM=getCompiledDocument(userList,'hpoa:userInfo');
}
return usersDOM;
}
this.getUserInfo=function(username,callback,fresh){
if(assertFalse(fresh)){
return me.callMethod("getUserInfo",[username],assertNull(callback));
}else{
var uInfoObject=null;
for(var i=0;i<userList.length;i++){
var currentUsername=getElementValueXpath(userList[i],'//hpoa:userInfo/hpoa:username');
if(currentUsername==username){
uInfoObject=userList[i];
break;
}
}
if(isFunction(callback)){
callback(uInfoObject);
return;
}else{
return uInfoObject;
}
}
}
this.getCurrentUserInfo=function(callback,fresh){
return me.getManagedData("getCurrentUserInfo",[],'currentUserInfo',assertNull(callback),assertFalse(fresh));
}
this.addUser=function(username,password,callback){
return me.callMethod("addUser",[username,password],callback);
}
this.addUserBayAccess=function(username,bayAccess,callback){
return me.callMethod("addUserBayAccess",[username,bayAccess],callback);
}
this.removeUserBayAccess=function(username,bayAccess,callback){
return me.callMethod("removeUserBayAccess",[username,bayAccess],callback);
}
this.removeUser=function(username,callback){
return me.callMethod("removeUser",[username],callback);
}
this.setUserFullname=function(username,fullName,callback){
return me.callMethod("setUserFullname",[username,fullName],callback);
}
this.setUserPassword=function(username,password,callback){
return me.callMethod("setUserPassword",[username,password],callback);
}
this.setUserContact=function(username,contact,callback){
return me.callMethod("setUserContact",[username,contact],callback);
}
this.setUserBayAcl=function(username,userAcl,callback){
return me.callMethod("setUserBayAcl",[username,userAcl],callback);
}
this.enableUser=function(username,callback){
return me.callMethod("enableUser",[username],callback);
}
this.disableUser=function(username,callback){
return me.callMethod("disableUser",[username],callback);
}
this.getUsbMediaFirmwareImages=function(callback,fresh){
return me.getManagedData("getUsbMediaFirmwareImages",[],'usbFirmwareList',assertNull(callback),assertFalse(fresh));
}
this.getUsbMediaConfigScripts=function(callback,fresh){
return me.getManagedData("getUsbMediaConfigScripts",[],'usbConfigScriptList',assertNull(callback),assertFalse(fresh));
}
this.generateOaConfigUsb=function(fileName,callback){
return me.callMethod("generateOaConfigUsb",[fileName],assertNull(callback));
}
this.getOaMediaDeviceArray=function(bayNumber,callback,fresh){
if(fresh){
return me.callMethod("getOaMediaDeviceArray",[bayNumber],function(result){
oaMediaDevices=deCompileXmlArray(result,'//hpoa:oaMediaDeviceArray','hpoa:oaMediaDevice','deviceIndex');
me.getOaMediaDeviceDOM(true);
try{
callback(result);
}catch(e){}
});
}else{
callback(me.getOaMediaDeviceDOM());
}
}
this.getOaMediaDeviceDOM=function(fresh){
if(assertFalse(fresh)||oaMediaDeviceDOM==null){
oaMediaDeviceDOM=getCompiledDocument(oaMediaDevices,'hpoa:oaMediaDevice');
}
return oaMediaDeviceDOM;
}
this.getCaCertificatesInfo=function(callback,fresh){
return me.getManagedData("getCaCertificatesInfo",[],'caCertInfo',assertNull(callback),assertFalse(fresh));
}
this.getLdapInfo=function(callback,fresh){
return me.getManagedData("getLdapInfo",[],'ldapInfo',assertNull(callback),assertFalse(fresh));
}
this.getLdapTestStatus=function(callback,fresh){
return me.getManagedData("getLdapTestStatus",[],'ldapTestStatus',assertNull(callback),assertFalse(fresh));
}
this.testLdap=function(username,password,callback){
me.callMethod("testLdap",[username,password],assertNull(callback),true,CallTypes.API,180000);
}
this.getLdapGroups=function(callback){
if(isFunction(callback)){
me.callMethod("getLdapGroups",[],function(result){groupsLoaded(result,callback);});
}else{
return groups;
}
}
function groupsLoaded(result,callback){
groups=result;
compileGroupList();
callback(result);
}
function compileGroupList(){
if(groups!=null){
var groupElements=null;
groupList=new Array();
try{
if(typeof(groups.getElementsByTagNameNS)!='undefined'){
groupElements=groups.getElementsByTagNameNS("*",'ldapGroupInfo');
}else{
groupElements=groups.getElementsByTagName('hpoa:ldapGroupInfo');
}
for(var i=0;i<groupElements.length;i++){
var groupDoc=top.getXml().parseXML('<group/>');
groupDoc.documentElement.appendChild(groupElements[i].cloneNode(true));
groupList.push(groupDoc);
try{
var xmlContent=new XMLSerializer().serializeToString(groupDoc);
groupList[groupList.length-1].xml=xmlContent;
}catch(e){}
}
}catch(e){}
}
}
this.getGroupsDOM=function(fresh){
if(assertFalse(fresh)||groupsDOM==null){
groupsDOM=getCompiledDocument(groupList,'hpoa:ldapGroupInfo');
}
return groupsDOM;
}
this.getLdapGroupInfo=function(groupName,callback,fresh){
if(assertFalse(fresh)){
return me.callMethod("getLdapGroupInfo",[groupName],assertNull(callback));
}else{
var groupInfoObject=null;
for(var i=0;i<groupList.length;i++){
var currentGroupName=getElementValueXpath(groupList[i],'//hpoa:ldapGroupInfo/hpoa:ldapGroupName');
if(currentGroupName==groupName){
groupInfoObject=groupList[i];
break;
}
}
if(isFunction(callback)){
callback(groupInfoObject);
return;
}else{
return groupInfoObject;
}
}
}
function removeCachedGroup(groupName){
for(var i=0;i<groupList.length;i++){
var currentGroupName=getElementValueXpath(groupList[i],'//hpoa:ldapGroupInfo/hpoa:ldapGroupName');
if(currentGroupName==groupName){
groupList.splice(i,1);
break;
}
}
me.getGroupsDOM(true);
}
function updateGroup(groupInfo){
var groupName=getElementValueXpath(groupInfo,'//hpoa:ldapGroupInfo/hpoa:ldapGroupName');
for(var i=0;i<groupList.length;i++){
var currentGroupName=getElementValueXpath(groupList[i],'//hpoa:ldapGroupInfo/hpoa:ldapGroupName');
if(currentGroupName==groupName){
groupList[i]=groupInfo;
break;
}
}
me.getGroupsDOM(true);
}
this.addLdapGroup=function(groupName,callback){
return me.callMethod("addLdapGroup",[groupName],callback);
}
this.setLdapGroupDescription=function(groupName,description,callback){
return me.callMethod("setLdapGroupDescription",[groupName,description],callback);
}
this.setLdapGroupBayAcl=function(groupName,acl,callback){
return me.callMethod("setLdapGroupBayAcl",[groupName,acl],callback);
}
this.addLdapGroupBayAccess=function(groupName,bayAccessDOM,callback){
return me.callMethod("addLdapGroupBayAccess",[groupName,bayAccessDOM],callback);
}
this.removeLdapGroupBayAccess=function(groupName,bayAccessDOM,callback){
return me.callMethod("removeLdapGroupBayAccess",[groupName,bayAccessDOM],callback);
}
this.removeLdapGroup=function(groupName,callback){
return me.callMethod("removeLdapGroup",[groupName],callback);
}
this.enableTwoFactorAuthentication=function(enableTwoFactor,enableCrl,subjectAltName,callback){
return me.callMethod("enableTwoFactorAuthentication",[enableTwoFactor,enableCrl,subjectAltName],callback);
}
this.enableLdapAuthentication=function(ldapEnabled,localEnabled,callback){
return me.callMethod("enableLdapAuthentication",[ldapEnabled,localEnabled],callback);
}
this.setLdapInfo=function(dsAddress,ldapPort,searchContext1,searchContext2,searchContext3,ntAccountMapping,callback){
return me.callMethod("setLdapInfo",[dsAddress,ldapPort,searchContext1,searchContext2,searchContext3,ntAccountMapping],callback);
}
this.setLdapInfoEx=function(dsAddress,ldapPort,searchContext1,searchContext2,searchContext3,ntAccountMapping,callback){
return me.callMethod("setLdapInfoEx",[dsAddress,ldapPort,searchContext1,searchContext2,searchContext3,ntAccountMapping],callback);
}
this.setLdapInfo2=function(dsAddress,ldapPort,ntAccountMapping,searchContexts,callback){
return me.callMethod("setLdapInfo2",[dsAddress,ldapPort,ntAccountMapping,searchContexts],callback);
}
this.setLdapInfo3=function(dsAddress,ldapPort,gcPort,ntAccountMapping,searchContexts,callback){
return me.callMethod("setLdapInfo3",[dsAddress,ldapPort,gcPort,ntAccountMapping,searchContexts],callback);
}
this.addLdapDirectoryServerCertificate=function(certificate,callback){
return me.callMethod("addLdapDirectoryServerCertificate",[certificate],callback,true,CallTypes.API,300000);
}
this.downloadLdapDirectoryServerCertificate=function(url,callback){
return me.callMethod("downloadLdapDirectoryServerCertificate",[url],callback,true,CallTypes.API,300000);
}
this.removeLdapDirectoryServerCertificate=function(md5Fingerprint,callback){
return me.callMethod("removeLdapDirectoryServerCertificate",[md5Fingerprint],callback);
}
this.getVlanInfo=function(callback,fresh){
return me.getManagedData("getVlanInfo",[],'vlanInfo',assertNull(callback),fresh);
}
this.setVlanInfo=function(vlanInfo,callback){
return me.callMethod("setVlanInfo",[vlanInfo],callback,true,CallTypes.API,180000);
}
this.saveConfig=function(callback){
return me.callMethod("saveConfig",[],callback,true,CallTypes.API,180000);
}
this.addVlan=function(vlanId,vlanName,callback){
return me.callMethod("addVlan",[vlanId,vlanName],callback);
}
this.editVlan=function(vlanId,vlanName,callback){
return me.callMethod("editVlan",[vlanId,vlanName],callback);
}
this.removeVlan=function(vlanId,callback){
return me.callMethod("removeVlan",[vlanId],callback);
}
this.revertVlan=function(delay,callback){
return me.callMethod("revertVlan",[delay],callback);
}
this.getEbipaInfo=function(callback,fresh){
return me.getManagedData("getEbipaInfo",[],'ebipaInfo',assertNull(callback),assertFalse(fresh));
}
this.getEbipaInfoEx=function(callback,fresh){
return me.getManagedData("getEbipaInfoEx",[],'ebipaInfoEx',assertNull(callback),assertFalse(fresh));
}
this.getEbipaDevInfo=function(callback,fresh){
return me.getManagedData("getEbipaDevInfo",[],'ebipaDevInfo',assertNull(callback),assertFalse(fresh));
}
this.configureEbipa=function(bayType,ebipaConfig,callback){
return me.callMethod("configureEbipa",[bayType,ebipaConfig],callback);
}
this.configureEbipaDev=function(ebipaConfig,callback){
return me.callMethod("configureEbipaDev",[ebipaConfig],callback);
}
this.configureEbipaEx=function(bayType,ebipaConfig,callback){
return me.callMethod("configureEbipaEx",[bayType,ebipaConfig],callback);
}
this.setEbipaIpAddress=function(bayType,ipAddress,callback){
return me.callMethod("setEbipaIpAddress",[bayType,ipAddress],callback);
}
this.setEbipaNetmask=function(bayType,netmask,callback){
return me.callMethod("setEbipaNetmask",[bayType,netmask],callback);
}
this.setEbipaGateway=function(bayType,gateway,callback){
return me.callMethod("setEbipaGateway",[bayType,gateway],callback);
}
this.setEbipaDomain=function(bayType,domain,callback){
return me.callMethod("setEbipaDomain",[bayType,domain],callback);
}
this.setEbipaDnsServers=function(bayType,dns1,dns2,dns3,callback){
return me.callMethod("setEbipaDnsServers",[bayType,dns1,dns2,dns3],callback);
}
this.setEbipaNtpServers=function(bayType,ntp1,ntp2,callback){
return me.callMethod("setEbipaNtpServers",[bayType,ntp1,ntp2],callback);
}
this.getEbipaAddressList=function(beginAddress,netmask,bayArray,callback){
return me.callMethod("getEbipaAddressList",[beginAddress,netmask,bayArray],callback);
}
this.getEbipav6Info=function(callback,fresh){
return me.getManagedData("getEbipav6Info",[],'ebipav6Info',assertNull(callback),assertFalse(fresh));
}
this.setEbipav6Info=function(ebipav6Info,callback){
return me.callMethod("setEbipav6Info",[ebipav6Info],callback);
}
this.getEbipav6InfoEx=function(callback,fresh){
return me.getManagedData("getEbipav6InfoEx",[],'ebipav6InfoEx',assertNull(callback),assertFalse(fresh));
}
this.setEbipav6InfoEx=function(ebipav6InfoEx,callback){
return me.callMethod("setEbipav6InfoEx",[ebipav6InfoEx],callback);
}
this.getEbipav6AddressList=function(beginAddress,bayArray,callback){
return me.callMethod("getEbipav6AddressList",[beginAddress,bayArray],callback);
}
this.getSshKeys=function(callback){
return me.callMethod("getSshKeys",[],callback);
}
this.getSshFingerprint=function(callback){
return me.callMethod("getSshFingerprint",[],callback);
}
this.downloadSshKeysFile=function(url,callback){
return me.callMethod("downloadSshKeysFile",[url],callback);
}
this.clearSshKeys=function(callback){
return me.callMethod("clearSshKeys",[],callback);
}
this.setSshKeys=function(keyString,callback){
return me.callMethod("setSshKeys",[keyString],callback);
}
this.setPowerConfig=function(redundancyMode,ceiling,enableActiveEfficiency,callback){
return me.callMethod("setPowerConfigInfo",[redundancyMode,ceiling,enableActiveEfficiency],callback);
}
this.getPowerConfigInfo=function(callback,fresh){
return me.getManagedData("getPowerConfigInfo",[],'powerConfigInfo',assertNull(callback),assertFalse(fresh));
}
this.setPowerCapConfig=function(powerCapConfig,callback){
return me.callMethod("setPowerCapConfig",[powerCapConfig],callback);
}
this.getPowerCapConfig=function(callback,fresh){
return me.getManagedData("getPowerCapConfig",[],'powerCapConfig',assertNull(callback),assertFalse(fresh));
}
this.getPowerCapExtConfig=function(callback,fresh){
return me.getManagedData("getPowerCapExtConfig",[],'powerCapExtConfig',assertNull(callback),assertFalse(fresh));
}
this.getPowerCapBladeStatus=function(callback,fresh){
return me.getManagedData("getPowerCapBladeStatus",[],'powerCapBladeStatus',assertNull(callback),assertFalse(fresh));
}
this.getEnclosurePowerCollectionInfo=function(callback){
return me.callMethod("getEnclosurePowerCollectionInfo",[],callback);
}
this.getEnclosurePowerData=function(callback){
return me.callMethod("getEnclosurePowerData",[],callback);
}
this.getEnclosurePowerSummary=function(callback){
return me.callMethod("getEnclosurePowerSummary",[],callback);
}
this.getEnclosureBladePowerSummary=function(callback){
return me.callMethod("getEnclosureBladePowerSummary",[],callback);
}
this.setWizardComplete=function(complete,callback){
return me.callMethod("setWizardComplete",[complete],assertFunction(callback));
}
this.setHpSimTrustMode=function(trustMode,callback){
return me.callMethod("setHpSimTrustMode",[trustMode],callback);
}
this.getHpSimInfo=function(callback,fresh){
return me.getManagedData("getHpSimInfo",[],'hpSimInfo',assertNull(callback),assertFalse(fresh));
}
this.downloadHpSimCertificate=function(url,callback){
return me.callMethod("downloadHpSimCertificate",[url],callback,true,CallTypes.API,300000);
}
this.addHpSimCertificate=function(x509String,callback){
return me.callMethod("addHpSimCertificate",[x509String],callback,true,CallTypes.API,300000);
}
this.removeHpSimCertificate=function(subjectCommonNameId,callback){
return me.callMethod("removeHpSimCertificate",[subjectCommonNameId],callback,true,CallTypes.API,300000);
}
this.addHpSimXeName=function(xeName,callback){
return me.callMethod("addHpSimXeName",[xeName],callback);
}
this.removeHpSimXeName=function(xeName,callback){
return me.callMethod("removeHpSimXeName",[xeName],callback);
}
this.restoreFactoryDefaults=function(callback){
return me.callMethod("restoreFactoryDefaults",[],callback,true,CallTypes.API,0);
}
this.getLcdInfo=function(callback,fresh){
var callbackFunction=function(result,method){
me.setIsTower(getElementValueXpath(lcdInfo,"//hpoa:partNumber"));
if(isFunction(callback)){
callback(lcdInfo,method);
}
}
return me.getManagedData("getLcdInfo",[],'lcdInfo',(isFunction(callback)||fresh==true?callbackFunction:null),assertFalse(fresh));
}
this.getLcdStatus=function(callback,fresh){
return me.getManagedData("getLcdStatus",[],'lcdStatus',assertNull(callback),assertFalse(fresh));
}
this.resetLcdUserNotesImage=function(callback){
return me.callMethod("resetLcdUserNotesImage",[],callback);
}
this.pressLcdButton=function(lcdButton,buttonState,callback){
return me.callMethod("pressLcdButton",[lcdButton,buttonState],callback);
}
this.setLcdButtonLock=function(buttonLock,callback){
return me.callMethod("setLcdButtonLock",[buttonLock],callback);
}
this.setLcdUserNotes=function(line1,line2,line3,line4,line5,line6,callback){
return me.callMethod("setLcdUserNotes",[line1,line2,line3,line4,line5,line6],callback);
}
this.getLcdUserNotes=function(callback){
return me.callMethod("getLcdUserNotes",[],callback);
}
this.resetLcdUserNotes=function(callback){
return me.callMethod("resetLcdUserNotes",[],callback);
}
this.setLcdProtectionPin=function(pin,callback){
return me.callMethod("setLcdProtectionPin",[pin],callback);
}
this.sendLcdMessage=function(screenName,message,callback){
return me.callMethod("sendLcdMessage",[screenName,message],callback);
}
this.askLcdSimpleQuestion=function(screenName,questionText,questionType,callback){
return me.callMethod("askLcdSimpleQuestion",[screenName,questionText,questionType],callback);
}
this.askLcdCustomQuestion=function(screenName,questionText,questionButtonFormat,answerMaxLen,callback){
return me.callMethod("askLcdCustomQuestion",[screenName,questionText,questionButtonFormat,answerMaxLen],callback);
}
this.withdrawLcdQuestion=function(callback){
return me.callMethod("withdrawLcdQuestion",[],callback);
}
this.insertVirtualMedia=function(bayNumber,virtualMediaDevType,virtualMediaUrl,callback){
return me.callMethod("insertVirtualMedia",[bayNumber,virtualMediaDevType,virtualMediaUrl],callback);
}
this.ejectVirtualMedia=function(bayNumber,virtualMediaDevType,callback){
return me.callMethod("ejectVirtualMedia",[bayNumber,virtualMediaDevType],callback);
}
this.getVirtualMediaStatus=function(bayNumber,virtualMediaDevType,callback,fresh){
return me.getManagedData("getVirtualMediaStatus",[bayNumber,virtualMediaDevType],'virtualMediaStatus['+bayNumber+']',assertNull(callback),assertFalse(fresh));
}
this.getVirtualMediaStatusDOM=function(fresh){
if(assertFalse(fresh)||virtualMediaStatusDOM==null){
virtualMediaStatusDOM=getCompiledDocument(virtualMediaStatus,'hpoa:virtualMediaStatus');
}
return virtualMediaStatusDOM;
}
this.getVirtualMediaUrlList=function(virtualMediaDevType,callback,fresh){
return me.getManagedData("getVirtualMediaUrlList",[virtualMediaDevType],'virtualMediaUrlDoc',assertNull(callback),assertFalse(fresh));
}
this.getVirtualMediaStatusAll=function(virtualMediaDevType,callback,fresh){
var numBlades=EM_MAX_BLADE_ARRAY();
if(!exists(fresh)){var fresh=false;}
fresh=(!fresh)?((virtualMediaStatus.length-1)!=numBlades):fresh;
var loaderObject=startLoadAll(numBlades,callback,me.getVirtualMediaStatusDOM);
if(fresh){
for(var i=1;i<=numBlades;i++){
me.getVirtualMediaStatus(i,virtualMediaDevType,loaderObject.loadAllCallback,fresh);
}
}else{
if(isFunction(callback)){
callback(me.getVirtualMediaStatusDOM(true));
}else{
return virtualMediaStatus;
}
}
}
this.getOaSessionArray=function(bayNumber,callback){
return me.callMethod("getOaSessionArray",[bayNumber],callback);
}
this.removeOaSession=function(bayNumber,id,callback){
return me.callMethod("removeOaSession",[bayNumber,id],callback);
}
this.getOaSessionTimeout=function(callback){
me.callMethod("getOaSessionTimeout",[],function(result){
var timeout=getElementValueXpath(result,"//hpoa:getOaSessionTimeoutResponse/hpoa:timeout");
top.setSessionTimeoutValue(timeout);
if(isFunction(callback)){
callback(result);
}
});
}
this.setOaSessionTimeout=function(timeout,callback){
return me.callMethod("setOaSessionTimeout",[timeout],callback);
}
this.setEnclosureUsbMode=function(mode,callback){
return me.callMethod("setEnclosureUsbMode",[mode],callback);
}
this.getNumBlades=function(){
return getEnclosureBayNumValue('bladeBays2');
}
this.getNumBays=function(){
return getEnclosureBayNumValue('bladeBays');
}
this.getNumManagerBays=function(){
return getEnclosureBayNumValue('oaBays');
}
this.getNumFans=function(){
return getEnclosureBayNumValue('fanBays');
}
this.getNumFanZones=function(){
return 4;
}
this.getNumPowerSupplies=function(){
return getEnclosureBayNumValue('powerSupplyBays');
}
this.getNumTrays=function(){
return getEnclosureBayNumValue('interconnectTrayBays');
}
var getEnclosureBayNumValue=function(element){
var bladeOffset=0;
var numBays=0;
if(element=="bladeBays2"){
numBays=getElementValueXpath(enclosureInfo,'//hpoa:enclosureInfo/hpoa:bladeBays');
bladeOffset=parseInt(getElementValueXpath(enclosureInfo,"//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='sidesPerBay']"));
if(isNaN(bladeOffset)){
bladeOffset=0;
}else{
bladeOffset=bladeOffset*16;
}
}else{
numBays=getElementValueXpath(enclosureInfo,'//hpoa:enclosureInfo/hpoa:'+element);
}
numBays=parseInt(numBays);
if(isNaN(numBays)||numBays==0){
switch(enclosureType){
case EnclosureTypes.c7000:
switch(element){
case 'bladeBays2':
numBays=EM_MAX_BLADES_C7000();
break;
case 'bladeBays':
numBays=EM_MAX_BLADES_C7000();
break;
case 'fanBays':
numBays=EM_MAX_FANS_C7000();
break;
case 'powerSupplyBays':
numBays=EM_MAX_PS();
break;
case 'interconnectTrayBays':
numBays=EM_MAX_SWITCHES_C7000();
break;
case 'oaBays':
numBays=EM_MAX_MANAGERS();
break;
default:
break;
}
break;
case EnclosureTypes.c3000:
switch(element){
case 'bladeBays2':
numBays=EM_MAX_BLADES_C3000();
break;
case 'bladeBays':
numBays=EM_MAX_BLADES_C3000();
break;
case 'fanBays':
numBays=EM_MAX_FANS_C3000();
break;
case 'powerSupplyBays':
numBays=EM_MAX_PS();
break;
case 'interconnectTrayBays':
numBays=EM_MAX_SWITCHES_C3000();
break;
case 'oaBays':
numBays=EM_MAX_MANAGERS();
break;
default:
break;
}
break;
default:
numBays=0;
break;
}
}
if(element=="bladeBays2"){
numBays=numBays+bladeOffset;
}
return numBays;
}
this.hasSNMPv3=function(){
return this.getActiveFirmwareVersion()>=3.80;
}
}
