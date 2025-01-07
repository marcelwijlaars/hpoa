<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
		xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->

	<xsl:template name="firmwareStatusTable">

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" ID="Table7">
			<tbody>

				<tr class="captionRow">
					<th><xsl:value-of select="$stringsDoc//value[@key='bay']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='role']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='firmwareStatus']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='firmwareVersion']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='hardwareVersion']" /></th>
				</tr>

				<xsl:for-each select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole!='OA_ABSENT']">

					<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />

					<tr class="altRowColor">
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='oaBay']" />&#160;<xsl:value-of select="$currentBayNumber"/>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="hpoa:oaRole='ACTIVE'"><xsl:value-of select="$stringsDoc//value[@key='active']" /></xsl:when>
								<xsl:when test="hpoa:oaRole='STANDBY'"><xsl:value-of select="$stringsDoc//value[@key='standby']" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></xsl:otherwise>
							</xsl:choose>
						</td>
						<td>
							<xsl:element name="div">

								<xsl:attribute name="id">
									<xsl:choose>
										<xsl:when test="hpoa:oaRole='ACTIVE'">
											<xsl:value-of select="'fwStatusActive'"/>
										</xsl:when>
										<xsl:when test="hpoa:oaRole='STANDBY'">
											<xsl:value-of select="'fwStatusStandby'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:attribute>

								<xsl:call-template name="statusIcon">
									<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
								</xsl:call-template>&#160;<xsl:choose>
									<xsl:when test="hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='firmwareMismatch']='ERROR'">
									<xsl:value-of select="$stringsDoc//value[@key='firmwareMismatch']" /></xsl:when>
									<xsl:otherwise>OK</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</td>
						<td>

							<xsl:element name="div">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('versionContainer', $currentBayNumber)"/>
								</xsl:attribute>

								<xsl:choose>
									<xsl:when test="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:fwVersion != ''">
										<xsl:value-of select="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:fwVersion"/>
                                                                                <xsl:if test="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='Build'] != ''">
                                                                                        <span class="whiteSpacer">&#160;</span>
                                                                                        <xsl:value-of select="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='Build']"/>
                                                                                </xsl:if>
									</xsl:when>
									<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></xsl:otherwise>
								</xsl:choose>

							</xsl:element>

						</td>
						<td>

							<xsl:element name="div">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('hwVersionContainer', $currentBayNumber)"/>
								</xsl:attribute>
								
								<xsl:value-of select="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:hwVersion"/>

							</xsl:element>
							
						</td>
					</tr>
				</xsl:for-each>

			</tbody>
		</table>
		
	</xsl:template>
	
</xsl:stylesheet>
