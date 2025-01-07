<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc"  />
	<xsl:param name="mpInfoDoc" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="vlanInfoDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/bayAddressList.xsl" />

	<xsl:template match="*">

		<xsl:variable name="bayNumber" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bayNumber" />
		<xsl:variable name="nBayNumber" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='NormalizedBayNumber']" />
    <xsl:variable name="iloFedCapability">
      <xsl:choose>
        <xsl:when test="count($mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name='BladeIloFederationCapability']) = 0">UNKNOWN</xsl:when>
        <xsl:otherwise><xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name='BladeIloFederationCapability']" /></xsl:otherwise>        
      </xsl:choose>
    </xsl:variable>

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='managementProcInfo']" />
			</caption>
			<TBODY>
				<TR class="altRowColor">
					<TH class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='name']"/></TH>
					<TD class="propertyValue">
						<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:dnsName"/>
					</TD>
				</TR>
				<TR class="">
					<TH class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='address']"/></TH>
					<TD class="propertyValue">
						<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ipAddress"/>
					</TD>
				</TR>
				<TR class="altRowColor">
					<TH class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='macAddress']"/></TH>
					<TD class="propertyValue">
						<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:macAddress"/>
					</TD>
				</TR>
				<TR class="">
					<TH class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='model']"/></TH>
					<TD class="propertyValue">
						<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:modelName"/>
					</TD>
				</TR>
				<TR class="altRowColor">
					<TH class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='firmwareVersion']"/></TH>
					<TD class="propertyValue">
						<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:fwVersion"/>
					</TD>
				</TR>
				<xsl:if test="$vlanInfoDoc//hpoa:vlanInfo/hpoa:vlanEnable='1'">
					<TR>
						<TH class="propertyName">
							<xsl:value-of select="$stringsDoc//value[@key='vlanIdName']"/>
						</TH>
						<TD class="propertyValue">
							<xsl:variable name="vlanId" select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:portArray/hpoa:port[@hpoa:deviceType='SERVER' and @hpoa:bayNumber=$nBayNumber]/hpoa:portVlanId" />
							<xsl:variable name="vlanName" select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg[hpoa:vlanId=$vlanId]/hpoa:vlanName" />
							<xsl:value-of select="$vlanId"/>&#160;<xsl:choose>
								<xsl:when test="$vlanName=''">(<xsl:value-of select="$stringsDoc//value[@key='unnamed']"/>)</xsl:when>
								<xsl:otherwise>(<xsl:value-of select="$vlanName"/>)</xsl:otherwise>
							</xsl:choose>
						</TD>
					</TR>
				</xsl:if>
        <xsl:if test="$iloFedCapability != 'UNKNOWN'">
          <tr>
						<th class="propertyName">
							<xsl:value-of select="$stringsDoc//value[@key='iloFederationCapable']"/>
						</th>
						<td class="propertyValue">
              <xsl:choose>
                <xsl:when test="$iloFedCapability = 'SUPPORTED'"><xsl:value-of select="$stringsDoc//value[@key='yes']" /></xsl:when>
                <xsl:when test="$iloFedCapability = 'UNSUPPORTED'"><xsl:value-of select="$stringsDoc//value[@key='no']" /></xsl:when>
                <xsl:when test="$iloFedCapability = 'UNSUPPORTED_FW'"><xsl:value-of select="$stringsDoc//value[@key='unsupportedFirmware']" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="statusUnknown" /></xsl:otherwise>            
              </xsl:choose>
						</td>
					</tr>
          <!-- tr class="altRowColor">
						<th class="propertyName">
							<xsl:value-of select="$stringsDoc//value[@key='enclosureEnablementForThisServer']"/>
						</th>
						<td class="propertyValue">
              <xsl:choose>
                <xsl:when test="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name='EnclosureBayIloFederationEnabled'] = 'true'"><xsl:value-of select="$stringsDoc//value[@key='yes']" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='no']" /></xsl:otherwise>
              </xsl:choose>
						</td>
					</tr -->
        </xsl:if>
			</TBODY>

		</table>

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:if test="count($mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]) &gt; 0" >

			<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
				<caption>
					<xsl:value-of select="$stringsDoc//value[@key='managementProcIPv6Info']"/>
				</caption>
				<TBODY>
					<xsl:for-each select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]">
						<xsl:variable name="rowClass">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 1">
									altRowColor
								</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<tr class="{$rowClass}">
							<th class="propertyName">
								<xsl:choose>
									<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6LLAddress')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6LinkLocalAddress']" />
									</xsl:when>
									<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6DHCPAddress')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6DHCPv6Address']" />
									</xsl:when>
									<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6SLAACAddress')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6SlaacAddress']" />
									</xsl:when>
									<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6StaticAddress')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6StaticAddress']" />
									</xsl:when>
									<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6EBIPAAddress')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6EBIPAAddress']" />
									</xsl:when>
								</xsl:choose>
							</th>
							<td class="propertyValue">
								<xsl:value-of select="current()" />
							</td>
						</tr>
					</xsl:for-each>
				</TBODY>
			</table>

			<span class="whiteSpacer">&#160;</span><br />
			<span class="whiteSpacer">&#160;</span><br />
		</xsl:if>

		<xsl:variable name="productId" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:productId" />
		<xsl:variable name="ipv4Address" select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ipAddress" />
		<xsl:variable name="fqdn" select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name ='iLOFQDN']" />    
		<xsl:variable name="ipv6Addresses" select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]" />

		<xsl:choose>
			<!-- ProLiant iLO or Integrity iLO3 -->
			<xsl:when test="$productId=8224 or $productId=33282">
				<xsl:value-of select="$stringsDoc//value[@key='iLORemoteMgmt']"/><br />
				<span class="whiteSpacer">&#160;</span><br />
			</xsl:when>
			<!-- AMC Telco Blade -->
			<xsl:when test="$productId='8213'">
				<xsl:value-of select="$stringsDoc//value[@key='remoteMgmt']"/><br />
				<span class="whiteSpacer">&#160;</span><br />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl != '[Unknown]'">
					<xsl:value-of select="$stringsDoc//value[@key='iLORemoteMgmt']"/><br />
					<span class="whiteSpacer">&#160;</span><br />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="count($ipv6Addresses) &gt; 0 or string-length($fqdn) &gt; 0" >
			<xsl:call-template name="bayAddressRadioGroup">
				<xsl:with-param name="fqdn" select="$fqdn"  />
				<xsl:with-param name="ipv4Address" select="$ipv4Address" />
				<xsl:with-param name="ipv6AddressList" select="$ipv6Addresses" />
			</xsl:call-template>

			<span class="whiteSpacer">&#160;</span><br />
		</xsl:if>

		<xsl:choose>
			<!-- ProLiant iLO -->
			<xsl:when test="$productId=8224">

				<div class="groupingBox">

					<em>
						<xsl:value-of select="$stringsDoc//value[@key='iLO-links']"/>
					</em><br />
					<span class="whiteSpacer">&#160;</span><br />

					<em>
						<xsl:value-of select="$stringsDoc//value[@key='iLO-links-popups']"/>
					</em><br />
					<span class="whiteSpacer">&#160;</span><br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:webUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='webAdmin']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='accessiLOweb']"/><br />

					<span class="whiteSpacer">&#160;</span><br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ircUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='integratedRemoteConsole']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='accessKVMandVirPwr']"/><br />

					<span class="whiteSpacer">&#160;</span><br />

					<xsl:if test="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ircFullUrl!=''">
					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ircFullUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='integratedRemoteConsoleFullSc']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='integratedRemoteConsoleFullScDesc']"/><br />

					<span class="whiteSpacer">&#160;</span><br />
					</xsl:if>

					<xsl:if test="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:remoteConsoleUrl!=''">
					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:remoteConsoleUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='remoteConsole']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='accessKVMfromRemoteConsole']"/><br />

					<span class="whiteSpacer">&#160;</span><br />
					</xsl:if>
					<xsl:if test="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:remoteSerialUrl!=''">
					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:remoteSerialUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='iLORemoteSerialConsole']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='iLORemoteSerialConsoleDesc']"/>
					</xsl:if>

				</div>
			</xsl:when>
			<!-- AMC Telco Blade -->
			<xsl:when test="$productId='8213'">

				<div class="groupingBox">

					<em>
						<xsl:value-of select="$stringsDoc//value[@key='iLO-links-popups']"/>
					</em><br />
					<span class="whiteSpacer">&#160;</span><br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onClick">doiLoPage('<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:webUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='managementConsole']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='managementConsoleDesc']"/><br />

				</div>

			</xsl:when>
			<!-- Integrity iLO3 -->
			<xsl:when test="$productId='33282'">

				<div class="groupingBox">

					<em>
						<xsl:value-of select="$stringsDoc//value[@key='iLO-links']"/>
					</em><br />
					<span class="whiteSpacer">&#160;</span><br />

					<em>
						<xsl:value-of select="$stringsDoc//value[@key='iLO-links-popups']"/>
					</em><br />
					<span class="whiteSpacer">&#160;</span><br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:webUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='webAdmin']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='accessiLOweb']"/><br />

					<span class="whiteSpacer">&#160;</span><br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ircUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='integratedRemoteConsole']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='accessKVMandVirPwr']"/><br />

					<span class="whiteSpacer">&#160;</span><br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:remoteSerialUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='iLORemoteSerialConsole']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='iLORemoteSerialConsoleDesc']"/><br />

					<span class="whiteSpacer">&#160;</span><br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name='virtualMediaUrl']"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='virtualMedia']"/>
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='virtualMediaDesc']"/>

				</div>
			</xsl:when>
			<xsl:otherwise>

				<xsl:if test="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl != '[Unknown]'">

					<div class="groupingBox">

						<em>
							<xsl:value-of select="$stringsDoc//value[@key='iLO-links-popups']"/>
						</em><br />
						<span class="whiteSpacer">&#160;</span><br />

						<b>
							<xsl:element name="a">
								<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
								<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '');</xsl:attribute>
								<xsl:value-of select="$stringsDoc//value[@key='webAdmin']"/>
							</xsl:element>
						</b><br />
						<xsl:value-of select="$stringsDoc//value[@key='accessiLOweb']"/><br />

					</div>

				</xsl:if>

			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>
