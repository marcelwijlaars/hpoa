<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
    
  <xsl:template name="addSnmpTrap" match="*">

    <xsl:variable name="fipsEnabled" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-DEBUG'" />
    
    <div id="errorDisplay" class="errorDisplay"></div>
    <em>
      <xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;*
    </em>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />

    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td id="lblAlertDest" valign="top" style="white-space:nowrap;">
          <xsl:value-of select="$stringsDoc//value[@key='snmpAlertDestination:']" />&#160;*
        </td>
        <td width="5">&#160;</td>
        <td valign="top">
          <input style="width:290px" validate-me="true" rule-list="6;8" range="1;64" caption-label="lblAlertDest" maxlength="64" class="stdInput" type="text" name="IPAddress" id="IPAddress" />      
        </td> 
        <td style="white-space:nowrap;padding-left:5px;">
          <xsl:value-of select="$stringsDoc//value[@key='ipDnsExample']" />        
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="4">&#160;</td>
      </tr>
      <tr id="snmpv1_container_1" name="snmpv1_container_1">
        <td valign="top" style="white-space:nowrap;">
          <xsl:value-of select="$stringsDoc//value[@key='communityString:']" />
        </td>
        <td width="5">&#160;</td>
        <td valign="top">
            <xsl:element name="input">
              <xsl:attribute name="style">width:290px</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="id">destinationString</xsl:attribute>
              <xsl:attribute name="name">destinationString</xsl:attribute>

              <xsl:choose>
                <xsl:when test="$fipsEnabled">
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                  <xsl:attribute name="perm-disable">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              
            </xsl:element>
        </td>
        <td>&#160;</td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="4">
          <br />
          <br />&#160;
        </td>
      </tr>
      <xsl:if test="$snmpv3Supported='true'">
        <tr>
          <td valign="top" colspan="4">
            <xsl:element name="input">
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="class">stdCheckBox</xsl:attribute>
              <xsl:attribute name="id">chkSNMPv3</xsl:attribute>
              <xsl:attribute name="name">chkSNMPv3</xsl:attribute>
              <xsl:attribute name="style">margin-bottom:1px;</xsl:attribute>
              <xsl:attribute name="onclick">enableSNMPv3Controls(this.checked);</xsl:attribute>
              <xsl:if test="$fipsEnabled or count($snmpInfo3Doc//hpoa:userInfo) = 0">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
				        <xsl:if test="$fipsEnabled">
                  <xsl:attribute name="checked">true</xsl:attribute>
				        </xsl:if>
              </xsl:if>
            </xsl:element>
            <label for="chkSNMPv3" style="margin-bottom:0px;">
              <xsl:value-of select="$stringsDoc//value[@key='SnmpVersion3']" />
            </label>
            <xsl:if test="$fipsEnabled">
              &#160;<span style="vertical-align:middle;">
                <xsl:call-template name="simpleTooltip">
                  <xsl:with-param name="msg" select="$stringsDoc//value[@key='snmpv3OnlyFips']" />
                </xsl:call-template>
              </span>
            </xsl:if>            
            <xsl:if test="count($snmpInfo3Doc//hpoa:userInfo) = 0">
              <span class="warningLabel">
                &#160;<xsl:value-of select="$stringsDoc//value[@key='snmpNoUsers']" />
              </span>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td class="formSpacer" colspan="4">&#160;</td>
        </tr>
        
        <tr id="snmpv3_container_1" name="snmpv3_container_1">
          <td id="lblUser" style="padding-left: 30px;">
            <xsl:value-of select="$stringsDoc//value[@key='user:']" />
          </td>
          <td width="5">&#160;</td>
          <td>
            <select class="stdInput" name="snmpUser" ID="snmpUser" caption-label="lblUser" option-id="chkSNMPv3">
              <xsl:if test="count($snmpInfo3Doc//hpoa:userInfo) = 0">
                <xsl:element name="option">
                  <xsl:attribute name="value"></xsl:attribute>                  
                  <xsl:value-of select="'none'"/>
                </xsl:element>
              </xsl:if>
              <xsl:for-each select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:users/hpoa:userInfo">
                <xsl:element name="option">
                  <xsl:attribute name="value">
                    <!-- 
                      for internal use, engine id first, for display, user first 
                      set engine ids that match current oa to be blank
                      when sent to back end code, correct local engine id will be substitued
                    -->
                    <xsl:choose>
                      <xsl:when test="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:engineid = hpoa:engineid">
                        <xsl:value-of select="concat('',';',hpoa:user)"/>                        
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="concat(hpoa:engineid,';',hpoa:user)"/>
                      </xsl:otherwise>
                    </xsl:choose>                                        
                  </xsl:attribute>
                  <xsl:value-of select="concat(hpoa:user,' - ',hpoa:engineid)"/>
                </xsl:element>
              </xsl:for-each>
            </select>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td class="formSpacer" colspan="4">&#160;</td>
        </tr>

        <tr id="snmpv3_container_2" name="snmpv3_container_2">
          <td id="lblSecurity" style="padding-left: 30px;">
            <xsl:value-of select="$stringsDoc//value[@key='security:']" />
          </td>
          <td width="5">&#160;</td>
          <td>
            <select class="stdInput" name="snmpSecurity" ID="snmpSecurity" caption-label="lblSecurity" style="width: 100px">
              <xsl:element name="option">
                <xsl:attribute name="value">SNMP-USER-SEC-NOAUTHNOPRIV</xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='TRAP-SNMP-USER-SEC-NOAUTHNOPRIV']" />
              </xsl:element>
              <xsl:element name="option">
                <xsl:attribute name="value">SNMP-USER-SEC-AUTHNOPRIV</xsl:attribute>
                <xsl:attribute name="selected">selected</xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='TRAP-SNMP-USER-SEC-AUTHNOPRIV']" />
              </xsl:element>
              <xsl:element name="option">
                <xsl:attribute name="value">SNMP-USER-SEC-AUTHPRIV</xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='TRAP-SNMP-USER-SEC-AUTHPRIV']" />
              </xsl:element>
            </select>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td colspan="4" class="formSpacer">&#160;</td>
        </tr>
        <tr id="snmpv3_container_3" name="snmpv3_container_3">
          <td id="lblInform" style="padding-left: 30px;white-space:nowrap;">
            <label for="chkInform">
              <xsl:value-of select="$stringsDoc//value[@key='SnmpInformMsg']" />&#160;
            </label>
          </td>
          <td width="5">&#160;</td>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="style">margin-left: 0;</xsl:attribute>
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="class">stdCheckBox</xsl:attribute>
              <xsl:attribute name="id">chkInform</xsl:attribute>
            </xsl:element>
          </td>
          <td>&#160;</td>
        </tr>
      </xsl:if>
    </table>

    <xsl:if test="$isWizard='false'">
      <br />
      <hr />
      <div align="right" style="margin-top:10px;">
        <div class='buttonSet'>
          <div class='bWrapperUp'>
            <div>
              <div>
                <xsl:element name="button">
                  <xsl:attribute name="type">button</xsl:attribute>
                  <xsl:attribute name="class">hpButton</xsl:attribute>
                  <xsl:attribute name="id">btnAddTrap</xsl:attribute>
                  <xsl:attribute name="onclick">addSnmpTrap();</xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='addTrap']" />
                </xsl:element>
              </div>
            </div>
          </div>
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnCancelTrap" onclick="cancelSnmpTrap();">
                  <xsl:value-of select="$stringsDoc//value[@key='cancel']" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>

