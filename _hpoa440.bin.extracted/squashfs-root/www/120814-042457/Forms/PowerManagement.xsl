<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="powerRedundancy">
		
		<xsl:variable name="presentSupplies" select="count($powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:presence=$PRESENT])"/>

		<xsl:variable name="isDC">
			<xsl:choose>
				<xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:subsystemType='EXTERNAL_DC'">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="powerUnits">
			<xsl:choose>
				<xsl:when test="$isDC='true'">DC</xsl:when>
				<xsl:otherwise>AC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each select="$powerConfigInfoDoc//hpoa:powerConfigInfo">

			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<TR>
					<TD valign="top">

						<xsl:element name="input">
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="name">redundancy</xsl:attribute>
							<xsl:attribute name="id">redundancyAC</xsl:attribute>

							<xsl:if test="hpoa:redundancyMode='AC_REDUNDANT'">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>

              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="disabled">true</xsl:attribute>
              </xsl:if>

							<xsl:attribute name="onclick">toggleDpsAvailable(this);</xsl:attribute>

						</xsl:element>
						
					</TD>
					<TD width="5">&#160;</TD>
					<TD valign="top">
						<xsl:choose>
							<xsl:when test="$isDC='true'">
								<label for="redundancyAC">
									<xsl:value-of select="$stringsDoc//value[@key='redundant:']" />
								</label>
								<em>
									<xsl:value-of select="$stringsDoc//value[@key='pwrManagementDesc']" />
								</em>
							</xsl:when>
							<xsl:otherwise>
								<label for="redundancyAC">
									<xsl:value-of select="$stringsDoc//value[@key='acRedundant']" />:
								</label>
								<em>
									<xsl:value-of select="$stringsDoc//value[@key='pwrManagementDescAC']" />
								</em>
							</xsl:otherwise>
						</xsl:choose>
						
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />

						<table cellpadding="0" cellspacing="0" border="0">

							<tr>
								<td>

									<xsl:choose>

										<xsl:when test="$enclosureType=0 or enclosureType=-1">

											<table cellpadding="0" cellspacing="0" border="0">
												<tr>
													<td style="border:2px solid #666666;padding:5px;" colspan="2">
														<table cellpadding="0" cellspacing="0" border="0">
															<tr>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
																<td class="deviceCell" width="35" height="25" bgcolor="#AAAAAA">&#160;</td>
															</tr>
															<tr>
																<td colspan="3" align="center">A</td>
															</tr>
														</table>
													</td>
													<td style="border-top:2px solid #666666;border-bottom:2px solid #666666; #666666;border-right:2px solid #666666;padding:5px;" colspan="2">
														<table cellpadding="0" cellspacing="0" border="0">
															<tr>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
																<td class="deviceCell" width="35" height="25" bgcolor="#AAAAAA">&#160;</td>
															</tr>
															<tr>
																<td colspan="3" align="center">B</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>

										</xsl:when>
										<xsl:otherwise>

                      <xsl:choose>

                        <xsl:when test="$isTower='true'">
                          <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                              <td style="border:2px solid #666666;padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td class="deviceCell" width="21" height="36" bgcolor="#AAAAAA">&#160;</td>
                                    <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_2_t.gif">&#160;</td>
                                    <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_2_t.gif">&#160;</td>
                                    <td align="center" style="padding-left:5px;">B</td>
                                  </tr>
                                </table>

                              </td>
                            </tr>
                            <tr>
                              <td style="border:2px solid #666666; border-top:0px; padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td class="deviceCell" width="21" height="36" bgcolor="#AAAAAA">&#160;</td>
                                    <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_t.gif">&#160;</td>
                                    <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_t.gif">&#160;</td>
                                    <td align="center" style="padding-left:5px;">A</td>
                                  </tr>
                                </table>

                              </td>

                            </tr>
                          </table>

                        </xsl:when>
                        <xsl:otherwise>
                          <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                              <td style="border:2px solid #666666;padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td class="deviceCell" width="36" height="21" bgcolor="#AAAAAA">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000.gif">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000.gif">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="3" align="center">A</td>
                                  </tr>
                                </table>

                              </td>
                              <td style="border:2px solid #666666; border-left:0px; padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td class="deviceCell" width="36" height="21" bgcolor="#AAAAAA">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000_2.gif">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000_2.gif">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="3" align="center">B</td>
                                  </tr>
                                </table>

                              </td>

                            </tr>
                          </table>
                        </xsl:otherwise>
                        
                      </xsl:choose>
                      
										</xsl:otherwise>

									</xsl:choose>
									
								</td>
								<td style="padding-left:10px;">
									<em><xsl:value-of select="$stringsDoc//value[@key='2plus2Config']" /></em>
								</td>
							</tr>

						</table>

						<span class="whiteSpacer">&#160;</span>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />

					</TD>
				</TR>
				<TR>
					<TD valign="top">
						<xsl:element name="input">
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="name">redundancy</xsl:attribute>
							<xsl:attribute name="id">redundancyPS</xsl:attribute>

							<xsl:if test="hpoa:redundancyMode='POWER_SUPPLY_REDUNDANT'">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>

              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="disabled">true</xsl:attribute>
              </xsl:if>
              
							<xsl:attribute name="onclick">toggleDpsAvailable(this);</xsl:attribute>

						</xsl:element>
					</TD>
					<TD width="5">&#160;</TD>
					<TD valign="top">
						<label for="redundancyPS">
							<xsl:value-of select="$stringsDoc//value[@key='powerSupplyRedundant']" />:
						</label>
						<em>
							<xsl:value-of select="$stringsDoc//value[@key='6pwrSupplyDesc']" />
						</em>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />

						<table cellpadding="0" cellspacing="0" border="0">

							<tr>
								<td>
									<xsl:choose>

										<xsl:when test="$enclosureType=0 or enclosureType=-1">

											<table cellpadding="0" cellspacing="0" border="0">
												<tr>
													<td style="border:2px solid #666666;padding:5px;">
														<table cellpadding="0" cellspacing="0" border="0">
															<tr>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
															</tr>
														</table>
													</td>
													<td style="border-top:2px solid #666666;border-bottom:2px solid #666666; border-right:2px solid #666666;padding:5px;">
														<table cellpadding="0" cellspacing="0" border="0">
															<tr>
																<td width="35" height="25" background="/120814-042457/images/enclosure_ps.gif">&#160;</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>

										</xsl:when>
										<xsl:otherwise>

                      <xsl:choose>
                        <xsl:when test="$isTower='true'">

                          <table cellpadding="0" cellspacing="0" border="0">

                            <tr>
                              <td>
                                <table cellpadding="0" cellspacing="0" border="0" style="border:2px solid #666666;border-right:0px none;">
                                  <tr>
                                    <td style="padding:5px;" colspan="2">
                                      
                                      <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                          <td width="24" height="50">&#160;</td>
                                        </tr>
                                      </table>

                                    </td>
                                  </tr>
                                  <tr>
                                    <td style="padding:5px;" colspan="2">

                                      <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                          <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_t.gif">&#160;</td>
                                        </tr>
                                      </table>

                                    </td>

                                  </tr>
                                </table>
                              </td>
                              <td>
                                <table cellpadding="0" cellspacing="0" border="0" style="border:2px solid #666666;">
                                  <tr>
                                    <td style="padding:5px;" colspan="2">

                                      <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                          <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_2_t.gif">&#160;</td>
                                          <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_2_t.gif">&#160;</td>
                                        </tr>
                                      </table>

                                    </td>
                                  </tr>
                                  <tr>
                                    <td style="padding:5px;" colspan="2">

                                      <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                          <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_t.gif">&#160;</td>
                                          <td width="24" height="50" background="/120814-042457/images/enclosure_ps_c3000_t.gif">&#160;</td>
                                        </tr>
                                      </table>

                                    </td>

                                  </tr>
                                </table>
                              </td>
                            </tr>

                          </table>

                        </xsl:when>
                        <xsl:otherwise>

                          <table cellpadding="0" cellspacing="0" border="0" style="border:2px solid #666666;border-bottom:0px none;">
                            <tr>
                              <td style="padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000.gif">&#160;</td>
                                  </tr>
                                </table>

                              </td>
                              <td style="padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td width="50" height="24">&#160;</td>
                                  </tr>
                                </table>

                              </td>

                            </tr>
                          </table>
                          <table cellpadding="0" cellspacing="0" border="0" style="border:2px solid #666666;">
                            <tr>
                              <td style="padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000.gif">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000.gif">&#160;</td>
                                  </tr>
                                </table>

                              </td>
                              <td style="padding:5px;" colspan="2">

                                <table cellpadding="0" cellspacing="0" border="0">
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000_2.gif">&#160;</td>
                                  </tr>
                                  <tr>
                                    <td width="50" height="24" background="/120814-042457/images/enclosure_ps_c3000_2.gif">&#160;</td>
                                  </tr>
                                </table>

                              </td>

                            </tr>
                          </table>
                          
                        </xsl:otherwise>
                      </xsl:choose>

										</xsl:otherwise>

									</xsl:choose>
								</td>
								<td style="padding-left:10px;">

									<xsl:choose>

										<xsl:when test="$enclosureType=0 or enclosureType=-1">
											<em><xsl:value-of select="$stringsDoc//value[@key='3plus1Config']" /></em>
										</xsl:when>
										<xsl:otherwise>
											<em><xsl:value-of select="$stringsDoc//value[@key='4plus1Config']" /></em>
										</xsl:otherwise>

									</xsl:choose>

								</td>
							</tr>
							
						</table>
						
						<span class="whiteSpacer">&#160;</span>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
					</TD>
				</TR>
				<TR>
					<TD valign="top">
						<xsl:element name="input">
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="name">redundancy</xsl:attribute>
							<xsl:attribute name="id">redundancyNone</xsl:attribute>

							<xsl:if test="hpoa:redundancyMode='NON_REDUNDANT'">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>

              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="disabled">true</xsl:attribute>
              </xsl:if>
              
							<xsl:attribute name="onclick">toggleDpsAvailable(this);</xsl:attribute>

						</xsl:element>
					</TD>
					<TD width="5">&#160;</TD>
					<TD valign="top">
						<label for="redundancyNone">
							<xsl:value-of select="$stringsDoc//value[@key='notRedundant']" />:
						</label>
						<em><xsl:value-of select="$stringsDoc//value[@key='pwrManagementNoRedudantDesc']" /></em>
					</TD>
				</TR>
			</TABLE>
			
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="acVaLimit">
		<xsl:param name="powerUnits"/>   

                <xsl:variable name="capLowerBound">
                        <xsl:choose>
                                <xsl:when
                                        test="string(round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:enclosurePowerCapLowerBound))) != 'NaN'">
                                        <xsl:value-of
                                                select="round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:enclosurePowerCapLowerBound)) " />
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

                <xsl:variable name="capUpperBound">
                        <xsl:choose>
                                <xsl:when
                                        test="string(round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:enclosurePowerCapUpperBound))) != 'NaN'">
                                        <xsl:value-of
                                                select="round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:enclosurePowerCapUpperBound)) " />
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

                <xsl:variable name="powerCap">
                        <xsl:choose>
                                <xsl:when
                                        test="string(round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:powerCap))) != 'NaN'">
                                        <xsl:value-of
                                                select="round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:powerCap)) " />
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

                <xsl:variable name="powerCapExt">
			<xsl:choose>
				<xsl:when test="string(round(number($powerCapExtConfigDoc//hpoa:powerCapExtConfig/hpoa:activeEDPCCap))) != 'NaN'">
					<xsl:value-of select="round(number($powerCapExtConfigDoc//hpoa:powerCapExtConfig/hpoa:activeEDPCCap)) " />
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="capExtMgrURL">
			<xsl:choose>
				<xsl:when test="string-length($powerCapExtConfigDoc//hpoa:powerCapExtConfig/hpoa:activeManagerURL) &gt; 0">
					<xsl:value-of select="$powerCapExtConfigDoc//hpoa:powerCapExtConfig/hpoa:activeManagerURL" />
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="string('UNDEFINED')" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="capExtTimeStamp">
			<xsl:choose>
				<xsl:when test="string-length($powerCapExtConfigDoc//hpoa:powerCapExtConfig/hpoa:activeTimeStamp) &gt; 0">
					<xsl:value-of select="$powerCapExtConfigDoc//hpoa:powerCapExtConfig/hpoa:activeTimeStamp" />
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="string('UNKNOWN')" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

                <xsl:variable name="ratedCircuitLowerBound">
                        <xsl:choose>
                                <xsl:when
                                        test="string(round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:extraData[@hpoa:name='ratedCircuitLowerBound']))) != 'NaN'">
                                        <xsl:value-of
                                                select="round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:extraData[@hpoa:name='ratedCircuitLowerBound'])) " />
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

                <xsl:variable name="deratedCircuit">
                        <xsl:choose>
                                <xsl:when
                                        test="string(round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:extraData[@hpoa:name='deratedCircuit']))) != 'NaN'">
                                        <xsl:value-of
                                                select="round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:extraData[@hpoa:name='deratedCircuit'])) " />
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

                <xsl:variable name="ratedCircuit">
                        <xsl:choose>
                                <xsl:when
                                        test="string(round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:extraData[@hpoa:name='ratedCircuit']))) != 'NaN'">
                                        <xsl:value-of
                                                select="round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:extraData[@hpoa:name='ratedCircuit'])) " />
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

		<TABLE>
			<xsl:if test="$powerCapExt!=0">
				<TR>
					<TD valign="top" colspan="3">
						<b>Power cap managed by group manager at <xsl:value-of
							select="$capExtMgrURL"
						/> (last updated at <xsl:value-of
							select="$capExtTimeStamp"
						/>)</b><br/><br/>
					</TD>
				</TR>
			</xsl:if>
			<TR>
				<TD valign="top">
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">powerLimit</xsl:attribute>
						<xsl:attribute name="id">dynamicPowerCap</xsl:attribute>
						<xsl:if test="$powerCap!=0">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>

						<xsl:if test="($serviceUserAcl = $USER) or ($capLowerBound = 0 and $capUpperBound = 0) or ($powerCapExt!=0)">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>
			
						<xsl:attribute name="onclick">enablePowerCapInput(true);enablePowerLimitInput(false)</xsl:attribute>

					</xsl:element>
				</TD>
				<TD width="5">&#160;</TD>
				<TD valign="top">
					<label for="dynamicPowerCap">
						<xsl:value-of select="$stringsDoc//value[@key='pwrCapLabel']" />:
					</label>
					<em>
						<xsl:value-of select="$stringsDoc//value[@key='pwrCapDescription']" />
					</em>
					<br />

					<span class="whiteSpacer">&#160;</span>
					<br />
		                

					<div id="powerCapContainer">

						<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
							<tr>
								<td colspan="3">
									<div id="powerCapError" class="errorDisplay"></div>
								</td>
							</tr>

							<tr>
								<td id="lblPowerCap" style="width:2%;white-space:nowrap;">
									<xsl:value-of select="$stringsDoc//value[@key='pwrCapShortLabel']" />:
								</td>
								<td><div style="width:10px;"></div></td>
								<td width="98%" style="white-space:nowrap;">
									<xsl:element name="input">

										<xsl:choose>
											<xsl:when test="$powerCap!=0 and $deratedCircuit!=0 and $ratedCircuit!=0 and $powerCapExt=0">
												<xsl:attribute name="class">stdInput</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												<xsl:attribute name="disabled">true</xsl:attribute>
											</xsl:otherwise>
							   			 </xsl:choose>
							
										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="id">powerCap</xsl:attribute>
              
										<!-- validation: (ignore when not enabled), integer between capLowerBound and capUpperBound -->
										<xsl:attribute name="validate-power-cap">true</xsl:attribute>
										<xsl:attribute name="rule-list">9</xsl:attribute>
										<xsl:attribute name="caption-label">lblPowerCap</xsl:attribute>
              
										<xsl:attribute name="value">
											<xsl:if test="$powerCap!=0 and $deratedCircuit!=0 and $ratedCircuit!=0">
												<xsl:value-of select="$powerCap"/>
											</xsl:if>
										</xsl:attribute>

										<xsl:if test="$serviceUserAcl = $USER">
											<xsl:attribute name="readonly">true</xsl:attribute>
										</xsl:if>
              
									</xsl:element>
									&#160;(<xsl:value-of select="concat($capLowerBound, ' - ', $capUpperBound)"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;<xsl:value-of select="$powerUnits" />)
								</td>
							</tr>

							<tr>
								<td id="lblDeratedCircuit" style="width:2%;white-space:nowrap;">
									<xsl:value-of select="$stringsDoc//value[@key='deratedCircuitLabel']" />:
								</td>
								<td><div style="width:10px;"></div></td>
								<td style="white-space:nowrap;">
									<xsl:element name="input">

										<xsl:choose>
											<xsl:when test="$deratedCircuit!=0 and $powerCapExt=0">
												<xsl:attribute name="class">stdInput</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												<xsl:attribute name="disabled">true</xsl:attribute>
											</xsl:otherwise>
							   			 </xsl:choose>
							
										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="id">deratedCircuit</xsl:attribute>
              
										<!-- validation: (ignore when not enabled), integer between capLowerBound and capUpperBound -->
										<xsl:attribute name="validate-power-cap">true</xsl:attribute>
										<xsl:attribute name="rule-list">9</xsl:attribute>
										<xsl:attribute name="caption-label">lblDeratedCircuit</xsl:attribute>
              
										<xsl:attribute name="value">
											<xsl:if test="$deratedCircuit!=0">
												<xsl:value-of select="$deratedCircuit"/>
											</xsl:if>
										</xsl:attribute>

										<xsl:if test="$serviceUserAcl = $USER">
											<xsl:attribute name="readonly">true</xsl:attribute>
										</xsl:if>
              
									</xsl:element>
									&#160;(<xsl:value-of select="concat($capLowerBound, ' - ', $capUpperBound)"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;<xsl:value-of select="$powerUnits" />)
								</td>
							</tr>

							<tr>
								<td id="lblRatedCircuit" style="width:2%;white-space:nowrap;">
									<xsl:value-of select="$stringsDoc//value[@key='ratedCircuitLabel']" />:
								</td>
								<td><div style="width:10px;"></div></td>
								<td  style="white-space:nowrap;">
									<xsl:element name="input">

										<xsl:choose>
											<xsl:when test="$ratedCircuit!=0 and $powerCapExt=0">
												<xsl:attribute name="class">stdInput</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												<xsl:attribute name="disabled">true</xsl:attribute>
											</xsl:otherwise>
							   			 </xsl:choose>
							
										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="id">ratedCircuit</xsl:attribute>
              
										<!-- validation: (ignore when not enabled), integer between ratedCircuitLowerBound and capUpperBound -->
										<xsl:attribute name="validate-power-cap">true</xsl:attribute>
										<xsl:attribute name="rule-list">9</xsl:attribute>
										<xsl:attribute name="caption-label">lblRatedCircuit</xsl:attribute>
              
										<xsl:attribute name="value">
											<xsl:if test="$ratedCircuit!=0">
												<xsl:value-of select="$ratedCircuit"/>
											</xsl:if>
										</xsl:attribute>

										<xsl:if test="$serviceUserAcl = $USER">
											<xsl:attribute name="readonly">true</xsl:attribute>
										</xsl:if>
              
									</xsl:element>
									&#160;(<xsl:value-of select="concat($ratedCircuitLowerBound, ' - ', $capUpperBound)"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;<xsl:value-of select="$powerUnits" />)
								</td>
							</tr>

                                                        <tr>
                                                               <td colspan="3" align="left">
                                                                       <span class="whiteSpacer">&#160;</span>
                                                               </td>
                                                       </tr>
                                                       <tr>
                                                               <td colspan="3" align="left">
                                                                       <xsl:value-of select="$stringsDoc//value[@key='edpcExample']" />
                                                               </td>
                                                       </tr>
						</TABLE>
					</div>	

					<span class="whiteSpacer">&#160;</span>
					<br />

					<xsl:if test="count($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:optOutBayArray/hpoa:bay[.='true']) &gt; 0">
						<br />
						<xsl:value-of select="$stringsDoc//value[@key='pwrCapBaysOptOutLabel']" />
						<xsl:for-each select="$powerCapConfigDoc//hpoa:powerCapConfig/hpoa:optOutBayArray/hpoa:bay">
							<xsl:variable name="position" select="position()" />
							<xsl:variable name="optOutValue" select="$powerCapConfigDoc//hpoa:powerCapConfig/hpoa:optOutBayArray/hpoa:bay[number($position)]" />
							<xsl:if test="$optOutValue='true'" >
								&#160;<xsl:value-of select="$position" />
							</xsl:if>
						</xsl:for-each>
						<br />
						<em>
						<xsl:value-of select="$stringsDoc//value[@key='pwrCapBaysOptOutHelp']" />
						</em>
						<br />
					</xsl:if>

					<xsl:if test="count($powerCapBladeStatusDoc//hpoa:info/hpoa:status/hpoa:codes[.!='1']) &gt; 0" >
						<br />
						<xsl:value-of select="$stringsDoc//value[@key='pwrCapBladeStatusLabel']" />
						<xsl:for-each select="$powerCapBladeStatusDoc//hpoa:info/hpoa:status">
							<xsl:variable name="blade" select="hpoa:symbolicBladeNumber" />
							<xsl:for-each select="hpoa:codes">
								<xsl:variable name="code" select="current()" />
								<xsl:if test="$code!='1'" >
									<br />
									<xsl:variable name="key" select="concat('pwrCapBladeStatus', $code)" />
									<xsl:value-of select="$stringsDoc//value[@key='pwrCapBladeNumber']" />&#160;<xsl:value-of select="$blade" />&#160;<xsl:value-of select="$stringsDoc//value[@key=$key]" />
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
						<br />
					</xsl:if>

					<span class="whiteSpacer">&#160;</span>
					<br />
				</TD>
			</TR>

			<TR>
				<TD valign="top">
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">powerLimit</xsl:attribute>			
						<xsl:attribute name="id">staticPowerLimit</xsl:attribute>

						<xsl:if test="$powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling!=0 and $powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling!=''">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>

						<xsl:if test="($serviceUserAcl = $USER) or ($powerCapExt != 0)">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="onclick">enablePowerLimitInput(true);enablePowerCapInput(false)</xsl:attribute>

					</xsl:element>
					</TD>
				<TD width="5">&#160;</TD>
				<TD valign="top">
					<label for="staticPowerLimit"><xsl:value-of select="$stringsDoc//value[@key='pwrLimitStaticLabel']" />:</label>			
					<em>
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitDesc1']" /><xsl:text> </xsl:text>
						<xsl:value-of select="$powerUnits" /><xsl:text> </xsl:text>
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitDesc2']" /><br />
						<span class="whiteSpacer">&#160;</span><br />
						<xsl:value-of select="$stringsDoc//value[@key='note:']" /><xsl:text> </xsl:text>
						<xsl:value-of select="$stringsDoc//value[@key='theMaximum']" /><xsl:text> </xsl:text>
						<xsl:value-of select="$powerUnits" /><xsl:text> </xsl:text>
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitNote1']" /><xsl:text> </xsl:text>
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitNote2']" /><xsl:text> </xsl:text>
						<xsl:value-of select="$powerUnits" /><xsl:text> </xsl:text>
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitNote3']" />
					</em><br />					
					
					<span class="whiteSpacer">&#160;</span>
					<br />
		                
					<div id="vaLimitContainer">

						<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
							<tr>
								<td colspan="3">
									<div id="powerLimitError" class="errorDisplay"></div>
								</td>
							</tr>
							<TR>
								<TD id="lblPowerLimit">
									<xsl:value-of select="$stringsDoc//value[@key='pwrLimit']" />:
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
									<xsl:element name="input">

										<xsl:choose>
											<xsl:when test="$powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling!=0 and $powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling!='' and $powerCapExt=0">
												<xsl:attribute name="class">stdInput</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
												<xsl:attribute name="disabled">true</xsl:attribute>
											</xsl:otherwise>
							   			 </xsl:choose>
							
										<xsl:attribute name="type">text</xsl:attribute>
										<xsl:attribute name="id">powerCeiling</xsl:attribute>
              
										<!-- validation: (ignore when not enabled), integer between minVa and maxVa -->
										<xsl:attribute name="validate-power-limit">true</xsl:attribute>
										<xsl:attribute name="rule-list">9</xsl:attribute>
										<xsl:attribute name="range"><xsl:value-of select="concat($minVa, ';', $maxVa)"/></xsl:attribute>
										<xsl:attribute name="caption-label">lblPowerLimit</xsl:attribute>
              
										<xsl:attribute name="value">
											<xsl:if test="$powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling!=0 and $powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling!=''">
												<xsl:value-of select="$powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling"/>
											</xsl:if>
										</xsl:attribute>

										<xsl:if test="$serviceUserAcl = $USER">
											<xsl:attribute name="readonly">true</xsl:attribute>
										</xsl:if>
              
									</xsl:element>
									&#160;(<xsl:value-of select="concat($minVa, ' - ', $maxVa)"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;<xsl:value-of select="$powerUnits" />)
								</TD>
							</TR>
						</TABLE>
					</div>	
					<span class="whiteSpacer">&#160;</span>
					<br />
				</TD>
			</TR>
				
				
			<TR>
				<TD valign="top">
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">powerLimit</xsl:attribute>
						<xsl:attribute name="id">powerLimitNone</xsl:attribute>
						
						<xsl:if test="($powerCap=0) and ($powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling=0 or $powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:powerCeiling='')">
				        		<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>

						<xsl:if test="($serviceUserAcl = $USER) or ($powerCapExt != 0)">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="onclick">enablePowerCapInput(false); enablePowerLimitInput(false);</xsl:attribute>
					</xsl:element>
				</TD>
				<TD width="5">&#160;</TD>
				<TD valign="top">
					<label for="powerLimitNone">
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitNoneLabel']" />:
					</label>
					<em>
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitNoneDescription']" />
					</em>
					<br />				
				</TD>
			</TR>
		</TABLE>

		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">inputPower</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="round($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPower)"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">inputPowerCapacity</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="round($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerCapacity)"/>
			</xsl:attribute>
		</xsl:element>

	</xsl:template>
	
</xsl:stylesheet>

