/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var ourButtonManager=null;
var ourTransferBoxManager=null;
var ourDropdownMenuManager=null;
var ourNavigationControlManager=null;
var ourTabManager=null;
var ourTableManager=null;
var ourTreeManager=null;
var ourTreeTableManager=null;
var mouseX=0;
var mouseY=0;
globalManagerCreate();
try{
if(top.getAlertManager){
window.alert=top.getAlertManager().alert;
}
}
catch(e){}
if(!document.all){
try{
document.createElement('a');
HTMLElement.prototype.click=function(){
if(typeof this.onclick=='function'){
if(this.onclick({type:'click'})&&this.href)
window.open(this.href,this.target?this.target:'_self');
}
else if(this.href)
window.open(this.href,this.target?this.target:'_self');
}
}
catch(e){
window.status='Warning: your browser is unable to attach click methods to all elements.';
}
}
function mouseIsOverAbsElement(obj){
if((mouseX<obj.offsetLeft)||(mouseX>obj.offsetLeft+obj.offsetWidth))return false;
else if((mouseY<obj.offsetTop)||(mouseY>obj.offsetTop+obj.offsetHeight))return false;
else return true;
}
function mouseTracker(e){
if(typeof(top.trackSessionByMouse)!='undefined'){
try{
top.trackSessionByMouse(e);
}catch(err){}
}
}
if(typeof(top.trackSessionByMouse)!='undefined'){
if(document.attachEvent){
document.attachEvent('onmousedown',mouseTracker);
}else{
document.onmousedown=mouseTracker;
}
}
function preventEventBubble(evt){
if(!evt){evt=window.event;}
if(evt.stopPropagation){
evt.stopPropagation();
}else{
evt.cancelBubble=true;
}
if(evt.preventDefault){
evt.preventDefault();
}else{
evt.returnValue=false;
}
}
function globalManagerCreate(){
if(typeof(ButtonManager)!="undefined"&&ourButtonManager==null){
ourButtonManager=new ButtonManager();
}
if(typeof(TransferBoxManager)!="undefined"&&ourTransferBoxManager==null){
ourTransferBoxManager=new TransferBoxManager();
}
if(typeof(DropdownMenuManager)!="undefined"&&ourDropdownMenuManager==null){
ourDropdownMenuManager=new DropdownMenuManager();
}
if(typeof(NavigationControlManager)!="undefined"&&ourNavigationControlManager==null){
ourNavigationControlManager=new NavigationControlManager();
}
if(typeof(TabManager)!="undefined"&&ourTabManager==null){
ourTabManager=new TabManager();
}
if(typeof(TableManager)!="undefined"&&ourTableManager==null){
ourTableManager=new TableManager();
}
if(typeof(TreeManager)!="undefined"&&ourTreeManager==null){
ourTreeManager=new TreeManager();
}
if(typeof(TreeTableManager)!="undefined"&&ourTreeTableManager==null){
ourTreeTableManager=new TreeTableManager();
}
}
function globalComponentInit(){
if(typeof(ButtonManager)!="undefined"){
ourButtonManager.init();
}
if(typeof(TransferBoxManager)!="undefined"){
ourTransferBoxManager.init();
}
if(typeof(DropdownMenuManager)!="undefined"){
ourDropdownMenuManager.init();
}
if(typeof(NavigationControlManager)!="undefined"){
ourNavigationControlManager.init();
}
if(typeof(TabManager)!="undefined"&&ourTabManager!=null){
ourTabManager.init();
}
if(typeof(TableManager)!="undefined"){
ourTableManager.init();
tableManager_windowResize();
}
if(typeof(TreeManager)!="undefined"){
ourTreeManager.init();
}
if(typeof(TreeTableManager)!="undefined"){
ourTreeTableManager.init();
}
}
function dF(foo){
document.debugform.debugtext.value+=foo+"\n";
}
function getEventOriginator(mozEvent){
return(document.all)?event.srcElement:mozEvent.target;
}
function reconcileEventHandlers(){
if(window.onload){
var applicationLevelOnload=window.onload;
window.onload=function(){globalComponentInit();applicationLevelOnload()};
}
else{
window.onload=globalComponentInit;
}
}
function appendClassName(obj,newClassName){
if(obj.className.indexOf(newClassName)!=-1)return true;
if(!obj.className)obj.className=newClassName;
else obj.className=obj.className+" "+newClassName;
}
function removeClassName(obj,classNameToRemove){
var newClassName=obj.className.replace(" "+classNameToRemove,"");
newClassName=newClassName.replace(classNameToRemove+" ","");
if(obj.className.length==newClassName.length){
newClassName=newClassName.replace(classNameToRemove,"");
}
obj.className=newClassName;
}
function MxGetFirstTag(e,szTag)
{
e=e.getElementsByTagName(szTag);
if(e!=null&&e.length>0)
return e.item(0);
return null;
}
function checkboxToggle(masterCheckBox,attribute,attributeValue,sourceId,executeOnclick){
var checkBoxCollection=null;
if(typeof(executeOnclick)=='undefined'){
var executeOnclick=false;
}
if(!sourceId){
checkBoxCollection=document.getElementsByTagName('input');
}else{
var source=document.getElementById(sourceId);
if(source){
checkBoxCollection=source.getElementsByTagName('input');
}
}
if(checkBoxCollection!=null){
try{
for(var i=0;i<checkBoxCollection.length;i++){
if(checkBoxCollection[i].getAttribute('type')=='checkbox'&&checkBoxCollection[i]!=masterCheckBox){
if(checkBoxCollection[i].getAttribute(attribute)==attributeValue){
checkBoxCollection[i].checked=masterCheckBox.checked;
if(executeOnclick){
try{
checkBoxCollection[i].onclick();
}
catch(e){
}
}
}
}
}
}catch(e){}
}
}
function containerCheckboxToggle(containerId,state){
if(containerId!=''){
var inputCollection=document.getElementById(containerId).getElementsByTagName('input');
for(var i=0;i<inputCollection.length;i++){
try{inputCollection[i].checked=state;}catch(e){}
}
}
}
function toggleCheckboxesEnabledById(id,state){
var inputs=document.getElementsByTagName("input");
for(var i=0;i<inputs.length;i++){
var input=inputs[i];
if(input.getAttribute("type")=="checkbox"){
if(input.id&&input.id.indexOf(id)>-1){
if(state){
input.disabled=false;
}else{
input.checked=false;
input.disabled=true;
}
}
}
}
}
function updateCheckboxTableButtons(inputs,buttonNames){
var totalChecked=0;
for(var i=0;i<inputs.length;i++){
if(inputs[i].type=="checkbox"&&inputs[i].checked){
totalChecked++;
}
}
for(var n=0;n<buttonNames.length;n++){
toggleButtonEnabled(buttonNames[n],(totalChecked>0));
}
}
function toggleButtonEnabled(id,enabled){
if(typeof(ourButtonManager)!="undefined"){
if(enabled==true){
ourButtonManager.enableButtonById(id);
}else{
ourButtonManager.disableButtonById(id);
}
}
}
function toggleButtonsEnabled(argsArray){
if(isArray(argsArray)&&argsArray.length>0&&argsArray.length%2==0){
for(var i=0;i<argsArray.length-1;i+=2){
toggleButtonEnabled(argsArray[i],argsArray[i+1]);
}
}
}
function toggleFormEnabled(containerId,state,inputTypes){
if(typeof(inputTypes)=='undefined'){
var inputTypes=[
'text',
'checkbox',
'radio',
'button',
'submit',
'reset',
'file',
'password',
];
}
var container=document.getElementById(containerId);
if(container){
var inputCollection=container.getElementsByTagName('input');
var spanCollection=container.getElementsByTagName('span');
for(var i=0;i<inputCollection.length;i++){
var input=inputCollection[i];
var inputType=input.getAttribute('type');
var permDisable=input.getAttribute('perm-disable');
var permEnable=input.getAttribute('perm-enable');
for(var j=0;j<inputTypes.length;j++){
if(inputType==inputTypes[j]){
if(!state&&!permEnable){
input.setAttribute('disabled','true');
if(input.getAttribute('type')=='text'||input.getAttribute('type')=='password'){
input.className='stdInputDisabled';
}
}
else{
if(permDisable!='true'){
input.removeAttribute('disabled');
if(input.getAttribute('type')=='text'||input.getAttribute('type')=='password'){
input.className='stdInput';
}
}
}
}
}
}
var selectCollection=container.getElementsByTagName('select');
for(var i=0;i<selectCollection.length;i++){
if(!state){
selectCollection[i].setAttribute('disabled','true');
}
else{
selectCollection[i].removeAttribute('disabled');
}
}
}
}
function toggleElementVisible(id,state){
try{
var element=document.getElementById(id);
if(element){
element.style['display']=(state)?'block':'none';
}
}
catch(e){}
}
function getHPButton(id,caption,clickHandler,emphasized){
var buttonWrapper=document.createElement('div');
buttonWrapper.className='bWrapperUp';
if(emphasized){
buttonWrapper.className+=' bEmphasized';
}
var innerWrapper1=document.createElement('div');
var innerWrapper2=document.createElement('div');
var button=document.createElement('button');
button.className='hpButton';
button.id=id;
button.nodeValue=caption;
button.onclick=clickHandler;
var buttonText=document.createTextNode(caption);
button.appendChild(buttonText);
innerWrapper2.appendChild(button);
innerWrapper1.appendChild(innerWrapper2);
buttonWrapper.appendChild(innerWrapper1);
return buttonWrapper;
}
function addListener(elem,eventName,eventHandler){
try{
if(window.attachEvent){
elem.attachEvent('on'+eventName,eventHandler);
}else if(window.addEventListener){
elem.addEventListener(eventName,eventHandler,false);
}
}catch(e){
top.logEvent("Global: "+e.message,null,1,5);
}
}
function removeListener(elem,eventName,eventHandler){
try{
if(window.detachEvent){
elem.detachEvent('on'+eventName,eventHandler);
}else if(window.removeEventListener){
elem.removeEventListener(eventName,eventHandler,false);
}
}catch(e){
top.logEvent("Global: "+e.message,null,1,5);
}
}
function getDocumentCoords(elem){
var page=new Object();
page.width=0;
page.height=0;
page.left=0;
page.right=0;
page.top=0;
page.bottom=0;
page.scrollX=0;
page.scrollY=0;
if(elem){
if(elem.ownerDocument.defaultView){
page.width=elem.ownerDocument.defaultView.innerWidth;
page.height=elem.ownerDocument.defaultView.innerHeight;
var widthAdj=2;
var heightAdj=2;
if(elem.ownerDocument.documentElement.offsetHeight>page.height){
widthAdj+=20;
}
if(elem.ownerDocument.documentElement.offsetWidth>page.width){
heightAdj+=20;
}
page.width-=widthAdj;
page.height-=heightAdj;
page.scrollX=elem.ownerDocument.defaultView.scrollX;
page.scrollY=elem.ownerDocument.defaultView.scrollY;
}else if(elem.document.documentElement&&elem.document.documentElement.clientWidth>0){
page.width=elem.document.documentElement.clientWidth;
page.height=elem.document.documentElement.clientHeight;
page.scrollX=elem.document.body.scrollLeft+elem.document.documentElement.scrollLeft;
page.scrollY=elem.document.body.scrollTop+elem.document.documentElement.scrollTop;
}else if(elem.document.body){
page.width=document.body.clientWidth;
page.height=document.body.clientHeight;
page.scrollX=document.body.scrollLeft;
page.scrollY=document.body.scrollTop;
}
page.left=page.scrollX;
page.right=page.width+page.scrollX;
page.top=page.scrollY;
page.bottom=page.height+page.scrollY;
}
return page;
}
function lookupKeyValue(searchString,key){
var value='';
if(searchString.indexOf(key+'=')>-1){
value=searchString.substring(searchString.indexOf(key+'=')+key.length+1);
if(value.indexOf('&')>-1){
value=value.substring(0,value.indexOf('&'));
}
if(value.indexOf("'")>-1){
value=value.substring(0,value.indexOf("'"));
}
if(value.indexOf('"')>-1){
value=value.substring(0,value.indexOf('"'));
}
if(value.indexOf(';')>-1){
value=value.substring(0,value.indexOf(';'));
}
value=unescape(value);
}
return value;
}
function getSearchValue(searchString,key){
return lookupKeyValue(searchString,key);
}
function getCookieValue(key){
return lookupKeyValue(document.cookie,key);
}
function getUserPreference(prefName){
return getCookieValueField(USER_PREFERENCES_COOKIE_NAME(),prefName);
}
function setUserPreference(prefName,prefValue){
return setCookieValueField(USER_PREFERENCES_COOKIE_NAME(),prefName,prefValue);
}
function getCookieValueField(cookieName,fieldName){
var cookieValue=unescape(getCookieValue(cookieName));
var nameValuePairs=new Array();
nameValuePairs=cookieValue.split('&');
for(var i=0;i<nameValuePairs.length;i++){
var nextPair=new Array();
nextPair=nameValuePairs[i].split('=');
if(nextPair[0]==fieldName){
return nextPair[1];
}
}
return null;
}
function setCookieValueField(cookieName,fieldName,fieldValue){
var value=getCookieValueField(cookieName,fieldName);
var cookieValue=unescape(getCookieValue(cookieName));
var newCookieValue="";
if(existsNonNull(value)){
if(fieldValue==value)return;
var nameValuePairs=new Array();
nameValuePairs=cookieValue.split('&');
for(var i=0;i<nameValuePairs.length;i++){
var nextPair=new Array();
nextPair=nameValuePairs[i].split('=');
if(typeof(nextPair[1])!='undefined'){
if(nextPair[0]==fieldName){
nextPair[1]=fieldValue;
}
newCookieValue+='&'+nextPair[0]+'='+nextPair[1];
}
}
}else{
if(isValidString(cookieValue)){
newCookieValue+=cookieValue+'&';
}
newCookieValue+=fieldName+'='+fieldValue;
}
var expires=new Date();
expires.setMonth(new Date().getYear()+100);
setCookieValue(cookieName,escape(newCookieValue),expires);
}
function cookiesEnabled(){
document.cookie="CookieSupport=test;";
return(document.cookie.indexOf("CookieSupport=test")>-1);
};
function setCookieValue(cookieName,cookieValue,expires,path,secure){
var before=document.cookie;
if(typeof(expires)=='undefined'){
var expires='';
}
if(typeof(path)=='undefined'){
var path='';
}
var cookieString=cookieName+'='+cookieValue+';';
if(expires!=null&&expires!=''){
cookieString+='expires='+expires+';';
}
if(path!=null&&path!=''){
cookieString+='path='+path+';';
}else{
cookieString+='path=/;';
}
if(secure!=false&&(window.location.protocol.indexOf('https')>-1)){
cookieString+="secure;"
}
document.cookie=cookieString;
top.logEvent(["Global: setCookieValue called for "+cookieName,"Value: "+cookieValue,"Expires: "+expires,"Path: "+path,"Before: "+before,"After: "+document.cookie],null,1,3);
}
function deleteCookieValue(cookieName,path){
var before=document.cookie;
document.cookie=cookieName+'=; path='+(path?path:'/')+'; expires=-1';
top.logEvent(["Global: deleteCookieValue called for "+cookieName+" (expires set to -1).","Before: "+before,"After: "+document.cookie],null,1,3);
}
function reconcilePage(){
try{globalComponentInit();}catch(e){}
try{
if(typeof(top.getString)=='function'){
window.status=top.getString("done");
}
}catch(e1){}
}
function isValidIPAddress(address){
var addressValid=true;
var ipPattern=/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
var ipArray=address.match(ipPattern);
if(ipArray==null){
addressValid=false;
}
else{
if(ipArray.length==5){
if(ipArray[0]!='255.255.255.255'&&ipArray[0]!='0.0.0.0'){
for(var i=1;i<ipArray.length;i++){
try{
if(parseInt(ipArray[i])>255){
addressValid=false;
break;
}
}
catch(e){
addressValid=false;
}
}
}
else{
addressValid=false;
}
}
else{
addressValid=false;
}
}
return addressValid;
}
function isValidDNSName(host){
var dnsNameValid=false;
if(host.match(/^[a-zA-Z0-9\-\.:]*$/)){
dnsNameValid=true;
}
return dnsNameValid;
}
function displayContentFailed(containerId,errorsArray,severity){
var para=top.getString('pageContentFailed');
var errorsExist=(errorsArray&&errorsArray.length>0);
if(errorsExist){
var key=(errorsArray.length>1?'errorsReported:':'errorReported:');
para+=" "+top.getString(key);
if(errorsArray[0]==top.getString("noOnboardAdmin")){
top.getTopology().clearCache();
top.getTopology().updateTopology();
return;
}
}
if(typeof(containerId)=='undefined'||containerId==null){
var containerId='bodyContent';
}
var contentContainer=document.getElementById(containerId);
if(contentContainer){
var iconSrc="";
var divClass="";
switch(severity){
case AlertMsgTypes.Information:
iconSrc='/120814-042457/images/status_informational_32.gif';
break;
case AlertMsgTypes.Normal:
iconSrc='/120814-042457/images/status_normal_32.gif';
break;
case AlertMsgTypes.Critical:
iconSrc='/120814-042457/images/status_critical_32.gif';
divClass='errorDisplay';
break;
case AlertMsgTypes.Warning:
default:
iconSrc='/120814-042457/images/status_minor_32.gif';
divClass='errorDisplay';
}
var output="<table cellpadding='0' cellspacing='0' border='0'><tr>"+
"<td><img border='0' src='"+iconSrc+"'/></td>"+
"<td style='padding-left:10px;'>"+para+"</td></tr>";
if(errorsExist){
output+="<tr><td>&nbsp;</td>"+
"<td style='padding-left:10px;'>"+
"<div class='"+divClass+"' style='display:block;'><ul>";
for(var i=0;i<errorsArray.length;i++){
output+="<li>"+errorsArray[i]+"</li>";
}
output+="</ul></td></tr></table>";
var linkText=top.getString("here");
var helpTip=top.getString("clickToReload");
var clickHandler='window.location.reload();';
if(typeof(getCurrentTab)!='undefined'&&typeof(setTabContent)!='undefined'){
clickHandler="try{setTabContent(getCurrentTab());}catch(e){window.location.reload();}";
}
var regexp=new RegExp("{%1}","g");
helpTip=helpTip.replace(regexp,"<a href='javascript:void(0);' "+
"onclick='"+clickHandler+"'>"+linkText+"</a>");
output+="<br /><hr /><div>"+helpTip+"</div>"
}else{
output+="</table>";
}
try{
contentContainer.innerHTML=output;
}catch(e){
contentContainer.innerHTML='';
}
}
}
function getAnimatedTimerHTML(text){
return "<img src='/120814-042457/images/icon_status_working.gif' style='width:13px;height:13px;vertical-align:middle' alt='' />&#160<em style='vertical-align:middle;'>"+text+"</em>";
}
function getContainerID(){
var isWizard=top.getTopology().getProxyLocal().getIsWizardSelected();
return(isWizard?'stepInnerContent':document.getElementById('tabContent')?'tabContent':'bodyContent');
}
function getElementValue(nodeSet,elementName,elementNS){
var elementValue='';
if(typeof(elementNS)=='undefined'){
var elementNS='';
}
else{
elementNS=elementNS+":"
}
try{
if(typeof(nodeSet.getElementsByTagNameNS)!='undefined'){
elementValue=nodeSet.getElementsByTagNameNS("*",elementName)[0].childNodes[0].nodeValue;
}
else{
elementValue=nodeSet.getElementsByTagName(elementNS+elementName)[0].childNodes[0].nodeValue;
}
}
catch(e){}
return elementValue;
}
function getInputValue(id){
var obj=document.getElementById(id);
if(obj){
if(obj.tagName.toLowerCase()=="select"){
return(obj.options[obj.selectedIndex].value);
}else{
switch((""+obj.getAttribute("type")).toLowerCase()){
case "radio":
case "checkbox":
return obj.checked;
case "textarea":
return obj.value.replace(/\r/ig,"");
case "text":
case "hidden":
case "password":
default:
return obj.value;
}
}
}
return "";
}
function setInputValue(id,value){
var obj=document.getElementById(id);
if(obj&&typeof(obj.value)!="undefined"){
obj.value=value;
}
}
function setElementTextByKey(keyAttribute){
var elems=document.getElementsByTagName("*");
for(var i=0;i<elems.length;i++){
if(elems[i].getAttribute(keyAttribute)&&elems[i].innerHTML){
elems[i].innerHTML=top.getString(elems[i].getAttribute(keyAttribute));
}
}
}
function setOptionChecked(id,checked){
var obj=document.getElementById(id);
if(obj&&typeof(obj.checked)!="undefined"){
obj.checked=parseBool(checked);
}
}
function getOptionGroupValue(name,parentId){
var host=(document.getElementById(parentId)||document);
if(host){
var elems=host.getElementsByTagName("input");
for(var i=0;i<elems.length;i++){
if(elems[i].type=="radio"&&elems[i].name==name&&elems[i].checked){
return elems[i].value;
}
}
}
return "";
}
function getElementValueFromString(string,elementName){
var elementValue='';
var elementNameEnd='</'+elementName+'>';
elementName='<'+elementName+'>';
if(string.indexOf(elementName)==-1){
return '';
}
elementValue=string.substring(string.indexOf(elementName)+elementName.length,string.indexOf(elementNameEnd));
var regExp=new RegExp("&gt;","g");
elementValue=elementValue.replace(regExp,">");
regExp=new RegExp("&lt;","g");
elementValue=elementValue.replace(regExp,"<");
return elementValue;
}
function getTotalXpath(nodeSet,xpath){
var xpathResult=0;
if(nodeSet){
try{
if(typeof(nodeSet.evaluate)!='undefined'){
xpathResult=nodeSet.evaluate("count("+xpath+")",nodeSet,nameSpaceResolver,XPathResult.NUMBER_TYPE,null).numberValue;
}else if(typeof(nodeSet.setProperty)!='undefined'){
nodeSet.setProperty("SelectionLanguage","XPath");
nodeSet.setProperty("SelectionNamespaces",SOAP_NAMESPACE_FULL()+" "+OA_NAMESPACE_FULL());
xpathResult=nodeSet.selectNodes(xpath).length;
}
}catch(e){}
}
return xpathResult;
}
function getArrayXpath(nodeSet,xpath){
var items;
var xpathResult=new Array;
if(nodeSet){
try{
if(typeof(nodeSet.evaluate)!='undefined'){
items=nodeSet.evaluate(xpath,nodeSet,nameSpaceResolver,7,null);
for(var i=0;i<items.snapshotLength;i++){
xpathResult.push(items.snapshotItem(i).textContent);
}
}else if(typeof(nodeSet.setProperty)!='undefined'){
nodeSet.setProperty("SelectionLanguage","XPath");
nodeSet.setProperty("SelectionNamespaces",SOAP_NAMESPACE_FULL()+" "+OA_NAMESPACE_FULL());
items=nodeSet.selectNodes(xpath);
for(var j=0;j<items.length;j++){
xpathResult.push(items[j].text);
}
}
}catch(e){}
}
return xpathResult;
}
function getElementValueXpath(nodeSet,xpath,nodeOnly){
var xpathResult=null;
var elementValue='';
if(nodeSet){
try{
if(typeof(nodeSet.evaluate)!='undefined'){
xpathResult=nodeSet.evaluate(xpath,nodeSet,nameSpaceResolver,7,null);
xpathResult=xpathResult.snapshotItem(0);
}else if(typeof(nodeSet.setProperty)!='undefined'){
nodeSet.setProperty("SelectionLanguage","XPath");
nodeSet.setProperty("SelectionNamespaces",SOAP_NAMESPACE_FULL()+" "+OA_NAMESPACE_FULL());
xpathResult=nodeSet.selectNodes(xpath);
xpathResult=xpathResult[0];
}
}catch(e){}
}
if(xpathResult!=null){
try{
if(xpathResult.textContent){
elementValue=xpathResult.textContent;
}else if(xpathResult.childNodes[0]){
elementValue=xpathResult.childNodes[0].nodeValue;
}
}catch(e){}
}
return(nodeOnly?xpathResult:elementValue);
}
function nameSpaceResolver(prefix){
switch(prefix){
case SOAP_NAMESPACE():
return SOAP_NAMESPACE_URI();
case OA_NAMESPACE():
return OA_NAMESPACE_URI();
case "xhtml":
return 'http://www.w3.org/1999/xhtml';
default:
return null;
}
}
function getCallSuccess(result){
try{
if(result==null){
return false;
}
if(typeof(result)=='boolean'){
return result;
}
if(isArray(result)){
return true;
}
if(result.xml==""){
return false;
}
var node=getElementValueXpath(result,"//hpoa:returnCodeOk",true)
if(node!=null){
return true;
}
if(result.xml.indexOf("SOAP-ENV:Fault")>-1){
return false;
}
if(result.xml.indexOf("parsererror")>-1){
return false;
}
}catch(e){
return(result.constructor==Object?true:false);
}
return true;
}
function convertAccessLevel(acl){
var accessLevels=['','USER','OPERATOR','ADMINISTRATOR'];
for(var i=1;i<accessLevels.length;i++){
if(acl==accessLevels[i]){
return i;
}
}
return 0;
}
function exists(arg){
return(!(typeof(arg)=='undefined'));
}
function existsNonNull(arg){
return(!(typeof(arg)=='undefined'||arg==null));
}
function assertNull(arg){
return(typeof(arg)=='undefined'?null:arg);
}
function assertTrue(arg){
return(typeof(arg)=='undefined'?true:parseBool(arg,true));
}
function isPercentValue(num){
if(!isNaN(num)){
return(num>=1&&num<=100);
}
return false;
}
function isNonZeroInteger(arg){
return(arg!=null&&!isNaN(arg)&&(arg>0)&&(parseInt(arg)==parseFloat(arg)));
}
function isEmailAddress(obj){
return(/^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/.test(obj.toString()));
}
function isDate(obj){
var aDate=new Date(obj);
return(aDate.toDateString()!="NaN"&&aDate.toDateString()!="Invalid Date");
}
function isNumber(obj){
return(obj!=null&&!isNaN(parseInt(obj)));
}
function isInteger(obj){
return(/^0$|^-?[1-9][0-9]*$/.test(obj.toString()));
}
function hasSpaces(obj){
return(obj.toString().search(/\s/)>-1);
}
function assertFalse(arg){
return(typeof(arg)=='undefined'?false:parseBool(arg));
}
function assertArray(arg){
if(typeof(arg)!='undefined'&&arg.constructor==Array){
return arg;
}else{
return(new Array());
}
}
function assertNumericRange(arg,min,max){
if(arg<min){
arg=min;
}else if(arg>max){
arg=max;
}
return arg;
}
function assertEmptyIpAddress(value){
return(value&&value!=""?value:"0.0.0.0");
}
function assertFunction(arg){
return(isFunction(arg)?arg:function(){});
}
function isFunction(arg){
switch(typeof(arg)){
case 'function':
return true;
case 'object':
if(arg!=null&&arg.constructor.toString().indexOf('Function()')>-1){
return true;
}
default:
return false;
}
}
function Nz(arg){
return((isNaN(arg)||arg==""||arg==null||(typeof(arg)=='undefined'))?0:arg);
};
function arrayContains(array,searchValue){
if(!isArray(array)){
return false;
}else{
for(var i=0;i<array.length;i++){
if(array[i]==searchValue){
return true;
}
}
}
return false;
};
function isValidIndex(index,arr){
if(isNaN(index)){
return false;
}else if(arr.constructor==Array){
if(arr.length==0){
return false;
}else{
return(index>=0&&index<arr.length);
}
}
return false;
};
function removeDuplicates(arrayOfStrings){
var hash=new Object();
var buffer='';
for(var index in arrayOfStrings){
buffer=arrayOfStrings[index];
if(isValidString(buffer)){
hash[buffer]=index;
}
}
arrayOfStrings=new Array();
for(var key in hash){
arrayOfStrings.push(key);
}
return arrayOfStrings;
};
function isObject(obj){
return((typeof(obj)=="object")||(typeof(obj)=="function"));
};
function isArray(obj){
if(obj==null){
return false;
}
try{
return(obj.constructor==Array);
}catch(err){return false;}
};
function isMissing(obj){
return(obj==null||typeof(obj)=="undefined"||!isValidString(obj));
};
function isValidString(obj){
return(typeof(obj)=="string"&&(obj=="&nbsp;"?false:obj.length>0));
};
function assertLocalizedString(key,originalString){
var localizedString=top.getString(key);
if(localizedString==""){
localizedString=originalString;
}
if(arrayContains(ErrorsWithSyslogDetail,key)){
if(top.getErrorString(key,ErrorType.OnboardAdmin)!=""||top.getErrorString(key,ErrorType.UserRequest)!=""){
localizedString+=" "+top.getString("seeSyslogForMoreInfo");
}
}
return localizedString;
};
function trimString(sourceString){
var nonPrints=["\t","\f","\n","\v"," "]
var newString="";
var charFound;
for(var i=0;i<sourceString.length;i++){
var temp=sourceString.substr(i,1);
charFound=true;
for(var j=0;j<nonPrints.length;j++){
if(temp==nonPrints[j]){
charFound=false;
break;
}
}
if(charFound){
newString+=temp;
}
}
return newString;
};
function escapeString(s){
if(s.length>0){
s=replaceCharacter(s,"<","&lt;");
s=replaceCharacter(s,">","&gt;");
}
return s;
}
function replaceCharacter(source,replaceChar,replaceWith){
if(isValidString(source)){
var regexp=new RegExp(replaceChar,"g");
source=source.replace(regexp,replaceWith);
}
return source;
};
function replaceTrailingChar(text,trailingChar,newChar){
return text.replace(new RegExp("\\"+trailingChar+"$"),newChar);
}
function parseBool(obj,defaultBool){
switch(typeof(obj)){
case "boolean":
return obj;
case "string":
return(obj.toLowerCase()=="true"?true:false);
case "number":
return(obj==0?false:true);
default:
return(typeof(defaultBool)=="undefined"?false:parseBool(defaultBool));
}
};
function isBool(obj){
if(typeof(obj)=="boolean")
return true;
if(typeof(obj)=="string"){
if(obj.toLowerCase()=="true"||obj.toLowerCase()=="false"){
return true;
}
}
return false;
};
function pathFix(path){
return(window.location.protocol.indexOf('http')==-1?".."+path:path);
};
function removeTrailingSlash(url){
return url.replace(/\/$/,'');
};
function ipv6UrlFix(text){
if(top.getBrowserInfo().agentContains("webkit")){
return(text.replace(/\/%5B/g,'/[').replace(/%5D\//g,']/').replace(/%5D:/g,']:'));
}else{
return text;
}
};
function replaceUrlAddress(url,newAddr){
if(isValidString(url)&&url.indexOf("://")>-1&&isValidString(newAddr)){
try{
var a=document.createElement("a");
a.href=url;
var port=((a.protocol=="https:"&&a.port=="443")||(a.protocol=="http:"&&a.port=="80")||a.port==""?"":":"+a.port);
var path=(a.pathname.indexOf("/")!=0?"/"+a.pathname:a.pathname);
url=(a.protocol+"//"+newAddr+port+path);
}catch(e){
top.logEvent("replaceUrlAddress error: "+e.message,null,1,5);
}
}
return url;
}
function determineObjectType(xmlString){
var objectType='';
if(xmlString.indexOf('hpoa:fanZone')>-1){
objectType='fanZone';
}
else if(xmlString.indexOf('hpoa:enclosureStatus')>-1){
objectType='enc';
}
else if(xmlString.indexOf('hpoa:bladeStatus')>-1){
objectType='bay';
}
else if(xmlString.indexOf('hpoa:interconnectTrayStatus')>-1){
objectType='interconnect';
}
else if(xmlString.indexOf('hpoa:powerSupplyStatus')>-1){
objectType='ps';
}
else if(xmlString.indexOf('hpoa:fanInfo')>-1){
objectType='fan';
}
else if(xmlString.indexOf('hpoa:powerSubsystemInfo')>-1){
objectType='pss';
}
else if(xmlString.indexOf('hpoa:thermalSubsystemInfo')>-1){
objectType='tss';
}
else if(xmlString.indexOf('hpoa:oaStatus')>-1){
objectType='oa';
}
return objectType;
}
function getBladeIplDoc(iplList){
var xml=importModule('xml');
var ipls=xml.parseXML('<hpoa:bladeIplArray xmlns:hpoa="hpoa.xsd" />');
for(var i=0;i<iplList.length;i++){
if(iplList[i].value!=''){
var iplDoc=xml.parseXML('<hpoa:ipl xmlns:hpoa="hpoa.xsd" />');
var bootPriorityElement=iplDoc.createElement('hpoa:bootPriority');
var bootPriorityText=iplDoc.createTextNode(''+parseInt((i+1)));
bootPriorityElement.appendChild(bootPriorityText);
var iplDeviceElement=iplDoc.createElement('hpoa:iplDevice');
var iplDeviceText=iplDoc.createTextNode(''+iplList[i].value);
iplDeviceElement.appendChild(iplDeviceText);
iplDoc.documentElement.appendChild(bootPriorityElement);
iplDoc.documentElement.appendChild(iplDeviceElement);
ipls.documentElement.appendChild(iplDoc.documentElement.cloneNode(true));
}
}
return ipls.documentElement.cloneNode(true);
}
function getBladeIplBootArrayExDoc(iplList){
var xml=importModule('xml');
var ipls=xml.parseXML('<hpoa:bladeIplBootArrayEx xmlns:hpoa="hpoa.xsd" />');
for(var i=0;i<iplList.length;i++){
if(iplList[i].value!=''){
var iplDoc=xml.parseXML('<hpoa:ipl xmlns:hpoa="hpoa.xsd" />');
var bootPriorityElement=iplDoc.createElement('hpoa:bootPriority');
var bootPriorityText=iplDoc.createTextNode(''+parseInt((i+1)));
bootPriorityElement.appendChild(bootPriorityText);
var iplDeviceElement=iplDoc.createElement('hpoa:bootDevIdentifier');
var iplDeviceText=iplDoc.createTextNode(''+iplList[i].value);
iplDeviceElement.appendChild(iplDeviceText);
iplDoc.documentElement.appendChild(bootPriorityElement);
iplDoc.documentElement.appendChild(iplDeviceElement);
ipls.documentElement.appendChild(iplDoc.documentElement.cloneNode(true));
}
}
return ipls.documentElement.cloneNode(true);
}
function getInnerHTML(elemId){
var elem=document.getElementById(elemId);
if(elem&&typeof(elem.innerHTML)!="undefined"){
return elem.innerHTML;
}
return "";
}
function setInnerHTML(elemId,html){
var elem=document.getElementById(elemId);
if(elem&&typeof(elem.innerHTML)!="undefined"){
elem.innerHTML=html;
}
}
function clearTextbox(id){
var tb=document.getElementById(id);
if(tb){
try{tb.value="";}catch(e){}
}
}
function focusTextbox(id){
var tb=document.getElementById(id);
if(tb){
try{tb.blur();}catch(e1){}
window.setTimeout(function(){try{tb.focus();}catch(e2){}},500);
}
}
function clearAll(){
clearTextbox('usernameInput');
clearTextbox('passwordInput');
focusTextbox('usernameInput');
}
function clearAllErrorMessages(){
if(typeof(DisplayManager)!="undefined"){
var displayMgr=new DisplayManager();
displayMgr.clearErrorContainers();
}
}
function isLocalDev(){
return false;
}
function getServiceUrl(proxyPath,baseOnly){
var proxy=((typeof(proxyPath)=='undefined'||proxyPath=='')?'/':proxyPath);
var service=(baseOnly==true?'':SERVICE_URL());
var port=(window.location.port==''?'':':'+window.location.port);
var proto=(window.location.protocol+'//');
var host=window.location.hostname;
if((host.indexOf(':')>-1)&&((host.indexOf('[')==-1)||(host.indexOf(']')==-1))){
host='['+host+']';
}
return(proto+host+port+proxy+service);
}
function getAllArray(min,max){
var allArray=new Array();
for(var i=min;i<=max;i++){
allArray[i]=i;
}
return allArray;
}
function getXmlBayArray(bayNumArray){
var xml=importModule('xml');
var bayArrayDoc=xml.parseXML('<hpoa:bayArray xmlns:'+OA_NAMESPACE()+'="'+OA_NAMESPACE_URI()+'" />');
for(var i=0;i<bayNumArray.length;i++){
if(bayNumArray[i]!=null){
var bayNumberElement=bayArrayDoc.createElement('hpoa:bay');
var bayNumberText=bayArrayDoc.createTextNode(''+i);
bayNumberElement.appendChild(bayNumberText);
bayArrayDoc.documentElement.appendChild(bayNumberElement);
}
}
return bayArrayDoc.documentElement.cloneNode(true);
}
function toXmlBayArray(bayNumArray){
var xml=importModule('xml');
var bayArrayDoc=xml.parseXML('<hpoa:bayArray xmlns:'+OA_NAMESPACE()+'="'+OA_NAMESPACE_URI()+'" />');
for(var i=0;i<bayNumArray.length;i++){
if(bayNumArray[i]!=null){
var bayNumberElement=bayArrayDoc.createElement('hpoa:bay');
var bayNumberText=bayArrayDoc.createTextNode(''+bayNumArray[i]);
bayNumberElement.appendChild(bayNumberText);
bayArrayDoc.documentElement.appendChild(bayNumberElement);
}
}
return bayArrayDoc.documentElement.cloneNode(true);
}
function deCompileXmlArray(arrayDoc,xpathStatement,elementName,elementId){
var xml=importModule('xml');
if(typeof(elementId)=='undefined'){
var elementId='bayNumber';
}
var arrayElements=null;
var resultArray=new Array();
arrayElements=getElementValueXpath(arrayDoc,xpathStatement,true);
if(arrayElements!=null){
for(var i=0;i<arrayElements.childNodes.length;i++){
if(arrayElements.childNodes[i].nodeName==elementName){
var identifier=(elementId=='none'?'none':parseInt(getElementValue(arrayElements.childNodes[i],elementId,OA_NAMESPACE())));
var documentString='';
if(typeof(XMLSerializer)!='undefined'){
documentString=new XMLSerializer().serializeToString(arrayElements.childNodes[i]);
}else{
documentString=arrayElements.childNodes[i].xml;
}
var tempDoc=xml.parseXML(documentString);
try{
tempDoc.xml=documentString;
}
catch(e){}
if(!isNaN(identifier)){
resultArray[identifier]=tempDoc;
}
else{
resultArray.push(tempDoc);
}
}
}
}
return resultArray;
}
function sortXmlArray(array,elementName){
var temp;
for(var i=array.length-1;i>=0;i--){
for(var j=1;j<=i;j++){
var value=getElementValueXpath(array[j-1],'//'+elementName);
var valueCmp=getElementValueXpath(array[j],'//'+elementName);
if(value.toLowerCase()>valueCmp.toLowerCase()){
temp=array[j-1];
array[j-1]=array[j];
array[j]=temp;
}
}
}
}
function StringBuilder(value)
{
this.strings=new Array("");
this.append(value);
}
StringBuilder.prototype.append=function(value)
{
if(value)
{
this.strings.push(value);
}
}
StringBuilder.prototype.clear=function()
{
this.strings.length=1;
}
StringBuilder.prototype.toString=function()
{
return this.strings.join("");
}
function getApplicationTimeout(){
var cookieTimeoutValue=parseInt(getCookieValue(GUI_TIMEOUT_COOKIE_NAME()));
var validTimeout=(isNaN(cookieTimeoutValue)?GUI_DEFAULT_TIMEOUT():cookieTimeoutValue);
top.logEvent("Global: Session Timeout value (milliseconds) is "+validTimeout,null,1,2);
return validTimeout;
}
function checkBitSet(code,mask){
if(code==0){
return false;
}
else{
return((code&mask)!=0);
}
}
function setNodeValueXpath(nodeSet,xpath,newValue,finalize){
var theNode=getElementValueXpath(nodeSet,xpath,true);
if(theNode){
if(theNode.firstChild&&theNode.firstChild.nodeType==NodeTypes.TEXT_NODE){
theNode.firstChild.nodeValue=newValue;
if(assertSerializer()&&assertTrue(finalize)){
nodeSet.xml=new XMLSerializer().serializeToString(nodeSet);
}
}else{
var textNode=nodeSet.createTextNode(newValue);
theNode.appendChild(textNode);
if(assertSerializer()&&assertTrue(finalize)){
nodeSet.xml=new XMLSerializer().serializeToString(nodeSet);
}
}
}
}
function assertSerializer(){
return(typeof(XMLSerializer)!='undefined');
};
function makeXmlParseable(fragment){
var hasXmlProperty=true;
var docString='';
var parsedDoc=null;
if(fragment!=null){
if(assertSerializer()){
hasXmlProperty=false;
docString=new XMLSerializer().serializeToString(fragment);
}else{
docString=fragment.xml;
}
parsedDoc=(top.getXml().parseXML(docString));
if(!hasXmlProperty){
parsedDoc.xml=docString;
}
}
return parsedDoc;
};
function getDomDocument(path){
var domDocument=top.getXml().parseXML('<br />');
try{
if(window.ActiveXObject){
domDocument.async=false;
domDocument.load(path);
}else if(typeof(XMLHttpRequest)!="undefined"){
var loader=new XMLHttpRequest();
loader.open("GET",path,false);
loader.send(null);
domDocument=loader.responseXML;
}
}catch(e){
top.logEvent("getDomDocument error: "+e.message,null,1,6);
}
return domDocument;
};
function _isValidIPv6Address(address,prefixLength){
var ipAddr,ipPrefix;
if(address==''){
return true;
}
if(address.indexOf("/")>=0){
var splitAddr=address.split("/");
if(splitAddr.length!=2){
return false;
}
ipAddr=splitAddr[0];
ipPrefix=splitAddr[1];
}
else{
ipAddr=address;
}
if(ipAddr!=undefined){
if(ipAddr.indexOf("::")==-1){
var oct=ipAddr.split(":");
if(oct.length!=8){
return false;
}
}
if((/^(:|([0-9A-Fa-f]{1,4}:){0,7})(:|(:[0-9A-Fa-f]{1,4}){0,7}|([0-9A-Fa-f]{0,4}))$/).test(ipAddr)){
if(ipPrefix!=undefined){
if((/^[0-9]{1,3}$/).test(ipPrefix)){
if((ipPrefix>0)&&(ipPrefix<129)){
return(prefixLength!='NO');
}
}
}
else{
return(prefixLength!='REQ');
}
}
}
return false;
}
function isValidIPv6Address(address){
return _isValidIPv6Address(address,'REQ');
}
function isValidIPv6AddressPrefOp(address){
return _isValidIPv6Address(address,'OP');
}
function _isIPv6AddressZero(address){
var splitedAdd=address.split('/');
if((splitedAdd[0]=='')||(splitedAdd[0]=='::'))
return true;
return false;
}
function openCgiWindow(cgiMethod,hpem){
var cgiUrl=getServiceUrl((hpem.getIsLocal()?"":hpem.getProxyUrl()),true)+cgiMethod;
var stylesheetUrl="stylesheetUrl=/120814-042457/Templates/cgiResponse";
if(hpem.getActiveFirmwareVersion()<2.00){
cgiUrl+="?oaSessionKey="+hpem.getSessionKey()+"&"+stylesheetUrl;
}else{
cgiUrl+="?"+stylesheetUrl;
}
window.open(cgiUrl);
};
