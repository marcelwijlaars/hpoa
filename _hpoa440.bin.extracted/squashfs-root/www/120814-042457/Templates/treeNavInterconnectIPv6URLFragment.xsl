<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
	(C) Copyright 2013 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:output method="html" />

	<xsl:param name="stringsDoc" />

	<xsl:param name="enclosureNumber" />
	<xsl:param name="isAuthenticated" />
	<xsl:param name="isLoaded" />

	<!-- Current service username and Access Control Level. -->
	<xsl:param name="netTrayInfoDoc" />

	<xsl:param name="proxyUrl" />
	<xsl:param name="isLocal" />
	<xsl:param name="bayNumber" />

	<!--
	Include the gui and enclosure connstants files.
	NOTE: The enclosure constants file is dependant on the $enclosureInfoDoc variable.
	-->
	<xsl:include href="../Templates/guiConstants.xsl" />

	<!-- Include the global templates file -->
	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/escape-uri.xsl" />
	<xsl:include href="../Templates/treeInterconnectLeaf.xsl" />

	<xsl:template match="*">
		<xsl:choose>
			<xsl:when test="$isAuthenticated='true' and $isLoaded='true'">
				<xsl:call-template name="treeNavInterconnectIPv6URLFragment" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="enclosureNotAuthorized" />    
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="treeNavInterconnectIPv6URLFragment">
		<xsl:variable name="mgmtUrl" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:urlToMgmt" />
		<xsl:variable name="hasIpv4MgmtUrl">
			<xsl:choose>
				<xsl:when test="$mgmtUrl = 'http://' or $mgmtUrl = 'https://' or $mgmtUrl = 'http:///' or $mgmtUrl = 'https:///' or $mgmtUrl = '' or contains($mgmtUrl, '0.0.0.0') = 'true'">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fqdn" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[@hpoa:name='urlToMgmtFQDN']" />
		<xsl:variable name="hasFqdnUrl">
			<xsl:choose>
				<xsl:when test="not($fqdn) or $fqdn = '' or $fqdn = 'http://' or $fqdn = 'https://' or $fqdn = 'http:///' or $fqdn = 'https:///'">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
    <xsl:variable name="showMgmtLink">
      <xsl:choose>
        <xsl:when test="$hasIpv4MgmtUrl = 'true' or $hasFqdnUrl = 'true' or (count($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber = $bayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]) &gt; 0)">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

		<xsl:element name="a">
			<xsl:attribute name="devId">
				<xsl:value-of select="concat('enc', $enclosureNumber, 'mc_interconnect', $bayNumber, 'Select')" />
			</xsl:attribute>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('enc', $enclosureNumber, 'mc_interconnect', $bayNumber, 'Link')" />
			</xsl:attribute>
      <xsl:attribute name="show-mgmt-link">
        <xsl:value-of select="$showMgmtLink" />
      </xsl:attribute>

			<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

			<!-- FQDN URL should be the default hyperlink -->
			<xsl:if test="$hasFqdnUrl = 'true'">
				<xsl:choose>
					<xsl:when test="starts-with($fqdn, '/') and $isLocal='false'">
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:value-of select="concat($proxyUrl, $fqdn)"/>
							</xsl:attribute>
							<xsl:attribute name="target">_blank</xsl:attribute>
							<!-- Management Console -->
							<xsl:value-of select="$stringsDoc//value[@key='mgmtconsole']" />
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:value-of select="$fqdn"/>
							</xsl:attribute>
							<xsl:attribute name="target">_blank</xsl:attribute>
							<!-- Management Console -->
							<xsl:value-of select="$stringsDoc//value[@key='mgmtconsole']" />
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<!-- FQDN URL is empty, IPv4 mgmt URL should be the default hyperlink -->
			<xsl:if test="$hasFqdnUrl = 'false' and $hasIpv4MgmtUrl = 'true'">
				<xsl:choose>
					<xsl:when test="starts-with($mgmtUrl, '/') and $isLocal='false'">
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:value-of select="concat($proxyUrl, $mgmtUrl)"/>
	`						</xsl:attribute>
							<xsl:attribute name="target">_blank</xsl:attribute>
							<!-- Management Console -->
							<xsl:value-of select="$stringsDoc//value[@key='mgmtconsole']" />
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:value-of select="$mgmtUrl"/>
							</xsl:attribute>
							<xsl:attribute name="target">_blank</xsl:attribute>
							<!-- Management Console -->
							<xsl:value-of select="$stringsDoc//value[@key='mgmtconsole']" />
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<xsl:if test="$hasFqdnUrl = 'true' or count($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]) &gt; 0">
				<!-- empty IPv4 and FQDN URL but having IPv6, show mgmtconsole as text instead of as link -->
        <xsl:if test="$hasFqdnUrl = 'false' and $hasIpv4MgmtUrl = 'false'">
          <xsl:value-of select="$stringsDoc//value[@key='mgmtconsole']" />
        </xsl:if>				
        <xsl:call-template name="urlListTooltip">
					<xsl:with-param name="fqdn">
						<xsl:if test="$hasFqdnUrl = 'true'">
							<xsl:value-of select="$fqdn" />
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="defaultUrl">
							<xsl:if test="$hasIpv4MgmtUrl = 'true'"><xsl:value-of select="$mgmtUrl"/></xsl:if> <!-- otherwise, empty -->
						</xsl:with-param>
					<xsl:with-param name="urlList" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]"/>
					<xsl:with-param name="itemProxyUrl" select="$proxyUrl"/>
					<xsl:with-param name="isLocal" select="$isLocal"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>

