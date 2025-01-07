/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var LogDeviceType={OA:0,
iLO:1
}
var PowerUnits={
WATTS:"watts",
AMPS:"amps",
BTUS:"btus"
}
function LineChart(logDeviceType,log,elementID,elementIdIn,sideA,sideB){
var me=this;
var iloLog=null;
var oaLog=null;
var maxColor="#cc0066";
var midColor="#1c6be3";
var minColor="#acbad2";
var capColor="#000000";
var deratedColor="#58c380";
var ratedColor="#1b763d";
var bottomPad=20;
var powerUnits=PowerUnits.WATTS;
var voltageFactor=220;
if(logDeviceType==LogDeviceType.iLO){iloLog=log;}
else{oaLog=log;}
var avgArray=null;
var maxArray=null;
var minArray=null;
var capArray=null;
var deratedArray=null;
var ratedArray=null;
var temperatureArray=null;
var timeArray=null;
var minValue=50000;
var maxValue=-1;
var minTemp=50000;
var maxTemp=-1;
var maxScale;
var minScale;
var showMin=false;
var showAvg=true;
var showPeak=true;
var showCap=true;
var showDerated=true;
var showRated=true;
var barWidth=null;
var graphTitle=null;
var showSideA=sideA;
var showSideB=sideB;
var tipTime=top.getString('tipTime');
var tipPeak=top.getString('tipPeakPower');
var tipMin=top.getString('tipMinPower');
var tipAverage=top.getString('tipAveragePower');
var tipCap=top.getString('tipPowerCap');
var tipNoCap=top.getString('tipNoCapSet');
var tipDerated=top.getString('tipDerated');
var tipNoDerated=top.getString('tipNoDerated');
var tipRated=top.getString('tipRated');
var tipNoRated=top.getString('tipNoRated');
var unitsWatts=top.getString('watts');
var unitsAmps=top.getString('amps');
var unitsBTUs=top.getString('btus');
function getIloArray(objArray){
var charToRemove='"';
var regExp=new RegExp("["+charToRemove+"]","g");
avgArray=new Array();
maxArray=new Array();
for(var i=0;i<objArray.length;i++){
var time=getElementValueXpath(objArray[i],'//TIME');
var avgp=getElementValueXpath(objArray[i],'//AVGP');
var maxp=getElementValueXpath(objArray[i],'//MAXP');
time=parseInt(time.replace(regExp,""));
avgp=parseInt(avgp.replace(regExp,""));
maxp=parseInt(maxp.replace(regExp,""));
if(avgp<minValue){minValue=avgp;}
if(maxp>maxValue){maxValue=maxp;}
avgArray[avgArray.length]=[time,avgp];
maxArray[maxArray.length]=[time,maxp];
}
}
function sortObjArray(a,b){
var x=a.documentElement.getAttribute("hpoa:timeStamp");
var y=b.documentElement.getAttribute("hpoa:timeStamp");
return((x<y)?-1:((x>y)?1:0));
}
function sortCapArray(a,b){
var x=a[0];
var y=b[0];
return((x<y)?-1:((x>y)?1:0));
}
function getFormattedDateTime(time){
var indexT=time.indexOf('T');
if(indexT<0)return date;
return time.substring(0,indexT)+" "+time.substring(indexT+1,indexT+9);
}
function sortBarArrayDescend(a,b){
var x=a.height;
var y=b.height;
return((x>y)?-1:((x<y)?1:0));
}
function getOaArray(objArray){
avgArray=new Array();
maxArray=new Array();
minArray=new Array();
capArray=new Array();
deratedArray=new Array();
ratedArray=new Array();
temperatureArray=new Array();
timeArray=new Array();
objArray=objArray.sort(sortObjArray);
var groupCaps=getArrayXpath(oaLog,"//hpoa:enclosurePowerRecords/hpoa:extraData[contains(@hpoa:name, 'groupCap_')]");
var groupDerateds=getArrayXpath(oaLog,"//hpoa:enclosurePowerRecords/hpoa:extraData[contains(@hpoa:name, 'groupDerated_')]");
var groupRateds=getArrayXpath(oaLog,"//hpoa:enclosurePowerRecords/hpoa:extraData[contains(@hpoa:name, 'groupRated_')]");
var psLefts=getArrayXpath(oaLog,"//hpoa:enclosurePowerRecords/hpoa:extraData[contains(@hpoa:name, 'numActivePSLeft_')]");
var psRights=getArrayXpath(oaLog,"//hpoa:enclosurePowerRecords/hpoa:extraData[contains(@hpoa:name, 'numActivePSRight_')]");
for(var i=0;i<objArray.length;i++){
var time=objArray[i].documentElement.getAttribute("hpoa:timeStamp");
var minp=objArray[i].documentElement.getAttribute("hpoa:minWattage");
var avgp=objArray[i].documentElement.getAttribute("hpoa:averageWattage");
var maxp=objArray[i].documentElement.getAttribute("hpoa:peakWattage");
var temp=objArray[i].documentElement.getAttribute("hpoa:ambientTemperature");
var capp=Nz(parseInt(groupCaps[i]));
var deratedp=Nz(parseInt(groupDerateds[i]));
var ratedp=Nz(parseInt(groupRateds[i]));
var leftActive=parseInt(psLefts[i]);
var rightActive=parseInt(psRights[i]);
if(isNaN(leftActive)||isNaN(rightActive))leftActive=rightActive=1;
if(leftActive==0||rightActive==0)minValue=0;
minp=parseInt(minp);
avgp=parseInt(avgp);
maxp=parseInt(maxp);
var leftmaxp=maxp*leftActive/(leftActive+rightActive);
var rightmaxp=maxp*rightActive/(leftActive+rightActive);
if(!(showSideA&&showSideB)){
if(showSideA)maxp=leftmaxp;
if(showSideB)maxp=rightmaxp;
}
temp=parseInt(temp);
minValue=Math.min(minValue,minp,avgp,maxp,leftmaxp,rightmaxp);
if(capp>0)minValue=Math.min(minValue,capp);
maxValue=Math.max(maxValue,minp,avgp,maxp,capp,deratedp,ratedp);
minTemp=Math.min(minTemp,temp);
maxTemp=Math.max(maxTemp,temp);
avgArray[avgArray.length]=[i,avgp];
maxArray[maxArray.length]=[i,maxp];
minArray[minArray.length]=[i,minp];
capArray[capArray.length]=[i,capp];
deratedArray[deratedArray.length]=[i,deratedp];
ratedArray[ratedArray.length]=[i,ratedp];
temperatureArray[temperatureArray.length]=[i,temp];
timeArray[timeArray.length]=[i,getFormattedDateTime(time)];
}
}
function reloadData(){
minValue=5000;
maxValue=-1;
if(iloLog){
var iloNodes=deCompileXmlArray(iloLog,'//GET_PWREG_HISTORY','SMPL');
getIloArray(iloNodes);
}else{
var oaNodes=deCompileXmlArray(oaLog,'//hpoa:enclosurePowerRecords','hpoa:enclosurePowerRecord');
getOaArray(oaNodes);
}
minValue=(minValue*4)/5;
minScale=minValue;
if(minScale>20){
minScale-=5;
}
maxScale=maxValue+5;
}
reloadData();
this.getMaxScale=function(){
if(powerUnits!=PowerUnits.AMPS)return maxScale;
var amps=maxScale/voltageFactor;
var maxAmps=20;
if(amps>maxAmps)maxAmps=30;
if(amps>maxAmps)maxAmps=40;
if(amps>maxAmps)maxAmps=50;
return maxAmps*voltageFactor;
}
this.getYTicks=function(){
var minTick=bottomPad;
var maxTick=maxValue-minValue+bottomPad;
var midTick=(minTick+(maxTick-minTick)/2);
var min=minScale;
var max=this.getMaxScale();
if(powerUnits==PowerUnits.WATTS){
var minLabel=""+min.toFixed(0)+"&#160;<br/>"+unitsWatts+"&#160;";
var midLabel=""+((min+(max-min)/2)).toFixed(0)+"&#160;<br/>"+unitsWatts+"&#160;";
var maxLabel=""+max.toFixed(0)+"&#160;<br/>"+unitsWatts+"&#160;";
}else if(powerUnits==PowerUnits.BTUS){
var minLabel=""+(min*3.412).toFixed(0)+"<br/>"+unitsBTUs;
var midLabel=""+((min+(max-min)/2)*3.412).toFixed(0)+"<br/>"+unitsBTUs;
var maxLabel=""+(max*3.412).toFixed(0)+"<br/>"+unitsBTUs;
}else{
var minLabel=""+(min/voltageFactor).toFixed(0)+"<br/>"+unitsAmps;
var midLabel=""+((min+(max-min)/2)/voltageFactor).toFixed(0)+"<br/>"+unitsAmps;
var maxLabel=""+(max/voltageFactor).toFixed(0)+"<br/>"+unitsAmps;
}
var yTicks=[{v:minTick,label:minLabel},
{v:midTick,label:midLabel},
{v:maxTick,label:maxLabel}];
return yTicks;
}
this.setGraphTitle=function(label){
graphTitle=label;
}
this.setInWatts=function(boolValue){
if(boolValue)powerUnits=PowerUnits.WATTS;
else powerUnits==PowerUnits.BTUS;
}
this.getInWatts=function(){
return powerUnits==PowerUnits.WATTS;
}
this.setPowerUnits=function(units,voltPhaseFactor){
powerUnits=units;
voltageFactor=voltPhaseFactor;
}
this.getPowerUnits=function(){
return powerUnits;
}
this.getMaxColor=function(){
return maxColor;
}
this.getMidColor=function(){
return midColor;
}
this.getMinColor=function(){
return minColor;
}
this.getCapColor=function(){
return capColor;
}
this.getDeratedColor=function(){
return deratedColor;
}
this.getRatedColor=function(){
return ratedColor;
}
this.buildBarGraph=function(eID,barWidth){
var s=new StringBuilder();
if(typeof(barWidth)==undefined||barWidth==null){
var barWidth=this.getBarWidth();
}
barWidth=2;
if(graphTitle!=null)s.append("<div style=\"position:absolute;z-index:10;color:white;text-align=center;margin-left:220px;margin-top:170px;\"><b>"+graphTitle+"</b></div>");
s.append("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"width:576px;height:185px;margin:0px;padding:0px;border:0px;border-spacing:0px;\"><tr style=\"width:auto;white-space:nowrap;margin:0px;padding:0px;border:0px;border-spacing:0px;\">");
var factor=1;
var pwrType=" "+unitsWatts;
if(powerUnits==PowerUnits.BTUS){
factor=3.412;
pwrType=" "+unitsBTUs;
}else if(powerUnits==PowerUnits.AMPS){
factor=1.0/voltageFactor;
pwrType=" "+unitsAmps;
}
var chartHeight=(this.getMaxScale()-minScale);
var chartFactor=100/chartHeight;
for(i=0;i<288-avgArray.length;i++)
{
s.append("<td style=\"position: relative;margin:0px auto;white-space:nowrap;padding:0px;border:0px;border-spacing:0px;width:auto;\" >");
s.append("<div class=\"chartOutlineVertical\"  style=\"z-index:1;position: relative;top:0px;left:0px;vertical-align:bottom;margin:0px auto;width:"+barWidth+"px;height:200px;background:#d3d3d3;padding:0px;border:0px;border-spacing:0px;\" title=\"\"/>");
s.append("</div></td>");
}
for(i=0;i<avgArray.length;i++)
{
var minHeight=(minArray[i][1])-minScale;
minHeight=Math.floor(minHeight*chartFactor);
var peakHeight=(maxArray[i][1])-minScale;
peakHeight=Math.floor(peakHeight*chartFactor);
var avgHeight=(avgArray[i][1])-minScale;
avgHeight=Math.floor(avgHeight*chartFactor);
var minPower=(minArray[i][1]*factor).toFixed(0)+pwrType+'<br /><b>'+tipTime+'</b>: '+timeArray[i][1];
var avgPower=(avgArray[i][1]*factor).toFixed(0)+pwrType+'<br /><b>'+tipTime+'</b>: '+timeArray[i][1];
var peakPower=new Array();
peakPower[0]=(maxArray[i][1]*factor).toFixed(0)+pwrType+'<br /><b>'+tipTime+'</b>: '+timeArray[i][1];
var minTip="<b>"+tipMin+"</b>: "+minPower;
var avgTip="<b>"+tipAverage+"</b>: "+avgPower;
var peakTip="<b>"+tipPeak+"</b>: "+peakPower[0];
var bars=new Array();
var ratedValue=ratedArray[i][1];
var ratedHeight;
var ratedTip;
if((1*ratedValue==0)){
ratedHeight=0;
ratedTip="<b>"+tipNoRated+"</b>";
}else{
ratedHeight=ratedValue-minScale;
ratedHeight=Math.floor(ratedHeight*chartFactor);
var rated=(ratedValue*factor).toFixed(0)+pwrType+'<br /><b>'+tipTime+'</b>: '+timeArray[i][1];
ratedTip="<b>"+tipRated+"</b>: "+rated;
}
if(showRated){
var bar={}
bar.height=ratedHeight;
bar.color=ratedColor;
bar.tip=ratedTip;
bar.name="ratedBar"+i;
bars.push(bar);
}
var deratedValue=deratedArray[i][1];
var deratedHeight;
var deratedTip;
if((1*deratedValue==0)){
deratedHeight=0;
deratedTip="<b>"+tipNoDerated+"</b>";
}else{
deratedHeight=deratedValue-minScale;
deratedHeight=Math.floor(deratedHeight*chartFactor);
var derated=(deratedValue*factor).toFixed(0)+pwrType+'<br /><b>'+tipTime+'</b>: '+timeArray[i][1];
deratedTip="<b>"+tipDerated+"</b>: "+derated;
}
if(showDerated){
var bar={}
bar.height=deratedHeight;
bar.color=deratedColor;
bar.tip=deratedTip;
bar.name="deratedBar"+i;
bars.push(bar);
}
var capValue=capArray[i][1];
var capHeight;
var capTip;
if((1*capValue==0)){
capHeight=0;
capTip="<b>"+tipNoCap+"</b>";
}else{
capHeight=capValue-minScale;
capHeight=Math.floor(capHeight*chartFactor);
var capPower=(capValue*factor).toFixed(0)+pwrType+'<br /><b>'+tipTime+'</b>: '+timeArray[i][1];
capTip="<b>"+tipCap+"</b>: "+capPower;
}
if(showCap){
var bar={}
bar.height=capHeight;
bar.color=capColor;
bar.tip=capTip;
bar.name="capBar"+i;
bars.push(bar);
}
if(showPeak){
if(peakHeight==0)peakHeight++;
var bar={}
bar.height=peakHeight;
bar.color=maxColor;
bar.tip=peakTip;
bar.name="peakBar"+i;
bars.push(bar);
}
if(showAvg){
var bar={}
bar.height=avgHeight;
bar.color=midColor;
bar.tip=avgTip;
bar.name="avgBar"+i;
bars.push(bar);
}
if(showMin){
if(avgHeight==minHeight)minHeight--;
var bar={}
bar.height=minHeight;
bar.color=minColor;
bar.tip=minTip;
bar.name="minBar"+i;
bars.push(bar);
}
bars.sort(sortBarArrayDescend);
s.append("<td style=\"position: relative;margin:0px auto;white-space:nowrap;padding:0px;border:0px;border-spacing:0px;width:auto;\" >");
s.append("<div id=bgBar"+i+" name=bgBar"+i+" class=\"chartOutlineVertical\"  style=\"z-index:1;position: relative;top:0px;left:0px;vertical-align:bottom;margin:0px auto;width:"+barWidth+"px;height:200px;background:#d3d3d3;padding:0px;border:0px;border-spacing:0px;\" title=\"\" onmouseout=\"showTooltip(event,this,false)\"/>");
for(var b=0;b<bars.length;b++){
var zindex=b+1;
var bar=bars[b];
var barName=bar.name;
var height=bar.height.toFixed(0);
var color=bar.color;
var tip=bar.tip;
var bottom=0;
if((barName==("capBar"+i))||(barName==("deratedBar"+i))||(barName==("ratedBar"+i))){
bottom=(height-2);
height=2;
}
s.append("<div id="+barName+" name="+barName+" class=\"chartBarVertical\" style=\"z-index:"+zindex+";position:absolute;bottom:"+bottom+"%;left:0px;vertical-align:bottom;margin:0px auto;padding:0px;border:0px;width:"+barWidth+"px;height:"+height+"%;background:"+color);
if(tip!=null){
s.append("\" title=\"\" data-titleText=\""+tip+"\" onmousemove=\"showTooltip(event,this,true)\"></div>");
}else{
s.append("\"></div>");
}
}
s.append("</div></td>");
}
s.append("</tr></table>");
s.append("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"width:auto;height:14px;margin:0px;padding:0px;border:0px;border-spacing:0px;background:#eeeeee\"><tr style=\"width:auto;white-space:nowrap;margin:0px;padding:0px;border:0px;border-spacing:0px;\">");
s.append("<td align=\"left\" style=\"width: 100%\"><div style=\"width:576px\">");
s.append("<div class=\"limitIndicatorOutline\">");
s.append("<div class=\"limitIndicatorInvisible\" style=\"width: 1%\">-24hrs&nbsp;</div>");
s.append("<div class=\"limitIndicatorNormal\" style=\"width: 25%\">-18hrs&nbsp;</div>");
s.append("<div class=\"limitIndicatorNormal\" style=\"width: 50%\">-12hrs&nbsp;</div>");
s.append("<div class=\"limitIndicatorNormal\" style=\"width: 75%\">-6hrs&nbsp;</div>");
s.append("<div class=\"limitIndicatorInvisible\" style=\"width: 100%\">present&nbsp;</div>");
s.append("</div>");
s.append("</div>");
s.append("</td>");
s.append("</tr></table>");
return s.toString();
}
this.showBar=function(name,checked){
if(name=="min"){
showMin=checked;
}else if(name=="average"){
showAvg=checked;
}else if(name=="peak"){
showPeak=checked;
}else if(name=="cap"){
showCap=checked;
}else if(name=="derated"){
showDerated=checked;
}else if(name=="rated"){
showRated=checked;
}
}
this.getBarWidth=function(){
if(barWidth==null){
barWidth=Math.ceil(400/avgArray.length);
}
if(barWidth<2)barWidth=2;
return barWidth;
}
this.getMaxBarWidth=function(){
var barWidth=this.getBarWidth();
if(barWidth<15)barWidth=15;
return barWidth;
}
this.setBarWidth=function(value){
try{
for(i=0;i<avgArray.length;i++){
document.getElementById('bgBar'+i).style.width=""+value+"px";
if(showCap){
document.getElementById('capBar'+i).style.width=""+value+"px";
document.getElementById('capBgBar'+i).style.width=""+value+"px";
}
if(showDerated)document.getElementById('deratedBar'+i).style.width=""+value+"px";
if(showRated)document.getElementById('ratedBar'+i).style.width=""+value+"px";
if(showPeak)document.getElementById('peakBar'+i).style.width=""+value+"px";
if(showAvg)document.getElementById('avgBar'+i).style.width=""+value+"px";
if(showMin)document.getElementById('minBar'+i).style.width=""+value+"px";
}
barWidth=value;
}catch(e){}
}
this.setBarHeight=function(value){
try{
for(i=0;i<avgArray.length;i++){
document.getElementById('bgBar'+i).style.height=""+value+"px";
}
}catch(e){}
}
function makeToolTip(divId,title,stringArray){
var s=new StringBuilder();
s.append("<div id=\""+divId+"\" style=\"border: 0px none; padding: 0px; background: transparent none repeat scroll 0% 50%;overflow: hidden; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial;-moz-background-inline-policy: -moz-initial;\" class=\"deviceInfo\">");
s.append("<table style=\"border: 1px solid rgb(51, 51, 51); width: 100%;\" cellspacing=\"0\"><tbody><tr><td style=\"text-align: left; padding-left: 2px; width: 20%; background-color: rgb(102, 102, 102);color: white;\">");
s.append("Server Bay 1");
s.append("</td></tr>");
s.append("</tbody></table></div>");
return s.toString();
}
};
