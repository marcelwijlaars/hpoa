/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
var gXml=null;
var gUrlLib=null;
var gTopology=null;
var gTransport=null;
var gSoapModule=null;
var gCallAnalyzer=null;
var gEventManager=null;
var gStringManager=null;
function _logImportError(type,severity,error){
var msg="Could not import the global "+type+" module!";
if(error!=undefined){
msg=[msg,error];
}
if(typeof(top.logEvent)=='function'){
top.logEvent(msg,null,1,severity);
}
}
function getXml(){
if(gXml==null){
try{
gXml=importModule('xml');
}catch(e){
_logImportError("XML",6,e.message);
}
}
return gXml;
}
function getUrlLib(){
if(gUrlLib==null){
try{
gUrlLib=importModule('urllib');
}catch(e){
_logImportError("URL",6,e.message);
}
}
return gUrlLib;
}
function getSoapModule(){
if(gSoapModule==null){
try{
gSoapModule=importModule('Soap');
}catch(e){
_logImportError("Soap",6,e.message);
}
}
return gSoapModule;
}
function getCallAnalyzer(){
if(gCallAnalyzer==null){
try{
gCallAnalyzer=importModule('CallAnalyzer');
}catch(e){
_logImportError("Call Analyzer",6,e.message);
}
}
return gCallAnalyzer;
}
function getTopology(){
if(gTopology==null){
try{
gTopology=importModule('topology');
}catch(e){
_logImportError("Topology",6,e.message);
}
}
return gTopology;
}
function getTransport(){
if(gTransport==null){
try{
gTransport=importModule('Transport');
}catch(e){
_logImportError("Transport",6,e.message);
}
}
return gTransport;
}
function getEventManager(){
if(gEventManager==null){
try{
gEventManager=importModule('EventManager');
}catch(e){
_logImportError("Event Manager",6,e.message);
}
}
return gEventManager;
}
function getStringManager(){
if(gStringManager==null){
try{
gStringManager=importModule('StringManager');
}catch(e){
_logImportError("String Manager",6,e.message);
}
}
return gStringManager;
}
