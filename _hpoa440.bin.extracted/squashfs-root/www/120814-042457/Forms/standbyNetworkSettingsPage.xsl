<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
  xmlns:t="urn:templates"
  xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2014 Hewlett-Packard Development Company, L.P.
  -->

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  
  <xsl:param name="stringsDoc" />
  <xsl:param name="oaNetworkInfoDoc" />
  <xsl:param name="oaStatusDoc" />
  <xsl:param name="readOnly" select="'false'" />
  <xsl:param name="templateName" select="'ipv4SettingsPage'" />
  
  <!-- callable templates -->
  <t:templates>
    <t:ipv4SettingsTab/>
    <t:ipv6SettingsTab/>
    <t:nicSettingsTab/>
    <t:advSettingsTab/>
  </t:templates>

  <xsl:variable name="templates" select="document('')//t:templates" />
  
  <!-- 
  ==========================================================================================
    @Purpose: calls named template specified by $templateName, and footer/button templates.
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template match="*">   
    <!-- page contents -->
    <span id="pageContents">         
      <xsl:apply-templates select="$templates/t:*[local-name() = $templateName]" />    
    </span>
    
    <!-- page footer -->
    <hr style="margin:15px 0px 10px 0px;" />
    <xsl:call-template name="reloadTabPageNotice" />
    
    <!-- page buttons -->
    <xsl:call-template name="applyButtonTemplate" />    
  </xsl:template>
  
  <!-- 
  ==========================================================================================
    @Purpose: render IPV4 page content
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template name="ipv4SettingsTab" match="t:ipv4SettingsTab">
    <xsl:call-template name="standbyNetworkIPv4Settings" />
  </xsl:template>
  
  <!-- 
  ==========================================================================================
    @Purpose: render IPV6 page content
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template name="ipv6SettingsTab" match="t:ipv6SettingsTab">
    <xsl:call-template name="standbyNetworkIPv6Settings" />
  </xsl:template>
  
  <!-- 
  ==========================================================================================
    @Purpose: render NIC options page content
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template name="nicSettingsTab" match="t:nicSettingsTab">
    <xsl:call-template name="nicSettings" />
  </xsl:template>
  
  <!-- 
  ==========================================================================================
    @Purpose: render DHCP domain name override page content
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template name="advSettingsTab" match="t:advSettingsTab">
    <xsl:call-template name="advancedNicSettings" />  
  </xsl:template>
  
  <!-- 
  ==========================================================================================
    @Purpose: render Apply button w/click handler.
    @notes  : 
  ==========================================================================================
  -->
  <xsl:template name="applyButtonTemplate">
    <xsl:if test="$readOnly != 'true'">
      <div align="right">
        <div class='buttonSet' style="margin-bottom:0px;">
          <div class='bWrapperUp'>
            <div>
              <div>
                <xsl:element name="button">
                  <xsl:attribute name="class">hpButton</xsl:attribute>
                  <xsl:attribute name="id"><xsl:value-of select="concat($templateName, 'Button')" /></xsl:attribute>
                  <xsl:attribute name="onclick">
                    <xsl:choose>
                      <xsl:when test="$templateName = 'ipv4SettingsTab'">setupStandbyIpv4Settings();</xsl:when>
                      <xsl:when test="$templateName = 'ipv6SettingsTab'">setupStandbyIpv6Settings();</xsl:when>
                      <xsl:when test="$templateName = 'nicSettingsTab'">setupStandbyNicSettings();</xsl:when>
                      <xsl:when test="$templateName = 'advSettingsTab'">setupStandbyAdvancedSettings();</xsl:when>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                </xsl:element>
              </div>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>
  </xsl:template>
  
  <!--
    ==========================================================================================
      @Purpose: renders IPv4 global info, and a form for setting IPv4 fields for the standby OA.    
      @notes  : 
    ==========================================================================================
  -->	
  <xsl:template name="standbyNetworkIPv4Settings">		
    <xsl:variable name="dhcpEnabled" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dhcpEnabled='true'" />
    
    <!-- IPV4 INFO-->
    <xsl:call-template name="ivp4Information" />
    
    <!-- IPV4 SETTINGS -->
    <h5 style="margin-bottom:15px;"><xsl:value-of select="$stringsDoc//value[@key='standbyOANetworkSetting']" /></h5>
    <div id="errorContainer" class="errorDisplay"></div>
    
    <!-- DHCP-->
    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="name">IPSetting</xsl:attribute>
            <xsl:attribute name="value">DHCP</xsl:attribute>
            <xsl:attribute name="id">DHCP</xsl:attribute>
            <xsl:attribute name="class">stdRadioButton</xsl:attribute>
            <xsl:if test="$dhcpEnabled">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="onclick">toggleFormEnabled('dhcpContainer', this.checked);toggleFormEnabled('staticContainer', !this.checked);</xsl:attribute>
          </xsl:element>
          <label for="DHCP">
            <xsl:value-of select="$stringsDoc//value[@key='dhcp']" />
          </label>
          <br />
          <div id="dhcpContainer">
            <blockquote style="margin-top:5px;margin-bottom:5px;">
              <xsl:element name="input">
                <xsl:attribute name="type">checkbox</xsl:attribute>
                <xsl:attribute name="class">stdCheckBox</xsl:attribute>					    
                <xsl:attribute name="id">DynDNS</xsl:attribute>
                <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dynDnsEnabled='true'">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="not($dhcpEnabled)">
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:if>
              </xsl:element>
              <label for="DynDNS">
                <xsl:value-of select="$stringsDoc//value[@key='dynDNS']" />
              </label>
            </blockquote>
          </div>          
        </td>
       </tr>
    </table>
    <div class="formSpacer">&#160;</div>  
    <hr />
    <div class="formSpacer">&#160;</div>  
    <!-- STATIC -->
    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td>          
          <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="name">IPSetting</xsl:attribute>
            <xsl:attribute name="value">Static</xsl:attribute>
            <xsl:attribute name="id">Static</xsl:attribute>
            <xsl:attribute name="class">stdRadioButton</xsl:attribute>
            <xsl:if test="not($dhcpEnabled)">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="onclick">toggleFormEnabled('dhcpContainer', !this.checked);toggleFormEnabled('staticContainer', this.checked);</xsl:attribute>
          </xsl:element>
          <label for="Static">
            <xsl:value-of select="$stringsDoc//value[@key='staticIPSettings']" />
          </label>
          <div id="staticContainer">
            <blockquote>
            <em><xsl:value-of select="$stringsDoc//value[@key='requiredField']" /> *</em> 
            <br />
            <br />              
            <table border="0" cellspacing="0" cellpadding="0">
              <!-- DNS Hostname -->
              <tr>
                <td style="white-space:nowrap;" id="lblDnsName">                  
                  <xsl:value-of select="$stringsDoc//value[@key='dnsHostName*:']" />
                </td>
                <td width="10">&#160;</td>
                <td>
                  <xsl:element name="input">
                    <!-- This field should never be disabled. -->
                    <xsl:attribute name="class">stdInput</xsl:attribute>
                    <xsl:attribute name="type">text</xsl:attribute>
                    <xsl:attribute name="perm-enable">true</xsl:attribute>
                    <xsl:attribute name="caption-label">lblDnsName</xsl:attribute>
                    <xsl:attribute name="id">DnsName</xsl:attribute>
                    <xsl:attribute name="maxlength">32</xsl:attribute>                    
                    <!-- validation: required, string, no spaces, 1 to 32 characters -->
                    <xsl:attribute name="validate-netsettings">true</xsl:attribute>
                    <xsl:attribute name="rule-list">6;8</xsl:attribute>
                    <xsl:attribute name="range">1;32</xsl:attribute>  
                    <xsl:attribute name="value">
                      <xsl:value-of select="$oaStatusDoc//hpoa:oaStatus/hpoa:oaName"/>
                    </xsl:attribute>
                  </xsl:element>					
                </td>
              </tr>
              <tr>
                <td colspan="3" class="formSpacer">&#160;</td>
              </tr>                
                <tr>
                  <td>
                    <span id="ipAddressLabel">
                      <xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" />*
                    </span>
                  </td>
                  <td width="10">&#160;</td>
                  <td>
                    <xsl:element name="input">
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="id">ipAddress</xsl:attribute>                      
                      <xsl:attribute name="maxlength">15</xsl:attribute>
                      <!-- validation: required, IP Address -->
                      <xsl:attribute name="validate-netSettings">true</xsl:attribute>
                      <xsl:attribute name="rule-list">2</xsl:attribute>
                      <xsl:attribute name="caption-label">ipAddressLabel</xsl:attribute>                      
                      <xsl:choose>
                        <xsl:when test="$dhcpEnabled">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                          <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">stdInput</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:attribute name="value">
                        <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:ipAddress" />
                      </xsl:attribute>
                    </xsl:element>
                  </td>
                </tr>
                <tr>
                  <td colspan="3" class="formSpacer">&#160;</td>
                </tr>
                <tr>
                  <td>
                    <span id="subnetMaskLabel">
                      <xsl:value-of select="$stringsDoc//value[@key='subnetMask:']" />*
                    </span>
                  </td>
                  <td width="10">&#160;</td>
                  <td>
                    <xsl:element name="input">
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="id">subnetMask</xsl:attribute>
                      <!-- validation: required, IP Address -->
                      <xsl:attribute name="validate-netSettings">true</xsl:attribute>
                      <xsl:attribute name="rule-list">2</xsl:attribute>
                      <xsl:attribute name="caption-label">subnetMaskLabel</xsl:attribute>
                      <xsl:attribute name="maxlength">15</xsl:attribute>                      
                      <xsl:choose>
                        <xsl:when test="$dhcpEnabled">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                          <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">stdInput</xsl:attribute>                          
                        </xsl:otherwise>
                      </xsl:choose>			
                      <xsl:attribute name="value">
                        <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:netmask" />
                      </xsl:attribute>
                    </xsl:element>
                  </td>
                </tr>
                <tr>
                  <td colspan="3" class="formSpacer">&#160;</td>
                </tr>
                <tr>
                  <td>
                    <span id="gatewayLabel">
                      <xsl:value-of select="$stringsDoc//value[@key='gateway:']" />
                    </span>
                  </td>
                  <td width="10">&#160;</td>
                  <td>
                    <xsl:element name="input">
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="id">gateway</xsl:attribute>
                      <!-- validation: optional IP address -->
                      <xsl:attribute name="validate-netSettings">true</xsl:attribute>
                      <xsl:attribute name="rule-list">0;2</xsl:attribute>
                      <xsl:attribute name="caption-label">gatewayLabel</xsl:attribute>
                      <xsl:attribute name="maxlength">15</xsl:attribute>                      
                      <xsl:choose>
                        <xsl:when test="$dhcpEnabled">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                          <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">stdInput</xsl:attribute>                          
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:gateway!=$EMPTY_IP_TEST">
                        <xsl:attribute name="value">
                          <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:gateway" />
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:element>
                  </td>
                </tr>
                <tr>
                  <td colspan="3" class="formSpacer">&#160;</td>
                </tr>
                <tr>
                  <td>
                    <span id="dnsAddress1Label">
                      <xsl:value-of select="$stringsDoc//value[@key='dnsServer']" /> 1:
                    </span>
                  </td>
                  <td width="10">&#160;</td>
                  <td>
                    <xsl:element name="input">
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="id">dnsAddress1</xsl:attribute>
                      <!-- validation: optional IP address -->
                      <xsl:attribute name="validate-netSettings">true</xsl:attribute>
                      <xsl:attribute name="rule-list">0;2</xsl:attribute>
                      <xsl:attribute name="caption-label">dnsAddress1Label</xsl:attribute>  
                      <xsl:attribute name="maxlength">15</xsl:attribute>                      
                      <xsl:choose>
                        <xsl:when test="$dhcpEnabled">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                          <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">stdInput</xsl:attribute>                          
                        </xsl:otherwise>
                      </xsl:choose>		
                      <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=1]!=$EMPTY_IP_TEST">
                        <xsl:attribute name="value">
                          <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=1]" />
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:element>
                  </td>
                </tr>
                <tr>
                  <td colspan="3" class="formSpacer">&#160;</td>
                </tr>
                <tr>
                  <td>
                    <span id="dnsAddress2Label">
                      <xsl:value-of select="$stringsDoc//value[@key='dnsServer']" /> 2:
                    </span>
                  </td>
                  <td width="10">&#160;</td>
                  <td>
                    <xsl:element name="input">
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="id">dnsAddress2</xsl:attribute>
                      <!-- validation: optional;IP address;unique;depends on dns1 -->
                      <xsl:attribute name="validate-netSettings">true</xsl:attribute>
                      <xsl:attribute name="rule-list">0;2;12;13</xsl:attribute>
                      <xsl:attribute name="related-inputs">dnsAddress1</xsl:attribute>
                      <xsl:attribute name="related-labels">dnsAddress1Label</xsl:attribute>
                      <xsl:attribute name="caption-label">dnsAddress2Label</xsl:attribute> 
                      <xsl:attribute name="maxlength">15</xsl:attribute>                      
                      <xsl:choose>
                        <xsl:when test="$dhcpEnabled">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                          <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">stdInput</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>			
                      <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=2]!=$EMPTY_IP_TEST">
                        <xsl:attribute name="value">
                          <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=2]" />
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:element>
                  </td>
                </tr>
              </table>
            </blockquote>						
          </div>					
        </td>
      </tr>
    </table>		
  </xsl:template>
  
  <!--
    ==========================================================================================
      @Purpose: renders IPv6 global info, and a form for setting IPv6 fields for the standby OA.    
      @notes  : 
    ==========================================================================================
  -->
  <xsl:template name="standbyNetworkIPv6Settings">    
    <!-- IPV6 INFO -->
    <xsl:call-template name="ipv6Information" />
    
    <!-- IPV6 SETTINGS -->
    <h5><xsl:value-of select="$stringsDoc//value[@key='standbyOANetworkSetting']" /></h5>
    <div id="errorContainer" class="errorDisplay"></div>
    
    <xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo">
      <xsl:variable name="dhcpEnabled" select="hpoa:dhcpEnabled='true'" />      
      <table cellpadding="0" cellspacing="0" border="0" style="width:auto;">
        <!-- STATIC addresses appear first in the list (0-based) with a maximum of 3 allowed -->
        <xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">
          <xsl:if test="position() &lt;= 3">
            <xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>
            <xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>
            <xsl:variable name="temp2" select="concat('Ipv6Address', (position()-1))"/>
            <tr>
              <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
            <tr>
              <xsl:element name="td">
                <xsl:attribute name="id"><xsl:value-of select="concat('lblStaticAddrIpv6', position())"/>
                </xsl:attribute>
                <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
                <xsl:value-of select="concat($stringsDoc//value[@key='ipv6StaticAddr'], position(), ':')"/>
              </xsl:element>
              <td width="5">&#160;</td>
              <td>
                <xsl:element name="input">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="caption-label"><xsl:value-of select="concat('lblStaticAddrIpv6', position())"/></xsl:attribute>
                  <xsl:attribute name="id"><xsl:value-of select="concat('StaticAddrIpv6', position())"/></xsl:attribute>
                  <xsl:attribute name="maxlength">45</xsl:attribute>
                  <xsl:attribute name="style">width:290px</xsl:attribute>
                  <xsl:attribute name="validate-static-ip">true</xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="position()>1">
                      <xsl:attribute name="rule-list">13;14</xsl:attribute>
                      <xsl:attribute name="related-inputs"><xsl:value-of select="concat('StaticAddrIpv6', position()-1)"/></xsl:attribute>
                      <xsl:attribute name="related-labels"><xsl:value-of select="concat('lblStaticAddrIpv6', position()-1)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="rule-list">14</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:attribute name="value">
                    <xsl:if test="contains($temp1, 'STATIC')">
                      <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
                    </xsl:if>                      
                  </xsl:attribute>                    
                </xsl:element>
              </td> 
            </tr>       
          </xsl:if>
        </xsl:for-each>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <xsl:element name="td">
            <xsl:attribute name="id">lblipv6dns1</xsl:attribute>
            <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
            IPv6 <xsl:value-of select="$stringsDoc//value[@key='dnsServer']" />&#160;1:
          </xsl:element>
          <td width="5">&#160;</td>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="style">width:290px</xsl:attribute>
              <xsl:attribute name="class">stdInput</xsl:attribute>
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="id">ipv6dns1</xsl:attribute>
              <xsl:attribute name="validate-static-ip">true</xsl:attribute>
              <xsl:attribute name="rule-list">15</xsl:attribute>
              <xsl:attribute name="caption-label">lblipv6dns1</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DnsStatic1']"/>
              </xsl:attribute>
            </xsl:element>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <xsl:element name="td">
            <xsl:attribute name="id">lblipv6dns2</xsl:attribute>
            <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
            IPv6 <xsl:value-of select="$stringsDoc//value[@key='dnsServer']" />&#160;2:
          </xsl:element>
          <td width="5">&#160;</td>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="style">width:290px</xsl:attribute>
              <xsl:attribute name="class">stdInput</xsl:attribute>
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="id">ipv6dns2</xsl:attribute>
              <xsl:attribute name="validate-static-ip">true</xsl:attribute>                                
              <!-- validation: optional;IP address;unique;depends on dns1 -->
              <xsl:attribute name="rule-list">12;15</xsl:attribute>
              <xsl:attribute name="caption-label">lblipv6dns2</xsl:attribute>
              <xsl:attribute name="related-inputs">ipv6dns1</xsl:attribute>
              <xsl:attribute name="related-labels">lblipv6dns1</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DnsStatic2']"/>
              </xsl:attribute>
            </xsl:element>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <xsl:element name="td">
            <xsl:attribute name="id">lblipv6DynDns</xsl:attribute>
            <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
            <label for="ipv6DynDns"><xsl:value-of select="$stringsDoc//value[@key='enableDynamicDNSIPv6']"/>:</label>
          </xsl:element>
          <td width="5">&#160;</td>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="class">stdCheckbox</xsl:attribute>
              <xsl:attribute name="style">margin-left:0px;</xsl:attribute>
              <xsl:attribute name="validate-dyn-dns">true</xsl:attribute>
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="id">ipv6DynDns</xsl:attribute>
              <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DynamicDns']='true'">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
            </xsl:element>
          </td>
        </tr>
        <tr>
          <td colspan="3" ><hr style="margin:10px 0px 10px 0px;" /></td>
        </tr>
        <!-- DEFAULT GATEWAY -->
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <xsl:element name="td">
            <xsl:attribute name="id">lblstaticipv6gw</xsl:attribute>
            <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
            <xsl:value-of select="$stringsDoc//value[@key='gatewayIPv6Static:']" />&#160;
          </xsl:element>
          <td width="5">&#160;</td>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="style">width:290px</xsl:attribute>
              <xsl:attribute name="class">stdInput</xsl:attribute>
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="id">staticipv6gw</xsl:attribute>
              <xsl:attribute name="validate-static-default-gw">true</xsl:attribute>
              <xsl:attribute name="rule-list">15</xsl:attribute>
              <xsl:attribute name="caption-label">lblstaticipv6gw</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6StaticDefaultGateway']"/>
              </xsl:attribute>
            </xsl:element>
          </td>
        </tr>   
          <!-- STATIC ROUTES -->
          <xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6StaticRouteDestination')]">            
            <xsl:variable name="SOAPName" select="concat('Ipv6StaticRouteDestination', position())"/>
            <xsl:variable name="GWSOAPName" select="concat('Ipv6StaticRouteGateway', position())"/>              
            <tr>
              <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
            <tr>
              <xsl:element name="td">
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('lblstaticipv6routedestination', position())"/>
                </xsl:attribute>
                <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
                <xsl:value-of select="concat($stringsDoc//value[@key='staticipv6routedestination'], position(), ':')" />&#160;
              </xsl:element>
              <td width="5">&#160;</td>
              <td>
                <xsl:element name="input">
                  <xsl:attribute name="style">width:290px</xsl:attribute>
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('staticipv6routedestination', position())"/>
                  </xsl:attribute>
                  <xsl:attribute name="validate-static-gw">true</xsl:attribute>
                  <xsl:attribute name="rule-list">13;14</xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="position()>1">
                      <xsl:attribute name="related-inputs"><xsl:value-of select="concat('staticipv6routegateway', position(), ';', 'staticipv6routedestination', position()-1)"/></xsl:attribute>
                      <xsl:attribute name="related-labels"><xsl:value-of select="concat('lblstaticipv6routegateway', position(), ';', 'lblstaticipv6routedestination', position()-1)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="related-inputs"><xsl:value-of select="concat('staticipv6routegateway', position())"/></xsl:attribute>
                      <xsl:attribute name="related-labels"><xsl:value-of select="concat('lblstaticipv6routegateway', position())"/></xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:attribute name="caption-label">
                    <xsl:value-of select="concat('lblstaticipv6routedestination', position())"/>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$SOAPName]"/>
                  </xsl:attribute>
                </xsl:element>
              </td>
            </tr>
            <!-- ROUTE GATEWAY -->
            <tr>
              <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
            <tr>
              <xsl:element name="td">
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('lblstaticipv6routegateway', position())"/>
                </xsl:attribute>
                <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
                <xsl:value-of select="concat($stringsDoc//value[@key='staticipv6routegateway'], position(), '):')" />&#160;
              </xsl:element>
              <td width="5">&#160;</td>
              <td>
                <xsl:element name="input">
                  <xsl:attribute name="style">width:290px</xsl:attribute>
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('staticipv6routegateway', position())"/>
                  </xsl:attribute>
                  <xsl:attribute name="validate-static-gw">true</xsl:attribute>
                  <xsl:attribute name="rule-list">13;15</xsl:attribute>
                  <xsl:attribute name="related-inputs"><xsl:value-of select="concat('staticipv6routedestination', position())"/></xsl:attribute>
                  <xsl:attribute name="related-labels"><xsl:value-of select="concat('lblstaticipv6routedestination', position())"/></xsl:attribute>
                  <xsl:attribute name="caption-label">
                    <xsl:value-of select="concat('lblstaticipv6routegateway', position())"/>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$GWSOAPName]"/>
                  </xsl:attribute>
                </xsl:element>
              </td>
            </tr>
          </xsl:for-each>
      </table>
    </xsl:for-each>    
  </xsl:template>

  <!--
  ==========================================================================================
    @Purpose: renders the form for setting domain name as dhcp-supplied or custom (override)
              for the standby OA.
    @notes  : the page logic is reversed - unchecking the checkbox enables the override.    
  ==========================================================================================
  -->
  <xsl:template name="advancedNicSettings">  
    
    <h5 style="margin-top:0px;margin-bottom:15px;"><xsl:value-of select="concat($stringsDoc//value[@key='advSettings'], ' ', $stringsDoc//value[@key='(standby)'])" /></h5>
    <div id="errorContainer" class="errorDisplay"></div>
    
    <div style="margin:0px;">
      <xsl:element name="input">
        <xsl:attribute name="type">checkbox</xsl:attribute>
        <xsl:attribute name="class">stdCheckBox</xsl:attribute>
        <xsl:attribute name="style">vertical-align:middle;margin:0px 10px 2px 0px;</xsl:attribute>
        <xsl:attribute name="name">dnsOverride</xsl:attribute>
        <xsl:attribute name="id">dnsOverride</xsl:attribute>
        <xsl:attribute name="onclick">toggleFormEnabled('dnSetting', !this.checked);</xsl:attribute>
        <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='false'">
          <xsl:attribute name="checked">true</xsl:attribute>
        </xsl:if>
      </xsl:element>    
      <label for="dnsOverride">
        <xsl:value-of select="$stringsDoc//value[@key='useDhcpDN']" />
      </label>
    </div>
    <div style="margin:16px 0px 10px 40px;">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td>
            <xsl:value-of select="$stringsDoc//value[@key='domainName:']" />
          </td>
          <td width="10">&#160;</td>
          <xsl:element name="td">
            <xsl:attribute name="id">dnSetting</xsl:attribute>
            <xsl:element name="input">
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="id">overrideDn</xsl:attribute>
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='true'">stdInput</xsl:when>
                  <xsl:otherwise>stdInputDisabled</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='false'">
                <xsl:attribute name="disabled">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">
                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='user_domain_name']" />
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
        </tr>
      </table>
    </div>
  </xsl:template>

  <!--
    ==========================================================================================
      @Purpose: renders the NIC options form for setting full auto or manual speeds for the standby OA.   
      @notes  : 
    ==========================================================================================
  -->
  <xsl:template name="nicSettings">
    <xsl:variable name="nicLinkForced" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICLinkForced']" />
    
    <h5 style="margin-top:0px;margin-bottom:15px;white-space:nowrap;">
      <xsl:value-of select="$stringsDoc//value[@key='nicSettingsStandby']" />
    </h5>
    <div id="errorContainer" class="errorDisplay"></div>
    
    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="name">nicSetting</xsl:attribute>						
            <xsl:attribute name="id">nicSetting_Auto</xsl:attribute>
            <xsl:attribute name="value">NIC_DUPLEX_AUTO</xsl:attribute>
            <xsl:attribute name="onclick">toggleFormEnabled('nicSettingsContainer', !this.checked);</xsl:attribute>
            <xsl:if test="$nicLinkForced = 'false'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
          </xsl:element>
        </td>
        <td width="10">&#160;</td>
        <td style="padding-top:4px;">
          <label for="nicSetting_Auto">
            <xsl:value-of select="$stringsDoc//value[@key='autoNeg']" />
          </label>
        </td>
      </tr>
    </table>
    <div class="formSpacer">&#160;</div>
    <hr />
    <div class="formSpacer">&#160;</div>
    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="name">nicSetting</xsl:attribute>						
            <xsl:attribute name="id">nicSetting_Full</xsl:attribute>
            <xsl:attribute name="value">NIC_DUPLEX_FULL</xsl:attribute>
            <xsl:attribute name="onclick">toggleFormEnabled('nicSettingsContainer', this.checked);</xsl:attribute>
            <xsl:if test="$nicLinkForced = 'true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
          </xsl:element>
        </td>
        <td width="10">&#160;</td>
        <td style="padding-top:4px;white-space:nowrap;">
          <label for="nicSetting_Full">
            <xsl:value-of select="$stringsDoc//value[@key='forcedFull']" />
          </label>
        </td>
      </tr>
    </table>
    <div id="nicSettingsContainer" style="margin:12px 0px 10px 45px;">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td style="white-space:nowrap;">
            <xsl:value-of select="$stringsDoc//value[@key='nicSpeed:']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:element name="select">
              <xsl:attribute name="id">nicSpeedSelect</xsl:attribute>							
              <xsl:if test="$nicLinkForced = 'false'">
                <xsl:attribute name="disabled">true</xsl:attribute>
              </xsl:if>
              <xsl:element name="option">
                <xsl:attribute name="value">NIC_SPEED_10</xsl:attribute>
                <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_10'">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>
                10Mbps
              </xsl:element>
              <xsl:element name="option">
                <xsl:attribute name="value">NIC_SPEED_100</xsl:attribute>
                <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_100'">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>
                100Mbps
              </xsl:element>								
            </xsl:element>
          </td>
        </tr>					
      </table>		
    </div>
  </xsl:template>
  
  
  <!--
    ==========================================================================================
      @Purpose: renders a read-only IPV4 information section    
      @notes  : 
    ==========================================================================================
  -->
  <xsl:template name="ivp4Information">
    <div class="groupingBox">
      <table cellpadding="0" cellspacing="2" border="0" width="auto">
        <tr>
          <td style="white-space:nowrap;"><xsl:value-of select="$stringsDoc//value[@key='enclosureIpMode']" />:</td>
          <td>&#160;</td>
          <td>
            <xsl:choose>
              <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='IpSwap']='true'">
                <xsl:value-of select="$stringsDoc//value[@key='enabled']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$stringsDoc//value[@key='disabled']" />
              </xsl:otherwise>
            </xsl:choose>      
          </td>
        </tr>
        <tr>
          <td><xsl:value-of select="$stringsDoc//value[@key='macAddress:']" /></td>
          <td width="10">&#160;</td>
          <td><xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:macAddress" /></td>
        </tr>
        <tr>
          <td><xsl:value-of select="$stringsDoc//value[@key='domainName:']" /></td>
          <td width="10">&#160;</td>
          <td>
            <xsl:choose>
              <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='true'">
                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='user_domain_name']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='dhcp_domain_name']" />
              </xsl:otherwise>
            </xsl:choose>            
          </td>
        </tr>
      </table>
    </div>
    <div class="formSpacer">&#160;</div>
  </xsl:template>
  
  
  <!--
    ==========================================================================================
      @Purpose: renders a read-only IPV6 information section    
      @notes  : 
    ==========================================================================================
  -->
  <xsl:template name="ipv6Information">
    <div class="groupingBox">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><xsl:value-of select="$stringsDoc//value[@key='enclosureIpMode']" />:</td>
          <td width="10">&#160;</td>
          <td>
            <xsl:choose>
              <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='IpSwap']='true'">
                <xsl:value-of select="$stringsDoc//value[@key='enabled']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$stringsDoc//value[@key='disabled']" />
              </xsl:otherwise>
            </xsl:choose>      
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <td>IPv6:</td>
          <td width="10">&#160;</td>
          <td>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true'">
              <xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
            </xsl:if>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='false'">
              <xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <!--IPV6 LINK LOCAL -->
        <xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">
          <xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>
          <xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>

          <xsl:if test="contains($temp1, 'LINKLOCAL')">
            <tr>
              <td>
                <xsl:value-of select="$stringsDoc//value[@key='ipv6LinkLocalAddr']"/>
              </td>
              <td width="10">&#160;</td>
              <td>
                <xsl:variable name="temp2" select="concat('Ipv6Address',(position()-1))"/>
                
                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
              </td>
            </tr>
            <tr>
              <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
          </xsl:if>
        </xsl:for-each>        
        <!--DYNAMIC DNS -->
        <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled']='true'">
          <tr>
            <td>
                <xsl:value-of select="$stringsDoc//value[@key='dynDNSIPv6']" />:
              </td>
            <td width="10">&#160;</td>
            <td>
              <xsl:choose>
                <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DynamicDns']='true'">
                  <xsl:value-of select="$stringsDoc//value[@key='enabled']" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='disabled']" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
        </xsl:if>
        <!--DHCP -->
        <tr>
          <td>
            <xsl:value-of select="$stringsDoc//value[@key='dhcpv6']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled']='true'">
              <xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
            </xsl:if>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled']='false'">
              <xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <!--DHCPv6 LOOP-->
        <xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">
          <xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>
          <xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>

          <xsl:if test="contains($temp1, 'DHCP')">
            <tr>
              <td>
                <xsl:value-of select="$stringsDoc//value[@key='dhcpv6Addr:']" />
              </td>
              <td width="10">&#160;</td>
              <td>
                <xsl:variable name="temp2" select="concat('Ipv6Address',(position()-1))"/>

                <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
              </td>
            </tr>
            <tr>
              <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
          </xsl:if>
        </xsl:for-each>
        <!-- RADV Traffic CODE -->
        <tr>
          <td>
            <xsl:value-of select="$stringsDoc//value[@key='routerTrafficConf']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RaTrafficEnabled']='true'">
              <xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
            </xsl:if>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RaTrafficEnabled']='false'">
              <xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <!-- RADV CODE -->
        <tr>
          <td style="white-space:nowrap;">
            <xsl:value-of select="$stringsDoc//value[@key='statelessAddrAutoconf']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='true'">
              <xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
            </xsl:if>
            <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='false'">
              <xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>   
      </table>
    </div>
    <div class="formSpacer">&#160;</div>
  </xsl:template>
</xsl:stylesheet>

