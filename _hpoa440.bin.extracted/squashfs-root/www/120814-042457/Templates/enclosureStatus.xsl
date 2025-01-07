<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
    <xsl:include href="../Templates/guiConstants.xsl" />
    <xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:param name="stringsDoc" />
	<xsl:param name="encNum" />
	
    <xsl:param name="systemStatusDoc" />
	
	<xsl:param name="enclosureInfoDoc" />
	<xsl:param name="enclosureStatusDoc" />
	
	<xsl:param name="oaStatusDoc" />
	<xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="thermalSubsystemInfoDoc" />
	
	<xsl:template match="*">

		<xsl:variable name="enclosureStatus" select="$enclosureStatusDoc//hpoa:enclosureStatus/hpoa:operationalStatus" />

		<xsl:variable name="isDC">
			<xsl:choose>
				<xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:subsystemType='EXTERNAL_DC'">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
    
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" ID="Table7">
			<tbody>
				<tr class="altRowColor">
					<th class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='enclosureStatus']" /> 
					</th>
					<td class="propertyValue">
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$enclosureStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='activeEMStatus']" />
					</th>
					<td class="propertyValue">
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$ACTIVE]/hpoa:operationalStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='standbyEMStatus']" />
					</th>
					<td class="propertyValue">
						
						<xsl:choose>
							<xsl:when test="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$STANDBY]/hpoa:operationalStatus!=$OA_ABSENT">
								<xsl:call-template name="getStatusLabel">
									<xsl:with-param name="statusCode" select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$STANDBY]/hpoa:operationalStatus" />
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
				</tr>
				<tr>
					<th class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='statusPowerMode']" />
					</th>
					<td class="propertyValue">
						<xsl:call-template name="getRedundancyLabel">
							<xsl:with-param name="redundancyMode" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:redundancyMode" />
							<xsl:with-param name="isDC" select="$isDC" />
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:for-each select="$enclosureStatusDoc//hpoa:enclosureStatus">

			<xsl:if test="count(hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED')])&gt;0 and count(hpoa:diagnosticChecks/*[not(node()='NOT_RELEVANT')])&gt;0">
				<xsl:call-template name="diagnosticStatusView">
					<xsl:with-param name="statusCode" select="$enclosureStatus" />
				</xsl:call-template>

				<span class="whiteSpacer">&#160;</span>
				<br />
				<span class="whiteSpacer">&#160;</span>
				<br />

			</xsl:if>

		</xsl:for-each>
		
<!--		Enclosure Status Overview -->
		<xsl:value-of select="$stringsDoc//value[@key='encStatusOverview']" />
		<br />
		
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table border="0" cellpadding="0" cellspacing="0" class="treeTable">
			<thead>
				<tr class="captionRow">
					<th>
