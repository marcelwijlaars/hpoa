<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
		xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/firmwareStatusTable.xsl"/>
	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Templates/globalTemplates.xsl"/>

	<xsl:param name="stringsDoc" />
	<xsl:param name="oaSessionKey" />
	<xsl:param name="oaInfoDoc" />
	<xsl:param name="oaStatusDoc" />
	<xsl:param name="enclosureStatusDoc" />
	<xsl:param name="oaUrl" />
	<xsl:param name="fwSyncSupported" select="'false'" />

	<xsl:template match="*">

		<xsl:call-template name="firmwareStatusTable"></xsl:call-template>
		
	</xsl:template>
	
</xsl:stylesheet>
