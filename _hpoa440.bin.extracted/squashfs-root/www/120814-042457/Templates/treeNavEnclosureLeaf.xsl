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
	<xsl:template name="treeNavEnclosureLeaf">
		
		<xsl:param name="enclosureNumber" />
		<xsl:param name="deviceNumber" />
		<xsl:param name="deviceLabel" />
		<xsl:param name="deviceStatus" />
		<xsl:param name="presence" />
		<xsl:param name="encNum" />
		
		<xsl:param name="customLabel" select="'none'" />
		<xsl:param name="href" select="'javascript:void(0);'" />
		<!--
			Determine the device name based on the label passed in.
			The label is used by JavaScript to identify the device
			in the page.  The deviceName variable contains the display
			name of the device for the UI.
		-->
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
		
		<xsl:element name="div">

			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="starts-with($deviceLabel, 'fan') and $deviceStatus!='OP_STATUS_UNKNOWN'">display:block;</xsl:when>
					<xsl:when test="$presence=$PRESENT">display:block;</xsl:when>
					<xsl:otherwise>display:none;</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:attribute name="class">leafWrapper</xsl:attribute>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('enc', $encNum, $deviceLabel, $deviceNumber, 'leafWrapper')"/>
			</xsl:attribute>

			<xsl:call-template name="leafInnerContent">
				<xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
				<xsl:with-param name="deviceNumber" select="$deviceNumber" />
				<xsl:with-param name="deviceLabel" select="$deviceLabel" />
				<xsl:with-param name="deviceStatus" select="$deviceStatus" />
				<xsl:with-param name="customLabel" select="$customLabel" />
				<xsl:with-param name="href" select="$href" />
				<xsl:with-param name="deviceName" select="$deviceName" />
			</xsl:call-template>
			
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="leafInnerContent">

		<xsl:param name="enclosureNumber" />
		<xsl:param name="deviceNumber" />
		<xsl:param name="deviceLabel" />
		<xsl:param name="deviceStatus" />
		<xsl:param name="deviceName" />

		<xsl:param name="customLabel" select="'none'" />
		<xsl:param name="href" select="'javascript:void(0);'" />
		
		<!-- Add the tree status icon by calling the statusIcon template -->
		<xsl:element name="div">

			<xsl:attribute name="class">treeStatusIcon</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, $deviceLabel, $deviceNumber, 'Status')"/></xsl:attribute>
			
			<xsl:if test="$deviceStatus != '' and $deviceStatus != $OP_STATUS_OK">
				<xsl:call-template name="statusIcon">
					<xsl:with-param name="statusCode" select="$deviceStatus" />
				</xsl:call-template>
			</xsl:if>
		</xsl:element>

		<!-- Add the tree leaf link and text label -->
		<xsl:element name="div">

			<xsl:attribute name="class">leaf</xsl:attribute>

			<!-- Tree leaf container's programmatic id -->
			<xsl:attribute name="id">
				<xsl:value-of select="concat('enc', $enclosureNumber, $deviceLabel, $deviceNumber, 'Select')" />
			</xsl:attribute>

			<!-- Tree leaf's hyperlink -->
			<xsl:element name="a">

				<xsl:attribute name="devId">
					<xsl:value-of select="concat('enc', $enclosureNumber, $deviceLabel, $deviceNumber, 'Select')" />
				</xsl:attribute>
				<xsl:attribute name="href">
					<xsl:value-of select="$href" />
				</xsl:attribute>
				<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
				<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

				<xsl:attribute name="devNum">
					<xsl:value-of select="$deviceNumber" />
				</xsl:attribute>
				<xsl:attribute name="devType">
					<xsl:value-of select="$deviceLabel" />
				</xsl:attribute>
				<xsl:attribute name="encNum">
					<xsl:value-of select="$enclosureNumber" />
				</xsl:attribute>

				<xsl:choose>
					<xsl:when test="$customLabel != 'none'">
						<xsl:value-of select="$customLabel" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($deviceName, ' ', $deviceNumber)" />
					</xsl:otherwise>
				</xsl:choose>

			</xsl:element>

		</xsl:element>
	</xsl:template>

</xsl:stylesheet>