<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:template name="treeInterconnectLeaf">

		<xsl:param name="enclosureNumber" />

		<xsl:element name="div">

			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="hpoa:presence=$PRESENT">display:block;</xsl:when>
					<xsl:otherwise>display:none;</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:attribute name="class">treeClosed</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'interconnect', hpoa:bayNumber, 'leafWrapper')"/></xsl:attribute>

			<xsl:call-template name="treeInterconnectLeafInternal">
				<xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
			</xsl:call-template>
			
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="treeInterconnectLeafInternal">

		<xsl:param name="enclosureNumber" />
		
		<div class="treeControl">
			<div class="treeDisclosure"></div>
			<xsl:element name="div">

				<xsl:attribute name="class">treeStatusIcon</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'interconnect', hpoa:bayNumber, 'Status')"/></xsl:attribute>
				
				<xsl:if test="hpoa:operationalStatus != $OP_STATUS_OK">
					<xsl:call-template name="statusIcon">
						<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
					</xsl:call-template>
				</xsl:if>
				
			</xsl:element>
		</div>
		<xsl:element name="div">
			<xsl:attribute name="class">treeTitle</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'interconnect', hpoa:bayNumber, 'Select')"/></xsl:attribute>
			<xsl:element name="a">

				<xsl:attribute name="devId"><xsl:value-of select="concat('enc', $enclosureNumber, 'interconnect', hpoa:bayNumber, 'Select')" /></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'interconnect', hpoa:bayNumber, 'Label')"/></xsl:attribute>
				<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
				<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
				<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

				<xsl:attribute name="devNum"><xsl:value-of select="hpoa:bayNumber" /></xsl:attribute>
				<xsl:attribute name="devType">interconnect</xsl:attribute>
				<xsl:attribute name="encNum"><xsl:value-of select="$enclosureNumber" /></xsl:attribute>

        <!-- Modifed 2-8-2006 mds -->
        <xsl:variable name="ioBay">
          <xsl:value-of select="hpoa:bayNumber"/>
        </xsl:variable>
        
        <xsl:variable name="linkValue">
          <xsl:value-of select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber = $ioBay]/hpoa:name"/>
        </xsl:variable>
        
        <!-- uncomment to add tooltips to links with very long text 
        <xsl:if test="string-length($linkValue) &gt; 30">
          <xsl:attribute name="title"><xsl:value-of select="$linkValue"/></xsl:attribute>
        </xsl:if>-->
        
        <xsl:choose>
          <xsl:when test="$linkValue = ''">
            <xsl:value-of select="concat(hpoa:bayNumber, '. Unknown Device')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(hpoa:bayNumber, '. ', $linkValue)"/>
          </xsl:otherwise>
        </xsl:choose>      

      </xsl:element>
		</xsl:element>

		<xsl:variable name="bayNumber" select="hpoa:bayNumber" />
		
		<div class="treeContents">
			
			<xsl:element name="div">

				<xsl:attribute name="class">leaf</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="concat('enc', $enclosureNumber, 'pm_interconnect', hpoa:bayNumber, 'Select')" />
				</xsl:attribute>

				<xsl:element name="a">

					<xsl:attribute name="devId">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'pm_interconnect', hpoa:bayNumber, 'Select')" />
					</xsl:attribute>
					<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
					<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
					<xsl:attribute name="class">treeSelectableLink</xsl:attribute>

					<xsl:attribute name="devNum">
						<xsl:value-of select="hpoa:bayNumber" />
					</xsl:attribute>
					<xsl:attribute name="devType">pm_interconnect</xsl:attribute>
					<xsl:attribute name="encNum">
						<xsl:value-of select="$enclosureNumber" />
					</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='portMapping']" />
