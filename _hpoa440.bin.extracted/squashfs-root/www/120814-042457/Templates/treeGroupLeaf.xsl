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
  
  <xsl:param name="groupEncNum" />
  <xsl:param name="groupName" />
  <xsl:param name="groupNameURI" />

  <xsl:template name="treeGroupLeaf" match="*">

    <xsl:param name="groupEncNum" select="$groupEncNum" />
    <xsl:param name="groupName" select="$groupName" />
    <xsl:param name="groupNameURI" select="$groupNameURI" />

    <xsl:element name="div">

			<xsl:attribute name="class">leaf</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="concat('enc', $groupEncNum, 'groupLeaf', $groupNameURI)"/></xsl:attribute>

			<xsl:element name="a">
				<xsl:attribute name="devId"><xsl:value-of select="concat('enc', $groupEncNum, 'group', $groupNameURI, 'Select')" /></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enclosure', $groupEncNum, 'GroupSelect', $groupNameURI)" /></xsl:attribute>
				<xsl:attribute name="href">../html/editGroup.html?action=edit&#38;groupName=<xsl:value-of select="$groupNameURI"/>&#38;encNum=<xsl:value-of select="$groupEncNum"/></xsl:attribute>
				<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
				<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

				<xsl:attribute name="devNum"><xsl:value-of select="$groupNameURI" /></xsl:attribute>
				<xsl:attribute name="devType">group</xsl:attribute>
				<xsl:attribute name="encNum"><xsl:value-of select="$groupEncNum" /></xsl:attribute>

				<xsl:value-of select="$groupName" />

			</xsl:element>

		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>