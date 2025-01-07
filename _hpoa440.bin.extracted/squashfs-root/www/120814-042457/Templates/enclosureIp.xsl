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

    <xsl:value-of select="$stringsDoc//value[@key='encIPAddress:']" />&#160;<em>
      <xsl:value-of select="$stringsDoc//value[@key='encIPAddressDesc']" />
    </em>
    <br />
    <span class="whiteSpacer">&#160;</span><br />
    <span class="whiteSpacer">&#160;</span><br />
    <div class="errorDisplay" id="errorDisplay"></div>

    <xsl:element name="input">
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="class">stdCheckBox</xsl:attribute>
      <xsl:attribute name="id">enclosureIpEnabled</xsl:attribute>
      <xsl:attribute name="onclick">toggleFormEnabled('enclosureIpForm', this.checked);</xsl:attribute>
      <xsl:if test="$serviceUserAcl = $USER">
        <xsl:attribute name="disabled">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingIpEnabled']='true'">
        <xsl:attribute name="checked">true</xsl:attribute>
      </xsl:if>

    </xsl:element><label for="enclosureIpEnabled">
      <xsl:value-of select="$stringsDoc//value[@key='enableEncIPAddress']" />
    </label><br />
    <span class="whiteSpacer">&#160;</span><br />

    <div id="enclosureIpForm">

      <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
          <TD>
            <span id="lblIpAddress"><xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" />*</span>
          </TD>
          <TD width="10">&#160;</TD>
          <TD>
            <xsl:element name="input">

              <xsl:attribute name="class">stdInput</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingIpEnabled']='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">ipAddress</xsl:attribute>
              <xsl:attribute name="id">ipAddress</xsl:attribute>
              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="readonly">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">
                <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingIpAddress'] != '0.0.0.0'">
                  <xsl:value-of select="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingIpAddress']" />
                </xsl:if>  
              </xsl:attribute> 
              
              <xsl:attribute name="validate-me">true</xsl:attribute>
              <xsl:attribute name="rule-list">2</xsl:attribute>
              <xsl:attribute name="caption-label">lblIpAddress</xsl:attribute>

              <xsl:attribute name="maxlength">64</xsl:attribute>        

            </xsl:element>
          </TD>
        </TR>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <TR>
          <TD>
            <span id="lblNetmask"><xsl:value-of select="$stringsDoc//value[@key='subnetMask:']" /></span>
          </TD>
          <TD width="10">&#160;</TD>
          <TD>
            <xsl:element name="input">

              <xsl:attribute name="class">stdInput</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingIpEnabled']='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">netmask</xsl:attribute>
              <xsl:attribute name="id">netmask</xsl:attribute>
              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="readonly">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">
                <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingNetmask'] != '0.0.0.0'">
                  <xsl:value-of select="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingNetmask']" />
                </xsl:if>
              </xsl:attribute>

              <xsl:attribute name="validate-me">true</xsl:attribute>
              <xsl:attribute name="rule-list">0;2</xsl:attribute>
              <xsl:attribute name="caption-label">lblNetmask</xsl:attribute>

              <xsl:attribute name="maxlength">64</xsl:attribute>
              
            </xsl:element>
          </TD>
        </TR>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <TR>
          <TD>
            <span id="lblGateway"><xsl:value-of select="$stringsDoc//value[@key='gateway:']" /></span>
          </TD>
          <TD width="10">&#160;</TD>
          <TD>
            <xsl:element name="input">

              <xsl:attribute name="class">stdInput</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingIpEnabled']='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">gateway</xsl:attribute>
              <xsl:attribute name="id">gateway</xsl:attribute>
              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="readonly">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">              
                <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingGateway'] != '0.0.0.0'">
                  <xsl:value-of select="$networkInfoDoc//hpoa:extraData[@hpoa:name='roamingGateway']" />
                </xsl:if>                
              </xsl:attribute>

              <xsl:attribute name="validate-me">true</xsl:attribute>
              <xsl:attribute name="rule-list">0;2</xsl:attribute>
              <xsl:attribute name="caption-label">lblGateway</xsl:attribute>

              <xsl:attribute name="maxlength">64</xsl:attribute>
              
            </xsl:element>
          </TD>
        </TR>
      </TABLE>

    </div>

    <xsl:if test="$serviceUserAcl != $USER">

      <span class="whiteSpacer">&#160;</span>
      <br />
      <div align="right">
        <div class='buttonSet'>
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnApplyDateTime" onclick="setEnclosureIp();">
                  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

    </xsl:if>

  </xsl:template>
  
</xsl:stylesheet>
