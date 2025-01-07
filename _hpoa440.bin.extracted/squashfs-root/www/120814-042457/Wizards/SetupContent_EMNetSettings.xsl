<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
	(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="stringsDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />

	<xsl:param name="enclosureList" />
	<xsl:param name="activeOaNetworkInfo" />
	<xsl:param name="standbyOaNetworkInfo" />
	<xsl:param name="hasStandby" />
	<xsl:param name="currentTab" />
	<xsl:param name="enclosureVersion" />
	
	<xsl:variable name="enclosureNumberCount" select="count($enclosureList//enclosure[selected = 'true'])" />

	<xsl:template match="*">

		<div id="stepInnerContent">

			<table cellpadding="0" cellspacing="0" border="0" width="100%" ID="Table1">
				<tr>
					<td style="padding-top:10px;" id="contentTableCell">	
						<xsl:choose>
							<xsl:when test="$currentTab = 'ipv4Tab'">	
								<table cellpadding="0" cellspacing="0" border="0" width="100%">
									<tr>
										<td>
											<div id="oaNetSettingsErrorDisplay" class="errorDisplay"></div>
										</td>
									</tr>
									<tr>
										<td>
											<b>
												<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara5']" /><br />
												<span class="whiteSpacer">&#160;</span><br />
											</b>
										</td>

										<xsl:if test="$hasStandby='true'">
											<td></td>
											<td>
												<b>
													<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara6']" /><br />
													<span class="whiteSpacer">&#160;</span><br />
												</b>
											</td>
										</xsl:if>

									</tr>
									<tr>
										<td class="groupingBox" valign="top">

											<!-- Active EM Settings -->
											<xsl:element name="input">
												<xsl:attribute name="type">radio</xsl:attribute>
												<xsl:attribute name="name">activeIPType</xsl:attribute>
												<xsl:attribute name="id">activeIPSettingDHCP</xsl:attribute>
												<xsl:attribute name="class">stdRadioButton</xsl:attribute>
                        <xsl:attribute name="value">dhcp</xsl:attribute>
												<xsl:attribute name="onclick">toggleFormEnabled('frmContainerActiveStatic', false);toggleFormEnabled('frmContainerActiveDHCP', true);setOaDnsFieldsEnabled('frmContainerActiveStatic');</xsl:attribute>
												<xsl:if test="$activeOaNetworkInfo//hpoa:dhcpEnabled = 'true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:element>
											<label for="activeIPSettingDHCP">
												<xsl:value-of select="$stringsDoc//value[@key='activeIPSettingDHCP']" /></label>
											<br />
											<blockquote>
												<div id="frmContainerActiveDHCP">
													<xsl:element name="input">
														<xsl:attribute name="type">checkbox</xsl:attribute>
														<xsl:attribute name="id">activeDDNS</xsl:attribute>
														<xsl:attribute name="class">stdCheckBox</xsl:attribute>
														<xsl:if test="$activeOaNetworkInfo//hpoa:dynDnsEnabled = 'true'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</xsl:element>
													<label id="lblActiveDDNS" for="activeDDNS">
														<xsl:value-of select="$stringsDoc//value[@key='lblDDNS']" /></label>
												</div>
											</blockquote>

											<span class="whiteSpacer">&#160;</span>
											<br />

											<hr />

											<span class="whiteSpacer">&#160;</span>
											<br />

											<xsl:element name="input">
												<xsl:attribute name="type">radio</xsl:attribute>
												<xsl:attribute name="name">activeIPType</xsl:attribute>
												<xsl:attribute name="id">activeIPSettingStatic</xsl:attribute>
												<xsl:attribute name="class">stdRadioButton</xsl:attribute>
                        <xsl:attribute name="value">static</xsl:attribute>
												<xsl:attribute name="onclick">toggleFormEnabled('frmContainerActiveStatic', true);toggleFormEnabled('frmContainerActiveDHCP', false);</xsl:attribute>
												<xsl:if test="$activeOaNetworkInfo//hpoa:dhcpEnabled = 'false'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:element>

											<label for="activeIPSettingStatic">
												<xsl:value-of select="$stringsDoc//value[@key='activeIPSettingStatic']" /></label>
											<br />

											<blockquote>

												<div id="frmContainerActiveStatic">
													<em>
														<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
													</em>
													<br />
													<span class="whiteSpacer">&#160;</span>
													<br />

													<xsl:for-each select="$enclosureList//enclosure">

														<xsl:if test="selected='true'">

															<b>
																<xsl:value-of select="$stringsDoc//value[@key='enclosure:']" />&#160;<xsl:value-of select="enclosureName" />
															</b>
															<br />
															<span class="whiteSpacer">&#160;</span>
															<br />

															<div id="{concat('enc', enclosureNum ,'activeNetSettingsContainer')}"></div>

															<xsl:if test="position() != last()">
																<span class="whiteSpacer">&#160;</span>
																<br />
																<span class="whiteSpacer">&#160;</span>
																<br />
															</xsl:if>

														</xsl:if>

													</xsl:for-each>

												</div>
											</blockquote>
										</td>
										<xsl:if test="$hasStandby='true'">
											<td>
												<img src="/120814-042457/images/one_white.gif" width="40" />
											</td>
											<td class="groupingBox" valign="top">

												<!--
												We may not have a standby in the primary, but we could have one
												in other linked enclosures.  Since we base our form off of the primary
												we may have to assume a default if one is not present.
												-->
												<xsl:variable name="dhcpOption">
													<xsl:choose>
														<xsl:when test="count($standbyOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:dhcpEnabled)=0">true</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$standbyOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:dhcpEnabled"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>

												<!-- Standby EM Settings -->
												<xsl:element name="input">
													<xsl:attribute name="type">radio</xsl:attribute>
													<xsl:attribute name="name">standbyIPType</xsl:attribute>
													<xsl:attribute name="id">standbyIPSettingDHCP</xsl:attribute>
													<xsl:attribute name="class">stdRadioButton</xsl:attribute>
                          <xsl:attribute name="value">dhcp</xsl:attribute>
													<xsl:attribute name="onclick">toggleFormEnabled('frmContainerStandbyStatic', false);toggleFormEnabled('frmContainerStandbyDHCP', true);setOaDnsFieldsEnabled('frmContainerStandbyStatic');</xsl:attribute>
													<xsl:if test="$dhcpOption='true'">
														<xsl:attribute name="checked">checked</xsl:attribute>
													</xsl:if>
												</xsl:element>
												<label for="standbyIPSettingDHCP">
													<xsl:value-of select="$stringsDoc//value[@key='standbyIPSettingDHCP']" /></label>
												<br />
												<blockquote>
													<div id="frmContainerStandbyDHCP">
														<xsl:element name="input">
															<xsl:attribute name="type">checkbox</xsl:attribute>
															<xsl:attribute name="id">standbyDDNS</xsl:attribute>
															<xsl:attribute name="class">stdCheckBox</xsl:attribute>
															<xsl:if test="$standbyOaNetworkInfo//hpoa:dynDnsEnabled = 'true'">
																<xsl:attribute name="checked">checked</xsl:attribute>
															</xsl:if>
														</xsl:element>
														<label id="lblStandbyDDNS" for="standbyDDNS">
															<xsl:value-of select="$stringsDoc//value[@key='lblDDNS']" />
														</label>
													</div>
												</blockquote>

												<span class="whiteSpacer">&#160;</span>
												<br />

												<hr />

												<span class="whiteSpacer">&#160;</span>
												<br />

												<xsl:element name="input">
													<xsl:attribute name="type">radio</xsl:attribute>
													<xsl:attribute name="name">standbyIPType</xsl:attribute>
													<xsl:attribute name="id">standbyIPSettingStatic</xsl:attribute>
													<xsl:attribute name="class">stdRadioButton</xsl:attribute>
                          <xsl:attribute name="value">static</xsl:attribute>
													<xsl:attribute name="onclick">toggleFormEnabled('frmContainerStandbyStatic', true);toggleFormEnabled('frmContainerStandbyDHCP', false);</xsl:attribute>
													<xsl:if test="$dhcpOption='false'">
														<xsl:attribute name="checked">checked</xsl:attribute>
													</xsl:if>
												</xsl:element>

												<label for="standbyIPSettingStatic">
													<xsl:value-of select="$stringsDoc//value[@key='standbyIPSettingStatic']" /></label>
												<br />

												<blockquote>

													<div id="frmContainerStandbyStatic">

														<em>
															<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
														</em>
														<br />
														<span class="whiteSpacer">&#160;</span>
														<br />

														<xsl:for-each select="$enclosureList//enclosure">

															<xsl:if test="selected='true'">

																<div id="{concat('enc', enclosureNum, 'standbyOuterContainer')}">

																	<b>
																		<xsl:value-of select="$stringsDoc//value[@key='enclosure']" />:&#160;<xsl:value-of select="enclosureName" />
																	</b>
																	<br />
																	<span class="whiteSpacer">&#160;</span>
																	<br />

																	<div id="{concat('enc', enclosureNum ,'standbyNetSettingsContainer')}"></div>

																	<xsl:if test="position() != last()">
																		<span class="whiteSpacer">&#160;</span>
																		<br />
																		<span class="whiteSpacer">&#160;</span>
																		<br />
																	</xsl:if>

																</div>

															</xsl:if>

														</xsl:for-each>

													</div>
												</blockquote>
											</td>
										</xsl:if>
									</tr>
								</table> 
							</xsl:when>
							<!-- IPv6-->
							<xsl:otherwise> 
								<div style="width:100%;margin-right:1%;">
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
																<label id="lblEnableRA" for="activeEnableRA"><xsl:value-of select="$stringsDoc//value[@key='enableSlaac']" /></label>
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
															<div id="frmContainerEnableRaTraffic" style="text-indent:30px;">
																<xsl:element name="input">
																	<xsl:attribute name="type">checkbox</xsl:attribute>
																	<xsl:attribute name="id">activeEnableRaTraffic</xsl:attribute>
																	<xsl:attribute name="class">stdCheckBox</xsl:attribute>
																	<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RaTrafficEnabled']='true'">
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
									</xsl:if>
									<span class="whiteSpacer">&#160;</span><br />
								</div>							

								<span class="whiteSpacer">&#160;</span>
								<br />

								<table cellpadding="0" cellspacing="0" border="0" width="100%">
									<tr>
										<td>
											<div id="oaNetSettingsErrorDisplay" class="errorDisplay"></div>
										</td>
									</tr>
									<tr>
										<td>
											<b>								
												<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara5']" /><br />
												<span class="whiteSpacer">&#160;</span><br />
											</b>
										</td>

										<xsl:if test="$hasStandby='true'">
											<td></td>
											<td>
												<b>
													<xsl:value-of select="$stringsDoc//value[@key='oaNetSettingsPara6']" /><br />
													<span class="whiteSpacer">&#160;</span><br />
												</b>
											</td>
										</xsl:if>

									</tr>
									<tr>
										<td class="groupingBox" valign="top">
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

											<xsl:if test="$enclosureNumberCount &gt; 1">
												<xsl:element name="input">
													<xsl:attribute name="id">enableAllIpv6DdnsActive</xsl:attribute>
													<xsl:attribute name="class">stdCheckbox</xsl:attribute>
													<xsl:attribute name="type">checkbox</xsl:attribute>
													<xsl:attribute name="onClick">checkAllIpv6DynDns(this.checked, 'ACTIVE')</xsl:attribute>
												</xsl:element>
												<label for="enableAllIpv6DdnsActive">
													<xsl:value-of select="$stringsDoc//value[@key='enableIpv6DdnsAllActive']" />
												</label>

												<br/><br/>
											</xsl:if>

											<div id="frmContainerActiveStaticIPv6">
												<xsl:for-each select="$enclosureList//enclosure">
													<xsl:if test="selected='true'">
														<div id="{concat('enc', enclosureNum ,'activeNetSettingsContainer')}"></div>
														<xsl:if test="position() != last()">
															<span class="whiteSpacer">&#160;</span>
															<br />
															<span class="whiteSpacer">&#160;</span>
															<br />
														</xsl:if>
													</xsl:if>
												</xsl:for-each>
											</div>				

											<xsl:if test="$enclosureVersion &lt; 3.6">
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

												<span class="whiteSpacer">&#160;</span>
												<br />

											</xsl:if>
										</td>
										<xsl:if test="$hasStandby='true'">
											<td>
												<img src="/120814-042457/images/one_white.gif" width="40" />
											</td>
											<td class="groupingBox" valign="top">
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
												
												<xsl:if test="$enclosureNumberCount &gt; 1">
													<xsl:element name="input">
														<xsl:attribute name="id">enableAllIpv6DdnsStandby</xsl:attribute>
														<xsl:attribute name="class">stdCheckbox</xsl:attribute>
														<xsl:attribute name="type">checkbox</xsl:attribute>
														<xsl:attribute name="onClick">checkAllIpv6DynDns(this.checked, 'STANDBY')</xsl:attribute>
													</xsl:element>
													<label for="enableAllIpv6DdnsActive">
														<xsl:value-of select="$stringsDoc//value[@key='enableIpv6DdnsAllStandby']" />
													</label>

													<br/><br/>
												</xsl:if>
												

												<div id="frmContainerStandbyStaticIPv6">

													<xsl:for-each select="$enclosureList//enclosure">

														<xsl:if test="selected='true'">

															<div id="{concat('enc', enclosureNum, 'standbyOuterContainer')}">
																<div id="{concat('enc', enclosureNum ,'standbyNetSettingsContainer')}"></div>
																<xsl:if test="position() != last()">
																	<span class="whiteSpacer">&#160;</span>
																	<br />
																	<span class="whiteSpacer">&#160;</span>
																	<br />
																</xsl:if>
															</div>
														</xsl:if>
													</xsl:for-each>
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
							</xsl:otherwise>
						</xsl:choose>		
					</td>
				</tr>
			</table>

		</div>
		<div id="waitContainer" class="waitContainer"></div>

	</xsl:template>

</xsl:stylesheet>