<!--					Port Mapping -->

				</xsl:element>
			</xsl:element>

			<xsl:variable name="mgmtUrl" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:urlToMgmt" />
			<xsl:variable name="hasIpv4MgmtUrl">
				<xsl:choose>
					<xsl:when test="$mgmtUrl = 'http://' or $mgmtUrl = 'https://' or $mgmtUrl = 'http:///' or $mgmtUrl = 'https:///' or $mgmtUrl = '' or contains($mgmtUrl, '0.0.0.0') = 'true'">false</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="fqdn" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[@hpoa:name='urlToMgmtFQDN']" />

			<xsl:element name="div">
				<xsl:attribute name="class">leaf</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="concat('enc', $enclosureNumber, 'mc_interconnect', hpoa:bayNumber, 'Select')" />
				</xsl:attribute>

				<xsl:if test="$hasIpv4MgmtUrl = 'false' and (count($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber = $bayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]) = 0) and string-length($fqdn) &lt; 1">
					<xsl:attribute name="style">display:none;</xsl:attribute>
				</xsl:if>

				<xsl:element name="a">
					<xsl:attribute name="devId">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'mc_interconnect', hpoa:bayNumber, 'Select')" />
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'mc_interconnect', hpoa:bayNumber, 'Link')" />
					</xsl:attribute>

					<xsl:attribute name="class">treeSelectableLink</xsl:attribute>
					<!-- FQDN URL is empty, make IPv4 mgmt URL as the default hyperlink -->
					<xsl:if test="string-length($fqdn) &lt; 1 and $hasIpv4MgmtUrl = 'true'">
						<xsl:choose>
							<xsl:when test="starts-with($mgmtUrl, '/') and $isLocal='false'">
								<xsl:attribute name="href">
									<xsl:value-of select="concat($proxyUrl, $mgmtUrl)"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="href">
									<xsl:value-of select="$mgmtUrl"/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<!-- FQDN URL is present, make it the default hyperlink -->
					<xsl:if test="string-length($fqdn) &gt; 0">
						<xsl:choose>
							<xsl:when test="starts-with($fqdn, '/') and $isLocal='false'">
								<xsl:attribute name="href">
									<xsl:value-of select="concat($proxyUrl, $fqdn)"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="href">
									<xsl:value-of select="$fqdn"/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<xsl:attribute name="target">_blank</xsl:attribute>

					<!-- Management Console -->
					<xsl:value-of select="$stringsDoc//value[@key='mgmtconsole']" />
					<xsl:if test="count($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]) &gt; 0 or string-length($fqdn) &gt; 0">
						<xsl:call-template name="urlListTooltip">
							<xsl:with-param name="fqdn">
								<xsl:if test="string-length($fqdn) &gt; 0"><xsl:value-of select="$fqdn"/></xsl:if>
							</xsl:with-param>
							<xsl:with-param name="defaultUrl">
								<xsl:if test="$hasIpv4MgmtUrl = 'true'"><xsl:value-of select="$mgmtUrl"/></xsl:if>
							</xsl:with-param>
							<xsl:with-param name="urlList" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]"/>
							<xsl:with-param name="itemProxyUrl" select="$proxyUrl"/>
							<xsl:with-param name="isLocal" select="$isLocal"/>
						</xsl:call-template>
					</xsl:if>

				</xsl:element>
			</xsl:element>
		</div>

	</xsl:template>

	<!--
	Template used when the enclosure has not been logged into.  The template
	displays the top level of the enclosure tree with one child node indicating
	that the enclosure information is not authorized.
	-->
	<xsl:template name="enclosureNotAuthorized">
		<div class="treeControl">
			<div class="treeStatusIcon">
				<img src="/120814-042457/images/icon_status_informational.gif"/>
			</div>
			<div class="treeDisclosure"></div>
		</div>

		<xsl:variable name="hashLink">
			<xsl:value-of select="concat('rackOverview.html#enc', $enclosureNumber)" />
		</xsl:variable>

		<xsl:element name="div">
			<xsl:attribute name="class">treeTitle</xsl:attribute>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('enc', $enclosureNumber, 'enc', $enclosureNumber, 'Select')" />
			</xsl:attribute>

			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="$hashLink" />
				</xsl:attribute>
				<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
				<xsl:attribute name="onclick">clearHighlight();top.mainPage.getStatusContainer().showStatus(false);try{if(top.getCurrentUserContext()==UserContextTypes.RackOverview){top.mainPage.getContentContainer().showEnclosureSignIn(<xsl:value-of select="$enclosureNumber" />);}}catch(e){}</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$isAuthenticated='true'">
						<xsl:value-of select="$stringsDoc//value[@key='linkedLoggedIn']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$stringsDoc//value[@key='linkedNotLoggedIn']" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
