<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="bladeInfoDoc"  />
	<xsl:param name="encNum" />
	<xsl:param name="oaVersion" />
	<xsl:param name="bladeMpInfoDoc" />
	<xsl:param name="firmwareDoc" />
	<xsl:param name="enclosureType" />
	<xsl:param name="numDeviceBays" />
	<xsl:param name="isTower" />
	<xsl:param name="fwManagementSettings" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="saPciList" />
        <xsl:param name="bladeStatusDoc"  />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/extendedFirmware.xsl" />
	<xsl:include href="../Forms/ServerSelect.xsl" />
        <xsl:include href="../Templates/firmwareMgmtCommon.xsl" />


	<xsl:template match="*">

		<xsl:value-of select="$stringsDoc//value[@key='bayFWDesc']" />
		<br />
		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />
		<div id="errorDisplay" class="errorDisplay"></div>
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="treeTable">

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
					<th colspan="2">
						<xsl:value-of select="$stringsDoc//value[@key='firmwareIsoVersion']" />
					</th>
                                        
				</tr>

				<xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo">
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
                                                <xsl:when test="$firmwareDoc//bladeFirmware/@lastUpdate != ''">
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
							<xsl:choose>
								<xsl:when test="$discovered='true'">
									<xsl:value-of select="$stringsDoc//value[@key='discovered:']" />&#160;<xsl:value-of select="$firmwareDoc//bladeFirmware/@lastUpdate"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='discovered:']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='no']" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<xsl:choose>
							<xsl:when test="count($firmwareDoc//bladeFirmware/start/HWDiscovery) &gt; 0">
								
								<xsl:for-each select="$firmwareDoc//bladeFirmware/start/HWDiscovery/serverinfo/rom">

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
                                                                        <td>&#160;</td>

								</xsl:for-each>

							</xsl:when>
							<xsl:when test="count($firmwareDoc//bladeFirmware/start/firmwarereport) &gt; 0">
                                                                <xsl:variable name="romVersion">
                                                                    <xsl:value-of select="hpoa:romVersion"/>
                                                                       
                                                                </xsl:variable>
                                                                <xsl:for-each select="$firmwareDoc//bladeFirmware/start/firmwarereport/system//rom_details">
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
								<td><xsl:if test="$discovered='true'"><xsl:value-of select="$stringsDoc//value[@key='nocomp']" /></xsl:if></td>
                                                                <td>&#160;</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>

					<xsl:if test="hpoa:bladeType='BLADE_TYPE_SERVER'">

						<xsl:choose>
							<xsl:when test="count($firmwareDoc//bladeFirmware/start/firmwarereport/system//ilo_details) &gt; 0">

                                                                <xsl:variable name="iloVersion">
                                                                    <xsl:value-of select="$bladeMpInfoDoc//hpoa:bladeMpInfo/hpoa:fwVersion"/>
                                                                </xsl:variable>

                                                                <xsl:variable name="formattedIloVersion">
                                                                    <xsl:call-template name="getIloVersion" >
                                                                        <xsl:with-param name="iloVersion" select="$iloVersion" />
                                                                     </xsl:call-template>
                                                                </xsl:variable>
								<xsl:for-each select="$firmwareDoc//bladeFirmware/start/firmwarereport/system//ilo_details">
									<tr>
										<td>&#160;</td>
										<td>&#160;</td>
                                                                                <td>
                                                                                    <xsl:value-of select="$bladeMpInfoDoc//hpoa:bladeMpInfo/hpoa:modelName"/>
                                                                                </td>
                                                                                <td>
                                                                                     <xsl:value-of select="$formattedIloVersion"/>
                                                                                </td>

										<td>
											<xsl:value-of select="repo_version"/>
										</td>
                                                                                <td>
                                                                                       <xsl:call-template name="checkMatch" >
                                                                                          <xsl:with-param name="deviceFwStr" select="$formattedIloVersion" />
                                                                                          <xsl:with-param name="isoFwStr" select="repo_version" />
                                                                                      </xsl:call-template>
                                                                                </td>
									</tr>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<td>&#160;</td>
									<td>&#160;</td>
									<td>
										<xsl:value-of select="$bladeMpInfoDoc//hpoa:bladeMpInfo/hpoa:modelName"/>
									</td>
									<td>
										<xsl:value-of select="$bladeMpInfoDoc//hpoa:bladeMpInfo/hpoa:fwVersion"/>
									</td>
									<td><xsl:if test="$discovered='true'"><xsl:value-of select="$stringsDoc//value[@key='nocomp']" /></xsl:if></td>
                                                                        <td>&#160;</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:if>

					<xsl:if test="hpoa:bladeType='BLADE_TYPE_SERVER'">
                                                <xsl:variable name="picVersion" select="$bladeMpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name='picFwVersion']" />
						<xsl:choose>
							<xsl:when test="count($firmwareDoc//bladeFirmware/start/firmwarereport/system//powerpic_details/powerpic/version) &gt; 0">
                                                                <xsl:for-each select="$firmwareDoc//bladeFirmware/start/firmwarereport/system//powerpic_details/powerpic">
									<xsl:element name="tr">
										<td>&#160;</td>
										<td>&#160;</td>
										<td class="" nowrap="true">
											<xsl:value-of select="product_id"/>
										</td>
										<td>
                                                                                <xsl:call-template name="powerpic" >
                                                                                   <xsl:with-param name="currentBayNumber" select="$currentBayNumber" />
                                                                                   <xsl:with-param name="picVersion" select="$picVersion" />
                                                                                </xsl:call-template>
                                                                                </td>

										<td nowrap="true">
											<xsl:value-of select="repo_version"/>
										</td>
                                                                                <td nowrap="true">
                                                                                <xsl:call-template name="checkMatch" >
                                                                                     <xsl:with-param name="deviceFwStr" select="$picVersion" />
                                                                                     <xsl:with-param name="isoFwStr" select="repo_version" />
                                                                                 </xsl:call-template>

                                                                                </td>
									</xsl:element>
								</xsl:for-each>

							</xsl:when>
							<xsl:when test="count($firmwareDoc//bladeFirmware/start//hp_rom_discovery//device/device_id[contains(@value, 'PowerPIC')]) &gt; 0">

								<xsl:for-each select="$firmwareDoc//bladeFirmware/start//hp_rom_discovery//devices/device[contains(device_id/@value, 'PowerPIC')]">

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
                                                                                <xsl:call-template name="powerpic" >
                                                                                   <xsl:with-param name="currentBayNumber" select="$currentBayNumber" />
                                                                                   <xsl:with-param name="picVersion" select="$picVersion" />
                                                                                </xsl:call-template>
									</td>
									<td><xsl:if test="$discovered='true'"><xsl:value-of select="$stringsDoc//value[@key='nocomp']" /></xsl:if></td>
                                                                        <td>&#160;</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="count($firmwareDoc//bladeFirmware/start/hp_rom_discovery) &gt; 0">

							<xsl:for-each select="$firmwareDoc//bladeFirmware/start">

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
						<xsl:when test="count($firmwareDoc//bladeFirmware/start/firmwarereport) &gt; 0">

							<xsl:for-each select="$firmwareDoc//bladeFirmware/start/firmwarereport/system">
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
               
               <xsl:variable name="fwMgmtStatus" select="count($bladeStatusDoc//hpoa:bladeStatus[hpoa:operationalStatus = $OP_STATUS_STARTING])" />
               <xsl:variable name="secureBoot" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='secureBoot']" />
    <xsl:choose>
			<xsl:when test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:isoUrl != '' and $fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:fwManagementEnabled='true' and $serviceUserAcl = 'ADMINISTRATOR' and $fwMgmtStatus = 0 and not($secureBoot = 'enabled')">
				<div align="right">
					<div class='buttonSet'>
						<div class='bWrapperUp'>
							<div>
								<div>
									<button type="button" class="hpButton" onclick="doManualDiscoveryOrUpdate('UPDATE');">
										<xsl:value-of select="$stringsDoc//value[@key='startManualUpdate']" />
									</button>
								</div>
							</div>
						</div>
						<div class='bWrapperUp'>
							<div>
								<div>
									<button type="button" class="hpButton" onclick="doManualDiscoveryOrUpdate('DISCOVERY')">
										<xsl:value-of select="$stringsDoc//value[@key='startManualDiscovery']" />
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="clearFloats"></div>
			</xsl:when>
			<xsl:otherwise>
				<div align="right">
					<div class='buttonSet'>
            <xsl:if test="$secureBoot = 'enabled'">
              <div style="float:right;">
                <xsl:call-template name="simpleTooltip">
						      <xsl:with-param name="msg" select="$stringsDoc//value[@key='unavailableInSecureBootMode']" />
					      </xsl:call-template>
              </div>
            </xsl:if>
						<div class='bWrapperUp'>
							<div>
								<div>
									<button type="button" class="hpButton" disabled="disabled">
										<xsl:value-of select="$stringsDoc//value[@key='startManualUpdate']" />
									</button>
								</div>
							</div>
						</div>
						<div class='bWrapperUp'>
							<div>
								<div>
									<button type="button" class="hpButton" disabled="disabled">
										<xsl:value-of select="$stringsDoc//value[@key='startManualDiscovery']" />
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="clearFloats"></div>
			</xsl:otherwise>
		</xsl:choose>

		<div style="display:none;">
			<xsl:call-template name="ServerSelect">
				<xsl:with-param name="enclosureNumber" select="$encNum" />
				<xsl:with-param name="checkAll" select="'false'" />
				<xsl:with-param name="disableAll" select="'false'" />
				<xsl:with-param name="enclosureType" select="$enclosureType" />
				<xsl:with-param name="numBays" select="$numDeviceBays" />
				<xsl:with-param name="checkAllLabel" select="''" />
			</xsl:call-template>
		</div>
		
	</xsl:template>

        <xsl:template name="powerpic">
            <xsl:param name="currentBayNumber"  />
            <xsl:param name="picVersion"  />
            
            <xsl:element name="div">
            <xsl:attribute name="id">
            <xsl:value-of select="concat('powerPicVerEnc', $encNum, 'Bay', $currentBayNumber)" />
            </xsl:attribute>
            <xsl:choose>
            <xsl:when test="$bladeMpInfoDoc//hpoa:bladeMpInfo/hpoa:modelName='iLO3'">
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
