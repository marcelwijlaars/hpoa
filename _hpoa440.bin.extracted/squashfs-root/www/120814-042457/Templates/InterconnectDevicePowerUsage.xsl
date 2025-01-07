<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="interconnectDevicePowerUsage">
				
		<table width="100%" class="captionTable" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="50%" align="left">Interconnect Device Power Usage</td>
				<td width="50%" align="right"><!--<a href="javascript:void(0);"><img align="right" onclick="toggleTableVisible('bladePowerUsageWrapper', this);" border="0" src="/120814-042457/images/win_expand.gif" title="Shrink/Expand" /></a>--></td>
			</tr>
		</table>
		<div id="bladePowerUsageWrapper">
			<table border="0" cellpadding="0" cellspacing="0" class="dataTable">
				<thead>
					<tr class="captionRow">
						<th>Bay Number</th>
						<th>Device Status</th>
						<th>Thermal Status</th>
						<th style="text-align:right">Power Usage (Watts)</th>
					</tr>
				</thead>
				<tbody>
					
					<xsl:for-each select="$interconnectTrayStatusDoc//hpoa:interconnectTrayStatus">

						<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
						
						<xsl:if test="hpoa:presence=$PRESENT">

							<xsl:element name="tr">

								<xsl:attribute name="class">
									<xsl:if test="position() mod 2 = 0">
										altRowColor
									</xsl:if>
								</xsl:attribute>

								<td width="20%">

									<xsl:choose>
										<xsl:when test="hpoa:presence=$PRESENT">
											<xsl:element name="a">
												<xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="hpoa:bayNumber" />, INTERCONNECT());</xsl:attribute>
												<xsl:value-of select="hpoa:bayNumber" />
											</xsl:element>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="hpoa:bayNumber" />
										</xsl:otherwise>
									</xsl:choose>

								</td>

								<td width="40%">

									<xsl:call-template name="getStatusLabel">
										<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
									</xsl:call-template>

								</td>

								<td width="20%" align="right">

									<xsl:value-of select="$interconnectTrayThermalDoc//hpoa:thermalInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:temperatureC"/>
									
								</td>

								<td width="20%" align="right" celltype="powerMeasurement">
									<!-- TODO: Hook up for interconnects when we have the data. -->
									<xsl:value-of select="hpoa:powerConsumed"/>
									<xsl:element name="div">
										<xsl:attribute name="style">display:none;</xsl:attribute>
										<xsl:attribute name="type">interconnect</xsl:attribute>
										<xsl:value-of select="hpoa:powerConsumed"/>
									</xsl:element>
								</td>

							</xsl:element>

						</xsl:if>

					</xsl:for-each>

				</tbody>
			</table>
		</div>
		<table width="100%" border="0" class="dataTable" cellpadding="0" cellspacing="0">
			<tr class="summaryRow">
				<td>
					Total:&#160;<span id="interconnectPowerConsumed"></span>
				</td>
			</tr>
		</table>
		
	</xsl:template>
	
</xsl:stylesheet>
