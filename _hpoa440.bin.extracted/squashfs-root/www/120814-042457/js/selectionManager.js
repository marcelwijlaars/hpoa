/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var ContentSelectErrors={
NONE:0,
DEVICE_NOT_FOUND:1,
INVALID_DEVICE_TYPE:2,
INVALID_DEVICE_ID:3,
NO_ONBOARD_ADMIN:4
};
function ContentInfo(){
this.type='';
this.bayNumber=-1;
this.rawId='';
this.error=-1;
};
function getContentInfo(type,id,hpemObject){
type=type.toLowerCase();
var cInfo=new ContentInfo();
cInfo.type=type;
cInfo.rawId=id;
if(type==''){
cInfo.error=ContentSelectErrors.INVALID_DEVICE_TYPE;
return cInfo;
}
switch(type){
case MP():
case PM_BLADE():
case BAY():
cInfo.error=ContentSelectErrors.INVALID_DEVICE_ID;
if(id==''){
cInfo.bayNumber=0;
break;
}
if(id.length<=2){
if(getElementValueXpath(hpemObject.getBladeInfoDOM(),'//hpoa:bladeInfo[hpoa:bayNumber='+id+']/hpoa:presence')=='PRESENT'){
cInfo.error=ContentSelectErrors.NONE;
cInfo.bayNumber=id;
break;
}
}else{
var bladeInfoDOM=hpemObject.getBladeInfoDOM();
var bayNum='';
bayNum=getElementValueXpath(bladeInfoDOM,'//hpoa:bladeInfo[contains(hpoa:serialNumber, "'+id+'")]/hpoa:bayNumber');
if(bayNum!=''){
cInfo.error=ContentSelectErrors.NONE;
cInfo.bayNumber=bayNum;
break;
}
bayNum=getElementValueXpath(bladeInfoDOM,'//hpoa:bladeInfo[hpoa:uuid="'+id+'"]/hpoa:bayNumber');
if(bayNum!=''){
cInfo.bayNumber=bayNum;
cInfo.error=ContentSelectErrors.NONE;
break;
}
bayNum=getElementValueXpath(bladeInfoDOM,'//hpoa:bladeInfo/hpoa:extraData[@hpoa:name="cUUID" and .="'+id+'"]/../hpoa:bayNumber');
if(bayNum!=''){
cInfo.bayNumber=bayNum;
cInfo.error=ContentSelectErrors.NONE;
break;
}
}
break;
case INTERCONNECT():
case PM_INTERCONNECT():
cInfo.error=ContentSelectErrors.INVALID_DEVICE_ID;
if(id==''){
cInfo.bayNumber=0;
cInfo.error=ContentSelectErrors.NONE;
}else{
if(getElementValueXpath(hpemObject.getInterconnectTrayStatus(id),'//hpoa:presence')=='PRESENT'){
cInfo.bayNumber=id;
cInfo.error=ContentSelectErrors.NONE;
}
}
break;
case POWER_SUPPLY():
cInfo.error=ContentSelectErrors.INVALID_DEVICE_ID;
if(id==''){
cInfo.bayNumber=0;
cInfo.error=ContentSelectErrors.NONE;
}else{
if(getElementValueXpath(hpemObject.getPsInfo(id),'//hpoa:presence')=='PRESENT'){
cInfo.bayNumber=id;
cInfo.error=ContentSelectErrors.NONE;
}
}
break;
case FAN():
cInfo.error=ContentSelectErrors.INVALID_DEVICE_ID;
if(id==''){
cInfo.bayNumber=0;
cInfo.error=ContentSelectErrors.NONE;
}else{
if(getElementValueXpath(hpemObject.getFanInfo(id),'//hpoa:presence')=='PRESENT'){
cInfo.bayNumber=id;
cInfo.error=ContentSelectErrors.NONE;
}
}
break;
case 'oa':
cInfo.error=ContentSelectErrors.INVALID_DEVICE_ID;
var role=getElementValueXpath(hpemObject.getOaStatus(id),'//hpoa:oaRole');
if(role=='ACTIVE'||role=='STANDBY'){
cInfo.bayNumber=id;
cInfo.error=ContentSelectErrors.NONE;
cInfo.type='em';
}
break;
case ENCLOSURE():
cInfo.bayNumber=1;
cInfo.error=ContentSelectErrors.NONE;
break;
default:
cInfo.error=ContentSelectErrors.INVALID_DEVICE_TYPE;
cInfo.bayNumber=-1;
break;
}
return cInfo;
}
