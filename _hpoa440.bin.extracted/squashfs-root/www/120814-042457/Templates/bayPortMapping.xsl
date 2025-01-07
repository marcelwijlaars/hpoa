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

  <!-- Document fragment parameters containing blade status and information -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="bladeStatusDoc" />
  <xsl:param name="bladeInfoDoc" />
  <xsl:param name="portMapInfoDoc" />
  <xsl:param name="bladeMezzInfoExDoc" />
  <xsl:param name="interconnectTrayInfoDoc" />
  <xsl:param name="interconnectTrayPortMapDoc" />
  <xsl:param name="enclosureType" />

  <xsl:template match="*">

        <table border="0" cellpadding="0" cellspacing="0" class="treeTable">
            <thead>
                <tr class="captionRow">
                    <th><xsl:value-of  select="$stringsDoc//value[@key='mezzSlot']" /></th>
					          <th><xsl:value-of  select="$stringsDoc//value[@key='mezzDevice']" /></th>
					          <th><xsl:value-of  select="$stringsDoc//value[@key='mezzDevicePort']" /></th>
					          <th><xsl:value-of  select="$stringsDoc//value[@key='portStatus']" /></th>
                    <th><xsl:value-of  select="$stringsDoc//value[@key='interconnectBay']" /></th>
                    <th><xsl:value-of  select="$stringsDoc//value[@key='interconnectBayPort']" /></th>
                    <th><xsl:value-of  select="$stringsDoc//value[@key='deviceID']" /></th>
                </tr>
            </thead>
            <tbody>

				<xsl:for-each select="$portMapInfoDoc//hpoa:mezz[hpoa:mezzNumber=$MEZZ_NUMBER_FIXED and (hpoa:mezzSlots/hpoa:type='MEZZ_SLOT_TYPE_FIXED' and hpoa:mezzDevices/hpoa:type != 'MEZZ_DEV_TYPE_MT')]">
					<xsl:call-template name="mezzTableRow" />
				</xsl:for-each>

				<xsl:for-each select="$portMapInfoDoc//hpoa:mezz[hpoa:mezzNumber!=$MEZZ_NUMBER_FIXED]">
					<xsl:call-template name="mezzTableRow" />
				</xsl:for-each>

			</tbody>
		</table>
    <span class="whiteSpacer">&#160;</span>
    <br />

    <div align="right">
      <div class='buttonSet'>
        <div class='bWrapperUp'>
          <div>
            <div>
              <button type='button' class='hpButton' id="btnApplyDateTime" onclick="initPage('tableView');">
                <xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>


  </xsl:template>

	<xsl:template name="mezzTableRow">

		<xsl:variable name="mezzNumber" select="hpoa:mezzNumber" />

		<tr class="treeTableTopLevel">
			<td>
				<b>
					<xsl:choose>
						<xsl:when test="hpoa:mezzDevices/hpoa:type='MEZZ_DEV_TYPE_FIXED'">
							<!--
								Embedded LOM Mezz device
							-->
							<xsl:choose>
								<xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_STORAGE'">
									SAS
								</xsl:when>
					                	<xsl:otherwise>
				      		          		<xsl:value-of  select="$stringsDoc//value[@key='embedded']" />
				             	   	</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!--
								Physical Mezz or FLB
							-->
							<xsl:choose>
								<!-- If FLB, convert mezzNumber to FLB value and add FLB notation -->
								<xsl:when test="$mezzNumber &gt; $FLB_START_IX">
									<xsl:variable name="FLBNumber" select="../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:extraData[@hpoa:name='aMezzNum']"/>
									<xsl:value-of select="concat('FLB', ' ', $FLBNumber)"/>
								</xsl:when>
								<xsl:otherwise>									
									<!-- Otherwise, display mezzNumber directly -->
									<xsl:value-of select="$mezzNumber"/>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:otherwise>
						
					</xsl:choose>
				</b>
			</td>
			
			<td colspan="6">
				<b>
					<xsl:choose>
					<xsl:when test="hpoa:mezzDevices/hpoa:type=$MEZZ_DEV_TYPE_MT and hpoa:mezzDevices/hpoa:name='N/A'">
						<xsl:value-of  select="$stringsDoc//value[@key='notAvailable']" />
					</xsl:when>
					<xsl:when test="hpoa:mezzDevices/hpoa:type=$MEZZ_DEV_TYPE_MT and hpoa:mezzDevices/hpoa:type!='MEZZ_DEV_TYPE_FIXED'">
						<xsl:value-of  select="$stringsDoc//value[@key='noDevicePresent']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getApprovedMezzName">
						<xsl:with-param name="bladeType" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType" />
						<xsl:with-param name="dataName" select="hpoa:mezzDevices/hpoa:name"/>
						</xsl:call-template>
					</xsl:otherwise>
					</xsl:choose>
				</b>
			</td>
		</tr>

		<xsl:choose>

			<xsl:when test="hpoa:mezzDevices/hpoa:name != '' and count(hpoa:mezzDevices/hpoa:port) = 0">

				<xsl:element name="tr">
					<td>&#160;</td>
					<td class="nested1" colspan="6">
						<xsl:value-of select="$stringsDoc//value[@key='isvbDeviceNotHaveReadIO']" />
					</td>
				</xsl:element>

			</xsl:when>
			<xsl:otherwise>

				<xsl:choose>
					<xsl:when test="count(hpoa:mezzSlots/hpoa:slot) &gt; 0">
						
						<xsl:for-each select="hpoa:mezzSlots/hpoa:slot">

							<xsl:variable name="slotNumber" select="hpoa:slotNumber" />
							<xsl:variable name="swmBayNumber" select="hpoa:interconnectTrayBayNumber" />
							<xsl:variable name="previousTrayType" select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=number($swmBayNumber)-1]/hpoa:interconnectTrayType"/>
							<xsl:variable name="hasSlot" select="(count($interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$swmBayNumber]/hpoa:slot[hpoa:interconnectTraySlotNumber=$slotNumber]) &gt; 0)" />
							<xsl:variable name="isIb" select="($slotNumber=2 and $interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$swmBayNumber]/hpoa:slot[hpoa:interconnectTraySlotNumber=$slotNumber]/hpoa:type='INTERCONNECT_TRAY_TYPE_IB')" />

							<xsl:if test="(not($previousTrayType='INTERCONNECT_TRAY_TYPE_IB') or $hasSlot) and not($isIb)">

								<xsl:variable name="portStatus" select="../../../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber]/hpoa:status"/>
								<xsl:variable name="portPartnerActive" select="../../../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber]/hpoa:extraData[@hpoa:name='portPartnerActive']='true'"/>

								<xsl:if test="count(current()[hpoa:interconnectTrayBayNumber=0])=0 and count(../../hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber])&gt;0">

									<xsl:if test="not($portPartnerActive)">

										<xsl:choose>
											<xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$slotNumber]/hpoa:guid) &gt; 0">
												<xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$slotNumber]">

													<xsl:if test="count(hpoa:guid) &gt; 0">

														<xsl:for-each select="hpoa:guid">

															<xsl:variable name="portNumber" select="../hpoa:portNumber" />

															<xsl:element name="tr">

																<td class="nested1"></td>
																<td>&#160;</td>
																<td nowrap="true" style="text-align:right;">
                                  <xsl:call-template name="getGuidLabel">
                                    <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                                    <xsl:with-param name="guidStruct" select="." />
                                    <xsl:with-param name="mezzNumber" select="$mezzNumber" />
                                  </xsl:call-template>                                  
																</td>
																<td nowrap="true">

																	<xsl:if test="$portStatus != $FABRIC_STATUS_UNKNOWN">
																		<xsl:call-template name="getStatusLabel">
																			<xsl:with-param name="statusCode" select="$portStatus" />
																		</xsl:call-template>
																	</xsl:if>

																</td>
																<td>

																	<xsl:variable name="interconnectBayNum" select="$portMapInfoDoc//hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzSlots/hpoa:slot[hpoa:slotNumber=$portNumber]/hpoa:interconnectTrayBayNumber" />

																	<xsl:choose>
																		<xsl:when test="$enclosureType=1">

																			<xsl:choose>
																				<xsl:when test="$interconnectBayNum=1">
																					<xsl:element name="img">
																						<xsl:attribute name="width">13</xsl:attribute>
																						<xsl:attribute name="height">13</xsl:attribute>
																						<xsl:attribute name="src">/120814-042457/images/io_icon_13_1.gif</xsl:attribute>
																					</xsl:element>&#160;
																				</xsl:when>
																				<xsl:when test="$interconnectBayNum=2">
																					<xsl:element name="img">
																						<xsl:attribute name="width">13</xsl:attribute>
																						<xsl:attribute name="height">13</xsl:attribute>
																						<xsl:attribute name="src">/120814-042457/images/io_icon_13_2_square.gif</xsl:attribute>
																					</xsl:element>&#160;
																				</xsl:when>
																				<xsl:when test="$interconnectBayNum=3">
																					<xsl:element name="img">
																						<xsl:attribute name="width">13</xsl:attribute>
																						<xsl:attribute name="height">13</xsl:attribute>
																						<xsl:attribute name="src">/120814-042457/images/io_icon_13_3_round.gif</xsl:attribute>
																					</xsl:element>
																					<xsl:element name="img">
																						<xsl:attribute name="width">13</xsl:attribute>
																						<xsl:attribute name="height">13</xsl:attribute>
																						<xsl:attribute name="src">/120814-042457/images/io_icon_13_3_diamond.gif</xsl:attribute>
																					</xsl:element>&#160;
																				</xsl:when>
																				<xsl:when test="$interconnectBayNum=4">
																					<xsl:element name="img">
																						<xsl:attribute name="width">13</xsl:attribute>
																						<xsl:attribute name="height">13</xsl:attribute>
																						<xsl:attribute name="src">/120814-042457/images/io_icon_13_4_round.gif</xsl:attribute>
																					</xsl:element>
																					<xsl:element name="img">
																						<xsl:attribute name="width">13</xsl:attribute>
																						<xsl:attribute name="height">13</xsl:attribute>
																						<xsl:attribute name="src">/120814-042457/images/io_icon_13_4_diamond.gif</xsl:attribute>
																					</xsl:element>&#160;
																				</xsl:when>
																			</xsl:choose>

																		</xsl:when>
																		<xsl:otherwise>

																			<xsl:element name="img">
																				<xsl:attribute name="width">13</xsl:attribute>
																				<xsl:attribute name="height">13</xsl:attribute>
																				<xsl:attribute name="src">
																					<xsl:value-of select="concat('/120814-042457/images/io_icon_13_', $interconnectBayNum, '.gif')"/>
																				</xsl:attribute>
																			</xsl:element>&#160;

																		</xsl:otherwise>
																	</xsl:choose>

																	<xsl:value-of select="$stringsDoc//value[@key='bay']" />&#160;<xsl:value-of select="$interconnectBayNum"/>
																</td>
																<td>
																	<xsl:value-of select="$stringsDoc//value[@key='port']" />&#160;<xsl:value-of select="$portMapInfoDoc//hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzSlots/hpoa:slot[hpoa:slotNumber=$portNumber]/hpoa:interconnectTrayPortNumber"/>
																</td>
																<td nowrap="true">
																	<xsl:value-of select="hpoa:guid"/>
																</td>

															</xsl:element>

														</xsl:for-each>

													</xsl:if>

												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:element name="tr">

													<xsl:if test="$portStatus = $FABRIC_STATUS_MISMATCH">
														<xsl:attribute name="class">mismatchRow</xsl:attribute>
													</xsl:if>

													<td class="nested1"></td>
													<td>&#160;</td>
													<td>
														<xsl:choose>
															<xsl:when test="../hpoa:type='MEZZ_SLOT_TYPE_FIXED' and $bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_STORAGE'">
																SAS&#160;<xsl:value-of select="$slotNumber"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$stringsDoc//value[@key='port']" />&#160;<xsl:value-of select="$slotNumber"/>
															</xsl:otherwise>
														</xsl:choose>
													</td>
													<td nowrap="true">

														<xsl:if test="$portStatus != $FABRIC_STATUS_UNKNOWN">
															<xsl:call-template name="getStatusLabel">
																<xsl:with-param name="statusCode" select="$portStatus" />
															</xsl:call-template>
														</xsl:if>

													</td>
													<td>

														<xsl:choose>
															<xsl:when test="$enclosureType=1">

																<xsl:choose>
																	<xsl:when test="hpoa:interconnectTrayBayNumber=1">
																		<xsl:element name="img">
																			<xsl:attribute name="width">13</xsl:attribute>
																			<xsl:attribute name="height">13</xsl:attribute>
																			<xsl:attribute name="src">/120814-042457/images/io_icon_13_1.gif</xsl:attribute>
																		</xsl:element>&#160;
																	</xsl:when>
																	<xsl:when test="hpoa:interconnectTrayBayNumber=2">
																		<xsl:element name="img">
																			<xsl:attribute name="width">13</xsl:attribute>
																			<xsl:attribute name="height">13</xsl:attribute>
																			<xsl:attribute name="src">/120814-042457/images/io_icon_13_2_square.gif</xsl:attribute>
																		</xsl:element>&#160;
																	</xsl:when>
																	<xsl:when test="hpoa:interconnectTrayBayNumber=3">
																		<xsl:element name="img">
																			<xsl:attribute name="width">13</xsl:attribute>
																			<xsl:attribute name="height">13</xsl:attribute>
																			<xsl:attribute name="src">/120814-042457/images/io_icon_13_3_round.gif</xsl:attribute>
																		</xsl:element>
																		<xsl:element name="img">
																			<xsl:attribute name="width">13</xsl:attribute>
																			<xsl:attribute name="height">13</xsl:attribute>
																			<xsl:attribute name="src">/120814-042457/images/io_icon_13_3_diamond.gif</xsl:attribute>
																		</xsl:element>&#160;
																	</xsl:when>
																	<xsl:when test="hpoa:interconnectTrayBayNumber=4">
																		<xsl:element name="img">
																			<xsl:attribute name="width">13</xsl:attribute>
																			<xsl:attribute name="height">13</xsl:attribute>
																			<xsl:attribute name="src">/120814-042457/images/io_icon_13_4_round.gif</xsl:attribute>
																		</xsl:element>
																		<xsl:element name="img">
																			<xsl:attribute name="width">13</xsl:attribute>
																			<xsl:attribute name="height">13</xsl:attribute>
																			<xsl:attribute name="src">/120814-042457/images/io_icon_13_4_diamond.gif</xsl:attribute>
																		</xsl:element>&#160;
																	</xsl:when>
																</xsl:choose>

															</xsl:when>
															<xsl:otherwise>

																<xsl:element name="img">
																	<xsl:attribute name="width">13</xsl:attribute>
																	<xsl:attribute name="height">13</xsl:attribute>
																	<xsl:attribute name="src">
																		<xsl:value-of select="concat('/120814-042457/images/io_icon_13_', hpoa:interconnectTrayBayNumber, '.gif')"/>
																	</xsl:attribute>
																</xsl:element>&#160;

															</xsl:otherwise>
														</xsl:choose>

														<xsl:value-of select="$stringsDoc//value[@key='bay']" />&#160;<xsl:value-of select="hpoa:interconnectTrayBayNumber"/>
													</td>
													<td>
														<xsl:value-of select="$stringsDoc//value[@key='port']" />&#160;<xsl:value-of select="hpoa:interconnectTrayPortNumber"/>
													</td>
													<td nowrap="true">
														<xsl:value-of select="../../../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber]/hpoa:wwpn"/>
													</td>
												</xsl:element>

												<xsl:if test="count(../../../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']) &gt; 0">

													<xsl:element name="tr">
														<xsl:if test="$portStatus = $FABRIC_STATUS_MISMATCH">
															<xsl:attribute name="class">mismatchRow</xsl:attribute>
														</xsl:if>

														<td class="nested1"></td>
														<td>&#160;</td>
														<td>
															<xsl:value-of select="$stringsDoc//value[@key='iScsiPort']" />&#160;<xsl:value-of select="$slotNumber"/>
														</td>
														<td nowrap="true">
															<xsl:if test="$portStatus != $FABRIC_STATUS_UNKNOWN">
																<xsl:call-template name="getStatusLabel">
																	<xsl:with-param name="statusCode" select="$portStatus" />
																</xsl:call-template>
															</xsl:if>
														</td>
														<td>
															<xsl:choose>
																<xsl:when test="$enclosureType=1">

																	<xsl:choose>
																		<xsl:when test="hpoa:interconnectTrayBayNumber=1">
																			<xsl:element name="img">
																				<xsl:attribute name="width">13</xsl:attribute>
																				<xsl:attribute name="height">13</xsl:attribute>
																				<xsl:attribute name="src">/120814-042457/images/io_icon_13_1.gif</xsl:attribute>
																			</xsl:element>&#160;
																		</xsl:when>
																		<xsl:when test="hpoa:interconnectTrayBayNumber=2">
																			<xsl:element name="img">
																				<xsl:attribute name="width">13</xsl:attribute>
																				<xsl:attribute name="height">13</xsl:attribute>
																				<xsl:attribute name="src">/120814-042457/images/io_icon_13_2_square.gif</xsl:attribute>
																			</xsl:element>&#160;
																		</xsl:when>
																		<xsl:when test="hpoa:interconnectTrayBayNumber=3">
																			<xsl:element name="img">
																				<xsl:attribute name="width">13</xsl:attribute>
																				<xsl:attribute name="height">13</xsl:attribute>
																				<xsl:attribute name="src">/120814-042457/images/io_icon_13_3_round.gif</xsl:attribute>
																			</xsl:element>
																			<xsl:element name="img">
																				<xsl:attribute name="width">13</xsl:attribute>
																				<xsl:attribute name="height">13</xsl:attribute>
																				<xsl:attribute name="src">/120814-042457/images/io_icon_13_3_diamond.gif</xsl:attribute>
																			</xsl:element>&#160;
																		</xsl:when>
																		<xsl:when test="hpoa:interconnectTrayBayNumber=4">
																			<xsl:element name="img">
																				<xsl:attribute name="width">13</xsl:attribute>
																				<xsl:attribute name="height">13</xsl:attribute>
																				<xsl:attribute name="src">/120814-042457/images/io_icon_13_4_round.gif</xsl:attribute>
																			</xsl:element>
																			<xsl:element name="img">
																				<xsl:attribute name="width">13</xsl:attribute>
																				<xsl:attribute name="height">13</xsl:attribute>
																				<xsl:attribute name="src">/120814-042457/images/io_icon_13_4_diamond.gif</xsl:attribute>
																			</xsl:element>&#160;
																		</xsl:when>
																	</xsl:choose>

																</xsl:when>
																<xsl:otherwise>

																	<xsl:element name="img">
																		<xsl:attribute name="width">13</xsl:attribute>
																		<xsl:attribute name="height">13</xsl:attribute>
																		<xsl:attribute name="src">
																			<xsl:value-of select="concat('/120814-042457/images/io_icon_13_', hpoa:interconnectTrayBayNumber, '.gif')"/>
																		</xsl:attribute>
																	</xsl:element>&#160;

																</xsl:otherwise>
															</xsl:choose>
															<xsl:value-of select="$stringsDoc//value[@key='bay']" />&#160;<xsl:value-of select="hpoa:interconnectTrayBayNumber"/>
														</td>
														<td>
															<xsl:value-of select="$stringsDoc//value[@key='port']" />&#160;<xsl:value-of select="hpoa:interconnectTrayPortNumber"/>
														</td>
														<td nowrap="true">
															<xsl:value-of select="../../../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']"/>
														</td>
													</xsl:element>

												</xsl:if>
												
											</xsl:otherwise>
										</xsl:choose>

									</xsl:if>

								</xsl:if>

							</xsl:if>

						</xsl:for-each>
								
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="tr">
							<td>&#160;</td>
							<td class="nested1" colspan="6">
								<xsl:value-of select="$stringsDoc//value[@key='noConnectSlot']" />
							</td>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
			
		</xsl:choose>

		
	</xsl:template>

</xsl:stylesheet>
