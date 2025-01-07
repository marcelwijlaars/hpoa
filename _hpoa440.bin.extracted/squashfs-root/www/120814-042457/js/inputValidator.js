/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
InputValidator.ValidateTag="validate-me";
InputValidator.LabelTag="linked-error";
InputValidator.MessageTag="msg-key";
InputValidator.MsgInsertTag="msg-insert-key";
InputValidator.RulesTag="rule-list";
InputValidator.CaptionTag="caption-label";
InputValidator.RelativesTag="related-inputs";
InputValidator.RangeTag="range";
InputValidator.InvalidTag="invalid-list";
InputValidator.RegExpTag="reg-exp";
InputValidator.FormIdTag="unique-id";
InputValidator.RelatedCaptionTag="related-labels";
InputValidator.OptionTag="option-id";
InputValidator.ExceptionsTag="rule-exceptions";
ValidatedInput.InputInvalidKey="inputInvalid";
ValidatedInput.InputMatchKey="inputMatch";
ValidatedInput.FieldRequiredKey="inputRequired";
ValidatedInput.NumberRequiredKey="inputNumber";
ValidatedInput.NumberRangeKey="inputNumberRange";
ValidatedInput.IntegerRequiredKey='inputInteger';
ValidatedInput.IntegerRangeKey='inputIntegerRange';
ValidatedInput.StringRequiredKey="inputString";
ValidatedInput.StringRangeKey="inputStringRange";
ValidatedInput.DateRequiredKey="inputDate";
ValidatedInput.EmailRequiredKey="inputEmail";
ValidatedInput.IpRequiredKey="inputIp";
ValidatedInput.NoSpacesKey="inputNoSpaces";
ValidatedInput.InvalidCharsKey="inputChars";
ValidatedInput.RegexKey="inputRegex";
ValidatedInput.UniqueKey="inputUnique";
ValidatedInput.DependentKey="inputDependent";
ValidatedInput.VisibleCharsKey="inputVisibleChars";
ValidatedInput.InputInvalidKeyEx="fieldInvalid";
ValidatedInput.InputMatchKeyEx="fieldMatch";
ValidatedInput.FieldRequiredKeyEx="fieldRequired";
ValidatedInput.NumberRequiredKeyEx="fieldNumber";
ValidatedInput.NumberRangeKeyEx="fieldNumberRange";
ValidatedInput.IntegerRequiredKeyEx='fieldInteger';
ValidatedInput.IntegerRangeKeyEx='fieldIntRange';
ValidatedInput.StringRequiredKeyEx="fieldString";
ValidatedInput.StringLengthKeyEx="fieldStringLength";
ValidatedInput.StringRangeKeyEx="fieldStringRange";
ValidatedInput.DateRequiredKeyEx="fieldDate";
ValidatedInput.EmailRequiredKeyEx="fieldEmail";
ValidatedInput.IpRequiredKeyEx="fieldIp";
ValidatedInput.NoSpacesKeyEx="fieldNoSpaces";
ValidatedInput.InvalidCharsKeyEx="fieldChars";
ValidatedInput.RegexKeyEx="fieldRegex";
ValidatedInput.UniqueKeyEx="fieldUnique";
ValidatedInput.DependentKeyEx="fieldDependent";
ValidatedInput.VisibleCharsKeyEx="fieldVisibleChars";
ValidationRule.Optional=0;
ValidationRule.Required=1;
ValidationRule.IpAddress=2;
ValidationRule.EmailAddress=3;
ValidationRule.Date=4
ValidationRule.Number=5;
ValidationRule.String=6;
ValidationRule.Mirror=7;
ValidationRule.NoSpaces=8;
ValidationRule.Integer=9;
ValidationRule.RegExp=10;
ValidationRule.InvalidChars=11;
ValidationRule.Unique=12;
ValidationRule.Dependent=13;
ValidationRule.Ipv6Address=14;
ValidationRule.Ipv6AddressPrefOp=15;
ValidationRule.VisibleChars=16;
ValidationRule.OptionDependents=17;
function InputValidator(validateTag,displayElementId,autoInit){
this.validateTag=(validateTag?validateTag:InputValidator.ValidateTag);
this.displayControl=document.getElementById(displayElementId);
this.inputs=new Array();
if(autoInit){
this.init();
}
};
function _setNewInputGroup(validateTag,displayElementId){
this.validateTag=validateTag;
if(exists(displayElementId)){
this.displayControl=document.getElementById(displayElementId);
}
this.init();
};
function _getInputs(){
return this.inputs;
};
function _getInput(id){
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].element.id==id){
return this.inputs[i];
}
}
};
function _getFirstInvalidInput(){
for(var i=0;i<this.inputs.length;i++){
if(!(this.inputs[i].hasValidInput())){
return this.inputs[i].element;
}
}
return null;
};
function _autoFocus(){
var elem=this.getFirstInvalidInput();
if(elem){
try{
elem.focus();
elem.select();
}catch(err){}
}
};
function _removeInput(id,useHTML){
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].element.id==id){
if(this.displayControl){
this.inputs.splice(i,1);
this.updateMessages(useHTML);
}else{
this.inputs[i].hideMessages();
this.inputs.splice(i,1);
}
}
}
};
function _init(){
var elems=document.getElementsByTagName("*");
this.inputs=new Array();
for(var i=0;i<elems.length;i++){
if(elems[i].getAttribute(this.validateTag)=="true"){
var newInput=new ValidatedInput(elems[i]);
newInput.init();
this.inputs[this.inputs.length]=newInput;
}
}
};
function _attachKeyListeners(callback){
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].element.attachEvent){
this.inputs[i].element.attachEvent("onkeyup",callback);
}else{
this.inputs[i].element.onkeyup=callback;
}
}
};
function _allInputsValidate(){
for(var i=0;i<this.inputs.length;i++){
if(!(this.inputs[i].hasValidInput())){
return false;
}
}
return true;
};
function _allInputsAreClean(){
for(var i=0;i<this.inputs.length;i++){
if(!(this.inputs[i].isClean())){
return false;
}
}
return true;
};
function _singleInputIsClean(id){
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].element.id==id){
return(this.inputs[i].isClean());
}
}
return true;
};
function _singleInputValidates(id){
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].element.id==id){
return(this.inputs[i].hasValidInput());
}
}
};
function _showCustomMessage(msg){
if(this.displayControl){
this.displayControl.innerHTML=msg;
this.displayControl.style.display='block';
}
};
function _updateMessages(useHTML){
var i;
if(this.displayControl){
this.displayControl.innerHTML=this.getRulesBroken(useHTML);
this.displayControl.style.display='block';
}else{
for(i=0;i<this.inputs.length;i++){
if(this.inputs[i].hasValidInput()){
this.inputs[i].hideMessages();
}else{
this.inputs[i].showMessages(useHTML);
}
}
}
};
function _updateFirstMessage(useHTML){
this.clearMessages();
if(this.displayControl){
this.displayControl.innerHTML=this.getFirstRuleBroken(useHTML);
this.displayControl.style.display='block';
}
};
function _clearMessages(){
if(this.displayControl){
this.displayControl.innerHTML="";
this.displayControl.style.display='none';
}else{
for(var i=0;i<this.inputs.length;i++){
this.inputs[i].hideMessages();
}
}
};
function _getFirstRuleBroken(useHTML){
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].hasValidInput()==false){
return this.inputs[i].getRulesBroken(useHTML);
}
}
};
function _getFirstRuleBrokenType(){
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].hasValidInput()==false){
return this.inputs[i].getFirstRuleBrokenType();
}
}
return-1;
};
function _getAllRulesBroken(useHTML){
var errors="";
for(var i=0;i<this.inputs.length;i++){
if(this.inputs[i].hasValidInput()==false){
errors+=this.inputs[i].getRulesBroken(useHTML);
}
}
return errors;
};
InputValidator.prototype.init=_init;
InputValidator.prototype.attachKeyListeners=_attachKeyListeners;
InputValidator.prototype.setNewInputGroup=_setNewInputGroup;
InputValidator.prototype.getInputs=_getInputs;
InputValidator.prototype.getInput=_getInput;
InputValidator.prototype.getFirstInvalidInput=_getFirstInvalidInput;
InputValidator.prototype.getFirstRuleBrokenType=_getFirstRuleBrokenType;
InputValidator.prototype.autoFocus=_autoFocus;
InputValidator.prototype.removeInput=_removeInput;
InputValidator.prototype.allInputsAreClean=_allInputsAreClean;
InputValidator.prototype.singleInputIsClean=_singleInputIsClean;
InputValidator.prototype.allInputsValidate=_allInputsValidate;
InputValidator.prototype.singleInputValidates=_singleInputValidates;
InputValidator.prototype.getFirstRuleBroken=_getFirstRuleBroken;
InputValidator.prototype.getRulesBroken=_getAllRulesBroken;
InputValidator.prototype.showCustomMessage=_showCustomMessage;
InputValidator.prototype.updateMessages=_updateMessages;
InputValidator.prototype.updateFirstMessage=_updateFirstMessage;
InputValidator.prototype.clearMessages=_clearMessages;
function ValidatedInput(elem){
this.element=((typeof(elem.tagName)=="undefined")?null:elem);
this.cleanValue=extractValue(elem)
this.formIdentifier="";
this.linkedErrorLabel=null;
this.invalidList=null;
this.regExp=null;
this.fieldName="";
this.optional=false;
this.optionElement=null;
this.useCustomMessage=false;
this.rules=new Array();
this.relatives=new Array();
this.relativeNames=new Array();
this.range=new Object();
this.range.min=null;
this.range.max=null;
this.exceptions=new Array();
};
function _initInput(){
var names=null;
var values=null;
var msg="";
if(this.element.getAttribute(InputValidator.CaptionTag)){
this.fieldName=getLabelText(this.element.getAttribute(InputValidator.CaptionTag));
}
if(this.element.getAttribute(InputValidator.FormIdTag)){
this.formIdentifier=" "+this.element.getAttribute(InputValidator.FormIdTag);
}
if(this.element.getAttribute(InputValidator.OptionTag)){
this.optionElement=document.getElementById(this.element.getAttribute(InputValidator.OptionTag));
}
if(this.element.getAttribute(InputValidator.RelativesTag)){
names=this.element.getAttribute(InputValidator.RelativesTag);
names=names.split(";");
for(var i=0;i<names.length;i++){
this.relatives[this.relatives.length]=document.getElementById(names[i]);
}
}
if(this.element.getAttribute(InputValidator.RelatedCaptionTag)){
names=this.element.getAttribute(InputValidator.RelatedCaptionTag);
names=names.split(";");
for(var n=0;n<names.length;n++){
this.relativeNames[this.relativeNames.length]=getLabelText(names[n]);
}
}
if(this.element.getAttribute(InputValidator.InvalidTag)){
this.invalidList=this.element.getAttribute(InputValidator.InvalidTag);
}
if(this.element.getAttribute(InputValidator.RegExpTag)){
this.regExp=new RegExp(this.element.getAttribute(InputValidator.RegExpTag));
}
if(this.element.getAttribute(InputValidator.ExceptionsTag)){
values=this.element.getAttribute(InputValidator.ExceptionsTag);
values=values.split(";");
for(var v=0;v<values.length;v++){
this.exceptions[this.exceptions.length]=values[v];
}
}
if(this.element.getAttribute(InputValidator.RangeTag)){
var range=this.element.getAttribute(InputValidator.RangeTag);
range=range.split(";");
if(range.length>=2){
range[0]=parseInt(range[0]);
range[1]=parseInt(range[1]);
this.range.min=(range[0]<range[1]?range[0]:range[1]);
this.range.max=(range[0]>range[1]?range[0]:range[1]);
}
}
if(this.element.getAttribute(InputValidator.RulesTag)!=null){
var rules=this.element.getAttribute(InputValidator.RulesTag);
rules=rules.split(";");
for(var j=0;j<rules.length;j++){
if(this.element.getAttribute(InputValidator.MessageTag)!=null){
if(this.useCustomMessage==false){
msg=this.getInputString(this.element.getAttribute(InputValidator.MessageTag));
this.useCustomMessage=true;
}
}else{
msg=this.getInputString(this.getStringKey(rules[j]));
}
if(rules[j]==ValidationRule.Optional){
this.optional=true;
}else{
this.addRule(rules[j],msg);
}
}
}else{
this.addRule(ValidationRule.Required,
this.getInputString(this.getStringKey(ValidationRule.Required)));
}
if(this.element.getAttribute(InputValidator.LabelTag)!=null){
var labelElement=document.getElementById(this.element.getAttribute(InputValidator.LabelTag));
if(labelElement){
this.linkedErrorLabel=labelElement;
}
}
};
function _getRule(type){
for(var i=0;i<this.rules.length;i++){
if(this.rules[i].type==type){
return this.rules[i];
}
}
return null;
};
function _addRule(type,msg){
if(!isNaN(type)){
return this.rules.push(new ValidationRule(type,msg));
}
};
function _removeRule(type){
if(!isNaN(type)){
for(var i=0;i<this.rules.length;i++){
if(this.rules[i].type==type){
this.rules.splice(i,1);
if(this.linkedErrorLabel&&isValidString(this.linkedErrorLabel.innerHTML)){
this.showMessages();
}
}
}
}
};
function _isClean(){
return(extractValue(this.element)==this.cleanValue);
};
function _hasValidInput(){
for(var i=0;i<this.rules.length;i++){
if(this.rules[i].isRuleBroken(this,this.relatives,this.range,this.optional)){
return false;
}
}
return true;
};
function getFirstRuleBrokenType(){
for(var i=0;i<this.rules.length;i++){
if(this.rules[i].isRuleBroken(this,this.relatives,this.range,this.optional)){
return this.rules[i].type;
}
}
return-1;
};
function _getRulesBroken(useHTML){
var errMsg="";
var lineBreak=(useHTML?"<br />":"\n");
var i;
if(this.useCustomMessage==true){
for(i=0;i<this.rules.length;i++){
if(this.rules[i].isRuleBroken(this,this.relatives,this.range,this.optional)){
errMsg=this.rules[i].msg+this.formIdentifier+lineBreak;
break;
}
}
}else{
for(i=0;i<this.rules.length;i++){
if(this.rules[i].isRuleBroken(this,this.relatives,this.range,this.optional)){
errMsg+=this.rules[i].msg+this.formIdentifier+lineBreak;
}
}
}
return errMsg;
};
function _showMessages(useHTML){
if(this.linkedErrorLabel){
this.linkedErrorLabel.innerHTML=this.getRulesBroken(useHTML);
}
};
function _hideMessages(){
if(this.linkedErrorLabel){
this.linkedErrorLabel.innerHTML="";
}
};
function _getInputString(type){
var regexp=null;
var i=0;
if(isValidString(type)){
var localString=top.getString(type);
if(isValidString(localString)){
if(this.fieldName.length>0){
regexp=new RegExp("{%1}","g");
localString=localString.replace(regexp,this.fieldName);
}
if(this.relativeNames.length>0){
var names="";
for(i=0;i<this.relativeNames.length;i++){
names+=(i>0?", ":"")+this.relativeNames[i];
}
regexp=new RegExp("{%2}","g");
localString=localString.replace(regexp,names);
}
if(this.range.min!=null&&this.range.max!=null){
regexp=new RegExp("{%min}","g");
localString=localString.replace(regexp,this.range.min);
regexp=new RegExp("{%max}","g");
localString=localString.replace(regexp,this.range.max);
}
if(this.invalidList!=null&&this.invalidList!=""){
var charList="";
for(i=0;i<this.invalidList.length;i++){
charList+=this.invalidList.charAt(i)+" ";
}
regexp=new RegExp("{%char-list}");
localString=localString.replace(regexp,charList);
}
if(this.element.getAttribute(InputValidator.MsgInsertTag)){
var msg=top.getString(this.element.getAttribute(InputValidator.MsgInsertTag));
regexp=new RegExp("{%custom-string}");
localString=localString.replace(regexp,msg);
}
if(this.exceptions.length>0){
localString=replaceTrailingChar(localString,".","")+", or "+this.exceptions.toString()+".";
}
}
return(localString==""?"[not found]":localString);
}
};
function _getStringKey(type){
var szValue="";
var useExKey=(this.fieldName.length>0);
switch(parseInt(type)){
case ValidationRule.IpAddress:
case ValidationRule.Ipv6Address:
case ValidationRule.Ipv6AddressPrefOp:
szValue=(useExKey?ValidatedInput.IpRequiredKeyEx:ValidatedInput.IpRequiredKey);
break;
case ValidationRule.EmailAddress:
szValue=(useExKey?ValidatedInput.EmailRequiredKeyEx:ValidatedInput.EmailRequiredKey);
break;
case ValidationRule.Number:
if(this.range.min&&this.range.max){
szValue=(useExKey?ValidatedInput.NumberRangeKeyEx:ValidatedInput.NumberRangeKey);
}else{
szValue=(useExKey?ValidatedInput.NumberRequiredKeyEx:ValidatedInput.NumberRequiredKey);
}
break;
case ValidationRule.Integer:
if(this.range.min&&this.range.max){
szValue=(useExKey?ValidatedInput.IntegerRangeKeyEx:ValidatedInput.IntegerRangeKey);
}else{
szValue=(useExKey?ValidatedInput.IntegerRequiredKeyEx:ValidatedInput.IntegerRequiredKey);
}
break;
case ValidationRule.String:
if(this.range.min&&this.range.max){
if(this.range.min==this.range.max&&useExKey){
szValue=ValidatedInput.StringLengthKeyEx;
}else{
szValue=(useExKey?ValidatedInput.StringRangeKeyEx:ValidatedInput.StringRangeKey);
}
}else{
szValue=(useExKey?ValidatedInput.StringRequiredKeyEx:ValidatedInput.StringRequiredKey);
}
break;
case ValidationRule.Date:
szValue=(useExKey?ValidatedInput.DateRequiredKeyEx:ValidatedInput.DateRequiredKey);
break;
case ValidationRule.Mirror:
szValue=(useExKey?ValidatedInput.InputMatchKeyEx:ValidatedInput.InputMatchKey);
break;
case ValidationRule.NoSpaces:
szValue=(useExKey?ValidatedInput.NoSpacesKeyEx:ValidatedInput.NoSpacesKey);
break;
case ValidationRule.RegExp:
szValue=(useExKey?ValidatedInput.RegexKeyEx:ValidatedInput.RegexKey);
break;
case ValidationRule.InvalidChars:
szValue=(useExKey?ValidatedInput.InvalidCharsKeyEx:ValidatedInput.InvalidCharsKey);
break;
case ValidationRule.Unique:
szValue=(useExKey?ValidatedInput.UniqueKeyEx:ValidatedInput.UniqueKey);
break;
case ValidationRule.Dependent:
szValue=(useExKey?ValidatedInput.DependentKeyEx:ValidateInput.DependentKey);
break;
case ValidationRule.VisibleChars:
szValue=(useExKey?ValidatedInput.VisibleCharsKeyEx:ValidateInput.VisibleCharsKey);
break;
case ValidationRule.Required:
default:
szValue=(useExKey?ValidatedInput.FieldRequiredKeyEx:ValidatedInput.FieldRequiredKey);
}
return szValue;
};
ValidatedInput.prototype.init=_initInput;
ValidatedInput.prototype.addRule=_addRule;
ValidatedInput.prototype.getRule=_getRule;
ValidatedInput.prototype.removeRule=_removeRule;
ValidatedInput.prototype.isClean=_isClean;
ValidatedInput.prototype.hasValidInput=_hasValidInput;
ValidatedInput.prototype.getFirstRuleBrokenType=getFirstRuleBrokenType;
ValidatedInput.prototype.getRulesBroken=_getRulesBroken;
ValidatedInput.prototype.showMessages=_showMessages;
ValidatedInput.prototype.hideMessages=_hideMessages;
ValidatedInput.prototype.getInputString=_getInputString;
ValidatedInput.prototype.getStringKey=_getStringKey;
function ValidationRule(type,msg){
this.type=(isNumber(type)?parseInt(type):null);
this.msg=(isValidString(msg)?msg:"");
};
function _isRuleBroken(validatedInput,obj,range,optional){
var elem=validatedInput.element;
var value=extractValue(elem);
var broken;
var i;
if((""+elem.getAttribute("type")).toLowerCase()=='checkbox'){
if(this.type==ValidationRule.OptionDependents){
if(value==false||elem.disabled==true){
return false;
}
}else{
return false;
}
}
if(validatedInput.optionElement&&validatedInput.optionElement.checked==false){
return false;
}
if(isMissing(value)&&optional){
return false;
}
if(validatedInput.exceptions.length>0){
if(arrayContains(validatedInput.exceptions,value)){
return false;
}
}
switch(this.type){
case ValidationRule.Required:
broken=isMissing(value);
break;
case ValidationRule.IpAddress:
broken=(!isValidIPAddress(value));
break;
case ValidationRule.Ipv6Address:
broken=(!isValidIPv6Address(value));
break;
case ValidationRule.Ipv6AddressPrefOp:
broken=(!isValidIPv6AddressPrefOp(value));
break;
case ValidationRule.EmailAddress:
broken=(!isEmailAddress(value));
break;
case ValidationRule.Date:
broken=(!isDate(value));
break;
case ValidationRule.Number:
broken=(!isNumber(value));
if(!broken&&range.min&&range.max){
broken=(!(parseFloat(value)>=parseFloat(range.min)&&parseFloat(value)<=parseFloat(range.max)));
}
break;
case ValidationRule.Integer:
broken=(!isInteger(value));
if(!broken&&range.min&&range.max){
broken=(!(parseInt(value)>=parseInt(range.min)&&parseInt(value)<=parseInt(range.max)));
}
break;
case ValidationRule.String:
broken=(!isValidString(value));
if(!broken&&range.min&&range.max){
broken=(!(value.length>=parseInt(range.min)&&value.length<=parseInt(range.max)));
}
break;
case ValidationRule.Mirror:
if(isArray(obj)){
for(i=0;i<obj.length;i++){
if(isValidString(obj[i].value)||(isValidString(value)&&obj[i].getAttribute("mirror-controlled")=="true")){
if(!valuesMatch(value,extractValue(obj[i]))){
return true;
}
}
}
}
broken=false;
break;
case ValidationRule.NoSpaces:
broken=hasSpaces(value);
break;
case ValidationRule.VisibleChars:
broken=(value.replace(/\s+/g,"")=="");
break;
case ValidationRule.RegExp:
broken=validatedInput.regExp.test(value);
break;
case ValidationRule.InvalidChars:
broken=containsChars(value,validatedInput.invalidList);
break;
case ValidationRule.Unique:
if(isArray(obj)){
for(i=0;i<obj.length;i++){
if(isValidString(obj[i].value)){
if(valuesMatch(value,extractValue(obj[i]))){
return true;
}
}
}
}
broken=false;
break;
case ValidationRule.Dependent:
if(isArray(obj)){
for(i=0;i<obj.length;i++){
if(!isValidString(extractValue(obj[i]))&&isValidString(value)){
return true;
}
}
}
broken=false;
break;
case ValidationRule.OptionDependents:
if(isArray(obj)){
for(i=0;i<obj.length;i++){
if(isValidString(extractValue(obj[i]))){
return false;
}
}
}
broken=true;
break;
default:
broken=false;
}
return broken;
};
ValidationRule.prototype.isRuleBroken=_isRuleBroken;
function getLabelText(id){
var fieldCaption=document.getElementById(id).innerHTML;
if(isValidString(fieldCaption)){
if(fieldCaption.indexOf(":")!=-1){
return fieldCaption.split(":")[0];
}else if(fieldCaption.indexOf("*")!=-1){
return fieldCaption.split("*")[0];
}else{
return fieldCaption;
}
}else{
return id;
}
}
function valuesMatch(obj1,obj2){
if(!(isMissing(obj1)||isMissing(obj2))){
return(obj1==obj2);
}
return false;
};
function containsChars(value,charList){
for(var i=0;i<charList.length;i++){
var regExp=new RegExp(/[a-z0-9]/i);
var esc=(regExp.test(charList.charAt(i))?"":"\\");
regExp=new RegExp(esc+charList.charAt(i));
if(regExp.test(value)){
return true;
}
}
return false;
};
function extractValue(obj){
if(obj){
if(obj.tagName.toLowerCase()=="select"){
return(obj.options[obj.selectedIndex].value);
}else{
switch((""+obj.getAttribute("type")).toLowerCase()){
case "radio":
case "checkbox":
return obj.checked;
case "textarea":
return obj.value.replace(/\r/ig,"");
case "text":
case "hidden":
case "password":
default:
return obj.value;
}
}
}
return "";
}
