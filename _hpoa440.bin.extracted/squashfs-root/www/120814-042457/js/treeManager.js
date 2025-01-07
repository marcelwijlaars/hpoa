/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function TreeManager(){
treeWrapperIds=new Array();
}
TreeManager.prototype.init=function(){
var divs=document.getElementsByTagName("DIV");
for(var i=0;i<divs.length;i++){
var node=divs[i];
var nodeClass=node.className;
if(nodeClass.indexOf("treeOpen")>-1||nodeClass.indexOf("treeClosed")>-1){
var nodeId=node.getAttribute('id');
if(nodeId){
if((nodeId.indexOf("blade")>-1||nodeId.indexOf("interconnect")>-1||nodeId.indexOf("group")>-1)
&&nodeId.indexOf('leafWrapper')>-1){
var divCollection=node.getElementsByTagName('div');
for(var j=0;j<divCollection.length;j++){
if(divCollection[j].className.indexOf("treeDisclosure")>-1){
divCollection[j].setAttribute("originalClassName",divCollection[j].className);
if(!hasVisibleChildren(node)){
divCollection[j].className="";
}
}
}
}
}
}
if(divs[i].className.indexOf("treeWrapper")!=-1){
var linkNodes=divs[i].getElementsByTagName("A");
for(var j=0;j<linkNodes.length;j++){
if(linkNodes[j].className=="treeSelectableLink"){
var devNum=linkNodes[j].getAttribute('devNum');
var encNum=linkNodes[j].getAttribute('encNum');
var devType=linkNodes[j].getAttribute('devType');
var showTray=linkNodes[j].getAttribute('showTray');
var href=linkNodes[j].getAttribute('href');
var selectContent=(href&&href.indexOf('javascript:void')>-1);
if(devNum&&encNum&&devType&&href&&selectContent){
linkNodes[j].setAttribute('href','javascript:top.mainPage.getHiddenFrame().selectDevice('+devNum+', \"'+devType+'\", '+encNum+', true, '+(showTray=="false"?"false":"true")+')');
}
else{
eval("linkNodes[j].onclick = function(mozEvent) {ourTreeManager.onClickHandler(mozEvent);}");
}
}
}
var inputNodeCollection=divs[i].getElementsByTagName("input");
for(var j=0;j<inputNodeCollection.length;j++){
if(inputNodeCollection[j].getAttribute('treeselector')=="yes"){
if((inputNodeCollection[j].checked)!=(inputNodeCollection[j].parentNode.parentNode.className=="treeOpenSelected")||(inputNodeCollection[j].parentNode.parentNode.className=="treeClosedSelected")){
relevantTreeNode=inputNodeCollection[j].parentNode.parentNode;
if(relevantTreeNode.className=="leafWrapper"){
ourTreeManager.toggleCheckboxHighlight(null,relevantTreeNode,false);
}
else{
ourTreeManager.toggleCheckboxHighlight(null,relevantTreeNode.parentNode,false);
}
}
if(inputNodeCollection[j].parentNode.parentNode.className=="treeControl"){
inputNodeCollection[j].onclick=function(mozEvent){ourTreeManager.toggleCheckboxHighlight(mozEvent,this.parentNode.parentNode.parentNode,true);};
var lookingForTreeTitle=inputNodeCollection[j].parentNode.parentNode.parentNode;
for(var k=0;k<lookingForTreeTitle.childNodes.length;k++){
if(lookingForTreeTitle.childNodes[k].className=="treeTitle"){
lookingForTreeTitle=lookingForTreeTitle.childNodes[k];
}
}
var lookingForTreeControl=inputNodeCollection[j].parentNode.parentNode.parentNode;
for(var k=0;k<lookingForTreeControl.childNodes.length;k++){
if(lookingForTreeControl.childNodes[k].className=="treeControl"){
lookingForTreeControl=lookingForTreeControl.childNodes[k];
}
}
lookingForTreeTitle.onclick=function(mozEvent){ourTreeManager.toggleCheckboxHighlight(mozEvent,this.parentNode,true);};
lookingForTreeControl.onclick=function(mozEvent){ourTreeManager.toggleCheckboxHighlight(mozEvent,this.parentNode,true);};
}
else if((inputNodeCollection[j].parentNode.parentNode.className=="leafWrapper")||(inputNodeCollection[j].parentNode.parentNode.className=="leafWrapperSelected")){
inputNodeCollection[j].onclick=function(mozEvent){ourTreeManager.toggleCheckboxHighlight(mozEvent,this.parentNode.parentNode,true);};
inputNodeCollection[j].parentNode.parentNode.onclick=function(mozEvent){ourTreeManager.toggleCheckboxHighlight(mozEvent,this,true);};
}
}
}
var masterCheckbox=document.getElementById(divs[i].getAttribute("id")+"_masterCheckbox");
if(masterCheckbox){
masterCheckbox.onclick=function(){ourTreeManager.selectAllCheckboxes(this);}
}
}
else if(
(divs[i].className=="treeOpen")||
(divs[i].className=="treeClosed")||
(divs[i].className=="treeOpenSelected")||
(divs[i].className=="treeClosedSelected")
){
var tree=divs[i];
var treeDisclosure=null;
for(var j=0;j<tree.childNodes.length;j++){
if((tree.childNodes[j].nodeType==1)&&(tree.childNodes[j].className=="treeControl")){
treeDisclosure=tree.childNodes[j];
}
}
if(treeDisclosure!=null){
for(var j=0;j<treeDisclosure.childNodes.length;j++){
if((treeDisclosure.childNodes[j].nodeType==1)&&(treeDisclosure.childNodes[j].className=="treeDisclosure")){
treeDisclosure=treeDisclosure.childNodes[j];
}
}
if(treeDisclosure.onclick){
eval("treeDisclosure.onclick = function(mozEvent) {var hardCodedFunction = "+treeDisclosure.onclick+" ;ourTreeManager.toggleTree(mozEvent,this);hardCodedFunction();};");
}
else{
eval("treeDisclosure.onclick = function(mozEvent) {ourTreeManager.toggleTree(mozEvent,this);};");
}
}
}
}
}
TreeManager.prototype.onClickHandler=function(mozEvent){
var treeElement=getEventOriginator(mozEvent);
var devNum=treeElement.getAttribute('devNum');
var encNum=treeElement.getAttribute('encNum');
var devType=treeElement.getAttribute('devType');
var showTray=treeElement.getAttribute('showTray');
if(encNum==null){
top.logEvent(["Tree Manager: NULL attribute detected.","Element: "+treeElement.id],null,1,5);
return;
}
var href=treeElement.getAttribute('href');
var selectContent=false;
if(href){
selectContent=(href.indexOf('javascript:void')>-1);
}
top.mainPage.getHiddenFrame().selectDevice(devNum,devType,encNum,selectContent,!(showTray=="false"));
ourTreeManager.makeTreeNodeHighlighted(treeElement);
}
TreeManager.prototype.toggleCheckboxHighlight=function(mozEvent,treeElement,checkOrigination){
var eventSource;
if(checkOrigination){
eventSource=(document.all)?event.srcElement:mozEvent.target;
try{
if(
(eventSource.tagName=="INPUT")&&((eventSource.getAttribute("treeselector")!="yes"))&&((eventSource.getAttribute("treeselector")!="yes"))
||(eventSource.tagName=="A")
||(eventSource.tagName=="IMG")
||(eventSource.className=="treeDisclosure")
){
return false;
}
}
catch(e){alert(e)}
}
var lookingForCheckbox=treeElement;
for(var i=0;i<lookingForCheckbox.childNodes.length;i++){
if(lookingForCheckbox.childNodes[i].className=="treeControl")lookingForCheckbox=lookingForCheckbox.childNodes[i];
}
for(var i=0;i<lookingForCheckbox.childNodes.length;i++){
if(lookingForCheckbox.childNodes[i].className=="treeCheckbox")lookingForCheckbox=lookingForCheckbox.childNodes[i];
}
for(var i=0;i<lookingForCheckbox.childNodes.length;i++){
if(lookingForCheckbox.childNodes[i].tagName=="INPUT")lookingForCheckbox=lookingForCheckbox.childNodes[i];
}
var ourTreeCheckbox=lookingForCheckbox;
if((checkOrigination)&&((!eventSource)||(eventSource.tagName!="INPUT"))){
ourTreeCheckbox.checked=!ourTreeCheckbox.checked;
}
if(ourTreeCheckbox.checked){
if(treeElement.className=="leaf")treeElement.className="leafSelected";
else if(treeElement.className=="treeOpen")treeElement.className="treeOpenSelected";
else if(treeElement.className=="treeClosed")treeElement.className="treeClosedSelected";
else if(treeElement.className=="leafWrapper")treeElement.className="leafWrapperSelected";
}
else{
if(treeElement.className=="leafSelected")treeElement.className="leaf";
else if(treeElement.className=="treeOpenSelected")treeElement.className="treeOpen";
else if(treeElement.className=="treeClosedSelected")treeElement.className="treeClosed";
else if(treeElement.className=="leafWrapperSelected")treeElement.className="leafWrapper";
}
}
TreeManager.prototype.selectAllCheckboxes=function(masterCheckbox){
var treeId=masterCheckbox.getAttribute("id").replace("_masterCheckbox","");
var treeObj=document.getElementById(treeId);
var inputNodeCollection=treeObj.getElementsByTagName("input");
for(var i=0;i<inputNodeCollection.length;i++){
if(inputNodeCollection[i].getAttribute('type')=="checkbox"){
if(masterCheckbox.checked!=inputNodeCollection[i].checked){
if(inputNodeCollection[i].getAttribute("treeselector")=="yes"){
inputNodeCollection[i].checked=!inputNodeCollection[i].checked;
var relevantTreeElement=inputNodeCollection[i].parentNode.parentNode;
if(relevantTreeElement.className=="treeControl"){
relevantTreeElement=relevantTreeElement.parentNode;
}
this.toggleCheckboxHighlight(null,relevantTreeElement,false);
}
}
}
}
}
TreeManager.prototype.toggleTree=function(mozEvent,treeControl){
try{
var treeObject=treeControl.parentNode;
if(treeControl.className=="treeDisclosure"){
treeObject=treeControl.parentNode.parentNode;
}
if(hasVisibleChildren(treeObject)){
if(treeObject.className=="treeClosed"){
treeObject.className="treeOpen";
}
else if(treeObject.className=="treeClosedSelected"){
treeObject.className="treeOpenSelected";
}
else if(treeObject.className=="treeOpenSelected"){
treeObject.className="treeClosedSelected";
}
else{
treeObject.className="treeClosed"
}
}
}
catch(e){}
}
function hasVisibleChildren(treeObject){
var hasVisible=false;
for(var i=0;i<treeObject.childNodes.length;i++){
var currentNode=treeObject.childNodes[i];
if(currentNode.className=='treeContents'&&currentNode.childNodes.length>0){
var hasVisible=false;
for(var j=0;j<currentNode.childNodes.length;j++){
if(currentNode.childNodes[j].style.display!='none'){
hasVisible=true;
break;
}
}
}
}
return hasVisible;
}
TreeManager.prototype.openAllTrees=function(wrapperId){
var wrapperDiv=document.getElementById(wrapperId);
var childDivs=wrapperDiv.getElementsByTagName("div");
for(var i=0;i<childDivs.length;i++){
if(childDivs[i].className=="treeClosed"){
if(hasVisibleChildren(childDivs[i])){
childDivs[i].className="treeOpen";
}
}
else if(childDivs[i].className=="treeClosedSelected"){
if(hasVisibleChildren(childDivs[i])){
childDivs[i].className="treeOpenSelected";
}
}
}
}
TreeManager.prototype.closeAllTrees=function(wrapperId){
var wrapperDiv=document.getElementById(wrapperId);
var childDivs=wrapperDiv.getElementsByTagName("div");
for(var i=0;i<childDivs.length;i++){
if(childDivs[i].className=="treeOpen"){
childDivs[i].className="treeClosed";
}
else if(childDivs[i].className=="treeOpenSelected"){
childDivs[i].className="treeClosedSelected";
}
}
}
TreeManager.prototype.openSpecificTreeNode=function(id){
try{
var walkingNode=document.getElementById(id);
while(walkingNode.parentNode){
if(walkingNode.className=="treeClosed"){
if(hasVisibleChildren(walkingNode)){
walkingNode.className="treeOpen";
}
}
walkingNode=walkingNode.parentNode;
}
}catch(e){}
}
TreeManager.prototype.makeTreeNodeHighlighted=function(treeLink){
if(treeLink.parentNode.tagName=="B")treeLink=treeLink.parentNode;
var parentClassName=treeLink.parentNode.className;
var grandparentClassName=treeLink.parentNode.parentNode.className;
if((grandparentClassName=="treeOpen")||(grandparentClassName=="treeClosed")){
this.unHighlightAllTreesExceptOne(treeLink.parentNode.parentNode);
}
else if(parentClassName=="leaf"){
this.unHighlightAllTreesExceptOne(treeLink.parentNode);
}
}
TreeManager.prototype.makeSpecificTreeNodeHighlighted=function(id){
this.openSpecificTreeNode(id);
var treeNode=document.getElementById(id);
var linkNode=(treeNode.childNodes[0].tagName=="B")?treeNode.childNodes[0].childNodes[0]:treeNode.childNodes[0];
this.makeTreeNodeHighlighted(linkNode);
var currentNode=treeNode;
var parentAnchor="";
do{
if(currentNode.className.indexOf("treeOpen")>-1||currentNode.className.indexOf("treeClosed")>-1){
parentAnchor=currentNode.getAttribute('id');
break;
}
}while(currentNode=currentNode.parentNode);
return parentAnchor;
}
TreeManager.prototype.unHighlightAllTreesExceptOne=function(highlightedTree){
var walkingNode=highlightedTree;
while((walkingNode.className!="treeWrapper")&&(walkingNode.className!="treeHasOneIconSpacing")&&(walkingNode.className!="treeHasTwoIconSpacing")&&(walkingNode.parentNode)){
walkingNode=walkingNode.parentNode;
}
var divNodes=walkingNode.getElementsByTagName("DIV");
for(var i=0;i<divNodes.length;i++){
if(divNodes[i]==highlightedTree){
if(divNodes[i].className=="leaf"){
divNodes[i].className="leafSelected";
}
else if(divNodes[i].className=="treeOpen"){
divNodes[i].className="treeOpenSelected";
}
else if(divNodes[i].className=="treeClosed"){
divNodes[i].className="treeClosedSelected";
}
else if(divNodes[i].className=="leafWrapper"){
divNodes[i].className="leafWrapperSelected";
}
}
else{
if(divNodes[i].className=="leafSelected")divNodes[i].className="leaf";
else if(divNodes[i].className=="treeOpenSelected")divNodes[i].className="treeOpen";
else if(divNodes[i].className=="treeClosedSelected")divNodes[i].className="treeClosed";
else if(divNodes[i].className=="leafWrapperSelected")divNodes[i].className="leafWrapper";
}
}
}
TreeManager.prototype.unHighlightAllTrees=function(wrapperId){
var walkingNode=document.getElementById(wrapperId);;
while((walkingNode.className!="treeWrapper")&&(walkingNode.className!="treeHasOneIconSpacing")&&(walkingNode.className!="treeHasTwoIconSpacing")&&(walkingNode.parentNode)){
walkingNode=walkingNode.parentNode;
}
var divNodes=walkingNode.getElementsByTagName("DIV");
for(var i=0;i<divNodes.length;i++){
if(divNodes[i].className=="leafSelected")divNodes[i].className="leaf";
else if(divNodes[i].className=="treeOpenSelected")divNodes[i].className="treeOpen";
else if(divNodes[i].className=="treeClosedSelected")divNodes[i].className="treeClosed";
else if(divNodes[i].className=="leafWrapperSelected")divNodes[i].className="leafWrapper";
}
}
TreeManager.prototype.resizeTreeContainerTo=function(id,width,height){
var treeContainerDiv=document.getElementById(id);
treeContainerDiv.style.width=width;
treeContainerDiv.style.height=height;
}
TreeManager.prototype.resizeTreeContainerBy=function(id,dWidth,dHeight){
var treeContainerDiv=document.getElementById(id);
if(treeContainerDiv.offsetWidth+dWidth>0){
treeContainerDiv.style.width=treeContainerDiv.offsetWidth+dWidth;
}
else treeContainerDiv.style.width=1;
if(treeContainerDiv.offsetHeight+dHeight>0){
treeContainerDiv.style.height=treeContainerDiv.offsetHeight+dHeight;
}
else treeContainerDiv.style.height=1;
}
TreeManager.prototype.treeSetWidth=function(szIdTree,w){
var e=document.getElementById(szIdTree);
if(e!=null){
e.style.overflow="auto";
e.style.width=w;
var err=e.offsetWidth-w;
if(w>=err)
e.style.width=w-err;
}
}
TreeManager.prototype.treeSetHeight=function(szIdTree,h){
var e=document.getElementById(szIdTree);
if(e!=null){
e.style.overflow="auto";
e.style.height=h;
var err=e.offsetHeight-h;
if(h>=err)
e.style.height=h-err;
}
}
