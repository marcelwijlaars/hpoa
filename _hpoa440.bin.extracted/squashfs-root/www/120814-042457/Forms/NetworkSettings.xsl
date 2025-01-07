<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
    <xsl:template name="networkSettings">
		 <xsl:param name="stringsDoc" />
		 <xsl:param name="oaNetworkInfoDoc" />
		 <xsl:param name="vlanInfoDoc" />
		 <xsl:param name="readOnly" select="false()" />
		
		<xsl:variable name="dhcpEnabled" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dhcpEnabled='true'" />
		
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">IPSetting</xsl:attribute>
						<xsl:attribute name="value">DHCP</xsl:attribute>
						<xsl:attribute name="id">DHCP</xsl:attribute>
						<xsl:attribute name="class">stdRadioButton</xsl:attribute>
						<xsl:if test="$dhcpEnabled">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="onclick">toggleFormEnabled('dhcpContainer', this.checked);toggleFormEnabled('staticContainer', !this.checked);</xsl:attribute>
					</xsl:element>
					<label for="DHCP">
						<xsl:value-of select="$stringsDoc//value[@key='dhcp']" />
					</label>
					<br />
					<div id="dhcpContainer">
						<blockquote>
							<xsl:element name="input">
								<xsl:attribute name="type">checkbox</xsl:attribute>
								<xsl:attribute name="class">stdCheckBox</xsl:attribute>
								<xsl:attribute name="name">DDNS</xsl:attribute>
								<xsl:attribute name="id">DDNS</xsl:attribute>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dynDnsEnabled='true'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:if test="not($dhcpEnabled)">
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:if>
							</xsl:element>
							<label for="DDNS">
								<xsl:value-of select="$stringsDoc//value[@key='dynDNS']" />
							</label>
						</blockquote>
					</div>
					
				</td>
			</tr>
		</table>

		<hr />

		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
          <div id="netErrorDisplay" class="errorDisplay"></div>
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">IPSetting</xsl:attribute>
						<xsl:attribute name="value">Static</xsl:attribute>
						<xsl:attribute name="id">Static</xsl:attribute>
						<xsl:attribute name="class">stdRadioButton</xsl:attribute>
						<xsl:if test="not($dhcpEnabled)">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="onclick">toggleFormEnabled('dhcpContainer', !this.checked);toggleFormEnabled('staticContainer', this.checked);</xsl:attribute>
					</xsl:element>
					<label for="Static">
						<xsl:value-of select="$stringsDoc//value[@key='staticIPSettings']" />
					</label>
					<br />
					<div id="staticContainer">

						<blockquote>
							<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ID="Table4">
								<TR>
									<TD>
										<span id="ipAddressLabel">
											<xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" />*
										</span>
									</TD>
									<TD width="10">&#160;</TD>
									<TD>
										<xsl:element name="input">
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="name">ipAddress</xsl:attribute>
											<xsl:attribute name="id">ipAddress</xsl:attribute>                      
											<xsl:attribute name="maxlength">15</xsl:attribute>
                      <!-- validation: required, IP Address -->
					            <xsl:attribute name="validate-netSettings">true</xsl:attribute>
					            <xsl:attribute name="rule-list">1;2</xsl:attribute>
					            <xsl:attribute name="caption-label">ipAddressLabel</xsl:attribute>   
											<xsl:attribute name="value">
												<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:ipAddress" />
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="$dhcpEnabled">
													<xsl:attribute name="disabled">true</xsl:attribute>
													<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">stdInput</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>										
										</xsl:element>
									</TD>
								</TR>
								<tr>
									<td colspan="3" class="formSpacer">&#160;</td>
								</tr>
								<TR>
									<TD>
										<span id="subnetMaskLabel">
											<xsl:value-of select="$stringsDoc//value[@key='subnetMask:']" />*
										</span>
									</TD>
									<TD width="10">&#160;</TD>
									<TD>
										<xsl:element name="input">
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="name">subnetMask</xsl:attribute>
											<xsl:attribute name="id">subnetMask</xsl:attribute>
                      <!-- validation: required, IP Address -->
			                <xsl:attribute name="validate-netSettings">true</xsl:attribute>
			                <xsl:attribute name="rule-list">1;2</xsl:attribute>
			                <xsl:attribute name="caption-label">subnetMaskLabel</xsl:attribute>
                      <xsl:attribute name="maxlength">15</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:netmask" />
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="$dhcpEnabled">
													<xsl:attribute name="disabled">true</xsl:attribute>
													<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">stdInput</xsl:attribute>                          
												</xsl:otherwise>
											</xsl:choose>																					
										</xsl:element>
									</TD>
								</TR>
								<tr>
									<td colspan="3" class="formSpacer">&#160;</td>
								</tr>
								<TR>
									<TD>
										<span id="gatewayLabel">
											<xsl:value-of select="$stringsDoc//value[@key='gateway:']" />
										</span>
									</TD>
									<TD width="10">&#160;</TD>
									<TD>
										<xsl:element name="input">
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="name">gateway</xsl:attribute>
											<xsl:attribute name="id">gateway</xsl:attribute>
                      <!-- validation: optional IP address -->
			                <xsl:attribute name="validate-netSettings">true</xsl:attribute>
			                <xsl:attribute name="rule-list">0;2</xsl:attribute>
			                <xsl:attribute name="caption-label">gatewayLabel</xsl:attribute>
                      <xsl:attribute name="maxlength">15</xsl:attribute>
											<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:gateway!=$EMPTY_IP_TEST">
												<xsl:attribute name="value">
													<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:gateway" />
												</xsl:attribute>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="$dhcpEnabled">
													<xsl:attribute name="disabled">true</xsl:attribute>
													<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">stdInput</xsl:attribute>                          
												</xsl:otherwise>
											</xsl:choose>											
										</xsl:element>
									</TD>
								</TR>
								<tr>
									<td colspan="3" class="formSpacer">&#160;</td>
								</tr>
								<TR>
									<TD>
										<span id="dnsAddress1Label">
											<xsl:value-of select="$stringsDoc//value[@key='dnsServer']" /> 1:
										</span>
									</TD>
									<TD width="10">&#160;</TD>
									<TD>
										<xsl:element name="input">
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="name">dnsAddress1</xsl:attribute>
											<xsl:attribute name="id">dnsAddress1</xsl:attribute>
                      <!-- validation: optional IP address -->
			                <xsl:attribute name="validate-netSettings">true</xsl:attribute>
			                <xsl:attribute name="rule-list">0;2</xsl:attribute>
			                <xsl:attribute name="caption-label">dnsAddress1Label</xsl:attribute>  
                      <xsl:attribute name="maxlength">15</xsl:attribute>
											<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=1]!=$EMPTY_IP_TEST">
												<xsl:attribute name="value">
													<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=1]" />
												</xsl:attribute>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="$dhcpEnabled">
													<xsl:attribute name="disabled">true</xsl:attribute>
													<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">stdInput</xsl:attribute>                          
												</xsl:otherwise>
											</xsl:choose>		
										</xsl:element>
									</TD>
								</TR>
								<tr>
									<td colspan="3" class="formSpacer">&#160;</td>
								</tr>
								<TR>
									<TD>
										<span id="dnsAddress2Label">
											<xsl:value-of select="$stringsDoc//value[@key='dnsServer']" /> 2:
										</span>
									</TD>
									<TD width="10">&#160;</TD>
									<TD>
										<xsl:element name="input">
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="name">dnsAddress2</xsl:attribute>
											<xsl:attribute name="id">dnsAddress2</xsl:attribute>
                      <!-- validation: optional;IP address;unique;depends on dns1 -->
			                <xsl:attribute name="validate-netSettings">true</xsl:attribute>
			                <xsl:attribute name="rule-list">0;2;12;13</xsl:attribute>
                      <xsl:attribute name="related-inputs">dnsAddress1</xsl:attribute>
                      <xsl:attribute name="related-labels">dnsAddress1Label</xsl:attribute>
			                <xsl:attribute name="caption-label">dnsAddress2Label</xsl:attribute> 
                      <xsl:attribute name="maxlength">15</xsl:attribute>
											<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=2]!=$EMPTY_IP_TEST">
												<xsl:attribute name="value">
													<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dns/hpoa:ipAddress[position()=2]" />
												</xsl:attribute>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="$dhcpEnabled">
													<xsl:attribute name="disabled">true</xsl:attribute>
													<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">stdInput</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>										
										</xsl:element>
									</TD>
								</TR>
							</TABLE>
						</blockquote>
						
					</div>
					
                </td>
            </tr>
        </table>
		
    </xsl:template>

	<xsl:template name="advancedNicSettings">
		<xsl:param name="oaNetworkInfoDoc" />
		<xsl:param name="oaMode" select="'ACTIVE'" />
	
		<xsl:variable name="inputId" select="concat('dnsOverride', $oaMode)" />
		<xsl:element name="input">
			<xsl:attribute name="type">checkbox</xsl:attribute>
			<xsl:attribute name="class">stdCheckBox</xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="$inputId" /></xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$inputId" /></xsl:attribute>
			<xsl:attribute name="onclick">toggleFormEnabled('<xsl:value-of select="concat('dnSetting_', $oaMode)" />', !this.checked);</xsl:attribute>
			<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='false'">
				<xsl:attribute name="checked">true</xsl:attribute>
			</xsl:if>
		</xsl:element>
		<xsl:element name="label">
			<xsl:attribute name="for"><xsl:value-of select="$inputId" /></xsl:attribute>
			<xsl:value-of select="$stringsDoc//value[@key='useDhcpDN']" />
		</xsl:element>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<xsl:value-of select="$stringsDoc//value[@key='domainName:']" />
				</td>
				<td width="10">&#160;</td>
				<xsl:element name="td">
					<xsl:attribute name="id"><xsl:value-of select="concat('dnSetting_', $oaMode)" /></xsl:attribute>
					<xsl:element name="input">
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of select="concat('overrideDn_', $oaMode)" /></xsl:attribute>
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='true'">stdInput</xsl:when>
								<xsl:otherwise>stdInputDisabled</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='false'">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="value">
							<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='user_domain_name']" />
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</tr>
			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="nicSettings">
		<xsl:param name="oaNetworkInfoDoc" />
		<xsl:param name="oaMode" select="'ACTIVE'" />
		<xsl:param name="encNum" select="1" />
		<xsl:param name="readOnly" select="false()" />

		<xsl:variable name="nicLinkForced" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICLinkForced']" />
		
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>

					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="concat($oaMode, 'fullAutoSetting', $encNum)"/></xsl:attribute>
						<!--<xsl:attribute name="id">fullAutoSetting_Auto</xsl:attribute>-->
						<xsl:attribute name="id"><xsl:value-of select="concat($oaMode, 'fullAutoSetting_Auto', $encNum)"/></xsl:attribute>
						<xsl:attribute name="onclick">toggleFormEnabled('<xsl:value-of select="concat($oaMode, 'nicSettingsContainer', $encNum)"/>', !this.checked);</xsl:attribute>
						<xsl:if test="$nicLinkForced = 'false'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
					</xsl:element>

				</td>
				<td width="10">&#160;</td>
				<td>
					<label for="{concat($oaMode, 'fullAutoSetting_Auto', $encNum)}">
					<!--<label for="fullAutoSetting_Auto">-->
						<xsl:value-of select="$stringsDoc//value[@key='autoNeg']" />
					</label>
				</td>
			</tr>
			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>
			<tr>
				<td>

					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="concat($oaMode, 'fullAutoSetting', $encNum)"/></xsl:attribute>
						<!--<xsl:attribute name="id">fullAutoSetting_Full</xsl:attribute>-->
						<xsl:attribute name="id"><xsl:value-of select="concat($oaMode, 'fullAutoSetting_Full', $encNum)"/></xsl:attribute>
						<xsl:attribute name="onclick">toggleFormEnabled('<xsl:value-of select="concat($oaMode, 'nicSettingsContainer', $encNum)"/>', this.checked);</xsl:attribute>
						<xsl:if test="$nicLinkForced = 'true'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
					</xsl:element>

				</td>
				<td width="10">&#160;</td>
				<td>
					<!--<label for="fullAutoSetting_Full">-->
					<label for="{concat($oaMode, 'fullAutoSetting_Full', $encNum)}">
						<xsl:value-of select="$stringsDoc//value[@key='forcedFull']" />
					</label>
				</td>
			</tr>
		</table>
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

			<xsl:element name="div">
				<xsl:attribute name="id"><xsl:value-of select="concat($oaMode, 'nicSettingsContainer', $encNum)"/></xsl:attribute>
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='nicSpeed:']" />
						</td>
						<td width="10">&#160;</td>
						<td>
							<xsl:element name="select">
								<xsl:attribute name="id"><xsl:value-of select="concat($oaMode, 'nicSpeedSelect', $encNum)"/></xsl:attribute>
								<xsl:attribute name="name">nicSpeedSelect</xsl:attribute>

								<xsl:if test="$nicLinkForced = 'false'">
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:if>

								<xsl:element name="option">
									<xsl:attribute name="value">NIC_SPEED_10</xsl:attribute>
									<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_10'">
										<xsl:attribute name="selected">true</xsl:attribute>
									</xsl:if>
									10Mbps
								</xsl:element>
								<xsl:element name="option">
									<xsl:attribute name="value">NIC_SPEED_100</xsl:attribute>
									<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_100'">
										<xsl:attribute name="selected">true</xsl:attribute>
									</xsl:if>
									100Mbps
								</xsl:element>
								
							</xsl:element>

						</td>
					</tr>
					
				</table>
			</xsl:element>

		
	</xsl:template>

</xsl:stylesheet>

