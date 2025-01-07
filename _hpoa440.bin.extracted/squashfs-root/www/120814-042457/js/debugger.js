/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var Schemes={
Amber:'amber',
Black:'black',
Blue:'blue',
Gray:'gray',
Green:'green',
Purple:'purple',
Red:'red',
Terminal:'terminal',
White:'white',
Yellow:'yellow'
};
var DebugOptions={
Theme:'Theme',
Level:'Level',
Severity:'Severity',
AutoFocus:'AutoFocus',
FontSize:'FontSize',
FontFamily:'FontFamily',
AutoExpand:'AutoExpand',
MaxEntries:'MaxEntries'
};
function Debugger(dbgLevel,maxEntries,rootPath,title){
var me=this;
this.entries=new Array();
this.icons=new Object();
this.maxEntries=(existsNonNull(maxEntries)?parseInt(maxEntries):0);
this.title=(existsNonNull(title)?title:"HP GUI Debugger");
this.debugLevel=(!isNaN(dbgLevel)?dbgLevel:0);
this.fixedSeverity=0;
this.rootPath=(rootPath==""?getServiceUrl("",true):rootPath);
this.debugWin=null;
this.loadState="none";
this.forceFocus=false;
this.autoExpand=false;
this.theme=Schemes.White;
this.lineNum=1;
this.width=720;
this.height=screen.height-80;
this.top=0;
this.left=(screen.width-10)-this.width;
this.font="Courier New,monospace";
this.fontSize=12;
this.color="Black";
this.medColor="DarkOrange";
this.hiColor="Red";
this.txtBkgrd="White";
this.winBkgrd="#EFEDED";
for(var i=0;i<9;i++){
this.icons[i]=new Image();
this.icons[i].style.width="13px";
this.icons[i].style.height="13px";
}
this.icons[0].src=this.rootPath+"120814-042457/images/icon_status_unknown.gif";
this.icons[0].tip="Unknown";
this.icons[1].src=this.rootPath+"120814-042457/images/icon_status_informational.gif";
this.icons[1].tip="Information";
this.icons[2].src=this.rootPath+"120814-042457/images/icon_status_normal.gif";
this.icons[2].tip="Normal";
this.icons[3].src=this.rootPath+"120814-042457/images/icon_status_warning.gif";
this.icons[3].tip="Warning";
this.icons[4].src=this.rootPath+"120814-042457/images/icon_status_minor.gif";
this.icons[4].tip="Warning Minor";
this.icons[5].src=this.rootPath+"120814-042457/images/icon_status_major.gif";
this.icons[5].tip="Warning Major";
this.icons[6].src=this.rootPath+"120814-042457/images/icon_status_critical.gif";
this.icons[6].tip="Critical";
this.icons[7].src=this.rootPath+"120814-042457/images/icon_status_critical.gif";
this.icons[7].tip="Fatal";
this.icons[8].src=this.rootPath+"120814-042457/Help/images/topic.gif";
this.icons[8].tip="Verbose Output";
this.icons[8].style.width="11px";
this.icons[8].style.height="14px"
};
function _getOptionsList(){
return "width="+this.width+",height="+this.height+",top="+this.top+
",left="+this.left+",status=no,resizable=yes,scrollbars=yes";
};
function _getContainerStyle(){
return "fontFamily:"+this.font+";backgroundColor:"+this.winBkgrd+
";color:"+this.color+";fontSize:"+this.fontSize+"px;padding:2px;";
};
function _setDebugLevel(dbgLevel){
this.debugLevel=dbgLevel;
};
function _setFontSize(fontSize){
this.fontSize=fontSize;
if(this.debugWin){
try{this.debugWin.top.setContainerStyle(this.getContainerStyle());}catch(e){}
}
};
function _setScheme(scheme){
scheme=(""+scheme).toLowerCase();
this.theme=scheme;
switch(scheme){
case Schemes.Terminal:
this.color="lime";
this.medColor="DarkOrange";
this.hiColor="Red";
this.txtBkgrd="#111";
this.winBkgrd="#000";
break;
case Schemes.Black:
this.color="White";
this.medColor="DarkOrange";
this.hiColor="Red";
this.txtBkgrd="Black";
this.winBkgrd="Black";
break;
case Schemes.Amber:
this.color="Black";
this.medColor="Yellow";
this.hiColor="#940A0A";
this.txtBkgrd="DarkOrange";
this.winBkgrd="#DE7300";
break;
case Schemes.Green:
this.color="Lime";
this.medColor="DarkOrange";
this.hiColor="Red";
this.txtBkgrd="#004400";
this.winBkgrd="#076307";
break;
case Schemes.Blue:
this.color="Aqua";
this.medColor="Orange";
this.hiColor="Yellow";
this.txtBkgrd="MidnightBlue";
this.winBkgrd="#13144D";
break;
case Schemes.Gray:
this.color="Black";
this.medColor="#B76E05";
this.hiColor="Red";
this.txtBkgrd="Gainsboro";
this.winBkgrd="#CAC6C6";
break;
case Schemes.Yellow:
this.color="DarkSlateGray";
this.medColor="DarkOrange";
this.hiColor="Red";
this.txtBkgrd="LemonChiffon";
this.winBkgrd="#FBF199";
break;
case Schemes.Red:
this.color="Lime";
this.medColor="#F5B161";
this.hiColor="#01FFB4";
this.txtBkgrd="#990000";
this.winBkgrd="#750303";
break;
case Schemes.Purple:
this.color="#FFC0FF";
this.medColor="yellow";
this.hiColor="#FF016D";
this.txtBkgrd="#540862";
this.winBkgrd="#4E0551";
break;
case Schemes.White:
default:
this.theme=Schemes.White;
this.color="Black";
this.medColor="DarkOrange";
this.hiColor="Red";
this.txtBkgrd="White";
this.winBkgrd="#EFEDED";
break;
}
if(this.debugWin){
try{this.debugWin.top.setContainerStyle(this.getContainerStyle());}catch(e){}
}
};
function _getTimeStamp(){
var d=new Date();
var dateParts=(d.toTimeString().split(" "));
return "("+dateParts[0]+")";
};
function _getIcon(doc,severity){
var icon=doc.createElement("img");
try{
icon.style.width=this.icons[severity].style.width;
icon.style.height=this.icons[severity].style.height;
icon.src=this.icons[severity].src;
icon.title=this.icons[severity].tip;
}catch(e){
icon.style.width=this.icons[0].style.width;
icon.style.height=this.icons[0].style.height;
icon.src=this.icons[0].src;
icon.title=this.icons[0].tip;
}
return icon;
};
function _getExpander(doc,targetId){
var div=doc.createElement("div");
var expanderDiv=doc.createElement("div");
var anchor=doc.createElement("a");
expanderDiv.id=targetId;
anchor.href="javascript:void(0);";
anchor.title="Click to Show, Hover to Hide";
anchor.style.color=this.medColor;
if(anchor.attachEvent){
anchor.attachEvent("onmouseover",function(){
anchor.nextSibling.nextSibling.style.display='none';
anchor.innerHTML='More ...';
});
anchor.attachEvent("onclick",function(){
anchor.nextSibling.nextSibling.style.display='block';
anchor.innerHTML='Less ...';
});
}else{
anchor.onmouseover=function(){
this.nextSibling.nextSibling.style.display='none';
this.innerHTML='More ...';}
anchor.onclick=function(){
this.nextSibling.nextSibling.style.display='block';
this.innerHTML='Less ...';}
}
if(this.autoExpand==true){
anchor.appendChild(doc.createTextNode("Less ..."));
}else{
anchor.appendChild(doc.createTextNode("More ..."));
}
div.appendChild(anchor);
div.appendChild(doc.createElement("br"));
div.appendChild(expanderDiv);
return[div,anchor,expanderDiv];
};
function _showDebugWindow(){
this.logEntry("Debugger launched remotely.",null,0,1);
};
function _popEntries(){
for(var index in this.entries){
var entry=this.entries[index];
this.logEntry(entry.data,entry.encNum,entry.dbgLevel,entry.severity);
}
};
function _logEntry(data,encNum,dbgLevel,severity){
if(!existsNonNull(dbgLevel)){
var dbgLevel=1;
}
if(!existsNonNull(severity)){
var severity=1;
}
var encLabel=(existsNonNull(encNum)?" Enc: "+encNum:"");
try{
if(this.debugWin==null){
var now=new Date();
var url=(window.location.hostname==""?"Running Locally":window.location.hostname);
this.debugWin=window.open(this.rootPath+"120814-042457/html/debugger.html?title="+url,"dbgWin"+now.getMilliseconds(),this.getOptionsList());
}
if(this.loadState!="loaded"){
try{
this.loadState=this.debugWin.top.getLoadState();
}catch(e){
this.entries.push(new EntryObject(data,encNum,dbgLevel,severity));
return;
}
if(this.loadState=='initialized'){
this.loadState="loaded";
this.lineNum=1;
this.debugWin.top.setContainerStyle(this.getContainerStyle());
this.entries.push(new EntryObject(data,encNum,dbgLevel,severity));
this.popEntries();
return;
}
}
if(this.fixedSeverity!=0&&this.fixedSeverity!=severity){
return;
}else if(!(dbgLevel<=this.debugLevel)){
return;
}
var doc=this.debugWin.document;
if((this.maxEntries>0?this.lineNum<=this.maxEntries:true)){
var line=doc.createElement("div");
var icon=this.getIcon(doc,severity);
var textNode=doc.createTextNode("  "+this.lineNum+++".\t"+this.getTimeStamp()+" ");
line.appendChild(icon);
line.appendChild(textNode);
line.setAttribute("severity",severity);
if(isArray(data)||(typeof(data)=="object"&&data.length!=undefined)){
line.appendChild(doc.createTextNode(data[0]+encLabel));
line.appendChild(doc.createElement("br"));
var extraLine=this.getExpander(doc,"extra"+this.lineNum);
for(var i=1;i<data.length;i++){
extraLine[2].appendChild(doc.createElement("br"));
extraLine[2].appendChild(doc.createTextNode(data[i]));
}
line.appendChild(extraLine[0]);
extraLine[2].setAttribute("extra",true);
extraLine[2].style.fontFamily=this.font;
extraLine[2].style.display=(this.autoExpand?"block":"none");
}else{
line.appendChild(doc.createTextNode((data?data:"[No Data]")+encLabel));
}
var altColor=(this.lineNum%2==0?this.winBkgrd:this.txtBkgrd);
var foreColor=this.color;
if(severity==8||severity==5){
foreColor=this.medColor;
}else if(severity>5){
foreColor=this.hiColor;
}
line.style.fontFamily=this.font;
line.style.backgroundColor=altColor;
line.style.width=(document.all?"100%":"99%");
line.style.padding="5px 0px 2px 5px";
line.style.color=foreColor;
this.debugWin.top.addEntry(line);
}
if(this.forceFocus==true){
this.debugWin.focus();
}
}catch(err){
this.loadState="none";
this.debugWin=null;
}
};
Debugger.prototype.logEntry=_logEntry;
Debugger.prototype.getIcon=_getIcon;
Debugger.prototype.getExpander=_getExpander;
Debugger.prototype.getTimeStamp=_getTimeStamp;
Debugger.prototype.getOptionsList=_getOptionsList;
Debugger.prototype.getContainerStyle=_getContainerStyle;
Debugger.prototype.setDebugLevel=_setDebugLevel;
Debugger.prototype.setFontSize=_setFontSize;
Debugger.prototype.showWindow=_showDebugWindow;
Debugger.prototype.popEntries=_popEntries;
Debugger.prototype.setScheme=_setScheme;
function EntryObject(data,encNum,dbgLevel,severity){
this.data=data;
this.encNum=encNum;
this.dbgLevel=dbgLevel;
this.severity=severity;
};
var dbgObj=null;
var debugListeners=null;
var gDebugReady=false;
var gDebugOn=(encodeURI(top.location.href).indexOf('debug=true')>-1);
var colors=['amber','black','blue','gray',
'green','red','terminal','white','yellow'];
function debugIsActive(){
return gDebugOn;
};
function registerDebugListener(callback){
if(debugListeners==null){
debugListeners=new ListenerCollection();
}
debugListeners.addListener(callback,["DEBUG_MODE_CHANGED"]);
};
function toggleDebugger(debugState){
gDebugOn=parseBool(debugState);
debugListeners.debugging=gDebugOn;
debugListeners.callListeners("DEBUG_MODE_CHANGED",gDebugOn);
logEvent("JavaScript Debugger toggled "+(gDebugOn==true?"on.":"off."),null,1,1);
};
function setDebugOption(debugOption,value){
switch(debugOption){
case DebugOptions.Theme:
getDebugger().setScheme(value);
break;
case DebugOptions.Level:
getDebugger().setDebugLevel(value);
break;
case DebugOptions.Severity:
getDebugger().fixedSeverity=value;
break;
case DebugOptions.AutoFocus:
getDebugger().forceFocus=parseBool(value);
break;
case DebugOptions.FontSize:
getDebugger().setFontSize(value);
break;
case DebugOptions.FontFamily:
getDebugger().font=value;
break;
case DebugOptions.AutoExpand:
getDebugger().autoExpand=parseBool(value);
break;
case DebugOptions.MaxEntries:
getDebugger().maxEntries=value;
break;
}
};
function getDebugger(){
if(dbgObj==null){
dbgObj=new Debugger(6,0,(typeof(gRootPath)=="undefined"?"":gRootPath));
}
return dbgObj;
};
function logEvent(data,encNum,debugLevel,severity){
if(debugIsActive()==true&&gDebugReady==true){
if(dbgObj==null){
var rootPath=(typeof(gRootPath)=='undefined'?"":gRootPath);
var locationHref=encodeURI(top.location.href);
dbgObj=new Debugger(6,0,rootPath);
var dbgLvl=getSearchValue(locationHref,'level');
if(dbgLvl!=""){
dbgObj.setDebugLevel(dbgLvl);
};
var scheme=getSearchValue(locationHref,'color');
if(scheme!=""){
dbgObj.setScheme(scheme);
}else{
}
var forceFocus=getSearchValue(locationHref,'focus');
if(forceFocus!=""){
dbgObj.forceFocus=parseBool(forceFocus);
}
var autoExpand=getSearchValue(locationHref,'expand');
if(autoExpand!=""){
dbgObj.autoExpand=parseBool(autoExpand);
}
var maxEntries=getSearchValue(locationHref,'max');
if(maxEntries!=""){
dbgObj.maxEntries=maxEntries;
}
var fontFamily=getSearchValue(locationHref,'font');
if(fontFamily!=""){
dbgObj.font=unescape(fontFamily);
}
var fontSize=getSearchValue(locationHref,'fontsize');
if(fontSize!=""){
dbgObj.fontSize=fontSize;
}
var fixedSeverity=getSearchValue(locationHref,'severity');
if(fixedSeverity!=""){
dbgObj.fixedSeverity=fixedSeverity;
}
}
dbgObj.logEntry(data,encNum,debugLevel,severity);
}
};
