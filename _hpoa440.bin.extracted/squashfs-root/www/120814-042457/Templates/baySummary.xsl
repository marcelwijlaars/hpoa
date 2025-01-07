<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />

	<!-- XML document parameters containing bay information and status -->
	<xsl:param name="stringsDoc" />
	<xsl:param name="encNum" />
	<xsl:param name="fwVersion" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="bladeStatusDoc" />
	<xsl:param name="enclosureInfoDoc" />
	<xsl:param name="mpInfoDoc" />
	<xsl:param name="virtualMediaUrlListDoc" />
	<xsl:param name="virtualMediaStatusDoc" />
	<xsl:param name="oaMediaDeviceList" />
	<xsl:param name="serviceUserAcl" />
  <xsl:param name="firmwareMgmtSupported" select="'false'" />
	
	<xsl:template match="*">

		<xsl:variable name="colSpan">
			<xsl:choose>
				<xsl:when test="number($fwVersion) &gt;= number('2.00')">
					<xsl:value-of select="number(8)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(7)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="errorDisplay" id="summaryErrorDisplay"></div>
		
	  <table border="0" cellpadding="0" cellspacing="0" width="102%">
		  <tr>
			  <td>
				  <h3 class="subTitle">
					  <xsl:value-of select="$stringsDoc//value[@key='deviceList']" />
				  </h3>
				  <div class="subTitleBottomEdge" style="margin-bottom:0px;"></div>
			  </td>
		  </tr>
		  <tr>
			  <td style="background-color:#cccccc;">
				  <xsl:call-template name="menuRow" >
					  <xsl:with-param name="colSpan" select="$colSpan" />
				  </xsl:call-template>
			  </td>
		  </tr>
		  <tr>
			  <td style="background-color:#cccccc;padding:0px 10px 10px 10px;">
				  <!-- Bay summary table -->
				  <table border="0" cellpadding="0" cellspacing="0" class="dataTable" style="width:100%;" id="summaryTable">
					  <thead>
						  <tr class="captionRow">
							  <th style="width:10px;">
								  <xsl:if test="count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$PRESENT])&gt;0">
									  <input type="checkbox" devid="bay" id="summaryMaster" tableid="summaryTable"/>
								  </xsl:if>
							  </th>

							  <th style="vertical-align:middle;">
								  <xsl:value-of select="$stringsDoc//value[@key='bay']" />
							  </th>
							  <th style="vertical-align:middle;">
								  <xsl:value-of select="$stringsDoc//value[@key='status']" />
							  </th>
							  <th style="vertical-align:middle;">
								  UID
							  </th>
							  <th style="vertical-align:middle;">
								  <xsl:value-of select="$stringsDoc//value[@key='powerState']" />
							  </th>
							  <th style="vertical-align:middle;">
								  <xsl:value-of select="$stringsDoc//value[@key='iLoIpAddress']" />
							  </th>
							  <th style="vertical-align:middle;">
								  <xsl:value-of select="$stringsDoc//value[@key='iloName']" />
							  </th>
							  <xsl:if test="number($colSpan) &gt;= number('8')">
								  <th style="vertical-align:middle;">
									  <xsl:value-of select="$stringsDoc//value[@key='iloDVDStatus']" />
								  </th>
							  </xsl:if>
						  </tr>
					  </thead>
					  <tbody>

						  <xsl:choose>
							  <xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$PRESENT])&gt;0">

								  <!-- Loop through each of the bay values in the blade info document. -->
								  <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$PRESENT]">
									  <xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
									  <xsl:variable name="delayRemaining" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='PowerDelayRemaining']" />
									  <xsl:variable name="symbolicBladeNumber" select="hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
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

										  <xsl:attribute name="originalClass"><xsl:value-of select="$alternateRowClass"/></xsl:attribute>

										  <td style="vertical-align:middle;">
											  <xsl:element name="input">
												  <xsl:attribute name="type">checkbox</xsl:attribute>
												  <xsl:attribute name="devid">bay</xsl:attribute>
												  <xsl:attribute name="affectsMenus">true</xsl:attribute>
												  <xsl:attribute name="bladeType"><xsl:value-of select="hpoa:bladeType"/></xsl:attribute>
												  <xsl:attribute name="productId"><xsl:value-of select="hpoa:productId"/></xsl:attribute>
												  <xsl:attribute name="bayNumber"><xsl:value-of select="hpoa:bayNumber"/></xsl:attribute>
												  <xsl:attribute name="id"><xsl:value-of select="concat('chk', hpoa:bayNumber)"/></xsl:attribute>
												  <xsl:attribute name="uidState"><xsl:value-of select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:uid"/></xsl:attribute>
												  <xsl:attribute name="rowselector">yes</xsl:attribute>
											  </xsl:element>
										  </td>
										  <td style="vertical-align:middle;">
											  <xsl:element name="a">
												  <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="hpoa:bayNumber" />);</xsl:attribute>
												  <xsl:value-of select="$symbolicBladeNumber" />
											  </xsl:element>
										  </td>

										  <!--
												Get the current bay's blade status value. Call the Status Label template
												to set the text and image for the current bay's blade status.
											-->
										  <td style="vertical-align:middle;">

											  <div id="{concat('bay', $currentBayNumber, 'status')}">
												  <xsl:call-template name="getStatusLabel">
													  <xsl:with-param name="statusCode" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:operationalStatus" />
												  </xsl:call-template>
											  </div>
											  
										  </td>

										  <!--
												Get the UID value for the current bay's blade. Call the UID Label template
												to set the text and image for the UID's state.
											-->
										  <td style="vertical-align:middle;" nowrap="true">
											  <div id="{concat('bay', $currentBayNumber, 'uid')}">
												  <xsl:call-template name="getUIDLabel">
													  <xsl:with-param name="statusCode" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:uid" />
												  </xsl:call-template>
											  </div>												  
										  </td>

										  <!--
												Get the power state for the current bay's blade. Call the Power State
												Label template to get the text for the blade's power state.
											-->
										  <td style="vertical-align:middle;">
											  <div id="{concat('bay', $currentBayNumber, 'powerState')}">

												  <xsl:choose>
													  <xsl:when test="number($delayRemaining) &gt; 0">
														  <xsl:value-of select="$stringsDoc//value[@key='delayed']" /> (<xsl:value-of select="$delayRemaining"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='seconds']" />)
													  </xsl:when>
													  <xsl:when test="number($delayRemaining)=-1">
														  <xsl:value-of select="$stringsDoc//value[@key='delayed']" /> - <xsl:value-of select="$stringsDoc//value[@key='noPoweron']"/>
													  </xsl:when>
													  <xsl:otherwise>
														  <xsl:call-template name="getPowerStateLabel">
															  <xsl:with-param name="powerState" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:powered" />
														  </xsl:call-template>
													  </xsl:otherwise>
												  </xsl:choose>

											  </div>
										  </td>
										  
										  <td style="vertical-align:middle;">

											  <div id="{concat('bay', $currentBayNumber, 'iLO-Ip')}">
												  
												  <xsl:variable name="productId" select="hpoa:productId" />

												  <xsl:variable name="isThereBayIPv6">
													  <xsl:call-template name="checkIfExistBayIPv6">
														  <xsl:with-param name="mpInfoDoc" select="$mpInfoDoc"/>
														  <xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
													  </xsl:call-template>
												  </xsl:variable>

												  <xsl:variable name="ipAddress" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:ipAddress" />
												  <xsl:variable name="loginUrl" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:loginUrl" />
												  <xsl:variable name="webUrl" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:webUrl" />
												  <xsl:variable name="fqdn" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name = 'iLOFQDN']" />
												  
												  <xsl:choose>
													  <xsl:when test="hpoa:bladeType='BLADE_TYPE_SERVER' or $productId='8213'">
														  <xsl:choose>
															  <xsl:when test="string-length($fqdn) &gt; 0">
																  <xsl:choose>
																	  <xsl:when test="$productId=8224 or $productId=4609 or $productId=33282">
																		  <xsl:element name="a">
																			  <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
																			  <xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$currentBayNumber"/>', '<xsl:value-of select="$loginUrl"/>', '<xsl:value-of select="$webUrl"/>', '<xsl:value-of select="$fqdn"/>');</xsl:attribute>
																			  <xsl:value-of select="$fqdn"/>
																		  </xsl:element>
																	  </xsl:when>
																	  <xsl:otherwise>
																		  <xsl:element name="a">
																			  <xsl:attribute name="href">
																				  <xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:loginUrl"/>
																			  </xsl:attribute>
																			  <xsl:attribute name="target"><xsl:value-of select="concat('bay', $currentBayNumber, 'WebSSO')"/></xsl:attribute>
																			  <xsl:value-of select="$fqdn"/>
																		  </xsl:element>
																	  </xsl:otherwise>
																  </xsl:choose>
															  </xsl:when>
															  <xsl:when test="$ipAddress != '' and string-length($fqdn) &lt; 1">
																  <xsl:choose>
																	  <xsl:when test="$productId=8224 or $productId=4609 or $productId=33282">
																		  <xsl:element name="a">
																			  <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
																			  <xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$currentBayNumber"/>', '<xsl:value-of select="$loginUrl"/>', '<xsl:value-of select="$webUrl"/>');</xsl:attribute>
																			  <xsl:value-of select="$ipAddress"/>
																		  </xsl:element>
																	  </xsl:when>
																	  <xsl:otherwise>
																		  <xsl:element name="a">
																			  <xsl:attribute name="href">
																				  <xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:loginUrl"/>
																			  </xsl:attribute>
																			  <xsl:attribute name="target"><xsl:value-of select="concat('bay', $currentBayNumber, 'WebSSO')"/></xsl:attribute>
																			  <xsl:value-of select="$ipAddress"/>
																		  </xsl:element>
																	  </xsl:otherwise>
																  </xsl:choose>
															  </xsl:when>
															  <xsl:otherwise>
																  <xsl:choose>
																	<!--check if there is no IPv6-->
																	<xsl:when test="$isThereBayIPv6 = 'true'">
																		  <xsl:value-of select="$stringsDoc//value[@key='noIPv4Address']" />
																	</xsl:when>
																	<xsl:otherwise>
																		  <span id='{$encNum}iloIpLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;">loading...</span>
																		  <input type='hidden' name='bladeMpInfoNeeded' id='bladeMpInfoNeeded' value='{$encNum}:{$currentBayNumber}' />
																	</xsl:otherwise>
																  </xsl:choose>
															  </xsl:otherwise>
														  </xsl:choose>

														  <!--check if there is IPv6-->
														  <xsl:if test="$isThereBayIPv6 = 'true' or string-length($fqdn) &gt; 0">
															  <xsl:text> </xsl:text> <!--space between the text and the tooltip-->
															  <xsl:element name="a">
																  <xsl:attribute name="devId">
																	  <xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:loginUrl" />
																  </xsl:attribute>
																  <xsl:attribute name="target">_blank</xsl:attribute>
																  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

																  <xsl:variable name="iLOIPv6UrlList" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]" />
																  <xsl:variable name="apostrophe">'</xsl:variable>
																  <xsl:variable name="customOnClickUrl" select="concat('doiLoSsoHelper(this, ', $apostrophe, $currentBayNumber, $apostrophe, ',', $apostrophe, $loginUrl, $apostrophe, ',', $apostrophe, $webUrl, $apostrophe, ',', $apostrophe, $productId, $apostrophe, ',', $apostrophe, $ipAddress, $apostrophe, ');')" />

																  <xsl:call-template name="urlListTooltip">
																	  <xsl:with-param name="fqdn" select="$fqdn" />
																	  <xsl:with-param name="defaultUrl" select="$ipAddress" />
																	  <xsl:with-param name="urlList" select="$iLOIPv6UrlList" />
																	  <xsl:with-param name="customOnClickUrl" select="$customOnClickUrl" />
																  </xsl:call-template>
															  </xsl:element>
														  </xsl:if>
													  </xsl:when>
													  <xsl:otherwise>
														  <span id='{$encNum}iloIpLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;font-size:10;">N/A</span>
													  </xsl:otherwise>
												  </xsl:choose>
												  
											  </div>
                        
										  </td>

										  <!--
												Get the current bay's server blade name and display it in the table cell.
											-->
										  <td style="vertical-align:middle;">
											  
											  <div id="{concat('bay', $currentBayNumber, 'iLO-Name')}">
												  <xsl:choose>
													  <xsl:when test="hpoa:bladeType='BLADE_TYPE_SERVER'">
														  <xsl:choose>
															  <xsl:when test="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:dnsName != ''">
																  <xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:dnsName"/>
															  </xsl:when>
															  <xsl:otherwise>
																  <span id='{$encNum}iloNameLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;">loading...</span>
															  </xsl:otherwise>
														  </xsl:choose>
													  </xsl:when>
													  <xsl:otherwise>
														  <span id='{$encNum}iloNameLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;font-size:10;">N/A</span>
													  </xsl:otherwise>
												  </xsl:choose>
											  </div>
												
										  </td>

										  <xsl:if test="number($colSpan) &gt;= number('8')">

											  <td style="vertical-align:middle;">
												  <div id="{concat('bay', $currentBayNumber, 'VmStatus')}">
													  <xsl:choose>
														  <xsl:when test="hpoa:bladeType='BLADE_TYPE_SERVER'">
															  <xsl:choose>
																  <xsl:when test="count($virtualMediaStatusDoc//hpoa:virtualMediaStatus[hpoa:bayNumber=$currentBayNumber])&gt;0" >
																	  <xsl:for-each select="$virtualMediaStatusDoc//hpoa:virtualMediaStatus[hpoa:bayNumber=$currentBayNumber]">

																		  <xsl:call-template name="getDvdStatusLabel">
																			  <xsl:with-param name="dvdSupport" select="hpoa:support" />
																			  <xsl:with-param name="dvdStatus" select="hpoa:cdromStatus" />
																		  </xsl:call-template>
																		  
																	  </xsl:for-each>
																  </xsl:when>
																  <xsl:otherwise>
																	  <span id='{$encNum}vmLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;">loading...</span>
																	  <input type='hidden' name='vmStatusNeeded' id='vmStatusNeeded' value='{$encNum}:{$currentBayNumber}' />
																  </xsl:otherwise>
															  </xsl:choose>
														  </xsl:when>
														  <xsl:otherwise>
															  <span id='{$encNum}vmLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;font-size:10;">N/A</span>
														  </xsl:otherwise>
													  </xsl:choose>

												  </div>
											  </td>
										  </xsl:if>

									  </xsl:element>
								  </xsl:for-each>
							  </xsl:when>
							  <!-- Check for some permissions and some locked. -->
								<xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$PRESENT])=0 and (count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence='PRESENCE_NO_OP']) &gt; 0 or count($bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$LOCKED]) &gt; 0)">
								  <tr class="noDataRow">
									  <td colspan="{$colSpan}">
										  <xsl:value-of select="$stringsDoc//value[@key='noAllPermissionDeviceBay1']" /><br />
										  <xsl:value-of select="$stringsDoc//value[@key='noAllPermissionDeviceBay2']" />
									  </td>
								  </tr>
							  </xsl:when>
							  <xsl:otherwise>
								  <tr class="noDataRow">
									  <td colspan="{$colSpan}"><xsl:value-of select="$stringsDoc//value[@key='noDeviceToDisplay']" /></td>
								  </tr>
							  </xsl:otherwise>
						  </xsl:choose>
						  
					  </tbody>
				  </table>
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
		<xsl:param name="colSpan"/>
		<table style="background-color:#cccccc;margin-left:3px;">
			<tr>
				<td colspan="{$colSpan}" style="background-color:#CCCCCC;padding:2px;">
					<table style="border:0px;width:100%;">
						<tr>
							<td style="border:0px;background-color:#CCCCCC;" onmouseover="updateMenuStatus();">

								<div id="m02_trigger" class="localNavTrigger">
									<xsl:value-of select="$stringsDoc//value[@key='uidState']" />
									<ul id="m02" class="dropdownMenu" isdropdownmenu="yes">
										<li id="toggleOn" class="">
											<a href="javascript:void(0)" onmouseover="window.status='';return true;"
											  onclick="(this.parentNode.className=='disabled' ? '':toggleBladeUids(UID_CMD_ON()));">
												<xsl:value-of select="$stringsDoc//value[@key='turnOn']" />
											</a>
										</li>
										<li id="toggleOff" class="">

											<a href="javascript:void(0)" onmouseover="window.status='';return true;"
												onclick="(this.parentNode.className=='disabled' ? '':toggleBladeUids(UID_CMD_OFF()));">
												<xsl:value-of select="$stringsDoc//value[@key='turnOff']" />
											</a>
										</li>
									</ul>
								</div>

								<xsl:if test="$serviceUserAcl != $USER">
									<div id="m01_trigger" class="localNavTrigger">
										<xsl:value-of select="$stringsDoc//value[@key='virtualPower']" />
										<ul id="m01" class="dropdownMenu" isdropdownmenu="yes" >
											<li id="momentaryPress" class="">
												<a href="javascript:void(0);" onmouseover="window.status='';return true;"
									 onclick="(this.parentNode.className=='disabled' ? '':setBladesPower(MOMENTARY_PRESS()))">
													<xsl:value-of select="$stringsDoc//value[@key='momentaryPress']" />
												</a>
											</li>
											<li id="pressHold" class="">
												<a href="javascript:void(0)" onmouseover="window.status='';return true;"
									 onclick="(this.parentNode.className=='disabled' ? '':setBladesPower(PRESS_AND_HOLD()));">
													<xsl:value-of select="$stringsDoc//value[@key='pressHold']" />
												</a>
											</li>
											<li id="coldBoot" class="">
												<a href="javascript:void(0)" onmouseover="window.status='';return true;"
									 onclick="(this.parentNode.className=='disabled' ? '':setBladesPower(COLD_BOOT()));">
													<xsl:value-of select="$stringsDoc//value[@key='coldBoot']" />
												</a>
											</li>
											<li id="reset" class="">
												<a href="javascript:void(0)" onmouseover="window.status='';return true;"
									 onclick="(this.parentNode.className=='disabled' ? '':setBladesPower(RESET()));">
													<xsl:value-of select="$stringsDoc//value[@key='reset']" />
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

									<!-- Virtual device support -->
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
																<xsl:attribute name="onclick">
																	connectServers('<xsl:value-of select="@hpoa:value" />');
																</xsl:attribute>

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
																<xsl:attribute name="onclick">
																	connectServers('<xsl:value-of select="@hpoa:value" />');
																</xsl:attribute>
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
									
								</xsl:if> <!-- Current user != 'USER' -->

                <xsl:if test="$firmwareMgmtSupported = 'true'">               
								  <xsl:if test="$serviceUserAcl = 'ADMINISTRATOR'">

									  <div id="m05_trigger" class="localNavTrigger">
										  <xsl:value-of select="$stringsDoc//value[@key='firmwareManagement']"/>

										  <ul id="m05" class="dropdownMenu" isdropdownmenu="yes">
											  <li>
												  <xsl:element name="a">

													  <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
													  <xsl:attribute name="onmouseover">window.status='';return true;</xsl:attribute>
													  <xsl:attribute name="onclick">(this.parentNode.className=='disabled' ? '':doFirmwareManagement('discover'));</xsl:attribute>

													  <xsl:value-of select="$stringsDoc//value[@key='startManualDiscovery']"/>

												  </xsl:element>
											  </li>
											  <li>
												  <xsl:element name="a">

													  <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
													  <xsl:attribute name="onmouseover">window.status='';return true;</xsl:attribute>
													  <xsl:attribute name="onclick">(this.parentNode.className=='disabled' ? '':doFirmwareManagement('update'));</xsl:attribute>

													  <xsl:value-of select="$stringsDoc//value[@key='startManualUpdate']"/>

												  </xsl:element>
											  </li>
										  </ul>
										
									  </div>
									
								  </xsl:if>
								</xsl:if>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

	</xsl:template>

</xsl:stylesheet>
