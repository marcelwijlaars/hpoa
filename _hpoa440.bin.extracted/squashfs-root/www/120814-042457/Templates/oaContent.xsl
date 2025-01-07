<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">
	<xsl:output method="xml" />

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->	
	
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:param name="stringsDoc" />
	<xsl:param name="oaInfoDoc" />
	<xsl:param name="oaStatusDoc" />
	<xsl:param name="oaThermalsDoc" />
	<xsl:param name="oaNetworkInfoDoc" />
	
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="serviceUserOaAccess" />
	
	<xsl:param name="isStandby" />
	
	<xsl:template match="*">

    <xsl:variable name="oaStatus" select="$oaStatusDoc//hpoa:oaStatus/hpoa:operationalStatus" />
    
		<xsl:if test="$oaStatusDoc//hpoa:oaStatus/hpoa:oaRole='STANDBY' and $isStandby='true'">

			<div class="groupingBox">
				<!-- standard helptooltip element -->
				<div id="helpTooltip" class="popupSmallWrapper">
					<div class="popupSmallTitle"><img alt="" src="/120814-042457/images/icons/help-popup.gif" /></div>
					<div id="tooltipText" class="helpPopupSmallBody"></div>
				</div>

				<xsl:variable name="activeBayNum">
					<xsl:choose>
						<xsl:when test="number($oaInfoDoc//hpoa:oaInfo/hpoa:bayNumber)=1">2</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="activeIp" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo[hpoa:bayNumber=$activeBayNum]/hpoa:ipAddress" />
				<xsl:variable name="activeUrlv4" select="concat('https://', $activeIp, '/')" />
				
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td style="vertical-align:top;">
							<img border="0" src="/120814-042457/images/status_informational_32.gif"/>
						</td>
						<td style="padding-left: 10px;">
							<xsl:value-of select="$stringsDoc//value[@key='inStandbyModeAccessActiveOaAt']" />:
							<ul>
								<xsl:if test="$activeIp != '0.0.0.0'">
									<li>
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="$activeUrlv4" /></xsl:attribute>
											<xsl:attribute name="target">_blank</xsl:attribute>
											<xsl:value-of select="$activeUrlv4" />
										</xsl:element>
									</li>
								</xsl:if>
								<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo[hpoa:bayNumber=$activeBayNum]/hpoa:extraData">
									<xsl:if test="string(.) and . != 'NotSet' and starts-with(@hpoa:name, 'Ipv6Address') and not(contains(@hpoa:name, 'Type'))">
										<li>
											<xsl:variable name="url" select="concat('https://[', substring-before(., '/'), ']/')" />
											<xsl:element name="a">
												<xsl:attribute name="href">
													<xsl:value-of select="$url" />
												</xsl:attribute>
												<xsl:attribute name="onclick">window.open('<xsl:value-of select="$url" />');return false;</xsl:attribute>
												<xsl:value-of select="$url" />
											</xsl:element>
											<xsl:if test="starts-with(., $LL_PREFIX)">
												<xsl:call-template name="errorTooltip">
													<xsl:with-param name="stringsFileKey" select="'llIpv6AccessHelpTip'" />
												</xsl:call-template>
											</xsl:if>
										</li>
									</xsl:if>
								</xsl:for-each>
							</ul>
						</td>
					</tr>
				</table>

			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			
		</xsl:if>
		
	    <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" ID="Table7">
	      <tbody>
	        <tr>
	          <th class="propertyName">
				  <xsl:value-of select="$stringsDoc//value[@key='status']" />
			  </th>
	          <td class="propertyValue">
	          	<xsl:call-template name="getStatusLabel">
		          	<xsl:with-param name="statusCode" select="$oaStatus" />
	          	</xsl:call-template>
	          </td>
	        </tr>
			
	        <tr class="altRowColor">
	        	<th class="propertyName">
					    <xsl:value-of select="$stringsDoc//value[@key='role']" />
				    </th>
	        	<td class="propertyValue">
					    <xsl:choose>
						    <xsl:when test="$oaStatusDoc//hpoa:oaStatus/hpoa:oaRole='ACTIVE'">
							    <xsl:value-of select="$stringsDoc//value[@key='active']" />
						    </xsl:when>
						    <xsl:when test="$oaStatusDoc//hpoa:oaStatus/hpoa:oaRole='STANDBY'">
							    <xsl:value-of select="$stringsDoc//value[@key='standby']" />
						    </xsl:when>
							<xsl:when test="$oaStatusDoc//hpoa:oaStatus/hpoa:oaRole='TRANSITION'">
								<xsl:value-of select="$stringsDoc//value[@key='transition']" />
							</xsl:when>
							<xsl:when test="$oaStatusDoc//hpoa:oaStatus/hpoa:oaRole='ABSENT'">
								<xsl:value-of select="$stringsDoc//value[@key='absent']" />
							</xsl:when>
						    <xsl:otherwise>
							    <xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
						    </xsl:otherwise>
					    </xsl:choose>					
	        	</td>
	        </tr>
			  <tr>
				  <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='bayNumber']" />
				  </th>
				  <td class="propertyValue">
					  <xsl:value-of select="$oaStatusDoc//hpoa:oaStatus/hpoa:bayNumber"/>
				  </td>
			  </tr>
			   
			  <xsl:if test="$oaStatusDoc//hpoa:oaStatus/hpoa:oaRole='ACTIVE'">

				  <tr class="altRowColor">
					  <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='temperature']" /></th>
					  <td class="propertyValue">

              <xsl:variable name="tempC" select="$oaThermalsDoc//hpoa:thermalInfo/hpoa:temperatureC" />

              <xsl:choose>
                <xsl:when test="$tempC != 0">

                  <xsl:variable name="tempF">
                    <xsl:call-template name="CtoF">
                      <xsl:with-param name="tempC" select="$tempC" />
                    </xsl:call-template>
                  </xsl:variable>

                  <xsl:value-of select="$tempC"/>&#176;C / <xsl:value-of select="$tempF"/>&#176;F

                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='notAvailable']" />
                </xsl:otherwise>
              </xsl:choose>
              
					  </td>
				  </tr>
				  <tr>
					  <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='cautionThreshold']" /></th>
					  <td class="propertyValue">

              <xsl:variable name="cautionC" select="$oaThermalsDoc//hpoa:thermalInfo/hpoa:cautionThreshold" />

              <xsl:choose>
                <xsl:when test="$cautionC != 0">
                  <xsl:variable name="cautionF">
                    <xsl:call-template name="CtoF">
                      <xsl:with-param name="tempC" select="$cautionC" />
                    </xsl:call-template>
                  </xsl:variable>

                  <xsl:value-of select="$cautionC"/>&#176;C / <xsl:value-of select="$cautionF"/>&#176;F
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='notAvailable']" />
                </xsl:otherwise>
              </xsl:choose>
              
					  </td>
				  </tr>
				  <tr class="altRowColor">
					  <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='criticalThreshold']" /></th>
					  <td class="propertyValue">

              <xsl:variable name="criticalC" select="$oaThermalsDoc//hpoa:thermalInfo/hpoa:criticalThreshold" />

              <xsl:choose>
                <xsl:when test="$criticalC != 0">

                  <xsl:variable name="criticalF">
                    <xsl:call-template name="CtoF">
                      <xsl:with-param name="tempC" select="$criticalC" />
                    </xsl:call-template>
                  </xsl:variable>

                  <xsl:value-of select="$criticalC"/>&#176;C / <xsl:value-of select="$criticalF"/>&#176;F

                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='notAvailable']" />   
                </xsl:otherwise>
              </xsl:choose>
              
					  </td>
				  </tr>
				  
			  </xsl:if>
			
	      </tbody>
	    </table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" ID="Table1">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='information']" />
			</caption>
			<tbody>
				<tr class="altRowColor">
					<th class="propertyName">
						<xsl:value-of select="$stringsDoc//value[@key='deviceName']" />
					</th>
					<td class="propertyValue">
						<xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:name" />
					</td>
				</tr>
			  <tr class="">
				<th class="propertyName">
				  <xsl:value-of select="$stringsDoc//value[@key='manufacturer']" />
				</th>
				<td class="propertyValue">
				  <xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:manufacturer" />
				</td>
			  </tr>
				<tr class="altRowColor">
					<th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='firmwareVersion']" />				 
			  </th>
	          <td class="propertyValue">
	          	<xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:fwVersion" />
       	          	<span class="whiteSpacer">&#160;</span>
                  	<xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:extraData[@hpoa:name='Build']" />
	          </td>
	        </tr>
				<tr class="">
					<th class="propertyName">
						<xsl:value-of select="$stringsDoc//value[@key='hardwareVersion']" />
					</th>
					<td class="propertyValue">
						<xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:hwVersion" />
					</td>
				</tr>
	        <tr class="altRowColor">
	          <th class="propertyName">
				  <xsl:value-of select="$stringsDoc//value[@key='partNumber']" />
			  </th>
	          <td class="propertyValue">
		          <xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:partNumber" />
	          </td>
	        </tr>
			  <tr>
				<th class="propertyName">
				  <xsl:value-of select="$stringsDoc//value[@key='sparePartNumber']" />
				</th>
				<td class="propertyValue">
				  <xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:sparePartNumber" />
				</td>
			  </tr>
			  <tr  class="altRowColor">
				  <th class="propertyName">
					  <xsl:value-of select="$stringsDoc//value[@key='serialNumber']" />
				  </th>
				  <td class="propertyValue">
					  <xsl:value-of select="$oaInfoDoc//hpoa:oaInfo/hpoa:serialNumber" />
				  </td>
			  </tr>
	      </tbody>
	    </table>

		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:for-each select="$oaStatusDoc//hpoa:oaStatus">

			<xsl:if test="count(hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED')])&gt;0 and count(hpoa:diagnosticChecks/*[not(node()='NOT_RELEVANT')])&gt;0">
				<xsl:call-template name="diagnosticStatusView">
					<xsl:with-param name="statusCode" select="$oaStatus" />
				</xsl:call-template>
			</xsl:if>

		</xsl:for-each>
		
	</xsl:template>

</xsl:stylesheet>
