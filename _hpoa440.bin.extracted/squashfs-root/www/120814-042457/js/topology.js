/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function EnclosureCollection(){
var enclosureMap=new Object();
var debugging=top.debugIsActive();
function enclosureCollectionDebug(debugState){
debugging=debugState;
};
function echo(msg,level,severity,extraData){
if(debugging==true){
var entry="Enclosure Collection: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
}
};
function sortByPosition(a,b){
try{
return a.getEnclosureNumber()-b.getEnclosureNumber();
}catch(e){
echo("Error in enclosure sort by position.",1,5,[e.message]);
return-1;
}
};
function sortEnclosures(collection){
return collection.sort(sortByPosition);
};
function positionExists(position,includeNonActive){
var encCollection=getAllEnclosures(includeNonActive);
for(var index in encCollection){
if(encCollection[index].getEnclosureNumber()==position){
return true;
}
}
return false;
};
function getLinkedEnclosures(includeNonActive){
var linkedCollection=new Array();
for(var uuid in enclosureMap){
if(enclosureMap[uuid].getIsLocal()==false){
if(includeNonActive==true||enclosureMap[uuid].getIsConnected()==true){
linkedCollection.push(enclosureMap[uuid]);
}
}
}
return sortEnclosures(linkedCollection);
};
function getWizardSelectedEnclosures(){
var wizSelectedEnclosures=new Array();
for(var uuid in enclosureMap){
var enclosure=enclosureMap[uuid];
if(enclosure.getIsConnected()==true&&enclosure.getIsWizardSelected()==true){
wizSelectedEnclosures.push(enclosure);
}
}
return sortEnclosures(wizSelectedEnclosures);
};
function getAuthenticatedEnclosures(){
var authenticatedEnclosures=new Array();
for(var uuid in enclosureMap){
if(enclosureMap[uuid].getIsConnected()==true){
if(enclosureMap[uuid].getIsAuthenticated()==true){
authenticatedEnclosures.push(enclosureMap[uuid]);
}
}
}
return sortEnclosures(authenticatedEnclosures);
};
function getAllEnclosures(includeNonActive){
var allEnclosures=new Array();
for(var uuid in enclosureMap){
if(includeNonActive==true||enclosureMap[uuid].getIsConnected()==true){
allEnclosures.push(enclosureMap[uuid]);
}
}
return sortEnclosures(allEnclosures);
};
this.init=function(){
top.registerDebugListener(enclosureCollectionDebug);
};
this.getEnclosureByProxyUrl=function(proxyUrl,includeNonActive){
var allEnclosures=getAllEnclosures(includeNonActive);
for(var index in allEnclosures){
if(allEnclosures[index].getProxyUrl()==proxyUrl){
return allEnclosures[index];
}
}
return null;
};
this.getPrimaryEnclosure=function(){
for(var uuid in enclosureMap){
if(enclosureMap[uuid].getIsLocal()==true){
return enclosureMap[uuid];
}
}
return null;
};
this.addPrimaryEnclosure=function(serviceUrl,position){
if(this.getPrimaryEnclosure()!=null){
echo("Cannot add a primary enclosure - already exists.",1,6);
return this.getPrimaryEnclosure();
}
echo("Adding a primary enclosure.",6,8,[serviceUrl,"Position: "+Nz(position)]);
return(enclosureMap["LOCAL"]=new hpem(serviceUrl,Nz(position),true));
};
this.getUuids=function(){
var encCollection=getAllEnclosures();
var uuids=new Array();
for(var index in encCollection){
uuids.push(encCollection[index].getUuid());
}
return uuids;
};
this.getEnclosureNumbers=function(){
var encCollection=getAllEnclosures();
var encNums=new Array();
for(var index in encCollection){
encNums.push(encCollection[index].getEnclosureNumber());
}
return encNums;
};
this.getLoadedEnclosures=function(){
var loadedCollection=new Array();
for(var uuid in enclosureMap){
if(enclosureMap[uuid].getIsLoaded()==true&&
enclosureMap[uuid].getIsConnected()==true){
loadedCollection.push(enclosureMap[uuid]);
}
}
return sortEnclosures(loadedCollection);
};
this.getRemovedEnclosures=function(){
var removedCollection=new Array();
for(var uuid in enclosureMap){
if(enclosureMap[uuid].getIsConnected()==false){
removedCollection.push(enclosureMap[uuid]);
}
}
return removedCollection;
};
this.getProxies=function(includeNonActive){
return getAllEnclosures(includeNonActive);
};
this.getSelectedProxies=function(){
return getWizardSelectedEnclosures();
};
this.getAuthenticatedProxies=function(){
return getAuthenticatedEnclosures();
};
this.getLinkedProxies=function(includeNonActive){
return getLinkedEnclosures(includeNonActive);
};
this.getEnclosure=function(uuid,includeNonActive){
var allEnclosures=getAllEnclosures(includeNonActive);
for(var index in allEnclosures){
if(allEnclosures[index].getUuid()==uuid){
return allEnclosures[index];
}
}
return null;
};
this.containsEnclosure=function(uuid,includeNonActive){
return(this.getEnclosure(uuid,includeNonActive)!=null);
};
this.addEnclosure=function(hpemInstance){
var position=hpemInstance.getEnclosureNumber();
var isLocal=hpemInstance.getIsLocal();
var uuid=hpemInstance.getUuid();
if(uuid==null){
uuid=(isLocal==true?"LOCAL":position);
}
if(isLocal==true&&this.getPrimaryEnclosure()!=null){
echo("Primary enclosure already exists.",1,5,this.getEncInfo());
return false;
}
if(this.containsEnclosure(uuid,true)){
echo("Enclosure is already in the collection.",1,5);
return true;
}
if(positionExists(position,false)){
echo("Position "+position+" is already occupied.",1,5);
}
enclosureMap[uuid]=hpemInstance;
return true;
};
this.removeEnclosure=function(uuid,includeNonActive,destroy){
if(this.containsEnclosure(uuid,includeNonActive)){
var encObj=this.getEnclosure(uuid,includeNonActive);
if(encObj.getIsLocal()==true){
echo("Unable to remove the primary enclosure!",1,5);
return false;
}else{
echo("Disconnecting enclosure with UUID: "+uuid+".",2,4);
top.getTransport().cancelCalls(uuid);
encObj.stopEvents();
encObj.setIsLoaded(false);
encObj.setIsConnected(false);
encObj.setIsWizardSelected(false);
encObj.setHasFocus(false);
if(destroy==true){
delete enclosureMap[uuid];
}
return true;
}
}else{
echo("Cannot remove the enclosure - not found.",1,5,["UUID: "+uuid]);
}
};
this.getPosition=function(uuid,includeNonActive){
if(this.containsEnclosure(uuid,includeNonActive)){
return this.getEnclosure(uuid,includeNonActive).getEnclosureNumber();
}else{
echo("OA "+uuid+" does not exist in the collection.",1,5);
}
};
this.reset=function(){
echo("Before reset.",1,1,this.getEncInfo());
for(var uuid in enclosureMap){
delete enclosureMap[uuid];
}
enclosureMap=new Object();
echo("After reset.",1,1,this.getEncInfo());
};
this.getEncInfo=function(includeNonActive,useHtml){
var tab=(useHtml==true?"&nbsp;&nbsp;":"___");
var list=new Array("Enclosures:","-----------------");
var encs=getAllEnclosures(includeNonActive);
for(var index in encs){
var enc=encs[index];
list.push("UUID="+enc.getUuid()+
tab+"Pos="+enc.getEnclosureNumber()+
tab+"Local="+enc.getIsLocal()+
tab+"Connected="+enc.getIsConnected()+
tab+"Loaded="+enc.getIsLoaded()+
tab+"Authenticated="+enc.getIsAuthenticated());
}
return list;
};
this.init();
};
EnclosureCollection.prototype.toString=function(){return "Enclosure Collection 1.20";}
function SessionValidator(){
var uuidMap=new Object();
function echo(msg,level,severity,extraData){
var entry="SessionValidator: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
};
function containsSuspect(uuid){
return(uuidMap[uuid]!=undefined);
};
function getTotalSuspects(){
var total=0;
for(var uuid in uuidMap){
total++;
}
return total;
};
this.reset=function(){
echo("Reset called.",6,1);
uuidMap=new Object();
};
this.hasSuspectSessions=function(){
return(getTotalSuspects()>0);
};
this.addSuspectSession=function(uuid){
if(!containsSuspect(uuid)){
uuidMap[uuid]=uuid;
echo("Adding session trace - UUID: "+uuid,1,4,["Total: "+getTotalSuspects()]);
}
};
this.removeSuspectSession=function(uuid){
if(containsSuspect(uuid)){
delete uuidMap[uuid];
echo("Removing session trace. UUID: "+uuid,1,1,["Total remaining: "+getTotalSuspects()]);
}
};
this.validateSessions=function(hpems,callback){
var sessions=new Array();
var formMgr=new FormManager(function(success){
if(isFunction(callback)){
callback(success);
}
});
formMgr.setTimeoutEnabled(true,300000,false);
formMgr.startTransactionBatch();
for(var index in hpems){
var thisHpem=hpems[index];
if(containsSuspect(thisHpem.getUuid())){
if(thisHpem.getIsConnected()==true&&thisHpem.getIsAuthenticated()==true){
echo("Validating suspect session. UUID: "+thisHpem.getUuid(),1,2);
formMgr.queueCall(thisHpem.isValidSession);
sessions.push(thisHpem.getUuid());
}
}
}
for(var i in sessions){
this.removeSuspectSession(sessions[i]);
}
formMgr.endBatch();
};
};
SessionValidator.prototype.toString=function(){return "Session Validator 1.00";}
Module("topology","1.2.0",function(mod){
var enclosures=new EnclosureCollection();
var listeners=new ListenerCollection();
var sessionValidator=new SessionValidator();
var selectedEnclosureId=0;
var rackTopologyDOM=null;
var enclosureLayoutDOM=null;
var enclosureLayoutCount=0;
var domBuilder=new DomBuilder();
var displayFrames=new Object();
var currentMode=TopologyModes.Local;
var currentState=TopologyStates.None;
var currentLoadState=LoadStates.None;
var currentPollState=PollStates.Stopped;
var currentAlertState=AlertStates.None;
var currentDisplayMode=TopologyModes.DisplayOn;
var MIN_INTERVAL=15000;
var pollInterval=15000;
var pollTimerId=0;
var debugging=top.debugIsActive();
function topologyDebug(debugState){
debugging=debugState;
};
function echo(msg,level,severity,extraData){
if(debugging==true){
var entry="Topology: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
}
};
function stateChangeEvent(newValue){
switch(newValue){
case TopologyModes.Linked:
if(currentMode!=newValue||mod.getMaxConnectionsExceeded()!=""){
currentMode=newValue;
rackTopologyDOM=null;
echo("Topology Mode set to "+newValue,2,3);
}
break;
case TopologyModes.Fixed:
currentMode=newValue;
echo("Topology Mode set to "+newValue,2,3);
break;
case TopologyModes.Local:
if(currentMode!=newValue){
currentMode=newValue;
echo("Topology Mode set to "+newValue,2,3);
notifyPollingClients();
}
switchToLocalMode(currentDisplayMode==TopologyModes.DisplayOn);
break;
case TopologyModes.DisplayOn:
case TopologyModes.DisplayOff:
if(currentDisplayMode!=newValue){
echo("Display mode set to "+newValue,2,4);
currentDisplayMode=newValue;
}
break;
case TopologyStates.Updating:
if(currentState!=TopologyStates.Updating){
currentState=newValue;
echo("Topology State set to "+newValue,2,3);
listeners.callListeners("TOPOLOGY_CHANGE_PENDING");
}
break;
case TopologyStates.Complete:
updateEventThrottle();
if(currentState!=TopologyStates.Complete){
currentState=newValue;
echo("Topology State set to "+newValue,2,3);
listeners.callListeners("TOPOLOGY_CHANGE_COMPLETE");
notifyPollingClients();
}
break;
case TopologyStates.None:
currentState=newValue;
echo("Topology State reset: "+newValue,2,3);
break;
case AlertStates.LoggingOut:
currentAlertState=newValue;
echo("Alert State set to "+newValue,1,5);
break;
case AlertStates.None:
currentAlertState=newValue;
echo("Alert State set to "+newValue,1,2);
break;
case PollStates.Started:
if(currentPollState!=newValue){
currentPollState=newValue;
echo("Polling State set to "+newValue,1,2);
startPollingTopology();
}
break;
case PollStates.Stopped:
currentPollState=newValue;
echo("Polling State set to "+newValue,1,2);
stopPollingTimer();
break;
case LoadStates.Loading:
case LoadStates.Complete:
case LoadStates.None:
currentLoadState=newValue;
echo("Load State set to "+newValue,1,2);
break;
default:
echo("Unknown topology state: "+newValue,1,6);
break;
}
};
function pollTopology(){
if(currentPollState==PollStates.Started){
mod.getTopology(function(result){
startPollingTopology();
},true,null,pollInterval);
}
};
function stopPollingTimer(){
if(pollTimerId>0){
window.clearTimeout(pollTimerId);
}
};
function startPollingTopology(){
stopPollingTimer();
pollTimerId=window.setTimeout(pollTopology,pollInterval);
};
function notifyPollingClients(){
if(currentPollState==PollStates.Started){
listeners.callListeners("TOPOLOGY_CHANGE_EVENT",enclosures.getProxies().length);
}
};
function addEnclosure(hpemObj,callback){
echo("addEnclosure called for Enclosure: "+(hpemObj.encName)+".",2,1,
["Enc: "+hpemObj.encNum,"Local: "+hpemObj.isLocal,"UUID: "+hpemObj.uuid]);
var newHpem=null;
if(hpemObj.isLocal==true){
echo("Updating PRIMARY enclosure object.",1,1);
newHpem=assertPrimaryEnclosure();
if(currentMode!=TopologyModes.Local||currentPollState==PollStates.Started){
newHpem.setEnclosureNumber(hpemObj.encNum,true);
}
newHpem.setUuid(hpemObj.uuid);
newHpem.setObjEnclosureName(hpemObj.encName);
newHpem.setObjRackName(hpemObj.rackName);
mod.selectPrimaryEnclosure();
}else{
echo("Creating NEW linked enclosure object.",1,1);
newHpem=new hpem(hpemObj.soapUrl,hpemObj.encNum,
hpemObj.isLocal,hpemObj.uuid,hpemObj.encName,hpemObj.rackName);
newHpem.setProxyUrl(hpemObj.url);
enclosures.addEnclosure(newHpem);
}
newHpem.setActiveFirmwareVersion(hpemObj.activeFwVersion);
newHpem.setStandbyFirmwareVersion(hpemObj.standbyFwVersion);
newHpem.setTwoFactorEnabled(parseBool(hpemObj.tfaEnabled));
newHpem.setCurrentFipsMode(hpemObj.fipsMode);
newHpem.setCurrentFipsState(hpemObj.fipsStatus);
newHpem.setEnclosureType(hpemObj.encType);
if(hpemObj.isTower!=''){
newHpem.setIsTower(hpemObj.isTower);
}else if(hpemObj.lcdPartNo!=''){
newHpem.setIsTower(hpemObj.lcdPartNo);
}
sendOaDetails(newHpem,callback);
return newHpem;
};
function updateEnclosure(hpemObj,callback){
echo("updateEnclosure called for Enclosure: "+(hpemObj.encName)+".",2,1,
["Enc: "+hpemObj.encNum,"Local: "+hpemObj.isLocal,"UUID: "+hpemObj.uuid]);
var existingHpem=enclosures.getEnclosure(hpemObj.uuid,true);
if(existingHpem!=null){
var wasDisconnected=(existingHpem.getIsConnected()==false);
if(currentMode!=TopologyModes.Local||currentPollState==PollStates.Started){
existingHpem.setEnclosureNumber(hpemObj.encNum,true);
}
existingHpem.setIsConnected(hpemObj.isConnected);
existingHpem.setIsLocal(hpemObj.isLocal);
existingHpem.setSoapUrl(hpemObj.soapUrl);
existingHpem.setActiveFirmwareVersion(hpemObj.activeFwVersion);
existingHpem.setStandbyFirmwareVersion(hpemObj.standbyFwVersion);
existingHpem.setTwoFactorEnabled(parseBool(hpemObj.tfaEnabled));
existingHpem.setCurrentFipsMode(hpemObj.fipsMode);
existingHpem.setCurrentFipsState(hpemObj.fipsStatus);
existingHpem.setObjEnclosureName(hpemObj.encName);
existingHpem.setObjRackName(hpemObj.rackName);
existingHpem.setEnclosureType(hpemObj.encType);
if(hpemObj.isTower!=''){
existingHpem.setIsTower(hpemObj.isTower);
}else if(hpemObj.lcdPartNo!=''){
existingHpem.setIsTower(hpemObj.lcdPartNo);
}
if(wasDisconnected){
if(hpemObj.isConnected==true&&existingHpem.getIsAuthenticated()==true){
sessionValidator.addSuspectSession(hpemObj.uuid);
}
}
sendOaDetails(existingHpem,callback);
}
return existingHpem;
}
function sendOaDetails(hpemInstance,oaDetailsCallback,pollClient){
if(!top.checkStandby()&&hpemInstance.getActiveFirmwareVersion()<=1.20){
echo("Outdated firmware detected for enclosure "+hpemInstance.getEnclosureNumber()+".",1,5);
}
if(currentPollState!=PollStates.Started||pollClient==true){
var encNum=hpemInstance.getEnclosureNumber();
var isLocal=hpemInstance.getIsLocal();
var callback=assertFunction(oaDetailsCallback);
hpemInstance.getOaInfos(function(result,method){
oaCallback(result,method,encNum,isLocal,callback);},true);
hpemInstance.getOaStatuss(function(result,method){
oaCallback(result,method,encNum,isLocal,callback);},true);
}
};
function oaCallback(result,methodName,encNum,isLocal,callback){
var params=["enc"+encNum,"",isLocal];
switch(methodName){
case "getOaInfos":
params[1]=getElementValueXpath(result,"//hpoa:oaInfo[hpoa:youAreHere='true']/hpoa:fwVersion");
params[0]+="fw";
break;
case "getOaStatuss":
params[1]=getElementValueXpath(result,"//hpoa:oaStatus[hpoa:oaRole='ACTIVE']/hpoa:oaName");
params[0]+="oaName";
break;
}try{
callback(params[0],params[1],params[2]);
}catch(e){
echo("oaCallback: "+e.message,2,4);
}
};
function removeEnclosureFromCache(uuid){
if(rackTopologyDOM!=null){
var parentXpath="//hpoa:enclosures";
var childXpath="//hpoa:enclosure[hpoa:enclosureUuid='"+uuid+"']";
if(domBuilder.removeChild(rackTopologyDOM,parentXpath,childXpath)==false){
childXpath="//hpoa:enclosure[hpoa:enclosureUrl='"+uuid+"']";
domBuilder.removeChild(rackTopologyDOM,parentXpath,childXpath)
}
}
};
function cascadeEnclosureRemoval(encCollection,localEncNum,encNum,direction){
var currentEncNum=0;
switch(direction){
case "ABOVE":
for(var i in encCollection){
currentEncNum=encCollection[i].getEnclosureNumber();
if(currentEncNum<=encNum){
echo("Removing upper enclosure "+currentEncNum+" from topology.",1,5);
rackTopologyDOM=null;
enclosures.removeEnclosure(encCollection[i].getUuid());
}
}
break;
case "BELOW":
for(var j in encCollection){
currentEncNum=encCollection[j].getEnclosureNumber();
if(currentEncNum>=encNum){
echo("Removing lower enclosure "+currentEncNum+" from topology.",1,5);
removeEnclosureFromCache(encCollection[j].getUuid());
enclosures.removeEnclosure(encCollection[j].getUuid());
}
}
break;
}
};
function removeEnclosure(uuid){
var lostHpem=getEnclosure(uuid);
if(lostHpem!=null){
if(mod.getDisplayMode()==TopologyModes.DisplayOff){
lostHpem.setIsAuthenticated(false);
return false;
}
if(lostHpem.getIsLocal()==true){
echo("Logging out - lost communicaton with the primary enclosure.",1,7)
mod.notifyUserSessionEnding(AlertReasons.PrimaryCommLoss);
return false;
}
var localEncNum=enclosures.getPrimaryEnclosure().getEnclosureNumber();
var encNum=lostHpem.getEnclosureNumber();
var encCollection=enclosures.getProxies();
echo("Enclosure list before removal.",2,3,enclosures.getEncInfo());
echo("Local Enc: "+localEncNum+"   Removing Enc: "+encNum,2,3);
stateChangeEvent(TopologyStates.Updating);
var existingFocusUuid=(mod.getSelectedProxy()?mod.getSelectedProxy().getUuid():0);
if(encNum<localEncNum){
cascadeEnclosureRemoval(encCollection,localEncNum,encNum,"ABOVE")
}else{
cascadeEnclosureRemoval(encCollection,localEncNum,encNum,"BELOW");
}
echo("Enclosure list after removal.",2,3,enclosures.getEncInfo());
autoNavigateByContext(null,null,(assertValidFocus(existingFocusUuid)==false));
stateChangeEvent(TopologyStates.Complete);
return true;
}else{
echo("Cannot remove enclosure UUID "+uuid+"  - not found.",1,6);
return false;
}
};
function autoNavigateByContext(alertMsg,type,force){
var currentUserContext=UserContextTypes.None;
var contextTitle=top.getString("topologyNotice");
var alertEnabled=true;
var contextMsg="";
if((currentMode==TopologyModes.Local&&mod.getMaxConnectionsExceeded()=="")||
(currentDisplayMode==TopologyModes.DisplayOff)){
return;
}
if(isFunction(top.getCurrentUserContext)){
currentUserContext=top.getCurrentUserContext();
}
switch(currentUserContext){
case UserContextTypes.None:
case UserContextTypes.Login:
case UserContextTypes.Standby:
case UserContextTypes.LoadOrFlash:
alertEnabled=false;
break;
case UserContextTypes.WizardWelcome:
case UserContextTypes.WizardFinish:
break;
case UserContextTypes.WizardEncSelect:
if(isValidString(alertMsg)){
top.gotoContext(UserContextTypes.WizardEncSelect);
}
break;
case UserContextTypes.WizardSteps:
contextMsg=top.getString("rackTopologyChanged")+"\n"+top.getString("updateEncSelections");
if(force||isValidString(alertMsg)){
top.gotoContext(UserContextTypes.WizardEncSelect);
}
break;
case UserContextTypes.DevicePage:
case UserContextTypes.OaFirmwareUpdate:
if(!force){
try{top.mainPage.getHiddenFrame().refreshNavTree(true);}catch(e){}
break;
}
contextMsg=top.getString("rackTopologyChanged");
if(enclosures.getProxies().length<enclosures.getProxies(true).length){
contextMsg+="\n\n"+top.getString("rebootedWillReturn");
}
case UserContextTypes.RackOverview:
top.gotoContext(UserContextTypes.RackOverview);
break;
default:
echo("Unknown user context type: "+currentUserContext,1,5);
break;
}
if(isValidString(alertMsg)){
contextMsg=alertMsg;
}
if(contextMsg!=""&&alertEnabled==true){
try{
top.mainPage.displayNotice(contextMsg,contextTitle,(exists(type)?type:AlertMsgTypes.Information),(contextMsg.length>100?400:null),30);
}catch(e){
alert(contextMsg,AlertMsgTypes.Information,30);
}
}
};
function redrawThisEnclosure(hpemObj){
if(hpemObj&&isFunction(top.getCurrentUserContext)){
var context=top.getCurrentUserContext();
var encNum=hpemObj.getEnclosureNumber();
switch(context){
case UserContextTypes.DevicePage:
case UserContextTypes.OaFirmwareUpdate:
case UserContextTypes.RackOverview:
if(context==UserContextTypes.RackOverview){
var contentFrame=top.mainPage.getContentContainer();
try{
if(contentFrame.getCurrentTab()=="rackOverview"){
contentFrame.loadRackEnclosure(hpemObj,encNum);
}
}catch(eOverview){}
}
try{
top.mainPage.getNavigationFrame().loadTreeEnclosure(hpemObj,encNum);
}catch(eTree){}
break;
case UserContextTypes.WizardEncSelect:
try{
top.mainPage.getPortalFrame().getWizardContentFrame().redrawEnclosureSelectTable();
}catch(eWizard){}
break;
default:
echo("Redraw not attempted in this context.",1,5,["Enclosure: "+encNum,"Context: "+context]);
break;
}
}
};
function assertPrimaryEnclosure(){
var primaryHpem=enclosures.getPrimaryEnclosure();
if(primaryHpem==null){
primaryHpem=enclosures.addPrimaryEnclosure(getServiceUrl(),1);
}
return primaryHpem;
};
function updateEventThrottle(){
var hpems=enclosures.getProxies();
var limit=(hpems.length<6?15000:20000);
for(var index in hpems){
hpems[index].getEvents().setSleepInterval(limit,true);
}
};
function switchToLocalMode(destroyLinked){
var hpemLocal=assertPrimaryEnclosure();
echo("Switching to local mode.",1,1,["Current mode: "+currentMode]);
if(currentMode!=TopologyModes.Local){
currentMode=TopologyModes.Local;
}
hpemLocal.setEnclosureNumber("1",true);
mod.setSelectedEnclosureNumber("1");
removeLinkedEnclosures(destroyLinked);
};
function removeLinkedEnclosures(destroyLinked){
var linkedEncs=enclosures.getLinkedProxies(true);
for(var index in linkedEncs){
enclosures.removeEnclosure(linkedEncs[index].getUuid(),true,assertFalse(destroyLinked));
}
};
function assertRemovalWarranted(uuid,soapUrl){
var thisHpem=getEnclosure(uuid);
var method="assertRemovalWarranted";
if(thisHpem==null){
echo(method+": the enclosure is already gone. UUID: "+uuid,1,4);
}else if(thisHpem.getIsAuthenticated()==false){
echo(method+": the enclosure is already un-authenticated.",1,4);
}else if(thisHpem.getIsConnected()==false){
echo(method+": the enclosure is already disconnected.",1,4);
}else if(thisHpem.getSoapUrl()!=soapUrl){
echo(method+": the enclosure's proxy url has changed.",1,4);
}else if(thisHpem.positionHasChanged()==true){
echo(method+": the enclosure has changed positions.",1,4,thisHpem.getPositionHistory());
}else{
echo(method+": the enclosure is active - removal warranted.",1,4);
return true;
}
return false;
};
function assertEnclosureNumbersMatch(uuid,hpemLocal,callback){
var thisHpem=getEnclosure(uuid);
var currentEncNum=(thisHpem==null?0:thisHpem.getEnclosureNumber());
hpemLocal.getRackTopology2(function(result){
if(getCallSuccess(result)==true){
var freshEncNum=getElementValueXpath(result,"//hpoa:enclosure[hpoa:enclosureUuid='"+uuid+"']/hpoa:enclosureNumber");
if(freshEncNum==""){
freshEncNum=getElementValueXpath(result,"//hpoa:enclosure[hpoa:enclosureUrl='"+uuid+"']/hpoa:enclosureNumber");
}
if(freshEncNum==currentEncNum){
echo("The enclosure number has not changed.",1,2);
callback(null);
}else{
if(freshEncNum==""){
echo("Enclosure "+currentEncNum+" not found in fresh topology, update now.",1,5,["UUID: "+uuid]);
}else{
echo("The enclosure number has changed, update topology now.",1,5,["Current: "+currentEncNum,"Fresh: "+freshEncNum]);
}
callback(result);
}
}else{
mod.notifyUserSessionEnding(AlertReasons.PrimaryCommLoss);
}
},90000);
};
function compareNodes(dom1,dom2,xpath){
var cachedNodes=getArrayXpath(dom1,xpath);
var resultNodes=getArrayXpath(dom2,xpath);
if(cachedNodes.length!=resultNodes.length){
return true;
}
for(var i=0;i<cachedNodes.length;i++){
if(cachedNodes[i]!=resultNodes[i]){
return true;
}
}
return false;
};
function assertPrimaryActive(){
if(top.checkStandby()==true){
return true;
}
return(top.checkStandby(true)==false);
};
function assertTopologyChanged(result){
if(rackTopologyDOM==null){
return true;
}
result=domBuilder.assertParseable(result);
rackTopologyDOM=domBuilder.assertParseable(rackTopologyDOM);
var processor=new XsltProcessor("/120814-042457/Templates/topologyChangeTest.xsl");
processor.addParameter('topologyOld',rackTopologyDOM);
processor.addParameter('topologyNew',result);
var changes=processor.getOutput();
if(!processor.hasErrors()&&changes!=""){
echo("New values detected in topology document.",1,5,changes.split("^"));
return true;
}
return false;
};
function assertUuidExists(hpemObj){
var existingHpem=enclosures.getEnclosureByProxyUrl(hpemObj.url,true);
if(hpemObj.uuid==""){
echo("Missing uuid in topology.",1,5,["Proxy: "+hpemObj.url]);
if(existingHpem!=null){
hpemObj.uuid=existingHpem.getUuid();
if(hpemObj.encName==""){
hpemObj.encName=existingHpem.getEnclosureName();
}
echo("Found existing match: "+hpemObj.encName+" ("+hpemObj.uuid+")",1,2);
}else{
hpemObj.uuid=hpemObj.url;
echo("No existing match, using proxy url for UUID ("+hpemObj.uuid+").",1,3);
}
}else{
if(existingHpem!=null&&existingHpem.getUuid()!=hpemObj.uuid){
echo("Replacing existing uuid with new uuid.",1,4,["Old: "+existingHpem.getUuid(),"New: "+hpemObj.uuid]);
existingHpem.setUuid(hpemObj.uuid);
}
}
};
function assertValidFocus(existingFocusUuid){
var selectedProxy=mod.getSelectedProxy();
var dbgMsg="";
if(currentMode!=TopologyModes.Local&&currentPollState!=PollStates.Started){
if(selectedProxy==null){
dbgMsg="The selected enclosure number no longer exists.";
}else if(selectedProxy.getIsLocal()!=true){
if(selectedProxy.getIsAuthenticated()==false){
dbgMsg="The selected enclosure is not authenticated";
}else if(selectedProxy.getIsLoaded()==false){
dbgMsg="The selected enclosure has been unloaded.";
}else if(existingFocusUuid!=null&&selectedProxy.getUuid()!=existingFocusUuid){
dbgMsg="The uuid of the selected enclosure ("+selectedEnclosureId+") has changed";
}
}
}
if(dbgMsg.length>0){
echo(dbgMsg,1,5,["Selected: "+(selectedProxy?selectedProxy.getUuid():"Not found."),"Arg: "+existingFocusUuid]);
mod.selectPrimaryEnclosure();
return false;
}
return true;
};
function updateTopologyFromDocument(result,oaDetailsCallback){
var uuidsInResult=new Array();
if(top.MX_HIDDEN.getUserInitiatedFlash()||currentDisplayMode==TopologyModes.DisplayOff){
echo("topology update requested during firmware update.",1,5);
return false;
}
if(result!=null){
var resultDoc=getElementValueXpath(result,'//hpoa:rackTopology2/hpoa:enclosures',true);
if(assertTopologyChanged(result)){
rackTopologyDOM=result;
}else{
echo("DUPLICATE or EMPTY topology document - no update needed.",6,2);
return false;
}
stateChangeEvent(TopologyStates.Updating);
var existingFocusUuid=(mod.getSelectedProxy()?mod.getSelectedProxy().getUuid():0);
var existingProxyCount=enclosures.getProxies().length;
for(var i=0;i<resultDoc.childNodes.length;i++){
if(resultDoc.childNodes[i].nodeName=='hpoa:enclosure'){
var currentEnc=getElementValue(resultDoc.childNodes[i],'enclosureNumber','hpoa');
var hpemObj=new Object();
hpemObj.isLocal=parseBool(getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:primaryEnclosure'));
hpemObj.encNum=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:enclosureNumber');
hpemObj.uuid=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:enclosureUuid');
hpemObj.url=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:enclosureUrl');
hpemObj.encName=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:enclosureName');
hpemObj.rackName=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:rackName');
hpemObj.activeFwVersion=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:activeOa="true"]/hpoa:fwVersion');
hpemObj.standbyFwVersion=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:activeOa="false"]/hpoa:fwVersion');
hpemObj.encType=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:enclosureProductName');
hpemObj.lcdPartNo=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:extraData[@hpoa:name="LcdPartNumber"]');
hpemObj.isTower=getElementValueXpath(result,'//hpoa:enclosure[hpoa:isTower="'+currentEnc+'"]/hpoa:extraData[@hpoa:name="isTower"]');
hpemObj.tfaEnabled=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:extraData[@hpoa:name="TwoFactorEnabled"]');
var fipsStatusVar;
fipsStatusVar=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:extraData[@hpoa:name="FipsMode"]');
var fipsStatusVariable;
fipsStatusVariable=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:extraData[@hpoa:name="FipsSecurityStatus"]');
var fipsStatusVariable1;
fipsStatusVariable1=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:extraData[@hpoa:name="FipsSecurityStatus1"]');
if(fipsStatusVariable!=""){
if(fipsStatusVariable=="NO_ERROR"&&(fipsStatusVar=="FIPS-ON"||fipsStatusVar=="FIPS-DEBUG")){
hpemObj.fipsMode=getElementValueXpath(result,'//hpoa:enclosure[hpoa:enclosureNumber="'+currentEnc+'"]/hpoa:extraData[@hpoa:name="FipsMode"]');
}
}
if(fipsStatusVariable1!=""){
if(fipsStatusVariable1=="FIPS_ERROR_LDAP_CERT_SIZE"&&fipsStatusVar=="FIPS-ON"){
hpemObj.fipsStatus="SECURE-DEGRADED";
}
if(fipsStatusVariable1=="FIPS_ERROR_LDAP_CERT_SIZE"&&fipsStatusVar=="FIPS-DEBUG"){
hpemObj.fipsStatus="DEBUG-DEGRADED";
}
}
hpemObj.soapUrl=(hpemObj.isLocal?getServiceUrl():getServiceUrl(hpemObj.url));
hpemObj.isConnected=true;
assertUuidExists(hpemObj);
uuidsInResult.push(hpemObj.uuid);
if(!enclosures.containsEnclosure(hpemObj.uuid,true)){
if(currentMode==TopologyModes.Linked||currentPollState==PollStates.Started){
addEnclosure(hpemObj,oaDetailsCallback);
}else if(hpemObj.isLocal==true){
addEnclosure(hpemObj,oaDetailsCallback);
}
}else{
updateEnclosure(hpemObj,oaDetailsCallback);
}
}
}
var uuidsExisting=enclosures.getUuids();
echo("Comparing the enclosure collection after update.",1,2,enclosures.getEncInfo());
for(var index in uuidsExisting){
echo("Existing UUID="+uuidsExisting[index]+", looking for topology match.",6,1);
if(!arrayContains(uuidsInResult,uuidsExisting[index])){
echo("No match, removing enclosure with UUID="+uuidsExisting[index],6,4);
enclosures.removeEnclosure(uuidsExisting[index]);
}else{
echo("Found a match, doing nothing.",6,2);
}
}
echo("Comparison complete.",1,2,enclosures.getEncInfo());
var maxConns=mod.getMaxConnectionsExceeded();
var alertMsg=(maxConns==""?null:top.getString("maxEnclosuresExceeded1")+maxConns+top.getString("maxEnclosuresExceeded2"));
var alertType=(maxConns==""?null:AlertMsgTypes.NotAllowed);
if(sessionValidator.hasSuspectSessions()){
sessionValidator.validateSessions(enclosures.getAuthenticatedProxies(),function(success){
autoNavigateByContext(alertMsg,alertType,(assertValidFocus(existingFocusUuid)==false));
stateChangeEvent(TopologyStates.Complete);
});
}else{
autoNavigateByContext(alertMsg,alertType,(assertValidFocus(existingFocusUuid)==false));
stateChangeEvent(TopologyStates.Complete);
}
return(existingProxyCount==1?enclosures.getProxies().length>1:true);
}else{
echo("updateTopologyFromDocument: the document was null.",1,6);
return null;
}
};
function getMaxEnclosureCount(){
var MAX=MAX_ENCLOSURES();
var topologyTotal=enclosures.getProxies().length;
if(topologyTotal>MAX){
echo("Expanding the max enclosures from "+MAX+" to "+topologyTotal+".",1,5);
MAX=topologyTotal;
}
return MAX;
};
function getEnclosure(uuid){
return enclosures.getEnclosure(uuid);
};
function destroyEnclosure(hpemInstance,killSession,callbackFunction){
var callback=assertFunction(callbackFunction);
if(hpemInstance==null){
callback(false);
}else{
if(hpemInstance.getIsAuthenticated()==true){
hpemInstance.userLogOut(killSession,function(result){
echo("Signed out user on enclosure "+hpemInstance.getEnclosureNumber()+", destroying hpem instance.",6,2);
hpemInstance.destroyServiceObject();
delete hpemInstance;
hpemInstance=null;
callback(result,"userLogOut");
});
}else{
echo("Enclosure "+hpemInstance.getEnclosureNumber()+" is not authenticated, destroying hpem instance.",6,2);
hpemInstance.destroyServiceObject();
delete hpemInstance;
hpemInstance=null;
callback(true,"userLogOut: Not called.");
}
}
};
function getEnclosureByPosition(enclosureNumber,includeNonActive){
var encCollection=enclosures.getProxies(includeNonActive);
for(var index in encCollection){
if(encCollection[index].getEnclosureNumber()==enclosureNumber){
return encCollection[index];
}
}
if(encCollection.length>0){
echo("Could not locate the enclosure in position "+enclosureNumber,1,5,enclosures.getEncInfo());
}
return null;
};
function updateCollectionWithUserSelections(selectionElems){
var totalSelected=0;
var topologyDisabled=mod.getMaxConnectionsExceeded()!="";
var existingUuids=enclosures.getUuids();
var selectedUuids=new Array();
for(var index in selectionElems){
if(selectionElems[index].checked==true){
echo("Adding Enclosure "+selectionElems[index].uuid+" to sign in selections.",1,4);
selectedUuids.push(selectionElems[index].uuid);
totalSelected++;
}
}
for(var i in existingUuids){
if(!arrayContains(selectedUuids,existingUuids[i])){
enclosures.removeEnclosure(existingUuids[i],false,true);
}
}
if(totalSelected>1&&totalSelected==selectionElems.length||topologyDisabled==true){
stateChangeEvent(TopologyModes.Linked);
}else if(totalSelected>1&&totalSelected<selectionElems.length){
stateChangeEvent(TopologyModes.Fixed);
}else{
stateChangeEvent(TopologyModes.Local);
}
};
function signInAllEnclosures(user,pass){
var linkedCollection=enclosures.getLinkedProxies();
var hpemLocal=assertPrimaryEnclosure();
hpemLocal.userLogIn(user,pass,function(result){
if(hpemLocal.getIsAuthenticated()==true){
if(linkedCollection.length>0&&currentMode!=TopologyModes.Local){
var batchMgr=new BatchManager(function(success){
for(var i in linkedCollection){
if(linkedCollection[i].getEnclosureType()==EnclosureTypes.Unknown){
linkedCollection[i].setIsAuthenticated(false);
}
}
top.startLogoutTimer();
setTimeout('top.hiddenPageLoadData(false)',10);
});
for(var index in linkedCollection){
var batch=batchMgr.addBatch('Sign In Linked Enclosure');
var trans1=batch.addTransaction('Authenticate User',new FormManager(),true);
trans1.formMgr.queueCall(linkedCollection[index].userLogIn,[user,pass]);
var trans2=batch.addTransaction('Load Enclosure Info',new FormManager(),false,true);
trans2.formMgr.queueCall(linkedCollection[index].getEnclosureInfo);
}
batchMgr.runBatches();
}else{
top.startLogoutTimer();
setTimeout('top.hiddenPageLoadData(false)',10);
}
}else{
top.failLogin(result);
}
});
};
function loadSingleEnclosure(uuid,progressBarInit,progressBarMgr,callback){
var thisHpem=enclosures.getEnclosure(uuid);
var objectsToLoad=0;
var objectsLoaded=0;
var updateFunction=function(){
progressBarMgr.updateProgressBar(0,(++objectsLoaded/objectsToLoad)*100);
if(objectsLoaded==objectsToLoad){
thisHpem.setIsLoaded(true);
window.setTimeout(function(){callback(true);},100);
}
}
if(thisHpem&&thisHpem.getIsAuthenticated()==true){
var encName=(top.checkStandby()?"":thisHpem.getEnclosureName()+": ");
var formMgr=new FormManager(function(success){
if(success){
progressBarInit(encName+top.getString("loadingEncInfo"));
if(top.checkStandby()){
thisHpem.getOaId(function(result){
var bayNum=parseInt(getElementValueXpath(result,'//hpoa:oaId'));
objectsToLoad=thisHpem.loadCacheStandby(bayNum,updateFunction);
});
}else{
objectsToLoad=thisHpem.loadCache(updateFunction);
}
}else{
callback(false);
}
});
progressBarInit(encName+top.getString("registeringEvents"));
formMgr.usePercentMode(function(percent){
progressBarMgr.updateProgressBar(0,percent);
});
formMgr.startTransactionBatch(true);
formMgr.queueCall(thisHpem.registerForEvents);
formMgr.queueCall(thisHpem.getEnclosureInfo);
formMgr.endBatch();
}else{
callback(true);
}
};
function analyzeRegistrations(topologyChanged){
var hpems=enclosures.getAuthenticatedProxies();
var totalRegistered=0;
var enclosureNames="";
echo("Analyzing registrations for "+hpems.length+" authenticated enclosures.",1,3,["Topology changed: "+topologyChanged]);
if(hpems.length>0){
for(var t in hpems){
if(hpems[t].getEnclosureType()==EnclosureTypes.Unknown){
hpems[t].setIsAuthenticated(false);
if(hpems[t].getIsLocal()==true){
mod.notifyUserSessionEnding(AlertReasons.PrimaryEncType);
return;
}
}
if(hpems[t].getEventsOn()==true){
totalRegistered++;
}else{
if(hpems[t].getIsLocal()==true){
mod.notifyUserSessionEnding(AlertReasons.PrimarySubscribe);
return;
}
enclosureNames+=hpems[t].getEnclosureName()+"\n";
}
}
if(totalRegistered!=hpems.length&&!topologyChanged){
alert(top.getString("eventRegFailedLinked")+"\n\n"+enclosureNames,AlertMsgTypes.Warning,30);
}
}
};
function loadAllEnclosures(progressBarInit,progressBarMgr,callback){
var hpems=enclosures.getAuthenticatedProxies();
var topologyChanged=(currentState==TopologyStates.Complete?false:true);
echo("Loading all authenticated enclosures.",1,2,["Current Topology State: "+currentState]);
function topologyPending(){
topologyChanged=true;
echo("topology change detected during loading sequence.",1,6,["Registration analysis limited to primary enclosure."]);
}
mod.addTopologyPendingListener(topologyPending);
var batchMgr=new BatchManager(function(success){
if(!success){
echo("Analyzing registrations because batch failed.",1,6,["Attempted total: "+hpems.length]);
analyzeRegistrations(topologyChanged);
}
mod.removeListener(topologyPending);
callback();
});
var batch=batchMgr.addBatch("LoadingEnclosures");
for(var i in hpems){
if(hpems[i].getIsLocal()==true){
var trans=batch.addTransaction("Loading "+hpems[i].getEnclosureName(),new FormManager(),true);
trans.formMgr.queueCall(loadSingleEnclosure,[hpems[i].getUuid(),progressBarInit,progressBarMgr]);
break;
}
}
for(var j in hpems){
if(hpems[j].getIsLocal()==false){
var transLinked=batch.addTransaction("Loading "+hpems[j].getEnclosureName(),new FormManager());
transLinked.formMgr.queueCall(loadSingleEnclosure,[hpems[j].getUuid(),progressBarInit,progressBarMgr]);
}
}
batchMgr.runBatches();
};
function stopEvents(hpems,progressBarInit,progressBarMgr,callback){
var formMgr=new FormManager(function(success){
callback();
});
progressBarInit(top.getString('stoppingEvents'));
formMgr.usePercentMode(function(percent){
progressBarMgr.updateProgressBar(0,percent);
});
formMgr.startTransactionBatch();
for(var i=0;i<hpems.length;i++){
if(hpems[i].getIsLoaded()==true){
hpems[i].setIsLoaded(false);
hpems[i].clearCache();
}
if(hpems[i].getEventsOn()==true){
formMgr.queueCall(hpems[i].stopEvents);
}
}
formMgr.endBatch();
};
mod.init=function(){
top.registerDebugListener(topologyDebug);
};
mod.loadEnclosureData=function(uuid,progressBarInit,progressBarMgr,callback){
var finalCallback=assertFunction(callback);
if(existsNonNull(uuid)==true){
var hpem=enclosures.getEnclosure(uuid);
var resultHandler=function(success,hpemObj){
if(!success&&hpemObj.getIsLocal()){
mod.notifyUserSessionEnding(AlertReasons.PrimarySubscribe);
}else{
finalCallback();
}
}
if(hpem.getIsLoaded()==true){
stopEvents([hpem],progressBarInit,progressBarMgr,function(){
if(hpem.getIsLocal()==false&&hpem.getHasFocus()){
mod.selectPrimaryEnclosure();
}
loadSingleEnclosure(uuid,progressBarInit,progressBarMgr,function(success){
resultHandler(success,hpem);
});
});
}else{
loadSingleEnclosure(uuid,progressBarInit,progressBarMgr,function(success){
resultHandler(success,hpem);
});
}
}else{
var hpems=enclosures.getAuthenticatedProxies();
if(enclosures.getLoadedEnclosures().length>0){
stopEvents(hpems,progressBarInit,progressBarMgr,function(){
top.getTransport().clearCallStacks();
top.getTransport().notifySessionReset();
loadAllEnclosures(progressBarInit,progressBarMgr,function(){
finalCallback();
});
});
}else{
loadAllEnclosures(progressBarInit,progressBarMgr,function(){
finalCallback();
});
}
}
};
mod.getLoginHtml=function(result){
var topologyDoc=null;
if(result!=null&&getTotalXpath(result,'//hpoa:enclosures/hpoa:enclosure')>0){
topologyDoc=result;
}else{
var hpemLocal=assertPrimaryEnclosure();
domBuilder.addDocument("hpoa:enclosures",["xmlns:hpoa","hpoa.xsd"]);
domBuilder.appendChild("hpoa:enclosure");
domBuilder.appendChild("hpoa:primaryEnclosure",null,"true","//hpoa:enclosure");
domBuilder.appendChild("hpoa:enclosureClone",null,"true","//hpoa:enclosure");
domBuilder.appendChild("hpoa:enclosureUuid",null,"LOCAL","//hpoa:enclosure");
domBuilder.appendChild("hpoa:enclosureNumber",null,"1","//hpoa:enclosure");
domBuilder.appendChild("hpoa:enclosureName",null,hpemLocal.getEnclosureName(),"//hpoa:enclosure");
topologyDoc=domBuilder.getDocument();
}
var templatePath="/120814-042457/Templates/topology.xsl";
var processor=new XsltProcessor(templatePath);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('topology',topologyDoc);
var output=processor.getOutput();
return(processor.hasErrors()==true?"":output);
};
mod.getLoginBannerHtml=function(bannerText){
var processor=new XsltProcessor("/120814-042457/Templates/loginBanner.xsl");
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('bannerText',bannerText);
var output=processor.getOutput();
return(processor.hasErrors()==true?"":output);
};
mod.getTopology=function(callback,fresh,oaDetailsCallback,maxWait){
if(rackTopologyDOM==null||fresh){
var hpemLocal=assertPrimaryEnclosure();
hpemLocal.getRackTopology2(function(result){
var topologyChanged=null;
if(getCallSuccess(result)==true){
topologyChanged=updateTopologyFromDocument(result,oaDetailsCallback);
}else{
rackTopologyDOM=null;
sendOaDetails(hpemLocal,oaDetailsCallback);
}
if(isFunction(callback)){
callback(result,"getRackTopology2",topologyChanged);
}
},maxWait);
}else{
if(isFunction(callback)){
callback(rackTopologyDOM,"getRackTopology2",false);
}
if(currentPollState==PollStates.Started&&isFunction(oaDetailsCallback)){
var currentEncs=enclosures.getProxies();
echo("Sending OA details to poll client.",6,2);
for(var index in currentEncs){
sendOaDetails(currentEncs[index],oaDetailsCallback,true);
}
}
}
};
mod.updateTopology=function(topology){
if(existsNonNull(topology)){
updateTopologyFromDocument(topology);
}else{
mod.getTopology(null,true);
}
};
mod.notifyCommLoss=function(uuid,soapUrl){
if(mod.getDisplayMode()==TopologyModes.DisplayOff){
var hpemLost=getEnclosure(uuid);
if(hpemLost){
listeners.callListeners("TOPOLOGY_EVENT",top.getString("commWithOaLost"),uuid);
hpemLost.setIsAuthenticated(false);
}
return;
}
if(assertRemovalWarranted(uuid,soapUrl)){
var hpemLocal=assertPrimaryEnclosure();
if(hpemLocal.getUuid()==uuid){
hpemLocal.setIsConnected(false);
mod.notifyUserSessionEnding(AlertReasons.PrimaryCommLoss);
return;
}else{
if(currentLoadState==LoadStates.Loading||top.MX_HIDDEN.getUserInitiatedFlash()){
removeEnclosure(uuid);
return;
}
assertEnclosureNumbersMatch(uuid,hpemLocal,function(result){
if(result==null){
removeEnclosure(uuid);
}else{
updateTopologyFromDocument(result);
}
});
}
}
};
mod.notifyAuthenticationFailed=function(uuid,methodName,soapUrl){
if(assertPrimaryActive()==false){
mod.notifyStandbyMode();
return;
}
var hpemInstance=getEnclosure(uuid);
var msg="";
if(mod.getDisplayMode()==TopologyModes.DisplayOff){
if(hpemInstance){
hpemInstance.setIsAuthenticated(false);
msg=replaceCharacter(top.getString("linkedSessionLoss"),"{%1}",hpemInstance.getEnclosureName());
listeners.callListeners("TOPOLOGY_EVENT",msg,uuid);
return;
}
}
switch(methodName){
case "userLogIn":
case "userLogOut":
case "unSubscribeForEvents":
case "generateHeartbeat":
break;
case "subscribeForEvents":
case "isValidSession":
if(hpemInstance){
hpemInstance.setIsAuthenticated(false);
}
break;
default:
if(assertRemovalWarranted(uuid,soapUrl)){
var hpemLocal=assertPrimaryEnclosure();
if(hpemLocal.getUuid()==uuid){
hpemLocal.setIsAuthenticated(false);
mod.notifyUserSessionEnding(AlertReasons.InvalidSession);
return;
}else{
if(currentState==TopologyStates.Updating){
echo("Authentication failure detected during topology update.",1,4);
return;
}
assertEnclosureNumbersMatch(uuid,hpemLocal,function(result){
if(result==null){
if(hpemInstance){
hpemInstance.setIsAuthenticated(false);
msg=replaceCharacter(top.getString("linkedSessionLoss"),"{%1}",hpemInstance.getEnclosureName());
}
autoNavigateByContext(msg,null,assertValidFocus(null)==false);
}else{
updateTopologyFromDocument(result);
}
});
}
}
break;
}
};
mod.notifyEventPipeLoss=function(uuid){
if(currentLoadState==LoadStates.Loading){
return;
}
var hpemInstance=getEnclosure(uuid);
if(hpemInstance&&hpemInstance.getEventsOn()==true){
if(hpemInstance.getIsLocal()==true){
echo("Event pipe lost on the primary enclosure, logging out.",1,7)
mod.notifyUserSessionEnding(AlertReasons.PrimaryPipeLoss);
}else{
echo("Event pipe lost on linked enclosure, unloading it.",1,7);
var msg=replaceCharacter(top.getString("linkedPipeLoss"),"{%1}",hpemInstance.getEnclosureName());
listeners.callListeners("TOPOLOGY_EVENT",msg,uuid);
hpemInstance.setIsLoaded(false);
hpemInstance.stopEvents();
hpemInstance.clearCache();
hpemInstance.setIsWizardSelected(false);
autoNavigateByContext(msg,AlertMsgTypes.Warning,assertValidFocus(null)==false);
}
}
};
mod.notifyCookieSet=function(uuid,cookie){
if(cookie.toString().indexOf(LINKED_ENC_COOKIE_NAME())>-1){
var sessionKey=lookupKeyValue(cookie,LINKED_ENC_COOKIE_NAME());
var hpemInstance=getEnclosure(uuid);
if(hpemInstance){
if(hpemInstance.getIsLocal()==false){
if(sessionKey==""){
echo("Server cookie was empty.",1,6,[cookie]);
hpemInstance.setIsAuthenticated(false);
}else{
echo("Server cookie contained session key.",1,2,[sessionKey]);
if(hpemInstance.getSessionKey()!=sessionKey){
hpemInstance.userLoginSSO(sessionKey,false);
}
}
redrawThisEnclosure(hpemInstance);
}
}
}
};
mod.unloadLinkedEnclosure=function(uuid,killSession,reason,type,contextMsg){
var hpemInstance=getEnclosure(uuid);
var msg="";
echo("Unload linked enclosure called.",1,3,["Sign out: "+killSession,"Reason: "+reason,"contextMsg: "+contextMsg]);
if(hpemInstance&&hpemInstance.getIsLocal()==false){
switch(reason){
case AlertReasons.LinkedFlash:
msg=replaceCharacter(top.getString("linkedFlashing"),"{%1}",hpemInstance.getEnclosureName());
break;
case AlertReasons.WebServerDown:
msg=replaceCharacter(top.getString("linkedWebServerDown"),"{%1}",hpemInstance.getEnclosureName());
break;
default:
}
top.getTransport().cancelCalls(uuid);
hpemInstance.stopEvents();
hpemInstance.setIsLoaded(false);
hpemInstance.setIsWizardSelected(false);
hpemInstance.setHasFocus(false);
if(killSession==true){
hpemInstance.setIsAuthenticated(false);
}
autoNavigateByContext(msg+(isValidString(contextMsg)?"\n\n"+contextMsg:""),(existsNonNull(type)?type:AlertMsgTypes.Information),assertValidFocus(null)==false);
}
};
mod.notifyStandbyMode=function(){
if(top.checkStandby()==true){
stateChangeEvent(TopologyModes.Local);
return;
}
echo("Standby mode detected during an active session.",1,4);
switch(top.getCurrentUserContext()){
case UserContextTypes.Standby:
return;
case UserContextTypes.Login:
case UserContextTypes.LoadOrFlash:
break;
default:
mod.notifyUserSessionEnding(AlertReasons.StandbyMode,null,true);
break;
}
top.getTransport().unload();
assertPrimaryEnclosure().setIsAuthenticated(false);
top.location.replace(encodeURI(top.location.href));
};
mod.notifyUserSessionEnding=function(reason,errorCode,notifyOnly,errorType){
var hpem=assertPrimaryEnclosure();
var encName=hpem.getEnclosureName();
var msg="";
if(currentAlertState!=AlertStates.LoggingOut&&currentPollState!=PollStates.Started&&currentDisplayMode!=TopologyModes.DisplayOff){
stateChangeEvent(AlertStates.LoggingOut);
switch(reason){
case AlertReasons.PrimaryCommLoss:
msg=top.getString("commWithOaLost")+"\n\n"+top.getString("sessionWillReset");
if(hpem.getProperty("ConfigScriptInProgress")==true){
hpem.setProperty("ConfigScriptInProgress",false);
msg+="\n\n"+top.getString("oaCommLossScriptMsg");
}
break;
case AlertReasons.PrimaryPipeLoss:
msg=top.getString("primaryPipeLoss")+"\n\n"+top.getString("sessionWillReset");
break;
case AlertReasons.InvalidSession:
msg=top.getString("sessionNotValid")+"\n\n"+top.getString("mustLoginAgain");
break;
case AlertReasons.StandbyMode:
msg=top.getString("modeChangeStandby")+"\n\n"+top.getString("sessionWillReset");
break;
case AlertReasons.PrimarySubscribe:
msg=top.getString("eventRegFailedPrimary")+"\n\n"+top.getString("mustLoginAgain");
break;
case AlertReasons.PrimaryEncType:
msg=top.getString("unknownPrimaryEncType")+"\n\n"+top.getString("mustLoginAgain");
break;
default:
break;
}
if(existsNonNull(errorCode)){
msg+="\n\n"+errorCode;
}
alert(msg,(existsNonNull(errorType)?errorType:AlertMsgTypes.Information),60);
if(notifyOnly!=true){
top.logout();
}
}
};
mod.signIn=function(user,pass){
var hpemLocal=assertPrimaryEnclosure();
if(top.checkStandby(true)==true){
stateChangeEvent(TopologyModes.Local);
hpemLocal.userLogIn(user,pass,function(result){
if(getCallSuccess(result)==true){
top.startLogoutTimer();
setTimeout('top.hiddenPageLoadData(true)',10);
}else{
top.failLogin(result);
}
});
}else if(currentMode==TopologyModes.Local){
signInAllEnclosures(user,pass);
}else{
mod.getTopology(function(result){
signInAllEnclosures(user,pass);
},true);
}
};
mod.getProxies=function(includeNonActive){
return enclosures.getProxies(includeNonActive);
};
mod.getSelectedProxies=function(){
return enclosures.getSelectedProxies();
};
mod.getProxy=function(enclosureNumber,uuid,includeNonActive){
if(existsNonNull(uuid)){
return enclosures.getEnclosure(uuid,includeNonActive);
}else{
return getEnclosureByPosition(enclosureNumber,includeNonActive);
}
};
mod.getProxyLocal=function(){
return assertPrimaryEnclosure();
};
mod.getSelectedProxy=function(){
if(selectedEnclosureId==0){
mod.selectPrimaryEnclosure();
}
return getEnclosureByPosition(selectedEnclosureId);
};
mod.getAuthenticatedProxies=function(){
return enclosures.getAuthenticatedProxies();
};
mod.removeProxy=function(uuid){
var hpemInstance=enclosures.getEnclosure(uuid);
if(hpemInstance){
echo("removeProxy called for enclosure "+hpemInstance.getEnclosureNumber(),1,6);
removeEnclosure(uuid);
}else{
echo("Cannot remove enclosure with UUID: "+uuid+" - not found.",1,5);
}
};
mod.getProxyConnected=function(uuid){
var hpemInstance=enclosures.getEnclosure(uuid,true);
if(hpemInstance){
return(hpemInstance.getIsLocal()||hpemInstance.getIsConnected());
}
echo("Connected state cannot be determined: Not found.",8,4,["UUID: "+uuid]);
return false;
};
mod.logoutAndDestroyAll=function(killSession,callback,percentCallback,linkedOnly){
var encCollection=enclosures.getLinkedProxies();
var hpemLocal=assertPrimaryEnclosure();
echo("logoutAndDestroyAll called.",6,3,["killSession: "+killSession,"linkedOnly: "+linkedOnly]);
if(hpemLocal.getIsConnected()==false){
for(var j=0;j<encCollection.length;j++){
encCollection[j].setIsConnected(false);
}
}
if(linkedOnly!=true){
top.getEventManager().stopEventLoop();
top.getTransport().clearCallStacks();
}
var formMgr=new FormManager(function(success){
echo("Batch success in logoutAndDestroyAll: "+success+".",6,1);
if(linkedOnly!=true){
mod.destroyAll();
top.getTransport().notifySessionReset();
}
if(isFunction(callback)){
callback(success);
}
});
if(isFunction(percentCallback)){
formMgr.usePercentMode(percentCallback);
}
echo("Starting logout and destroy batch.",6,1);
formMgr.startTransactionBatch();
for(var i=0;i<encCollection.length;i++){
echo("Destroying linked enclosure "+encCollection[i].getEnclosureNumber(),6,1);
formMgr.queueCall(destroyEnclosure,[encCollection[i],killSession]);
}
if(linkedOnly!=true){
echo("Destroying primary enclosure.",6,4);
formMgr.queueCall(destroyEnclosure,[hpemLocal,killSession]);
}
formMgr.endBatch();
};
mod.destroyAll=function(){
echo("destroyAll called.",6,1);
enclosures.reset();
sessionValidator.reset();
rackTopologyDOM=null;
selectedEnclosureId=0;
stateChangeEvent(TopologyModes.Local);
stateChangeEvent(TopologyModes.DisplayOn);
stateChangeEvent(TopologyStates.None);
stateChangeEvent(LoadStates.None);
};
mod.failOverPrimaryEnclosure=function(resetOnly,mode){
var hpemLocal=assertPrimaryEnclosure();
var msg=top.getString("oatransitionStarted");
mod.logoutAndDestroyAll(true,function(){
top.MX_HIDDEN.displayResetTimer(false,function(){
top.displayHiddenFrame();
if(mode=="STANDBY"){
top.makeGuiActive();
}else{
top.makeGuiStandby();
}
top.getEventManager().stopEventLoop();
if(!(resetOnly)){
hpemLocal.oaManualFailover(function(){});
}
hpemLocal.setIsAuthenticated(false);
},msg);
},null,true);
};
mod.clearCache=function(){
rackTopologyDOM=null;
};
mod.getTopologyDOM=function(){
return rackTopologyDOM;
};
mod.getUuidArray=function(){
return enclosures.getUuids();
};
mod.addFocusChangeListener=function(listener,isMaster){
echo("Adding focus change listener",3,1,[listener.toString()]);
return listeners.addListener(listener,["ENCLOSURE_FOCUS_CHANGED"],isMaster);
};
mod.setLoginSelections=function(selectionElems){
if(isNonZeroInteger(selectionElems.length)){
updateCollectionWithUserSelections(selectionElems);
}else{
echo("No selection objects found, using Local Mode.",1,4);
stateChangeEvent(TopologyModes.Local);
}
};
mod.validateLoadedEnclosures=function(){
var hpems=enclosures.getProxies();
for(var index in hpems){
var thisHpem=hpems[index];
if(thisHpem.getIsLoaded()==true&&thisHpem.getIsMinimumLoad()==true){
thisHpem.stopEvents();
thisHpem.setIsLoaded(false);
}
}
};
mod.getEnclosureCountByProperty=function(methodName,returnValue,hpemArray){
var hpems=(hpemArray?hpemArray:enclosures.getProxies());
var total=0;
for(var index in hpems){
var thisHpem=hpems[index];
if(isFunction(thisHpem[methodName])){
if(thisHpem[methodName]()==returnValue){
total++;
}
}
}
return total;
};
mod.getMaxEnclosures=function(){
return getMaxEnclosureCount();
};
mod.getMaxEnclosureList=function(){
var encCount=getMaxEnclosureCount();
if(encCount==enclosureLayoutCount&&enclosureLayoutDOM!=null){
echo("Returning cached enclosure layout document.",3,2);
return enclosureLayoutDOM;
}else{
echo("Creating new enclosure layout document.",1,4);
enclosureLayoutCount=encCount;
}
domBuilder.addDocument("enclosures");
for(var i=1;i<=encCount;i++){
domBuilder.appendChild("enclosure",["number",i]);
}
return(enclosureLayoutDOM=domBuilder.getDocument());
};
mod.getMaxConnectionsExceeded=function(){
return(rackTopologyDOM==null?"":getElementValueXpath(rackTopologyDOM,"//hpoa:extraData[@hpoa:name='maxConnectionsExceeded']"));
};
mod.getDisplayMode=function(){
return currentDisplayMode;
};
mod.setTopologyMode=function(newMode){
stateChangeEvent(newMode);
};
mod.setTopologyRunState=function(newState){
stateChangeEvent(newState);
};
mod.setLoadState=function(newState){
stateChangeEvent(newState);
};
mod.resetAlertState=function(){
stateChangeEvent(AlertStates.None);
};
mod.registerForTopologyChangeEvent=function(listener,interval){
if(exists(interval)&&!isNaN(interval)){
pollInterval=(interval>=MIN_INTERVAL?interval:MIN_INTERVAL);
}
stateChangeEvent(PollStates.Started);
return listeners.addListener(listener,["TOPOLOGY_CHANGE_EVENT"]);
};
mod.deregisterForTopologyChangeEvent=function(listener,forceOff){
listeners.removeListener(listener);
if(!listeners.eventTypeExists("TOPOLOGY_CHANGE_EVENT")||forceOff==true){
stateChangeEvent(PollStates.Stopped);
pollInterval=MIN_INTERVAL;
}
};
mod.registerDisplayFrame=function(frame){
if(frame.name){
displayFrames[frame.name]=frame;
mod.broadcastPrimaryFipsState();
}
};
mod.unregisterDisplayFrame=function(frame){
if(frame.name){
delete displayFrames[frame.name];
}
};
mod.broadcastPrimaryFipsState=function(){
var hpemLocal=assertPrimaryEnclosure();
var primaryFipsEnabled=hpemLocal.getProperty("FipsEnabled");
var primaryFipsMode=hpemLocal.getProperty("FipsMode");
var primaryFipsStatus=hpemLocal.getProperty("FipsStatus");
var primaryFipsStatusEnable=hpemLocal.getProperty("FipsStatusEnabled");
for(var name in displayFrames){
if(isFunction(displayFrames[name].setIconVisible))
{
displayFrames[name].setIconVisible(primaryFipsMode,primaryFipsEnabled);
displayFrames[name].setIconVisible(primaryFipsStatus,primaryFipsStatusEnable);
}
}
}
mod.addTopologyPendingListener=function(listener,isMaster){
echo("Adding topology pending listener.",3,1,[listener.toString()]);
return listeners.addListener(listener,["TOPOLOGY_CHANGE_PENDING"],isMaster);
};
mod.addTopologyCompleteListener=function(listener,isMaster){
echo("Adding topology complete listener.",3,1,[listener.toString()]);
return listeners.addListener(listener,["TOPOLOGY_CHANGE_COMPLETE"],isMaster);
};
mod.addTopologyEventListener=function(listener,isMaster){
echo("Adding topology event listener.",3,1,[listener.toString()]);
return listeners.addListener(listener,["TOPOLOGY_EVENT"],isMaster);
};
mod.removeListener=function(listener){
echo("Removing topology listener.",3,1,[listener.toString()]);
return listeners.removeListener(listener);
};
mod.setSelectedEnclosureNumber=function(enclosureNumber){
if(selectedEnclosureId!=enclosureNumber){
var encNum=parseInt(enclosureNumber);
if(!isNaN(encNum)&&encNum>0){
selectedEnclosureId=encNum;
var hpems=enclosures.getProxies();
for(var index in hpems){
hpems[index].setHasFocus((hpems[index].getEnclosureNumber()==selectedEnclosureId));
}
updateEventThrottle();
listeners.callListeners("ENCLOSURE_FOCUS_CHANGED",selectedEnclosureId);
}else{
echo("Cannot set the selected enclosure number to: "+enclosureNumber,1,6);
}
}
};
mod.getSelectedEnclosureNumber=function(){
return selectedEnclosureId;
};
mod.selectPrimaryEnclosure=function(){
mod.setSelectedEnclosureNumber(assertPrimaryEnclosure().getEnclosureNumber());
};
mod.init();
});
