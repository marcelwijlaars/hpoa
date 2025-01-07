<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
    <xsl:output method="xml" />

    <xsl:include href="../Templates/guiConstants.xsl" />
    <xsl:include href="../Templates/globalTemplates.xsl" />

	<!--
		XML document Parameter containing status information about each
		of the devices in the enclosure.
	-->
	<xsl:param name="stringsDoc" />
    <xsl:param name="compiledSystemStatusDoc" />
	
    <xsl:template name="systemStatusData" match="*">
		
        <!-- System Status Data document root -->
        <systemStatusData>
			
            <!-- Section storing detailed information about each problematic device -->
            <deviceStatusDetail>

				<xsl:for-each select="$compiledSystemStatusDoc//enclosure">

					<xsl:variable name="currentEncNum" select="@enclosureNumber" />
					<xsl:variable name="currentEncName" select="@enclosureName" />
          <xsl:variable name="currentFwVersion" select="number(@activeFwVersion)" />
					<xsl:variable name="encNode" select="." />

					<xsl:element name="enclosure">
						<xsl:attribute name="enclosureNumber"><xsl:value-of select="$currentEncNum"/></xsl:attribute>
						<xsl:attribute name="enclosureName"><xsl:value-of select="$currentEncName"/></xsl:attribute>
            <xsl:attribute name="activeFwVersion"><xsl:value-of select="$currentFwVersion"/></xsl:attribute>

						<!--
							If there are any problematic blades, add them to the device list.
						-->
						<xsl:for-each select="current()//hpoa:bladeStatus">

							<!-- Add the device to the list if it has a problematic status code -->
							<xsl:if test="hpoa:operationalStatus!=$OP_STATUS_OK and hpoa:presence=$PRESENT">

								<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
								<xsl:variable name="productName" select="$compiledSystemStatusDoc//enclosure[@enclosureNumber=$currentEncNum]//hpoa:bladeInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:name" />
								<xsl:variable name="serverName" select="$compiledSystemStatusDoc//enclosure[@enclosureNumber=$currentEncNum]//hpoa:bladeInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='serverHostName']" />
								<xsl:variable name="deviceName">
									<xsl:choose>
										<xsl:when test="($serverName != '[Unknown]') and ($serverName != 'Status is not available') and ($serverName != '')">
											<xsl:value-of select="$serverName"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$productName"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:call-template name="deviceDetailObject">
									<xsl:with-param name="deviceType" select="'bay'" />
									<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='blade']" />
									<xsl:with-param name="deviceName" select="$deviceName" />
									<xsl:with-param name="deviceNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="deviceSymbolicNumber" select="//hpoa:bladeInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
									<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
									<xsl:with-param name="enclosureName" select="$currentEncName" />
									<xsl:with-param name="severity" select="hpoa:operationalStatus" />
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>

						<!--
							If there are any problematic power supplies, add them to the list.
						-->
						<xsl:for-each select="current()//hpoa:powerSupplyStatus">
							<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
							<xsl:if test="hpoa:operationalStatus!=$OP_STATUS_OK and $encNode//hpoa:powerSupplyInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:presence=$PRESENT">
								<xsl:call-template name="deviceDetailObject">
									<xsl:with-param name="deviceType" select="'ps'" />
									<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='powerSupply']" />
									<xsl:with-param name="deviceName" select="concat($stringsDoc//value[@key='powerSupply'], ' ', hpoa:bayNumber)" />
									<xsl:with-param name="deviceNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="deviceSymbolicNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
									<xsl:with-param name="enclosureName" select="$currentEncName" />
									<xsl:with-param name="severity" select="hpoa:operationalStatus" />                  
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>

						<!--
							If there are any problematic interconnect trays, add them to the list.
						-->
						<xsl:for-each select="current()//hpoa:interconnectTrayStatus">
							<xsl:if test="hpoa:operationalStatus!=$OP_STATUS_OK and hpoa:presence=$PRESENT">
								<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
								<xsl:call-template name="deviceDetailObject">
									<xsl:with-param name="deviceType" select="'interconnect'" />
									<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='interconnectBay']" />
									<xsl:with-param name="deviceName" select="$compiledSystemStatusDoc//enclosure[@enclosureNumber=$currentEncNum]//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:name" />
									<xsl:with-param name="deviceNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="deviceSymbolicNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
									<xsl:with-param name="enclosureName" select="$currentEncName" />
									<xsl:with-param name="severity" select="hpoa:operationalStatus" />
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>

						<!--
							If there are any problematic fans, add them to the list.
						-->
						<xsl:for-each select="current()//hpoa:fanInfo">
							<xsl:if test="hpoa:operationalStatus!=$OP_STATUS_OK and hpoa:presence=$PRESENT">
								<xsl:call-template name="deviceDetailObject">
									<xsl:with-param name="deviceType" select="'fan'" />
									<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='fan']" />
									<xsl:with-param name="deviceName" select="hpoa:name" />
									<xsl:with-param name="deviceNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="deviceSymbolicNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
									<xsl:with-param name="enclosureName" select="$currentEncName" />
									<xsl:with-param name="severity" select="hpoa:operationalStatus" />
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>

						<!--
							If there are any problems with the overall power subsystem, add them here.
						-->
						<xsl:for-each select="current()//hpoa:powerSubsystemInfo">
							<xsl:if test="hpoa:operationalStatus!=$OP_STATUS_OK">
								<xsl:call-template name="deviceDetailObject">
									<xsl:with-param name="deviceType" select="'ps'" />
									<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='powerSubsystem']" />
									<xsl:with-param name="deviceName" select="''" />
									<xsl:with-param name="deviceNumber" select="0" />
									<xsl:with-param name="deviceSymbolicNumber" select="0" />
									<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
									<xsl:with-param name="enclosureName" select="$currentEncName" />
									<xsl:with-param name="severity" select="hpoa:operationalStatus" />
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>

						<xsl:for-each select="current()//hpoa:thermalSubsystemInfo">
							<xsl:if test="hpoa:operationalStatus!=$OP_STATUS_OK">
								<xsl:call-template name="deviceDetailObject">
									<xsl:with-param name="deviceType" select="'fan'" />
									<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='thermalSubsystem']" />
									<xsl:with-param name="deviceName" select="''" />
									<xsl:with-param name="deviceNumber" select="0" />
									<xsl:with-param name="deviceSymbolicNumber" select="0" />
									<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
									<xsl:with-param name="enclosureName" select="$currentEncName" />
									<xsl:with-param name="severity" select="hpoa:operationalStatus" />
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>

						<!--
							If there are any problems with the overall power subsystem, add them here.
						-->
						<xsl:for-each select="current()//hpoa:oaStatus">
							<xsl:if test="hpoa:oaRole!=$OA_ABSENT and hpoa:operationalStatus!=$OP_STATUS_OK">
								<xsl:call-template name="deviceDetailObject">
									<xsl:with-param name="deviceType" select="'em'" />
									<xsl:with-param name="deviceLabel" select="'Onboard Administrator'" />
									<xsl:with-param name="deviceName" select="'Onboard Administrator'" />
									<xsl:with-param name="deviceNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="deviceSymbolicNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
									<xsl:with-param name="enclosureName" select="$currentEncName" />
									<xsl:with-param name="severity" select="hpoa:operationalStatus" />
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
						
						<xsl:if test="current()//hpoa:enclosureStatus/hpoa:operationalStatus != $OP_STATUS_OK">
							<xsl:call-template name="deviceDetailObject">
								<xsl:with-param name="deviceType" select="'enc'" />
								<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='enclosure']" />
								<xsl:with-param name="deviceName" select="$currentEncName" />
								<xsl:with-param name="deviceNumber" select="0" />
								<xsl:with-param name="deviceSymbolicNumber" select="0" />
								<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
								<xsl:with-param name="enclosureName" select="$currentEncName" />
								<xsl:with-param name="severity" select="current()//hpoa:enclosureStatus/hpoa:operationalStatus" />
							</xsl:call-template>
						</xsl:if>
            
            <!-- add remote support status if errors exist -->
            <xsl:if test="$currentFwVersion &gt;= 3.50">
              <xsl:if test="current()//hpoa:ersConfigInfo//hpoa:ersEnabled = 'true' and (current()//hpoa:ersConfigInfo//hpoa:ersLastInventoryErrorStr != '' or current()//hpoa:ersConfigInfo//hpoa:ersLastTestAlertErrorStr != '')">
                <xsl:call-template name="deviceDetailObject">
								<xsl:with-param name="deviceType" select="'ers'" />
								<xsl:with-param name="deviceLabel" select="$stringsDoc//value[@key='supportService']" />
								<xsl:with-param name="deviceName" select="$stringsDoc//value[@key='remoteSupport']" />
								<xsl:with-param name="deviceNumber" select="0" />
								<xsl:with-param name="deviceSymbolicNumber" select="0" />
								<xsl:with-param name="enclosureNumber" select="$currentEncNum" />
								<xsl:with-param name="enclosureName" select="$currentEncName" />
								<xsl:with-param name="severity" select="$OP_STATUS_DEGRADED" />
							</xsl:call-template>
              </xsl:if>
            </xsl:if>
						
					</xsl:element>
					
				</xsl:for-each>
				<!-- End for-each enclosure -->
				
            </deviceStatusDetail>
            
        </systemStatusData>
        
	</xsl:template>

    <xsl:template name="deviceDetailObject">

        <xsl:param name="deviceType" />
        <xsl:param name="deviceLabel" />
        <xsl:param name="deviceName" />
        <xsl:param name="deviceNumber" />
        <xsl:param name="deviceSymbolicNumber" />
		    <xsl:param name="enclosureNumber" />
		    <xsl:param name="enclosureName" />
        <xsl:param name="severity" />
        
        <device>
          <deviceType>
            <xsl:value-of select="$deviceType" />
          </deviceType>
          <deviceLabel>
            <xsl:value-of select="$deviceLabel" />
          </deviceLabel>
          <deviceName>
            <xsl:choose>
              <xsl:when test="$deviceName != ''">
	              <xsl:value-of select="$deviceName" />
              </xsl:when>
              <xsl:otherwise>
	              <xsl:value-of select="$deviceLabel" />
              </xsl:otherwise>
            </xsl:choose>
          </deviceName>
          <deviceNumber>
            <xsl:value-of select="$deviceNumber" />
          </deviceNumber>
          <deviceSymbolicNumber>
            <xsl:value-of select="$deviceSymbolicNumber" />
          </deviceSymbolicNumber>
          <enclosureNumber>
            <xsl:value-of select="$enclosureNumber" />
          </enclosureNumber>
          <enclosureName>
            <xsl:value-of select="$enclosureName" />
          </enclosureName>
          <severity>
            <xsl:value-of select="$severity" />
          </severity>
          <severityLabel>            
            <xsl:variable name="statusContent">
              <xsl:call-template name="getStatusLabel">
                <xsl:with-param name="statusCode" select="$severity" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="normalize-space(substring-after($statusContent, '&#160;'))"  />
          </severityLabel>
        </device>
        
    </xsl:template>
  

</xsl:stylesheet>
