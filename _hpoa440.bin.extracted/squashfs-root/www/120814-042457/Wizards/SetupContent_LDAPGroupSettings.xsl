<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="enclosureList" />
	<xsl:param name="groupInfoDoc" />
	<xsl:param name="username" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="action" />
	<xsl:param name="serviceUserAcl" select="$ADMINISTRATOR" />
	<xsl:param name="userOaAccess" select="'true'" />
	<xsl:param name="isCurrentUser" select="'false'" />

	<xsl:param name="enclosureType" select="0" />
	<xsl:param name="linkHasMixed" select="'false'" />
  <xsl:param name="lcdInfoDoc" />
  <xsl:param name="isTower" select="'false'" />
  
	<xsl:include href="../Wizards/wizardForms/GroupSettings.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />

	<xsl:param name="numIoBays" />
	<xsl:param name="numDeviceBays" />
	
	<!--
		We don't use this in the wizard, but it's required
		for the users templates.
	-->
	<xsl:param name="encNum" select="1" />
	
	<xsl:template match="*">
		
		<div id="stepInnerContent">

			<div class="wizardTextContainer" >

				<xsl:choose>
					<xsl:when test="$action='add'">
            <xsl:value-of select="$stringsDoc//value[@key='ldapGroupSettingsPara1']" />
            <xsl:value-of select="$stringsDoc//value[@key='ldapGroupSettingsPara2a']" />
            <b>
              <xsl:value-of select="$stringsDoc//value[@key='addGroup']" />
            </b>
            <xsl:value-of select="$stringsDoc//value[@key='ldapGroupSettingsPara2b']" />
					</xsl:when>
					<xsl:otherwise>
            <xsl:value-of select="$stringsDoc//value[@key='ldapGroupSettingsPara3']" />
            <xsl:value-of select="$stringsDoc//value[@key='ldapGroupSettingsPara2a']" />
            <b>
              <xsl:value-of select="$stringsDoc//value[@key='updateGroup']" />
            </b>
            <xsl:value-of select="$stringsDoc//value[@key='ldapGroupSettingsPara2b']" />
					</xsl:otherwise>
				</xsl:choose>
				
			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div id="groupErrorDisplay" class="errorDisplay"></div>

			<xsl:call-template name="groupSettings" />
			
		</div>
		<div id="waitContainer" class="waitContainer"></div>
		
	</xsl:template>
	
</xsl:stylesheet>

