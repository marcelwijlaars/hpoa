<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="stringsDoc" />
	<xsl:param name="encName" />
	<xsl:param name="bayNum" />
	<xsl:param name="encNum" />
	<xsl:param name="oaMode" />
	<xsl:param name="oaNetworkInfoDoc" />
	<xsl:param name="oaStatusDoc" />
	<xsl:param name="isWizard" />
  <xsl:param name="masterMode" select="''" />
	
	<xsl:include href="../../Templates/guiConstants.xsl"/>

	<xsl:template match="*">
      
    <xsl:variable name="activeId">
      <xsl:value-of select="concat('(', $encName, ' (', $stringsDoc//value[@key='active'], '))')"/>
    </xsl:variable>
    <xsl:variable name="standbyId">
      <xsl:value-of select="concat('(', $encName, ' (', $stringsDoc//value[@key='standby'], '))')"/>
    </xsl:variable>

		<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo">

			<xsl:variable name="dhcpEnabled">
        <xsl:choose>
          <xsl:when test="$masterMode=''"><xsl:value-of select="string(hpoa:dhcpEnabled='true')" /></xsl:when>  
          <xsl:otherwise><xsl:value-of select="string($masterMode='dhcp')" /></xsl:otherwise>
        </xsl:choose> 
      </xsl:variable>

			<table cellpadding="0" cellspacing="0" border="0">

				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('lbl', $oaMode, 'DnsName', $encNum)"/>
						</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='dnsHostName*:']" />
					</xsl:element>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">

							<!-- This field should never be disabled. -->
							<xsl:attribute name="class">stdInput</xsl:attribute>

							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="caption-label">
								<xsl:value-of select="concat('lbl', $oaMode, 'DnsName', $encNum)"/>
							</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($oaMode, 'DnsName', $encNum)"/>
							</xsl:attribute>
							<xsl:attribute name="maxlength">32</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$oaStatusDoc//hpoa:oaStatus/hpoa:oaName"/>
							</xsl:attribute>
              <!-- validation: required, string, no spaces, 1 to 32 characters -->
              <xsl:attribute name="validate-dns">true</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$oaMode='ACTIVE'">
                  <xsl:attribute name="unique-id"><xsl:value-of select="$activeId" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$standbyId" /></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
							<xsl:attribute name="rule-list">6;8</xsl:attribute>
              <xsl:attribute name="range">1;32</xsl:attribute>
              
							<xsl:attribute name="caption-label">
								<xsl:value-of select="concat('lbl', $oaMode, 'DnsName', $encNum)"/>
							</xsl:attribute>            
              
						</xsl:element>
						<xsl:element name="input">
							<xsl:attribute name="type">hidden</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($oaMode, 'BayNumber', $encNum)"/>
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$bayNum"/>
							</xsl:attribute>
						</xsl:element>
					</td>
				</tr>
				<xsl:if test="not($isWizard) or ($isWizard = 'false')">
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<tr>
						<xsl:element name="td">
							<xsl:value-of select="$stringsDoc//value[@key='macAddress:']" />
						</xsl:element>
						<td width="10">&#160;</td>
						<td>
							<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:macAddress" />
						</td>
					</tr>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
          <xsl:if test="count($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']) &gt; 0">
					  <tr>
						  <xsl:element name="td">
							  <xsl:value-of select="$stringsDoc//value[@key='domainName:']" />
						  </xsl:element>
						  <td width="10">&#160;</td>
						  <td>
						  <xsl:choose>
							  <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='true'">
								  <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='user_domain_name']" />
							  </xsl:when>
							  <xsl:otherwise>
								  <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='dhcp_domain_name']" />
							  </xsl:otherwise>
						  </xsl:choose>

						  </td>
					  </tr>
          </xsl:if>
				</xsl:if>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('lbl', $oaMode, 'Ip', $encNum)"/>
						</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" />*
					</xsl:element>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">

							<xsl:choose>
								<xsl:when test="$dhcpEnabled='true'">
									<xsl:attribute name="disabled">true</xsl:attribute>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="type">text</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$oaMode='ACTIVE'">
                  <xsl:attribute name="validate-ip-static-active">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$activeId" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="validate-ip-static-standby">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$standbyId" /></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:attribute name="rule-list">2</xsl:attribute>
              <xsl:attribute name="caption-label">
								<xsl:value-of select="concat('lbl', $oaMode, 'Ip', $encNum)"/>
							</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($oaMode, 'Ip', $encNum)"/>
							</xsl:attribute>

							<xsl:if test="hpoa:ipAddress != $EMPTY_IP_TEST">
								<xsl:attribute name="value">
									<xsl:value-of select="hpoa:ipAddress"/>
								</xsl:attribute>
							</xsl:if>

						</xsl:element>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('lbl', $oaMode, 'Netmask', $encNum)"/>
						</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='subnetMask:']" />*
					</xsl:element>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">

							<xsl:choose>
								<xsl:when test="$dhcpEnabled='true'">
									<xsl:attribute name="disabled">true</xsl:attribute>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="type">text</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$oaMode='ACTIVE'">
                  <xsl:attribute name="validate-ip-static-active">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$activeId" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="validate-ip-static-standby">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$standbyId" /></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:attribute name="rule-list">2</xsl:attribute>
              <xsl:attribute name="caption-label">
                <xsl:value-of select="concat('lbl', $oaMode, 'Netmask', $encNum)"/>
              </xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat($oaMode, 'Netmask', $encNum)"/>
              </xsl:attribute>
              <xsl:if test="hpoa:netmask != $EMPTY_IP_TEST">
                <xsl:attribute name="value">
                  <xsl:value-of select="hpoa:netmask"/>
                </xsl:attribute>
              </xsl:if>

            </xsl:element>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <xsl:element name="td">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('lbl', $oaMode, 'Gateway', $encNum)"/>
            </xsl:attribute>
            <xsl:value-of select="$stringsDoc//value[@key='gateway:']" />
          </xsl:element>
          <td width="10">&#160;</td>
          <td>
            <xsl:element name="input">

              <xsl:choose>
                <xsl:when test="$dhcpEnabled='true'">
                  <xsl:attribute name="disabled">true</xsl:attribute>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">stdInput</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$oaMode='ACTIVE'">
                  <xsl:attribute name="validate-ip-static-active">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$activeId" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="validate-ip-static-standby">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$standbyId" /></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
							<xsl:attribute name="rule-list">0;2</xsl:attribute>
							<xsl:attribute name="caption-label">
								<xsl:value-of select="concat('lbl', $oaMode, 'Gateway', $encNum)"/>
							</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($oaMode, 'Gateway', $encNum)"/>
							</xsl:attribute>
							<xsl:if test="hpoa:gateway != $EMPTY_IP_TEST">
								<xsl:attribute name="value">
									<xsl:value-of select="hpoa:gateway"/>
								</xsl:attribute>
							</xsl:if>

						</xsl:element>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('lbl', $oaMode, 'Dns1', $encNum)"/>
						</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='dnsServer']" />&#160;1:
					</xsl:element>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">

							<xsl:choose>
								<xsl:when test="$dhcpEnabled='true'">
									<xsl:attribute name="disabled">true</xsl:attribute>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="type">text</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$oaMode='ACTIVE'">
                  <xsl:attribute name="validate-ip-static-active">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$activeId" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="validate-ip-static-standby">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$standbyId" /></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
							<xsl:attribute name="rule-list">0;2</xsl:attribute>
							<xsl:attribute name="caption-label">
								<xsl:value-of select="concat('lbl', $oaMode, 'Dns1', $encNum)"/>
							</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($oaMode, 'Dns1', $encNum)"/>
							</xsl:attribute>
							<xsl:if test="hpoa:dns/hpoa:ipAddress[position()=1] != $EMPTY_IP_TEST">
								<xsl:attribute name="value">
									<xsl:value-of select="hpoa:dns/hpoa:ipAddress[position()=1]"/>
								</xsl:attribute>
							</xsl:if>

						</xsl:element>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<xsl:element name="td">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('lbl', $oaMode, 'Dns2', $encNum)"/>
						</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='dnsServer']" />&#160;2:
					</xsl:element>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">

							<xsl:choose>
								<xsl:when test="$dhcpEnabled='true'">
									<xsl:attribute name="disabled">true</xsl:attribute>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="id"><xsl:value-of select="concat($oaMode, 'Dns2', $encNum)"/></xsl:attribute>
              <!-- validation: optional;IP address;unique;depends on dns1 -->
              <xsl:choose>
                <xsl:when test="$oaMode='ACTIVE'">
                  <xsl:attribute name="validate-ip-static-active">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$activeId" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="validate-ip-static-standby">true</xsl:attribute>
                  <xsl:attribute name="unique-id"><xsl:value-of select="$standbyId" /></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
							<xsl:attribute name="rule-list">0;2;12;13</xsl:attribute>
							<xsl:attribute name="caption-label"><xsl:value-of select="concat('lbl', $oaMode, 'Dns2', $encNum)"/></xsl:attribute>
              <xsl:attribute name="related-inputs"><xsl:value-of select="concat($oaMode, 'Dns1', $encNum)"/></xsl:attribute>
              <xsl:attribute name="related-labels"><xsl:value-of select="concat('lbl', $oaMode, 'Dns1', $encNum)"/></xsl:attribute>

              <xsl:if test="hpoa:dns/hpoa:ipAddress[position()=2] != $EMPTY_IP_TEST">

								<xsl:attribute name="value">
									<xsl:value-of select="hpoa:dns/hpoa:ipAddress[position()=2]"/>
								</xsl:attribute>

							</xsl:if>

						</xsl:element>
					</td>
				</tr>

			</table>

		</xsl:for-each>

	</xsl:template>


</xsl:stylesheet>

