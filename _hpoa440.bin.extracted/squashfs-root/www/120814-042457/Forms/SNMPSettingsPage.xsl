<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/SNMPSettings.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />

    <xsl:param name="stringsDoc" />
    <xsl:param name="networkInfoDoc" />
    <xsl:param name="snmpInfoDoc" />
    <xsl:param name="snmpInfo3Doc" select="''"/>    
	  <xsl:param name="serviceUserAcl" />
	  <xsl:param name="testSupported" />
    <xsl:param name="snmpv3Supported" select="'false'"/>

  <xsl:template match="*">
    <xsl:variable name="fipsEnabled" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-DEBUG'" />
    <b>
      <xsl:value-of select="$stringsDoc//value[@key='snmpSettings']" />
    </b>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />

		<div id="snmpErrorDisplay" class="errorDisplay"></div>
		
        <xsl:value-of select="$stringsDoc//value[@key='systemInfo:']" />&#160;<em>
            <xsl:value-of select="$stringsDoc//value[@key='snmpInfoDescription']" />
        </em><br />
        <span class="whiteSpacer">&#160;</span><br />

        <div class="groupingBox">
			    <div id="settingsErrorDisplay" class="errorDisplay"></div>
            <xsl:call-template name="SNMPSettings" />
          </div>

    <xsl:if test="$serviceUserAcl != $USER">
      <span class="whiteSpacer">&#160;</span>
      <br />
      <div align="right">
        <div class='buttonSet' style="margin-bottom:0px;">
          <div class='bWrapperUp'>
            <div>
              <div>
                <xsl:element name="button">
                  <xsl:attribute name="class">hpButton</xsl:attribute>
                  <xsl:attribute name="id">btnSetupSnmp</xsl:attribute>
                  <xsl:attribute name="onclick">setupSnmp();</xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                  <xsl:if test="$fipsEnabled and $snmpv3Supported !='true'">
                    <xsl:attribute name="disabled">true</xsl:attribute>
                  </xsl:if>
                </xsl:element>
              </div>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>

    <br />
    <br />
    <br />
    
		<xsl:value-of select="$stringsDoc//value[@key='alertDestinations']" />
		<span class="whiteSpacer">&#160;</span><br />
		
		<div>
      <span class="whiteSpacer">&#160;</span>
      <br />
			<div id="trapsErrorDisplay" class="errorDisplay"></div>
			<xsl:call-template name="SNMPTrapDestinations">
        <xsl:with-param name="showTest" select="'true'" />
      </xsl:call-template>
		</div>
  </xsl:template>
	

</xsl:stylesheet>

