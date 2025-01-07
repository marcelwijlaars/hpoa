<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="setupType" select="''" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureList" />
	
	<xsl:template name="SetupEMNet" match="*">
		
		<div class="wizardTextContainer">

			<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara1']"/><br />
			

			<span class="whiteSpacer">&#160;</span><br />

			<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara2']"/><br />

			<span class="whiteSpacer">&#160;</span><br />

			<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara3']"/><br />

			<span class="whiteSpacer">&#160;</span><br />
			
			<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara4']"/><br />
			
			<span class="whiteSpacer">&#160;</span><br />
			
			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

	  <xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara7']"/>

    </div>
	
	</xsl:template>
	
</xsl:stylesheet>

