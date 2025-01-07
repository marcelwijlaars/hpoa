<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  
  <xsl:template name="extendedFirmware">

		<xsl:param name="currentBayNumber" />
		<xsl:param name="display" />
		
		<xsl:element name="tr">
			<xsl:attribute name="class">rowHighlight1</xsl:attribute>
			<xsl:if test="$display='false'">
				<xsl:attribute name="style">display:none;</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="parentid">
				<xsl:value-of select="concat('tc_id', $currentBayNumber)"/>
			</xsl:attribute>
			<td>&#160;</td>
			<td>Component</td>
			<td>Current Version</td>
			<td>Firmware DVD Version</td>
			<td>&#160;</td>
			<td>&#160;</td>
		</xsl:element>
		
		<xsl:for-each select="start/HWDiscovery/serverinfo/rom">

			<xsl:element name="tr">
				<xsl:attribute name="class">contentsRow</xsl:attribute>
				<xsl:attribute name="parentid">
					<xsl:value-of select="concat('tc_id', $currentBayNumber)"/>
				</xsl:attribute>
				<xsl:if test="$display='false'">
					<xsl:attribute name="style">display:none;</xsl:attribute>
				</xsl:if>

				<td>&#160;</td>
				<td class="nested2" nowrap="true">
					System ROM
				</td>
				<td nowrap="true">
					<xsl:value-of select="concat('Version: ', version)"/>
					<br />
					<xsl:value-of select="concat('Family: ', family)"/>
				</td>
				<td nowrap="true">
					N/A
				</td>
				<td>&#160;</td>
				<td>&#160;</td>

			</xsl:element>

		</xsl:for-each>
		
		<xsl:for-each select="hp_rom_discovery">
			<xsl:for-each select="devices/device[funcnumber/@value='' or funcnumber/@value='0000']">

				<xsl:element name="tr">
					<xsl:attribute name="class">contentsRow</xsl:attribute>
					<xsl:attribute name="parentid">
						<xsl:value-of select="concat('tc_id', $currentBayNumber)"/>
					</xsl:attribute>
					<xsl:if test="$display='false'">
						<xsl:attribute name="style">display:none;</xsl:attribute>
					</xsl:if>

					<td>&#160;</td>
					<td class="nested2" nowrap="true">
						<xsl:value-of select="product_id/@value"/>
					</td>
					<td nowrap="true">
						<xsl:for-each select="fw_item">
							<xsl:value-of select="type/@value"/>: <xsl:value-of select="active_version/@value"/><br />
						</xsl:for-each>
					</td>
					<td nowrap="true">
						<xsl:for-each select="fw_item">
							<xsl:value-of select="type/@value"/>: <xsl:value-of select="version/@value"/><br />
						</xsl:for-each>
					</td>
					<td>&#160;</td>
					<td>&#160;</td>

				</xsl:element>

			</xsl:for-each>
		</xsl:for-each>

		<xsl:for-each select="start/HWDiscovery/storage_info/devices/device">

			<xsl:element name="tr">
				<xsl:attribute name="class">contentsRow</xsl:attribute>
				<xsl:attribute name="parentid">
					<xsl:value-of select="concat('tc_id', $currentBayNumber)"/>
				</xsl:attribute>
				<xsl:if test="$display='false'">
					<xsl:attribute name="style">display:none;</xsl:attribute>
				</xsl:if>

				<td>&#160;</td>
				<td class="nested2" nowrap="true">
					<xsl:value-of select="product_id/@value"/>
				</td>
				<td nowrap="true">
					<xsl:value-of select="written_version/@value"/>
				</td>
				<td nowrap="true">
					<xsl:value-of select="active_version/@value"/>
				</td>
				<td>&#160;</td>
				<td>&#160;</td>

			</xsl:element>

		</xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
