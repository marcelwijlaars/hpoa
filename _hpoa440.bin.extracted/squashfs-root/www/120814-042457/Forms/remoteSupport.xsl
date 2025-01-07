<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2011 Hewlett-Packard Development Company, L.P.
  -->
  <xsl:include href="../Templates/globalTemplates.xsl"/>
  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="ersConfigInfoDoc" />
  <xsl:param name="serviceUserAcl" />
  
  <xsl:variable name="overridden" select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersSolutionOverrideStatus'] = 'true'" />
  <xsl:variable name="mode" select="$ersConfigInfoDoc//hpoa:ersMode" />
  <xsl:variable name="activated" select="$ersConfigInfoDoc//hpoa:ersEnabled = 'true'" />
  <xsl:variable name="onlineRegistrationComplete" select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersOnlineRegistrationComplete'] = 'true'" />
  <xsl:variable name="ersLockDirect" select="(count($ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersLockDirect']) = 0) or ($ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersLockDirect'] != 'false')" />
  <xsl:variable name="fullyActivated" select="$activated = true() and (($mode = $ERS_MODE_IRS) or ($onlineRegistrationComplete = true()))" />

  <!-- 
  ==========================================================================================
    @Purpose   : configure or update eRS settings.
    
    @notes     : dual purpose form; will present both connection options when not activated,
                 otherwise will present edit mode for the currently active service.
                 
    @dev       : TODO: stringify text for japanese.
    
  ==========================================================================================
  -->
  <xsl:template name="ersConfiguration" match="*">
    
    <xsl:choose>
      <xsl:when test="$overridden = true()">
        <xsl:call-template name="ersHeader" />                
      </xsl:when>
      <xsl:otherwise>
        <!-- MAIN FORM -->
        <div style="border:none;padding:0px;">
          <table style="vertical-align:top;width:100%;border:0px;padding:0px;border-collapse:collapse;">
            <tr>
              <td style="vertical-align:top;width:100%;">
                <xsl:call-template name="ersHeader" />  
              </td>
            </tr>
          </table>        
          
          <xsl:if test="$fullyActivated != true()">
            <xsl:choose>
              <xsl:when test="$ersLockDirect = true()">
                <!-- IRS ONLY -->               
                <table border="0" width="100%" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="10%">                          
                      <label>
                        <xsl:element name="div">
                          <xsl:attribute name="style">box-sizing:border-box;cursor:pointer;width:325px;height:90px;background-image:url('/120814-042457/images/remote-support-irs.gif');background-repeat:no-repeat;filter:progid:DXImageTransform.Microsoft.Shadow(color=white, direction=135 strength=5)progid:DXImageTransform.Microsoft.Shadow(color=white, direction=295 strength=5)</xsl:attribute>
                          <xsl:attribute name="title"><xsl:value-of select="$stringsDoc//value[@key='remoteSupportRemoteTip']" /></xsl:attribute>
                          <xsl:attribute name="onmouseover">this.style.boxShadow='0px 0px 10px #99CCFF';this.style.filter='progid:DXImageTransform.Microsoft.Glow(color=#99CCFF, strength=5)';</xsl:attribute>                               
                          <xsl:attribute name="onmouseout">this.style.boxShadow='';this.style.filter='progid:DXImageTransform.Microsoft.Shadow(color=white, direction=135 strength=5)progid:DXImageTransform.Microsoft.Shadow(color=white, direction=295 strength=5)'</xsl:attribute>                           
                        </xsl:element>
                      </label>
                      <br />
                    </td>   
                    <td width="auto">
                      <input type="radio" value="ERS_MODE_IRS" style="margin:0px;height:1px;width:1px;visibility:hidden;" checked="checked" id="remoteSupportIRS" name="remoteSupportType" />
                    </td>
                  </tr>
                </table>
                            
                <form id="frmIrs" style="display:block;">
                  <table id="tblRemote" border="0" cellpadding="0" cellspacing="0" style="width:100%;margin:0px;">
                    <tr>
                      <th style="text-align:left;padding:3px;background-color:#716B66;color:#fff;font-weight:bold;">
                        <xsl:value-of select="$stringsDoc//value[@key='connectToRemoteSupportServer']"/>
                      </th>
                    </tr>
                    <tr>
                      <td valign="top" style="border:1px solid #ccc;padding:10px 0px 10px 10px;">
                        <xsl:call-template name="modeRemote" /> 
                        <br />
                      </td>
                    </tr>
                  </table>
                        
                  <div class="buttonSet" style="margin-top:10px;margin-right:10px;">
                    <div class="bWrapperUp">
                      <div>
                        <div>
                          <button type='button' class='hpButton' id="btnRegister" onclick="applyRemoteSupportSettings();">
                            <xsl:value-of select="$stringsDoc//value[@key='register']" />
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <br />                    
                  <span id="requiredField" style="padding-top:5px;font-style:italic;">
                    <xsl:value-of select="$stringsDoc//value[@key='asterisk']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />
                  </span>                        
                </form>

              </xsl:when>
              <xsl:when test="$activated = true() and $fullyActivated != true()">
                
                <table style="vertical-align:top;width:100%;border:0px;padding:0px;border-collapse:collapse;">
                  <tr>
                    <td valign="top">
                      <br />
                      <table cellpadding="0" cellspacing="0" style="width:100%;border:0px;padding:0px;">
                        <tr>
                          <th style="text-align:left;padding:3px;background-color:#716B66;color:#fff;font-weight:bold;">
                            <xsl:value-of select="$stringsDoc//value[@key='step2of2Desc']"/>
                          </th>
                        </tr>
                        <tr>
                          <td valign="top" style="border:1px solid #ccc;padding:10px;">
                            <div id="errorDisplayStep2" class="errorDisplay"></div>
                            
                            <xsl:value-of select="$stringsDoc//value[@key='pleaseGoTo']"/>&#160;<a href="http://www.hp.com/go/InsightOnline" target="_new">www.hp.com/go/insightOnline</a>&#160;<xsl:value-of select="$stringsDoc//value[@key='regDirectCompleteDesc']"/>
                          
                            <br />
                            <br />
                            <input type="checkbox" id="chkConfirm" style="vertical-align:middle;margin-right:5px;margin-bottom:3px;" onclick="if (this.checked == true){{ourButtonManager.enableButtonById('btnConfirm')}}else{{ourButtonManager.disableButtonById('btnConfirm')}}" />
                            <label for="chkConfirm" style="vertical-align:middle;"><xsl:value-of select="$stringsDoc//value[@key='pleaseConfirmRegProcess']"/></label>                           
                            
                            <div align="right">
                              <div class="buttonSet" style="margin:0px;">
                                <div class="bWrapperDisabled" style="margin:0px">
                                  <div>
                                    <div>
                                      <button type='button' class='hpButton' id="btnConfirm" disabled="true" onclick="setOnlineRegistrationComplete();">
                                        <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                                      </button>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </div>
                            <br />
                            <br />
                            <xsl:value-of select="$stringsDoc//value[@key='ersEmailAlertingNote']" />
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>              
                <br />
              </xsl:when>
              <xsl:otherwise>
                <table style="vertical-align:top;width:100%;border:0px;padding:0px;border-collapse:collapse;">
                  <tr>
                    <td valign="top">
                
                      <table cellpadding="0" cellspacing="0" style="width:100%;border:0px;padding:0px;">
                        <tr>
                          <th style="text-align:left;padding:3px;background-color:#716B66;color:#fff;font-weight:bold;">                            
                            <xsl:value-of select="$stringsDoc//value[@key='select1of2WaysToRegister:']"/>
                          </th>
                        </tr>
                        <tr>
                          <td valign="top" style="border:1px solid #ccc;padding:10px;">
                            <table border="0" width="100%">
                              <tr>
                                <td width="10%">                          
                                 <label for="remoteSupportHP">                             
                                   <xsl:element name="div">
                                     <xsl:attribute name="style">box-sizing:border-box;cursor:pointer;width:325px;height:90px;background-image:url('/120814-042457/images/remote-support-direct.gif');background-repeat:no-repeat;filter:progid:DXImageTransform.Microsoft.Shadow(color=white, direction=135 strength=5)progid:DXImageTransform.Microsoft.Shadow(color=white, direction=295 strength=5)</xsl:attribute>
                                     <xsl:attribute name="title"><xsl:value-of select="$stringsDoc//value[@key='remoteSupportDirectTip']" /></xsl:attribute>
                                      <xsl:attribute name="onmouseover">this.style.boxShadow='0px 0px 10px #99CCFF';this.style.filter='progid:DXImageTransform.Microsoft.Glow(color=#99CCFF, strength=5)';</xsl:attribute>                               
                                      <xsl:attribute name="onmouseout">this.style.boxShadow='';this.style.filter='progid:DXImageTransform.Microsoft.Shadow(color=white, direction=135 strength=5)progid:DXImageTransform.Microsoft.Shadow(color=white, direction=295 strength=5)'</xsl:attribute>                           
                                  </xsl:element>
                                </label>
                                </td>
                                <td width="100px">&#160;</td>                            
                                <td width="10%">
                                  <label for="remoteSupportIRS">                             
                                     <xsl:element name="div">
                                       <xsl:attribute name="style">box-sizing:border-box;cursor:pointer;width:325px;height:90px;background-image:url('/120814-042457/images/remote-support-irs.gif');background-repeat:no-repeat;filter:progid:DXImageTransform.Microsoft.Shadow(color=white, direction=135 strength=5)progid:DXImageTransform.Microsoft.Shadow(color=white, direction=295 strength=5)</xsl:attribute>
                                       <xsl:attribute name="title"><xsl:value-of select="$stringsDoc//value[@key='remoteSupportRemoteTip']" /></xsl:attribute>
                                       <xsl:attribute name="onmouseover">this.style.boxShadow='0px 0px 10px #99CCFF';this.style.filter='progid:DXImageTransform.Microsoft.Glow(color=#99CCFF, strength=5)';</xsl:attribute>                               
                                       <xsl:attribute name="onmouseout">this.style.boxShadow='';this.style.filter='progid:DXImageTransform.Microsoft.Shadow(color=white, direction=135 strength=5)progid:DXImageTransform.Microsoft.Shadow(color=white, direction=295 strength=5)'</xsl:attribute>                           
                                    </xsl:element>
                                  </label>
                                </td>   
                                <td width="auto">&#160;</td>
                              </tr>                                                 
                              <tr>
                                <td valign="top">
                                  <table border="0">
                                    <tr>
                                      <td valign="top"><input type="radio" value="ERS_MODE_DIRECT" style="margin:0px;" id="remoteSupportHP" name="remoteSupportType" onclick="toggleElementVisible('frmDirect', true);toggleElementVisible('frmIrs', false);toggleElementVisible('requiredField', true);reconcilePage();"/></td>
                                      <td valign="middle"><label for="remoteSupportHP" style="font-weight:bold;"><xsl:value-of select="$stringsDoc//value[@key='connectDirectlyToRemoteSupport']"/></label></td>
                                    </tr>
                                  </table>                            
                                </td>
                                <td width="100px">&#160;</td>
                                <td valign="top">
                                  <table border="0">
                                    <tr>
                                      <td valign="top"><input type="radio" value="ERS_MODE_IRS" style="margin:0px;" id="remoteSupportIRS" name="remoteSupportType" onclick="toggleElementVisible('frmDirect', false);toggleElementVisible('frmIrs', true);toggleElementVisible('requiredField', true);reconcilePage();"/></td>
                                      <td valign="middle"><label for="remoteSupportIRS" style="font-weight:bold;" ><xsl:value-of select="$stringsDoc//value[@key='connectToRemoteSupportServer']"/></label></td>
                                    </tr>
                                  </table>                           
                                </td>
                                <td width="auto">&#160;</td>
                              </tr>
                            </table>
                      
                            <br />                      
                      
                            <form id="frmDirect" style="display:none;">
                              <table id="tblDirect" border="0" cellspacing="0" style="width:98%;margin-left:5px;border:0px;padding:0px;">
                                <tr>
                                  <th style="text-align:left;padding:3px;background-color:#716B66;color:#fff;font-weight:bold;">                                    
                                    <xsl:value-of select="$stringsDoc//value[@key='step1of2Desc']"/>
                                  </th>
                                </tr>
                                <tr>
                                  <td valign="top" style="border:1px solid #ccc;padding:10px;">
                                    <xsl:call-template name="modeDirect" />
                                  </td>
                                </tr>
                              </table>
                        
                              <div class="buttonSet" style="margin-top:10px;margin-right:20px;">
                                <div class="bWrapperUp">
                                  <div>
                                    <div>
                                      <button type='button' class='hpButton' id="btnRegister" onclick="applyRemoteSupportSettings();">
                                        <xsl:value-of select="$stringsDoc//value[@key='register']" />
                                      </button>
                                    </div>
                                  </div>
                                </div>
                              </div>
                        
                            </form>
                      
                            <form id="frmIrs" style="display:none;">
                              <table id="tblDirect" border="0" cellpadding="0" cellspacing="0" style="width:98%;margin-left:5px;border:0px;padding:0px;">
                                <tr>
                                  <th style="text-align:left;padding:3px;background-color:#716B66;color:#fff;font-weight:bold;">
                                    <xsl:value-of select="$stringsDoc//value[@key='connectToRemoteSupportServer']"/>
                                  </th>
                                </tr>
                                <tr>
                                  <td valign="top" style="border:1px solid #ccc;padding:10px;">
                                    <xsl:call-template name="modeRemote" /> 
                                    <br />
                                  </td>
                                </tr>
                              </table>
                        
                              <div class="buttonSet" style="margin-top:10px;margin-right:20px;">
                                <div class="bWrapperUp">
                                  <div>
                                    <div>
                                      <button type='button' class='hpButton' id="btnRegister" onclick="applyRemoteSupportSettings();">
                                        <xsl:value-of select="$stringsDoc//value[@key='register']" />
                                      </button>
                                    </div>
                                  </div>
                                </div>
                              </div>
                        
                            </form>                     
                      
                          </td>
                        </tr>                 
                      </table>                
                    </td>
                  </tr>
                  <xsl:if test="$fullyActivated != true()">
                    <tr>
                      <td>
                        <div id="requiredField" style="padding-top:5px;font-style:italic;display:none;">
                          <xsl:value-of select="$stringsDoc//value[@key='asterisk']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />
                        </div>      
                      </td>
                    </tr>
                  </xsl:if>           
                </table>                
              </xsl:otherwise>
            </xsl:choose> 
          </xsl:if> 
          
        </div>    
    
        <!-- MAINTENANCE FIELDS -->
   
       <xsl:if test="$activated = true()">
         
        <xsl:call-template name="ersDiagnosticTable" />
        <br />
        <br />        
         
         <!-- proxy form if Direct mode -->
         <xsl:if test="$mode = 'ERS_MODE_DIRECT'">
           <table id="tblDirect" border="0" cellspacing="0" style="width:100%;margin:0px;border:0px;padding:0px;">
            <tr>
              <th style="text-align:left;padding:3px;background-color:#716B66;color:#fff;font-weight:bold;">                
                <xsl:value-of select="$stringsDoc//value[@key='needToChangeProxySettings']"/>
              </th>
            </tr>
            <tr>
              <td valign="top" style="border:1px solid #ccc;padding:10px;">
                <xsl:call-template name="proxySettingsForm" />
              </td>
            </tr>
           </table>
         </xsl:if>         
         
         <!-- un-registration for both modes -->
         <br />
         <xsl:call-template name="unregisterForm" />
       </xsl:if>
        
      </xsl:otherwise>    
    </xsl:choose>   
  </xsl:template>
 
  
  <!-- 
  ==========================================================================================
    @Purpose: maintenance section: un-registration
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template name="unregisterForm">
    <div id="errorDisplayUnregister" class="errorDisplay"></div>
    <table id="tblUnregister" border="0" cellspacing="0" style="width:100%;margin-left:0px;border:1px solid #ccc;padding:0px;">
      <tr>
        <th colspan="2" style="text-align:left;padding:3px;background-color:#716B66;color:#fff;font-weight:bold;">          
          <xsl:value-of select="$stringsDoc//value[@key='needToUnregister']"/>
        </th>
      </tr>
      <tr>
        <td style="padding:20px;vertical-align:middle;">          
          <xsl:value-of select="$stringsDoc//value[@key='unregisterDesc']"/>
        </td>
        <td style="padding:20px 10px 0px 0px;vertical-align:middle;">      
          <div class="buttonSet" style="margin-bottom:0px;">
            <div class='bWrapperUp'>
              <div>
                <div>
                  <button type='button' class='hpButton' id="btnDeactivate" onclick="deactivateRemoteSupport();">
                    <xsl:value-of select="$stringsDoc//value[@key='unregister']" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </td>
      </tr>
    </table>
  
  </xsl:template>  
  
  
  <!-- 
  ==========================================================================================
    @Purpose: Header denoting current activation status
    @notes  : Status icons used to conform with iLO implementation.
  ==========================================================================================
  -->
  <xsl:template name="ersHeader">
    <xsl:variable name="errorsExist">
    <xsl:choose>
      <xsl:when test="string-length($ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr) &gt; 0 or string-length($ersConfigInfoDoc//hpoa:ersLastTestAlertErrorStr) &gt; 0">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>     
    </xsl:variable>
    <xsl:variable name="statusColor">
      <xsl:choose>
        <xsl:when test="$overridden = true()">#ccc</xsl:when>
        <xsl:when test="$fullyActivated = true() and $errorsExist = 'false'">#00C000</xsl:when>
        <xsl:otherwise>#E0C135</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="rsTooltip">
      <xsl:value-of select="concat($stringsDoc//value[@key='remoteSupportDesc'], '&#10;', $stringsDoc//value[@key='readMore:'], ' www.hp.com/go/insightremotesupport')" />
    </xsl:variable>
    
    <xsl:if test="$overridden != true()">
      <h4 title="{$rsTooltip}" style="font-size:110%;"><a target="_new" href="http://www.hp.com/go/insightremotesupport" style="color:black"><xsl:value-of select="$stringsDoc//value[@key='quickSetupRemoteSupport']" /></a></h4>
    </xsl:if>
    
    <div style="{concat('min-width:250px;vertical-align:middle;margin:10px 0px 10px 1px;padding:15px 10px 5px 10px;border:2px solid ', $statusColor)}">
      <xsl:choose>
        <xsl:when test="$overridden = true()">
          <table cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td style="vertical-align:top;">
                <img src="/120814-042457/images/status_informational_32.gif" style="vertical-align:middle;margin-right:10px;" />
              </td>
              <td style="font-weight:bold;">
                <xsl:value-of select="concat($stringsDoc//value[@key='remoteSupportProvidedBy'], $ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersSolutionOverrideProviderStr'])" />               
              </td>
            </tr>
          </table>
          <br />
        </xsl:when>
        <xsl:when test="$fullyActivated != true()">          
          <table cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td style="vertical-align:top;">
                <img src="/120814-042457/images/status_minor_32.gif" style="vertical-align:middle;margin-right:10px;" />
              </td>
              <td style="font-weight:bold;">
                <xsl:choose>
                  <xsl:when test="$activated = true() and $fullyActivated != true()">
                    <xsl:value-of select="$stringsDoc//value[@key='stepOneCompletedDesc']" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$stringsDoc//value[@key='notRegisteredWithRemoteSupport']" />
                  </xsl:otherwise>                  
                </xsl:choose>                               
              </td>
            </tr>
          </table>
          <br />
        </xsl:when>
        <xsl:otherwise>        
          <xsl:variable name="iconSrc">
            <xsl:choose>
              <xsl:when test="$errorsExist = 'true'">/120814-042457/images/status_minor_32.gif</xsl:when>
              <xsl:otherwise>/120814-042457/images/status_normal_32.gif</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <table cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td>
                <img src="{$iconSrc}" style="vertical-align:middle;margin-right:10px;" />
              </td>
              <td style="font-weight:bold;">
                <xsl:choose>
                  <xsl:when test="$mode = $ERS_MODE_DIRECT">
                    <xsl:choose>
                      <xsl:when test="$errorsExist = 'true'"><xsl:value-of select="$stringsDoc//value[@key='errorsReportedSeeDiagnosticTable']" />&#160;&#160;</xsl:when>
                      <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='registeredWithRemoteSupport']" />&#160;&#160;</xsl:otherwise>
                    </xsl:choose>                    
                    <xsl:value-of select="concat($stringsDoc//value[@key='hpPassportAccountUsed'], '&#160;&#160;', $ersConfigInfoDoc//hpoa:extraData[@hpoa:name='ersOnlinePassportName'])" />
                  </xsl:when>
                  <xsl:when test="$mode = $ERS_MODE_IRS">
                    <xsl:choose>
                      <xsl:when test="$errorsExist = 'true'"><xsl:value-of select="$stringsDoc//value[@key='errorsReportedSeeDiagnosticTable']" />&#160;&#160;</xsl:when>
                      <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='registeredWithRemoteSupport']" />&#160;&#160;</xsl:otherwise>
                    </xsl:choose>                    
                    <xsl:value-of select="concat($stringsDoc//value[@key='irsHostingDeviceUsed'], '&#160;&#160;', $ersConfigInfoDoc//hpoa:irsHostname, ':', $ersConfigInfoDoc//hpoa:irsPort)" />
                  </xsl:when>
                </xsl:choose>
              </td>
            </tr>
          </table>
          <span class="whiteSpacer">&#160;</span>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
  
    <!-- 
  ==========================================================================================
    @Purpose: Adds small table with last event|data collection status
    @notes  : only shown when fully activated
  ==========================================================================================
  -->
  <xsl:template name="ersDiagnosticTable">

    <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" style="margin-top:20px;">
      <caption><xsl:value-of select="$stringsDoc//value[@key='diagnosticInformation']" /></caption>
      <tbody>
        <tr class="altRowColor">
          <th class="propertyName" style="width:200px;">
            <xsl:value-of select="$stringsDoc//value[@key='lastInventoryError']"/>
          </th>
          <td class="propertyValue">
            <xsl:choose>
              <xsl:when test="$ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr != ''">
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                  <xsl:with-param name="optStyle" select="'margin-bottom:-2px;'" />
                </xsl:call-template>&#160;
                <xsl:call-template name="assertLocalizedString">
                  <xsl:with-param name="localizedStringsDoc" select="$stringsDoc" />
                  <xsl:with-param name="originalString" select="$ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr" />
                  <xsl:with-param name="key" select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name='ersLastInventoryErrorCode']" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="getStatusLabel">
                  <xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
                  <xsl:with-param name="optStyle" select="'margin-bottom:-2px;'" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>            
          </td>
        </tr>        
        <tr class="">
          <th class="propertyName" style="width:200px;">
            <xsl:value-of select="$stringsDoc//value[@key='lastTestAlertError']"/>
          </th>
          <td class="propertyValue">
            <xsl:choose>
              <xsl:when test="$ersConfigInfoDoc//hpoa:ersLastTestAlertErrorStr != ''">
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                  <xsl:with-param name="optStyle" select="'margin-bottom:-2px;'" />
                </xsl:call-template>&#160;
                <xsl:call-template name="assertLocalizedString">
                  <xsl:with-param name="localizedStringsDoc" select="$stringsDoc" />
                  <xsl:with-param name="originalString" select="$ersConfigInfoDoc//hpoa:ersLastTestAlertErrorStr" />
                  <xsl:with-param name="key" select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name='ersLastTestAlertErrorCode']" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="getStatusLabel">
                  <xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
                  <xsl:with-param name="optStyle" select="'margin-bottom:-2px;'" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>            
          </td>
        </tr>
        <xsl:if test="$ersConfigInfoDoc//hpoa:ersNumFailedAttemptsInventory &gt; 0">
          <tr class="altRowColor">
            <th class="propertyName" style="width:200px;">
              <xsl:value-of select="$stringsDoc//value[@key='failedInventoryAttempts']"/>
            </th>
            <td class="propertyValue">
              <xsl:value-of select="$ersConfigInfoDoc//hpoa:ersNumFailedAttemptsInventory"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="$ersConfigInfoDoc//hpoa:ersNumFailedAttemptsServiceAlerts &gt; 0">
          <xsl:variable name="rowColor">
            <xsl:choose>
              <xsl:when test="$ersConfigInfoDoc//hpoa:ersNumFailedAttemptsInventory &gt; 0"></xsl:when>
              <xsl:otherwise>altRowColor</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <tr class="{$rowColor}">
            <th class="propertyName" style="width:200px;">
              <xsl:value-of select="$stringsDoc//value[@key='failedTestAlertAttempts']"/>
            </th>
            <td class="propertyValue">
              <xsl:value-of select="$ersConfigInfoDoc//hpoa:ersNumFailedAttemptsServiceAlerts"/>
            </td>
          </tr>
        </xsl:if>
      </tbody>
    </table>
  </xsl:template>
  
  <!-- 
  ==========================================================================================
    @Purpose: Adds section for connecting directly to HP
    @notes  : Not shown when remote mode is activated.
  ==========================================================================================
  -->
  <xsl:template name="modeDirect">
    
    <h4 style="font-size:110%;margin:20px 10px 20px 10px;cursor:pointer;display:inline;" title="{$stringsDoc//value[@key='passportAccountDesc']}"><xsl:value-of select="$stringsDoc//value[@key='enterHpCredentials']"/></h4>
    <a style="margin-left:20px;font-style:italic;" target="_new" href="http://www.hp.com/go/insightonline"><xsl:value-of select="$stringsDoc//value[@key='dontHaveAnAccount']"/></a>
    
    <br />
    
    <!-- DIRECT CONNECT FORM --> 
    <div id="remoteSupportFormHP" style="margin:15px 0px 5px 0px;padding-left:20px;width:100%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;margin-left:10px;">
      <div id="errorDisplayHP" class="errorDisplay" style="margin-left:0px;margin-top:0px;"></div>
      <xsl:if test="$fullyActivated != true()">
        <table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top:3px;">
          <tr>
            <td id="lblUserId" style="white-space:nowrap;">
                <xsl:value-of select="$stringsDoc//value[@key='passportUsername:']" /><xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
            </td>
            <td width="10"><div style="width:30px;"></div></td>
            <td style="width:90%;">
              <!-- INPUT: USER ID -->
              <xsl:element name="input">                          
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="style">width:300px;</xsl:attribute>
                <xsl:attribute name="class">stdInput</xsl:attribute>
                <xsl:attribute name="id">userId</xsl:attribute>
                <xsl:if test="$serviceUserAcl != $ADMINISTRATOR">
                  <xsl:attribute name="readonly">true</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="value"></xsl:attribute>
                <!-- validation rules: string up to 128 chars -->
                <xsl:attribute name="validate-me">true</xsl:attribute>
                <xsl:attribute name="rule-list">6</xsl:attribute>
                <xsl:attribute name="caption-label">lblUserId</xsl:attribute>
                <xsl:attribute name="range">1;128</xsl:attribute>
                <xsl:attribute name="maxlength">128</xsl:attribute>
                <xsl:attribute name="option-id">remoteSupportHP</xsl:attribute>
                <!-- end validation rules-->            
              </xsl:element>
            </td>
          </tr>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <tr>
            <td id="lblUserPassword" style="white-space:nowrap;">
              <xsl:value-of select="$stringsDoc//value[@key='passportPassword:']" /><xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
            </td>
            <td width="10">&#160;</td>
            <td style="width:99%;">
              <!-- INPUT: USER PASSWORD -->
              <xsl:element name="input">
                <xsl:attribute name="class">stdInput</xsl:attribute>           
                <xsl:attribute name="autocomplete">off</xsl:attribute>
                <xsl:attribute name="type">password</xsl:attribute>
                <xsl:attribute name="style">width:300px;</xsl:attribute>
                <xsl:attribute name="class">stdInput</xsl:attribute>
                <xsl:attribute name="id">userPassword</xsl:attribute>
                <xsl:attribute name="autocomplete">off</xsl:attribute>
                <xsl:if test="$serviceUserAcl != $ADMINISTRATOR">
                  <xsl:attribute name="readonly">true</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="value"></xsl:attribute>
                <!-- validation rules: string up to 128 chars -->
                <xsl:attribute name="validate-me">true</xsl:attribute>
                <xsl:attribute name="rule-list">6</xsl:attribute>
                <xsl:attribute name="caption-label">lblUserPassword</xsl:attribute>
                <xsl:attribute name="range">1;128</xsl:attribute>
                <xsl:attribute name="maxlength">128</xsl:attribute>
                <xsl:attribute name="option-id">remoteSupportHP</xsl:attribute>
                <!-- end validation rules-->            
              </xsl:element>
            </td>
          </tr>
          <tr>
            <td colspan="3" class="formSpacer">&#160;<br /></td>
          </tr> 
        </table>        
      </xsl:if>
      
      <br />
      <xsl:call-template name="proxySettingsForm" />
      
      <table valign="top" border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr>
          <td valign="top" width="1%">
            <xsl:element name="input">
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="id">chkEULA</xsl:attribute>
              <xsl:attribute name="style">margin-left:0px;vertical-align:middle;</xsl:attribute>            
            </xsl:element>
          </td>
          <td style="width:90%;padding-left:5px;padding-top:3px;padding-bottom:4px;">
            <label for="chkEULA">
              &#160;<xsl:value-of select="$stringsDoc//value[@key='iAcceptTheTermsAndConditions']"/> 
            </label>
            &#160;<a href="http://www.hp.com/go/SWLicensing" target="_new"><xsl:value-of select="concat($stringsDoc//value[@key='hpSoftwareLicenseAgreement'], '&#160;', $stringsDoc//value[@key='andThe'], '&#160;', $stringsDoc//value[@key='hpInsightMgmtAdditionalLicenseAuth'])"/></a>
          </td>
          <br />
        </tr>
      </table>  
      
      <br />      
      <xsl:call-template name="registerAgreement" />
      
    </div>
 </xsl:template>
  
  
  <!-- 
  ==========================================================================================
    @Purpose: Adds proxy form
    @notes  : only used for direct connect
  ==========================================================================================
  -->
