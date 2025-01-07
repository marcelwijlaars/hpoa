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
	<xsl:param name="vlanInfoDoc" />
  
  <xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
  
	<xsl:template match="*">
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='information']" />
			</caption>
			<tbody>

				<xsl:for-each select="$netTrayInfoDoc//hpoa:interconnectTrayInfo">

          <tr>
            <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='productName']" /></th>
            <td class="propertyValue">
              <xsl:value-of select="hpoa:name" />
            </td>
          </tr>
          <tr class="altRowColor">
            <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='mgmtIpAddress']" /></th>
						<td class="propertyValue">
							<xsl:choose>
								<xsl:when test="hpoa:inBandIpAddress != $EMPTY_IP_TEST">
									<xsl:value-of select="hpoa:inBandIpAddress" />
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
          <tr>
            <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='managementUrl']" /><font style="font-size:100%;vertical-align:top;">&#160;*</font></th>
            <td class="propertyValue">
              <xsl:value-of select="hpoa:urlToMgmt" />              
            </td>
          </tr>
          <tr class="altRowColor">
            <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='userAssignedName']" /></th>
            <td class="propertyValue">
              <xsl:value-of select="hpoa:userAssignedName" />
						</td>
					</tr>
					<tr>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='partNumber']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="hpoa:partNumber" />
						</td>
					</tr>
					<tr class="altRowColor">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='sparePartNumber']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="hpoa:sparePartNumber" />
						</td>
					</tr>
					<tr>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='serialNumber']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="hpoa:serialNumber" />
						</td>
					</tr>
					<tr class="altRowColor">
						<xsl:variable name="extendedType">
							<xsl:value-of select="hpoa:extraData[@hpoa:name='ExtendedFabricType']"/>
						</xsl:variable>

						<xsl:variable name="interconnectType">
							<xsl:choose>
								<xsl:when test="$extendedType!=''">
									<xsl:value-of select="$extendedType"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="hpoa:interconnectTrayType"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='type']" /></th>
						<td class="propertyValue">
							<xsl:call-template name="getInterconnectTypeLabel">
								<xsl:with-param name="type" select="$interconnectType" />
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='manufacturer']" /></th>
						<td class="propertyValue">
							<xsl:value-of select="hpoa:manufacturer" />
						</td>
					</tr>
					<tr class="altRowColor">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='tempSensor']" /></th>
						<td class="propertyValue">
							<xsl:choose>
								<xsl:when test="hpoa:temperatureSensorSupport='true'">
									<xsl:value-of select="$stringsDoc//value[@key='statusPresent']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				<xsl:if test="count($netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:extraData[@hpoa:name='swmFWVersion']) &gt; 0">
					<tr>
						<th class="propertyName">
							<xsl:value-of select="$stringsDoc//value[@key='firmwareVersion']" />
						</th>
						<td class="propertyValue">
							<xsl:value-of select="hpoa:extraData[@hpoa:name='swmFWVersion']" />
						</td>
					</tr>
				</xsl:if>

					<xsl:if test="$vlanInfoDoc//hpoa:vlanInfo/hpoa:vlanEnable='1'">
						<xsl:variable name="bayNumber" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:bayNumber" />

						<tr class="altRowColor">
							<th class="propertyName">
							  <xsl:value-of select="$stringsDoc//value[@key='vlanIdName']" />
							</th>
							<td class="propertyValue">
							  <xsl:variable name="vlanId" select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:portArray/hpoa:port[@hpoa:deviceType='INTERCONNECT' and @hpoa:bayNumber=$bayNumber]/hpoa:portVlanId" />
							  <xsl:value-of select="$vlanId"/>&#160;(<xsl:value-of select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg[hpoa:vlanId=$vlanId]/hpoa:vlanName"/>)
							</td>
						 </tr>
					</xsl:if>

        </xsl:for-each>
				
			</tbody>
		</table>
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		
		<xsl:if test="count($netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:extraData[contains(@hpoa:name,'swmIPv6')]) &gt; 0">
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
				<caption>
					<xsl:value-of select="$stringsDoc//value[@key='ipv6Addresses']" />
				</caption>
				<tbody>
					<xsl:for-each select="$netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:extraData[contains(@hpoa:name,'swmIPv6')]">
						<xsl:variable name="rowClass">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 1">altRowColor</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<tr class="{$rowClass}">
							<th class="propertyName">
								<xsl:choose>
									<xsl:when test="contains(@hpoa:name, 'LLAddress')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6LinkLocalAddress']" />
									</xsl:when>
									<xsl:when test="contains(@hpoa:name, 'DHCP')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6DHCPv6Address']" />
									</xsl:when>
									<xsl:when test="contains(@hpoa:name, 'EBIPA')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6EBIPAAddress']" />
									</xsl:when>
									<xsl:when test="contains(@hpoa:name, 'SLAAC')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6SlaacAddress']" />
									</xsl:when>
								</xsl:choose>
							</th>
							<td class="propertyValue"><xsl:value-of select="current()" /></td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="$netTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]">
						<xsl:variable name="rowClass">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 1">altRowColor</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<tr class="{$rowClass}">
							<th class="propertyName">
								<xsl:choose>
									<xsl:when test="contains(@hpoa:name, 'LLAddress')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6LinkLocalURL']" />
									</xsl:when>
									<xsl:when test="contains(@hpoa:name, 'DHCP')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6DHCPv6URL']" />
									</xsl:when>
									<xsl:when test="contains(@hpoa:name, 'EBIPA')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6EBIPAURL']" />
									</xsl:when>
									<xsl:when test="contains(@hpoa:name, 'SLAAC')">
										<xsl:value-of select="$stringsDoc//value[@key='ipv6SLAACURL']" />
									</xsl:when>
								</xsl:choose>
							</th>
							<td class="propertyValue"><xsl:value-of select="current()" /></td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table> 
			<p />

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
		</xsl:if>
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='connectivity']" />
			</caption>
			<tbody>

				<xsl:for-each select="$netTrayInfoDoc//hpoa:interconnectTrayInfo">

					<tr class="altRowColor">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='js2Connector']" /></th>
						<td class="propertyValue">

							<xsl:choose>
								<xsl:when test="hpoa:extraData[@hpoa:name='Js2Connector']='Absent'">
									<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
								</xsl:when>
								<xsl:when test="hpoa:extraData[@hpoa:name='Js2Connector']='Present'">
									<xsl:value-of select="$stringsDoc//value[@key='statusPresent']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="hpoa:extraData[@hpoa:name='Js2Connector']" />
								</xsl:otherwise>
							</xsl:choose>

						</td>
					</tr>

					<tr>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='internalEthernetInterface']" /></th>
						<td class="propertyValue">

							<xsl:choose>
								<xsl:when test="hpoa:extraData[@hpoa:name='InternalEthernetInterface']='Absent'">
									<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
								</xsl:when>
								<xsl:when test="hpoa:extraData[@hpoa:name='InternalEthernetInterface']='Present'">
									<xsl:value-of select="$stringsDoc//value[@key='statusPresent']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="hpoa:extraData[@hpoa:name='InternalEthernetInterface']" />
								</xsl:otherwise>
							</xsl:choose>
							
						</td>
					</tr>

					<tr class="altRowColor">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='internalEthernetRoute']" /></th>
						<td class="propertyValue">
							<xsl:choose>
								<xsl:when test="hpoa:ethernetPortRoute='true'">
									<xsl:value-of select="$stringsDoc//value[@key='enabled']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='disabled']" />
								</xsl:otherwise>
							</xsl:choose>
							
						</td>
					</tr>

					<tr>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='internalSerialInterface']" /></th>
						<td class="propertyValue">

							<xsl:choose>
								<xsl:when test="hpoa:extraData[@hpoa:name='InternalSerialPortInterface']='Absent'">
									<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
								</xsl:when>
								<xsl:when test="hpoa:extraData[@hpoa:name='InternalSerialPortInterface']='Present'">
									<xsl:value-of select="$stringsDoc//value[@key='statusPresent']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="hpoa:extraData[@hpoa:name='InternalSerialPortInterface']" />
								</xsl:otherwise>
							</xsl:choose>
							
						</td>
					</tr>

					<tr class="altRowColor">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='internalSerialRoute']" /></th>
						<td class="propertyValue">
							<xsl:choose>
								<xsl:when test="hpoa:rs232PortRoute='true'">
									<xsl:value-of select="$stringsDoc//value[@key='enabled']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='disabled']" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>

					<tr class="altRowColor">
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='externalSerialPortInterface']" /></th>
						<td class="propertyValue">

							<xsl:choose>
								<xsl:when test="hpoa:extraData[@hpoa:name='ExternalSerialPortInterface']='Absent'">
									<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
								</xsl:when>
								<xsl:when test="hpoa:extraData[@hpoa:name='ExternalSerialPortInterface']='Present'">
									<xsl:value-of select="$stringsDoc//value[@key='statusPresent']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="hpoa:extraData[@hpoa:name='ExternalSerialPortInterface']" />
								</xsl:otherwise>
							</xsl:choose>
							
						</td>
					</tr>

					<tr>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='externalEthernetInterface']" /></th>
						<td class="propertyValue">

							<xsl:choose>
								<xsl:when test="hpoa:extraData[@hpoa:name='ExternalEthernetInterface']='Absent'">
									<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
								</xsl:when>
								<xsl:when test="hpoa:extraData[@hpoa:name='ExternalEthernetInterface']='Present'">
									<xsl:value-of select="$stringsDoc//value[@key='statusPresent']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="hpoa:extraData[@hpoa:name='ExternalEthernetInterface']" />
								</xsl:otherwise>
							</xsl:choose>
							
						</td>
					</tr>

					<xsl:if test="hpoa:extraData[@hpoa:name='InternalSerialPortInterface']='Present'">
						<tr class="altRowColor">
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='serialPortBaudRate']" /></th>
							<td class="propertyValue">
								<xsl:value-of select="hpoa:extraData[@hpoa:name='SerialPortBaudRate']" />
							</td>
						</tr>
					</xsl:if>
					
				</xsl:for-each>
			</tbody>

		</table>

    <br />
    <font style="font-size:120%;margin-right:3px;">
      <xsl:value-of select="$stringsDoc//value[@key='asterisk']"/>
    </font>
    <em>
      <xsl:value-of select="$stringsDoc//value[@key='ioMgmtUrlDislaimer']" />
    </em>
		
	</xsl:template>

</xsl:stylesheet>
