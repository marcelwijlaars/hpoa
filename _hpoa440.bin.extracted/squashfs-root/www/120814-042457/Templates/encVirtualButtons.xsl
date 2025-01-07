<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:include href="../Templates/uid.xsl" />

	<xsl:param name="enclosureStatusDoc" />
	
	<xsl:template match="*">

		<xsl:value-of select="$stringsDoc//value[@key='virtualIndicator']" />
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<div class="groupingBox">
			<xsl:call-template name="uid">
				<xsl:with-param name="uidState" select="$enclosureStatusDoc//hpoa:enclosureStatus/hpoa:uid" />
			</xsl:call-template>
		</div>
		<br />
    <span class="whiteSpacer">&#160;</span>
	</xsl:template>
	
</xsl:stylesheet>

