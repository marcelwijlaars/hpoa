<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="vlanInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="enclosureType" />

	<xsl:template name="vlanControl" match="*">
                <div id="errorDisplay" class="errorDisplay"></div>
		<xsl:variable name="numDeviceBays">
			<xsl:choose>
				<xsl:when test="$enclosureType=0">16</xsl:when>
				<xsl:when test="$enclosureType=1">8</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="numIoBays">
			<xsl:choose>
				<xsl:when test="$enclosureType=0">8</xsl:when>
				<xsl:when test="$enclosureType=1">4</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$vlanInfoDoc//hpoa:vlanInfo/hpoa:vlanChanged='1' and $serviceUserAcl != 'USER'">

			<xsl:value-of select="$stringsDoc//value[@key='savedConfig']" />
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div class="groupingBox">

				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td style="vertical-align:top;">
							<img src="/120814-042457/images/status_informational_32.gif" width="32" height="32" />
						</td>
						<td style="width:10px;">&#160;</td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='savedConfNote']" />
						</td>
					</tr>
				</table>
				<br />
				
				<span class="whiteSpacer">&#160;</span>
				<br />
				<table cellpadding="0" cellspacing="0" border="0" align="center">
					<tr>
						<td nowrap="true">
							<div class='buttonSet buttonsAreLeftAligned' style="margin-bottom:0px;">
								<div class='bWrapperUp'>
									<div>
										<div>
											<xsl:if test="$serviceUserAcl != 'USER'">
												<button type='button' class='hpButton' onclick="revertVlanConfig();">
													<xsl:value-of select="$stringsDoc//value[@key='revert']" />
												</button>
											</xsl:if>
										</div>
									</div>
								</div>
								<div class='bWrapperUp'>
									<div>
										<div>
											<xsl:if test="$serviceUserAcl != 'USER'">
												<button type='button' class='hpButton' onclick="saveVlanConfig();">
													<xsl:value-of select="$stringsDoc//value[@key='save']" />
												</button>
											</xsl:if>
										</div>
									</div>
								</div>
							</div>
						</td>
					</tr>
				</table>

			</div>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
		</xsl:if>

		<xsl:value-of select="$stringsDoc//value[@key='activeConfig:']"/>&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='activeConfigNote']"/>
			<xsl:if test="$vlanInfoDoc//hpoa:vlanInfo/hpoa:vlanChanged='1'">
				&#160;<xsl:value-of select="$stringsDoc//value[@key='settingsNotSaved']"/>
			</xsl:if>
		</em>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div class="groupingBox">

			<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<tr>
					<td id="">
						<xsl:value-of select="$stringsDoc//value[@key='vlanMode:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:choose>
							<xsl:when test="$vlanInfoDoc//hpoa:vlanInfo/hpoa:vlanEnable='1'">
								<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td id="">
						<xsl:value-of select="$stringsDoc//value[@key='defaultVlanId:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:value-of select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg/hpoa:vlanId" />&#160;(<xsl:value-of select="$stringsDoc//value[@key='untagged']"/>)
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td id="">
						<xsl:value-of select="$stringsDoc//value[@key='oaVlanId:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:value-of select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:portArray/hpoa:port[@hpoa:deviceType='OA']"/>
					</td>
				</tr>
			</table>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:value-of select="$stringsDoc//value[@key='vlanMembership']"/>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" style="width:96%;">
				<thead>
					<tr class="captionRow">
						<th>
							<xsl:value-of select="$stringsDoc//value[@key='vlanId']"/>
						</th>
						<th>
							<xsl:value-of select="$stringsDoc//value[@key='vlanName']"/>
						</th>
						<th>
							<xsl:value-of select="$stringsDoc//value[@key='vlanMembers']"/>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg">
						<xsl:variable name="vlanId" select="hpoa:vlanId" />
						<xsl:variable name="altRowColor">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 0">altRowColor</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<tr class="{$altRowColor}">
							<td>
								<xsl:value-of select="$vlanId"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:vlanName"/>
							</td>
							<td>

								<xsl:choose>
									<xsl:when test="count(../../hpoa:portArray/hpoa:port[hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numDeviceBays]) &gt; 0">

										<xsl:if test="count(../../hpoa:portArray/hpoa:port[@hpoa:deviceType='SERVER' and hpoa:portVlanId=$vlanId]) &gt; 0">
											<xsl:value-of select="$stringsDoc//value[@key='serverBays']"/>:
											<xsl:for-each select="../../hpoa:portArray/hpoa:port[@hpoa:deviceType='SERVER' and hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numDeviceBays]">
												<xsl:value-of select="@hpoa:bayNumber"/>
												<xsl:if test="position() != last()">,&#160;</xsl:if>
											</xsl:for-each>
											<br />
										</xsl:if>

										<xsl:if test="count(../../hpoa:portArray/hpoa:port[@hpoa:deviceType='INTERCONNECT' and hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numIoBays]) &gt; 0">
											<xsl:value-of select="$stringsDoc//value[@key='interconnectBays']"/>:
											<xsl:for-each select="../../hpoa:portArray/hpoa:port[@hpoa:deviceType='INTERCONNECT' and hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numIoBays]">
												<xsl:value-of select="@hpoa:bayNumber"/>
												<xsl:if test="position() != last()">,&#160;</xsl:if>
											</xsl:for-each>
											<br />
										</xsl:if>

										<xsl:if test="count(../../hpoa:portArray/hpoa:port[@hpoa:deviceType='OA' and hpoa:portVlanId=$vlanId]) &gt; 0">
											<xsl:value-of select="$stringsDoc//value[@key='oaBays']"/>
										</xsl:if>

									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$stringsDoc//value[@key='none']"/>
									</xsl:otherwise>
								</xsl:choose>

							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
			
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

 
