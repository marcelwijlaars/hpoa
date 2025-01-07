<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/DirectorySettings.xsl" />

	<xsl:param name="ldapInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="encNum" />
	<xsl:param name="isWizard" select="'false'" />
	
	<xsl:template name="SetupLDAP" match="*">

		<div id="stepInnerContent">

			<div class="wizardTextContainer">
        <xsl:value-of select="$stringsDoc//value[@key='ldapSettingsPara1']" />
        <xsl:value-of select="$stringsDoc//value[@key='ldapSettingsPara2a']" />
        <em>
          <xsl:value-of select="$stringsDoc//value[@key='ldapSettingsPara2b']" />
        </em>
        <xsl:value-of select="$stringsDoc//value[@key='ldapSettingsPara2c']" />
      </div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<div id="ldapErrorDisplay" class="errorDisplay"></div>

			<xsl:call-template name="directorySettings" />

		</div>
		<div id="waitContainer" class="waitContainer"></div>
		
	</xsl:template>
	
</xsl:stylesheet>

