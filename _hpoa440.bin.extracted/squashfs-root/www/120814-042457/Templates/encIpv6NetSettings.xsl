<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:include href="../Forms/NetworkSettings.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureName" />
	<xsl:param name="enclosureNum" />
	<xsl:param name="activeOaNetworkInfo" />
	<xsl:param name="standbyOaNetworkInfo" />
	<xsl:param name="hasStandby" />
	<xsl:param name="activeBoardType" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="enclosureType" select="0" />
	<xsl:param name="networkInfoDoc" />
	<xsl:param name="enclosureVersion" />
	<xsl:param name="ipSwap" />


	<xsl:template match="*">

		<b>
			<xsl:value-of select="$stringsDoc//value[@key='ipSettings']" /> - <xsl:value-of select="$stringsDoc//value[@key='ipv6Settings']" />
		</b>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div id="stepInnerContent">

			<div >
				<xsl:if test="$activeBoardType != 1">
					<xsl:value-of select="$stringsDoc//value[@key='enclosureIpMode']" />:&#160;<em>
						<xsl:value-of select="$stringsDoc//value[@key='encIpModeDescription']" />
					</em>
					<br />
					<span class="whiteSpacer">&#160;</span><br />

					<div class="groupingBox">
						<div id="protocolErrorDisplay" class="errorDisplay"></div>
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="class">stdCheckBox</xsl:attribute>
										<xsl:attribute name="id">encIpMode</xsl:attribute>
										<xsl:attribute name="onclick">toggleIpMode6();</xsl:attribute>
										<xsl:if test="$serviceUserAcl = $USER or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
											<!-- TODO: OR the user does not have OA access-->
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$ipSwap = 'true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
									<label for="encIpMode">
										<xsl:value-of select="$stringsDoc//value[@key='enclosureIpMode']" />
										<xsl:call-template name="fipsHelpMsg">
											<xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']" />
											<xsl:with-param name="msgType">tooltip</xsl:with-param>
											<xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
										</xsl:call-template>
									</label>
								</td>
							</tr>
						</table>
					</div>
				</xsl:if>

				<span class="whiteSpacer">&#160;</span><br />
				<b><xsl:value-of select="$stringsDoc//value[@key='note:']" /></b>&#160;<xsl:value-of select="$stringsDoc//value[@key='changingNetworkSettingOANote1']" /><br />
			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<!-- IPv6, DHCPv6 and Router Advertisement are enclosure wide-settings since 3.60 version. -->
			<xsl:if test="$enclosureVersion &gt;= 3.6">
				<div id="enclosureNetSettingsErrorDisplay" class="errorDisplay"></div>
				<div>
					<b>
						<xsl:value-of select="$stringsDoc//value[@key='enclosureNetworkSetting']" />
					</b>
					<br />
					<br/><xsl:value-of select="$stringsDoc//value[@key='enclosureNetworkSettingNote']" /><br/>
					<span class="whiteSpacer">&#160;</span>
					<br />

					<div class="groupingBox">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td>
									<div id="frmContainerEnableIpv6">
										<xsl:element name="input">
											<xsl:attribute name="type">checkbox</xsl:attribute>
											<xsl:attribute name="id">activeEnableIPv6</xsl:attribute>
											<xsl:attribute name="class">stdCheckBox</xsl:attribute>
											<xsl:attribute name="onclick">toggleIpMode6();</xsl:attribute>
											<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:element>
										<label id="lblEnableIPv6" for="activeEnableIPv6"><xsl:value-of select="$stringsDoc//value[@key='enableIpv6']" /></label>
									</div>

									<span class="whiteSpacer">&#160;</span>
									<br />
								</td>
							</tr>

							<xsl:if test="$enclosureVersion &lt; 4.3">
								<tr>
									<td>
										<div id="frmContainerEnableRA">
											<xsl:element name="input">
												<xsl:attribute name="type">checkbox</xsl:attribute>
												<xsl:attribute name="id">activeEnableRA</xsl:attribute>
												<xsl:attribute name="class">stdCheckBox</xsl:attribute>

												<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:element>                      
											<label id="lblEnableRA" for="activeEnableRA">
                        <xsl:choose>
                          <xsl:when test="$enclosureVersion &gt;= 4.0"><xsl:value-of select="$stringsDoc//value[@key='enableSlaac']" /></xsl:when>
                          <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='enableRouterAdv']" /></xsl:otherwise>
                        </xsl:choose>
                      </label>
										</div>

										<span class="whiteSpacer">&#160;</span>
										<br />
									</td>
								</tr>

								<tr>
									<td>
										<div id="frmContainerEnableDHCPv6">
											<xsl:element name="input">
												<xsl:attribute name="type">checkbox</xsl:attribute>
												<xsl:attribute name="id">activeEnableDHCPv6</xsl:attribute>
												<xsl:attribute name="class">stdCheckBox</xsl:attribute>

												<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled'] = 'true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:element>
											<label id="lblEnableDHCPv6" for="activeEnableDHCPv6"><xsl:value-of select="$stringsDoc//value[@key='enableDHCPv6']" /></label>
										</div>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="$enclosureVersion &gt;= 4.3">
								<tr>
									<td>
										<div id="frmContainerEnableRouterTraffic" style="text-indent:30px;">
											<xsl:element name="input">
												<xsl:attribute name="type">checkbox</xsl:attribute>
												<xsl:attribute name="id">activeEnableRaTraffic</xsl:attribute>
												<xsl:attribute name="class">stdCheckBox</xsl:attribute>
												<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RaTrafficEnabled'] = 'true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
																						</xsl:element>
											<label id="lblEnableRaTraffic" for="activeEnableRaTraffic"><xsl:value-of select="$stringsDoc//value[@key='enableRouterTraffic']" /></label>
										     
										</div>

										<span class="whiteSpacer">&#160;</span>
										<br />
									</td>
								</tr>

								<tr>
									<td>
										<div id="frmContainerEnableRA" style="text-indent:80px;">
											<xsl:element name="input">
												<xsl:attribute name="type">checkbox</xsl:attribute>
												<xsl:attribute name="id">activeEnableRA</xsl:attribute>
												<xsl:attribute name="class">stdCheckBox</xsl:attribute>

												<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:element>
											<label id="lblEnableRA" for="activeEnableRA"><xsl:value-of select="$stringsDoc//value[@key='enableSlaac']" /></label>
										</div>

										<span class="whiteSpacer">&#160;</span>
										<br />
									</td>
								</tr>

								<tr>
									<td>
										<div id="frmContainerEnableDHCPv6" style="text-indent:30px;">
											<xsl:element name="input">
												<xsl:attribute name="type">checkbox</xsl:attribute>
												<xsl:attribute name="id">activeEnableDHCPv6</xsl:attribute>
												<xsl:attribute name="class">stdCheckBox</xsl:attribute>

												<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled'] = 'true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:element>
											<label id="lblEnableDHCPv6" for="activeEnableDHCPv6"><xsl:value-of select="$stringsDoc//value[@key='enableDHCPv6']" /></label>
										</div>
									</td>
								</tr>
							</xsl:if>

						</table>
					</div>
				</div>

				<span class="whiteSpacer">&#160;</span>
				<br />
				<span class="whiteSpacer">&#160;</span>
				<br />
			</xsl:if>
			<div id="oaNetSettingsErrorDisplay" class="errorDisplay"></div>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td>
						<b>
							<xsl:value-of select="$stringsDoc//value[@key='activeOANetworkSetting']" />
						</b><br />
						<span class="whiteSpacer">&#160;</span><br />
					</td>

					<xsl:if test="$hasStandby='true'">
						<td style="width:40px;">
							&#160;
						</td>
						<td>
							<b>
								<xsl:value-of select="$stringsDoc//value[@key='standbyOANetworkSetting']" />
							</b><br />
							<span class="whiteSpacer">&#160;</span><br />
						</td>
					</xsl:if>
				</tr>

				<tr>
					<td class="groupingBox" style="width:500px;" halign="right" valign="top">
						<xsl:if test="$enclosureVersion &lt; 3.6">
							<div id="frmContainerEnableIpv6">
									<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">activeEnableIPv6</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>

									<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label id="lblEnableIPv6" for="activeEnableIPv6"><xsl:value-of select="$stringsDoc//value[@key='enableIpv6']" /></label>
							</div>

							<span class="whiteSpacer">&#160;</span>
							<br />
						</xsl:if>

						<!--INSERT IPV6 INDIVIDUAL FIELDS TO BE EDITED -->
						<div id="frmContainerActiveStaticIpv6">
							<div id="{concat('enc',$enclosureNum,'activeNetSettingsContainer')}"></div>
						</div>

						<xsl:if test="$enclosureVersion &lt; 3.6">
							<span class="whiteSpacer">&#160;</span>
							<br />

							<div id="frmContainerEnableRA">

								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">activeEnableRA</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>
									<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label id="lblEnableRA" for="activeEnableRA"><xsl:value-of select="$stringsDoc//value[@key='enableSlaac']" /></label>
							</div>

							<span class="whiteSpacer">&#160;</span>
							<br />

							<div id="frmContainerEnableDHCPv6">
								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">activeEnableDHCPv6</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>
									<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled'] = 'true'">

										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label id="lblEnableDHCPv6" for="activeEnableDHCPv6"><xsl:value-of select="$stringsDoc//value[@key='enableDHCPv6']" /></label>
							</div>
						</xsl:if>
					</td>

				<xsl:if test="$hasStandby='true'">
					<td style="width:40px;">
						<img src="/120814-042457/images/one_white.gif" width="40" />
					</td>
					<td class="groupingBox" style="width:500px;" halign="right" valign="top">
						<xsl:if test="$enclosureVersion &lt; 3.6">
							<div id="frmContainerStandbyEnableIpv6">

								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">standbyEnableIPv6</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>

									<xsl:if test="$standbyOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label id="lblEnableIPv6" for="standbyEnableIPv6"><xsl:value-of select="$stringsDoc//value[@key='enableIpv6']" /></label>
							</div>

							<span class="whiteSpacer">&#160;</span>
							<br />
						</xsl:if>

						<div id="frmContainerStandbyStaticIpv6">
							<div id="{concat('enc',$enclosureNum,'standbyNetSettingsContainer')}"></div>
						</div>

						<xsl:if test="$enclosureVersion &lt; 3.6">
							<span class="whiteSpacer">&#160;</span>
							<br />

							<div id="frmContainerStandByEnableRA">

								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">standbyEnableRA</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>
									<xsl:if test="$standbyOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label id="lblEnableRA" for="standbyEnableRA"> <xsl:value-of select="$stringsDoc//value[@key='enableSlaac']" /> </label>
							</div>

							<span class="whiteSpacer">&#160;</span>
							<br />

							<div id="frmContainerStandbyEnableDHCPv6">

								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">standbyEnableDHCPv6</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>
									<xsl:if test="$standbyOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled'] = 'true'">

										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label id="lblEnableDHCPv6" for="standbyEnableDHCPv6"><xsl:value-of select="$stringsDoc//value[@key='enableDHCPv6']" /></label>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				</tr>

			</table>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' id="encIpApply" onclick='setupOaNetSettingsIpv6(true,successCallbackIpv6);'  class='hpButton'>
									<xsl:value-of select="$stringsDoc//value[@key='apply']" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<span class="whiteSpacer">&#160;</span>
			<br />
		</div>
	</xsl:template>

</xsl:stylesheet>

