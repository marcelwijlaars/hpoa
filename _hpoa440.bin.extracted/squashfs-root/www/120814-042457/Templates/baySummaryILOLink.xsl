<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:param name="bladeType" />
	<xsl:param name="ipAddress" />
	<xsl:param name="bayNumber" />
	<xsl:param name="webUrl" />
	<xsl:param name="loginUrl" />
	<xsl:param name="mpInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="currentBayNumber" />
	<xsl:param name="productId" />

	<xsl:template match="*">

		<xsl:variable name="isThereBayIPv6">
			<xsl:call-template name="checkIfExistBayIPv6">
				<xsl:with-param name="mpInfoDoc" select="$mpInfoDoc"/>
				<xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="fqdn" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='iLOFQDN']" />
	
		<xsl:choose>
			<xsl:when test="$bladeType='BLADE_TYPE_SERVER'">
				<xsl:choose>
					<xsl:when test="string-length($fqdn) &gt; 0">
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$loginUrl"/>', '<xsl:value-of select="$webUrl"/>', '<xsl:value-of select="$fqdn"/>');</xsl:attribute>
							<xsl:value-of select="$fqdn"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$ipAddress != '' and string-length($fqdn) &lt; 1">
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$loginUrl"/>', '<xsl:value-of select="$webUrl"/>');</xsl:attribute>
							<xsl:value-of select="$ipAddress"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<!--check if there is no IPv6-->
							<xsl:when test="$isThereBayIPv6 = 'true'">
								<xsl:value-of select="$stringsDoc//value[@key='noIPv4Address']" />
							</xsl:when>
							<xsl:otherwise>Unknown</xsl:otherwise>
						  </xsl:choose>
					</xsl:otherwise>
				</xsl:choose>

				  <!--check if there is IPv6-->
				<xsl:if test="$isThereBayIPv6 = 'true' or string-length($fqdn) &gt; 0">
					<xsl:text> </xsl:text> <!--space between the text and the tooltip-->
					<xsl:element name="a">
						<xsl:attribute name="devId">
							<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:loginUrl" />
						</xsl:attribute>
						<xsl:attribute name="target">_blank</xsl:attribute>
						<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

						<xsl:variable name="iLOIPv6UrlList" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]" />
						
						<xsl:variable name="apostrophe">'</xsl:variable>
						<xsl:variable name="customOnClickUrl" select="concat('doiLoSsoHelper(this, ', $apostrophe, $currentBayNumber, $apostrophe, ',', $apostrophe, $loginUrl, $apostrophe, ',', $apostrophe, $webUrl, $apostrophe, ',', $apostrophe, $productId, $apostrophe, ',', $apostrophe, $ipAddress, $apostrophe, ');')" />

						<xsl:call-template name="urlListTooltip">
							<xsl:with-param name="fqdn" select="$fqdn" />
							<xsl:with-param name="defaultUrl" select="$ipAddress" />
							<xsl:with-param name="urlList" select="$iLOIPv6UrlList" />
							<xsl:with-param name="customOnClickUrl" select="$customOnClickUrl" />
						</xsl:call-template>
					</xsl:element>
				</xsl:if>

			</xsl:when>
			<xsl:otherwise>
				N/A
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

</xsl:stylesheet>
