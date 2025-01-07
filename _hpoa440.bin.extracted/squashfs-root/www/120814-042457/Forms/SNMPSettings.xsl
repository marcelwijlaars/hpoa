<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:include href="../Forms/SNMPAlerts.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  
  <xsl:template name="SNMPSettings">

    <xsl:variable name="fipsEnabled" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-DEBUG'" />

    <xsl:element name="input">
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="class">stdCheckBox</xsl:attribute>
      <xsl:attribute name="id">SNMPEnabled</xsl:attribute>


      <xsl:if test="$serviceUserAcl = $USER or ($fipsEnabled and $snmpv3Supported !='true')">
        <xsl:attribute name="disabled">true</xsl:attribute>
      </xsl:if>

      <xsl:attribute name="onclick">toggleFormEnabled('snmpForm', this.checked);</xsl:attribute>

      <xsl:if test="$networkInfoDoc//hpoa:snmpEnabled='true'">
        <xsl:attribute name="checked">true</xsl:attribute>
      </xsl:if>
    </xsl:element>

    <label for="SNMPEnabled">
      <xsl:value-of select="$stringsDoc//value[@key='enableSNMP']" />
      <xsl:if test="$fipsEnabled and $snmpv3Supported !='true'">
        <xsl:call-template name="fipsHelpMsg">
          <xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']"/>
          <xsl:with-param name="msgType">tooltip</xsl:with-param>
          <xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </label>

    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
    <div id="snmpForm">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td>
            <xsl:value-of select="$stringsDoc//value[@key='systemName:']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <span id="systemNameLabel">
              <xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:sysName" />
            </span>
          </td>
        </tr>

        <xsl:if test="$snmpv3Supported='true'">
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <tr>
            <td>
              <xsl:value-of select="$stringsDoc//value[@key='engineID:']" />
            </td>
            <td width="10">&#160;</td>
            <td>
              <span id="engineIdLabel">
                <xsl:value-of select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:engineid" />
              </span>
            </td>
          </tr>
        </xsl:if>

        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <td id="systemLocationLabel">
            <xsl:value-of select="$stringsDoc//value[@key='systemLocation:']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:element name="input">

              <xsl:choose>
                <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">systemLocation</xsl:attribute>
              <xsl:attribute name="id">systemLocation</xsl:attribute>
              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="readonly">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">
                <xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:sysLocation" />
              </xsl:attribute>

              <xsl:attribute name="maxlength">20</xsl:attribute>

            </xsl:element>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <td id="systemContactLabel">
            <xsl:value-of select="$stringsDoc//value[@key='systemContact:']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:element name="input">

              <xsl:choose>
                <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">systemContact</xsl:attribute>
              <xsl:attribute name="id">systemContact</xsl:attribute>
              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="readonly">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">
                <xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:sysContact" />
              </xsl:attribute>

              <xsl:attribute name="maxlength">20</xsl:attribute>

            </xsl:element>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer"><br /><br /></td>
        </tr>
        <tr>
          <td id="rcLabel">
            <xsl:value-of select="$stringsDoc//value[@key='readCommunity:']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:element name="input">

              <xsl:choose>
                <xsl:when test="$fipsEnabled">
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:when>
                <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">readCommunity</xsl:attribute>
              <xsl:attribute name="id">readCommunity</xsl:attribute>
              <xsl:if test="$fipsEnabled">
                <xsl:attribute name="perm-disable">true</xsl:attribute>
              </xsl:if>

              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="readonly">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">
                <xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:roCommunity" />
              </xsl:attribute>

              <xsl:attribute name="maxlength">20</xsl:attribute>

            </xsl:element>
            <xsl:if test="$fipsEnabled and $snmpv3Supported ='true'">
              <xsl:call-template name="fipsHelpMsg">
                <xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']"/>
                <xsl:with-param name="msgType">tooltip</xsl:with-param>
                <xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
              </xsl:call-template>
            </xsl:if>

          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <td id="wcLabel">
            <xsl:value-of select="$stringsDoc//value[@key='writeCommunity:']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:element name="input">

              <xsl:choose>

                <xsl:when test="$fipsEnabled">
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:when>
                <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">writeCommunity</xsl:attribute>
              <xsl:attribute name="id">writeCommunity</xsl:attribute>
              <xsl:if test="$fipsEnabled">
                <xsl:attribute name="perm-disable">true</xsl:attribute>
              </xsl:if>

              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="readonly">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">
                <xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:rwCommunity" />
              </xsl:attribute>

              <xsl:attribute name="maxlength">20</xsl:attribute>

            </xsl:element>
            <xsl:if test="$fipsEnabled and $snmpv3Supported ='true'">
              <xsl:call-template name="fipsHelpMsg">
                <xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']"/>
                <xsl:with-param name="msgType">tooltip</xsl:with-param>
                <xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
              </xsl:call-template>
            </xsl:if>

          </td>
        </tr>

        <xsl:if test="$snmpv3Supported='true'">
          <tr>
            <td colspan="3" class="formSpacer"><br /><br /></td>
          </tr>
          <tr>
            <td id="engineIdStringLabel">
              <xsl:value-of select="$stringsDoc//value[@key='engineIdString:']" />
            </td>
            <td width="10">&#160;</td>
            <td>
              <xsl:element name="input">

                <xsl:choose>
                  <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
                    <xsl:attribute name="class">stdInput</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                    <xsl:attribute name="disabled">true</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="name">engineIdString</xsl:attribute>
                <xsl:attribute name="id">engineIdString</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:engineIdString" />
                </xsl:attribute>

                <xsl:attribute name="maxlength">27</xsl:attribute>

              </xsl:element>
              <xsl:call-template name="simpleTooltip">
                <xsl:with-param name="msg" select="$stringsDoc//value[@key='snmpv3EngineIdChange']" />
              </xsl:call-template>
            </td>
          </tr>

        </xsl:if>

      </table>

    </div>
  </xsl:template>

  <xsl:template name="SNMPTrapDestinations">
    <xsl:param name="showTest" select="'false'" />
    <xsl:param name="isWizard" select="'false'" />
    
    <div id="snmpTrapContainer" name="snmpTrapContainer">
      <xsl:call-template name="SNMPAlerts">
        <xsl:with-param name="isWizard" select="$isWizard" />
      </xsl:call-template>
   
      <xsl:if test="$testSupported='true' and $showTest = 'true'">
        <p>
          <xsl:value-of select="$stringsDoc//value[@key='testAlertDestinations']"  />
        </p>
        <div class="errorDisplay" id="errorDisplay"></div>

        <table id="tblTestAlerts" cellpadding="0" cellspacing="10" width="100%" style="border:1px solid #ccc;">
          <tr>
            <td style="vertical-align:middle;padding:15px;">
              <i valign="middle">
                <xsl:value-of select="$stringsDoc//value[@key='testAlertDestinationsDesc']"/>
              </i>
            </td>
            <td style="padding:10px 15px 0px 0px;">
              <div class="buttonSet" style="margin:0px;">
                <div class='bWrapperUp'>
                  <div>
                    <div>
                      <xsl:element name="button">
                        <xsl:attribute name="class">hpButton</xsl:attribute>
                        <xsl:attribute name="id">btnTestSnmp</xsl:attribute>
                        <xsl:attribute name="onclick">testSnmp();</xsl:attribute>
                        <xsl:if test="$networkInfoDoc//hpoa:snmpEnabled!='true' or ($snmpv3TrapCount + $snmpTrapCount = 0)">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$stringsDoc//value[@key='sndTestAlert']" />
                      </xsl:element>
                    </div>
                  </div>
                </div>
              </div>
            </td>
          </tr>
        </table>
      </xsl:if>
      
    </div>

  </xsl:template>

</xsl:stylesheet>

