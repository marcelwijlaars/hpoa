/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var themeImages=null;
function cacheImages(){
try{
if(document.images){
themeImages=new Array(7);
for(var i=0;i<themeImages.length;i++){
themeImages[i]=new Image();
}
themeImages[0].src="/120814-042457/images/themes/blue/navbar_global_trigger_bg.gif";
themeImages[1].src="/120814-042457/images/themes/blue/navbar_global_trigger_over_bg.gif";
themeImages[2].src="/120814-042457/images/navbar_local_trigger_bg.gif";
themeImages[3].src="/120814-042457/images/navbar_local_trigger_over_bg.gif";
themeImages[4].src="/120814-042457/images/themes/blue/navbar_parent_bg_over.gif";
themeImages[5].src="/120814-042457/images/themes/blue/navbar_parent_bg.gif";
themeImages[6].src="/120814-042457/images/menu_sep.gif";
}
}catch(loadError){}
};
function DropdownMenuManager(){
this.HIDE_SUBMENU_DELAY=500;
this.HIDE_ALL_DELAY=1000;
cacheImages();
}
DropdownMenuManager.prototype.init=function(){
this.dropdownMenuIds=new Array();
this.mouseIsGone=false;
this.timerSubMenus=0;
this.timerAllMenus=0;
var nodeCollection=window.document.getElementsByTagName("ul");
for(var i=0;i<nodeCollection.length;i++){
if(nodeCollection[i].getAttribute('isdropdownmenu')=="yes"){
var rightClickMenu=false;
if(nodeCollection[i].getAttribute('isrightclick')=="yes"){
rightClickMenu=true;
}
var menu=nodeCollection[i];
menu.style.width="";
menu.style.height="";
var id=menu.getAttribute('id');
var menuTrigger=document.getElementById(id+"_trigger");
menuTrigger.mouseIsOver=false;
this.dropdownMenuIds[this.dropdownMenuIds.length]=id;
var shim=document.getElementById("shim"+id);
if(shim){
shim.style.width="";
shim.style.height="";
}else{
shim=document.createElement("iframe");
shim.setAttribute("id","shim"+id);
shim.setAttribute("src","menublank.html");
shim.setAttribute("scrolling","no");
shim.className="dropdownMenuShim";
}
menu.parentNode.insertBefore(shim,menu);
if(menuTrigger.tagName=="LI"){
eval("menuTrigger.onmouseover = function(mozEvent) {ourDropdownMenuManager.updateTimer(false); ourDropdownMenuManager.activateMenu(this,'"+id+"',mozEvent);this.mouseIsOver=true;ourDropdownMenuManager.checkForSiblingSubMenusToClose(this)}");
eval("menuTrigger.onmouseout  = function(mozEvent) {ourDropdownMenuManager.updateTimer(true); ourDropdownMenuManager.unHighlightTrigger(this,'"+id+"',mozEvent);this.mouseIsOver=false;}");
}
else{
if(rightClickMenu){
eval("menuTrigger.onmousedown = function(event) {var rightclick;if (!event) var event = window.event;if (event.which) rightclick = (event.which == 3);else if (event.button) rightclick = (event.button == 2);if ( rightclick) {this.rightClickMenuClicked = true;ourDropdownMenuManager.activateMenu(this,'"+id+"',event);this.mouseIsOver=true;ourDropdownMenuManager.checkForSiblingSubMenusToClose(this);if (document.all) event.cancelBubble = true;else event.stopPropagation();}}");
eval("menuTrigger.onmouseup = function(event) {var rightclick;if (!event) var event = window.event;if (event.which) rightclick = (event.which == 3);else if (event.button) rightclick = (event.button == 2);if ( rightclick) {this.rightClickMenuClicked = false;if (document.all) event.cancelBubble = true;else event.stopPropagation();}}");
menuTrigger.oncontextmenu=function(e){return false;};
}else{
eval("menuTrigger.onclick  = function(event) {ourDropdownMenuManager.updateTimer(false); ourDropdownMenuManager.showDropdownMenu('"+id+"',event);ourDropdownMenuManager.highlightTopLevelTrigger('"+id+"');}");
}
eval("menuTrigger.onmouseover = function(event) {ourDropdownMenuManager.updateTimer(false); if(ourDropdownMenuManager.someMenuIsOpen('"+id+"')){ourDropdownMenuManager.showDropdownMenu('"+id+"',event); this.timerId = window.setTimeout('ourDropdownMenuManager.possiblyClearAllMenus()', 2000);}ourDropdownMenuManager.highlightTopLevelTrigger('"+id+"');}");
eval("menuTrigger.onmouseout = function(){ourDropdownMenuManager.updateTimer(true); if (!ourDropdownMenuManager.aMenuIsOpen('"+id+"')){ ourDropdownMenuManager.unHighlightTopLevelTrigger('"+id+"');}}");
}
var childElements=menu.getElementsByTagName("li");
var widestChild=0;
for(var j=0;j<childElements.length;j++){
var menuItem=childElements[j];
if((menuItem.nodeType==1)&&(menuItem.parentNode==menu)&&(menuItem.className!="dropdownMenuSpacer")){
var menuItemTextContents=menuItem.childNodes[0];
var checkedItemPadding=0;
if((menuItemTextContents.className)&&((menuItemTextContents.className.indexOf("dropdownMenuItemChecked")!=-1)||
(menuItemTextContents.className.indexOf("dropdownMenuItemUnchecked")!=-1))){
checkedItemPadding=(document.all?10:0);
}
widestChild=Math.max(widestChild,menuItem.offsetWidth+checkedItemPadding);
if((menuItem.className!="subMenuTrigger")&&(menuItem.className!="subMenuTriggerOver")){
menuItem.onmouseover=function(){
this.mouseGone=false;
if(this.className!="disabled"){
ourDropdownMenuManager.highlightRegularLiItem(this);
ourDropdownMenuManager.checkForSiblingSubMenusToClose(this)
}
}
eval("menuItem.onmouseout = function(){ourDropdownMenuManager.updateTimer(true); if (this.className!='disabled'){ourDropdownMenuManager.unHighlightRegularLiItem(this);}}");
}
menuItem.onclick=function(){
var childNode=(this.childNodes[0].className?this.childNodes[0]:this.childNodes[1]);
if(childNode&&childNode.className){
if(childNode.className=="dropdownMenuItemChecked"){
childNode.className="dropdownMenuItemUnchecked";
eval(childNode.getAttribute("onuncheck"));
}else if(childNode.className=="dropdownMenuItemUnchecked"){
childNode.className="dropdownMenuItemChecked";
eval(childNode.getAttribute("oncheck"));
}
}
ourDropdownMenuManager.clearMenus();
}
}
}
try{menu.style.width=widestChild;}catch(e){}
}
}
}
DropdownMenuManager.prototype.checkForSiblingSubMenusToClose=function(liObj){
var ulParent=liObj.parentNode;
var family=ulParent.getElementsByTagName("LI");
for(var i=0;i<family.length;i++){
if((family[i].className=="subMenuTrigger")||(family[i].className=="subMenuTriggerOver")){
if((family[i].parentNode==ulParent)&&(family[i]!=liObj)){
var id=family[i].getAttribute("id").replace("_trigger","");
var menu=document.getElementById(id);
if(!mouseIsOverAbsElement(menu)){
this.timerSubMenus=window.setTimeout("ourDropdownMenuManager.possiblyClearMenu('"+id+"')",this.HIDE_SUBMENU_DELAY);
}
}
}
}
}
DropdownMenuManager.prototype.updateTimer=function(mouseOut){
this.mouseIsGone=mouseOut;
if(this.timerAllMenus>0){
window.clearTimeout(this.timerAllMenus);
}
this.timerAllMenus=window.setTimeout("ourDropdownMenuManager.possiblyClearAllMenus()",this.HIDE_ALL_DELAY);
}
DropdownMenuManager.prototype.possiblyClearAllMenus=function(){
if(this.mouseIsGone){this.clearMenus();}
if(this.timerAllMenus>0){
window.clearTimeout(this.timerAllMenus);
this.timerAllMenus=0;
}
}
DropdownMenuManager.prototype.possiblyClearMenu=function(id){
var menu=document.getElementById(id);
var menuTrigger=document.getElementById(id+"_trigger");
if(this.timerSubMenus>0){
window.clearTimeout(this.timerSubMenus);
this.timerSubMenus=0;
}
if(!menuTrigger.mouseIsOver){
this.hideDropdownMenu(id);
if(menuTrigger.className!="subMenuTrigger"){
menuTrigger.className="subMenuTrigger";
}
}
}
DropdownMenuManager.prototype.aMenuIsOpen=function(id){
menu=document.getElementById(id);
if(menu.style.visibility=="visible")return true;
else return false;
}
DropdownMenuManager.prototype.someMenuIsOpen=function(someChildElementId){
var childElement=document.getElementById(someChildElementId);
var lookingForTopLevelTrigger=childElement;
while((lookingForTopLevelTrigger)&&(lookingForTopLevelTrigger.tagName!="DIV")){
lookingForTopLevelTrigger=lookingForTopLevelTrigger.parentNode;
}
var foundAnOpenMenu=false;
if(lookingForTopLevelTrigger){
var menuContainer=lookingForTopLevelTrigger.parentNode;
var ulCollection=menuContainer.getElementsByTagName("UL");
for(var i=0;i<ulCollection.length;i++){
if((ulCollection[i].className.indexOf("dropdownMenu")!=-1)&&(this.aMenuIsOpen(ulCollection[i].getAttribute("id")))){
foundAnOpenMenu=true;
}
}
}
return foundAnOpenMenu;
}
DropdownMenuManager.prototype.highlightTopLevelTrigger=function(id){
for(var i=0;i<this.dropdownMenuIds.length;i++){
trigger=document.getElementById(this.dropdownMenuIds[i]+"_trigger");
if(trigger){
if(trigger.tagName=="DIV"){
if(this.dropdownMenuIds[i]==id){
if(trigger.className.indexOf("globalNavTrigger")!=-1){
if(trigger.className!="globalNavTriggerOver"){
trigger.className="globalNavTriggerOver";
}
}
else if(trigger.className.indexOf("localNavTrigger")!=-1){
if(trigger.className!="localNavTriggerOver"){
trigger.className="localNavTriggerOver";
}
}
else if(trigger.className.indexOf("standardNavTrigger")!=-1){
if(trigger.className!="standardNavTriggerOver"){
trigger.className="standardNavTriggerOver";
}
}
}
}
}
}
}
DropdownMenuManager.prototype.unHighlightTopLevelTrigger=function(id){
trigger=document.getElementById(id+"_trigger");
if(trigger){
if(trigger.className.indexOf("globalNavTrigger")!=-1){
if(trigger.className!="globalNavTrigger"){
trigger.className="globalNavTrigger";
}
}
else if(trigger.className.indexOf("localNavTrigger")!=-1){
if(trigger.className!="localNavTrigger"){
trigger.className="localNavTrigger";
}
}
else if(trigger.className.indexOf("standardNavTrigger")!=-1){
if(trigger.className!="standardNavTrigger"){
trigger.className="standardNavTrigger";
}
}
}
}
DropdownMenuManager.prototype.activateMenu=function(obj,id,mozEvent){
var eventSource=getEventOriginator(mozEvent);
if(eventSource.getAttribute("id")==id+"_trigger"){
this.showDropdownMenu(id,mozEvent);
obj.className="subMenuTriggerOver";
}
}
DropdownMenuManager.prototype.unHighlightTrigger=function(obj,id,mozEvent){
if((obj==getEventOriginator(mozEvent))&&(!this.aMenuIsOpen(id))){
obj.className="subMenuTrigger";
}
}
DropdownMenuManager.prototype.unHighlightRegularLiItem=function(obj){
obj.style.backgroundColor='#ffffff';
}
DropdownMenuManager.prototype.highlightRegularLiItem=function(obj){
obj.style.backgroundColor='#99ccff';
}
DropdownMenuManager.prototype.disableMenuItem=function(id){
document.getElementById(id).className="disabled";
}
DropdownMenuManager.prototype.enableMenuItem=function(id){
document.getElementById(id).className="";
}
DropdownMenuManager.prototype.insertNewMenuItem=function(newTitle,newURL,idOfItemToInsertAfter){
var newLiElement=document.createElement("li");
var insertAfter=document.getElementById(idOfItemToInsertAfter);
var liContents=document.createTextNode(newTitle);
newLiElement.setAttribute("action",newURL);
newLiElement.appendChild(liContents);
newLiElement.onmouseover=function(){if(this.className!="disabled"){ourDropdownMenuManager.highlightRegularLiItem(this);ourDropdownMenuManager.checkForSiblingSubMenusToClose(this)}}
newLiElement.onmouseout=function(){if(this.className!="disabled"){ourDropdownMenuManager.unHighlightRegularLiItem(this);}}
newLiElement.onclick=function(){if((this.className!="disabled")&&(this.getAttribute("action"))){document.location=this.getAttribute("action");}}
newLiElement.onmousedown=function(mozEvent){if(document.all)event.cancelBubble=true;else mozEvent.stopPropagation();}
insertAfter.parentNode.insertBefore(newLiElement,insertAfter);
}
DropdownMenuManager.prototype.showDropdownMenu=function(id,mozEvent){
var menu=document.getElementById(id);
var page=getDocumentCoords(menu);
var menuTrigger=document.getElementById(id+"_trigger");
var eventSource=getEventOriginator(mozEvent);
if((eventSource==menuTrigger)||((eventSource.tagName=="IMG")&&(eventSource.parentNode==menuTrigger))){
this.hideAllSiblingsOfAGivenMenu(menu);
var offsetX=menuTrigger.offsetLeft;
var offsetY=menuTrigger.offsetTop;
if(menuTrigger.tagName=="DIV"||eventSource.tagName=="IMG"){
var ob=menuTrigger.parentNode;
while(ob.offsetParent!=null){
offsetY+=ob.offsetTop;
offsetX+=ob.offsetLeft;
ob=ob.offsetParent;
}
}
var insertionX=offsetX;
var insertionY=offsetY;
if(menuTrigger.tagName=="DIV"||eventSource.tagName=="IMG"){
if(menuTrigger.className.indexOf("globalNavTrigger")!=-1){
if(!document.all){
insertionX+=4;
}
}
if(offsetX+menu.offsetWidth>page.right)
insertionX=page.right-menu.offsetWidth;
insertionY+=menuTrigger.offsetHeight;
}
else{
if(offsetX+menu.offsetWidth>page.right)
insertionX-=menuTrigger.offsetWidth;
else
insertionX+=menuTrigger.offsetWidth;
insertionY-=3;
}
if(menu.style.visibility!="visible"){
if(page.scrollX>0){
menu.style.left=(insertionX<page.left?page.left:insertionX)+"px";
}else{
menu.style.left=(insertionX>0?insertionX:0)+"px";
}
menu.style.top=insertionY+"px";
menu.style.visibility="visible";
var width=menu.offsetWidth;
var height=menu.offsetHeight;
var shim=document.getElementById("shim"+id);
if(shim){
shim.style.width=width+"px";
shim.style.height=height+"px";
shim.style.top=menu.style.top;
shim.style.left=menu.style.left;
shim.style.visibility="visible";
}
}
}
}
DropdownMenuManager.prototype.hideDropdownMenu=function(id){
var menu=document.getElementById(id);
menu.style.visibility="hidden";
var shim=document.getElementById("shim"+id);
if(shim){
shim.style.visibility="hidden";
}
}
DropdownMenuManager.prototype.hideAllSiblingsOfAGivenMenu=function(menu){
var menuSiblings=menu.parentNode.parentNode.getElementsByTagName("ul");
for(var i=0;i<menuSiblings.length;i++){
if(menuSiblings[i]!=menu){
this.hideDropdownMenu(menuSiblings[i].id);
var siblingMenuTrigger=document.getElementById(menuSiblings[i].id+"_trigger");
if(siblingMenuTrigger.tagName!="DIV"){
if(siblingMenuTrigger.className!="subMenuTrigger"){
siblingMenuTrigger.className="subMenuTrigger";
}
}
}
}
}
DropdownMenuManager.prototype.clearMenus=function(){
for(var i=0;i<this.dropdownMenuIds.length;i++){
var menuTrigger=document.getElementById(this.dropdownMenuIds[i]+"_trigger");
if(menuTrigger){
if(menuTrigger.tagName=="LI"){
if(menuTrigger.className!="subMenuTrigger"){
menuTrigger.className="subMenuTrigger";
}
}else{
if(menuTrigger.className.indexOf("localNavTrigger")!=-1){
if(menuTrigger.className!="localNavTrigger"){
menuTrigger.className="localNavTrigger";
}
}else if(menuTrigger.className.indexOf("globalNavTrigger")!=-1){
if(menuTrigger.className!="globalNavTrigger"){
menuTrigger.className="globalNavTrigger";
}
}else if(menuTrigger.className.indexOf("standardNavTrigger")!=-1){
if(menuTrigger.className!="standardNavTrigger"){
menuTrigger.className="standardNavTrigger";
}
}
}
this.hideDropdownMenu(this.dropdownMenuIds[i]);
}
}
}
DropdownMenuManager.prototype.setLocalMenuEnabled=function(state,id){
var cssClass=(state==true?"":"disabled");
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
if(divs[i].className.indexOf("localNavTrigger")>-1&&(id?(divs[i].id==id):true)){
var listItems=divs[i].getElementsByTagName("LI");
for(var j=0;j<listItems.length;j++){
if(listItems[j].firstChild.tagName=="A"){
listItems[j].className=cssClass;
}
}
}
}
};
function dropdownMenuManager_clearMenus(){
ourDropdownMenuManager.clearMenus();
}
