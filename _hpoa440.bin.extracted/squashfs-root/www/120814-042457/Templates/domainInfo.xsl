<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<!-- Document fragment parameters containing blade status and information -->
	<xsl:param name="monarchBladeNum" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="domainInfoDoc" />
	<xsl:param name="bladeInfoDom" />
	<xsl:param name="bladeStatusDom" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:template match="*">

		<xsl:variable name="monarchName" select="$bladeInfoDom//hpoa:bladeInfo[hpoa:bayNumber=$monarchBladeNum]/hpoa:name" />

		<xsl:choose>
			<xsl:when test="count($domainInfoDoc//hpoa:domainInfo/hpoa:domains/hpoa:domain[hpoa:monarchBlade=$monarchBladeNum]) &gt; 0">
				<xsl:for-each select="$domainInfoDoc//hpoa:domainInfo/hpoa:domains/hpoa:domain[hpoa:monarchBlade=$monarchBladeNum]">
					<table align="center" border="0" cellpadding="0" cellspacing="0" class="treeTable">
						<caption>
							Multi-Blade Server Status - <xsl:value-of select="$monarchName"/>
						</caption>
						<tbody>

							<tr>
								<td></td>
								<td>
									<xsl:value-of select="$stringsDoc//value[@key='bay']" />
								</td>
								<td>
									<xsl:value-of select="$stringsDoc//value[@key='status']" />
								</td>
								<td>
									<xsl:value-of select="$stringsDoc//value[@key='systemHealth']" />
								</td>
								<td>
									<xsl:value-of select="$stringsDoc//value[@key='statusPowered']" />
								</td>
								<td>
									<xsl:value-of select="$stringsDoc//value[@key='powerAllocated']" />
								</td>
								<td>
									<xsl:value-of select="$stringsDoc//value[@key='virtualFan']" />
								</td>
							</tr>

							<xsl:for-each select="hpoa:partitions/hpoa:partition">

								<xsl:variable name="mmpNum" select="hpoa:mmpBlade"/>
								<!-- Monarch System is used for all blades -->
								<xsl:variable name="systemHealth" select="$bladeStatusDom//hpoa:bladeStatus[hpoa:bayNumber=$mmpNum]/hpoa:extraData[@hpoa:name='SystemHealth']" />

								<tr class="treeTableTopLevel">
									<td nowrap="true">
										<b>
											<xsl:choose>
												<xsl:when test="hpoa:serverName != '' and hpoa:serverName != 'Status is not available'">
													<xsl:value-of select="hpoa:serverName"/>:
												</xsl:when>
												<xsl:otherwise>
													Hostname Unknown
												</xsl:otherwise>
											</xsl:choose>
										</b>
									</td>
									<td colspan="6">&#160;</td>
								</tr>

								<xsl:for-each select="$bladeStatusDom//hpoa:bladeStatus[hpoa:bayNumber=$mmpNum]">
									<tr>
										<td class="nested1" nowrap="true" style="width:100px;">
											Monarch Blade:
										</td>
										<td width="10%" nowrap="true">
											<xsl:element name="a">
												<xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$mmpNum" />);</xsl:attribute>
												<xsl:value-of select="$mmpNum"/>
											</xsl:element>
										</td>
										<td>
											<xsl:call-template name="getStatusLabel">
												<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
											</xsl:call-template>
										</td>
										<td>
											<xsl:call-template name="getStatusLabel">
												<xsl:with-param name="statusCode" select="$systemHealth" />
											</xsl:call-template>
										</td>
										<td>
											<xsl:call-template name="getPowerLabel">
												<xsl:with-param name="powered" select="hpoa:powered" />
											</xsl:call-template>
										</td>
										<td>
											<xsl:value-of select="hpoa:powerConsumed" />&#160;
											<xsl:value-of select="$stringsDoc//value[@key='watts']" />
										</td>
										<td>
											<xsl:value-of select="hpoa:extraData[@hpoa:name='VirtualFan']" />%
										</td>
									</tr>

								</xsl:for-each>

								<xsl:for-each select="hpoa:bays/hpoa:bay[.!=$mmpNum]">
									<xsl:variable name="bayNum" select="." />
									<xsl:for-each select="$bladeStatusDom//hpoa:bladeStatus[hpoa:bayNumber=$bayNum]">
										<tr>
											<td class="nested1">Auxiliary Blade:</td>
											<td width="10%" nowrap="true">
												<xsl:element name="a">
													<xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$bayNum" />);</xsl:attribute>
													<xsl:value-of select="$bayNum"/>
												</xsl:element>
											</td>
											<td>
												<xsl:call-template name="getStatusLabel">
													<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
												</xsl:call-template>
											</td>
											<td>
												<xsl:call-template name="getStatusLabel">
													<xsl:with-param name="statusCode" select="$systemHealth" />
												</xsl:call-template>
											</td>
											<td>
												<xsl:call-template name="getPowerLabel">
													<xsl:with-param name="powered" select="hpoa:powered" />
												</xsl:call-template>
											</td>
											<td>
												<xsl:value-of select="hpoa:powerConsumed" />&#160;
												<xsl:value-of select="$stringsDoc//value[@key='watts']" />
											</td>
											<td>
												<xsl:value-of select="hpoa:extraData[@hpoa:name='VirtualFan']" />%
											</td>
										</tr>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:for-each>
						</tbody>
					</table>

					<xsl:for-each select="$bladeInfoDom//hpoa:bladeInfo[hpoa:bayNumber=$monarchBladeNum]">

						<xsl:variable name="productId" select="hpoa:productId" />

						<span class="whiteSpacer">&#160;</span>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />

						<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
							<caption>
								Multi-Blade Server Information - <xsl:value-of select="$monarchName"/>
							</caption>
							<tbody>
								<tr class="">
									<th class="propertyName">
										<xsl:value-of select="$stringsDoc//value[@key='bladeType']" />
									</th>
									<td class="propertyValue">
										<xsl:choose>
											<xsl:when test="hpoa:bladeType='BLADE_TYPE_SERVER'">
												<xsl:value-of select="$stringsDoc//value[@key='serverBlade']" />
											</xsl:when>
											<xsl:when test="hpoa:bladeType='BLADE_TYPE_STORAGE'">
												<xsl:value-of select="$stringsDoc//value[@key='storageBlade']" />
											</xsl:when>
											<xsl:when test="hpoa:bladeType='BLADE_TYPE_IO'">
												<xsl:value-of select="$stringsDoc//value[@key='ioBlade']" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								<tr class="altRowColor">
									<th class="propertyName">
										<xsl:value-of select="$stringsDoc//value[@key='manufacturer']" />
									</th>
									<td class="propertyValue">
										<xsl:value-of select="hpoa:manufacturer" />
									</td>
								</tr>
								<tr class="">
									<th class="propertyName">
										<xsl:value-of select="$stringsDoc//value[@key='productName']" />
									</th>
									<td class="propertyValue">
										<xsl:value-of select="hpoa:name" />
									</td>
								</tr>
								<tr class="altRowColor">
									<th class="propertyName">
										<xsl:value-of select="$stringsDoc//value[@key='partNumber']" />
									</th>
									<td class="propertyValue">
										<xsl:value-of select="hpoa:partNumber" />
									</td>
								</tr>
								<tr class="">
									<th class="propertyName">
										<xsl:value-of select="$stringsDoc//value[@key='serialNumber']" />
									</th>
									<td class="propertyValue">
										<xsl:value-of select="hpoa:serialNumber" />
									</td>
								</tr>
								<xsl:if test="hpoa:bladeType='BLADE_TYPE_SERVER'">
									<tr class="altRowColor">
										<th class="propertyName">
											<xsl:value-of select="$stringsDoc//value[@key='uuid']" />
										</th>
                                        <td class="propertyValue">
                                            <xsl:choose>
                                                <xsl:when test="count(hpoa:extraData[@hpoa:name='DomainUUID']) &gt; 0">
                                                    <xsl:value-of select="hpoa:extraData[@hpoa:name='DomainUUID']" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="count(hpoa:extraData[@hpoa:name='cUUID']) &gt; 0">
                                                            <xsl:value-of select="hpoa:extraData[@hpoa:name='cUUID']" />
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="hpoa:uuid" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
										</td>
									</tr>
								</xsl:if>
								<!--
								<tr class="">
									<th class="propertyName">
										<xsl:value-of select="$stringsDoc//value[@key='biosAssetTag']" />
									</th>
									<td class="propertyValue">
										<xsl:choose>
											<xsl:when test="hpoa:assetTag != '[Unknown]'">
												<xsl:value-of select="hpoa:assetTag" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$stringsDoc//value[@key='Not set']" />
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								-->
							</tbody>
						</table>
					</xsl:for-each>

				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				The multi-blade server information is not present.
			</xsl:otherwise>
		</xsl:choose>
		
		

	</xsl:template>

</xsl:stylesheet>
