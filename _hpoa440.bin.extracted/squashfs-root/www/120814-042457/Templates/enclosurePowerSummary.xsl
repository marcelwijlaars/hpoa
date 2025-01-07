<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
    <xsl:include href="../Templates/guiConstants.xsl" />
    <xsl:include href="../Templates/globalTemplates.xsl" />

    <!-- Document fragment parameters containing blade status and information -->
	<xsl:param name="stringsDoc" />
	<xsl:param name="powerSummaryDoc" />
	<xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="enclosureBladePowerSummaryDoc" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="interconnectInfoDoc" />
	<xsl:param name="encNum" />

	<xsl:template match="*">

		<xsl:value-of select="$stringsDoc//value[@key='encPowerSummary']"/>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" style="width:100%">
			<tr>
				<td style="width:50%; vertical-align:top;">
					<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
						<caption>
							<xsl:value-of select="$stringsDoc//value[@key='encInputPwrSummary']"/>
						</caption>
						<thead>
							<tr class="captionRow">
								<th>
									<xsl:value-of select="$stringsDoc//value[@key='enclosure']"/>
								</th>
								<th style="text-align:right;">
									<xsl:choose>
										<xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:subsystemType='EXTERNAL_DC'"><xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC</xsl:when>
										<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='watts']"/> AC</xsl:otherwise>
									</xsl:choose>
								</th>
							</tr>
						</thead>
						<xsl:for-each select="$powerSummaryDoc//hpoa:enclosurePowerSummary/hpoa:enclosureInputSummary">
							<tbody>
								<tr>
									<td>
										<xsl:value-of select="$stringsDoc//value[@key='presentPwr']"/>
									</td>
									<td style="text-align:right;">
										<xsl:value-of select="hpoa:presentPower"/>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="$stringsDoc//value[@key='maxInputPwr']"/></td>
									<td style="text-align:right;">
										<xsl:choose>
											<xsl:when test="hpoa:maxPower=0">
												<xsl:value-of select="$stringsDoc//value[@key='notAvailable']"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="hpoa:maxPower"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="$stringsDoc//value[@key='pwrCapLabel']"/></td>
									<td style="text-align:right;">
										<xsl:choose>
											<xsl:when test="hpoa:powerCap=0">
												<xsl:value-of select="$stringsDoc//value[@key='notSet']"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="hpoa:powerCap"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="$stringsDoc//value[@key='pwrLimit']"/>
									</td>
									<td style="text-align:right;">
										<xsl:choose>
											<xsl:when test="hpoa:powerLimit=0">
												<xsl:value-of select="$stringsDoc//value[@key='notSet']"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="hpoa:powerLimit"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</tbody>
						</xsl:for-each>
					</table>
				</td>
				<td>
					<img src="/120814-042457/images/one_white.gif" width="20" height="20" />
				</td>
				<td style="width:50%; vertical-align:top;">
					<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
						<caption>
							<xsl:value-of select="$stringsDoc//value[@key='encOutputPwrSummary']"/>
						</caption>
						<thead>
							<tr class="captionRow">
								<th>
									<xsl:value-of select="$stringsDoc//value[@key='enclosure']"/>
								</th>
								<th style="text-align:right;">
									<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC</th>
							</tr>
						</thead>
						<xsl:for-each select="$powerSummaryDoc//hpoa:enclosurePowerSummary/hpoa:enclosureOutputSummary">
							<tbody>
								<tr>
									<td>
										<xsl:value-of select="$stringsDoc//value[@key='powerCapacity']"/></td>
									<td style="text-align:right;">
										<xsl:value-of select="hpoa:powerCapacity"/>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="$stringsDoc//value[@key='powerAllocated']"/>
									</td>
									<td style="text-align:right;">
										<xsl:value-of select="hpoa:allocatedPower"/>
									</td>
								</tr>
								<tr>
									<td><xsl:value-of select="$stringsDoc//value[@key='powerAvailable']"/></td>
									<td style="text-align:right;">
										<xsl:value-of select="hpoa:availablePower"/>
									</td>
								</tr>
							</tbody>
						</xsl:for-each>
					</table>
				</td>
			</tr>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='encBayPwrAllocation']"/></caption>
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='bay']"/>
					</th>
					<th style="text-align:right;">
						<xsl:value-of select="$stringsDoc//value[@key='powerAllocated']"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)</th>
				</tr>
			</thead>
			<xsl:for-each select="$powerSummaryDoc//hpoa:enclosurePowerSummary/hpoa:enclosureBayOutputSummary">
				<tbody>
					<tr>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='serverBays']"/>
						</td>
						<td style="text-align: right;">
							<xsl:value-of select="hpoa:devicePower"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='interconnectBays']"/>
						</td>
						<td style="text-align: right;">
							<xsl:value-of select="hpoa:interconnectPower"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='fans']"/>
						</td>
						<td style="text-align: right;">
							<xsl:value-of select="hpoa:fanPower"/>
						</td>
					</tr>
					<tr class="summaryRow">
						<td>&#160;</td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='total']"/>:&#160;<xsl:value-of select="hpoa:powerAllocated"/>
						</td>
					</tr>

				</tbody>
			</xsl:for-each>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:variable name="displayCapping" select="number($powerSummaryDoc//hpoa:enclosurePowerSummary/hpoa:enclosureInputSummary/hpoa:powerCap) != 0" />
		<xsl:variable name="displayMSAC">
			<xsl:choose>
				<xsl:when test="$enclosureBladePowerSummaryDoc//hpoa:enclosureBladePowerSummary/hpoa:minPowerCap != 'NaN'">
					<xsl:value-of select="1" />
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="0" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='deviceBayPwrSummary']"/></caption>
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='bay']"/>
					</th>
					<th><xsl:value-of select="$stringsDoc//value[@key='name']"/>
					</th>
					<xsl:if test="$displayCapping">
						<th style="text-align:right;"><xsl:value-of select="$stringsDoc//value[@key='powerCap']"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)</th>
						<th style="text-align:right;">% <xsl:value-of select="$stringsDoc//value[@key='powerCap']"/>&#160;</th>
						<th style="text-align:right;"><xsl:value-of select="$stringsDoc//value[@key='presentPwr']"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)</th>
						<xsl:if test="$displayMSAC != 0">
							<th style="text-align:right;"><xsl:value-of select="$stringsDoc//value[@key='minimumCap']"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)</th>
						</xsl:if>
					</xsl:if>
					<th style="text-align:right;">
						<xsl:value-of select="$stringsDoc//value[@key='powerAllocated']"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)
					</th>
				</tr>
			</thead>
			<xsl:for-each select="$powerSummaryDoc//hpoa:enclosurePowerSummary/hpoa:enclosureBladePowerSummary">
				<tbody>
					<xsl:for-each select="hpoa:bladePowerSummary">
						<xsl:variable name="bayNumber" select="hpoa:bayNumber"/>
						<tr>
							<td>
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$bayNumber" />, "bay", <xsl:value-of select="$encNum" />, true);</xsl:attribute>
									<xsl:value-of select="hpoa:symbolicBladeNumber"/>
								</xsl:element>
							</td>
							<td>
								<xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]">
									<xsl:choose>
										<xsl:when test="(hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]') and (hpoa:extraData[@hpoa:name='serverHostName'] != 'Status is not available') and (hpoa:extraData[@hpoa:name='serverHostName'] != '')">
											<xsl:value-of select="hpoa:extraData[@hpoa:name='serverHostName']" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="hpoa:name"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>

							</td>
							<xsl:if test="$displayCapping">
								<td style="text-align:right;">
									<xsl:choose>
										<xsl:when test="hpoa:powerCap=0">
											<xsl:value-of select="$stringsDoc//value[@key='n/a']"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="hpoa:powerCap"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td style="text-align:right;">
									<xsl:choose>
										<xsl:when test="hpoa:powerCap=0">
											<xsl:value-of select="$stringsDoc//value[@key='n/a']"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="hpoa:presentPowerPercentPowerCap"/>%
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td style="text-align:right;">
									<xsl:choose>
										<xsl:when test="hpoa:powerCap=0">
											<xsl:value-of select="$stringsDoc//value[@key='n/a']"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="hpoa:presentPower"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<xsl:if test="$displayMSAC != 0">
									<td style="text-align:right;">
										<xsl:choose>
											<xsl:when test="hpoa:powerCap=0">
												<xsl:value-of select="$stringsDoc//value[@key='n/a']"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:for-each select="$enclosureBladePowerSummaryDoc//hpoa:enclosureBladePowerSummary/hpoa:bladePowerSummary[hpoa:bayNumber=$bayNumber]">
													<xsl:value-of select="hpoa:minPowerCap"/>
												</xsl:for-each>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
							</xsl:if>
							<td style="text-align:right;">
								<xsl:value-of select="hpoa:powerAllocated"/>
							</td>
						</tr>
					</xsl:for-each>
					<tr class="summaryRow">
						<td>&#160;</td>
						<td>&#160;</td>
						<xsl:if test="$displayCapping">
							<td>&#160;</td>
							<td>&#160;</td>
							<td>&#160;</td>
							<xsl:if test="$displayMSAC != 0">
								<td>
									<xsl:value-of select="$stringsDoc//value[@key='total']"/>:&#160;<xsl:value-of select="$enclosureBladePowerSummaryDoc//hpoa:enclosureBladePowerSummary/hpoa:minPowerCap"/>
					 			</td>
							</xsl:if>
						</xsl:if>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='total']"/>:&#160;<xsl:value-of select="hpoa:powerAllocated"/>
						</td>
					</tr>
				</tbody>
			</xsl:for-each>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='ioBayPwrSummary']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$stringsDoc//value[@key='bay']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='name']"/></th>
					<th style="text-align:right;"><xsl:value-of select="$stringsDoc//value[@key='powerAllocated']"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)</th>
				</tr>
			</thead>
			<xsl:for-each select="$powerSummaryDoc//hpoa:enclosurePowerSummary/hpoa:enclosureInterconnectPowerSummary">
				<tbody>
					<xsl:for-each select="hpoa:interconnectPowerSummary">
						<xsl:variable name="bayNumber" select="hpoa:bayNumber"/>
						<tr>
							<td>
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$bayNumber" />, "interconnect", <xsl:value-of select="$encNum" />, true);</xsl:attribute>
									<xsl:value-of select="$bayNumber"/>
								</xsl:element>
							</td>
							<td>
								<xsl:value-of select="$interconnectInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:name"/>
							</td>
							<td style="text-align:right;">
								<xsl:value-of select="hpoa:powerAllocated"/>
							</td>

						</tr>
					</xsl:for-each>
					<tr class="summaryRow">
						<td>&#160;</td>
						<td>&#160;</td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='total']"/>:&#160;<xsl:value-of select="hpoa:powerAllocated"/>
						</td>
					</tr>
				</tbody>
			</xsl:for-each>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='fanPwrSummary']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$stringsDoc//value[@key='fanRule']"/></th>
					<th style="text-align:right;">
						<xsl:value-of select="$stringsDoc//value[@key='presentPwr']"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='allFans']"/> (<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)
					</th>
					<th style="text-align:right;">
						<xsl:value-of select="$stringsDoc//value[@key='powerAllocated']"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='watts']"/> DC)
					</th>

				</tr>
			</thead>
			<xsl:for-each select="$powerSummaryDoc//hpoa:enclosurePowerSummary/hpoa:enclosureFanPowerSummary">
				<tbody>
					<tr>
						<td>
							<xsl:value-of select="hpoa:fanRule"/>-<xsl:value-of select="$stringsDoc//value[@key='fan']"/>
						</td>
						<td style="text-align:right;">
							<xsl:value-of select="hpoa:presentPower"/>
						</td>
						<td style="text-align:right;">
							<xsl:value-of select="hpoa:powerAllocated"/>
						</td>
					</tr>
				</tbody>
			</xsl:for-each>
		</table>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div class='bWrapperUp'>
			<div>
				<div>
					<xsl:element name="button">

						<xsl:attribute name="type">button</xsl:attribute>
						<xsl:attribute name="class">hpButton</xsl:attribute>
						<xsl:attribute name="id">btnTestSettings</xsl:attribute>
						<xsl:attribute name="onclick">loadContent();</xsl:attribute>

						<xsl:value-of select="$stringsDoc//value[@key='refresh']" />
					</xsl:element>

				</div>
			</div>
		</div>
		
	</xsl:template>

	
</xsl:stylesheet>
