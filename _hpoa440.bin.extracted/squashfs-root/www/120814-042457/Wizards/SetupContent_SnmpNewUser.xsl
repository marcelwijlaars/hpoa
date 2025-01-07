<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:param name="stringsDoc" />
  <xsl:param name="isWizard" select="'true'" />
  <xsl:param name="snmpInfo3Doc" select="''" />
  <xsl:param name="networkInfoDoc" />

  <xsl:include href="../Forms/addSnmpUser.xsl" />

  <xsl:template match="*">
    
    <div id="stepInnerContent">

      <div class="wizardTextContainer" >

          <xsl:value-of select="$stringsDoc//value[@key='snmpUserSettingsPara1']"/>

      </div>

      <span class="whiteSpacer">&#160;</span>
      <br />
      <span class="whiteSpacer">&#160;</span>
      <br />
      <div id="userErrorDisplay" class="errorDisplay"></div>

      <xsl:call-template name="addSnmpUser" />

    </div>
    <div id="waitContainer" class="waitContainer"></div>

  </xsl:template>

</xsl:stylesheet>
