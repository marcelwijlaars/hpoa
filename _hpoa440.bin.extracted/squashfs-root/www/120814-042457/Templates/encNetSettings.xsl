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
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureName" />
	<xsl:param name="enclosureNum" />
	<xsl:param name="activeOaNetworkInfo" />
	<xsl:param name="standbyOaNetworkInfo" />
	<xsl:param name="hasStandby" />
	<xsl:param name="activeBoardType" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="enclosureType" select="0" />

	<xsl:template match="*">

		<div id="stepInnerContent">
			<b>
				<xsl:value-of select="$stringsDoc//value[@key='enclosure']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='ipSettings']" />
			</b>
			<br />

			<xsl:if test="$activeBoardType != 1">
				<span class="whiteSpacer">&#160;</span>
				<br />
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
									<xsl:attribute name="onclick">toggleIpMode(this.checked);</xsl:attribute>
									<xsl:if test="$serviceUserAcl = $USER">
										<!-- TODO: OR the user does not have OA access-->
										<xsl:attribute name="disabled">true</xsl:attribute>
									</xsl:if>
									<xsl:if test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='IpSwap'] = 'true'">
										<xsl:attribute name="checked">true</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label for="encIpMode">
									<xsl:value-of select="$stringsDoc//value[@key='enclosureIpMode']" />
								</label>
							</td>
						</tr>
					</table>
				</div>
			</xsl:if>

			<span class="whiteSpacer">&#160;</span><br />
			<b><xsl:value-of select="$stringsDoc//value[@key='note:']" /></b>&#160;<xsl:value-of select="$stringsDoc//value[@key='changingNetworkSettingOANote1']" /><br />

			<span class="whiteSpacer">&#160;</span><br />
			<xsl:value-of select="$stringsDoc//value[@key='changingNetworkSettingOANote2']" />

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div id="oaNetSettingsErrorDisplay" class="errorDisplay"></div>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<!--<tr>
					<td>
						<div id="oaNetSettingsErrorDisplay" class="errorDisplay"></div>
					</td>
				</tr>-->
				<tr>
					<td>
						<b><xsl:value-of select="$stringsDoc//value[@key='activeOANetworkSetting']" />
						</b><br />
						<span class="whiteSpacer">&#160;</span><br />
					</td>

					<xsl:if test="$hasStandby='true'">
						<td></td>
						<td>
							<b>
								<xsl:value-of select="$stringsDoc//value[@key='standbyOANetworkSetting']" />
							</b><br />
							<span class="whiteSpacer">&#160;</span><br />
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
							<xsl:attribute name="onclick">toggleIpMode();toggleFormEnabled('frmContainerActiveStatic', false);toggleFormEnabled('frmContainerActiveDHCP', true);setOaDnsFieldsEnabled('frmContainerActiveStatic');</xsl:attribute>
							<xsl:if test="$activeOaNetworkInfo//hpoa:dhcpEnabled = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:element>
						<label for="activeIPSettingDHCP">DHCP</label>
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
								<label id="lblActiveDDNS" for="activeDDNS"><xsl:value-of select="$stringsDoc//value[@key='enableDynmicDNS']" /></label>
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
							<xsl:attribute name="onclick">toggleIpMode();toggleFormEnabled('frmContainerActiveStatic', true);toggleFormEnabled('frmContainerActiveDHCP', false);</xsl:attribute>
							<xsl:if test="$activeOaNetworkInfo//hpoa:dhcpEnabled = 'false'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:element>

						<label for="activeIPSettingStatic"><xsl:value-of select="$stringsDoc//value[@key='staticIPSettings']" /></label>
						<br/>
						<blockquote>
							<div id="frmContainerActiveStatic">
								<em>
									<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
								</em>
								<br />
								<span class="whiteSpacer">&#160;</span>
								<br />
								<div id="{concat('enc', $enclosureNum ,'activeNetSettingsContainer')}"></div>
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
								<xsl:attribute name="onclick">toggleFormEnabled('frmContainerStandbyStatic', false);toggleFormEnabled('frmContainerStandbyDHCP', true);setOaDnsFieldsEnabled('frmContainerStandbyStatic');</xsl:attribute>
								<xsl:if test="$dhcpOption='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:element>
							<label for="standbyIPSettingDHCP">DHCP</label>
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
									<label id="lblStandbyDDNS" for="standbyDDNS"><xsl:value-of select="$stringsDoc//value[@key='enableDynmicDNS']" /></label>
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
								<xsl:attribute name="onclick">toggleFormEnabled('frmContainerStandbyStatic', true);toggleFormEnabled('frmContainerStandbyDHCP', false);</xsl:attribute>
								<xsl:if test="$dhcpOption='false'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:element>

							<label for="standbyIPSettingStatic"><xsl:value-of select="$stringsDoc//value[@key='staticIPSettings']" /></label>
							<br/>
							<blockquote>
								<div id="frmContainerStandbyStatic">
									<em>
										<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
									</em>
									<br />
									<span class="whiteSpacer">&#160;</span>
									<br />
									<div id="{concat('enc', $enclosureNum, 'standbyOuterContainer')}">
										<div id="{concat('enc', $enclosureNum ,'standbyNetSettingsContainer')}"></div>
									</div>
								</div>
							</blockquote>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td>
						<span class="whiteSpacer">&#160;</span>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
					</td>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="$stringsDoc//value[@key='nicSettings']" />
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						<div class="groupingBox" >
							<div id="nicErrorDisplay" class="errorDisplay"></div>
							<xsl:call-template name="nicSettings">
								<xsl:with-param name="oaNetworkInfoDoc" select="$activeOaNetworkInfo" />
								<xsl:with-param name="oaMode" select="'ACTIVE'" />
								<xsl:with-param name="encNum" select="$enclosureNum" />
							</xsl:call-template>
						</div>
					</td>
					<xsl:if test="$hasStandby='true'">
						<td></td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='nicSettings']" />
							<br />
							<span class="whiteSpacer">&#160;</span>
							<br />
							<div class="groupingBox">
								<div id="nicErrorDisplay" class="errorDisplay"></div>
								<xsl:call-template name="nicSettings">
									<xsl:with-param name="oaNetworkInfoDoc" select="$standbyOaNetworkInfo" />
									<xsl:with-param name="oaMode" select="'STANDBY'" />
									<xsl:with-param name="encNum" select="$enclosureNum" />
								</xsl:call-template>
							</div>
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
								<button type='button' onclick='setupOaNetSettings(true,successCallback);'  class='hpButton' id="Button1">
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

