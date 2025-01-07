<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<!--
		Tree leaf template for use with JavaScript outside of the normal tree
		xslt transformation process.  Because of the way that JavaScript deals with 
		parameters and included templates, we cannot reuse the normal treeNavEnclosureLeaf
		template.  Instead, we must wrap it inside this stylesheet so it is called in
		the same manner as it would be within the tree.
	-->

	<xsl:param name="enclosureNumber" />
	<xsl:param name="deviceNumber" />
	<xsl:param name="deviceLabel" />
	<xsl:param name="deviceStatus" />

	<xsl:param name="customLabel" select="'none'" />
	<xsl:param name="href" select="'javascript:void(0);'" />

	<xsl:param name="stringsDoc" />
	
	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Templates/globalTemplates.xsl"/>
	<xsl:include href="../Templates/treeNavEnclosureLeaf.xsl"/>
	
	<xsl:variable name="powerSupplyText" select="$stringsDoc//value[@key='powerSupply']" />
	<xsl:variable name="fanText" select="$stringsDoc//value[@key='fan']" />
	<xsl:variable name="interconnectText" select="$stringsDoc//value[@key='interconnectBay']" />
	<xsl:variable name="bayText" select="$stringsDoc//value[@key='bay']" />
	
	<xsl:template name="treeNavEnclosureLeafExternal" match="*">

		<xsl:variable name="deviceName">
			<xsl:choose>
				<xsl:when test="starts-with($deviceLabel, 'ps')">
					<xsl:value-of select="$powerSupplyText" />
				</xsl:when>
				<xsl:when test="starts-with($deviceLabel, 'bay')">
					<xsl:value-of select="$bayText" />
				</xsl:when>
				<xsl:when test="starts-with($deviceLabel, 'interconnect')">
					<xsl:value-of select="$interconnectText" />
				</xsl:when>
				<xsl:when test="starts-with($deviceLabel, 'fan')">
					<xsl:value-of select="$fanText" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="leafInnerContent">
			<xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
			<xsl:with-param name="deviceNumber" select="$deviceNumber" />
			<xsl:with-param name="deviceLabel" select="$deviceLabel" />
			<xsl:with-param name="deviceStatus" select="$deviceStatus" />
			<xsl:with-param name="customLabel" select="$customLabel" />
			<xsl:with-param name="href" select="$href" />
			<xsl:with-param name="deviceName" select="$deviceName" />
		</xsl:call-template>
		
	</xsl:template>

</xsl:stylesheet>