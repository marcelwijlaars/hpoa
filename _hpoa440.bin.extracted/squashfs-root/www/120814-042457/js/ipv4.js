/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function IPv4Manager(){}
function _isValidIpAddress4(address){
var isValid=true;
var ipPattern=/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
var ipArray=address.match(ipPattern);
if(ipArray==null){
isValid=false;
}
else{
if(ipArray.length==5){
if(ipArray[0]!='255.255.255.255'&&ipArray[0]!='0.0.0.0'){
for(var i=1;i<ipArray.length;i++){
try{
if(parseInt(ipArray[i])>255){
isValid=false;
break;
}
}
catch(e){
isValid=false;
}
}
}
else{
isValid=false;
}
}
else{
isValid=false;
}
}
return isValid;
}
function _isValidNetmask4(netmask){
var isValid=false;
isValid=_isValidNetmaskPattern4(netmask);
if(isValid){
isValid=_getAddressClass4(netmask)!=IPClasses.Unknown;
}
return isValid;
}
function _isValidNetmaskPattern4(netmask){
var isValid=false;
if(netmask!=''&&netmask!='0.0.0.0'){
var netmask_expr=/^(128|192|224|240|248|252|254|255)\.(0|128|192|224|240|248|252|254|255)\.(0|128|192|224|240|248|252|254|255)\.(0|128|192|224|240|248|252|254)$/;
isValid=netmask.match(netmask_expr)!=null;
}
return isValid;
}
function _getAddressClass4(netmask){
var maskOctets=netmask.split('.');
var ipClass=IPClasses.Unknown;
if(maskOctets.length==4){
var bitCount=0;
var lastBitReached=false;
var hasInvalidBits=false;
for(var i=0;i<maskOctets.length;i++){
var currentOctet=parseInt(maskOctets[i]);
for(var j=0;j<8;j++){
if(currentOctet&(0x80>>j)){
if(lastBitReached){
hasInvalidBits=true;
break;
}
else{
bitCount++;
}
}
else{
lastBitReached=true;
}
}
if(hasInvalidBits){
break;
}
}
if(!hasInvalidBits){
var remainder=(parseInt(bitCount%8))>0?1:0;
ipClass=parseInt(bitCount/8)+remainder;
}
}
return ipClass;
}
function _getAvailableAddresses4(netmask){
var numAddresses=0;
if(_isValidNetmask4(netmask)){
var maskOctets=netmask.split('.');
var bitCount=0;
var lastBitReached=false;
for(var i=0;i<maskOctets.length;i++){
var currentOctet=parseInt(maskOctets[i]);
for(var j=0;j<8;j++){
if(currentOctet&(0x80>>j)){
bitCount++;
}
else{
break;
}
}
if(lastBitReached){
break;
}
}
numAddresses=Math.pow(2,(32-bitCount));
}
return numAddresses;
}
IPv4Manager.prototype.toString=function(){return "IPv4 Manager";};
IPv4Manager.prototype.isValidIpAddress=_isValidIpAddress4;
IPv4Manager.prototype.isValidNetmask=_isValidNetmask4;
IPv4Manager.prototype.getAddressClass=_getAddressClass4;
IPv4Manager.prototype.getAvailableAddresses=_getAvailableAddresses4;
