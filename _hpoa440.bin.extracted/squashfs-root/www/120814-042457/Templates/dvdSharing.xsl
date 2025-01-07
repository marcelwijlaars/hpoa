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

	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="bladeStatusDoc" />
	<xsl:param name="bladeMpInfoDoc" />
	<xsl:param name="virtualMediaUrlListDoc" />
	<xsl:param name="virtualMediaStatusDoc" />
	<xsl:param name="oaMediaDeviceList" />
	<xsl:param name="serviceUserAcl" />
	<!--<xsl:param name="firmwareManagementSettings" />-->

	<xsl:param name="stringsDoc" />
	
	<xsl:template match="*">

		<b><xsl:value-of select="$stringsDoc//value[@key='dvdDrive']" /></b><br />
		
		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:value-of select="$stringsDoc//value[@key='dvdShareDesc']" /><br />
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<xsl:value-of select="$stringsDoc//value[@key='note:']" /> <em>
			<xsl:value-of select="$stringsDoc//value[@key='dvdShareNote']" />
		</em><br />
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div class="errorDisplay" id="dvdErrorDisplay"></div>

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					<h3 class="subTitle">
						<xsl:value-of select="$stringsDoc//value[@key='deviceList']" />
					</h3>
					<div class="subTitleBottomEdge" style="margin-bottom:0px;"></div>
				</td>
			</tr>
			<tr>
				<xsl:choose>
					<xsl:when test="$serviceUserAcl != 'USER'">
						<td style="background-color:#cccccc;">
							<xsl:call-template name="menuRow" />
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td style="background-color:#cccccc;">
							<span class="whiteSpacer">&#160;</span>
							<br />
						</td>
					</xsl:otherwise>
				</xsl:choose>
				
			</tr>
			<tr>
				<td style="background-color:#cccccc;padding:0px 10px 10px 10px;">
					<!-- Bay summary table -->
					<xsl:element name="table">
						<xsl:attribute name="cellpadding">0</xsl:attribute>
						<xsl:attribute name="cellspacing">0</xsl:attribute>
						<xsl:attribute name="class">dataTable</xsl:attribute>
						<xsl:attribute name="style">width:100%;</xsl:attribute>
						<xsl:attribute name="id">dvdSharingTable</xsl:attribute>

						<thead>
							<tr class="captionRow">

								<th style="vertical-align:middle;width:10px;" nowrap="true">
									<input type="checkbox" devid="bay" id="summaryMaster" tableid="dvdSharingTable"/>
								</th>

								<th style="vertical-align:middle;">
									<xsl:value-of select="$stringsDoc//value[@key='bay']" />
								</th>

								<th style="vertical-align:middle;" nowrap="true">
									<xsl:value-of select="$stringsDoc//value[@key='powerState']" />
								</th>

								<th style="vertical-align:middle;" nowrap="true">
									<xsl:value-of select="$stringsDoc//value[@key='remoteConsole']" />
								</th>

								<th style="vertical-align:middle;" nowrap="true">
									<xsl:value-of select="$stringsDoc//value[@key='iloDVDStatus']" />
								</th>

								<th style="vertical-align:middle;" nowrap="true">
									<xsl:value-of select="$stringsDoc//value[@key='deviceOrImgURL']" />
								</th>

							</tr>
						</thead>
            
            <xsl:choose>
              <xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence='PRESENT' and hpoa:bladeType='BLADE_TYPE_SERVER']) &gt; 0">
                <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:presence='PRESENT' and hpoa:bladeType='BLADE_TYPE_SERVER']">
					<xsl:sort select="hpoa:extraData[@hpoa:name='NormalizedBayNumber']" data-type="number" />
					<xsl:sort select="hpoa:extraData[@hpoa:name='NormalizedSideNumber']" />

					<xsl:variable name="bayNumber" select="hpoa:bayNumber"/>
					<xsl:variable name="symbolicBayNumber" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />

					<xsl:if test="count(hpoa:extraData[@hpoa:name='monarchBlade'])=0 or (hpoa:extraData[@hpoa:name='monarchBlade' and .=0]) or (hpoa:extraData[@hpoa:name='monarchBlade' and .=$bayNumber])">
						<xsl:element name="tr">

							<xsl:if test="position() mod 2 = 0">
								<xsl:attribute name="class">altRowColor</xsl:attribute>
								<xsl:attribute name="originalClass">altRowColor</xsl:attribute>
							</xsl:if>

							<td style="vertical-align:middle;">
								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="devid">bay</xsl:attribute>
									<xsl:attribute name="affectsMenus">true</xsl:attribute>
									<xsl:attribute name="bladeType">
										<xsl:value-of select="hpoa:bladeType"/>
									</xsl:attribute>
									<xsl:attribute name="productId">
										<xsl:value-of select="hpoa:productId"/>
									</xsl:attribute>
									<xsl:attribute name="bayNumber">
										<xsl:value-of select="$bayNumber"/>
									</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat('chk', $bayNumber)"/>
									</xsl:attribute>
									<xsl:attribute name="rowselector">yes</xsl:attribute>
								</xsl:element>
							</td>

							<td style="vertical-align:middle;">
								<xsl:value-of select="$symbolicBayNumber" />
							</td>

							<td style="vertical-align:middle;">
								<div id="{concat('bay', $bayNumber, 'powerState')}">
									<xsl:call-template name="getPowerStateLabel">
										<xsl:with-param name="powerState" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$bayNumber]/hpoa:powered" />
									</xsl:call-template>
								</div>
							</td>

							<td style="vertical-align:middle;" nowrap="true">

								<xsl:variable name="productId" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]/hpoa:productId" />

								<xsl:choose>

									<!-- Integrity iLO -->
									<xsl:when test="$productId='4609'">

										<xsl:element name="a">
											<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
											<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$bladeMpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$bayNumber]/hpoa:loginUrl"/>', '');</xsl:attribute>
											<xsl:value-of select="$stringsDoc//value[@key='webAdmin']"/>
										</xsl:element>

									</xsl:when>

									<!-- ProLiant iLO -->
									<xsl:when test="$productId='8224'">

										<table cellpadding="0" cellspading="0" border="0">
											<tr>
												<td style="border:0px none;">
													<select id="{concat('bay', $bayNumber, 'RcSelect')}">
														<option value="hpoa:ircUrl"><xsl:value-of select="$stringsDoc//value[@key='integratedRemoteConsoleIE']"  /></option>
														<option value="hpoa:remoteConsoleUrl"><xsl:value-of select="$stringsDoc//value[@key='remoteConsoleAppletJava']"  /></option>
													</select>
												</td>
												<td style="border:0px none;padding-left:3px;vertical-align:bottom;">
													<xsl:element name="a">
														<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
														<xsl:attribute name="onclick">startRcLaunch(<xsl:value-of select="$bayNumber"/>);</xsl:attribute>
														<xsl:value-of select="$stringsDoc//value[@key='launch']" />
													</xsl:element>
												</td>
											</tr>
										</table>

									</xsl:when>

								</xsl:choose>

							</td>

							<xsl:choose>
								<xsl:when test="count($virtualMediaStatusDoc//hpoa:virtualMediaStatus[hpoa:bayNumber=$bayNumber]) &gt; 0">

									<xsl:for-each select="$virtualMediaStatusDoc//hpoa:virtualMediaStatus[hpoa:bayNumber=$bayNumber]">

										<!-- Status cell -->
										<td style="vertical-align:middle;">
											<div id="{concat('bay', $bayNumber, 'VmStatus')}">

												<xsl:call-template name="getDvdStatusLabel">
													<xsl:with-param name="dvdSupport" select="hpoa:support" />
													<xsl:with-param name="dvdStatus" select="hpoa:cdromStatus" />
												</xsl:call-template>

											</div>
											<input type="hidden" name="vmStatusNeeded" value="{$bayNumber}" />
										</td>

										<!-- Device/URL cell -->
										<td style="vertical-align:middle;">

											<div id="{concat('bay', $bayNumber, 'DevUrl')}">

												<xsl:variable name="bladeUrl" select="hpoa:cdromUrl" />

												<xsl:choose>
													<xsl:when test="$bladeUrl = 'tray_open://'">
														<xsl:value-of select="$stringsDoc//value[@key='trayOpenOrNoMedia']" />
													</xsl:when>
													<xsl:when test="$bladeUrl = 'http://169.254.0.1/fcgi-bin/dvd.iso'">
														<xsl:value-of select="$stringsDoc//value[@key='encDVD']" />
													</xsl:when>
													<xsl:when test="$bladeUrl = 'http://169.254.0.2/fcgi-bin/dvd.iso'">
														<xsl:value-of select="$stringsDoc//value[@key='encDVD']" />
													</xsl:when>
													<!--
													<xsl:when test="$bladeUrl = $firmwareManagementSettings//hpoa:firmwareManagementSettings/hpoa:isoUrl">
														[<xsl:value-of select="$stringsDoc//value[@key='firmwareManagement']" />]
													</xsl:when>
													-->
													<xsl:otherwise>
														<xsl:value-of select="$bladeUrl"/>
													</xsl:otherwise>
												</xsl:choose>

											</div>

										</td>

									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<td style="vertical-align:middle;">
										<div id="{concat('bay', $bayNumber, 'VmStatus')}">&#160;</div>
										<input type="hidden" name="vmStatusNeeded" value="{$bayNumber}" />
									</td>
									<td style="vertical-align:middle;">
										<div id="{concat('bay', $bayNumber, 'DevUrl')}">&#160;</div>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:if>

				</xsl:for-each>
              </xsl:when>
							<!-- Check for some permissions and some locked. -->
							<xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$PRESENT])=0 and (count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence='PRESENCE_NO_OP']) &gt; 0 or count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$LOCKED]) &gt; 0)">
								<tr class="noDataRow">
									<td colspan="6">
										<xsl:value-of select="$stringsDoc//value[@key='noAllPermissionDeviceBay1']" />
										<br />
										<xsl:value-of select="$stringsDoc//value[@key='noAllPermissionDeviceBay2']" />
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<tr class="noDataRow">
									<td colspan="6">
										<xsl:value-of select="$stringsDoc//value[@key='noDeviceToDisplay']" />
									</td>
								</tr>
							</xsl:otherwise>
        </xsl:choose>
			</xsl:element>
			<!-- //table -->

				</td>
			</tr>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />

		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' onclick="refreshSummary();">
								<xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>

	<!-- 
    @Purpose: Adds a new row with menus for setting UID, power modes, and for resetting iLOs.
    @Created: 11-08-2005
    @Author : michael.slama@hp.com
    @mods   : 12-16-2005 -mds: added menu disabling functionality by adding a method to the 
              DropdownMenuManager class and adding logic to the onclick handlers of the anchors. 
              The device selection checkboxes also received an attribute 'affectsMenus' so they
              can be distinguished at runtime.
              
              09-21-2006 -mds: added One Time Boot menu - needs handler.
  -->
	<xsl:template name="menuRow">

		<xsl:param name="dvdUrl" />
		
		<table style="background-color:#cccccc;margin-left:3px;">
			<tr>
				<td colspan="6" style="background-color:#CCCCCC;padding:2px;">
					<table style="border:0px;width:100%;">
						<tr>
							<td style="border:0px;background-color:#CCCCCC;" onmouseover="updateMenuStatus();">
								<div id="m01_trigger" class="localNavTrigger">
									<xsl:value-of select="$stringsDoc//value[@key='virtualPower']" />
									<ul id="m01" class="dropdownMenu" isdropdownmenu="yes" >
										<li id="momentaryPress" class="">
											<a href="javascript:void(0);" onmouseover="window.status='';return true;" 
												onclick="(this.parentNode.className=='disabled' ? '':setBladesPower('MOMENTARY_PRESS'))">
												<xsl:value-of select="$stringsDoc//value[@key='momentaryPress']" />
											</a>
										</li>
										<li id="pressHold" class="">
											<a href="javascript:void(0)" onmouseover="window.status='';return true;" onclick="(this.parentNode.className=='disabled' ? '':setBladesPower(PRESS_AND_HOLD()));">
												<xsl:value-of select="$stringsDoc//value[@key='pressHold']" />
											</a>
										</li>
										<li id="coldBoot" class="">
											<a href="javascript:void(0);" onmouseover="window.status='';return true;" 
												onclick="(this.parentNode.className=='disabled' ? '':setBladesPower('COLD_BOOT'))">
												<xsl:value-of select="$stringsDoc//value[@key='coldBoot']" />
											</a>
										</li>
									</ul>
								</div>

								<div id="m03_trigger" class="localNavTrigger">
									<xsl:value-of select="$stringsDoc//value[@key='oneTimeBoot']" />
									<ul id="m03" class="dropdownMenu" isdropdownmenu="yes">
										<li id="floppy" class="">
											<a href="javascript:void(0)" onmouseover="window.status='';return true;" onclick="(this.parentNode.className=='disabled' ? '':setBladeFirstTimeBoot('ONE_TIME_BOOT_FLOPPY'));">
												<xsl:value-of select="$stringsDoc//value[@key='fdDriveA']" />
											</a>
										</li>
										<li id="CDROM" class="">
											<a href="javascript:void(0)" onmouseover="window.status='';return true;" onclick="(this.parentNode.className=='disabled' ? '':setBladeFirstTimeBoot('ONE_TIME_BOOT_CD'));">
												<xsl:value-of select="'CD-ROM'" />
											</a>
										</li>
										<li id="hardDisk" class="">
											<a href="javascript:void(0)" onmouseover="window.status='';return true;" onclick="(this.parentNode.className=='disabled' ? '':setBladeFirstTimeBoot('ONE_TIME_BOOT_HARD_DRIVE'));">
												<xsl:value-of select="$stringsDoc//value[@key='hddDriveC']" />
											</a>
										</li>
										<li id="RBSU" class="">
											<a href="javascript:void(0)" onmouseover="window.status='';return true;" onclick="(this.parentNode.className=='disabled' ? '':setBladeFirstTimeBoot('RBSU'));">
												<xsl:value-of select="'RBSU'" />
											</a>
										</li>
										<li id="PXE" class="">
											<a href="javascript:void(0)" onmouseover="window.status='';return true;" onclick="(this.parentNode.className=='disabled' ? '':setBladeFirstTimeBoot('PXE'));">
												<xsl:value-of select="'PXE NIC'" />
											</a>
										</li>
									</ul>
								</div>

								<div id="m04_trigger" class="localNavTrigger">
									DVD

									<ul id="m04" class="dropdownMenu" isdropdownmenu="yes">
										
									<xsl:choose>
										<xsl:when test="1 = 0"> <!-- Allow user to disconnect even when no DVD/USB is present.
										<xsl:when test="count($oaMediaDeviceList//hpoa:oaMediaDevice[(hpoa:deviceType=1 or hpoa:deviceType=2) and hpoa:devicePresence='PRESENT']) = 0">
										 -->
											<li class="disabled"><xsl:value-of select="$stringsDoc//value[@key='noDVDdrvEnc']" /></li>
										</xsl:when>
										<xsl:when test="1 = 0"> <!-- Allow user to disconnect even when no DVD/USB is present.
										<xsl:when test="(count($oaMediaDeviceList//hpoa:oaMediaDevice[(hpoa:deviceType=1 or hpoa:deviceType=2) and hpoa:devicePresence='PRESENT']) &gt; 0) and (count($oaMediaDeviceList//hpoa:oaMediaDevice[(hpoa:deviceType=1 or hpoa:deviceType=2) and hpoa:mediaPresence='PRESENT']) = 0)">
										 -->
											<li class="disabled"><xsl:value-of select="$stringsDoc//value[@key='noMediaDVDDrive']" /></li>
										</xsl:when>
										<xsl:otherwise>

											<xsl:for-each select="$virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=' ' or @hpoa:value='']">

												<li>

													<xsl:element name="a">

														<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
														<xsl:attribute name="onmouseover">window.status='';return true;</xsl:attribute>
														<xsl:attribute name="onclick">connectServers('<xsl:value-of select="@hpoa:value" />');</xsl:attribute>
														<xsl:choose>
															<xsl:when test="@hpoa:property='Connect to Enclosure DVD'">
																<xsl:value-of select="$stringsDoc//value[@key='connectEncDVD']"/>
															</xsl:when>
															<xsl:when test="@hpoa:property='Disconnect DVD Hardware'">
																<xsl:value-of select="$stringsDoc//value[@key='disconnectEncDVD']"/>
															</xsl:when>
															<xsl:when test="@hpoa:property='Disconnect Blade from DVD/iso'">
																<xsl:value-of select="$stringsDoc//value[@key='disconnectBladeDVDiso']"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="@hpoa:property" />
															</xsl:otherwise>
														</xsl:choose>

													</xsl:element>

												</li>

											</xsl:for-each>

											<xsl:for-each select="$virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value!=' ' and @hpoa:value!='']">

												<li>

													<xsl:element name="a">

														<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
														<xsl:attribute name="onmouseover">window.status='';return true;</xsl:attribute>
														<xsl:attribute name="onclick">connectServers('<xsl:value-of select="@hpoa:value" />');</xsl:attribute>
														<xsl:choose>
															<xsl:when test="@hpoa:property='Connect to Enclosure DVD'">
																<xsl:value-of select="$stringsDoc//value[@key='connectEncDVD']"/>
															</xsl:when>
															<xsl:when test="@hpoa:property='Disconnect DVD Hardware'">
																<xsl:value-of select="$stringsDoc//value[@key='disconnectEncDVD']"/>
															</xsl:when>
															<xsl:when test="@hpoa:property='Disconnect Blade from DVD/iso'">
																<xsl:value-of select="$stringsDoc//value[@key='disconnectBladeDVDiso']"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="@hpoa:property" />
															</xsl:otherwise>
														</xsl:choose>
													</xsl:element>

												</li>

											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
									</ul>
								</div>
									
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

	</xsl:template>
	
</xsl:stylesheet>
