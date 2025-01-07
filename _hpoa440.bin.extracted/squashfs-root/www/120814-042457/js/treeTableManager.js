/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function TreeTableManager(){
this.treeControls=null;
}
TreeTableManager.prototype.init=function(){
var tableRows=document.getElementsByTagName("tr");
this.treeControls=new Array();
for(var i=0;i<tableRows.length;i++){
if(tableRows[i].className.indexOf("treeTableTitleRow")>-1){
var tree=tableRows[i];
var childDivs=tree.getElementsByTagName("DIV");
var treeControl=null;
for(var j=0;j<childDivs.length;j++){
if((childDivs[j].nodeType==1)&&(childDivs[j].className=="treeControl")){
treeControl=childDivs[j];
break;
}
}
var additionalOnClick;
if(treeControl){
var treeControlObj=new Object();
treeControlObj.elem=treeControl;
treeControlObj.master=tableRows[i];
this.treeControls.push(treeControlObj);
if(treeControl.onclick){
if(treeControl.onclick.toString().indexOf("ourTreeTableManager.toggleTableTree(mozEvent,this)")==-1){
additionalOnClick=treeControl.onclick;
eval("treeControl.onclick = function(mozEvent) {var hardCodedFunction = "+treeControl.onclick+" ;ourTreeTableManager.toggleTableTree(mozEvent,this);hardCodedFunction();};");
}
}else{
eval("treeControl.onclick = function(mozEvent) {ourTreeTableManager.toggleTableTree(mozEvent,this);};");
}
}
}
}
}
TreeTableManager.prototype.toggleTableTree=function(mozEvent,treeControl){
var titleRowObject=treeControl;
var parentId;
var i;
while((titleRowObject)&&(titleRowObject.tagName!="TR")){
titleRowObject=titleRowObject.parentNode;
}
try{
var titleRowId=titleRowObject.id;
}catch(e){
return;
}
titleRowId=titleRowId.substring(2,titleRowId.length);
var tableObject=titleRowObject.parentNode;
if(tableObject.tagName!="TABLE")tableObject=tableObject.parentNode;
var allTableRows=tableObject.getElementsByTagName("TR");
if(titleRowObject.className.indexOf("treeTableTitleRowOpen")!=-1){
titleRowObject.className=titleRowObject.className.replace("treeTableTitleRowOpen","treeTableTitleRowClosed");
for(i=0;i<allTableRows.length;i++){
parentId=allTableRows[i].getAttribute("parentid");
if(parentId){
if(parentId.indexOf(titleRowId)!=-1){
allTableRows[i].style.display="none";
}
}
}
}else{
titleRowObject.className=titleRowObject.className.replace("treeTableTitleRowClosed","treeTableTitleRowOpen");
for(i=0;i<allTableRows.length;i++){
parentId=allTableRows[i].getAttribute("parentid");
if(parentId){
if(parentId.indexOf(titleRowId)!=-1){
var allParentIds=allTableRows[i].getAttribute("parentid").split("_");
var foundACloserParentThatIsStillClosed=false;
for(var j=0;j<allParentIds.length;j++){
if((allParentIds[j]!="tc")&&(document.getElementById("tc_"+allParentIds[j]).className=="treeTableTitleRowClosed")){
foundACloserParentThatIsStillClosed=true;
}
}
if(!foundACloserParentThatIsStillClosed){
allTableRows[i].style.cssText="display:table-row";
}
}
}
}
}
}
TreeTableManager.prototype.toggleAllTableTrees=function(show){
for(var i=0;i<this.treeControls.length;i++){
var master=this.treeControls[i].master;
if((show&&master.className.indexOf("treeTableTitleRowClosed")>-1)||(!show&&master.className.indexOf("treeTableTitleRowOpen")>-1)){
this.toggleTableTree(null,this.treeControls[i].elem);
}
}
}
