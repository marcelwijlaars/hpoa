<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:param name="stringsDoc" />
	<xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="powerConfigInfoDoc" />
	
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	
	<xsl:template match="*">

		<xsl:variable name="subsystemStatus" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:operationalStatus" />
		
		<xsl:variable name="remainingCapacity" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:redundantCapacity" />
		<xsl:variable name="allocated" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:powerConsumed" />
		
		<!-- This is essentially allocated + remaining giving us the total -->
		<xsl:variable name="totalCapacity" select="number($remainingCapacity) + number($allocated)" />
		
		<xsl:variable name="overAllocated" select="$remainingCapacity &lt;= 0" />

		<xsl:variable name="intAllocated" select="round(number($allocated))" />
		<xsl:variable name="intTotalCapacity" select="round(number($totalCapacity))" />

		<xsl:value-of select="$stringsDoc//value[@key='devicePwrUsageDesc1']" /><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='devicePwrUsageDesc2']" /><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='devicePwrUsageNote:']" /><br />

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tbody>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='subSystemStatus']" /></th>
					<td>
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$subsystemStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='powerAllocated']" /></th>
					<td>
						<xsl:value-of select="$allocated" />&#160;
						<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='powerAvailable']" /></th>
					<td>
						<xsl:value-of select="$remainingCapacity" />&#160;
						<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='powerCapacity']" /></th>
					<td>
						<xsl:value-of select="$totalCapacity" />&#160;
						<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC
					</td>
				</tr>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tr class="captionRow">
				<th nowrap="true">
					<xsl:value-of select="$stringsDoc//value[@key='powerAllocated']" />&#160;/&#160;
					<xsl:value-of select="$stringsDoc//value[@key='powerCapacity']" />
				</th>
			</tr>
			<tr>
				<td>
					
					

					<xsl:variable name="allocatedWidth" select="($intAllocated div $intTotalCapacity)*100" />
					
					<xsl:variable name="cssClass">
						<xsl:choose>
              <!--
							<xsl:when test="$subsystemStatus=$OP_STATUS_DEGRADED">percentageBar percentageBarWarning</xsl:when>
							<xsl:when test="$subsystemStatus=$OP_STATUS_NON_RECOVERABLE_ERROR">percentageBar percentageBarCritical</xsl:when>
              -->
              <xsl:when test="$overAllocated">percentageBar percentageBarWarning</xsl:when>
              <xsl:otherwise>percentageBar</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<div class="percentageOutline">

						<xsl:element name="div">
							<xsl:attribute name="class"><xsl:value-of select="$cssClass" /></xsl:attribute>
							<xsl:attribute name="devID">PS1</xsl:attribute>
							<xsl:attribute name="style">
								<xsl:choose>
									<xsl:when test="$overAllocated">width:100%;</xsl:when>
									<xsl:otherwise>width:<xsl:value-of select="$allocatedWidth"/>%;</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:value-of select="$intAllocated"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC
						</xsl:element>

					</div>

					<div class="limitIndicatorOutline">
						<div class="limitIndicatorNormal" style="width:100%">
							<xsl:value-of select="$intTotalCapacity"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC&#160;
						</div>
					</div>
          
				</td>
			</tr>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnApplyDateTime" onclick="refreshPage();">
								<xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>