<xsl:template name="proxySettingsForm">
  <xsl:variable name="proxyDescKey">
    <xsl:choose>
      <xsl:when test="$activated = true()">proxySettingsMaintainDesc</xsl:when>
      <xsl:otherwise>proxySettingsDesc</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <div class="errorDisplay" id="errorDisplayProxy"></div>
  <p style="margin: 5px 0px 15px 0px;"><i><xsl:value-of select="$stringsDoc//value[@key=$proxyDescKey]"/></i></p>  
      
  <!--  PROXY SETTINGS -->
  <div id="advSettings" style="display:block;" width="100%">
    <table border="0" cellspacing="0" cellpadding="0">        
      <!-- always editable -->                
      <tr>
        <td id="lblProxyUrl" style="white-space:nowrap;">
          <xsl:value-of select="$stringsDoc//value[@key='webProxyUrl:']" />
        </td>
        <td width="10"><div style="width:39px;"></div></td>
        <td style="width:90%;">
          <!-- INPUT: PROXY URL -->
          <xsl:element name="input">
            <xsl:attribute name="class">stdInput</xsl:attribute>           
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="style">width:300px;</xsl:attribute>
            <xsl:attribute name="id">proxyUrl</xsl:attribute>
            <xsl:attribute name="value">                  
              <xsl:value-of select="$ersConfigInfoDoc//hpoa:ersConfigInfo/hpoa:ersProxyUrl" />                  
            </xsl:attribute>
            <!-- validation rules: optional, limit to 255 chars, no spaces -->
            <xsl:attribute name="validate-me">true</xsl:attribute>
            <xsl:attribute name="validate-proxy">true</xsl:attribute>
            <xsl:attribute name="rule-list">0;8</xsl:attribute>
            <xsl:attribute name="caption-label">lblProxyUrl</xsl:attribute>
            <xsl:attribute name="maxlength">255</xsl:attribute>
            <!-- end validation rules-->             
          </xsl:element>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
          
        <!-- PROXY AUTHENTICATION -->
      <tr>
        <td id="lblProxyUsername" style="white-space:nowrap;">
          <xsl:value-of select="$stringsDoc//value[@key='webProxyUsername:']" /> 
        </td>
        <td width="10">&#160;</td>
        <td>
          <!-- INPUT: USERNAME -->
          <xsl:element name="input">
            <xsl:attribute name="class">stdInput</xsl:attribute>            
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="style">width:300px;</xsl:attribute>
            <xsl:attribute name="id">proxyUsername</xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="$ersConfigInfoDoc//hpoa:ersProxyUsername"/></xsl:attribute>
            <!-- validation rules: optional, limit to 128 chars -->
            <xsl:attribute name="validate-me">true</xsl:attribute>
            <xsl:attribute name="validate-proxy">true</xsl:attribute>
            <xsl:attribute name="rule-list">0</xsl:attribute>
            <xsl:attribute name="maxlength">128</xsl:attribute>
            <!-- end validation rules-->            
          </xsl:element>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td id="lblProxyPassword" style="white-space:nowrap;">
          <xsl:value-of select="$stringsDoc//value[@key='webProxyPassword:']" /> 
        </td>
        <td width="10">&#160;</td>
        <td>
          <!-- INPUT: PROXY PASSWORD -->
          <xsl:element name="input">
            <xsl:attribute name="class">stdInput</xsl:attribute>          
            <xsl:attribute name="type">password</xsl:attribute>
            <xsl:attribute name="style">width:300px;</xsl:attribute>
            <xsl:attribute name="id">proxyPassword</xsl:attribute>
            <xsl:attribute name="autocomplete">off</xsl:attribute>
            <xsl:if test="$serviceUserAcl != $ADMINISTRATOR">
              <xsl:attribute name="readonly">true</xsl:attribute>
            </xsl:if>            
            <!-- validation rules: optional, limit to 128 chars -->
            <xsl:attribute name="validate-me">true</xsl:attribute>
            <xsl:attribute name="validate-proxy">true</xsl:attribute>
            <xsl:attribute name="rule-list">0</xsl:attribute>
            <xsl:attribute name="maxlength">128</xsl:attribute>
            <!-- end validation rules-->            
          </xsl:element>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>              
      <tr>
        <td id="lblProxyPort" style="white-space:nowrap;">
            <xsl:value-of select="$stringsDoc//value[@key='webProxyPort:']" />
        </td>
        <td width="10">&#160;</td>
        <td>
          <!-- INPUT: PROXY PORT -->
          <xsl:element name="input">
            <xsl:attribute name="class">stdInput</xsl:attribute>            
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="style">width:85px;</xsl:attribute>
            <xsl:attribute name="id">ersProxyPort</xsl:attribute>
            <xsl:if test="$serviceUserAcl != $ADMINISTRATOR">
              <xsl:attribute name="readonly">true</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="value">
              <xsl:value-of select="$ersConfigInfoDoc//hpoa:ersProxyPort" />                     
            </xsl:attribute>
            <!-- validation rules: optional, integer (1 - 65535) -->
            <xsl:attribute name="validate-me">true</xsl:attribute>
            <xsl:attribute name="validate-proxy">true</xsl:attribute>
            <xsl:attribute name="rule-list">0;9</xsl:attribute>
            <xsl:attribute name="caption-label">lblProxyPort</xsl:attribute>
            <xsl:attribute name="range">1;65535</xsl:attribute>
            <xsl:attribute name="maxlength">5</xsl:attribute>
            <!-- end validation rules-->             
          </xsl:element>
        </td>
      </tr>
    </table>
    <span class="whiteSpacer">&#160;</span>  
        
    <xsl:if test="$activated = true()">
      <div class="buttonSet" style="margin-bottom:0px;">
        <div class='bWrapperUp'>
          <div>
            <div>
              <button type='button' class='hpButton' id="btnUpdateProxy" onclick="updateProxySettings();">
                <xsl:value-of select="$stringsDoc//value[@key='apply']" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>      
        
  </div>
  </xsl:template>
  
  
  <!-- 
  ==========================================================================================
    @Purpose: Adds section for connecting to Insight Remote Support
    @notes  : Not shown when direct mode is activated.
  ==========================================================================================
  -->
  <xsl:template name="modeRemote">
    
    <h4 style="font-size:110%;margin:10px 10px 20px 10px;"><xsl:value-of select="$stringsDoc//value[@key='enterInsightRemoteSupportInfo']"/></h4>
    
    <!-- REMOTE SERVICES FORM --> 
    <div id="remoteSupportFormIRS" style="margin:0px 0px 5px 0px;padding-left:20px;width:96%;padding-right:0px;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;">
      <div id="errorDisplayIRS" class="errorDisplay" style="margin-left:0px;"></div>
      <table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-bottom:10px;margin-left:10px;">
        <tr>
          <td colspan="3" class="formSpacer">
            &#160;
          </td>
        </tr>
        <tr>
          <td id="lblIrsHost" style="white-space:nowrap;">
            <xsl:value-of select="$stringsDoc//value[@key='servernameOrIp:']" />
            <xsl:if test="$fullyActivated != true()">
              <xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
            </xsl:if>
          </td>
          <td>
            <div style="width:24px;">&#160;</div>
          </td>
          <td style="width:90%;">
            <!-- INPUT: IRS Hostname -->
            <xsl:choose>
              <xsl:when test="$fullyActivated != true()">
                <xsl:element name="input">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="style">width:300px;</xsl:attribute>
                  <xsl:attribute name="id">irsHost</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:if test="$fullyActivated = true()">
                      <xsl:value-of select="$ersConfigInfoDoc//hpoa:irsHostname" />
                    </xsl:if>
                  </xsl:attribute>
                  <!-- validation rules: string, 1 to 50 chars -->
                  <xsl:attribute name="validate-me">true</xsl:attribute>
                  <xsl:attribute name="rule-list">6;13</xsl:attribute>
                  <xsl:attribute name="caption-label">lblIrsHost</xsl:attribute>
                  <xsl:attribute name="range">4;255</xsl:attribute>
                  <xsl:attribute name="related-inputs">irsHost</xsl:attribute>
                  <xsl:attribute name="maxlength">255</xsl:attribute>
                  <xsl:attribute name="option-id">remoteSupportIRS</xsl:attribute>
                  <!-- end validation rules-->
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$ersConfigInfoDoc//hpoa:irsHostname" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <td id="lblIrsPort" style="white-space:nowrap;">
            <xsl:value-of select="$stringsDoc//value[@key='serverPort:']" />
            <xsl:if test="$fullyActivated != true()">
              <xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
            </xsl:if>
          </td>
          <td>
            <div style="width:24px;">&#160;</div>
          </td>
          <td style="width:100%;">
            <!-- INPUT: IRS Hostname Port -->
            <xsl:choose>
              <xsl:when test="$fullyActivated != true()">
                <xsl:element name="input">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="style">width:85px;</xsl:attribute>
                  <xsl:attribute name="id">irsPort</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:choose>
                      <xsl:when test="$ersConfigInfoDoc//hpoa:irsPort = '0' or $ersConfigInfoDoc//hpoa:irsPort = ''">
                        <xsl:text>7906</xsl:text><!-- default value -->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$ersConfigInfoDoc//hpoa:irsPort" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>  
                  <!-- validation rules: integer, 1 - 65535 -->
                  <xsl:attribute name="validate-me">true</xsl:attribute>
                  <xsl:attribute name="rule-list">9</xsl:attribute>
                  <xsl:attribute name="caption-label">lblIrsPort</xsl:attribute>
                  <xsl:attribute name="related-inputs">irsHost</xsl:attribute>
                  <xsl:attribute name="related-labels">lblIrsHost</xsl:attribute>
                  <xsl:attribute name="range">1;65535</xsl:attribute>
                  <xsl:attribute name="maxlength">5</xsl:attribute>
                  <xsl:attribute name="option-id">remoteSupportIRS</xsl:attribute>
                  <!-- end validation rules-->
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$ersConfigInfoDoc//hpoa:irsPort" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">
            &#160;<br /><br />
          </td>
        </tr>
        <tr>
          <td colspan="3">
            <br />
            <b>
              <xsl:value-of select="$stringsDoc//value[@key='note:']"/>
            </b>&#160;
            <xsl:value-of select="$stringsDoc//value[@key='remoteSupportServerMinimumVersion']"/>            
          </td>
        </tr>
      </table>
    </div> 

  </xsl:template>

    <!-- 
  ==========================================================================================
    @Purpose: displays a passive agreement statement (requires no explicit action)
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template name="registerAgreement">
    <xsl:if test="$fullyActivated != 'true'">
      <br />
      <table style="border:0px;">
        <tr>
          <td>
            <label for="" style="line-height:160%;padding-right:0px;border:0px;">
              <i>
                <xsl:value-of select="$stringsDoc//value[@key='ersAgreement']"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='ersPrivacyStatement']"  />
                <a href="http://www.hp.com/go/privacy" target="_new">
                  <xsl:value-of select="$stringsDoc//value[@key='hpDataPrivacyPolicy']"/>
                </a>.
              </i>
            </label>
          </td>
        </tr>
      </table>
      <br />
    </xsl:if>    
  </xsl:template>
</xsl:stylesheet>

