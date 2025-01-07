/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
Module("CallAnalyzer","1.2.0",function(mod){
var MAX_ATTEMPTS=2;
var GATEWAY_ATTEMPTS=3;
var MAP_PATH="/120814-042457/Strings/action-map.xml";
var actionDOM=null;
var enabledStatus=true;
var debugging=top.debugIsActive();
function callAnalyzerDebug(debugState){
debugging=parseBool(debugState);
};
function loadActionMap(url){
try{
var http=importModule('urllib');
actionDOM=http.sendRequest("GET",url);
if(typeof(actionDOM.responseXML.xml)!='undefined'){
if(debugging){
echo("Action map loaded (IE).",3,2,[actionDOM.responseXML.xml]);
}
var xml=importModule('xml');
actionDOM=xml.parseXML(actionDOM.responseXML.xml);
}else{
if(debugging&&typeof(XMLSerializer)!='undefined'){
echo("Action map loaded (Mozilla).",3,2,[new XMLSerializer().serializeToString(actionDOM.responseXML)]);
}
actionDOM=actionDOM.responseXML;
}
}catch(e){
echo("Could not load the action map!",1,7,[e.toString()]);
}
};
function echo(msg,level,severity,extraData){
if(debugging==true){
var entry="Call Analyzer: "+msg;
if(exists(extraData)&&isArray(extraData)){
entry=[entry].concat(extraData);
}
top.logEvent(entry,null,level,severity);
}
};
function getResultType(result){
try{
if(result==null){
return ResultType.Null;
}else if(typeof(result)=='boolean'){
return ResultType.Empty;
}else if(result.xml==""){
return ResultType.Empty;
}else if(result.xml.indexOf("SOAP-ENV:Fault")>-1){
return getSoapErrorStructType(result);
}else{
return ResultType.Normal;
}
}catch(e){
echo("Error in getResultType(result)",1,6,["Result: "+result,e.message]);
return ResultType.Unknown;
}
};
function getSoapErrorStructType(result){
if(getElementValueXpath(result,'//hpoa:faultInfo/hpoa:errorType')==""){
return ResultType.SoapFault;
}else if(getElementValueXpath(result,'//hpoa:internalErrorCode')!=""){
return ResultType.InternalError;
}else if(getElementValueXpath(result,'//hpoa:errorCode')!=""){
return ResultType.StandardError;
}else{
return ResultType.Unknown;
}
};
function getSoapFaultErrorType(result){
if(getElementValueXpath(result,'//SOAP-ENV:Subcode/SOAP-ENV:Value')=="wsse:FailedAuthentication"){
return ErrorType.AuthFailed;
}else{
return ErrorType.UserRequest;
}
};
function assertBitMaskError(errorInfo,resultType){
var errorArray=new Array();
var maskObject=null;
switch(errorInfo.callName){
case 'configureEbipa':
case 'configureEbipaEx':
case 'configureEbipaDev':
maskObject=EbipaErrors;
break;
default:
break;;
}
if(maskObject!=null){
switch(resultType){
case ResultType.StandardError:
var bitcode0=parseInt(errorInfo.bitField0);
var bitcode1=parseInt(errorInfo.bitField1);
if(!isNaN(bitcode0)&&!isNaN(bitcode1)){
extractBitmaskStrings(bitcode0,maskObject.getErrorCodes0(),errorArray);
extractBitmaskStrings(bitcode1,maskObject.getErrorCodes1(),errorArray);
}
break;
case resultType.InternalError:
default:
var bitcode=parseInt(errorInfo.errorNumber);
if(!isNaN(bitcode)){
extractBitmaskStrings(bitcode,maskObject.getErrorCodes(),errorArray,maskObject.getFlipBit());
}
break;
}
if(errorArray.length>0){
errorInfo.errorType=ErrorType.BitMask;
errorInfo.errorString=createErrorListFromArray(errorArray,true);
}
}
};
function stringParseResult(result,startNodeString,endNodeString){
var start=result.xml.indexOf(startNodeString);
var end=result.xml.indexOf(endNodeString);
if(start>-1&&end>-1){
return(result.xml.substring(start+(startNodeString.length),end));
}
return "";
};
function extractBitmaskStrings(errorNumber,maskCodes,errorArray,flipBit){
for(var prop in maskCodes){
var errorFlag=(existsNonNull(flipBit)?maskCodes[prop]&flipBit:maskCodes[prop]);
if((errorNumber&errorFlag)!=0){
var errString=top.getString(prop);
errorArray.push(errString==""?"Bitmask code: "+prop:errString);
}
}
};
function createErrorListFromArray(errorArray,useHtml){
var list="";
var linebreak=(useHtml?"<br />":"\n");
if(isArray(errorArray)&&errorArray.length>0){
for(var i=0;i<errorArray.length;i++){
list+=errorArray[i]+(i==errorArray.length-1?"":linebreak);
}
}
return list;
};
function isLocalizableError(errorInfo){
var canLocalize=true;
if(errorInfo.errorNumber!=""){
switch(errorInfo.errorType){
case ErrorType.OnboardAdmin:
canLocalize=(!arrayContains(FixedOaErrors,errorInfo.errorNumber));
break;
case ErrorType.UserRequest:
canLocalize=(!arrayContains(FixedUserErrors,errorInfo.errorNumber));
break;
}
}
return canLocalize;
};
function assertRetryAllowed(callObject){
if(callObject.attempts>=(callObject.error==HttpErrors.BadGateway||callObject.error==HttpErrors.InService?GATEWAY_ATTEMPTS:MAX_ATTEMPTS)){
echo("Max attempts reached, retry not allowed.",6,3);
callObject.resultType=ResultType.MaxAttempts;
assignAction(callObject);
return false;
}
echo("Max attempts not reached yet, retry will be allowed.",6,3);
return true;
};
function assertCallbackOk(callObject){
if(callObject.actionRequired==ActionType.RetryRequest){
assertRetryAllowed(callObject);
}
switch(callObject.actionRequired){
case ActionType.RetryRequest:
case ActionType.UpdateTopology:
return false;
case ActionType.NotifyCommLoss:
case ActionType.NotifyAuthFailed:
return true;
default:
return true;
}
};
function searchMap(method,resultType,errorType,error){
echo("Received action map query values.",5,3,["Method: "+method,"Result Type: "+resultType,"Error Type: "+(exists(errorType)?errorType:""),"Error Number: "+(exists(error)?error:"")]);
if(exists(errorType)&&exists(error)){
var specificAction=getElementValueXpath(actionDOM,"//method[@name='"+method+"']/result[@type='"+resultType+"']/action[@type='"+errorType+"' and @error='"+error+"']");
if(specificAction!=""){
echo("Found specific action entry in map: "+specificAction,3,1);
return ActionType[specificAction];
}
}
var masterAction=getElementValueXpath(actionDOM,"//method[@name='"+method+"']/result[@type='"+resultType+"']/action[not(@error)]");
if(masterAction!=""){
echo("Found master action entry in map: "+masterAction,3,1);
return ActionType[masterAction];
}
var genericAction=getElementValueXpath(actionDOM,"//method[@name='"+method+"']/action");
if(genericAction!=""){
echo("Found generic action entry in map: "+genericAction,3,1);
return ActionType[genericAction];
}
return ActionType.None;
};
function assignAction(callObject,defaultAction){
var method=callObject.callName;
var resultType=callObject.resultType;
var errorType=callObject.errorType;
var error=callObject.error;
switch(resultType){
case ResultType.SoapFault:
switch(errorType){
case ErrorType.AuthFailed:
callObject.actionRequired=ActionType.NotifyAuthFailed;
break;
default:
callObject.actionRequired=searchMap(method,resultType,errorType,error);
break;
}
break;
case ResultType.Null:
case ResultType.Empty:
case ResultType.Failed:
case ResultType.InternalError:
case ResultType.StandardError:
if(debugging){
echo("Searching action map for "+method+" entry.",3,1,callObject.getProperties());
}
callObject.actionRequired=searchMap(method,resultType,errorType,error);
break;
case ResultType.MaxAttempts:
if(debugging){
echo("Max Attempts for "+method+", searching action map.",1,6,callObject.getProperties());
}
callObject.actionRequired=searchMap(method,resultType,errorType,error);
break;
default:
callObject.actionRequired=searchMap(method,"",errorType,error);
break;
}
if(callObject.actionRequired==ActionType.None&&existsNonNull(defaultAction)){
callObject.actionRequired=defaultAction;
}
echo("Assigned action: "+callObject.actionRequired,3,2);
};
mod.init=function(mapUrl){
loadActionMap((exists(mapUrl)?mapUrl:MAP_PATH));
top.registerDebugListener(callAnalyzerDebug);
};
mod.toggleEnabled=function(enabled){
enabledStatus=enabled;
};
mod.extractErrorInfo=function(result,resultType){
var errorInfo={errorNumber:"",errorType:"",errorString:"",rawString:"",appendString:""}
var type=(exists(resultType)?resultType:getResultType(result));
switch(type){
case ResultType.Null:
errorInfo.errorNumber=ErrorCode.NoResult;
errorInfo.errorType=ErrorType.FormManager;
break;
case ResultType.Empty:
errorInfo.errorNumber=ErrorCode.Unparseable;
errorInfo.errorType=ErrorType.FormManager;
break;
case ResultType.SoapFault:
errorInfo.errorNumber=ErrorCode.SoapFault;
errorInfo.errorType=getSoapFaultErrorType(result);
errorInfo.errorString=getElementValueXpath(result,'//SOAP-ENV:Text');
break;
case ResultType.InternalError:
errorInfo.errorNumber=getElementValueXpath(result,'//hpoa:internalErrorCode');
errorInfo.callName=getElementValueXpath(result,'//hpoa:operationName');
if(arrayContains(BitmaskErrorMethods,errorInfo.callName)){
assertBitMaskError(errorInfo,type);
}
if(!(errorInfo.errorType==ErrorType.BitMask)){
errorInfo.errorNumber=ErrorCode.SoftReply;
errorInfo.errorType=ErrorType.FormManager;
}
break;
case ResultType.StandardError:
errorInfo.errorNumber=getElementValueXpath(result,'//hpoa:errorCode');
errorInfo.errorType=getElementValueXpath(result,'//hpoa:errorType');
errorInfo.rawString=getElementValueXpath(result,'//hpoa:errorText');
errorInfo.callName=getElementValueXpath(result,'//hpoa:operationName');
if(arrayContains(BitmaskErrorMethods,errorInfo.callName)){
errorInfo.bitField0=getElementValueXpath(result,'//hpoa:extraData[@hpoa:name="BitField0"]');
errorInfo.bitField1=getElementValueXpath(result,'//hpoa:extraData[@hpoa:name="BitField1"]');
assertBitMaskError(errorInfo,type);
}else{
if(!(isLocalizableError(errorInfo))){
errorInfo.errorString=errorInfo.rawString;
}
}
break;
case ResultType.Unknown:
default:
errorInfo.errorNumber=stringParseResult(result,'<hpoa:errorCode>','</hpoa:errorCode>');
errorInfo.errorType=stringParseResult(result,'<hpoa:errorType>','</hpoa:errorType>');
errorInfo.rawString=stringParseResult(result,'<hpoa:errorText>','</hpoa:errorText>');
break;
}
if(errorInfo.errorNumber==""){
errorInfo.errorString=getElementValueXpath(result,'//hpoa:errorText');
errorInfo.errorNumber=ErrorCode.NotFound;
errorInfo.errorType=ErrorType.FormManager;
}
if((errorInfo.errorType==ErrorType.OnboardAdmin||errorInfo.errorType==ErrorType.UserRequest)&&arrayContains(ErrorsWithSyslogDetail,errorInfo.errorNumber)){
errorInfo.appendString="seeSyslogForMoreInfo";
}
echo("Error Info extracted.",4,1,["Result Type: "+type,"Error Type: "+
errorInfo.errorType,"Error Number: "+errorInfo.errorNumber,"Error Text: ["+
errorInfo.errorString+"]","Raw Text: ["+errorInfo.rawString+"]","Append String: ["+
errorInfo.appendString+"]"]);
return errorInfo;
};
mod.getErrorString=function(errorInfo,result){
var errString="";
if(!existsNonNull(errorInfo)){
var errorInfo=mod.extractErrorInfo(result);
}
if(errorInfo.errorString!=""){
switch(errorInfo.errorType){
case ErrorType.BitMask:
errString=errorInfo.errorString;
break;
default:
errString=escapeString(errorInfo.errorString);
break;
}
}else{
errString=top.getErrorString(errorInfo.errorNumber,errorInfo.errorType);
}
if(errString==""){
echo("Error string not found for error ("+errorInfo.errorNumber+") of type ("+errorInfo.errorType+")",1,5);
if(errorInfo.rawString!=""){
errString=errorInfo.rawString;
}
}
return errString;
};
mod.analyze=function(callObject){
var callbackOk=true;
if(enabledStatus==false){
return callbackOk;
}
switch(callObject.errorType){
case ErrorType.XhrError:
switch(callObject.error){
case XhrErrors.Incomplete:
case XhrErrors.OpenError:
case XhrErrors.SendError:
callObject.resultType=ResultType.Failed;
assignAction(callObject,ActionType.RetryRequest);
break;
case XhrErrors.TimedOut:
callObject.resultType=ResultType.Failed;
assignAction(callObject,ActionType.CreateTimedOutError);
break;
case XhrErrors.Aborted:
if(debugging){
echo("Analysis detected an aborted call.",1,4,callObject.getProperties());
}
callObject.resultType=ResultType.Empty;
assignAction(callObject,ActionType.Ignore);
switch(callObject.actionRequired){
case ActionType.CreateEventResponse:
case ActionType.CreateApiResponse:
case ActionType.CreateSoapError:
callbackOk=true;
break;
default:
callbackOk=false;
break;
}
break;
default:
break;
}
break;
case ErrorType.HttpError:
switch(callObject.error){
case HttpErrors.BadGateway:
case HttpErrors.InService:
assignAction(callObject,ActionType.RetryRequest);
if(callObject.resultType==ResultType.MaxAttempts){
callObject.actionRequired=ActionType.NotifyCommLoss;
}
break;
case HttpErrors.TimedOut:
assignAction(callObject,ActionType.NotifyCommLoss);
break;
case HttpErrors.BadRequest:
case HttpErrors.InternalError:
case HttpErrors.Unauthorized:
case HttpErrors.NoContent:
case HttpErrors.Forbidden:
case HttpErrors.NotFound:
default:
break;
}
default:
if(callObject.actionRequired==ActionType.None){
callObject.resultType=getResultType(callObject.result);
if(!(callObject.resultType==ResultType.Normal)){
var errorInfo=mod.extractErrorInfo(callObject.result,callObject.resultType);
callObject.errorType=errorInfo.errorType;
callObject.error=errorInfo.errorNumber;
callObject.errorString=errorInfo.errorString;
assignAction(callObject);
}
}
break;
}
if(callbackOk!=false){
callbackOk=assertCallbackOk(callObject);
}
return callbackOk;
};
mod.init();
});
