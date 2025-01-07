/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function showLDAPIPv6DisabledNote(isWizard,encNum){
var hpem;
var ldapEnabled=document.getElementById('ldapEnabled');
var IPAddressServer=document.getElementById('dsAddress').value;
var isIPv6Address=false;
if(isWizard=='true')
hpem=top.getTopology().getProxyLocal();
else
hpem=top.mainPage.getHiddenFrame().getProxy(encNum);
var activeOaNetworkInfo=hpem.getOaNetworkInfoByMode(ACTIVE(),null,false);
var IPv6Enabled=(getElementValueXpath(activeOaNetworkInfo,'//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name="Ipv6Enabled"]')=='true');
if(IPAddressServer!=''){
isIPv6Address=isValidIPv6AddressPrefOp(IPAddressServer);
}
if(ldapEnabled.checked&&!(IPv6Enabled)&&isIPv6Address){
var note_div=document.getElementById('LDAPIPv6DisabledDisplay');
var message=top.getString('LDAPIPv6DisabledNote');
note_div.style.display="block";
note_div.innerHTML="<em>"+message+"</em>";
}else{
var note_div=document.getElementById('LDAPIPv6DisabledDisplay');
if(note_div){
note_div.style.display="none";
note_div.innerHTML="";
}
}
}
