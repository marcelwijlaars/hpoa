<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="enclosureName" />
	<xsl:param name="enclosureNumber" />

	<xsl:template match="*">
		
		<img align='bottom' border='0' height="11" src='/120814-042457/images/shortcut.gif' style='margin-right: 3px' width="11" />
		
		<xsl:element name="a">
			<xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$enclosureNumber" />, 'enc', <xsl:value-of select="$enclosureNumber" />, true);</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="concat('enclosure', $enclosureNumber, 'ShortcutLink')"/></xsl:attribute>
			<xsl:value-of select="$enclosureName"/>
		</xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>
