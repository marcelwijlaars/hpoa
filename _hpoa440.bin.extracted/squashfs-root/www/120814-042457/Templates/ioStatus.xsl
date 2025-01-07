<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:param name="stringsDoc" />
	<xsl:param name="netTrayInfoDoc" />
	<xsl:param name="netTrayStatusDoc" />  
	
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:param name="isLocal" />
	<xsl:param name="proxyUrl" />
	<xsl:param name="enclosureNumber" select="''"/>
  
	<xsl:template match="*">

    <xsl:variable name="ioStatus" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus/hpoa:operationalStatus" />
    <xsl:variable name="mgmtUrl" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:urlToMgmt" />
	<xsl:variable name="hasIpv4MgmtUrl">
		<xsl:choose>
			<xsl:when test="$mgmtUrl = 'http://' or $mgmtUrl = 'https://' or $mgmtUrl = 'http:///' or $mgmtUrl = 'https:///' or $mgmtUrl = '' or contains($mgmtUrl, '0.0.0.0') = 'true'">false</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

<!-- 		Interconnect Module Management<br /> -->
		<xsl:value-of select="$stringsDoc//value[@key='interconnectModuleMgmt']" />
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div class="groupingBox">

			<ul>
			<xsl:variable name="currentBayNumber" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:bayNumber" />
			<xsl:variable name="fqdn" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='urlToMgmtFQDN']" />
			<xsl:variable name="hasFqdnUrl">
				<xsl:choose>
					<xsl:when test="not($fqdn) or $fqdn = '' or $fqdn = 'http://' or $fqdn = 'https://' or $fqdn = 'http:///' or $fqdn = 'https:///'">false</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<li>
			<xsl:choose> 
				<!-- FQDN URL should be the default hyperlink -->
				<xsl:when test="$hasFqdnUrl = 'true'">
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
				</xsl:when>

				<!-- FQDN URL is empty, IPv4 mgmt URL should be the default hyperlink -->
				<xsl:when test="$hasFqdnUrl = 'false' and $hasIpv4MgmtUrl = 'true'">
					<xsl:choose>
						<xsl:when test="starts-with($mgmtUrl, '/') and $isLocal='false'">
							<xsl:element name="a">
								<xsl:attribute name="href">
									<xsl:value-of select="concat($proxyUrl, $mgmtUrl)"/>
								</xsl:attribute>
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
				</xsl:when>
			</xsl:choose>

			<xsl:if test="$hasFqdnUrl = 'true' or count($netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]) &gt; 0">
				<!-- empty IPv4 and FQDN URL but having IPv6, show mgmtconsole as text instead of as link -->
        <xsl:if test="$hasFqdnUrl = 'false' and $hasIpv4MgmtUrl = 'false'">
				  <xsl:value-of select="$stringsDoc//value[@key='mgmtconsole']" />
        </xsl:if>
				<xsl:element name="a">
					<xsl:attribute name="devId">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'bay', $currentBayNumber)" />
					</xsl:attribute>
					<xsl:attribute name="target">_blank</xsl:attribute>
					<xsl:attribute name="class">treeSelectableLink</xsl:attribute>
					<xsl:call-template name="urlListTooltip">
						<xsl:with-param name="fqdn" select="$fqdn" />
						<xsl:with-param name="defaultUrl" select="$mgmtUrl" />
						<xsl:with-param name="urlList" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]" />
						<xsl:with-param name="itemProxyUrl" select="$proxyUrl" />
						<xsl:with-param name="isLocal" select="$isLocal" />
					</xsl:call-template>
				</xsl:element>
			</xsl:if>

			<font style="font-size:100%;vertical-align:top;">&#160;*</font>
			</li>

        
				<li>
					<a href="javascript:top.mainPage.getHiddenFrame().selectDevice(bayNum, PM_INTERCONNECT(), encNum, true);">
<!--					Port Mapping Information -->
					<xsl:value-of select="$stringsDoc//value[@key='portMapping-Info']" />
					</a>
				</li>
			</ul>
		</div>
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:variable name="delayRemaining" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus/hpoa:extraData[@hpoa:name='PowerDelayRemaining']" />
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<!-- Status -->
			<xsl:value-of select="$stringsDoc//value[@key='status']" />
			</caption>
			<tbody>
				<tr>
					<th class="propertyName">
					<!-- Status -->
					<xsl:value-of select="$stringsDoc//value[@key='status']" />
					</th>
					<td class="propertyValue">
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$ioStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName">
					<!-- Thermal Status -->
					<xsl:value-of select="$stringsDoc//value[@key='thermalStatus']" />
					</th>
					<td class="propertyValue">
						<xsl:call-template name="getThermalLabel">
							<xsl:with-param name="statusCode" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus/hpoa:thermal" />
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th class="propertyName">
					<!-- Powered -->
					<xsl:value-of select="$stringsDoc//value[@key='statusPowered']" />
					</th>
					<td class="propertyValue">

						<xsl:choose>
							<xsl:when test="number($delayRemaining) &gt; 0">
								<xsl:value-of select="$stringsDoc//value[@key='delayed']" />
							</xsl:when>
							<xsl:when test="number($delayRemaining)=-1">
								<xsl:value-of select="$stringsDoc//value[@key='delayed']" /> - <xsl:value-of select="$stringsDoc//value[@key='noPoweron']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="getPowerLabel">
									<xsl:with-param name="powered" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus/hpoa:powered" />
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
				</tr>

				<xsl:if test="number($delayRemaining) &gt; 0">
					<tr class="altRowColor">
						<th class="propertyName">
							<xsl:value-of select="$stringsDoc//value[@key='delayRemaining']" />
						</th>
						<td class="propertyValue">
							<xsl:value-of select="$delayRemaining"/>
						</td>
					</tr>
				</xsl:if>

			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<xsl:for-each select="$netTrayStatusDoc//hpoa:interconnectTrayStatus">

			<xsl:if test="count(hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED')])&gt;0 and count(hpoa:diagnosticChecks/*[not(node()='NOT_RELEVANT')])&gt;0">
				<xsl:call-template name="diagnosticStatusView">
					<xsl:with-param name="statusCode" select="$ioStatus" />
					<xsl:with-param name="deviceType" select="'INTERCONNECT'" />
				</xsl:call-template>
			</xsl:if>

		</xsl:for-each>
    
    <xsl:if test="$mgmtUrl != 'http://' and $mgmtUrl != 'https://' and $mgmtUrl != 'http:///' and $mgmtUrl != 'https:///' and $mgmtUrl != '' and contains($mgmtUrl, '0.0.0.0') != 'true'">
      <br />
      <font style="font-size:120%;margin-right:3px;"><xsl:value-of select="$stringsDoc//value[@key='asterisk']"/></font>
      <em><xsl:value-of select="$stringsDoc//value[@key='ioMgmtUrlDislaimer']" /></em>
    </xsl:if>    
    
	</xsl:template>



</xsl:stylesheet>
