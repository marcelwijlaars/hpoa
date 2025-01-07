<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:output method="text"/>
	
	<!--
	IMPORTANT: This stylesheet formatting is difficult to read, but
	it must stay this way to maintain correct spacing for the CSV formatting.
	-->
	<xsl:template match="rackFirmware" xml:space="preserve">Bay Number, Device Name, Discovered, Firmware Component, Current Version, Firmware ISO Version
<xsl:for-each select="bladeFirmwareList" xml:space="preserve">
<xsl:value-of select="concat('Enclosure: ', @enclosureName)" /><br />
<xsl:for-each select="bladeFirmware" xml:space="preserve"><xsl:variable name="discovered"><xsl:choose><xsl:when test="@lastUpdate!=''"><xsl:value-of select="true()" /></xsl:when><xsl:otherwise><xsl:value-of select="false()" /></xsl:otherwise></xsl:choose></xsl:variable>&#10;<xsl:value-of select="@symbolicBayNumber" />, <xsl:value-of select="normalize-space(@name)" />, <xsl:choose><xsl:when test="$discovered!='true'">No</xsl:when><xsl:otherwise><xsl:value-of select="@lastUpdate" /></xsl:otherwise></xsl:choose>, <xsl:call-template name="romInfo" ><xsl:with-param name="discovered" select="$discovered" /></xsl:call-template>, <xsl:call-template name="iloInfo"><xsl:with-param name="discovered" select="$discovered" /></xsl:call-template>, <xsl:call-template name="pmcInfo"><xsl:with-param name="discovered" select="$discovered" /></xsl:call-template>, <xsl:call-template name="nicInfo" /></xsl:for-each>
</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="romInfo">
                <xsl:param name="discovered" select="false()" />
                <xsl:variable name="romVersion"><xsl:value-of select="rom"/></xsl:variable>
		<xsl:choose>
			<!--FDT-->
			<xsl:when test="count(start/HWDiscovery/serverinfo/rom) &gt; 0">
				<xsl:for-each select="start/HWDiscovery/serverinfo/rom">System ROM, <xsl:value-of select="family"/> <xsl:value-of select="version"/>, </xsl:for-each>
			</xsl:when>
			<!--DVD-->
			<xsl:when test="count(start/firmwarereport/system//rom_details) &gt; 0">
				<xsl:for-each select="start/firmwarereport/system//rom_details">System ROM, <xsl:value-of select="concat(rom_family, ' ', rom_version)"/>, <xsl:value-of select="concat(rom_family, ' ', repo_version)"/></xsl:for-each>
			</xsl:when>
			<!--OA Data-->
			<xsl:otherwise>System ROM, <xsl:value-of select="$romVersion"/>, <xsl:if test="$discovered='true'"><xsl:text>
</xsl:text>No component</xsl:if></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<xsl:template name="iloInfo">
                <xsl:param name="discovered" select="false()" />
                <xsl:variable name="iloVersion"><xsl:value-of select="iLO/version"/></xsl:variable>
		<xsl:choose>
                        <xsl:when test="count(start/firmwarereport/system//ilo_details/type) &gt; 0">
				<xsl:for-each select="start/firmwarereport/system//ilo_details"><xsl:value-of select="type"/>, <xsl:value-of select="$iloVersion"/>, <xsl:value-of select="repo_version"/></xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="iLO/model"/>, <xsl:value-of select="$iloVersion"/>, <xsl:if test="$discovered='true'">No component</xsl:if></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="pmcInfo">
                <xsl:param name="discovered" select="false()" />
                <xsl:variable name="powerPicVersion"><xsl:value-of select="pmcVersion"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="count(start/firmwarereport/system//powerpic_details/powerpic/version) &gt; 0">
				<xsl:for-each select="start/firmwarereport/system//powerpic_details/powerpic"><xsl:value-of select="product_id"/>, <xsl:value-of select="$powerPicVersion"/>, <xsl:value-of select="repo_version"/></xsl:for-each>
			</xsl:when>
			<xsl:when test="count(start/hp_rom_discovery//device/device_id[contains(@value, 'PowerPIC')]) &gt; 0">
				<xsl:for-each select="start//hp_rom_discovery//devices/device[contains(device_id/@value, 'PowerPIC')]"><xsl:value-of select="product_id/@value"/>, <xsl:value-of select="fw_item/type/@value"/>: <xsl:value-of select="fw_item/active_version/@value"/>, <xsl:value-of select="fw_item/type/@value"/>: <xsl:value-of select="fw_item/version/@value"/></xsl:for-each>
			</xsl:when>
			<xsl:otherwise>Power Management Controller, <xsl:value-of select="$powerPicVersion"/>, <xsl:if test="$discovered='true'">No component</xsl:if></xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="nicInfo">
		<xsl:choose>
			<!--FDT-->
			<xsl:when test="count(start/hp_rom_discovery) &gt; 0">

				<xsl:for-each select="start/hp_rom_discovery">
					<xsl:for-each select="devices/device[(funcnumber/@value='' or funcnumber/@value='0000') and not(contains(device_id/@value, 'PowerPIC'))]"><xsl:for-each select="fw_item"><xsl:value-of select="../product_id/@value"/>, <xsl:value-of select="type/@value"/>: <xsl:value-of select="active_version/@value"/>, <xsl:value-of select="type/@value"/>: <xsl:value-of select="version/@value"/>, </xsl:for-each></xsl:for-each>
				</xsl:for-each>

				<xsl:for-each select="start/HWDiscovery/storage_info/devices/device">

							<xsl:variable name="productId" select="product_id/@value" />

							<xsl:choose>
								<xsl:when test="//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId != ''">
									<xsl:value-of select="//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(device_id/@value, ':')">
											<xsl:value-of select="$productId"/> <xsl:value-of select="concat('(Bay ', substring(device_id/@value, 5, 1), ')')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$productId"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>, <xsl:value-of select="written_version/@value"/>, <xsl:value-of select="active_version/@value"/>, </xsl:for-each>
			</xsl:when>
			
			<!--DVD-->
			<xsl:when test="count(start/firmwarereport) &gt; 0">

				<xsl:for-each select="start/firmwarereport/system">
					<xsl:for-each select=".//nic_details/nic_device">
            <xsl:if test="count(.//version/..) &gt; 0"><xsl:for-each select=".//version/.."><xsl:value-of select="../product_id"/>, <xsl:value-of select="concat(local-name(.), ' : ', version)" />, <xsl:value-of select="concat(local-name(.), ' : ', repo_version)" />, </xsl:for-each></xsl:if>
            <xsl:for-each select="./*/repo_version/.."><xsl:if test="count(./version) = 0"><xsl:value-of select="../product_id"/>, <xsl:value-of select="concat(local-name(.), ' : ', version)" />, <xsl:value-of select="concat(local-name(.), ' : ', repo_version)" />, </xsl:if></xsl:for-each>
					</xsl:for-each>

					<xsl:for-each select=".//scontroller_details/scontroller_device">
						<xsl:variable name="productId" select="product_id" />

						<xsl:choose>
							<xsl:when test="//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId != ''"><xsl:value-of select="//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$productId"/></xsl:otherwise>
						</xsl:choose>, <xsl:value-of select="version"/>, <xsl:value-of select="repo_version"/>, </xsl:for-each>

          <xsl:for-each select=".//harddisk_details/hard_drive">
						<xsl:value-of select="concat('- ', product_id, ' (Bay ', bay, ')')"/>, <xsl:value-of select="version"/>, <xsl:value-of select="repo_version"/>, </xsl:for-each>
				</xsl:for-each>
				
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>