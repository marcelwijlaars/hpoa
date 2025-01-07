/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function ENCLOSURE_NUM(){return 'encNum'}
function IS_LOCAL(){return 'isLocal'}
function IS_AUTHENTICATED(){return 'isAuthenticated'}
function IS_LOADED(){return 'isLoaded'}
function SOAP_FAULT_TEST(){return 'SOAP-ENV:Fault'}
function SOAP_FAILED_AUTHENTICATION(){return 'wsse:FailedAuthentication'}
function SOAP_METHOD_UNDEFINED(method){return 'SOAP Method is not defined: '+method}
function EBIPA_INVALID_RANGE(){return 'Range setting is not valid for selected enclosures'}
function EBIPAV6_INVALID_RANGE(){return 'Range setting is not valid for selected enclosures'}
function SERVICE_URL(){return 'hpoa'}
function OA_REBOOT_TIMEOUT(){return 200;}
function OA_REBOOT_TIMEOUT_FR(){return 380;}
function GUI_DEFAULT_TIMEOUT(){return 0;}
function MIN_VA(){return 2700}
function MAX_VA(){return 16400}
function VA_TO_BTU(){return 3.412}
function PERMISSION_DENIED(){return 8}
function PRESENT(){return 'PRESENT'}
function ABSENT(){return 'ABSENT'}
function LOCKED(){return 'LOCKED'}
function SO_SELECTED_FLAG(){return 'so_selected'}
function OA_NAMESPACE(){return 'hpoa'}
function OA_NAMESPACE_URI(){return 'hpoa.xsd'}
function OA_NAMESPACE_FULL(){return "xmlns:hpoa='hpoa.xsd'"}
function SOAP_NAMESPACE(){return 'SOAP-ENV'}
function SOAP_NAMESPACE_URI(){return 'http://www.w3.org/2003/05/soap-envelope'}
function SOAP_NAMESPACE_FULL(){return "xmlns:SOAP-ENV='http://www.w3.org/2003/05/soap-envelope'"}
function LOAD_CONTENT_FAILED(){return top.getString('pageContentFailed')}
function LOGIN_FAILED(){return top.getString('loginFailed')}
function EM_MAX_BLADES_PER_ROW_C7000(){return 8}
function EM_MAX_BLADES_PER_ROW_C3000(){return 2}
function EM_MAX_BLADES_C7000(){return 16}
function EM_MAX_BLADES_C3000(){return 8}
function EM_MAX_FANS_C7000(){return 10}
function EM_MAX_FANS_C3000(){return 6}
function EM_MAX_BLADE_ARRAY(){return 48}
function EM_MAX_PS(){return 6}
function EM_MAX_SWITCHES_C7000(){return 8}
function EM_MAX_SWITCHES_C3000(){return 4}
function EM_MAX_MANAGERS(){return 2}
function EM_MAX_USERS(){return 25}
function EM_MAX_GROUPS(){return 20}
function EM_MAX_SNMP_TRAPS(){return 8}
function EM_MIN_EBIPA_ADDRESS(){return 1}
function EM_MAX_EBIPA_ADDRESS(){return 254}
function SUBNET_MAX(){return 254};
function EM_SNMP_TRAP_COMMUNITY(){return "public"}
function EM_MAX_LEN_PRODUCT_NAME(){return 64}
function EM_MAX_LEN_PIPE_NAME(){return 32}
function EM_MAX_LEN_PART_NUMBER(){return 16}
function EM_MAX_LEN_SERIAL_NUMBER(){return 17}
function EM_MAX_LEN_ASSET_TAG(){return 33}
function EM_MAX_LEN_MANUFACTURER(){return 32}
function EM_MAX_LEN_ENC_NAME(){return 33}
function EM_MAX_LEN_RACK_NAME(){return 33}
function EM_MAX_LEN_EV_DATA(){return 300}
function EM_MAX_LEN_SERVER_NAME(){return 32}
function EM_MAX_LEN_OS_NAME(){return 43}
function EM_MAX_LEN_CPU_NAME(){return 32}
function EM_MAX_LEN_MAC_ADDR(){return 20}
function EM_MAX_LEN_ROM_VERSION(){return 17}
function EM_MAX_LEN_USER_NAME(){return 14}
function EM_MAX_LEN_GECOS(){return 44}
function EM_MAX_LEN_REAL_NAME(){return 21}
function EM_MAX_LEN_SNMP_COMMUNITY(){return 21}
function EM_MAX_LEN_SNMP_CONTACT(){return 21}
function EM_MAX_LEN_SNMP_LOCATION(){return 21}
function EM_MAX_LEN_CONTACT_INFO(){return 21}
function EM_MIN_LEN_PASSWORD_RAW(){return 3}
function EM_MAX_LEN_PASSWORD_RAW(){return 9}
function EM_MAX_LEN_PASSWORD_HASH(){return 15}
function EM_MAX_LEN_GROUP_NAME(){return 14}
function EM_MAX_LEN_GROUP_DESC(){return 21}
function EM_MAX_LEN_TIMEZONE(){return 40}
function EM_MAX_LEN_IP_ADDRESS_STRING(){return 16}
function EM_DATA_BLADE_INFO(){return 'hpoa:bladeInfo'}
function EM_DATA_BLADE_STATUS(){return 'hpoa:bladeStatus'}
function EM_DATA_PS_INFO(){return 'hpoa:powerSupplyInfo'}
function EM_DATA_PS_STATUS(){return 'hpoa:powerSupplyStatus'}
function EM_DATA_NETTRAY_INFO(){return 'hpoa:interconnectTrayInfo'}
function EM_DATA_NETTRAY_STATUS(){return 'hpoa:interconnectTrayStatus'}
function EM_DATA_FAN_INFO(){return 'hpoa:fanInfo'}
function EM_DATA_FAN_ZONE(){return 'hpoa:fanZone'}
function EM_DATA_BLADE_MP_INFO(){return 'hpoa:bladeMpInfo'}
function EM_DATA_OA_INFO(){return 'hpoa:oaInfo'}
function EM_DATA_OA_STATUS(){return 'hpoa:oaStatus'}
function EM_DATA_OA_NETWORK_INFO(){return 'hpoa:oaNetworkInfo'}
function BAY(){return 'bay'}
function BLADE(){return 'blade'}
function INTERCONNECT(){return 'interconnect'}
function POWER_SUPPLY(){return 'ps'}
function FAN(){return 'fan'}
function ENCLOSURE_MANAGER(){return 'em'}
function ENCLOSURE_NETWORK(){return 'enc_network'}
function MAX_ENCLOSURES(){return 7}
function ENCLOSURE(){return 'enc'}
function LCD(){return 'lcd'}
function SECURITY(){return 'security'}
function PIM(){return 'pim'}
function POWER_THERMAL(){return 'pt'}
function MP(){return 'mp'}
function PM_BLADE(){return 'pm_blade'}
function PM_INTERCONNECT(){return 'pm_interconnect'}
function DVD(){return 'dvd'}
function REMOTE_SUPPORT(){return 'ers'}
function ACTIVE_HEALTH_SYSTEM(){return 'active_health_system'}
function ONBOARD_ADMINISTRATOR_BAY(){return 'ONBOARD_ADMINISTRATOR_BAY'}
function SERVER_BLADE_BAY(){return 'SERVER_BLADE_BAY'}
function INTERCONNECT_TRAY_BAY(){return 'INTERCONNECT_TRAY_BAY'}
function EBIPA_DEVICE_BOTH(){return 'EBIPA_DEVICE_BOTH'}
function POWER_SUPPLIES(){return 'POWER_SUPPLIES'}
function EBIPAV6_DEVICE_BOTH(){return 'EBIPAV6_DEVICE_BOTH'}
function STATUS_NORMAL(){return 'STATUS_NORMAL'}
function STATUS_UNKNOWN(){return 'STATUS_UNKNOWN'}
function STATUS_FAILED(){return 'STATUS_FAILED'}
function STATUS_DEGRADED(){return 'STATUS_DEGRADED'}
function STATUS_MAJOR(){return 'STATUS_MAJOR'}
function STATUS_MINOR(){return 'STATUS_MINOR'}
function STATUS_WARNING(){return 'STATUS_WARNING'}
function OP_STATUS_UNKNOWN(){return 'OP_STATUS_UNKNOWN'}
function OP_STATUS_OTHER(){return 'OP_STATUS_OTHER'}
function OP_STATUS_OK(){return 'OP_STATUS_OK'}
function OP_STATUS_DEGRADED(){return 'OP_STATUS_DEGRADED'}
function OP_STATUS_STRESSED(){return 'OP_STATUS_STRESSED'}
function OP_STATUS_PREDICTIVE_FAILURE(){return 'OP_STATUS_PREDICTIVE_FAILURE'}
function OP_STATUS_NON_RECOVERABLE_ERROR(){return 'OP_STATUS_NON-RECOVERABLE_ERROR'}
function OP_STATUS_ERROR(){return 'OP_STATUS_ERROR'}
function OP_STATUS_STARTING(){return 'OP_STATUS_STARTING'}
function OP_STATUS_STOPPING(){return 'OP_STATUS_STOPPING'}
function OP_STATUS_STOPPED(){return 'OP_STATUS_STOPPED'}
function OP_STATUS_IN_SERVICE(){return 'OP_STATUS_IN_SERVICE'}
function OP_STATUS_NO_CONTACT(){return 'OP_STATUS_NO_CONTACT'}
function OP_STATUS_LOST_COMMUNICATION(){return 'OP_STATUS_LOST_COMMUNICATION'}
function OP_STATUS_ABORTED(){return 'OP_STATUS_ABORTED'}
function OP_STATUS_DORMANT(){return 'OP_STATUS_DORMANT'}
function OP_STATUS_SUPPORTING_ENTITY_IN_ERROR(){return 'OP_STATUS_SUPPORTING_ENTITY_IN_ERROR'}
function OP_STATUS_COMPLETED(){return 'OP_STATUS_COMPLETED'}
function OP_STATUS_POWER_MODE(){return 'OP_STATUS_POWER_MODE'}
function OP_STATUS_DMTF_RESERVED(){return 'OP_STATUS_DMTF_RESERVED'}
function OP_STATUS_VENDER_RESERVED(){return 'OP_STATUS_VENDER_RESERVED'}
function UID_CMD_TOGGLE(){return 'UID_CMD_TOGGLE'}
function UID_CMD_ON(){return 'UID_CMD_ON'}
function UID_CMD_OFF(){return 'UID_CMD_OFF'}
function UID_CMD_BLINK(){return 'UID_CMD_BLINK'}
function UID_ON(){return 'UID_ON'}
function UID_OFF(){return 'UID_OFF'}
function UID_BLINK(){return 'UID_BLINK'}
function LANGUAGE_COOKIE_NAME(){return 'UserPref-Language'}
function MAX_CONNECTIONS_COOKIE_NAME(){return 'UserPref-MaxConnections'}
function SIM_SSO_COOKIE_NAME(){return 'HP-HMMD'}
function LOCAL_ENC_COOKIE_NAME(){return 'encLocalKey'}
function LINKED_ENC_COOKIE_NAME(){return 'encLinkedKey'}
function LOCAL_ENC_USER_NAME(){return 'encLocalUser'}
function GUI_TIMEOUT_COOKIE_NAME(){return 'UserPref-Timeout'}
function USER_PREFERENCES_COOKIE_NAME(){return 'UserPref'}
function USER_PREFERENCES_LANGUAGE(){return 'langPref'}
function USER_PREFERENCES_SHOW_PEAK_POWER(){return 'peakPwr'}
function USER_PREFERENCES_SHOW_AVERAGE_POWER(){return 'avgPwr'}
function USER_PREFERENCES_SHOW_MIN_POWER(){return 'minPwr'}
function USER_PREFERENCES_SHOW_POWER_CAP(){return 'pwrCap'}
function USER_PREFERENCES_SHOW_DERATED(){return 'derated'}
function USER_PREFERENCES_SHOW_RATED(){return 'rated'}
function USER_PREFERENCES_SHOW_IN_WATTS(){return 'inWatts'}
function USER_PREFERENCES_UNITS_FOR_PEAK(){return 'unitsForPeak'}
function USER_PREFERENCES_UNITS_FOR_AVG(){return 'unitsForAvg'}
function USER_PREFERENCES_VOLTAGE(){return 'voltage'}
function NET_PROTO_SNMP(){return 'NET_PROTO_SNMP'}
function NET_PROTO_SSH(){return 'NET_PROTO_SSH'}
function NET_PROTO_TELNET(){return 'NET_PROTO_TELNET'}
function NET_PROTO_HTTP(){return 'NET_PROTO_HTTP'}
function NET_PROTO_NTP(){return 'NET_PROTO_NTP'}
function NET_PROTO_IPSECURITY(){return 'NET_PROTO_IPSECURITY'}
function NET_PROTO_ALERTMAIL(){return 'NET_PROTO_ALERTMAIL'}
function NET_PROTO_EBIPA_SVB(){return 'NET_PROTO_EBIPA_SVB'}
function NET_PROTO_EBIPA_SWM(){return 'NET_PROTO_EBIPA_SWM'}
function NET_PROTO_EBIPAV6_SVB(){return 'NET_PROTO_EBIPAV6_SVB'}
function NET_PROTO_EBIPAV6_SWM(){return 'NET_PROTO_EBIPAV6_SWM'}
function NET_PROTO_XMLREPLY(){return 'NET_PROTO_XMLREPLY'}
function NET_PROTO_DYNDNS(){return 'NET_PROTO_DYNDNS'}
function NET_PROTO_IPSWAP(){return 'NET_PROTO_IPSWAP'}
function NET_PROTO_GUI_LOGIN_DETAIL(){return 'NET_GUI_LOGIN_DETAIL'}
function NET_PROTO_ACTIVE_HEALTH_SYSTEM(){return 'NET_PROTO_ACTIVE_HEALTH_SYSTEM'}
function NET_PROTO_ILO_FEDERATION(){return 'NET_ILO_FEDERATION'}
function NET_PROTO_SSH_KEX_DHG1(){return 'NET_PROTO_SSH_KEX_DHG1'}
function NET_PROTO_FQDN(){return 'NET_PROTO_FQDN'}
function NET_PROTO_TLS10(){return 'NET_PROTO_TLS10'}
function NET_PROTO_TLS11(){return 'NET_PROTO_TLS11'}
function NET_PROTO_TLS12(){return 'NET_PROTO_TLS12'}
function PRESS_AND_HOLD(){return 'PRESS_AND_HOLD'}
function MOMENTARY_PRESS(){return 'MOMENTARY_PRESS'}
function COLD_BOOT(){return 'COLD_BOOT'}
function RESET(){return 'RESET'}
function MANUAL_OVERRIDE(){return 'MANUAL_OVERRIDE'}
function FIRMWARE_IMAGE(){return 'FIRMWARE_IMAGE'}
function LCD_IMAGE(){return 'LCD_IMAGE'}
function FIRMWARE_INTERNAL_IMAGE(){return 'FIRMWARE_INTERNAL_IMAGE'}
function PROLIANT_MP_IMAGE(){return 'PROLIANT_MP_IMAGE'}
function MAXIMUM(){return 'MAXIMUM'}
function AUTOMATIC(){return 'AUTOMATIC'}
function NOT_REDUNDANT(){return 'NOT_REDUNDANT'}
function AC_REDUNDANT(){return 'AC_REDUNDANT'}
function POWER_SUPPLY_REDUNDANT(){return 'POWER_SUPPLY_REDUNDANT'}
function AC_REDUNDANT_WITH_OVERSUBSCRIPTION(){return 'AC_REDUNDANT_WITH_OVERSUBSCRIPTION'}
function LCD_OK(){return 'LCD_OK'}
function LCD_UP(){return 'LCD_UP'}
function LCD_DOWN(){return 'LCD_DOWN'}
function LCD_LEFT(){return 'LCD_LEFT'}
function LCD_RIGHT(){return 'LCD_RIGHT'}
function RELEASED(){return 'RELEASED'}
function PRESSED(){return 'PRESSED'}
function STATEMENT(){return 'STATEMENT'}
function QUESTION(){return 'QUESTION'}
function ANSWER(){return 'ANSWER'}
function ACTIVE(){return 'ACTIVE'}
function STANDBY(){return 'STANDBY'}
function ADMINISTRATOR(){return 'Administrator'}
function OPERATOR(){return 'Operator'}
function USER(){return 'user'}
function GROUP(){return 'group'}
function INTERCONNECT_TRAY_PORT_STATUS_UNKOWN(){return 'INTERCONNECT_TRAY_PORT_STATUS_UNKOWN'}
function INTERCONNECT_TRAY_PORT_STATUS_OK(){return 'INTERCONNECT_TRAY_PORT_STATUS_OK'}
function INTERCONNECT_TRAY_PORT_STATUS_MISMATCH(){return 'INTERCONNECT_TRAY_PORT_STATUS_MISMATCH'}
function HPSIM_DISABLED(){return 'HPSIM_DISABLED'}
function TRUST_BY_CERTIFICATE(){return 'TRUST_BY_CERTIFICATE'}
function MAX_CONNECTIONS(){return 2;}
function PDU_TYPE_1(){return "413374-B21";}
function PDU_TYPE_2(){return "413375-B21";}
function PDU_TYPE_3(){return "413376-B21";}
function PDU_TYPE_5(){return "663698-001";}
function OA_FIPS_MODE_ON(){return "FIPS-ON"}
function OA_FIPS_MODE_OFF(){return "FIPS-OFF"}
function OA_FIPS_MODE_DEBUG(){return "FIPS-DEBUG"}
function OA_FIPS_MODE_SECURE_DEGRADED(){return "SECURE-DEGRADED"}
function OA_FIPS_MODE_DEBUG_DEGRADED(){return "DEBUG-DEGRADED"}
var FixedOaErrors=['108','374'];
var FixedUserErrors=[];
var ErrorsWithSyslogDetail=['368','383','385','528','532','561','562'];
var BitmaskErrorMethods=['configureEbipa','configureEbipaEx','configureEbipaDev'];
var CallState={
Success:'Success',
Pending:'Pending',
Failed:'Failed',
Error:'Error',
TimedOut:'TimedOut',
Cancel:'Canceled',
None:'None'
};
var BatchState={
None:'None',
Queue:'Queue',
Loading:'Loading',
Complete:'Complete',
TimedOut:'TimedOut',
Aborted:'Aborted'
};
var ReportMode={
Normal:'Normal',
Percent:'Percent'
};
var ErrorStructType={
Empty:'Empty',
SoapFault:'SoapFault',
InternalError:'InternalError',
StandardError:'StandardError',
Unknown:'Unknown'
};
var ErrorType={
FormManager:'FORM_MANAGER',
OnboardAdmin:'ONBOARD_ADMINISTRATOR',
AuthFailed:'AUTH_FAILED',
UserRequest:'USER_REQUEST',
HttpError:'HTTP_ERROR',
XhrError:'XHR_ERROR',
BitMask:'BITMASK',
Unknown:'UNKNOWN'
};
var SupportedXhrTypes={
ActiveX:'ActiveX',
Native:'Native',
NoSupport:'NoSupport'
};
var XhrErrors={
None:'None',
Incomplete:'Incomplete',
OpenError:'OpenError',
SendError:'SendError',
TimedOut:'TimedOut',
Aborted:'Aborted'
};
var HttpErrors={
None:200,
NoContent:204,
NotModified:304,
BadRequest:400,
Unauthorized:401,
Forbidden:403,
NotFound:404,
TimedOut:408,
InternalError:500,
BadGateway:502,
InService:503
};
var EventErrors={
NoOpenPipe:'201',
WrongSize:'202',
WrongLength:'203',
Terminated:'204'
};
var EventRunStates={
Stopped:'Stopped',
Paused:'Paused',
Started:'Started',
Ready:'Ready'
};
var EventThrottle={
Auto:'Auto',
None:'None'
};
var ErrorCode={
TimedOut:'300',
Aborted:'301',
InvalidMethod:'302',
Unexpected:'303',
Unparseable:'304',
SoftReply:'305',
NoResult:'306',
BatchTimedOut:'307',
TfaAuthFailed:'308',
HttpsDisabled:'309',
SoapFault:'400',
NotFound:'999'
};
var ResultType={
Null:'Null',
Empty:'Empty',
Normal:'Normal',
SoapFault:'SoapFault',
InternalError:'InternalError',
StandardError:'StandardError',
MaxAttempts:'MaxAttempts',
Failed:'Failed',
Unknown:'Unknown'
};
var ActionType={
None:'None',
UpdateTopology:'UpdateTopology',
NotifyCommLoss:'NotifyCommLoss',
NotifyPipeLoss:'NotifyPipeLoss',
NotifyAuthFailed:'NotifyAuthFailed',
RetryRequest:'RetryRequest',
UseLocalOnly:'UseLocalOnly',
UseStandbyMode:'UseStandbyMode',
CreateApiResponse:'CreateApiResponse',
CreateEventResponse:'CreateEventResponse',
CreateTimedOutError:'CreateTimedOutError',
CreateSoapError:'CreateSoapError',
Ignore:'Ignore'
};
var ResponseClones={
Normal:'Normal',
Event:'Event',
SoapError:'SoapError',
InternalError:'InternalError'
};
var ConnectionTypes={
Primary:'P',
Linked:'L'
};
var ConnectionStates={
None:'NoConnection',
Initializing:'Initializing',
EventsStopped:'EventsStopped',
EventsStarted:'EventsStarted',
Unloading:'Unloading',
Waiting:'Waiting',
Ready:'Ready'
};
var TopologyModes={
Local:'Local',
Linked:'Linked',
Fixed:'Fixed',
DisplayOn:'DisplayOn',
DisplayOff:'DisplayOff'
};
var TopologyStates={
None:'NoState',
Broken:'Broken',
Updating:'Updating',
Complete:'Complete',
FlashPending:'FlashPending',
FlashComplete:'FlashComplete',
Wizard:'Wizard'
};
var FlashObjectTypes={
LowerLinked:'LowerLinked',
UpperLinked:'UpperLinked',
Primary:'Primary'
};
var UserContextTypes={
DevicePage:'DevicePage',
RackOverview:'RackOverview',
OaFirmwareUpdate:'OaFirmwareUpdate',
LoadOrFlash:'LoadOrFlash',
Login:'Login',
WizardSteps:'WizardSteps',
WizardWelcome:'WizardWelcome',
WizardEncSelect:'WizardEncSelect',
WizardFinish:'WizardFinish',
Standby:'Standby',
None:'None'
};
var AlertReasons={
PrimarySubscribe:'PrimarySubscribe',
PrimaryCommLoss:'PrimaryCommLoss',
PrimaryPipeLoss:'PrimaryPipeLoss',
PrimaryEncType:'PrimaryEncType',
LinkedFlash:'LinkedFlash',
InvalidSession:'InvalidSession',
StandbyMode:'StandbyMode',
WebServerDown:'WebServerDown'
};
var AlertStates={
None:'AlertNone',
LoggingOut:'LoggingOut'
};
var PollStates={
Started:'Started',
Stopped:'Stopped'
};
var LoadStates={
None:'LoadNone',
Loading:'Loading',
Complete:'LoadComplete'
};
var CallTypes={
API:'API',
Event:'Event'
};
var SourceTypes={
None:'None',
Upload:'Upload',
Download:'Download'
};
var FlashStates={
None:0,
Downloading:1,
Pending:2,
Buffering:3,
Flashing:4,
Complete:5,
Failed:6,
Unknown:7
};
var ReadyStates={
New:0,
Open:1,
Sent:2,
Data:3,
Complete:4
};
function REGEX_TIME(){return/^(0[0-9]|1[0-9]|2[0-3]):[0-5]\d$/;}
function REGEX_DATE(){return/^((20[0-2][0-9]|203[0-7])-(0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-9]|3[0-1]))|(2038-01-(0[1-9]|1[0-9]))$/;}
var AlertMsgTypes={
Default:0,
Information:1,
Normal:2,
Warning:3,
NotAllowed:4,
Critical:5,
Question:6
};
var UserTypes={
Local:0,
LDAP:1,
HPSIM:2
};
var RemoteSupportTypes={
DoNotConnect:"ERS_MODE_DISABLED",
DirectConnect:"ERS_MODE_DIRECT",
InsightRemote:"ERS_MODE_IRS"
};
var EbipaErrors={
toString:function(){return "EbipaErrors"},
getErrorCodes0:function(){return{
EM_ERR_EBIPA_NETMASK:0x00000001,
EM_ERR_EBIPA_GATEWAY:0x00000002,
EM_ERR_EBIPA_GATEWAY_UNREACH:0x00000004,
EM_ERR_EBIPA_DOMAIN:0x00000008,
EM_ERR_EBIPA_BAY_IPADDRESS1:0x00000010,
EM_ERR_EBIPA_BAY_IPADDRESS2:0x00000020,
EM_ERR_EBIPA_BAY_IPADDRESS3:0x00000040,
EM_ERR_EBIPA_BAY_IPADDRESS4:0x00000080,
EM_ERR_EBIPA_BAY_IPADDRESS5:0x00000100,
EM_ERR_EBIPA_BAY_IPADDRESS6:0x00000200,
EM_ERR_EBIPA_BAY_IPADDRESS7:0x00000400,
EM_ERR_EBIPA_BAY_IPADDRESS8:0x00000800,
EM_ERR_EBIPA_BAY_IPADDRESS9:0x00001000,
EM_ERR_EBIPA_BAY_IPADDRESS10:0x00002000,
EM_ERR_EBIPA_BAY_IPADDRESS11:0x00004000,
EM_ERR_EBIPA_BAY_IPADDRESS12:0x00008000,
EM_ERR_EBIPA_BAY_IPADDRESS13:0x00010000,
EM_ERR_EBIPA_BAY_IPADDRESS14:0x00020000,
EM_ERR_EBIPA_BAY_IPADDRESS15:0x00040000,
EM_ERR_EBIPA_BAY_IPADDRESS16:0x00080000,
EM_ERR_EBIPA_BAY_IPADDRESS1A:0x00100000,
EM_ERR_EBIPA_BAY_IPADDRESS2A:0x00200000,
EM_ERR_EBIPA_BAY_IPADDRESS3A:0x00400000,
EM_ERR_EBIPA_BAY_IPADDRESS4A:0x00800000,
EM_ERR_EBIPA_BAY_IPADDRESS5A:0x01000000,
EM_ERR_EBIPA_BAY_IPADDRESS6A:0x02000000,
EM_ERR_EBIPA_BAY_IPADDRESS7A:0x04000000,
EM_ERR_EBIPA_BAY_IPADDRESS8A:0x08000000,
EM_ERR_EBIPA_BAY_IPADDRESS9A:0x10000000,
EM_ERR_EBIPA_BAY_IPADDRESS10A:0x20000000,
EM_ERR_EBIPA_BAY_IPADDRESS11A:0x40000000,
EM_ERR_EBIPA_BAY_IPADDRESS12A:0x80000000
}
},
getErrorCodes1:function(){return{
EM_ERR_EBIPA_BAY_IPADDRESS13A:0x00000001,
EM_ERR_EBIPA_BAY_IPADDRESS14A:0x00000002,
EM_ERR_EBIPA_BAY_IPADDRESS15A:0x00000004,
EM_ERR_EBIPA_BAY_IPADDRESS16A:0x00000008,
EM_ERR_EBIPA_BAY_IPADDRESS1B:0x00000010,
EM_ERR_EBIPA_BAY_IPADDRESS2B:0x00000020,
EM_ERR_EBIPA_BAY_IPADDRESS3B:0x00000040,
EM_ERR_EBIPA_BAY_IPADDRESS4B:0x00000080,
EM_ERR_EBIPA_BAY_IPADDRESS5B:0x00000100,
EM_ERR_EBIPA_BAY_IPADDRESS6B:0x00000200,
EM_ERR_EBIPA_BAY_IPADDRESS7B:0x00000400,
EM_ERR_EBIPA_BAY_IPADDRESS8B:0x00000800,
EM_ERR_EBIPA_BAY_IPADDRESS9B:0x00001000,
EM_ERR_EBIPA_BAY_IPADDRESS10B:0x00002000,
EM_ERR_EBIPA_BAY_IPADDRESS11B:0x00004000,
EM_ERR_EBIPA_BAY_IPADDRESS12B:0x00008000,
EM_ERR_EBIPA_BAY_IPADDRESS13B:0x00010000,
EM_ERR_EBIPA_BAY_IPADDRESS14B:0x00020000,
EM_ERR_EBIPA_BAY_IPADDRESS15B:0x00040000,
EM_ERR_EBIPA_BAY_IPADDRESS16B:0x00080000,
EM_ERR_EBIPA_DNS1:0x00100000,
EM_ERR_EBIPA_DNS2:0x00200000,
EM_ERR_EBIPA_DNS3:0x00400000,
EM_ERR_EBIPA_NTP1:0x00800000,
EM_ERR_EBIPA_NTP2:0x01000000,
EM_ERR_EBIPA_DUP_IPADDRESS:0x02000000,
EM_ERR_EBIPA_ALREADY_ENABLED:0x04000000,
EM_ERR_EBIPA_ALREADY_DISABLED:0x08000000
}
},
getHighBit:function(){return 0x80000000},
getFlipBit:function(){return 0x7FFFFFFF},
getErrorCodes:function(){return{
EM_ERR_EBIPA:0x80000000,
EM_ERR_EBIPA_NETMASK:0x80000001,
EM_ERR_EBIPA_GATEWAY:0x80000002,
EM_ERR_EBIPA_GATEWAY_UNREACH:0x80000004,
EM_ERR_EBIPA_DOMAIN:0x80000008,
EM_ERR_EBIPA_DNS1:0x80100000,
EM_ERR_EBIPA_DNS2:0x80200000,
EM_ERR_EBIPA_DNS3:0x80400000,
EM_ERR_EBIPA_NTP1:0x80800000,
EM_ERR_EBIPA_NTP2:0x81000000,
EM_ERR_EBIPA_DUP_IPADDRESS:0x82000000,
EM_ERR_EBIPA_BAY_IPADDRESS1:0x80000010,
EM_ERR_EBIPA_BAY_IPADDRESS2:0x80000020,
EM_ERR_EBIPA_BAY_IPADDRESS3:0x80000040,
EM_ERR_EBIPA_BAY_IPADDRESS4:0x80000080,
EM_ERR_EBIPA_BAY_IPADDRESS5:0x80000100,
EM_ERR_EBIPA_BAY_IPADDRESS6:0x80000200,
EM_ERR_EBIPA_BAY_IPADDRESS7:0x80000400,
EM_ERR_EBIPA_BAY_IPADDRESS8:0x80000800,
EM_ERR_EBIPA_BAY_IPADDRESS9:0x80001000,
EM_ERR_EBIPA_BAY_IPADDRESS10:0x80002000,
EM_ERR_EBIPA_BAY_IPADDRESS11:0x80004000,
EM_ERR_EBIPA_BAY_IPADDRESS12:0x80008000,
EM_ERR_EBIPA_BAY_IPADDRESS13:0x80010000,
EM_ERR_EBIPA_BAY_IPADDRESS14:0x80020000,
EM_ERR_EBIPA_BAY_IPADDRESS15:0x80040000,
EM_ERR_EBIPA_BAY_IPADDRESS16:0x80080000
}
}
};
var EnclosureTypes={
Unknown:-1,
c7000:0,
c3000:1
};
var IPClasses={
Unknown:-1,
ClassA:1,
ClassB:2,
ClassC:3
};
var cacheList=[
["/120814-042457/Templates/xsltProcessorTest.xsl","Xslt Processor Test Template"],
["/120814-042457/Templates/topology.xsl","Topology Template"],
["/120814-042457/Templates/topologyChangeTest.xsl","Topology Validation Template"],
["/120814-042457/Templates/progressBar.xsl","Progress Bar Template"],
["/120814-042457/Templates/alertManager.xsl","Alert Dialog Template"],
["/120814-042457/Templates/systemStatusData.xsl","System Status Data Template"],
["/120814-042457/Templates/systemStatus.xsl","System Status Template"],
["/120814-042457/Templates/systemStatusTray.xsl","Status Tray Template"],
["/120814-042457/Templates/treeNav.xsl","Tree View Template"],
["/120814-042457/Templates/treeNavEnclosure.xsl","Tree Enclosure Template"],
["/120814-042457/Templates/treeShortcutLink.xsl","Tree Shortcut Link Template"],
["/120814-042457/Templates/waitContainer.xsl","Wait Container Template"],
["/120814-042457/Templates/rackOverview.xsl","Rack Overview Template"],
["/120814-042457/Templates/rackOverviewEnclosure.xsl","Enclosure Template"],
["/120814-042457/Templates/rackOverviewEncInfo.xsl","Enclosure Info Template"]
];
var noCacheItems=[
"help-about.xsl"
];
var scriptPaths=[
['/120814-042457/js/browser.js','Browser Scripts'],
['/120814-042457/js/descriptor.js','Soap Descriptor'],
['/120814-042457/js/listeners.js','Listener Collection Class'],
['/120814-042457/js/domBuilder.js','Dom Builder Class'],
['/120814-042457/js/formManager.js','Form Manager Class'],
['/120814-042457/js/displayManager.js','Display Manager Class'],
['/120814-042457/js/inputValidator.js','Input Validator Class'],
['/120814-042457/js/batchManager.js','Batch Manager Class'],
['/120814-042457/js/events.js','Events Class'],
['/120814-042457/js/hpem.js','Onboard Administrator Class'],
['/120814-042457/js/init.js','Init Module'],
['/120814-042457/js/urllib.js','Url Module'],
['/120814-042457/js/xml.js','Xml Module'],
['/120814-042457/js/xslt.js','Xslt Processor Class'],
['/120814-042457/js/topology.js','Topology Module'],
['/120814-042457/js/http.js','Http Wrapper Class'],
['/120814-042457/js/callAnalyzer.js','Soap Analyzer Module'],
['/120814-042457/js/globalSoap.js','Soap Module'],
['/120814-042457/js/transport.js','Transport Module'],
['/120814-042457/js/eventManager.js','Event Manager Module'],
['/120814-042457/js/globalModules.js','Module Accessor Scripts'],
['/120814-042457/js/stringManager.js','String Manager Class']
];
var NodeTypes={
ELEMENT_NODE:1,
ATTRIBUTE_NODE:2,
TEXT_NODE:3,
CDATA_SECTION_NODE:4,
ENTITY_REFERENCE_NODE:5,
ENTITY_NODE:6,
PROCESSING_INSTRUCTION_NODE:7,
COMMENT_NODE:8,
DOCUMENT_NODE:9,
DOCUMENT_TYPE_NODE:10,
DOCUMENT_FRAGMENT_NODE:11,
NOTATION_NODE:12
};
