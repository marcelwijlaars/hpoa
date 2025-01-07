<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<!--
		Generic tree node leaf template. Takes enclosure number, device number,
		and device label (device type) as parameters.
		
		This template depends on the globalTemplates.xsl file being
		included in the topmost template.
	-->

	<xsl:param name="encNum" />
	<xsl:param name="username" />

	<xsl:template name="treeUserLeaf" match="*">

		<xsl:param name="encNum" select="$encNum" />
		<xsl:param name="username" select="$username" />
		
		<xsl:element name="div">

			<xsl:attribute name="class">leaf</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="concat('enc', $encNum, 'userLeaf', $username)"/></xsl:attribute>

			<xsl:element name="a">
				<xsl:attribute name="devId"><xsl:value-of select="concat('enc', $encNum, 'user', $username, 'Select')" /></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enclosure', $encNum, 'UserSelect', $username)" /></xsl:attribute>
				<xsl:attribute name="href">../html/editUser.html?action=edit&#38;username=<xsl:value-of select="$username" />&#38;encNum=<xsl:value-of select="$encNum"/></xsl:attribute>
				<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
				<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

				<xsl:attribute name="devNum"><xsl:value-of select="$username" /></xsl:attribute>
				<xsl:attribute name="devType">user</xsl:attribute>
				<xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>

				<xsl:value-of select="$username" />

			</xsl:element>

		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>