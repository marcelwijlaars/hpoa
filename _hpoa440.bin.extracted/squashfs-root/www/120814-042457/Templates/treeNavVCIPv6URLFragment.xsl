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
  <xsl:param name="vcmInfoDoc" />
  <xsl:param name="activeOaNetworkInfo" />
  <xsl:param name="netTrayInfoDoc" />

  <xsl:param name="proxyUrl" />
  <xsl:param name="isLocal" />

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
        <xsl:call-template name="treeNavVCIPv6URLFragment" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="enclosureNotAuthorized" />    
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name="treeNavVCIPv6URLFragment">
   	<!-- VCM component -->
	<!-- If the IPv4 address field is not empty -->
	<xsl:variable name="vcmHasIpv4Address">
		<xsl:choose>
			<xsl:when test="$vcmInfoDoc//hpoa:vcmUrl != 'empty' and $vcmInfoDoc//hpoa:vcmUrl != ''">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- If IPv6 is enabled and if there are non-empty IPv6 addresses to be displayed -->
	<xsl:variable name="vcmHasIpv6Address">
		<xsl:choose>
			<xsl:when test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true' and count($vcmInfoDoc//hpoa:extraData[@hpoa:name='IPv6URL']/text()) &gt; 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="vcmfqdn" select="$vcmInfoDoc//hpoa:extraData[@hpoa:name='VCMFQDNURL']" />
	<!-- If the FQDN address field is not empty -->
	<xsl:variable name="vcmHasFqdnAddress">
		<xsl:choose>
			<xsl:when test="string-length($vcmfqdn) &gt; 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="$vcmHasIpv4Address='true' or $vcmHasIpv6Address='true' or $vcmHasFqdnAddress='true'">
			<div class="leafWrapper">
				<xsl:element name="div">
					<xsl:attribute name="class">leaf</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'vcm', '1', 'Select')" />
					</xsl:attribute>
					<xsl:element name="a">
						<xsl:attribute name="devId">
							<xsl:value-of select="concat('enc', $enclosureNumber, 'vcm', '1', 'Select')" />
						</xsl:attribute>
						<xsl:if test="$vcmHasFqdnAddress='true'">
							<xsl:attribute name="href">
								<xsl:value-of select="$vcmfqdn" />
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="$vcmHasFqdnAddress='false' and $vcmHasIpv4Address='true'">
							<xsl:attribute name="href">
								<xsl:value-of select="$vcmInfoDoc//hpoa:vcmUrl" />
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="target">_blank</xsl:attribute>
						<xsl:attribute name="class">treeSelectableLink</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='vcManager']" />
						<xsl:if test="$vcmHasIpv6Address='true' or $vcmHasFqdnAddress='true'">
						  <xsl:call-template name="urlListTooltip">
							<xsl:with-param name="fqdn" select="$vcmfqdn" />
							<xsl:with-param name="defaultUrl" select="$vcmInfoDoc//hpoa:vcmUrl" />
							<xsl:with-param name="urlList" select="$vcmInfoDoc//hpoa:extraData[@hpoa:name='IPv6URL']" />
							<xsl:with-param name="itemProxyUrl" select="$proxyUrl" />
							<xsl:with-param name="isLocal" select="$isLocal" />
						  </xsl:call-template>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</div>
	</xsl:if>

	</xsl:template>

</xsl:stylesheet>

