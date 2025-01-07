<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="treeBladeLeaf">

		<xsl:param name="enclosureNumber" />
		<xsl:param name="monarchBlade" select="0" />
                <xsl:param name="activefwVersion" select="0" />
                <xsl:param name="serviceUserAcl" select="$ADMINISTRATOR" />
		<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
		
		<xsl:element name="div">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="($currentBayNumber &lt;=16 and count($bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=number($currentBayNumber+16) and hpoa:presence='PRESENT']))">display:none;</xsl:when>
					<xsl:when test="hpoa:presence='PRESENT'">display:block;</xsl:when>
					<xsl:otherwise>display:none;</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="class">treeClosed</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'blade', hpoa:bayNumber, 'leafWrapper')"/></xsl:attribute>

			<xsl:call-template name="treeBladeLeafInternal">
				<xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
				<xsl:with-param name="monarchBlade" select="$monarchBlade" />
			</xsl:call-template>
			
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="treeBladeLeafInternal">

		<xsl:param name="enclosureNumber" />
		<xsl:param name="monarchBlade" />

		<div class="treeControl">
			<xsl:element name="div">
				<xsl:attribute name="class">treeDisclosure</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'blade', hpoa:bayNumber, 'treeDisclosure')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="div">

				<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />

				<xsl:attribute name="class">treeStatusIcon</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'bay', $currentBayNumber, 'Status')"/></xsl:attribute>
				
				<xsl:variable name="bladeStatus" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:operationalStatus" />
				<xsl:if test="$bladeStatus != $OP_STATUS_OK">
					<xsl:call-template name="statusIcon">
						<xsl:with-param name="statusCode" select="$bladeStatus" />
					</xsl:call-template>
				</xsl:if>

			</xsl:element>
		</div>
		<xsl:element name="div">
			<xsl:attribute name="class">treeTitle</xsl:attribute>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('enc', $enclosureNumber, 'bay', hpoa:bayNumber, 'Select')"/>
			</xsl:attribute>
			<xsl:element name="a">

				<xsl:attribute name="devId">
					<xsl:value-of select="concat('enc', $enclosureNumber, 'bay', hpoa:bayNumber, 'Select')" />
				</xsl:attribute>
				<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
				<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
				<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

				<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'blade', hpoa:bayNumber, 'Label')"/></xsl:attribute>
				
				<xsl:attribute name="devNum">
					<xsl:value-of select="hpoa:bayNumber" />
				</xsl:attribute>
				<xsl:attribute name="devType">bay</xsl:attribute>
				<xsl:attribute name="encNum">
					<xsl:value-of select="$enclosureNumber" />
				</xsl:attribute>

				<xsl:variable name="symbolicBladeNumber" >
					<xsl:call-template name="deviceBaySymbolicNumber">
						<xsl:with-param name="bladeInfo" select="current()" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>

					<xsl:when test="$monarchBlade=hpoa:bayNumber">
						<xsl:choose>
							<xsl:when test="(hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]') and (hpoa:extraData[@hpoa:name='serverHostName'] != 'Status is not available') and (hpoa:extraData[@hpoa:name='serverHostName'] != '')">
								<xsl:value-of select="concat($symbolicBladeNumber, '. ', 'Monarch - ', hpoa:extraData[@hpoa:name='serverHostName'])" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($symbolicBladeNumber, '. ', 'Monarch')" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$monarchBlade != 0 and $monarchBlade != hpoa:bayNumber">
						<xsl:value-of select="concat($symbolicBladeNumber, '. ', 'Auxiliary')" />
					</xsl:when>
					<xsl:when test="(hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]') and (hpoa:extraData[@hpoa:name='serverHostName'] != 'Status is not available') and (hpoa:extraData[@hpoa:name='serverHostName'] != '')">
						<xsl:value-of select="concat($symbolicBladeNumber, '. ', hpoa:extraData[@hpoa:name='serverHostName'])" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="serialNumber">
							<xsl:choose>
								<xsl:when test="hpoa:serialNumber and hpoa:serialNumber != '' and hpoa:serialNumber != '[Unknown]' and hpoa:serialNumber != 'Status is not available'">
									<xsl:value-of select="concat('-', hpoa:serialNumber)" />
								</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:value-of select="concat($symbolicBladeNumber, '. ', hpoa:name,$serialNumber)" />
					</xsl:otherwise>
				</xsl:choose>
      </xsl:element>
    </xsl:element>

			<div class="treeContents">

				<xsl:element name="div">

					<xsl:if test="(hpoa:bladeType='BLADE_TYPE_STORAGE' or hpoa:bladeType='BLADE_TYPE_IO') and (hpoa:productId != '8213')">
						<xsl:attribute name="style">display:none;</xsl:attribute>
					</xsl:if>

					<xsl:if test="$monarchBlade != 0 and $monarchBlade != hpoa:bayNumber">
						<xsl:attribute name="style">display:none;</xsl:attribute>
					</xsl:if>

					<xsl:attribute name="class">leaf</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'mp', hpoa:bayNumber, 'Select')" />
					</xsl:attribute>

					<xsl:element name="a">

						<xsl:attribute name="devId">
							<xsl:value-of select="concat('enc', $enclosureNumber, 'mp', hpoa:bayNumber, 'Select')" />
						</xsl:attribute>
						<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
						<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
						<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

						<xsl:attribute name="devNum">
							<xsl:value-of select="hpoa:bayNumber" />
						</xsl:attribute>
						<xsl:attribute name="devType">mp</xsl:attribute>
						<xsl:attribute name="encNum">
							<xsl:value-of select="$enclosureNumber" />
						</xsl:attribute>

						<xsl:choose>
							<xsl:when test="hpoa:productId!='8213'">iLO</xsl:when>
							<xsl:otherwise>Management Console</xsl:otherwise>
						</xsl:choose>

					</xsl:element>
				</xsl:element>

				<xsl:element name="div">

					<xsl:if test="(hpoa:bladeType='BLADE_TYPE_STORAGE' or hpoa:bladeType='BLADE_TYPE_IO') and (hpoa:productId != '8213') and not(contains(hpoa:name, 'SB50'))">
						<xsl:attribute name="style">display:none;</xsl:attribute>
					</xsl:if>

					<xsl:attribute name="class">leaf</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'pm_blade', hpoa:bayNumber, 'Select')" />
					</xsl:attribute>

					<xsl:element name="a">

						<xsl:attribute name="devId">
							<xsl:value-of select="concat('enc', $enclosureNumber, 'pm_blade', hpoa:bayNumber, 'Select')" />
						</xsl:attribute>
						<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
						<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
						<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

						<xsl:attribute name="devNum">
							<xsl:value-of select="hpoa:bayNumber" />
						</xsl:attribute>
						<xsl:attribute name="devType">pm_blade</xsl:attribute>
						<xsl:attribute name="encNum">
							<xsl:value-of select="$enclosureNumber" />
						</xsl:attribute>

						<xsl:value-of select="$stringsDoc//value[@key='portMapping']" />

					</xsl:element>
				</xsl:element>

        <xsl:if test="$firmwareMgmtSupported = 'true'">

          <xsl:element name="div">

            <xsl:if test="$serviceUserAcl!=$ADMINISTRATOR or (number($activefwVersion) &lt; number('3.35')) or ((hpoa:bladeType='BLADE_TYPE_STORAGE' or hpoa:bladeType='BLADE_TYPE_IO') and (hpoa:productId != '8213') and not(contains(hpoa:name, 'SB50'))) or (hpoa:productId != '8224')">
              <xsl:attribute name="style">display:none;</xsl:attribute>
            </xsl:if>

            <xsl:attribute name="class">leaf</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'fw_blade', hpoa:bayNumber, 'Select')" />
            </xsl:attribute>

            <xsl:element name="a">

              <xsl:attribute name="devId">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'fw_blade', hpoa:bayNumber, 'Select')" />
              </xsl:attribute>
              <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
              <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
              <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

              <xsl:attribute name="devNum">
                <xsl:value-of select="hpoa:bayNumber" />
              </xsl:attribute>
              <xsl:attribute name="devType">fw_blade</xsl:attribute>
              <xsl:attribute name="encNum">
                <xsl:value-of select="$enclosureNumber" />
              </xsl:attribute>

              <xsl:value-of select="$stringsDoc//value[@key='firmware']" />

            </xsl:element>
          
          </xsl:element>
        </xsl:if>
		
			</div>
  </xsl:template>
	
</xsl:stylesheet>
