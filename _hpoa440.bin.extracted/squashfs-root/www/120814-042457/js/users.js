/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var uInfo=null;
var gInfo=null;
var currentOaAccess;
var currentSvbPermissions;
var currentSwmPermissions;
var addUserResults=new Object();
var addGroupResults=new Object();
function initUserOverview(editUserFunction,newUserFunction,deleteUserFunction){
var overviewTable=document.getElementById('secObjOverviewTable');
if(overviewTable){
var inputCollection=overviewTable.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
if(inputCollection[i].getAttribute('rowselector')=='no'){
inputCollection[i].onclick=userSelected;
var tableRow=inputCollection[i].parentNode.parentNode;
var tableCells=tableRow.getElementsByTagName('td');
for(var j=0;j<tableCells.length;j++){
tableCells[j].onclick=null;
}
}
}
}
updateButtonClickHandlers(['editSecObjButton','editSecObjButton1'],editUserFunction);
updateButtonClickHandlers(['newSecObjButton','newSecObjButton1'],newUserFunction);
updateButtonClickHandlers(['deleteSecObjButton','deleteSecObjButton1'],deleteUserFunction);
userSelected();
}
function updateButtonClickHandlers(buttonIdArray,clickHandler){
for(var i=0;i<buttonIdArray.length;i++){
var thisButton=document.getElementById(buttonIdArray[i]);
if(thisButton){
thisButton.onclick=clickHandler;
}
}
}
function userSelected(){
var checkedCount=0;
var overviewTable=document.getElementById('secObjOverviewTable');
if(overviewTable){
var inputCollection=overviewTable.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
if(inputCollection[i].checked){
checkedCount++;
}
}
if(checkedCount==0){
ourButtonManager.disableButtonById('editSecObjButton');
ourButtonManager.disableButtonById('deleteSecObjButton');
if(document.getElementById('editSecObjButton1')&&document.getElementById('deleteSecObjButton1')){
ourButtonManager.disableButtonById('editSecObjButton1');
ourButtonManager.disableButtonById('deleteSecObjButton1');
}
}else if(checkedCount==1){
var adminChecked=false;
ourButtonManager.enableButtonById('editSecObjButton');
if(document.getElementById('editSecObjButton1')){
ourButtonManager.enableButtonById('editSecObjButton1');
}
if(getSelectedSecObjects()[0]!=null&&getSelectedSecObjects()[0]=='Administrator'){
ourButtonManager.disableButtonById('deleteSecObjButton');
if(document.getElementById('deleteSecObjButton1')){
ourButtonManager.disableButtonById('deleteSecObjButton1')
}
}else{
ourButtonManager.enableButtonById('deleteSecObjButton');
if(document.getElementById('deleteSecObjButton1')){
ourButtonManager.enableButtonById('deleteSecObjButton1');
}
}
}
else if(checkedCount>1){
ourButtonManager.enableButtonById('deleteSecObjButton');
ourButtonManager.disableButtonById('editSecObjButton');
if(document.getElementById('editSecObjButton1')&&document.getElementById('deleteSecObjButton1')){
ourButtonManager.disableButtonById('editSecObjButton1');
ourButtonManager.enableButtonById('deleteSecObjButton1');
}
}
}else{
}
}
function getSelectedSecObjects(){
var selectedObjects=new Array();
var userOverviewTable=document.getElementById('secObjOverviewTable');
if(userOverviewTable){
inputCollection=userOverviewTable.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
if(inputCollection[i].checked){
var secObjId=inputCollection[i].getAttribute('secObjId');
selectedObjects.push(secObjId);
}
}
}
return selectedObjects;
}
function loadCurrentSettings(encNum){
try{
currentSvbPermissions=getSvbSelection(encNum);
currentSwmPermissions=getSwmSelection(encNum);
currentOaAccess=document.getElementById('userOaAccess').checked;
}catch(e){}
}
function getSvbSelection(encNum){
return getSelection('svbSelectEnc'+encNum);
}
function getSwmSelection(encNum){
return getSelection('swmSelectEnc'+encNum);
}
function disableInputs(selectContainerId,bool){
var selectContainer=document.getElementById(selectContainerId);
var selections=null;
if(selectContainer){
selections=new Array();
var inputCollection=selectContainer.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var currentInput=inputCollection[i];
if(currentInput.getAttribute('type')=='checkbox'&&currentInput.getAttribute('bayId')){
currentInput.disabled=bool;
}
}
}
}
function getSelection(baySelectContainerId){
var baySelectContainer=document.getElementById(baySelectContainerId);
var selections=null;
if(baySelectContainer){
selections=new Array();
var inputCollection=baySelectContainer.getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
var currentInput=inputCollection[i];
if(currentInput.getAttribute('type')=='checkbox'&&currentInput.getAttribute('bayId')){
var bayNum=currentInput.getAttribute('bayId');
selections[bayNum]=currentInput.checked;
}
}
}
return selections;
}
function getPermissionDOM(oaAccess,svbPermissions,swmPermissions){
var xml=importModule('xml');
var bayPermissions=xml.parseXML('<hpoa:bays xmlns:hpoa="hpoa.xsd" />');
var oaAccessElement=bayPermissions.createElement('hpoa:oaAccess');
var oaAccessValue=bayPermissions.createTextNode(''+oaAccess);
oaAccessElement.appendChild(oaAccessValue);
bayPermissions.documentElement.appendChild(oaAccessElement);
var bladeBaysElement=bayPermissions.createElement('hpoa:bladeBays');
for(var i=0;i<svbPermissions.length;i++){
if(svbPermissions[i]!=null){
var bladeDoc=xml.parseXML('<hpoa:blade xmlns:hpoa="hpoa.xsd" />');
var bayNumElement=bladeDoc.createElement('hpoa:bayNumber');
var bayNumValue=bladeDoc.createTextNode(''+i);
bayNumElement.appendChild(bayNumValue);
var bayAccessElement=bladeDoc.createElement('hpoa:access');
var bayAccessValue=bladeDoc.createTextNode(''+svbPermissions[i]);
bayAccessElement.appendChild(bayAccessValue);
bladeDoc.documentElement.appendChild(bayNumElement);
bladeDoc.documentElement.appendChild(bayAccessElement);
bladeBaysElement.appendChild(bladeDoc.documentElement.cloneNode(true));
}
}
var swmBaysElement=bayPermissions.createElement('hpoa:interconnectTrayBays');
for(var i=0;i<swmPermissions.length;i++){
if(swmPermissions[i]!=null){
var swmDoc=xml.parseXML('<hpoa:interconnectTray xmlns:hpoa="hpoa.xsd" />');
var bayNumElement=swmDoc.createElement('hpoa:bayNumber');
var bayNumValue=swmDoc.createTextNode(''+i);
bayNumElement.appendChild(bayNumValue);
var bayAccessElement=swmDoc.createElement('hpoa:access');
var bayAccessValue=swmDoc.createTextNode(''+swmPermissions[i]);
bayAccessElement.appendChild(bayAccessValue);
swmDoc.documentElement.appendChild(bayNumElement);
swmDoc.documentElement.appendChild(bayAccessElement);
swmBaysElement.appendChild(swmDoc.documentElement.cloneNode(true));
}
}
bayPermissions.documentElement.appendChild(bladeBaysElement);
bayPermissions.documentElement.appendChild(swmBaysElement);
return bayPermissions.documentElement.cloneNode(true);
}
function getUserInfo(encNum,fresh){
userInfo=new Object();
try{
var usernameContainer=document.getElementById('username');
if(typeof(usernameContainer.value)!='undefined'){
userInfo['username']=usernameContainer.value;
}else if(typeof(usernameContainer.innerHTML)!='undefined'){
userInfo['username']=usernameContainer.innerHTML;
}
userInfo['password']=document.getElementById('password').value;
userInfo['fullName']=document.getElementById('fullName').value;
userInfo['contact']=document.getElementById('contact').value;
var userBayAclMenu=document.getElementById('userBayAcl');
if(userBayAclMenu!=null){
userInfo['userBayAcl']=userBayAclMenu.options[userBayAclMenu.selectedIndex].value;
}else{
userInfo['userBayAcl']=null;
}
var userEnabledCheckbox=document.getElementById('chkUserEnabled');
if(userEnabledCheckbox!=null){
userInfo['userEnabled']=userEnabledCheckbox.checked;
}else{
userInfo['userEnabled']=null;
}
if(document.getElementById('linkHasMixed')){
var svbBool=document.getElementById('1 Bay Select').checked;
var swmBool=document.getElementById('1 IO Select').checked;
var oaBool=document.getElementById('userOaAccess').checked;
userInfo['permissionsToAdd']=getPermissionsAll(oaBool,svbBool,swmBool);
userInfo['permissionsToRemove']=getPermissionsAll(!oaBool,!svbBool,!swmBool);
}else{
userInfo['permissionsToAdd']=getAddPermissions(encNum,fresh);
userInfo['permissionsToRemove']=getRemovePermissions(encNum,fresh);
}
}catch(e){}
return userInfo;
}
function getGroupInfo(encNum,fresh){
groupInfo=new Object();
try{
var groupNameContainer=document.getElementById('groupName');
if(typeof(groupNameContainer.value)!='undefined'){
groupInfo['groupName']=groupNameContainer.value;
}else if(typeof(groupNameContainer.innerHTML)!='undefined'){
groupInfo['groupName']=(groupNameContainer.innerText?groupNameContainer.innerText:groupNameContainer.textContent);
}
groupInfo['description']=document.getElementById('description').value;
groupInfo['groupBayAcl']=document.getElementById('userBayAcl').options[document.getElementById('userBayAcl').selectedIndex].value;
if(document.getElementById('linkHasMixed')){
var svbBool=document.getElementById('1 Bay Select').checked;
var swmBool=document.getElementById('1 IO Select').checked;
var oaBool=document.getElementById('userOaAccess').checked;
groupInfo['permissionsToAdd']=getPermissionsAll(oaBool,svbBool,swmBool);
groupInfo['permissionsToRemove']=getPermissionsAll(!oaBool,!svbBool,!swmBool);
}else{
groupInfo['permissionsToAdd']=getAddPermissions(encNum,fresh);
groupInfo['permissionsToRemove']=getRemovePermissions(encNum,fresh);
}
}
catch(e){
}
return groupInfo;
}
function getAddPermissions(encNum,fresh){
var newSvbPermissions=getSvbSelection(encNum);
var newSwmPermissions=getSwmSelection(encNum);
var addSvbPermissions=new Array();
var addSwmPermissions=new Array();
var addOaPermission;
for(var i=0;i<currentSvbPermissions.length;i++){
if(newSvbPermissions[i]==null){
continue;
}
if(currentSvbPermissions[i]!=null){
if(fresh){
addSvbPermissions[i]=newSvbPermissions[i];
}else{
if(!currentSvbPermissions[i]&&newSvbPermissions[i]){
addSvbPermissions[i]=true;
}else{
addSvbPermissions[i]=false;
}
}
}
}
for(var i=0;i<currentSwmPermissions.length;i++){
if(newSwmPermissions[i]==null){
continue;
}
if(currentSwmPermissions[i]!=null){
if(fresh){
addSwmPermissions[i]=newSwmPermissions[i];
}else{
if(!currentSwmPermissions[i]&&newSwmPermissions[i]){
addSwmPermissions[i]=true;
}else{
addSwmPermissions[i]=false;
}
}
}
}
var newOaAccess=document.getElementById('userOaAccess').checked;
if(fresh){
addOaPermission=newOaAccess;
}else{
if(!currentOaAccess&&newOaAccess){
addOaPermission=true;
}else{
addOaPermission=false;
}
}
return getPermissionDOM(addOaPermission,addSvbPermissions,addSwmPermissions);
}
function getPermissionsAll(oaPermission,svbPermission,swmPermission){
var svbPermissions=new Array();
var swmPermissions=new Array();
for(var i=0;i<=EM_MAX_BLADE_ARRAY();i++){
svbPermissions.push(svbPermission);
}
for(var i=0;i<=EM_MAX_SWITCHES_C7000();i++){
swmPermissions.push(swmPermission);
}
return getPermissionDOM(oaPermission,svbPermissions,swmPermissions);
}
function getRemovePermissions(encNum,fresh){
var newSvbPermissions=getSvbSelection(encNum);
var newSwmPermissions=getSwmSelection(encNum);
var remSvbPermissions=new Array();
var remSwmPermissions=new Array();
var remOaPermission;
for(var i=0;i<currentSvbPermissions.length;i++){
if(newSvbPermissions[i]==null){
continue;
}
if(currentSvbPermissions[i]!=null){
if(fresh){
remSvbPermissions[i]=!newSvbPermissions[i];
}else{
if(currentSvbPermissions[i]&&!newSvbPermissions[i]){
remSvbPermissions[i]=true;
}else{
remSvbPermissions[i]=false;
}
}
}
}
for(var i=0;i<currentSwmPermissions.length;i++){
if(newSwmPermissions[i]==null){
continue;
}
if(currentSwmPermissions[i]!=null){
if(fresh){
remSwmPermissions[i]=!newSwmPermissions[i];
}else{
if(currentSwmPermissions[i]&&!newSwmPermissions[i]){
remSwmPermissions[i]=true;
}else{
remSwmPermissions[i]=false;
}
}
}
}
var newOaAccess=document.getElementById('userOaAccess').checked;
if(fresh){
remOaPermission=!newOaAccess;
}else{
if(currentOaAccess&&!newOaAccess){
remOaPermission=true;
}else{
remOaPermission=false;
}
}
return getPermissionDOM(remOaPermission,remSvbPermissions,remSwmPermissions);
}
function setUserAcl(encNum,aclValue){
if(aclValue!=null){
var enableInputs=true;
if(aclValue=='ADMINISTRATOR'){
var oaAccess=document.getElementById('userOaAccess').checked;
if(oaAccess){
var serverChkBox=document.getElementById(''+encNum+' Bay Select');
if(!serverChkBox.checked){
serverChkBox.checked=true;
checkboxToggle(serverChkBox,'devid','bay','svbSelectEnc'+encNum);
}
serverChkBox.disabled=true;
var ioChkBox=document.getElementById(''+encNum+' IO Select');
if(!ioChkBox.checked){
ioChkBox.checked=true;
checkboxToggle(ioChkBox,'devid','interconnect','swmSelectEnc'+encNum)
}
ioChkBox.disabled=true;
disableInputs('svbSelectEnc'+encNum,true);
disableInputs('swmSelectEnc'+encNum,true);
enableInputs=false;
}
}
if(enableInputs){
document.getElementById(''+encNum+' Bay Select').disabled=false;
document.getElementById(''+encNum+' IO Select').disabled=false;
disableInputs('svbSelectEnc'+encNum,false);
disableInputs('swmSelectEnc'+encNum,false);
}
}
}
function oaToggle(encNum,checked){
var userBayAclMenu=document.getElementById('userBayAcl');
if(userBayAclMenu!=null){
setUserAcl(encNum,userBayAclMenu.options[userBayAclMenu.selectedIndex].value);
}
}
