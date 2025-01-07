<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl"/>

	<xsl:param name="vlanInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="deviceType" />
	<xsl:param name="enclosureType" />

  <xsl:template match="*">

	  <div id="errorDisplay" class="errorDisplay"></div>

	  <xsl:variable name="numBays">
		  <xsl:choose>
			  <xsl:when test="$deviceType='SERVER' and $enclosureType=0">16</xsl:when>
			  <xsl:when test="$deviceType='SERVER' and $enclosureType=1">8</xsl:when>
			  <xsl:when test="$deviceType='INTERCONNECT' and $enclosureType=0">8</xsl:when>
			  <xsl:when test="$deviceType='INTERCONNECT' and $enclosureType=1">4</xsl:when>
		  </xsl:choose>
	  </xsl:variable>

	  <xsl:choose>
		  <xsl:when test="$deviceType='SERVER'">
			  <xsl:value-of select="$stringsDoc//value[@key='vlanDeviceBayTitle:']" />&#160;<em>
				  <xsl:value-of select="$stringsDoc//value[@key='vlanDeviceBayTitleDescription']" />
			  </em><br />
		  </xsl:when>
		  <xsl:when test="$deviceType='INTERCONNECT'">
			  <xsl:value-of select="$stringsDoc//value[@key='vlanInterconnectBayTitle:']" />&#160;<em>
				  <xsl:value-of select="$stringsDoc//value[@key='vlanInterconnectBayTitleDescription']" />
			  </em><br />
		  </xsl:when>
	  </xsl:choose>

	  <span class="whiteSpacer">&#160;</span>
	  <br />
	  <div id="vlanDeviceListContainer0">
		  <table id="vlanDeviceTable" class="dataTable" border="0" cellpadding="0" cellspacing="0">
			  <thead>
				  <tr class="captionRow">
					  <th style="vertical-align: middle;width: 40px;">
						  <xsl:value-of select="$stringsDoc//value[@key='bay']"/>
					  </th>
					  <th style="vertical-align: middle;" nowrap="true">
						  <xsl:value-of select="$stringsDoc//value[@key='vlan']"/>
					  </th>
				  </tr>
			  </thead>
			  <tbody devicetype="{$deviceType}">
					<xsl:for-each select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:portArray/hpoa:port[@hpoa:deviceType=$deviceType and @hpoa:bayNumber &lt;= $numBays]">
						<xsl:variable name="vlanId" select="hpoa:portVlanId" />
						<xsl:variable name="altRowColor">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 0">altRowColor</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="bayNum" select="@hpoa:bayNumber" />
						<tr class="{$altRowColor}">
							<td nowrap="true">
								<xsl:choose>
									<xsl:when test="$deviceType='SERVER'">
										<xsl:value-of select="$bayNum"/>, <xsl:value-of select="concat($bayNum, 'A')"/>, <xsl:value-of select="concat($bayNum, 'B')"/>
									</xsl:when>
									<xsl:when test="$deviceType='INTERCONNECT'">
										<xsl:value-of select="$bayNum"/>
									</xsl:when>
								</xsl:choose>
							</td>
							<td>
								<xsl:element name="select">
									<xsl:attribute name="style">width:200px;</xsl:attribute>
									<xsl:attribute name="portNumber"><xsl:value-of select="@hpoa:portNumber"/></xsl:attribute>
									<xsl:for-each select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg">
										<xsl:element name="option">
											<xsl:if test="hpoa:vlanId=$vlanId">
												<xsl:attribute name="selected">true</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="value"><xsl:value-of select="hpoa:vlanId"/></xsl:attribute>
											<xsl:choose>
												<xsl:when test="hpoa:vlanName=''">
													<xsl:value-of select="concat(hpoa:vlanId, ' - ', $stringsDoc//value[@key='unnamed'])"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="concat(hpoa:vlanId, ' - ', hpoa:vlanName)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
							</td>
						</tr>
					</xsl:for-each>
			  </tbody>
		  </table>
	  </div>
	  <span class="whiteSpacer">&#160;</span>
	  <br />
	  <div align="right">
		  <div class='buttonSet' style="margin-bottom:0px;">
			  <div class='bWrapperUp'>
				  <div>
					  <div>
						  <xsl:if test="$serviceUserAcl != $USER">
							  <xsl:element name="button">
								  <xsl:attribute name="type">button</xsl:attribute>
								  <xsl:attribute name="class">hpButton</xsl:attribute>
								  <xsl:attribute name="onclick">updateVlanDevice();</xsl:attribute>
								  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
							  </xsl:element>
						  </xsl:if>
					  </div>
				  </div>
			  </div>

		  </div>
	  </div>

  </xsl:template>

</xsl:stylesheet>

