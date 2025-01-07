<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<!-- XML document parameters containing bay information and status -->
	<xsl:param name="fanInfoDoc" />
	<xsl:param name="thermalSubsystemInfoDoc" />
	<xsl:param name="enclosureType" select="string('0')" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="numFansPerRow" select="5" />
	<xsl:param name="numFansPerEnclosure" select="10" />
	<xsl:param name="encNum" />

	<xsl:template match="*">
		<table border="0" cellpadding="5" cellspacing="0" style="width: 100%; top: 0px;
						left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border: 0px;">
			<tbody>
				<tr style="width: 100%;">
					<td valign="top" style="vertical-align: top;">
						<xsl:call-template name="fanSummaryTable">
							<xsl:with-param name="statusCode" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:operationalStatus" />
							<xsl:with-param name="redundancyMode" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:redundancy" />
							<xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<span class="whiteSpacer">&#160;</span>
					<br />
				</tr>

				<tr style="width: 100%;">
					<td valign="top" style="vertical-align: top;">
						<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" valign="top" style="vertical-align: top;">
							<tbody>
								<tr valign="top" style="vertical-align: top;">
									<xsl:choose>
										<xsl:when test="$fanInfoDoc!=''">
											<td valign="top" style="vertical-align: top;">
												<xsl:call-template name="rearViewTable">
												</xsl:call-template>
											</td>
											<td>
												<span class="whiteSpacer" style="margin:15px;">&#160;</span>
												<br />
											</td>
										</xsl:when>
									</xsl:choose>
									<td valign="top" style="vertical-align: top;" width="100%">
										<xsl:call-template name="fanListTable">
										</xsl:call-template>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' id='btnRefreshSummary' class='hpButton' onclick="refreshSummary();">
								<xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
		</div>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" 
			style="vertical-align: top; margin: 0px auto; padding: 0px; border: 0px;">
			<tbody>

			</tbody>
		</table>
		<xsl:if test="$fanInfoDoc!=''" >
			<xsl:call-template name="fanRuleHelp">
			</xsl:call-template>

			<div>
				<br />
				<span class="whiteSpacer">&#160;</span>
				<br />
			</div>

			<!-- the fan tooltip elements -->
			<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo">
				<xsl:variable name="myId">
					<xsl:value-of select="concat('fanZoneFanBay_', hpoa:bayNumber)" />
				</xsl:variable>
				<xsl:call-template name="fanBayTooltip">
					<xsl:with-param name="bayNum" select="hpoa:bayNumber" />
					<xsl:with-param name="fanInfoDoc" select="$fanInfoDoc" />
					<xsl:with-param name="fanZone" select="true()" />
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>

	</xsl:template>

	<xsl:template name ="fanSummaryTable">
		<xsl:param name="statusCode" />
		<xsl:param name="redundancyMode" />
		<xsl:param name="fanRule" />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tbody>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='thermalSubsystemStatus']" /></th>
					<td class="propertyValue" style="vertical-align: middle;">
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$statusCode" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName">
						<xsl:value-of select="$stringsDoc//value[@key='redundancy']" />
					</th>
					<td class="propertyValue">
						<xsl:call-template name="getRedundancyLabel">
							<xsl:with-param name="redundancyMode" select="$redundancyMode" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName">
						<xsl:value-of select="$stringsDoc//value[@key='fanLocationRule']" />
					</th>
					<td class="propertyValue">
						<!--<xsl:choose>
							<xsl:when test="$enclosureType='1'">
								6 fans required for c3000 enclosure
							</xsl:when>
							<xsl:otherwise>-->
								<xsl:value-of select="$fanRule"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='fanRule']" />
							<!--</xsl:otherwise>
						</xsl:choose>-->
					</td>
				</tr>
				<!--<tr>
					<th class="propertyName">
						Fans Required<br />(Non-redundant):
					</th>
					<td class="propertyValue">
						<xsl:value-of select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:neededFans"/>&#160;Fan(s) minimum required to cool the enclosure
					</td>
				</tr>-->
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="rearViewTable">
		<table border="0" cellpadding="0" cellspacing="0" valign="top" style="width: 250px; top: 0px;
						left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border: 0px;">
			<tbody>
				<tr style="width: 250px;">
					<td align="left" colspan="2">
						<xsl:value-of select="$stringsDoc//value[@key='rearView']" />
					</td>
				</tr>
				<tr>
					<td style="height: 184px; border-width: 0px; vertical-align: top;">
						<div style="z-index: 1; position: relative; top: 0px; left: 0px; margin: 0px auto;
										padding: 0px; border: 0px; border-spacing: 0px;">
              
							<xsl:choose>
								<xsl:when test="$enclosureType='1'">
                  <xsl:choose>

                    <xsl:when test="$isTower = 'true'">

                      <img src="/120814-042457/images/rear_view_c3000_t.gif" alt='' style="z-index: 2; position: absolute; vertical-align: top; margin: 0px auto; padding: 0px; border: 0px;" />
                      <div id="Div9" name="idc" style="z-index: 4; position: absolute; top: 65px; left: 17px; vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; height: 122px; width: 100px;">
                        <table border="0" cellpadding="0" cellspacing="0" style="top: 0px;left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width:0px;width: 100px; border-color:Background; border-style:none; font-size: 13px;font-weight: bold; font-family: Arial; background:none">
                          <tbody>
                            <tr>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=3]" >
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                  <xsl:with-param name="isTower" select="'true'" />
                                </xsl:call-template>
                              </xsl:for-each>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=6]" >
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                  <xsl:with-param name="isTower" select="'true'" />
                                </xsl:call-template>
                              </xsl:for-each>
                            </tr>
                            <tr>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=2]" >
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                  <xsl:with-param name="isTower" select="'true'" />
                                </xsl:call-template>
                              </xsl:for-each>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=5]" >
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                  <xsl:with-param name="isTower" select="'true'" />
                                </xsl:call-template>
                              </xsl:for-each>
                            </tr>
                            <tr>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=1]" >
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                  <xsl:with-param name="isTower" select="'true'" />
                                </xsl:call-template>
                              </xsl:for-each>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=4]" >
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                  <xsl:with-param name="isTower" select="'true'" />
                                </xsl:call-template>
                              </xsl:for-each>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                      
                    </xsl:when>
                    <xsl:otherwise>

                      <img src="/120814-042457/images/rear_view_c3000.gif" alt='' style="z-index: 2; position: absolute; vertical-align: top;
											margin: 0px auto; padding: 0px; border: 0px;" />
                      <div id="Div9" name="idc" style="z-index: 4; position: absolute; top: 17px; left: 63px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 122px;
											height: 51px;" title="">
                        <table border="0" cellpadding="0" cellspacing="0" style="top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width:0px;
												width: 100%; height: 51px; border-color:Background; border-style:none; font-size: 13px;
												font-weight: bold; font-family: Arial; background:none">
                          <tbody>
                            <tr>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber &lt; 4]" >
                                <xsl:sort data-type="number" select="hpoa:bayNumber" order="ascending" />
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                </xsl:call-template>
                              </xsl:for-each>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                      <div id="Div10" name="idc" style="z-index: 4; position: absolute; top: 67px; left: 63px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 122px;
											height: 51px;" title="">
                        <table border="0" cellpadding="0" cellspacing="0" style="top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width:0px;
												width: 100%; height: 51px; border-color:Background; border-style:none; font-size: 13px;
												font-weight: bold; font-family: Arial; background:none">
                          <tbody>
                            <tr>
                              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber &gt; 3]" >
                                <xsl:sort data-type="number" select="hpoa:bayNumber" order="ascending" />
                                <xsl:call-template name="fanCell">
                                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                                  <xsl:with-param name="fanInfo" select="current()" />
                                  <xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
                                </xsl:call-template>
                              </xsl:for-each>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                      
                    </xsl:otherwise>
                    
                  </xsl:choose>
                  
								</xsl:when>
								<xsl:otherwise>
									<img src="/120814-042457/images/rear_view.gif" alt='' style="z-index: 2; position: absolute; vertical-align: top;
											margin: 0px auto; padding: 0px; border: 0px;" />
									<div id="Div9" name="idc" style="z-index: 4; position: absolute; top: 2px; left: 24px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 202px;
											height: 51px;" title="">
										<table border="0" cellpadding="0" cellspacing="0" style="top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width:0px;
												width: 100%; height: 51px; border-color:Background; border-style:none; font-size: 13px;
												font-weight: bold; font-family: Arial; background:none">
											<tbody>
												<tr>
													<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber &lt; 6]" >
														<xsl:sort data-type="number" select="hpoa:bayNumber" order="ascending" />
														<xsl:call-template name="fanCell">
															<xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
															<xsl:with-param name="fanInfo" select="current()" />
															<xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
														</xsl:call-template>
													</xsl:for-each>
												</tr>
											</tbody>
										</table>
									</div>
									<div id="Div10" name="idc" style="z-index: 4; position: absolute; top: 137px; left: 24px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 202px;
											height: 51px;" title="">
										<table border="0" cellpadding="0" cellspacing="0" style="top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width:0px;
												width: 100%; height: 51px; border-color:Background; border-style:none; font-size: 13px;
												font-weight: bold; font-family: Arial; background:none">
											<tbody>
												<tr>
													<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber &gt; 5]" >
														<xsl:sort data-type="number" select="hpoa:bayNumber" order="ascending" />
														<xsl:call-template name="fanCell">
															<xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
															<xsl:with-param name="fanInfo" select="current()" />
															<xsl:with-param name="fanRule" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:wantedFans"/>
														</xsl:call-template>
													</xsl:for-each>
												</tr>
											</tbody>
										</table>
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name ="fanListTable">
		<span class="whiteSpacer">&#160;</span>
		<br />
		<table cellpadding="0" cellspacing="0" class="dataTable" ID="fanListTable" style="
				vertical-align: top; margin: 0px auto; padding: 0px;
				width: 100%;margin-top:2px;">
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='fan']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='model']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='status']" />
					</th>
					<th style="text-align:right;"><xsl:value-of select="$stringsDoc//value[@key='fanSpeedOfMax']" /></th>
				</tr>
			</thead>
			<tbody>
				<xsl:choose>
					<xsl:when test="count($fanInfoDoc//hpoa:fanInfo[hpoa:presence=$PRESENT])&gt;0">

						<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo">
							<!--
									  Determine if the row is odd or even using Mod division, and set the
									  table row class appropriately.
								  -->
							<xsl:variable name="alternateRowClass">
								<xsl:if test="position() mod 2 = 0">altRowColor</xsl:if>
							</xsl:variable>

							<!-- Table row element for each of the bay values in the array -->
							<xsl:element name="tr">

								<!-- Set the class attribute of the table cell for alternating -->
								<xsl:attribute name="class">
									<xsl:value-of select="$alternateRowClass" />
								</xsl:attribute>

								<td>
									<xsl:call-template name="getFanLink">
										<xsl:with-param name="fanInfo" select="current()" />
										<xsl:with-param name="encNum" select="$encNum" />
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="hpoa:name"/>
								</td>
								<xsl:choose>
									<xsl:when test="hpoa:presence != $ABSENT or hpoa:operationalStatus!='OP_STATUS_UNKNOWN'">
										<td>
											<xsl:choose>
												<xsl:when test="hpoa:diagnosticChecks/hpoa:deviceLocationError='ERROR'">
													<xsl:call-template name="statusIcon" >
														<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
													</xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='improperLocation']" />
												</xsl:when>
												<xsl:when test="hpoa:presence='ABSENT' and hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='deviceMissing']='ERROR'">
													<xsl:call-template name="statusIcon" >
														<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
													</xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='fanNeeded']" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="getStatusLabel">
														<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td style="text-align:right;">
											<xsl:choose>
												<xsl:when test="hpoa:presence='ABSENT' and hpoa:operationalStatus!='OP_STATUS_UNKNOWN'">
													<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
												</xsl:when>
												<xsl:when test="hpoa:presence='ABSENT' and hpoa:operationalStatus='OP_STATUS_UNKNOWN'">
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="getFanSpeedPercent">
														<xsl:with-param name="rpm" select="hpoa:fanSpeed" />
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td><xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" /></td>
										<td style="text-align:right;">&#160;</td>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="$fanInfoDoc='' or count($fanInfoDoc//hpoa:fanInfo[hpoa:presence='PRESENCE_NO_OP'])=$numFansPerEnclosure">
						<tr class="noDataRow">
							<td colspan="4"><xsl:value-of select="$stringsDoc//value[@key='noPermissionFan']" /></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr class="noDataRow">
							<td colspan="4"><xsl:value-of select="$stringsDoc//value[@key='thereNoFanToDisplay']" /></td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<!-- Fan cell template -->
	<xsl:template name="fanCell">
		<xsl:param name="fanNumber" />
		<xsl:param name="fanInfo" />
		<xsl:param name="fanRule" />
		<xsl:param name="presence" select="hpoa:presence" />
    <xsl:param name="isTower" select="'false'" />
    
		<xsl:variable name="status" select="hpoa:operationalStatus" />
		<xsl:variable name="myId">
			<xsl:value-of select="concat('fan', $fanNumber, 'Select')" />
		</xsl:variable>
		<xsl:variable name="numFansPerRow">
			<xsl:choose>
				<xsl:when test="$enclosureType='1'">
					3
				</xsl:when>
				<xsl:otherwise>
					5
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="deviceImage">
			<xsl:choose>
				<xsl:when test="hpoa:presence=$PRESENT">
					<xsl:choose>
						<xsl:when test="$fanNumber &lt;= $numFansPerRow">
              <xsl:choose>
                <xsl:when test="$isTower='true'">
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan_t.gif')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan.gif')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$isTower='true'">
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan_bot_t.gif')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan_bot.gif')" />
                </xsl:otherwise>
              </xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$fanNumber &lt;= $numFansPerRow">
              <xsl:choose>
                <xsl:when test="$isTower='true'">
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan_blank_t.gif')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan_blank.gif')" />
                </xsl:otherwise>
              </xsl:choose>
						</xsl:when>
						<xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$isTower='true'">
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan_bot_blank_t.gif')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="string('/120814-042457/images/rear_view_fan_bot_blank.gif')" />
                </xsl:otherwise>
              </xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="td">
			<xsl:attribute name="align">center</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$enclosureType='1'">
						<!-- c3000 fan rules:
						4 - Fan bays 2, 4, 5, and 6 - device bays 1, 2, 5, or 6
						6 - Fan bays all  - device bays all -->
						<xsl:choose>
							<xsl:when test="$fanNumber=2 or $fanNumber=4 or $fanNumber=5 or $fanNumber=6">
								<xsl:attribute name="class">zoneHighlight</xsl:attribute>
							</xsl:when>
							<xsl:when test="($fanNumber=1 or $fanNumber=3) and ($fanRule=6)">
								<xsl:attribute name="class">zoneHighlight</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">zone</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- c7000 fan rules:
						4 - Fan bays 4, 5, 9, and 10 - device bays 1, 2, 9, or 10
						6 - Fan bays 3, 4, 5, 8, 9, and 10 - device bays 1, 2, 3, 4, 7, 8, 9, or 10
						8 - Fan bays 1, 2, 4, 5, 6, 7, 9, and 10  - device bays all
						10 - Fan bays all  - device bays all -->
						<xsl:choose>
							<xsl:when test="$fanNumber=4 or $fanNumber=5 or $fanNumber=9 or $fanNumber=10">
								<xsl:attribute name="class">zoneHighlight</xsl:attribute>
							</xsl:when>
							<xsl:when test="($fanNumber=3 or $fanNumber=8) and ($fanRule=6 or $fanRule=10)">
								<xsl:attribute name="class">zoneHighlight</xsl:attribute>
							</xsl:when>
							<xsl:when test="($fanNumber=1 or $fanNumber=2 or $fanNumber=6 or $fanNumber=7) and ($fanRule=8 or $fanRule=10)">
								<xsl:attribute name="class">zoneHighlight</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">zone</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>

			<xsl:choose>

        <xsl:when test="$isTower='true'">

          <xsl:choose>
            <xsl:when test="$fanNumber &lt;= $numFansPerRow">
              <xsl:attribute name="valign">middle</xsl:attribute>
              <xsl:attribute name="style">height:40px;width:51px;vertical-align: middle;text-align:right;padding-right:2px;</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="valign">middle</xsl:attribute>
              <xsl:attribute name="style">width:51px;height:40px;vertical-align: middle;text-align:left;padding-left:2px;</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:attribute name="height">40</xsl:attribute>
          <xsl:attribute name="width">51</xsl:attribute>
          
        </xsl:when>
        <xsl:otherwise>

          <xsl:choose>
            <xsl:when test="$fanNumber &lt;= $numFansPerRow">
              <xsl:attribute name="valign">bottom</xsl:attribute>
              <xsl:attribute name="style">width:40px;height:51px;vertical-align: bottom;</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="valign">top</xsl:attribute>
              <xsl:attribute name="style">width:40px;height:51px;vertical-align: top;</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:attribute name="height">51</xsl:attribute>
          <xsl:attribute name="width">40</xsl:attribute>
          <xsl:attribute name="align">center</xsl:attribute>
          
        </xsl:otherwise>
        
			</xsl:choose>
      
			<xsl:attribute name="background">
				<xsl:value-of select="$deviceImage" />
			</xsl:attribute>
			<xsl:call-template name="getFanLink">
				<xsl:with-param name="fanInfo" select="." />
				<xsl:with-param name="foreground-color">white</xsl:with-param>
				<xsl:with-param name="encNum" select="$encNum" />
			</xsl:call-template>
		</xsl:element>
	</xsl:template>

	<xsl:template name="fanRuleHelp">

		<!--
	The following is for fanInfo's only right now.
	4 - Fan bays 4, 5, 9, and 10 - device bays 1, 2, 9, or 10
	6 - Fan bays 3, 4, 5, 8, 9, and 10 - device bays 1, 2, 3, 4, 7, 8, 9, or 10
	8 - Fan bays 1, 2, 4, 5, 6, 7, 9, and 10  - device bays all 10 - Fan bays all  - device bays all

			If (hpoa:deviceLocationError==ERROR) || ( hpoa:diagnosticData hpoa:name="deviceMissing"==ERROR )-->
		<xsl:variable name="locationErrors" select="count($fanInfoDoc//hpoa:fanInfo/hpoa:diagnosticChecks[hpoa:deviceLocationError='ERROR'])" />
		<xsl:variable name="missingErrors" select="count($fanInfoDoc//hpoa:fanInfo/hpoa:diagnosticChecksEx[hpoa:diagnosticData[@hpoa:name='deviceMissing']='ERROR'])" />

		<xsl:if test="$locationErrors&gt;0 or $missingErrors&gt;0">
			<span>
				<xsl:value-of select="$stringsDoc//value[@key='repairOptions']" />:<br/><br/>
			</span>

			<span>
				<xsl:value-of select="$stringsDoc//value[@key='belowSuggestionToFixThermalSubsystemStatus']" />:<br/><br/>
			</span>

			<xsl:if test="$missingErrors=1">
				<span>
					<xsl:value-of select="$stringsDoc//value[@key='forCurrentFanRuleNeedInBay']" />&#160;<xsl:value-of select="$fanInfoDoc//hpoa:fanInfo[hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='deviceMissing']='ERROR']//hpoa:bayNumber" />.
					<br />
				</span>
			</xsl:if>
			<xsl:if test="$missingErrors&gt;1">
				<span><xsl:value-of select="$stringsDoc//value[@key='forCurrentFanRuleNeedInFollowingBay']" />&#160;</span>
				<!--Count number of fans that have ( hpoa:diagnosticData hpoa:name="deviceMissing"==ERROR )-->
				<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='deviceMissing']='ERROR']">
					<xsl:value-of select="hpoa:bayNumber" />
					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>.
			</xsl:if>

			<xsl:if test="$locationErrors=1">
				<span>
					<br />
					<xsl:value-of select="$stringsDoc//value[@key='forFollowingFanLocationNoNeedCurrentFanRule']" />&#160;
					<xsl:value-of select="$fanInfoDoc//hpoa:fanInfo[hpoa:diagnosticChecks[hpoa:deviceLocationError='ERROR']]/hpoa:bayNumber"/>.
				</span>
				<!--Count number of fans that have ( hpoa:diagnosticData hpoa:name="deviceMissing"==ERROR )
				< list fans="" with="" "," seperators=""  >
					"Consider moving one or more of these to one of the needed bays listed above."-->
			</xsl:if>
			<xsl:if test="$locationErrors&gt;1">
				<span>
					<br /><xsl:value-of select="$stringsDoc//value[@key='forFollowingFanLocationNoNeedCurrentFanRule2']" />
					<!--Count number of fans that have ( hpoa:diagnosticData hpoa:name="deviceMissing"==ERROR )-->
					<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:diagnosticChecks[hpoa:deviceLocationError='ERROR']]">
						<xsl:value-of select="hpoa:bayNumber" />
						<xsl:if test="position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>.<br />
					<xsl:value-of select="$stringsDoc//value[@key='moveOneOrMoreNeeds']" />
				</span>
			</xsl:if>

			<!-- at some point in each page give a description and a link to the fan rule help page -->
			<span>
				<br/><br/><br/><xsl:value-of select="$stringsDoc//value[@key='fanRuleHelpNote']" />
			</span>

		</xsl:if>
	</xsl:template>
</xsl:stylesheet>