<!--					Subsystems and Devices -->
					<xsl:value-of select="$stringsDoc//value[@key='subSysAndDevices']" />
					</th>
					<th>
					<xsl:value-of select="$stringsDoc//value[@key='status']" />
					</th>
				</tr>
			</thead>
			<tbody>

				<!-- Number of bad device variables for each of the device categories. -->
				<xsl:variable name="badBladeCount" select="count($systemStatusDoc/systemStatusData/deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='bay'])" />
				<xsl:variable name="badInterconnectCount" select="count($systemStatusDoc/systemStatusData/deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='interconnect'])" />
				<xsl:variable name="badPowerSupplyCount" select="(count($systemStatusDoc/systemStatusData/deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='ps' and deviceNumber!=0])&gt;0)" />
				<xsl:variable name="badFanCount" select="count($systemStatusDoc/systemStatusData/deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='fan'])" />
				
				<!-- Device Bay Overview -->
				<tr class="treeTableTopLevel">
					<td>
						<b>
							<a href="javascript:top.mainPage.getHiddenFrame().selectDevice(0, 'bay', {$encNum}, true);">
								<xsl:value-of select="$stringsDoc//value[@key='serverBayOverview']" />
							</a>
						</b>
					</td>
					<td>

						<xsl:choose>
							<xsl:when test="$badBladeCount &lt;= 0">
								<xsl:call-template name="getStatusLabel">
									<xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								&#160;
							</xsl:otherwise>
						</xsl:choose>

					</td>
				</tr>

				<xsl:if test="$badBladeCount &gt; 0">

					<xsl:for-each select="$systemStatusDoc//deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='bay']">
					<xsl:sort select="deviceSymbolicNumber" />
 						<tr>
							<td class="nested1">
								<a href="javascript:top.mainPage.getHiddenFrame().selectDevice({deviceNumber}, 'bay', {$encNum}, true);">
									<xsl:value-of select="deviceLabel" />&#160;<xsl:value-of select="deviceSymbolicNumber" />
								</a>
							</td>

							<td>
								<xsl:call-template name="getStatusLabel">
									<xsl:with-param name="statusCode" select="severity" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:if>

				<!-- Interconnect Bay Overview -->
				<tr class="treeTableTopLevel">
					<td>
						<b>
							<a href="javascript:top.mainPage.getHiddenFrame().selectDevice(0, 'interconnect', {$encNum}, true);">
								<xsl:value-of select="$stringsDoc//value[@key='interconnectBayOverview']" />
							</a>
						</b>
					</td>
					<td>

						<xsl:choose>
							<xsl:when test="$badInterconnectCount &lt;= 0">
								<xsl:call-template name="getStatusLabel">
									<xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								&#160;
							</xsl:otherwise>
						</xsl:choose>

					</td>
				</tr>

				<xsl:if test="$badInterconnectCount &gt; 0">

					<xsl:for-each select="$systemStatusDoc//deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='interconnect']">
						<tr>
							<td class="nested1">
								<a href="javascript:top.mainPage.getHiddenFrame().selectDevice({deviceNumber}, 'interconnect', {$encNum}, true);">
									<xsl:value-of select="deviceLabel" />&#160;<xsl:value-of select="deviceNumber"/>
								</a>
							</td>

							<td>
								<xsl:call-template name="getStatusLabel">
									<xsl:with-param name="statusCode" select="severity" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:if>

				<!-- Power Supply Overview -->
				<tr class="treeTableTopLevel">
					<td>
						<b>
							<a href="javascript:top.mainPage.getHiddenFrame().selectDevice(0, 'ps', {$encNum}, true);">
								<xsl:value-of select="$stringsDoc//value[@key='powerSubsystem']" />
							</a>
						</b>
					</td>
					<td>

						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:operationalStatus" />
						</xsl:call-template>

					</td>
				</tr>

				<xsl:if test="$badPowerSupplyCount &gt; 0">

					<xsl:for-each select="$systemStatusDoc//deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='ps']">

						<xsl:if test="deviceNumber!=0">
							<tr>
								<td class="nested1">
									<a href="javascript:top.mainPage.getHiddenFrame().selectDevice({deviceNumber}, 'ps', {$encNum}, true);">
										<xsl:value-of select="deviceName" />
									</a>
								</td>

								<td>
									<xsl:call-template name="getStatusLabel">
										<xsl:with-param name="statusCode" select="severity" />
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>

				</xsl:if>

				<!-- Fan Overview -->
				<tr class="treeTableTopLevel">
					<td>
						<b>
							<a href="javascript:top.mainPage.getHiddenFrame().selectDevice(0, 'fan', {$encNum}, true);">
								<xsl:value-of select="$stringsDoc//value[@key='thermalSubsystem']" />
							</a>
						</b>
					</td>
					<td>

						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:operationalStatus" />
						</xsl:call-template>

					</td>
				</tr>

				<xsl:if test="$badFanCount &gt; 0">

					<xsl:for-each select="$systemStatusDoc//deviceStatusDetail/enclosure[@enclosureNumber=$encNum]/device[deviceType='fan' and deviceNumber &gt; 0]">
						<tr>
							<td class="nested1">
								<a href="javascript:top.mainPage.getHiddenFrame().selectDevice({deviceNumber}, 'fan', {$encNum}, true);">
									<xsl:value-of select="deviceName" /> - Bay <xsl:value-of select="deviceNumber"/>
								</a>
							</td>

							<td>
								<xsl:call-template name="getStatusLabel">
									<xsl:with-param name="statusCode" select="severity" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:if>

			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		
	</xsl:template>
	
</xsl:stylesheet>
