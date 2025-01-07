<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="InterconnectSelect">

		<xsl:param name="enclosureNumber" />
		<xsl:param name="checkAll" />
		<xsl:param name="disableAll" />
		<xsl:param name="enclosureType" select="0" />
		<xsl:param name="numBays" select="8" />
		<xsl:param name="checkAllLabel" select="''" />

		<!--<xsl:variable name="numBays">
			<xsl:choose>
				<xsl:when test="$enclosureType=0 or $enclosureType=-1">
					<xsl:value-of select="$IO_BAYS_PER_ENCLOSURE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(4)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>-->
  
		<table cellpadding="0" cellspacing="0" border="0">
		<tr><td>
			<xsl:element name="input">
								
				<xsl:attribute name="onclick">checkboxToggle(this, 'devid', 'interconnect', '<xsl:value-of select="concat('swmSelectEnc', $enclosureNumber)" />');</xsl:attribute>
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat($enclosureNumber,' IO Select')" /></xsl:attribute>
				<xsl:attribute name="devid">bay</xsl:attribute>
				<xsl:attribute name="style">margin-right:5px;</xsl:attribute>
				<xsl:if test="$checkAll = 'true' or count(hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:access='true'])=$numBays">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
				<xsl:if test="$disableAll='true'">
					<xsl:attribute name="disabled">true</xsl:attribute>
				</xsl:if>
			</xsl:element>
			
			<xsl:element name="label">
				<xsl:attribute name="for"><xsl:value-of select="concat($enclosureNumber,' IO Select')" /></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$checkAllLabel != ''">
						<xsl:value-of select="$checkAllLabel"/>
					</xsl:when>
					<xsl:otherwise>
				<xsl:value-of select="$stringsDoc//value[@key='allInterconnectBays']" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element><br />
			
			<span class="whiteSpacer">&#160;</span><br />
			
		</td></tr>
		<tr><td align="center">
		
			<xsl:element name="div">
				
				<xsl:attribute name="id"><xsl:value-of select="concat('swmSelectEnc', $enclosureNumber)" /></xsl:attribute>

				<xsl:choose>
					<xsl:when test="$enclosureType=0 or $enclosureType=-1">
						<table cellpadding="0" cellspacing="0" border="0" height="74" class="ioBaysSmall" ID="Table3">
							<tr>
								<td style="width:20px;background:none;color:#000000;border:none;">1</td>
								<td style="width:94px;">
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">1</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=1]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td style="width:94px;">
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">2</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=2]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td style="width:20px;background:none;color:#000000;border:none;">2</td>
							</tr>
							<tr>
								<td style="width:20px;background:none;color:#000000;border:none;">3</td>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">3</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=3]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">4</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=4]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td style="width:20px;background:none;color:#000000;border:none;">4</td>
							</tr>
							<tr>
								<td style="width:20px;background:none;color:#000000;border:none;">5</td>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">5</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=5]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">6</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=6]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td style="width:20px;background:none;color:#000000;border:none;">6</td>
							</tr>
							<tr>
								<td style="width:20px;background:none;color:#000000;border:none;">7</td>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">7</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=7]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td>
									<xsl:element name="input">
										<xsl:attribute name="type">checkbox</xsl:attribute>
										<xsl:attribute name="bayId">8</xsl:attribute>
										<xsl:attribute name="devid">interconnect</xsl:attribute>
										<xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=8]/hpoa:access='true'">
											<xsl:attribute name="checked">true</xsl:attribute>
										</xsl:if>
										<xsl:if test="$disableAll = 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</td>
								<td style="width:20px;background:none;color:#000000;border:none;">8</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:otherwise>

            <xsl:choose>
              <xsl:when test="$isTower = 'true'">

                <table cellpadding="1" cellspacing="0" width="37">
                  <tr>
                    <td align="center" style="padding-bottom: 5px;">Top</td>
                  </tr>
                </table>
                
                <table cellpadding="0" cellspacing="0" border="0" width="37" class="ioBaysSmall" ID="Table3">
                  <tr>
                    <td style="height:20px;background:none;color:#000000;border:none;">2</td>
                    <td style="height:20px;background:none;color:#000000;border:none;">4</td>
                  </tr>
                  <tr>
                    <td style="height:42px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">2</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=2]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td style="height:42px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">4</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=4]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                  </tr>
                  <tr>
                    <td style="height:42px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">1</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=1]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td style="height:42px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">3</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=3]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                  </tr>
                  <tr>
                    <td style="height:20px;background:none;color:#000000;border:none;">1</td>
                    <td style="height:20px;background:none;color:#000000;border:none;">3</td>
                  </tr>
                </table>

              </xsl:when>
              <xsl:otherwise>
                <table cellpadding="0" cellspacing="0" border="0" height="37" class="ioBaysSmall" ID="Table3">
                  <tr>
                    <td style="width:20px;background:none;color:#000000;border:none;">1</td>
                    <td style="width:94px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">1</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=1]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td style="width:94px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">2</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=2]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td style="width:20px;background:none;color:#000000;border:none;">2</td>
                  </tr>
                  <tr>
                    <td style="width:20px;background:none;color:#000000;border:none;">3</td>
                    <td>
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">3</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=3]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td>
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="bayId">4</xsl:attribute>
                        <xsl:attribute name="devid">interconnect</xsl:attribute>
                        <xsl:if test="$checkAll = 'true' or hpoa:interconnectTrayBays/hpoa:interconnectTray[hpoa:bayNumber=4]/hpoa:access='true'">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disableAll = 'true'">
                          <xsl:attribute name="disabled">true</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td style="width:20px;background:none;color:#000000;border:none;">4</td>
                  </tr>
                </table>
              </xsl:otherwise>
            </xsl:choose>
            
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:element>
		</td></tr></table>
		<!-- -->
	</xsl:template>
	
</xsl:stylesheet>

