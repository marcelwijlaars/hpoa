<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:template name="networkAccessProtocols">

    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">httpAccess</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:httpsEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="httpAccess">
            <xsl:value-of select="$stringsDoc//value[@key='enableWebProtocol']" />
          </label>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">sshAccess</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:sshEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="sshAccess">
            <xsl:value-of select="$stringsDoc//value[@key='enableSSHProtocol']" />
          </label>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">telnetAccess</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:telnetEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="telnetAccess">
            <xsl:value-of select="$stringsDoc//value[@key='enableTelnetProtocol']" />
          </label>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">xmlReplyAccess</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:xmlReplyEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="xmlReplyAccess">
            <xsl:value-of select="$stringsDoc//value[@key='xmlReply']" />
          </label>
        </td>
      </tr>
    </table>

  </xsl:template>

  <xsl:template name="networkAccessSecurity">

    <xsl:element name="input">
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="class">stdCheckBox</xsl:attribute>
      <xsl:attribute name="id">ipSecEnabled</xsl:attribute>
      <xsl:if test="$serviceUserAcl = $USER">
        <xsl:attribute name="disabled">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="$networkInfoDoc//hpoa:ipSecurityEnabled='true'">
        <xsl:attribute name="checked">true</xsl:attribute>
      </xsl:if>

    </xsl:element><label for="ipSecEnabled">
      <xsl:value-of select="$stringsDoc//value[@key='enableIPSec']" />
    </label><br />

    <span class="whiteSpacer">&#160;</span><br />

    Trusted Addresses&#160;<xsl:value-of select="$stringsDoc//value[@key='ipExample']" /><br />
    <span class="whiteSpacer">&#160;</span><br />

    <xsl:choose>
      <xsl:when test="$serviceUserAcl != $USER">
        <table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td>
              <input class="stdInput" maxlength="15"  type="text" name="IPAddress" id="IPAddress" />
              <br />
              <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td class="formSpacer">&#160;</td>
                </tr>
              </table>
            </td>
            <td rowspan="2" valign="top" style="padding-top:4px;">
              <!-- These buttons call IP Transfer Box code defined in global.js -->
              <div class="verticalButtonSet" style="padding-left:10px;">
                <div class="bWrapperUp">
                  <div>
                    <div>
                      <button style="width:70px;" onclick="addTrustedHost();" class="hpButtonSmall" ID="ipTransfer_Add">
                        <xsl:value-of select="$stringsDoc//value[@key='add']" />
                      </button>
                    </div>
                  </div>
                </div>
                <div class="bWrapperUp">
                  <div>
                    <div>

						<xsl:element name="button">

							<xsl:attribute name="style">width:70px;</xsl:attribute>
							<xsl:attribute name="onclick">removeTrustedHosts();</xsl:attribute>
							<xsl:attribute name="class">hpButtonSmall</xsl:attribute>
							<xsl:attribute name="ID">ipTransfer_Remove</xsl:attribute>

							<xsl:if test="count($networkInfoDoc//hpoa:ipAllow[hpoa:ipAddress != '0.0.0.0']) = 0">
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:if>

							<xsl:value-of select="$stringsDoc//value[@key='remove']" />
							
						</xsl:element>
						
                    </div>
                  </div>
                </div>
              </div>
              <div class="clearFloats"></div>
            </td>
          </tr>
          <tr>
            <td>
              <select class="stdInput" size="5" name="selectedAddresses" style="width:100%" multiple="true" ID="selectedAddresses">
                <xsl:for-each select="$networkInfoDoc//hpoa:ipAllow/hpoa:ipAddress">
                  <xsl:if test="current() != $EMPTY_IP_TEST">
                    <xsl:element name="option">
                      <xsl:attribute name="value">
                        <xsl:value-of select="current()" />
                      </xsl:attribute>
                      <xsl:value-of select="current()" />
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </select>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <select class="stdInput" size="8" name="selectedAddresses" style="width:200px" multiple="true" ID="selectedAddresses">
          <xsl:for-each select="$networkInfoDoc//hpoa:ipAllow/hpoa:ipAddress">
            <xsl:if test="current() != $EMPTY_IP_TEST">
              <xsl:element name="option">
                <xsl:attribute name="value">
                  <xsl:value-of select="current()" />
                </xsl:attribute>
                <xsl:value-of select="current()" />
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </select>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>

