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

	<xsl:param name="fanInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="encType" />

	<xsl:template match="*">

		<xsl:variable name="fanStatus" select="$fanInfoDoc//hpoa:fanInfo/hpoa:operationalStatus" />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tbody>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='status']" /></th>
					<td class="propertyValue">
						<xsl:choose>
							<xsl:when test="$fanInfoDoc//hpoa:fanInfo/hpoa:presence=$ABSENT and $fanStatus='OP_STATUS_UNKNOWN'">
								<xsl:value-of select="$stringsDoc//value[@key='emptyFanBay']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="getStatusLabel">
									<xsl:with-param name="statusCode" select="$fanStatus" />
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:if test="$fanInfoDoc//hpoa:fanInfo/hpoa:presence!=$ABSENT">
					<tr class="">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='name']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="$fanInfoDoc//hpoa:fanInfo/hpoa:name" />
						</td>
					</tr>
					<tr class="altRowColor">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='presentPwr']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="$fanInfoDoc//hpoa:fanInfo/hpoa:powerConsumed" />&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />
						</td>
					</tr>
					<tr class="">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='partNumber']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="$fanInfoDoc//hpoa:fanInfo/hpoa:partNumber" />
						</td>
					</tr>
				  <tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='sparePartNumber']" /></th>
					<td class="propertyValue">
					  <xsl:value-of select="$fanInfoDoc//hpoa:fanInfo/hpoa:sparePartNumber" />
					</td>
				  </tr>
				  <tr class="">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='serialNumber']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="$fanInfoDoc//hpoa:fanInfo/hpoa:serialNumber" />
						</td>
					</tr>
				</xsl:if>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo">

			<xsl:if test="count(hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED')])&gt;0 and count(hpoa:diagnosticChecks/*[not(node()='NOT_RELEVANT')])&gt;0">
				<xsl:call-template name="diagnosticStatusView">
					<xsl:with-param name="statusCode" select="$fanStatus" />
					<xsl:with-param name="deviceType" select="'FAN'" />
					<xsl:with-param name="encType" select="$encType" />
				</xsl:call-template>

				<span class="whiteSpacer">&#160;</span>
				<br />

			</xsl:if>

		</xsl:for-each>

		<xsl:if test="$fanInfoDoc//hpoa:fanInfo/hpoa:presence!=$ABSENT">

			<span class="whiteSpacer">&#160;</span>
			<br />

			<table border="0" cellpadding="0" cellspacing="0" class="dataTable">
				<tr class="captionRow">
					<!--<th width="10%">Status</th>-->
					<th width="60%" nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='fanSpeedOfMax']" /></th>
				</tr>
				<tr>
					<td width="60%">
						<div class="percentageOutline">

							<xsl:variable name="fanSpeed" select="$fanInfoDoc//hpoa:fanInfo/hpoa:fanSpeed" />
							<xsl:variable name="maxFanSpeed" select="$fanInfoDoc//hpoa:fanInfo/hpoa:maxFanSpeed" />

							<xsl:variable name="speedDisplayWidth" select="round((number($fanSpeed) div number($maxFanSpeed))*100)" />

							<xsl:element name="div">

								<xsl:attribute name="class">percentageBar</xsl:attribute>
								<xsl:attribute name="style">
									width:<xsl:value-of select="$speedDisplayWidth"/>%;color:#000000;
								</xsl:attribute>
								<xsl:value-of select="$speedDisplayWidth"/>%
							</xsl:element>

						</div>
					</td>
				</tr>

			</table>
		</xsl:if>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' onclick="refreshFanInfo();">
								<xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>


	</xsl:template>

</xsl:stylesheet>

