<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
	(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="stringsDoc"/>
	<xsl:param name="encName"/>
	<xsl:param name="bayNum"/>
	<xsl:param name="encNum"/>
	<xsl:param name="oaMode"/>
	<xsl:param name="oaNetworkInfoDoc"/>
	<xsl:param name="oaStatusDoc"/>
	<xsl:param name="isWizard"/>
	<xsl:param name="enclosureVersion"/>
	<xsl:include href="../../Templates/guiConstants.xsl"/>
	<xsl:template match="*">

	<xsl:variable name="activeId">
		<xsl:value-of select="concat('(', $encName, ' (', $stringsDoc//value[@key='active'], '))')"/>
	</xsl:variable>
	<xsl:variable name="standbyId">
		<xsl:value-of select="concat('(', $encName, ' (', $stringsDoc//value[@key='standby'], '))')"/>
	</xsl:variable>

		<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo">

			<xsl:variable name="dhcpEnabled" select="hpoa:dhcpEnabled='true'" />

			<xsl:if test="$isWizard='true'">
				<h5><xsl:value-of select="concat($stringsDoc//value[@key='enclosure:'], ' ', $encName)" /></h5>
			</xsl:if>

			<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">

				<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">

					<xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>

					<xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>

					<xsl:choose >

						<xsl:when test="contains($temp1, 'STATIC')">

							<xsl:variable name="temp2" select="concat('Ipv6Address',(position()-1))"/>

							<xsl:variable name="last_position" select="position()"/>

							<xsl:variable name="ipv6StaticAddrString" select="$stringsDoc//value[@key='ipv6StaticAddr']"/>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>

							<tr>
								<xsl:element name="td">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',position(),$encNum)"/>
									</xsl:attribute>
									<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
									<xsl:value-of select="concat($ipv6StaticAddrString,position(),':')"/>
								</xsl:element>
								<td width="5">&#160;</td>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="class">stdInput</xsl:attribute>
										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="caption-label">
											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',position(), $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'StaticAddrIpv6',position(),$encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="maxlength">45</xsl:attribute>
										<xsl:attribute name="style">width:290px</xsl:attribute>
										<xsl:attribute name="validate-me">true</xsl:attribute>
										<xsl:choose>
											<xsl:when test="position()>1">
												<xsl:attribute name="rule-list">13;14</xsl:attribute>
												<xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'StaticAddrIpv6',position()-1,$encNum)"/></xsl:attribute>
												<xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',position()-1,$encNum)"/></xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="rule-list">14</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:attribute name="caption-label">
											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',position(),$encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
										</xsl:attribute>
										<xsl:if test="not($isWizard) or ($isWizard = 'false')">
											<xsl:attribute name="onchange">toggleIpMode6();</xsl:attribute>
										</xsl:if>
									</xsl:element>

									<xsl:element name="input">
										<xsl:attribute name="type">hidden</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'BayNumber', $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="$bayNum"/>
										</xsl:attribute>
									</xsl:element>
								</td> 
							</tr>

						</xsl:when>

						<xsl:when test="not(contains($temp1, 'STATIC')) and (position()=1)"> 

							<xsl:variable name="ipv6StaticAddrString" select="$stringsDoc//value[@key='ipv6StaticAddr']"/>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>
							<tr>

								<xsl:element name="td">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv61', $encNum)"/>
									</xsl:attribute>
									<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
									<xsl:value-of select="concat($ipv6StaticAddrString,'1',':')"/>
								</xsl:element>
								<td width="5">&#160;</td>
								<td>
									<xsl:element name="input">


										<xsl:attribute name="class">stdInput</xsl:attribute>

										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="caption-label">
											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',1, $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'StaticAddrIpv6',1,$encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="maxlength">45</xsl:attribute>
										<xsl:attribute name="style">width:290px</xsl:attribute>
										<xsl:attribute name="validate-me">true</xsl:attribute>
										<xsl:attribute name="rule-list">14</xsl:attribute>
										<xsl:attribute name="caption-label">

											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv61', $encNum)"/>

										</xsl:attribute>


										<xsl:attribute name="value">

										</xsl:attribute>
										<xsl:if test="not($isWizard) or ($isWizard = 'false')">
											<xsl:attribute name="onchange">toggleIpMode6();</xsl:attribute>
										</xsl:if>

									</xsl:element>
									<xsl:element name="input">
										<xsl:attribute name="type">hidden</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'BayNumber', $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="$bayNum"/>
										</xsl:attribute>
									</xsl:element>
								</td> 
							</tr>

						</xsl:when>


						<xsl:when test="not(contains($temp1, 'STATIC')) and (position()=2)"> 

							<xsl:variable name="ipv6StaticAddrString" select="$stringsDoc//value[@key='ipv6StaticAddr']"/>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>

							<tr>

								<xsl:element name="td">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv62', $encNum)"/>
									</xsl:attribute>
									<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
									<xsl:value-of select="concat($ipv6StaticAddrString,'2',':')"/>
								</xsl:element>
								<td width="5">&#160;</td>
								<td>
									<xsl:element name="input">


										<xsl:attribute name="class">stdInput</xsl:attribute>

										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="caption-label">
											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',2, $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'StaticAddrIpv6',2,$encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="maxlength">45</xsl:attribute>
										<xsl:attribute name="style">width:290px</xsl:attribute>
										<xsl:attribute name="validate-me">true</xsl:attribute>
										<xsl:attribute name="rule-list">13;14</xsl:attribute>
										<xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'StaticAddrIpv6',1,$encNum)"/></xsl:attribute>
										<xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',1,$encNum)"/></xsl:attribute>
										<xsl:attribute name="caption-label">

											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv62', $encNum)"/>

										</xsl:attribute>

										<xsl:attribute name="value">

										</xsl:attribute>
										<xsl:if test="not($isWizard) or ($isWizard = 'false')">
											<xsl:attribute name="onchange">toggleIpMode6();</xsl:attribute>
										</xsl:if>

									</xsl:element>
									<xsl:element name="input">
										<xsl:attribute name="type">hidden</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'BayNumber', $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="$bayNum"/>
										</xsl:attribute>
									</xsl:element>
								</td> 
							</tr>


						</xsl:when>




						<xsl:when test="not(contains($temp1, 'STATIC')) and (position()=3)"> 

							<xsl:variable name="ipv6StaticAddrString" select="$stringsDoc//value[@key='ipv6StaticAddr']"/>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>


							<tr>
								<xsl:element name="td">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv63', $encNum)"/>
									</xsl:attribute>
									<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
									<xsl:value-of select="concat($ipv6StaticAddrString,'3',':')"/>
								</xsl:element>
								<td width="5">&#160;</td>
								<td>
									<xsl:element name="input">


										<xsl:attribute name="class">stdInput</xsl:attribute>

										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="caption-label">
											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',3, $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'StaticAddrIpv6',3,$encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="maxlength">45</xsl:attribute>
										<xsl:attribute name="style">width:290px</xsl:attribute>
										<xsl:attribute name="validate-me">true</xsl:attribute>
										<xsl:attribute name="rule-list">13;14</xsl:attribute>
										<xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'StaticAddrIpv6',2,$encNum)"/></xsl:attribute>
										<xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv6',2,$encNum)"/></xsl:attribute>
										<xsl:attribute name="caption-label">

											<xsl:value-of select="concat('lbl', $oaMode, 'StaticAddrIpv63', $encNum)"/>

										</xsl:attribute>

										<xsl:attribute name="value">

										</xsl:attribute>
										<xsl:if test="not($isWizard) or ($isWizard = 'false')">
											<xsl:attribute name="onchange">toggleIpMode6();</xsl:attribute>
										</xsl:if>

									</xsl:element>
									<xsl:element name="input">
										<xsl:attribute name="type">hidden</xsl:attribute>
										<xsl:attribute name="id">
											<xsl:value-of select="concat($oaMode, 'BayNumber', $encNum)"/>
										</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="$bayNum"/>
										</xsl:attribute>
									</xsl:element>
								</td> 
							</tr>

						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>

				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('lbl', $oaMode, 'ipv6dns1', $encNum)"/>
						</xsl:attribute>
						<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>

						IPv6 <xsl:value-of select="$stringsDoc//value[@key='dnsServer']" />&#160;1:
					</xsl:element>
					<td width="5">&#160;</td>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="style">width:290px</xsl:attribute>
							<xsl:attribute name="class">stdInput</xsl:attribute>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($oaMode, 'ipv6dns1', $encNum)"/>
							</xsl:attribute>

							<xsl:attribute name="validate-me">true</xsl:attribute>
							<xsl:attribute name="rule-list">15</xsl:attribute>
							<xsl:attribute name="caption-label">
								<xsl:value-of select="concat('lbl', $oaMode, 'ipv6dns1', $encNum)"/>
							</xsl:attribute>

							<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DnsStatic1'] != $EMPTY_IP_TEST">

								<xsl:attribute name="value">
									<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DnsStatic1']"/>

								</xsl:attribute>
							</xsl:if>

						</xsl:element>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('lbl', $oaMode, 'ipv6dns2', $encNum)"/>
						</xsl:attribute>
						<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
						IPv6 <xsl:value-of select="$stringsDoc//value[@key='dnsServer']" />&#160;2:
					</xsl:element>
					<td width="5">&#160;</td>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="style">width:290px</xsl:attribute>
							<xsl:attribute name="class">stdInput</xsl:attribute>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of select="concat($oaMode, 'ipv6dns2', $encNum)"/></xsl:attribute>
							<!-- validation: optional;IP address;unique;depends on dns1 -->

							<xsl:choose>
								<xsl:when test="$oaMode='ACTIVE'">
									<xsl:attribute name="validate-ip-static-active">true</xsl:attribute>
									<xsl:attribute name="unique-id"><xsl:value-of select="$activeId" /></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="validate-ip-static-standby">true</xsl:attribute>
									<xsl:attribute name="unique-id"><xsl:value-of select="$standbyId" /></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="rule-list">12;15</xsl:attribute>
							<xsl:attribute name="caption-label">
								<xsl:value-of select="concat('lbl', $oaMode, 'ipv6dns2', $encNum)"/>
							</xsl:attribute>

							<xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'ipv6dns1', $encNum)"/></xsl:attribute>
							<xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'ipv6dns1', $encNum)"/></xsl:attribute>

							<xsl:attribute name="value">
								<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DnsStatic2']"/>
							</xsl:attribute>

						</xsl:element>
					</td>
				</tr>

				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
        
        <xsl:if test="count($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DynamicDns']) &gt; 0">
				  <tr>
					  <xsl:element name="td">
						  <xsl:attribute name="id">
							  <xsl:value-of select="concat('lbl', $oaMode, 'ipv6DynDns', $encNum)"/>
						  </xsl:attribute>
						  <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
						  <xsl:value-of select="$stringsDoc//value[@key='enableDynamicDNSIPv6']"/>:
					  </xsl:element>
					  <td width="5">&#160;</td>
					  <td>
						  <xsl:element name="input">
							  <xsl:attribute name="class">stdCheckbox</xsl:attribute>
							  <xsl:attribute name="type">checkbox</xsl:attribute>
							  <xsl:attribute name="id">
								  <xsl:value-of select="concat($oaMode, 'ipv6DynDns', $encNum)"/>
							  </xsl:attribute>
							  <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DynamicDns']='true'">
								  <xsl:attribute name="checked">true</xsl:attribute>
							  </xsl:if>
							  <xsl:if test="$isWizard='true'">
								  <xsl:if test="$oaMode='ACTIVE'">
									  <xsl:attribute name="onClick">updateCheckAllIpv6DynDns('ACTIVE')</xsl:attribute>
								  </xsl:if>
								  <xsl:if test="$oaMode='STANDBY'">
									  <xsl:attribute name="onClick">updateCheckAllIpv6DynDns('STANDBY')</xsl:attribute>
								  </xsl:if>
							  </xsl:if>
						  </xsl:element>
					  </td>
				  </tr>

				  <tr>
					  <td colspan="3" ><hr /></td>
				  </tr>
        </xsl:if>

				<!-- Default Gateway - test for OA version 4.20 & up-->
				<xsl:if test="$enclosureVersion &gt;= 4.2">
				<tr>
                                	<td colspan="3" class="formSpacer">&#160;</td>
                                </tr>
                                <tr>
                                	<xsl:element name="td">
                                        <xsl:attribute name="id">
                                        	<xsl:value-of select="concat('lbl', $oaMode, 'staticipv6gw', $encNum)"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
                                        <xsl:value-of select="$stringsDoc//value[@key='gatewayIPv6Static:']" />&#160;
                                        </xsl:element>
				<td width="5">&#160;</td>
                                <td>
                                	<xsl:element name="input">
                                        <xsl:attribute name="style">width:290px</xsl:attribute>
                                        <xsl:attribute name="class">stdInput</xsl:attribute>
                                        <xsl:attribute name="type">text</xsl:attribute>
                                        <xsl:attribute name="id">
                                        	<xsl:value-of select="concat($oaMode, 'staticipv6gw', $encNum)"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="validate-me">true</xsl:attribute>
                                        <xsl:attribute name="rule-list">15</xsl:attribute>
                                        <xsl:attribute name="caption-label">
	                                        <xsl:value-of select="concat('lbl', $oaMode, 'staticipv6gw', $encNum)"/>
                                        </xsl:attribute>
                                        <!-- NEED BACK END CHANGES-->
                                        <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6StaticDefaultGateway'] != ''">
                                        <xsl:attribute name="value">
                                        	<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6StaticDefaultGateway']"/>
                                        </xsl:attribute>
                                        </xsl:if>
                                        </xsl:element>
				</td>
                                </tr>   
                                </xsl:if>

				<!-- Static Routes - test for OA version 4.30 & up-->
				<xsl:if test="$enclosureVersion &gt;= 4.3">
					<!-- ROUTE -->
					<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6StaticRouteDestination')]">
						
						<xsl:variable name="SOAPName" select="concat('Ipv6StaticRouteDestination', position())"/>
						<xsl:variable name="GWSOAPName" select="concat('Ipv6StaticRouteGateway', position())"/>
							
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
									<xsl:value-of select="concat('lbl', $oaMode, 'staticipv6routedestination', position(), $encNum)"/>
						</xsl:attribute>
						<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
								<xsl:value-of select="concat($stringsDoc//value[@key='staticipv6routedestination'], position(), ':')" />&#160;
					</xsl:element>
					<td width="5">&#160;</td>
					<td>
						<xsl:element name="input">
									<xsl:attribute name="style">width:290px</xsl:attribute>
									<xsl:attribute name="class">stdInput</xsl:attribute>
									<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id">
										<xsl:value-of select="concat($oaMode, 'staticipv6routedestination', position(), $encNum)"/>
							</xsl:attribute>
									<xsl:attribute name="validate-me">true</xsl:attribute>
									<xsl:attribute name="rule-list">13;14</xsl:attribute>

									<xsl:choose>
										<xsl:when test="position()>1">
											<xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'staticipv6routegateway', position(), $encNum, ';', $oaMode, 'staticipv6routedestination', position()-1, $encNum)"/></xsl:attribute>
											<xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'staticipv6routegateway', position(), $encNum, ';', 'lbl', $oaMode, 'staticipv6routedestination', position()-1, $encNum)"/></xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'staticipv6routegateway', position(), $encNum)"/></xsl:attribute>
											<xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'staticipv6routegateway', position(), $encNum)"/></xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:attribute name="caption-label">
										<xsl:value-of select="concat('lbl', $oaMode, 'staticipv6routedestination', position(), $encNum)"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$SOAPName]"/>
									</xsl:attribute>
						</xsl:element>
					</td>
				</tr>

						<!-- ROUTE GATEWAY -->
						<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
						</tr>
						<tr>
							<xsl:element name="td">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('lbl', $oaMode, 'staticipv6routegateway', position(), $encNum)"/>
								</xsl:attribute>
								<xsl:attribute name="style">white-space:nowrap;</xsl:attribute>
								<xsl:value-of select="concat($stringsDoc//value[@key='staticipv6routegateway'], position(), '):')" />&#160;
							</xsl:element>
							<td width="5">&#160;</td>
							<td>
								<xsl:element name="input">
									<xsl:attribute name="style">width:290px</xsl:attribute>
									<xsl:attribute name="class">stdInput</xsl:attribute>
									<xsl:attribute name="type">text</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat($oaMode, 'staticipv6routegateway', position(), $encNum)"/>
									</xsl:attribute>
									<xsl:attribute name="validate-me">true</xsl:attribute>
									<xsl:attribute name="rule-list">13;15</xsl:attribute>
									<xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'staticipv6routedestination', position(), $encNum)"/></xsl:attribute>
									<xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'staticipv6routedestination', position(), $encNum)"/></xsl:attribute>
									<xsl:attribute name="caption-label">
										<xsl:value-of select="concat('lbl', $oaMode, 'staticipv6routegateway', position(), $encNum)"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$GWSOAPName]"/>
									</xsl:attribute>
								</xsl:element>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>
			</table>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>

