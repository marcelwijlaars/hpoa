/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function TableManager(){
this.scrollableTableIds=null;
this.systemStatusTables=new Array();
this.systemStatusTableIds=new Array();
}
TableManager.prototype.init=function(){
var index=0;
var table=null;
var tableId="";
var cellNodeCollection=null;
var inputNodeCollection=null;
var tableNodeCollection=window.document.getElementsByTagName("table");
this.scrollableTableIds=new Array();
for(var i=0;i<tableNodeCollection.length;i++){
if(tableNodeCollection[i].className.indexOf("scrollingTable")!=-1){
table=tableNodeCollection[i];
tableId=table.getAttribute('id');
this.scrollableTableIds[this.scrollableTableIds.length]=tableId;
var tableScrollingDiv=document.getElementById(tableId+"_scrollingTableDiv");
eval("document.getElementById(tableId + '_scrollingTableDiv').onscroll=function() {ourTableManager.slideColumns('"+tableId+"')}");
}
if(tableNodeCollection[i].className.indexOf("systemStatus")!=-1){
this.systemStatusTables[index]=tableNodeCollection[i];
this.systemStatusTableIds[index]=tableNodeCollection[i].getAttribute('id');
index++;
}
}
for(i=0;i<this.systemStatusTables.length;i++){
cellNodeCollection=this.systemStatusTables[i].getElementsByTagName("td");
for(var j=0;j<cellNodeCollection.length;j++){
if(cellNodeCollection[j].getAttribute('id')&&
(cellNodeCollection[j].className=='deviceCell'||
cellNodeCollection[j].className=='deviceCellDS'))
cellNodeCollection[j].onclick=function(mozEvent){ourTableManager.selectCell(mozEvent);};
}
}
inputNodeCollection=window.document.getElementsByTagName("input");
for(i=0;i<inputNodeCollection.length;i++){
var chk;
if(inputNodeCollection[i].getAttribute('tableid')){
chk=inputNodeCollection[i];
tableId=chk.getAttribute("tableid");
if(tableId){
eval("chk.onclick = function(mozEvent) {ourTableManager.tableCheckboxToggleAll(mozEvent,this,'"+tableId+"');};");
}
else alert('error: table has checkbox but checkbox has no tableid');
}
if(inputNodeCollection[i].getAttribute('allowRowSelect')){
if(inputNodeCollection[i].getAttribute('allowRowSelect')=='false'){
continue;
}
}
if(inputNodeCollection[i].getAttribute('rowselector')=="yes"){
if(((inputNodeCollection[i].checked)||(inputNodeCollection[i].value=="1"))&&(inputNodeCollection[i].parentNode.parentNode.className.indexOf("rowHighlight")==-1)){
appendClassName(inputNodeCollection[i].parentNode.parentNode,"rowHighlight");
}
else if(((!inputNodeCollection[i].checked)&&(inputNodeCollection[i].value!="1"))&&(inputNodeCollection[i].parentNode.parentNode.className.indexOf("rowHighlight")!=-1)){
removeClassName(inputNodeCollection[i].parentNode.parentNode,"rowHighlight");
}
inputNodeCollection[i].onclick=function(mozEvent){ourTableManager.tableRowHighlightToggle(mozEvent,this.parentNode.parentNode,true);};
var checkingForPropertyViewTable=inputNodeCollection[i].parentNode;
var isPropertyViewTable=false;
while(checkingForPropertyViewTable.tagName!="TABLE"){
checkingForPropertyViewTable=checkingForPropertyViewTable.parentNode;
if(checkingForPropertyViewTable==null){return false;}
}
if(checkingForPropertyViewTable.className.indexOf("propertyViewTable")!=-1)isPropertyViewTable=true;
inputNodeCollection[i].parentNode.parentNode.onclick=function(mozEvent){return ourTableManager.tableRowHighlightToggle(mozEvent,this,true);};
if(isPropertyViewTable){
if(!document.all){
inputNodeCollection[i].parentNode.parentNode.onmousedown=function(mozEvent){return false;};
}
}
}
}
this.windowResize();
}
TableManager.prototype.windowResize=function(){
var visualHeaderScrollingDiv=null;
var tableScrollingDiv=null;
var availableWidth=0;
var table=null;
var i;
for(i=0;i<this.scrollableTableIds.length;i++){
visualHeaderScrollingDiv=document.getElementById(this.scrollableTableIds[i]+"_headerDiv");
tableScrollingDiv=document.getElementById(this.scrollableTableIds[i]+"_scrollingTableDiv");
table=document.getElementById(this.scrollableTableIds[i]);
if(tableScrollingDiv&&tableScrollingDiv.className.indexOf("liquidHeight")!=-1){
tableScrollingDiv.style.height=Math.max(20,this.getContainersAvailableHeight(tableScrollingDiv)-visualHeaderScrollingDiv.offsetHeight-100)+"px";
}
if(tableScrollingDiv&&tableScrollingDiv.className.indexOf("liquidWidth")!=-1){
availableWidth=this.getContainersAvailableWidth(tableScrollingDiv);
visualHeaderScrollingDiv.style.width=parseInt(availableWidth/2)+"px";
tableScrollingDiv.style.width=parseInt(availableWidth/2)+"px";
}
}
availableWidth=0;
for(i=0;i<this.scrollableTableIds.length;i++){
visualHeaderScrollingDiv=document.getElementById(this.scrollableTableIds[i]+"_headerDiv");
tableScrollingDiv=document.getElementById(this.scrollableTableIds[i]+"_scrollingTableDiv");
table=document.getElementById(this.scrollableTableIds[i]);
if(tableScrollingDiv&&tableScrollingDiv.className.indexOf("liquidWidth")!=-1){
if(availableWidth==0||tableScrollingDiv.className.indexOf("masterWidth")==-1){
availableWidth=this.getContainersAvailableWidth(tableScrollingDiv);
}
visualHeaderScrollingDiv.style.width=availableWidth+"px";
tableScrollingDiv.style.width=availableWidth+"px";
var dummyRow=document.getElementById(table.id+"_dummyRow");
for(var k=0;k<dummyRow.childNodes.length;k++){
if(dummyRow.childNodes[k].nodeType==1){
dummyRow.childNodes[k].style.width="";
}
if(dummyRow.childNodes[k].childNodes[0].nodeType&&dummyRow.childNodes[k].childNodes[0].nodeType==1){
dummyRow.childNodes[k].childNodes[0].style.width="";
}
}
var headerDivs=document.getElementById(table.id+"_headerDiv").childNodes[0].childNodes;
for(var j=0;j<headerDivs.length;j++){
if(headerDivs[j].nodeType&&headerDivs[j].nodeType==1){
headerDivs[j].style.width="";
}
}
var minWidth=table.getAttribute('min-width');
if(minWidth==null||isNaN(parseInt(minWidth))){
minWidth=100;
}else{
minWidth=parseInt(minWidth);
}
table.style.width=(availableWidth>=minWidth?"100%":minWidth+"px");
this.resizeTableColumns(table.id);
}
if(tableScrollingDiv&&tableScrollingDiv.className.indexOf("liquidHeight")!=-1){
this.adjustScrollingTableHeight(tableScrollingDiv);
if((table.offsetHeight+visualHeaderScrollingDiv.offsetHeight)<tableScrollingDiv.offsetHeight){
tableScrollingDiv.style.height="";
}
}
this.slideColumns(this.scrollableTableIds[i]);
}
}
TableManager.prototype.getYOffset=function(obj){
var offsetY=0;
if(obj.offsetParent){
while(obj.offsetParent){
offsetY+=obj.offsetTop
obj=obj.offsetParent;
}
}else if(obj.y){
offsetY+=obj.y;
}
return offsetY;
}
TableManager.prototype.adjustScrollingTableHeight=function(obj){
var pageHeight=0;
var minHeight=60;
var objTop=this.getYOffset(obj);
var padBottom=obj.getAttribute('pad-bottom');
if(padBottom!=null&&!isNaN(parseInt(padBottom))){
padBottom=parseInt(padBottom);
}else{
padBottom=0;
}
if(obj.ownerDocument.defaultView){
pageHeight=obj.ownerDocument.defaultView.innerHeight;
}else if(obj.document.documentElement&&obj.document.documentElement.clientHeight>0){
pageHeight=obj.document.documentElement.clientHeight;
}else if(obj.document.body){
pageHeight=obj.document.body.clientHeight;
}
top.logEvent("Table Manager: page height: "+pageHeight,null,1,6);
var calcHeight=(pageHeight-objTop-padBottom);
obj.style.height=(calcHeight>=minHeight?calcHeight:minHeight)+"px";
}
TableManager.prototype.getContainersAvailableWidth=function(element){
var parent=element.offsetParent;
var paddingAndBorder=0;
if(document.all){
if(parseInt(parent.currentStyle.paddingLeft)){
paddingAndBorder+=parseInt(parent.currentStyle.paddingLeft);
}
if(parseInt(parent.currentStyle.paddingRight)){
paddingAndBorder+=parseInt(parent.currentStyle.paddingRight);
}
if(parseInt(parent.currentStyle.borderLeftWidth)){
paddingAndBorder+=parseInt(parent.currentStyle.borderLeftWidth);
}
if(parseInt(parent.currentStyle.borderRightWidth)){
paddingAndBorder+=parseInt(parent.currentStyle.borderRightWidth);
}
}
else{
paddingAndBorder=
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("padding-left"))+
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("padding-right"))+
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("border-left-width"))+
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("border-right-width"));
}
if(isNaN(paddingAndBorder))paddingAndBorder=0;
return Math.max(0,parent.offsetWidth-paddingAndBorder);
}
TableManager.prototype.getContainersAvailableHeight=function(element){
var parent=element.offsetParent;
var paddingAndBorder=0;
if(document.all){
if(parseInt(parent.currentStyle.paddingTop)){
paddingAndBorder+=parseInt(parent.currentStyle.paddingTop);
}
if(parseInt(parent.currentStyle.paddingBottom)){
paddingAndBorder+=parseInt(parent.currentStyle.paddingBottom);
}
if(parseInt(parent.currentStyle.borderTopWidth)){
paddingAndBorder+=parseInt(parent.currentStyle.borderTopWidth);
}
if(parseInt(parent.currentStyle.borderBottomWidth)){
paddingAndBorder+=parseInt(parent.currentStyle.borderBottomWidth);
}
}
else{
paddingAndBorder=
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("padding-top"))+
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("padding-bottom"))+
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("border-top-width"))+
parseInt(document.defaultView.getComputedStyle(parent,'').getPropertyValue("border-bottom-width"));
}
if(isNaN(paddingAndBorder))paddingAndBorder=0;
return Math.max(1,parent.offsetHeight-paddingAndBorder);
}
TableManager.prototype.resizeTableColumns=function(tableId){
var tableDummyRow=document.getElementById(tableId+"_dummyRow");
var visualHeaderDivParent=document.getElementById(tableId+"_headerDiv");
var visualHeaderDiv=visualHeaderDivParent.childNodes[0];
var table=document.getElementById(tableId);
var tableScrollingDiv=document.getElementById(tableId+"_scrollingTableDiv");
visualHeaderDivParent.style.width=visualHeaderDivParent.offsetWidth;
visualHeaderDiv.style.width=2*table.offsetWidth+"px";
var maxScreenDivHeight=0;
for(var i=0;i<visualHeaderDiv.childNodes.length;i++){
if(visualHeaderDiv.childNodes[i].nodeType==1){
maxScreenDivHeight=Math.max(maxScreenDivHeight,visualHeaderDiv.childNodes[i].offsetHeight);
}
}
visualHeaderDiv.style.height=maxScreenDivHeight+"px";
var extraWidthForFirstHeader=2;
if(!document.all)extraWidthForFirstHeader=0;
for(i=0;i<tableDummyRow.childNodes.length;i++){
var tableColumnWidth=tableDummyRow.childNodes[i].offsetWidth;
var visualHeaderDivWidth=visualHeaderDiv.childNodes[i].offsetWidth;
if(tableDummyRow.childNodes[i].nodeType==1){
if(visualHeaderDivWidth>tableColumnWidth){
tableDummyRow.childNodes[i].childNodes[0].style.width=(visualHeaderDivWidth-10)+"px";
tableDummyRow.childNodes[i].style.width=(visualHeaderDivWidth-10)+"px";
}
else{
visualHeaderDiv.childNodes[i].style.width=tableDummyRow.childNodes[i].offsetWidth+extraWidthForFirstHeader-((document.all)?0:1)+"px";
}
extraWidthForFirstHeader=0;
visualHeaderDiv.childNodes[i].style.height=maxScreenDivHeight+"px";
}
}
}
TableManager.prototype.slideColumns=function(tableId){
var visualHeaderDivParent=document.getElementById(tableId+"_headerDiv");
if(visualHeaderDivParent){
var slidingColumnHeaders=visualHeaderDivParent.childNodes[0];
var scrollingDiv=document.getElementById(tableId+"_scrollingTableDiv");
slidingColumnHeaders.style.left=-scrollingDiv.scrollLeft;
var tableScrollingDiv=document.getElementById(tableId+"_scrollingTableDiv");
visualHeaderDivParent.style.width=tableScrollingDiv.offsetWidth+"px";
}
}
TableManager.prototype.clearHighlight=function(){
for(var i=0;i<this.systemStatusTableIds.length;i++){
if(this.systemStatusTableIds[i]){
tableNode=document.getElementById(this.systemStatusTableIds[i]);
if(tableNode){
cellNodeCollection=tableNode.getElementsByTagName("td");
for(var j=0;j<cellNodeCollection.length;j++){
if(cellNodeCollection[j].className.indexOf("deviceCellDSHighlight")!=-1){
removeClassName(cellNodeCollection[j],"deviceCellDSHighlight");
appendClassName(cellNodeCollection[j],"deviceCellDS");
}else{
removeClassName(cellNodeCollection[j],"deviceCellHighlight");
}
removeClassName(cellNodeCollection[j],"deviceCellDashed");
}
}
}
}
}
TableManager.prototype.toggleCellHighlight=function(statusCell){
for(var i=0;i<this.systemStatusTableIds.length;i++){
if(this.systemStatusTableIds[i]){
tableNode=document.getElementById(this.systemStatusTableIds[i]);
if(tableNode){
cellNodeCollection=tableNode.getElementsByTagName("td");
for(var j=0;j<cellNodeCollection.length;j++){
if(cellNodeCollection[j].className.indexOf("deviceCellDSHighlight")!=-1){
removeClassName(cellNodeCollection[j],"deviceCellDSHighlight");
appendClassName(cellNodeCollection[j],"deviceCellDS");
}else{
removeClassName(cellNodeCollection[j],"deviceCellHighlight");
}
removeClassName(cellNodeCollection[j],"deviceCellDashed");
}
}
}
}
if(statusCell.className.indexOf("deviceCellDS")!=-1){
removeClassName(statusCell,"deviceCellDS");
appendClassName(statusCell,"deviceCellDSHighlight");
}else{
appendClassName(statusCell,"deviceCellHighlight");
}
}
TableManager.prototype.selectCell=function(mozEvent){
var eventSource=getEventOriginator(mozEvent);
var statusCell=null;
if(eventSource.tagName=="TD"&&(eventSource.className.indexOf("deviceCell")==0)){
statusCell=eventSource;
}
else{
var tempNode=eventSource.parentNode;
if(eventSource.tagName=="INPUT")return;
while(tempNode.className.indexOf("deviceCell")<0){
tempNode=tempNode.parentNode;
if(tempNode==null)return;
}
statusCell=tempNode;
}
if(statusCell){
var devNum=statusCell.getAttribute('devNum');
var encNum=statusCell.getAttribute('encNum');
var devType=statusCell.getAttribute('devType');
top.mainPage.getHiddenFrame().selectDevice(devNum,devType,encNum,true);
}
}
TableManager.prototype.selectCellById=function(devId){
if(devId&&ourTableManager.containsNode(devId)){
statusCell=document.getElementById(devId);
ourTableManager.toggleCellHighlight(statusCell);
}
else{
ourTableManager.clearHighlight();
}
}
TableManager.prototype.dashCellById=function(devId){
if(devId&&ourTableManager.containsNode(devId)){
statusCell=document.getElementById(devId);
appendClassName(statusCell,"deviceCellDashed");
}
}
TableManager.prototype.containsNode=function(nodeId){
for(var i=0;i<this.systemStatusTableIds.length;i++){
if(this.systemStatusTableIds[i]){
tableNode=document.getElementById(this.systemStatusTableIds[i]);
if(tableNode){
cellNodeCollection=tableNode.getElementsByTagName("td");
for(var j=0;j<cellNodeCollection.length;j++){
var devId=cellNodeCollection[j].getAttribute('id');
if(devId){
if(devId==nodeId)
return true;
}
}
}
}
}
return false;
}
TableManager.prototype.tableCheckboxToggleAll=function(mozEvent,masterCheckbox,uniqueTableId){
var tableNode=document.getElementById(uniqueTableId);
var inputNodeCollection=null;
if(tableNode){
inputNodeCollection=tableNode.getElementsByTagName("input");
for(var i=0;i<inputNodeCollection.length;i++){
if(inputNodeCollection[i].getAttribute('type')=="checkbox"){
if(inputNodeCollection[i].getAttribute('allowRowSelect')){
if(inputNodeCollection[i].getAttribute('allowRowSelect')=='false'){
continue;
}
}
if(masterCheckbox!=inputNodeCollection[i]){
if(inputNodeCollection[i].getAttribute("rowselector")=="yes"){
if(masterCheckbox.checked!=inputNodeCollection[i].checked){
this.tableRowHighlightToggle(mozEvent,inputNodeCollection[i].parentNode.parentNode,false);
}
}
}
}
}
}
}
TableManager.prototype.tableRowHighlightToggle=function(mozEvent,rowElement,checkOrigination){
var eventSource=getEventOriginator(mozEvent);
var inputNodeCollection=null;
var tableRowNode=null;
var i=0;
var j=0;
if((eventSource.tagName=="SELECT")||(eventSource.tagName=="OPTION")||((eventSource.tagName=="DIV")&&(eventSource.className=="treeControl"))){
return false;
}
if(eventSource.tagName=="A"){return true;}
var tableNode=rowElement.parentNode;
if(!tableNode){return false;}
while(tableNode.tagName!="TABLE"){
tableNode=tableNode.parentNode;
if(tableNode==null){return false;}
}
var isPropertyViewTable=(tableNode.className.indexOf("propertyViewTable")!=-1);
inputNodeCollection=rowElement.getElementsByTagName("input");
var ourRowSelectorFormElement;
for(i=0;i<inputNodeCollection.length;i++){
if(inputNodeCollection[i].getAttribute("rowselector")=="yes"){
ourRowSelectorFormElement=inputNodeCollection[i];
}
}
if((eventSource.tagName!="INPUT")||((eventSource.tagName=="INPUT")&&(eventSource.getAttribute("tableid")))){
if(ourRowSelectorFormElement.getAttribute("type")=="checkbox"){
ourRowSelectorFormElement.checked=!ourRowSelectorFormElement.checked;
}
if(ourRowSelectorFormElement.getAttribute("type")=="radio"){
ourRowSelectorFormElement.checked=!ourRowSelectorFormElement.checked;
}
else if(ourRowSelectorFormElement.getAttribute("type")=="hidden"){
if(ourRowSelectorFormElement.value=="1")ourRowSelectorFormElement.value=0;
else ourRowSelectorFormElement.value="1";
}
}
if(isPropertyViewTable){
var ctrlKey=(document.all)?window.event.ctrlKey:mozEvent.ctrlKey;
if(!ctrlKey){
inputNodeCollection=tableNode.getElementsByTagName("INPUT");
for(j=0;j<inputNodeCollection.length;j++){
if((inputNodeCollection[j].getAttribute("type")=="hidden")&&(inputNodeCollection[j].getAttribute("rowselector")=="yes")){
tableRowNode=inputNodeCollection[j].parentNode;
while(tableRowNode.tagName!="TR"){tableRowNode=tableRowNode.parentNode;
if(tableRowNode==null){return false;}
}
if(inputNodeCollection[j]!=ourRowSelectorFormElement){
removeClassName(tableRowNode,"rowHighlight");
inputNodeCollection[j].value="0";
}
else{
appendClassName(tableRowNode,"rowHighlight");
}
}
}
}
else{
if(rowElement.className.indexOf("rowHighlight")!=-1){
removeClassName(rowElement,"rowHighlight");
rowElement.value="0";
}
else{
appendClassName(rowElement,"rowHighlight");
rowElement.value="1";
}
}
}
else{
if(ourRowSelectorFormElement.checked){
if((ourRowSelectorFormElement.getAttribute("type")=="checkbox")||(ourRowSelectorFormElement.getAttribute("type")=="hidden")){
appendClassName(rowElement,"rowHighlight");
}
else{
inputNodeCollection=tableNode.getElementsByTagName("INPUT");
for(j=0;j<inputNodeCollection.length;j++){
if(inputNodeCollection[j].getAttribute("type")=="radio"){
tableRowNode=inputNodeCollection[j].parentNode.parentNode;
if(!inputNodeCollection[j].checked){
removeClassName(tableRowNode,"rowHighlight");
}
else{
appendClassName(tableRowNode,"rowHighlight");
}
}
}
}
}
else{
removeClassName(rowElement,"rowHighlight");
}
}
if(checkOrigination){
var checkedCount=0;
var totalCount=0;
inputNodeCollection=tableNode.getElementsByTagName('input');
for(i=0;i<inputNodeCollection.length;i++){
if((inputNodeCollection[i].getAttribute('type')=='checkbox'||inputNodeCollection[i].getAttribute('type')=='radio')&&!inputNodeCollection[i].getAttribute('tableid')){
totalCount++;
if(inputNodeCollection[i].checked){
checkedCount++;
}
}
}
for(i=0;i<inputNodeCollection.length;i++){
if(inputNodeCollection[i].getAttribute('tableid')){
inputNodeCollection[i].checked=(checkedCount==totalCount)?true:false;
break;
}
}
}
}
function tableManager_windowResize(){
ourTableManager.windowResize();
}
