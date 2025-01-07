<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2012 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:template name="bayAddressRadioGroup">
		<xsl:param name="fqdn" select="''" />
		<xsl:param name="ipv4Address" />
		<xsl:param name="ipv6AddressList" />

		<div id="iloIpv6ErrorDisplay" class="errorDisplay"></div>
		<div class="groupingBox">
			<!-- standard helptooltip element -->
			<div id="helpTooltip" class="popupSmallWrapper">
				<div class="popupSmallTitle"><img alt="" src="/120814-042457/images/icons/help-popup.gif" /></div>
				<div id="tooltipText" class="helpPopupSmallBody"></div>
			</div>

			<em>
				<xsl:value-of select="$stringsDoc//value[@key='iLO-ip-addresses']"/>
			</em><br />
			<span class="whiteSpacer">&#160;</span><br />

			<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
			        <xsl:if test="string-length($fqdn) &gt; 0">
					<tr>
                                                <td valign="top">
                                                        <xsl:element name="input">
                                                                <xsl:attribute name="type">radio</xsl:attribute>
                                                                <xsl:attribute name="name">iloIpAddress</xsl:attribute>
                                                                <xsl:attribute name="id">iloFqdn</xsl:attribute>                                   
								<xsl:attribute name="checked">true</xsl:attribute>
                                                                <xsl:attribute name="value"><xsl:value-of select="$fqdn" /></xsl:attribute>
                                                        </xsl:element>
                                                </td>
                                                <td width="5"></td>
                                                <td valign="middle">
                                                        <label for="iloFqdn"><xsl:value-of select="$fqdn"/></label>
                                                </td>
                                        </tr>
				</xsl:if>

				<xsl:if test="$ipv4Address != '' and $ipv4Address != '0.0.0.0'">
					<tr>
						<td valign="top">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="name">iloIpAddress</xsl:attribute>
								<xsl:attribute name="id">iloIpAddr0</xsl:attribute>
								<xsl:if test="string-length($fqdn) &lt; 1">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value"><xsl:value-of select="$ipv4Address" /></xsl:attribute>
							</xsl:element>
						</td>
						<td width="5"></td>
						<td valign="middle">
							<label for="iloIpAddr0"><xsl:value-of select="$ipv4Address"/></label>
						</td>
					</tr>
				</xsl:if>
          
				<xsl:for-each select="$ipv6AddressList">
					<xsl:variable name="ipv6Addr" select="substring-before(current(), '/')" />
          <xsl:variable name="ipv6Id" select="concat('iloIpAddr', position())" />

					<tr>
						<td valign="top">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="name">iloIpAddress</xsl:attribute>
								<xsl:attribute name="id"><xsl:value-of select="$ipv6Id" /></xsl:attribute>
								<xsl:if test="position() = 1 and ('$ipv4Address' = '' or '$ipv4Address' = '0.0.0.0')">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value"><xsl:value-of select="concat('[', $ipv6Addr, ']')" /></xsl:attribute>
							</xsl:element>
						</td>
						<td width="5"></td>
						<td valign="middle">
							<label for="{$ipv6Id}"><xsl:value-of select="$ipv6Addr" /></label>
							<xsl:choose>
								<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6LLAddress')">
									<em>
										(<xsl:value-of select="$stringsDoc//value[@key='ipv6LinkLocalAddress']" />)
										<xsl:call-template name="errorTooltip">
											<xsl:with-param name="stringsFileKey" select="'iloLLIpv6AccessHelpTip'" />
										</xsl:call-template>
									</em>
								</xsl:when>
								<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6DHCPAddress')">
									<em> (<xsl:value-of select="$stringsDoc//value[@key='ipv6DHCPv6Address']" />) </em>
								</xsl:when>
								<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6SLAACAddress')">
									<em> (<xsl:value-of select="$stringsDoc//value[@key='ipv6SlaacAddress']" />) </em>
								</xsl:when>
								<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6StaticAddress')">
									<em> (<xsl:value-of select="$stringsDoc//value[@key='ipv6StaticAddress']" />) </em>
								</xsl:when>
								<xsl:when test="starts-with(@hpoa:name, 'iLOIPv6EBIPAAddress')">
									<em> (<xsl:value-of select="$stringsDoc//value[@key='ipv6EBIPAAddress']" />) </em>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</div>

	</xsl:template>

</xsl:stylesheet>
