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
  
  <xsl:template name="addSnmpUser" match="*">
    <div id="errorDisplay" class="errorDisplay"></div>
    <em>
      <xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;*
    </em>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />

    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td id="lblUsername">
          <xsl:value-of select="$stringsDoc//value[@key='username:']" />&#160;*
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <input maxlength="32" size="60" validate-me="true" rule-list="6;8" caption-label="lblUsername" range="1;32" class="stdInput" type="text" id="username" />
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>
      <tr>
        <td id="lblEngineID">
          <xsl:value-of select="$stringsDoc//value[@key='engineID:']" />&#160;
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3" style="white-space:nowrap;">
          
          <xsl:element name="input">
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="name">engineid</xsl:attribute>
            <xsl:attribute name="id">engineid</xsl:attribute>
            <xsl:attribute name="maxlength">66</xsl:attribute>
            <xsl:attribute name="size">60</xsl:attribute>
            <xsl:attribute name="validate-me">true</xsl:attribute>
            <xsl:attribute name="rule-list">0</xsl:attribute>
            <xsl:attribute name="caption-label">lblEngineID</xsl:attribute>
            <xsl:attribute name="range">2;66</xsl:attribute>
            <xsl:attribute name="class">stdInput</xsl:attribute>
            <xsl:if test="$isWizard='false'"> <!-- don't suggest engine id when dealing with one-to-many enclosures -->
              <xsl:attribute name="value">
                <xsl:value-of select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:engineid" />
              </xsl:attribute>
            </xsl:if>
          </xsl:element>
          <xsl:if test="$isWizard = 'true'">
            <xsl:call-template name="simpleTooltip">
              <xsl:with-param name="msg" select="$stringsDoc//value[@key='addUserEngineIdWizardDesc']" />
            </xsl:call-template>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>
      <tr>
        <td id="lblAccessMode">
          <xsl:value-of select="$stringsDoc//value[@key='snmpAccessMode:']" />
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <xsl:element name="select">
            <xsl:attribute name="class">stdInput</xsl:attribute>
            <xsl:attribute name="name">accessMode</xsl:attribute>
            <xsl:attribute name="ID">accessMode</xsl:attribute>
            <xsl:attribute name="caption-label">lblAccessMode</xsl:attribute>
            <xsl:attribute name="style">width: 100px</xsl:attribute>
            <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] != 'FIPS-OFF'">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:element name="option">
              <xsl:attribute name="value">0</xsl:attribute>
              <xsl:attribute name="selected">selected</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='snmpReadOnly']" />
            </xsl:element>
            <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-OFF'">
              <xsl:element name="option">
                <xsl:attribute name="value">1</xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='snmpReadWrite']" />
              </xsl:element>
            </xsl:if>
          </xsl:element>
          <xsl:call-template name="fipsHelpMsg">
            <xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']"/>
            <xsl:with-param name="msgType">tooltip</xsl:with-param>
            <xsl:with-param name="msgKey">fipsUnavailableLocalOnly</xsl:with-param>
          </xsl:call-template>
          <!-- if the above msg isn't shown, at least show not available msg-->
          <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-OFF'">
            <xsl:call-template name="simpleTooltip">              
              <xsl:with-param name="msg" select="$stringsDoc//value[@key='snmpv3LocalUserOnly']" />
            </xsl:call-template>
          </xsl:if>

        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>
      <tr>
        <td id="lblMinimumSecurity">
          <xsl:value-of select="$stringsDoc//value[@key='minSecurity:']" />
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <select class="stdInput" name="minimumSecurity" ID="minimumSecurity" caption-label="lblMinimumSecurity" style="width: 100px">
            <xsl:element name="option">
              <xsl:attribute name="value">SNMP-USER-SEC-NOAUTHNOPRIV</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='SNMP-USER-SEC-NOAUTHNOPRIV']" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:attribute name="value">SNMP-USER-SEC-AUTHNOPRIV</xsl:attribute>
              <xsl:attribute name="selected">selected</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='SNMP-USER-SEC-AUTHNOPRIV']" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:attribute name="value">SNMP-USER-SEC-AUTHPRIV</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='SNMP-USER-SEC-AUTHPRIV']" />
            </xsl:element>
          </select>
          <xsl:call-template name="simpleTooltip">
            <xsl:with-param name="msg" select="$stringsDoc//value[@key='snmpv3LocalUserOnly']" />
          </xsl:call-template>

        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5" style="padding-bottom: 3em;">&#160;</td>
      </tr>
      <tr>
        <td id="lblAuthProtocol">
          <xsl:value-of select="$stringsDoc//value[@key='snmpAuthProtocol:']" />
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <xsl:element name="select">
            <xsl:attribute name="class">stdInput</xsl:attribute>
            <xsl:attribute name="name">authAlgorithm</xsl:attribute>
            <xsl:attribute name="ID">authAlgorithm</xsl:attribute>
            <xsl:attribute name="caption-label">lblAuthProtocol</xsl:attribute>
            <xsl:attribute name="style">width: 100px</xsl:attribute>

            <xsl:element name="option">
              <xsl:attribute name="value">SNMP-USER-AUTH-SHA1</xsl:attribute>
              <xsl:attribute name="selected">selected</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='SNMP-USER-AUTH-SHA1']" />
            </xsl:element>
            <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-OFF'">
              <xsl:element name="option">
                <xsl:attribute name="value">SNMP-USER-AUTH-MD5</xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='SNMP-USER-AUTH-MD5']" />
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>

      <tr>
        <td id="lblAuthentication">
          <xsl:value-of select="$stringsDoc//value[@key='authPassphrase:']" />&#160;*
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <input maxlength="40" size="60" validate-me="true" rule-list="6" caption-label="lblAuthentication" range="8;40" class="stdInput" mirror-controlled="true" type="password" autocomplete="off" id="authPassphrase" />
        </td>
      </tr>
      
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>

      <tr>
        <td id="lblAuthenticationConfirm">
          <xsl:value-of select="$stringsDoc//value[@key='authPassphraseConfirm:']" />&#160;*
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <input maxlength="40" size="60" validate-me="true" rule-list="7" caption-label="lblAuthentication" range="8;40" related-inputs="authPassphrase" class="stdInput" type="password" autocomplete="off"  id="authPassphraseConfirm" />
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5" style="padding-bottom: 3em;">&#160;</td>
      </tr>

      <tr>
        <td id="lblPrivProtocol">
          <xsl:value-of select="$stringsDoc//value[@key='snmpPrivProtocol:']" />
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <xsl:element name="select">
            <xsl:attribute name="class">stdInput</xsl:attribute>
            <xsl:attribute name="name">privAlgorithm</xsl:attribute>
            <xsl:attribute name="ID">privAlgorithm</xsl:attribute>
            <xsl:attribute name="caption-label">lblPrivProtocol</xsl:attribute>
            <xsl:attribute name="style">width: 100px</xsl:attribute>

            <xsl:element name="option">
              <xsl:attribute name="value">SNMP-USER-PRIV-AES128</xsl:attribute>
              <xsl:attribute name="selected">selected</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='SNMP-USER-PRIV-AES128']" />
            </xsl:element>
            <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-OFF'">
              <xsl:element name="option">
                <xsl:attribute name="value">SNMP-USER-PRIV-DES</xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='SNMP-USER-PRIV-DES']" />
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>

      <tr>
        <td id="lblPrivacy">
          <xsl:value-of select="$stringsDoc//value[@key='privPassphrase:']" />
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <input maxlength="40" size="60" validate-me="true" rule-list="0;6" caption-label="lblPrivacy" range="8;40" class="stdInput" mirror-controlled="true" type="password" autocomplete="off" id="privPassphrase" />
          <xsl:call-template name="simpleTooltip">
            <xsl:with-param name="msg" select="$stringsDoc//value[@key='snmpv3PrivacyPassOptions']" />
          </xsl:call-template>          
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>
      <tr>
        <td id="lblPrivacyConfirm">
          <xsl:value-of select="$stringsDoc//value[@key='privPassphraseConfirm:']" />
        </td>
        <td style="width:10px;">&#160;</td>
        <td colspan="3">
          <input maxlength="40" size="60" validate-me="true" rule-list="7" caption-label="lblPrivacy" range="8;40" related-inputs="privPassphrase" class="stdInput" type="password" autocomplete="off" id="authPrivacyConfirm" />
        </td>
      </tr>
      <tr>
        <td class="formSpacer" colspan="5">&#160;</td>
      </tr>
    </table>

    <xsl:if test="$isWizard='false'">
      <br />
      <hr />
      <div align="right" style="margin-top:10px;">
        <div class='buttonSet'>
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnAddUser" onclick="addSnmpUser();">
                  <xsl:value-of select="$stringsDoc//value[@key='addUser']" />
                </button>
              </div>
            </div>
          </div>
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnCancelUser" onclick="cancelSnmpUser();">
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

