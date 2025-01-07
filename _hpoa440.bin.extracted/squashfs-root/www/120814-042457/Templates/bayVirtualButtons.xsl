<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/bayAddressList.xsl" />

	<xsl:include href="../Templates/uid.xsl" />

	<xsl:param name="stringsDoc" />
	<xsl:param name="bladeStatusDoc" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="virtualMediaUrlListDoc" />
	<xsl:param name="virtualMediaStatusDoc" />
	<xsl:param name="oaMediaDeviceList" />
	<xsl:param name="mpInfoDoc" />
	
	<xsl:template match="*">

		<!-- The server's current power state. -->
		<xsl:variable name="svbPowerState" select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:powered" />
		<xsl:variable name="bladeType" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType" />
		<xsl:variable name="bayNumber" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bayNumber" />

		<xsl:if test="$bladeType = 'BLADE_TYPE_SERVER' and not($serviceUserAcl=$USER)">
			<!-- hide this block for non-"USER" permission -->

			<xsl:value-of select="$stringsDoc//value[@key='virtualPower']" />
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<div class="groupingBox">

				<span id="powerMsg">
					<xsl:value-of select="$stringsDoc//value[@key='bayPowerStateDescription']" />&#160;<xsl:call-template name="getPowerLabel">
						<xsl:with-param name="powered" select="$svbPowerState" />
					</xsl:call-template>
				</span>
				<br />

				<span class="whiteSpacer">&#160;</span>
				<br />

				<table cellpadding="0" cellspacing="0" border="0" align="center">
					<tr>
						<td nowrap="true">

							<div class="buttonSet buttonsAreLeftAligned">
								<xsl:choose>

									<!-- Power state is off - buttons to power on. -->
									<xsl:when test="$svbPowerState='POWER_OFF' or $svbPowerState='POWER_STAGED_OFF'">
										<div class="bWrapperUp"><div><div><button class="hpButtonSmall"  onclick="setBladePowerMode(MOMENTARY_PRESS());"><xsl:value-of select="$stringsDoc//value[@key='momentaryPress']" /></button></div></div></div>
									</xsl:when>

									<!-- Power state is on - buttons to power off. -->
									<xsl:when test="$svbPowerState='POWER_ON'">
										<div class="bWrapperUp"><div><div><button class="hpButtonSmall"  onclick="setBladePowerMode(MOMENTARY_PRESS());"><xsl:value-of select="$stringsDoc//value[@key='momentaryPress']" /></button></div></div></div>
										<div class="bWrapperUp"><div><div><button class="hpButtonSmall"  onclick="setBladePowerMode(PRESS_AND_HOLD());"><xsl:value-of select="$stringsDoc//value[@key='pressHold']" /></button></div></div></div>
										<div class="bWrapperUp"><div><div><button class="hpButtonSmall"  onclick="setBladePowerMode(COLD_BOOT());"><xsl:value-of select="$stringsDoc//value[@key='coldBoot']" /></button></div></div></div>
										<div class="bWrapperUp"><div><div><button class="hpButtonSmall"  onclick="setBladePowerMode(RESET());"><xsl:value-of select="$stringsDoc//value[@key='reset']" /></button></div></div></div>

									</xsl:when>

								</xsl:choose>
							</div>

							<div class="clearFloats"></div>
						</td>
					</tr>
				</table>

			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

		</xsl:if>

		<xsl:value-of select="$stringsDoc//value[@key='virtualIndicator']" />:&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='bayVirtualButtonDesc']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />
		<div id="uidErrorDisplay" class="errorDisplay"></div>

		<div id="uidGroupingBox" class="groupingBox">

			<xsl:call-template name="uid">
				<xsl:with-param name="uidState" select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:uid" />
			</xsl:call-template>

		</div>

		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:if test="$bladeType = 'BLADE_TYPE_SERVER' and not($serviceUserAcl=$USER)">

			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:value-of select="$stringsDoc//value[@key='dvdDrive']" />:&#160;
			<em>
			<xsl:value-of select="$stringsDoc//value[@key='bayDVDDriveDesc']" />
			</em><br />

			<span class="whiteSpacer">&#160;</span>
			<br />

			<div class="errorDisplay" id="dvdErrorDisplay"></div>

			<table cellpadding="0" cellspacing="0" border="0" class="dataTable">

				<thead>
					<tr class="captionRow">

						<th><xsl:value-of select="$stringsDoc//value[@key='connectToDevice']" /></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='iloDVDStatus']" /></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='deviceOrImgURL']" /></th>
					</tr>
				</thead>

				<tr>

					<td>

						<xsl:choose>
							<xsl:when test="1 = 0"> <!-- Allow user to disconnect even when no DVD/USB is present.
							<xsl:when test="(count($oaMediaDeviceList//hpoa:oaMediaDevice[(hpoa:deviceType=1 or hpoa:deviceType=2) and hpoa:mediaPresence='PRESENT'])=0) or (count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value='' or @hpoa:value=' '])=0)">
							-->
								<xsl:value-of select="$stringsDoc//value[@key='noMediaDVDDrive']" />
							</xsl:when>
							<xsl:otherwise>
								<select id="vmSelect">

									<xsl:for-each select="$virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value='' or @hpoa:value=' ']">

										<xsl:element name="option">
											<xsl:attribute name="value">
												<xsl:value-of select="@hpoa:value"/>
											</xsl:attribute>

											<xsl:if test="$virtualMediaStatusDoc//hpoa:virtualMediaStatus/hpoa:cdromUrl=@hpoa:value">
												<xsl:attribute name="selected">true</xsl:attribute>
											</xsl:if>
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

									</xsl:for-each>

									<xsl:for-each select="$virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value!='' and @hpoa:value!=' ']">

										<xsl:element name="option">
											<xsl:attribute name="value">
												<xsl:value-of select="@hpoa:value"/>
											</xsl:attribute>

											<xsl:if test="$virtualMediaStatusDoc//hpoa:virtualMediaStatus/hpoa:cdromUrl=@hpoa:value">
												<xsl:attribute name="selected">true</xsl:attribute>
											</xsl:if>
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

									</xsl:for-each>

								</select>
							</xsl:otherwise>
						</xsl:choose>

					</td>

					<xsl:for-each select="$virtualMediaStatusDoc//hpoa:virtualMediaStatus">

						<!-- Status cell -->
						<td style="vertical-align:middle;">

							<div id="{concat('bay', hpoa:bayNumber, 'VmStatus')}">

								<xsl:call-template name="getDvdStatusLabel">
									<xsl:with-param name="dvdSupport" select="hpoa:support" />
									<xsl:with-param name="dvdStatus" select="hpoa:cdromStatus" />
								</xsl:call-template>

							</div>

						</td>

						<!-- Device/URL cell -->
						<td style="vertical-align:middle;">

							<div id="{concat('bay', hpoa:bayNumber, 'DevUrl')}">

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
									<xsl:otherwise>
										<xsl:value-of select="$bladeUrl"/>
									</xsl:otherwise>
								</xsl:choose>
								
								<!--
								<xsl:choose>

									<xsl:when test="hpoa:cdromUrl = $virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:property='Enclosure DVD']/@hpoa:value">
										<xsl:value-of select="$stringsDoc//value[@key='encDVD']" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="hpoa:cdromUrl"/>
									</xsl:otherwise>

								</xsl:choose>
								-->

							</div>

						</td>

					</xsl:for-each>
				</tr>

			</table>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>

								<xsl:element name="button">

									<xsl:attribute name="type">button</xsl:attribute>
									<xsl:attribute name="class">hpButton</xsl:attribute>
									<xsl:attribute name="id">btnApply</xsl:attribute>
									<xsl:attribute name="onclick">connectServer();</xsl:attribute>

									<xsl:value-of select="$stringsDoc//value[@key='apply']" />

								</xsl:element>

							</div>
						</div>
					</div>
				</div>
			</div>
                        <span class="whiteSpacer">&#160;</span>
                        <br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:variable name="productId" select="$bladeInfoDoc//hpoa:productId" />
			<!--IPv6/IPv4 selection radios -->

			<xsl:variable name="fqdn" select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name ='iLOFQDN']" />
			<xsl:variable name="ipv4Address" select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ipAddress" />
			<xsl:variable name="ipv6Addresses" select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]" />

	                <xsl:if test="count($ipv6Addresses) &gt; 0  or string-length($fqdn) &gt; 0" >
        	                <xsl:call-template name="bayAddressRadioGroup">
					<xsl:with-param name="fqdn" select="$fqdn"  />
                	                <xsl:with-param name="ipv4Address" select="$ipv4Address" />
                        	        <xsl:with-param name="ipv6AddressList" select="$ipv6Addresses" />
	                       	</xsl:call-template>
	                        <span class="whiteSpacer">&#160;</span><br />
			</xsl:if>

			<!-- end of radio selection -->


			<xsl:choose>

				<!-- Integrity iLO2 -->
				<xsl:when test="$productId='4609'">

					<xsl:variable name="webUrl" select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:webUrl" />

					<xsl:if test="$webUrl != '[Unknown]'">

						<!--
								We need to pass 'none' here because Integrity iLO works differently than
								ProLiant iLO.
							-->
						<b>
							<xsl:element name="a">
								<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
								<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '');</xsl:attribute>
								<xsl:value-of select="$stringsDoc//value[@key='webAdmin']" />
							</xsl:element>
						</b><br />
						<xsl:value-of select="$stringsDoc//value[@key='accessiLOweb']" /><br />

					</xsl:if>

				</xsl:when>
				<!-- Integrity iLO3 -->
				<xsl:when test="$productId='33282'">

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ircUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='integratedRemoteConsole']"/>
						</xsl:element>
					</b>
					<br />
					<xsl:value-of select="$stringsDoc//value[@key='accessKVMandVirPwr']"/>
					<br />

					<span class="whiteSpacer">&#160;</span>
					<br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:remoteSerialUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='iLORemoteSerialConsole']"/>
						</xsl:element>
					</b>
					<br />
					<xsl:value-of select="$stringsDoc//value[@key='iLORemoteSerialConsoleDesc']"/>
					<br />
					
				</xsl:when>
				<!-- ProLiant iLO -->
				<xsl:when test="$productId='8224'">

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:ircUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='integratedRemoteConsole']" />
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='accessKVMandVirPwr']" /><br />

					<span class="whiteSpacer">&#160;</span>
					<br />

					<b>
						<xsl:element name="a">
							<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
							<xsl:attribute name="onclick">doiLoSso('<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:loginUrl"/>', '<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo/hpoa:remoteConsoleUrl"/>');</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='remoteConsole']" />
						</xsl:element>
					</b><br />
					<xsl:value-of select="$stringsDoc//value[@key='accessKVMfromRemoteConsole']" /><br />
					
				</xsl:when>
				
			</xsl:choose>
			
		</xsl:if>
		
	</xsl:template>


</xsl:stylesheet>

