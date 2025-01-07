/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function transformFrontView(hpem,encNum){
var output='';
var enclosureType=hpem.getEnclosureType();
if(enclosureType==EnclosureTypes.c7000){
var processor=new XsltProcessor('../Templates/enclosureFrontView_c7000.xsl');
processor.addParameter('encNum',encNum);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('graphicsMap',top.getGraphicsMap());
processor.addParameter('enclosureInfoDoc',hpem.getEnclosureInfo());
processor.addParameter('enclosureStatusDoc',hpem.getEnclosureStatus());
processor.addParameter('bladeStatusDoc',hpem.getBladeStatusDOM());
processor.addParameter('bladeInfoDoc',hpem.getBladeInfoDOM());
processor.addParameter('domainInfoDoc',hpem.getDomainInfo());
processor.addParameter('powerSupplyStatusDoc',hpem.getPsStatusDOM());
processor.addParameter('powerSupplyInfoDoc',hpem.getPsInfoDOM());
processor.addParameter('currentUserInfo',hpem.getCurrentUserInfo());
if(hpem.getBladeMpInfoDOM()!=null){
processor.addParameter('mpInfoDoc',hpem.getBladeMpInfoDOM());
}
output=processor.getOutput();
if(processor.hasErrors()){
output='<br />';
output+='The view failed to draw. Click <a href="javascript:refreshView(\'front\', '+encNum+');">here</a> to refresh.';
}
}
else if(enclosureType==EnclosureTypes.c3000){
if(hpem.getIsTower()==true){
var processor=new XsltProcessor('../Templates/enclosureFrontView_c3000_t.xsl');
}else{
var processor=new XsltProcessor('../Templates/enclosureFrontView_c3000.xsl');
}
processor.addParameter('encNum',encNum);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('graphicsMap',top.getGraphicsMap());
processor.addParameter('enclosureInfoDoc',hpem.getEnclosureInfo());
processor.addParameter('enclosureStatusDoc',hpem.getEnclosureStatus());
processor.addParameter('bladeStatusDoc',hpem.getBladeStatusDOM());
processor.addParameter('bladeInfoDoc',hpem.getBladeInfoDOM());
processor.addParameter('domainInfoDoc',hpem.getDomainInfo());
processor.addParameter('oaInfoDoc',hpem.getOaInfoDOM());
processor.addParameter('oaStatusDoc',hpem.getOaStatusDOM());
processor.addParameter('oaNetworkInfoDoc',hpem.getOaNetworkInfoDOM());
processor.addParameter('mpInfoDoc',hpem.getBladeMpInfoDOM());
processor.addParameter('oaMediaDeviceList',hpem.getOaMediaDeviceDOM());
processor.addParameter('currentUserAcl',hpem.getUserAccessLevel());
processor.addParameter('currentUserInfo',hpem.getCurrentUserInfo());
output=processor.getOutput();
if(processor.hasErrors()){
output='<br />';
output+='The view failed to draw. Click <a href="javascript:refreshView(\'front\', '+encNum+');">here</a> to refresh.';
}
}
else{
output='<b>'+top.getString('unknownEnclosureType')+'</b>';
}
return output;
}
function transformRearView(hpem,encNum){
var output='';
var enclosureType=hpem.getEnclosureType();
if(enclosureType==EnclosureTypes.c7000){
var processor=new XsltProcessor('../Templates/enclosureRearView_c7000.xsl');
processor.addParameter('encNum',encNum);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('graphicsMap',top.getGraphicsMap());
processor.addParameter('enclosureInfoDoc',hpem.getEnclosureInfo());
processor.addParameter('enclosureStatusDoc',hpem.getEnclosureStatus());
processor.addParameter('netTrayStatusDoc',hpem.getInterconnectTrayStatusDOM());
processor.addParameter('netTrayInfoDoc',hpem.getInterconnectTrayInfoDOM());
processor.addParameter('oaInfoDoc',hpem.getOaInfoDOM());
processor.addParameter('oaStatusDoc',hpem.getOaStatusDOM());
processor.addParameter('oaNetworkInfoDoc',hpem.getOaNetworkInfoDOM());
processor.addParameter('fanInfoDoc',hpem.getFanInfoDOM());
output=processor.getOutput();
if(processor.hasErrors()){
output='<br />';
output+='The view failed to draw. Click <a href="javascript:refreshView(\'rear\', '+encNum+');">here</a> to refresh.';
}
}
else if(enclosureType==EnclosureTypes.c3000){
if(hpem.getIsTower()==true){
var processor=new XsltProcessor('../Templates/enclosureRearView_c3000_t.xsl');
}else{
var processor=new XsltProcessor('../Templates/enclosureRearView_c3000.xsl');
}
processor.addParameter('encNum',encNum);
processor.addParameter('stringsDoc',top.getStringsDoc());
processor.addParameter('graphicsMap',top.getGraphicsMap());
processor.addParameter('enclosureInfoDoc',hpem.getEnclosureInfo());
processor.addParameter('enclosureStatusDoc',hpem.getEnclosureStatus());
processor.addParameter('netTrayStatusDoc',hpem.getInterconnectTrayStatusDOM());
processor.addParameter('netTrayInfoDoc',hpem.getInterconnectTrayInfoDOM());
processor.addParameter('powerSupplyStatusDoc',hpem.getPsStatusDOM());
processor.addParameter('powerSupplyInfoDoc',hpem.getPsInfoDOM());
processor.addParameter('fanInfoDoc',hpem.getFanInfoDOM());
processor.addParameter('kvmInfoDoc',hpem.getKvmInfo());
output=processor.getOutput();
if(processor.hasErrors()){
output='<br />';
output+='The view failed to draw. Click <a href="javascript:refreshView(\'rear\', '+encNum+');">here</a> to refresh.';
}
}
else{
output='<b>'+top.getString('unknownEnclosureType')+'</b>';
}
return output;
}
function refreshView(side,encNum){
var hpem=top.getTopology().getProxy(encNum);
if(hpem){
if(side=='front'){
loadFrontView(hpem,encNum);
}
else if(side=='rear'){
loadRearView(hpem,encNum);
}
}
}
