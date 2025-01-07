<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../Templates/guiConstants.xsl"/>

	<xsl:param name="networkInfoDoc" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="serviceUserAcl" />
  
  <xsl:template match="*">

    <xsl:value-of select="$stringsDoc//value[@key='ipSec:']" />&#160;<em>
      <xsl:value-of select="$stringsDoc//value[@key='ipSecDescription']" />
    </em>
    <br />
    <span class="whiteSpacer">&#160;</span><br />

    <div id="securityErrorDisplay" class="errorDisplay"></div>
    <xsl:call-template name="networkAccessSecurity" />

    <xsl:if test="$serviceUserAcl != $USER">
      <span class="whiteSpacer">&#160;</span>
      <br />
      <div align="right">
        <div class='buttonSet' style="margin-bottom:0px;">
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnSetIPSec" onclick="setIpSecurity();">
                  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>
    
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
    
    <xsl:value-of select="$stringsDoc//value[@key='trustedAddress']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='ipv4v6Example']" /><br />
    <span class="whiteSpacer">&#160;</span><br />

    <xsl:choose>
      <xsl:when test="$serviceUserAcl != $USER">
        <table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td>
              <input class="stdInput" maxlength="44"  style="width:290px" type="text" name="IPAddress" id="IPAddress" />
		
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
              <select class="stdInput" size="5" name="selectedAddresses" style="width:290px" multiple="true" ID="selectedAddresses">
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
        <select class="stdInput" size="8" name="selectedAddresses" style="width:100px" multiple="true" ID="selectedAddresses">
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
