<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">
	<xsl:output method = "html" />

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/extendedFirmware.xsl" />

	<xsl:param name="stringsDoc" />
	<xsl:param name="encNum" />
	<xsl:param name="iLoUpdate" />
	<xsl:param name="update" />
	<xsl:param name="primaryOaVersion" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="bladeStatusDoc" />
	<xsl:param name="interconnectTrayInfoDoc" />
	<xsl:param name="interconnectTrayStatusDoc" />
	<xsl:param name="oaInfoDoc" />
	<xsl:param name="oaStatusDoc" />
	<xsl:param name="enclosureInfoDoc" />
	<xsl:param name="bladeMpInfoDom" />
	<xsl:param name="isAuthenticated" />
	<xsl:param name="isLocal" />
	<xsl:param name="encType" />
	<xsl:param name="isTower" />
	<xsl:param name="isLoaded" />
	<xsl:param name="enclosureName" />
	<xsl:param name="encuuid" />
	<xsl:param name="numDeviceBays" />
	<xsl:param name="firmwareDoc" />
	<xsl:param name="encComponentFirmware" />
	<xsl:param name="numIoBays" />
	<xsl:param name="saPciList" />
  <xsl:param name="firmwareMgmtSupported" select="'false'" />

  <xsl:include href="../Templates/firmwareMgmtCommon.xsl" />
	
	<xsl:variable name="activeOaBay">
		<xsl:value-of select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole='ACTIVE']//hpoa:bayNumber" />
	</xsl:variable>
	<xsl:variable name="oaVersion" >
		<xsl:value-of select="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=$activeOaBay]/hpoa:fwVersion"/>
	</xsl:variable>

	<xsl:template name="rackOverviewEnclosure" match="*">

		<xsl:variable name="hash">
			<xsl:value-of select="concat('enc', $encNum)"/>
		</xsl:variable>
		<xsl:variable name="linkId" select="concat('signOutEnc', $encNum)" />
		<xsl:variable name="linkStyle">visibility:visible;margin:0px;</xsl:variable>

		<table cellpadding="0" cellspacing="0" border="0" align="center" style="border-collapse:collapse;" width="100%">
			<tr>
				<td style="padding-right:1px;">

					<div style="width:100%;">

						<h3 class="subTitle">
							<a name="{$hash}" />

							<div class="subTitleIcon" id="{$linkId}" style="{$linkStyle}">
								<xsl:choose>
									<xsl:when test="not($isAuthenticated='true')">
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="concat('rackOverview.html#enc', $encNum)" /></xsl:attribute>
											<xsl:attribute name="style">color:#fff;text-decoration:underline;font-weight:normal;padding-bottom:2px;</xsl:attribute>
											<xsl:attribute name="onclick">selectTab('rackOverview');top.mainPage.getStatusContainer().showStatus(false);</xsl:attribute>
											<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
											<xsl:value-of select="$stringsDoc//value[@key='linkedNotLoggedIn']" />
										</xsl:element>
									</xsl:when>
									<xsl:when test="$isLocal = 'true'">
										<span style="color:#fff;text-decoration:none;font-weight:bold;padding-bottom:2px;" >
											<xsl:value-of select="$stringsDoc//value[@key='primaryConnection']" />
										</span>
									</xsl:when>
									<xsl:when test="not($isLocal='true') and $isLoaded='true'">
										<span style="color:#fff;text-decoration:none;font-weight:normal;padding-bottom:2px;" >
											<xsl:value-of select="$stringsDoc//value[@key='linkedLoggedIn']" />
										</span>
									</xsl:when>
								</xsl:choose>
							</div>

							<span>
								<xsl:value-of select="$stringsDoc//value[@key='enclosure']" />:
							</span>
							<xsl:element name="span">
								<xsl:attribute name="style">display:inline;</xsl:attribute>
								<xsl:attribute name="id">
									<xsl:value-of select="concat('encNameLabel', $encNum)"/>
								</xsl:attribute>
								<xsl:value-of select="$enclosureName"/>
							</xsl:element>

						</h3>

						<div class="subTitleBottomEdge"></div>

						<xsl:element name="div">

							<xsl:attribute name="id">
								<xsl:value-of select="concat('enc', $encNum, 'Content')" />
							</xsl:attribute>
							<xsl:attribute name="class">enclosureWrapper</xsl:attribute>

							<xsl:call-template name="firmwareEnclosure" />

						</xsl:element>

					</div>

				</td>
			</tr>

		</table>

	</xsl:template>

	<xsl:template name="firmwareEnclosure">
                
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption style="background-color:transparent;color:black;font-weight:normal;padding-bottom:5px;">
				<xsl:value-of select="$stringsDoc//value[@key='oaFirmwareInformation']" />
                        </caption>
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='bay']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='model']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='manufacturer']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='serialNumber']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='partNumber']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='sparePartNumber']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='firmwareVersion']" />
					</th>
				</tr>
			</thead>
			<TBODY>
				<xsl:choose>
					<xsl:when test="count($oaInfoDoc//hpoa:oaInfo) > 0 and count($oaStatusDoc//hpoa:oaStatus) > 0">
						<xsl:for-each select="$oaInfoDoc//hpoa:oaInfo">

							<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />

							<xsl:if test="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:oaRole!=$OA_ABSENT">
								<xsl:element name="tr">
									<xsl:if test="position() mod 2 != 0">
										<xsl:attribute name="class">altRowColor</xsl:attribute>
									</xsl:if>
									<td>
										<xsl:choose>
											<xsl:when test="$isLoaded = 'true'">
												<xsl:element name="a">
													<xsl:attribute name="href">
														javascript:selectDevice(<xsl:value-of select="hpoa:bayNumber" />, ENCLOSURE_MANAGER(),<xsl:value-of select="$encNum"/>);
													</xsl:attribute>
													<xsl:value-of select="hpoa:bayNumber" />
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="hpoa:bayNumber" />
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										<xsl:value-of select="hpoa:name" />
									</td>
									<td>
										<xsl:value-of select="hpoa:manufacturer" />
									</td>
									<td>
										<xsl:value-of select="hpoa:serialNumber"/>
									</td>
									<td>
										<xsl:value-of select="hpoa:partNumber"/>
									</td>
									<td>
										<xsl:value-of select="hpoa:sparePartNumber"/>
									</td>
									<td>
										<xsl:if test="number(hpoa:fwVersion) &lt; number($primaryOaVersion)">
											<xsl:call-template name="statusIcon" >
												<xsl:with-param name="statusCode" select="string('OP_STATUS_DEGRADED')" />
											</xsl:call-template>&#160;
										</xsl:if>
    								<xsl:choose>
	                		<xsl:when test="hpoa:fwVersion != ''">
                     		<xsl:value-of select="hpoa:fwVersion"/>
				                <xsl:if test="hpoa:extraData[@hpoa:name='Build'] != ''">
                        	<span class="whiteSpacer">&#160;</span>
	                        <xsl:value-of select="hpoa:extraData[@hpoa:name='Build']"/>
                        </xsl:if>
                  		</xsl:when>
                    	<xsl:otherwise>
                    		<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
                   		</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="not($isLoaded='true')">
								<tr>
									<td colspan="7" style="text-align:center;">
										<xsl:value-of select="$stringsDoc//value[@key='signInRequiredThisInfo']" />
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<td colspan="7" style="text-align:center;">
										Not available. Click <a href="javascript:void(0);" onclick="loadRackFirmwareVersions();">here</a> to refresh.
									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>

			</TBODY>
		</table>

		<xsl:if test="count($encComponentFirmware//hpoa:hpqUpdateDeviceResponse) &gt; 0">
			<span class="whiteSpacer">&#160;</span>
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="treeTable">
				<caption style="background-color:transparent;color:black;font-weight:normal;padding-bottom:5px;">
					<xsl:value-of select="$stringsDoc//value[@key='encComponentFWInfo']" />
				</caption>
				
				<thead>
					<tr class="captionRow">
						<th><xsl:value-of select="$stringsDoc//value[@key='bay']" /></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='deviceModel']" /></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='currentFWVersion']" /></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='availableFWVersion']" /></th>
					</tr>
				</thead>
				<tbody>

					<xsl:for-each select="$encComponentFirmware//hpoa:hpqUpdateDeviceResponse/hpoa:show/hpoa:showEntry">
						<xsl:element name="tr">
							<xsl:if test="position() mod 2 != 0">
								<xsl:attribute name="class">altRowColor</xsl:attribute>
							</xsl:if>
							<td>
                <xsl:choose>
                    <xsl:when test="hpoa:deviceType='FAN'">
                    <xsl:element name="a">
                        <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="hpoa:bayNumber" />, FAN(),<xsl:value-of select="$encNum"/>);</xsl:attribute>
                        <xsl:value-of select="hpoa:bayNumber" />
                    </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hpoa:bayNumber" />
                    </xsl:otherwise>
                </xsl:choose>
							</td>
							<td>
								<xsl:value-of select="hpoa:deviceDescription"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:currentVersion"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:availableVersion"/>
							</td>
						</xsl:element>
					</xsl:for-each>
					
				</tbody>
			</table>
		</xsl:if>

		<span class="whiteSpacer">&#160;</span>
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="treeTable">
			<caption style="background-color:transparent;color:black;font-weight:normal;padding-bottom:5px;">
				<xsl:value-of select="$stringsDoc//value[@key='devicefwinfo']" />
			</caption>
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='bay']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='deviceModel']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='firmwareComponent']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='currentVersion']" />
					</th>

          <xsl:if test="$firmwareMgmtSupported = 'true'">
					  <th colspan="2">
						  <xsl:value-of select="$stringsDoc//value[@key='firmwareIsoVersion']" />
					  </th>            
          </xsl:if>
				</tr>

				<xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$PRESENT and hpoa:bladeType='BLADE_TYPE_SERVER']">
				  <xsl:sort select="hpoa:extraData[@hpoa:name='NormalizedBayNumber']" data-type="number" />
				  <xsl:sort select="hpoa:extraData[@hpoa:name='NormalizedSideNumber']" />

							<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
							<xsl:variable name="symbolicBladeNumber" >
								<xsl:call-template name="deviceBaySymbolicNumber">
									<xsl:with-param name="bladeInfo" select="current()" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="bladeName" select="hpoa:name"/>

              <xsl:variable name="discovered">
                  <xsl:choose>
                      <xsl:when test="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/@lastUpdate != ''">
                          <xsl:value-of select="true()" />
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:value-of select="false()" />
                      </xsl:otherwise>
                  </xsl:choose>
              </xsl:variable>


							<xsl:element name="tr">

								<xsl:attribute name="class">treeTableTopLevel</xsl:attribute>
								<td>
									<xsl:element name="a">
										<xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="hpoa:bayNumber" />, BAY(),<xsl:value-of select="$encNum"/>);</xsl:attribute>
										<xsl:value-of select="$symbolicBladeNumber" />
									</xsl:element>
								</td>
								<td>
									<b>
										<xsl:value-of select="$bladeName" />
									</b>
									<br />
                  <xsl:if test="$firmwareMgmtSupported = 'true'">
										<xsl:choose>
											<xsl:when test="$discovered='true'">
												<xsl:value-of select="$stringsDoc//value[@key='discovered:']" />&#160;<xsl:value-of select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/@lastUpdate"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$stringsDoc//value[@key='discovered:']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='no']" />
											</xsl:otherwise>
										</xsl:choose>
                  </xsl:if>
								</td>

								<xsl:choose>
									<!--FDT-->
									<xsl:when test="count($firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/HWDiscovery/serverinfo/rom) &gt; 0">

										<xsl:for-each select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/HWDiscovery/serverinfo/rom">

											<td class="" nowrap="true">
												<xsl:value-of select="$stringsDoc//value[@key='systemROM']" />

											</td>
											<td nowrap="true">
												<xsl:value-of select="concat('Version: ', version)"/>
												<br />
												<xsl:value-of select="concat('Family: ', family)"/>
											</td>
											<td>&#160;</td>
                                                                                        <td>&#160;</td>

										</xsl:for-each>

									</xsl:when>
									<!--DVD-->
									<xsl:when test="count($firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport/system//rom_details) &gt; 0">
                                                                                <xsl:variable name="romVersion">
                                                                                    <xsl:value-of select="hpoa:romVersion"/>
                                                                                </xsl:variable>

										<xsl:for-each select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport/system//rom_details">
											<td class="" nowrap="true">
												<xsl:value-of select="$stringsDoc//value[@key='systemROM']" />
											</td>
                                                                                        <td nowrap="true">
                                                                                                <xsl:call-template name="displayRomVersion" >
                                                                                                    <xsl:with-param name="romVersion" select="$romVersion" />
                                                                                                </xsl:call-template>

                                                                                        </td>
											<td>
                        <xsl:call-template name="getRomVersion" >
                          <xsl:with-param name="romVersion" select="repo_version" />
                        </xsl:call-template>                        
												<br />
												<xsl:value-of select="concat('Family: ', rom_family)"/>
											</td>
                                                                                        <td>
                                                                                                <xsl:variable name="formattedRomVersion">
                                                                                                    <xsl:call-template name="getRomVersion" >
                                                                                                      <xsl:with-param name="romVersion" select="$romVersion" />
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="formattedRepoVersion">
                                                                                                    <xsl:call-template name="getRomVersion" >
                                                                                                      <xsl:with-param name="romVersion" select="repo_version" />
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                 <xsl:call-template name="checkMatch" >
                                                                                                      <xsl:with-param name="deviceFwStr" select="$formattedRomVersion" />
                                                                                                      <xsl:with-param name="isoFwStr" select="$formattedRepoVersion" />
                                                                                                 </xsl:call-template>
                                                                                        </td>

										</xsl:for-each>
									</xsl:when>
									<!--OA Data-->
									<xsl:otherwise>
										<td>
											<xsl:choose>
												<xsl:when test="hpoa:bladeType='BLADE_TYPE_SERVER'">
													<xsl:value-of select="$stringsDoc//value[@key='systemROM']" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$stringsDoc//value[@key='romVersion']" />
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td>
											<xsl:value-of select="hpoa:romVersion"/>
										</td>

                    <xsl:if test="$firmwareMgmtSupported = 'true'">
                      <td>
                        <xsl:if test="$discovered='true'">
                          <xsl:value-of select="$stringsDoc//value[@key='nocomp']" />
                        </xsl:if>
                      </td>
                      <td>&#160;</td>                      
                    </xsl:if>
									</xsl:otherwise>
								</xsl:choose>

							</xsl:element>

					<xsl:if test="hpoa:bladeType='BLADE_TYPE_SERVER'">
                                              
                                              <xsl:choose>
							<xsl:when test="count($firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport/system//ilo_details) &gt; 0">
                                                               

								<xsl:for-each select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport/system//ilo_details">
									<tr>
										<td>&#160;</td>
										<td>&#160;</td>
										<td>
                                                                                    <xsl:call-template name="iloNameTemplate">
                                                                                        <xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
                                                                                        <xsl:with-param name="bladeType" select="'BLADE_TYPE_SERVER'"/>
                                                                                    </xsl:call-template>

										</td>
										<td>
                                                                                     <xsl:call-template name="iloVersionTemplate">
                                                                                         <xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
                                                                                          <xsl:with-param name="type" select="'2'"/>
                                                                                     </xsl:call-template>


                                                                                </td>
										<td>
                                                                                    <xsl:element name="div">
                                                                                        <xsl:attribute name="id">
                                                                                                <xsl:value-of select="concat('iloIsoFwVerEnc', $encNum, 'Bay', $currentBayNumber)" />
                                                                                        </xsl:attribute>
											<xsl:value-of select="repo_version"/>
                                                                                    </xsl:element>
										</td>
                                                                                <td>
                                                                                     <xsl:element name="div">
                                                                                        <xsl:attribute name="id">
                                                                                                <xsl:value-of select="concat('infoIconIlo', $encNum, 'Bay', $currentBayNumber)" />
                                                                                        </xsl:attribute>

                                                                                          <xsl:if test="string($bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:fwVersion)!=''">
                                                                                              <xsl:call-template name="iloVersionDifference" >
                                                                                                  <xsl:with-param name="iloVersion" select="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:fwVersion" />
                                                                                                  <xsl:with-param name="isoVersion" select="repo_version" />
                                                                                              </xsl:call-template>
                                                                                          </xsl:if>
                                                                                     </xsl:element>
                                                                                </td>
									</tr>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<td>&#160;</td>
									<td>&#160;</td>
									<td>
                                                                             <xsl:call-template name="iloNameTemplate">
                                                                                 <xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
                                                                                 <xsl:with-param name="bladeType" select="'BLADE_TYPE_SERVER'"/>
                                                                             </xsl:call-template>

									</td>
									<td>
                                                                             <xsl:call-template name="iloVersionTemplate">
                                                                                 <xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
                                                                             </xsl:call-template>
									</td>
                  <xsl:if test="$firmwareMgmtSupported = 'true'">
                    <td>
                      <xsl:if test="$discovered='true'">
                        <xsl:value-of select="$stringsDoc//value[@key='nocomp']" />
                      </xsl:if>
                    </td>
                    <td>&#160;</td>
                  </xsl:if>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:if>
							
					<xsl:if test="hpoa:bladeType='BLADE_TYPE_SERVER'">

						<xsl:choose>
							<xsl:when test="count($firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport/system//powerpic_details/powerpic/version) &gt; 0">

								<xsl:for-each select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport/system//powerpic_details/powerpic">
									<xsl:element name="tr">
										<td>&#160;</td>
										<td>&#160;</td>
										<td class="" nowrap="true">
											<xsl:value-of select="product_id"/>
										</td>
										<td nowrap="true">
                                                                                    <xsl:call-template name="powerPicTemplate">
                                                                                        <xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
                                                                                    </xsl:call-template>
    										</td>
										<td nowrap="true">
                                                                                        <xsl:element name="div">
                                                                                            <xsl:attribute name="id">
                                                                                                <xsl:value-of select="concat('picIsoFwVerEnc', $encNum, 'Bay', $currentBayNumber)" />
                                                                                            </xsl:attribute>
                                                                                            <xsl:value-of select="repo_version"/>
                                                                                        </xsl:element>

										</td>
                                                                                <td>
                                                                                    <xsl:element name="div">
                                                                                        <xsl:attribute name="id">
                                                                                                <xsl:value-of select="concat('infoIconPic', $encNum, 'Bay', $currentBayNumber)" />
                                                                                        </xsl:attribute>

                                                                                      <xsl:call-template name="checkMatch" >
                                                                                          <xsl:with-param name="deviceFwStr" select="version" />
                                                                                          <xsl:with-param name="isoFwStr" select="repo_version" />
                                                                                      </xsl:call-template>
                                                                                    </xsl:element>
                                                                                </td>
									</xsl:element>
								</xsl:for-each>

							</xsl:when>
							<xsl:when test="count($firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start//hp_rom_discovery//device/device_id[contains(@value, 'PowerPIC')]) &gt; 0">

								<xsl:for-each select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start//hp_rom_discovery//devices/device[contains(device_id/@value, 'PowerPIC')]">

									<xsl:element name="tr">

										<td>&#160;</td>
										<td>&#160;</td>
										<td class="" nowrap="true">
											<xsl:value-of select="product_id/@value"/>
										</td>
										<td nowrap="true">
											<xsl:for-each select="fw_item">
												<xsl:value-of select="type/@value"/>: <xsl:value-of select="active_version/@value"/><br />
											</xsl:for-each>
										</td>
										<td nowrap="true">
											<xsl:for-each select="fw_item">
												<xsl:value-of select="type/@value"/>: <xsl:value-of select="version/@value"/><br />
											</xsl:for-each>
										</td>
                    <td>&#160;</td>

									</xsl:element>

								</xsl:for-each>
								
							</xsl:when>
							<xsl:otherwise>

								<tr>
									<td>&#160;</td>
									<td>&#160;</td>
									<td>
										<xsl:value-of select="$stringsDoc//value[@key='powerPic']" />
									</td>
									<td>

                                                                                <xsl:call-template name="powerPicTemplate">
                                                                                    <xsl:with-param name="currentBayNumber" select="$currentBayNumber"/>
                                                                                </xsl:call-template>

									</td>
                  <xsl:if test="$firmwareMgmtSupported = 'true'">
                    <td>
                      <xsl:if test="$discovered='true'">
                        <xsl:value-of select="$stringsDoc//value[@key='nocomp']" />
                      </xsl:if>
                    </td>
                    <td>&#160;</td>
                  </xsl:if>
								</tr>
									
							</xsl:otherwise>
						</xsl:choose>
								
					</xsl:if>
					
					<xsl:choose>
						<!--FDT-->
						<xsl:when test="count($firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/hp_rom_discovery) &gt; 0">

							<xsl:for-each select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start">

								<xsl:for-each select="hp_rom_discovery">
									<xsl:for-each select="devices/device[(funcnumber/@value='' or funcnumber/@value='0000') and not(contains(device_id/@value, 'PowerPIC'))]">

										<xsl:element name="tr">

											<td>&#160;</td>
											<td>&#160;</td>
											<td class="" nowrap="true">
												<xsl:value-of select="product_id/@value"/>
											</td>
											<td nowrap="true">
												<xsl:for-each select="fw_item">
													<xsl:value-of select="type/@value"/>: <xsl:value-of select="active_version/@value"/><br />
												</xsl:for-each>
											</td>
											<td nowrap="true">
												<xsl:for-each select="fw_item">
													<xsl:value-of select="type/@value"/>: <xsl:value-of select="version/@value"/><br />
												</xsl:for-each>
											</td>
                                                                                        <td>&#160;</td>

										</xsl:element>

									</xsl:for-each>
								</xsl:for-each>

								<xsl:for-each select="HWDiscovery/storage_info/devices/device">

									<xsl:element name="tr">

										<xsl:variable name="cssClass">
											<xsl:if test="contains(device_id/@value, ':')">nested1</xsl:if>
										</xsl:variable>
										
										<td>&#160;</td>
										<td>&#160;</td>
										<td class="{$cssClass}" nowrap="true">

											<xsl:variable name="productId" select="product_id/@value" />

											<xsl:choose>
												<xsl:when test="$saPciList//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId != ''">
													<xsl:value-of select="$saPciList//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId"/>
												</xsl:when>
												<xsl:otherwise>

													<xsl:choose>
														<xsl:when test="contains(device_id/@value, ':')">
															<xsl:value-of select="$productId"/>&#160;<xsl:value-of select="concat('(Bay ', substring(device_id/@value, 5, 1), ')')"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$productId"/>
														</xsl:otherwise>
													</xsl:choose>

												</xsl:otherwise>
											</xsl:choose>
											
										</td>
										<td nowrap="true">
											<xsl:value-of select="written_version/@value"/>
										</td>
										<td nowrap="true">
											<xsl:value-of select="active_version/@value"/>
										</td>
                                                                                <td>&#160;</td>

									</xsl:element>

								</xsl:for-each>

							</xsl:for-each>

						</xsl:when>
						<!--DVD-->
						<xsl:when test="count($firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport) &gt; 0">

							<xsl:for-each select="$firmwareDoc//bladeFirmware[@bayNumber=$currentBayNumber]/start/firmwarereport/system">
								<xsl:for-each select=".//nic_details/nic_device">
									<xsl:element name="tr">

										<td>&#160;</td>
										<td>&#160;</td>
										<td class="" nowrap="true">
											<xsl:value-of select="product_id"/>
										</td>
                    <td nowrap="true">
                    <xsl:for-each select=".//version/..">
                            <xsl:value-of select="concat(local-name(.), ' : ', version)" />
                            <br/>
                    </xsl:for-each>
                    </td>
                    <td nowrap="true">
                    <xsl:for-each select="./*/repo_version/..">
                            <xsl:value-of select="concat(local-name(.), ' : ', repo_version)" />
                            <br/>
                    </xsl:for-each>
                    </td>
                    <td>
                        <xsl:for-each select="./*/repo_version/..">
                            <xsl:call-template name="checkMatch" >
                                <xsl:with-param name="deviceFwStr" select="version" />
                                <xsl:with-param name="isoFwStr" select="repo_version" />
                            </xsl:call-template>
                            <br/>
                        </xsl:for-each>
                          <xsl:for-each select=".//version/..">
                            <xsl:if test="count(repo_version)=0">
                                <xsl:call-template name="checkMatch" >
                                    <xsl:with-param name="deviceFwStr" select="version" />
                                    <xsl:with-param name="isoFwStr" select="repo_version" />
                                </xsl:call-template>
                                <br/>
                            </xsl:if>
                        </xsl:for-each>

                    </td>

									</xsl:element>
								</xsl:for-each>

								<xsl:for-each select=".//scontroller_details/scontroller_device">
									<xsl:element name="tr">
										<td>&#160;</td>
										<td>&#160;</td>
										<td class="" nowrap="true">

											<xsl:variable name="productId" select="product_id" />

											<xsl:choose>
												<xsl:when test="$saPciList//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId != ''">
													<xsl:value-of select="$saPciList//hpoa:saPCIList[hpoa:pciId=substring($productId, 1, 4) != '']/hpoa:productId"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$productId"/>
												</xsl:otherwise>
											</xsl:choose>
											
										</td>
										<td nowrap="true">
											<xsl:value-of select="version"/>
										</td>
										<td nowrap="true">
											<xsl:value-of select="repo_version"/>
										</td>
                    <td>
                      <xsl:call-template name="checkMatch" >
                            <xsl:with-param name="deviceFwStr" select="version" />
                            <xsl:with-param name="isoFwStr" select="repo_version" />
                      </xsl:call-template>
                    </td>

									</xsl:element>

									<xsl:for-each select="hard_drive">
										<xsl:element name="tr">
											<td>&#160;</td>
											<td>&#160;</td>
											<td class="nested1" nowrap="true">
												<xsl:value-of select="concat(product_id, ' (Bay ', bay, ')')"/>
											</td>
											<td nowrap="true">
												<xsl:value-of select="version"/>
											</td>
											<td nowrap="true">
												<xsl:value-of select="repo_version"/>
											</td>
                      <td>
                        <xsl:call-template name="checkMatch" >
                              <xsl:with-param name="deviceFwStr" select="version" />
                              <xsl:with-param name="isoFwStr" select="repo_version" />
                        </xsl:call-template>
                      </td>

										</xsl:element>

									</xsl:for-each>
									
								</xsl:for-each>

                <xsl:for-each select=".//harddisk_details/hard_drive">
									<xsl:element name="tr">
										<td>&#160;</td>
										<td>&#160;</td>
										<td class="nested1" nowrap="true">
											<xsl:value-of select="concat(product_id, ' (Bay ', bay, ')')"/>
										</td>
										<td nowrap="true">
											<xsl:value-of select="version"/>
										</td>
										<td nowrap="true">
											<xsl:value-of select="repo_version"/>
										</td>
                    <td>
                      <xsl:call-template name="checkMatch" >
                            <xsl:with-param name="deviceFwStr" select="version" />
                            <xsl:with-param name="isoFwStr" select="repo_version" />
                      </xsl:call-template>
                    </td>
									</xsl:element>
								</xsl:for-each>
							</xsl:for-each>							
						</xsl:when>
					</xsl:choose>

				</xsl:for-each>
				
			</thead>
		</table>
		
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption  style="background-color:transparent;color:black;font-weight:normal;padding-bottom:5px;">
				<xsl:value-of select="$stringsDoc//value[@key='interconnectfwinfo']" />
			</caption>
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='bay']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='deviceModel']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='firmwareVersion']" />
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$interconnectTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence='PRESENT']">
					<xsl:variable name="bayNumber" select="hpoa:bayNumber"/>
					<tr>
						<td>
							<xsl:element name="a">
								<xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$bayNumber" />, INTERCONNECT(),<xsl:value-of select="$encNum"/>);</xsl:attribute>
								<xsl:value-of select="$bayNumber" />
							</xsl:element>
						</td>
						<td>
							<xsl:value-of select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:name"/>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[@hpoa:name='swmFWVersion'] != ''">
									<xsl:value-of select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:extraData[@hpoa:name='swmFWVersion']"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='notAvailable']"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>

	</xsl:template>

        <xsl:template name="iloVersionTemplate">
             <xsl:param name="currentBayNumber"  />
             <xsl:param name="type"  select="''" />
             <xsl:element name="div">
                    <xsl:attribute name="id">
                            <xsl:value-of select="concat('iloFwVerEnc',$type,$encNum, 'Bay', $currentBayNumber)" />
                    </xsl:attribute>
                    <xsl:choose>
                            
                            <xsl:when test="string($bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:fwVersion)!=''">
                                <xsl:choose>
                                    <xsl:when test="$type='2'" >
                                        <xsl:call-template name="getIloVersion">
                                            <xsl:with-param name="iloVersion" select="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:fwVersion"/>
                                        </xsl:call-template>
                                   </xsl:when>
                                   <xsl:otherwise>
                                        <xsl:value-of select="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:modelName"/>&#160;
                                        <xsl:call-template name="getIloFwVersionLabel">
                                                <xsl:with-param name="productId" select="hpoa:productId"/>
                                                <xsl:with-param name="fwVersion" select="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:fwVersion"/>
                                                <xsl:with-param name="iloModel" select="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:modelName"/>
                                        </xsl:call-template>
                                   </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                    <span id='{$encNum}iloIpLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;">loading ...</span>
                            </xsl:otherwise>
                    </xsl:choose>
            </xsl:element>



        </xsl:template>
        
        <xsl:template name="iloNameTemplate">
             <xsl:param name="currentBayNumber"  />
             <xsl:param name="bladeType"  />
             <xsl:element name="div">
                <xsl:attribute name="id">
                        <xsl:value-of select="concat('iloModelEnc', $encNum, 'Bay', $currentBayNumber)" />
                </xsl:attribute>
                <xsl:choose>
                        <xsl:when test="string($bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:modelName)!=''">
                                <xsl:value-of select="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:modelName"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:choose>
                                        <xsl:when test="$bladeType='BLADE_TYPE_SERVER'">
                                                <span id='{$encNum}iloNameLoadingText{$currentBayNumber}' style="z-index:10;cursor:default;color:#666;font-style:italic;">loading ...</span>
                                                <input type='hidden' name='bladeMpInfoNeeded' id='bladeMpInfoNeeded' value='{$encNum}:{$currentBayNumber}' />
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <span style="z-index:10;cursor:default;color:#666;">N/A</span>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                </xsl:choose>
            </xsl:element>

        </xsl:template>

        <xsl:template name="powerPicTemplate">
            <xsl:param name="currentBayNumber"  />
            <xsl:element name="div">
                <xsl:attribute name="id">
                        <xsl:value-of select="concat('powerPicVerEnc', $encNum, 'Bay', $currentBayNumber)" />
                </xsl:attribute>
                <xsl:variable name="picVersion" select="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='picFwVersion']" />
                <xsl:choose>
                        <xsl:when test="$bladeMpInfoDom//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:modelName='iLO3'">
                                <xsl:choose>
                                        <xsl:when test="$picVersion != ''">
                                                <xsl:value-of select="$picVersion"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="$stringsDoc//value[@key='notAvailable']"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:choose>
                                        <xsl:when test="$picVersion != '' and (number($picVersion) &gt; 0.5 and number($picVersion) &lt; 1.2)" >
                                                <xsl:call-template name="statusIcon" >
                                                        <xsl:with-param name="statusCode" select="string('Informational')" />
                                                </xsl:call-template>&#160;
                                                <xsl:value-of select="$picVersion"/>&#160;<xsl:call-template name="errorTooltip">
                                                        <xsl:with-param name="stringsFileKey" select="'powerPicTooltip'" />
                                                </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:choose>
                                                        <xsl:when test="$picVersion != ''">
                                                                <xsl:value-of select="$picVersion"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:value-of select="$stringsDoc//value[@key='notAvailable']"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
