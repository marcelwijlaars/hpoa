<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2012 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="stringsDoc" />
	<xsl:param name="bayListDoc" />
	<xsl:param name="ebipav6InfoDoc" />
	<xsl:param name="invalidIpString" />
	<xsl:param name="isTower" />
	<xsl:param name="isWizard" />

	<!--
		We default to ADMINISTRATOR for the wizard, but this parameter is supplied by
		the service object in the main gui.
	-->
	<xsl:param name="serviceUserAcl" select="'ADMINISTRATOR'" />

	<!-- server (device) or interconnect bays -->
	<xsl:param name="deviceType" />

	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Templates/globalTemplates.xsl"/>

	<xsl:template match="*">
		<!--
			This variable is used to return an enclosure count for the autofill.
		-->
		<xsl:variable name="enclosureCount" select="count($bayListDoc/enclosureBayList/enclosure)" />

		<xsl:variable name="enabledCount" select="count($bayListDoc/enclosureBayList/enclosure//bay/hpoa:bay[hpoa:enabled='true'])" />
		<xsl:variable name="resetCount" select="count($bayListDoc/enclosureBayList/enclosure//bay/hpoa:bay[hpoa:reset='true'])" />

		<xsl:variable name="allBaysEnabled" select="($enabledCount != 0) and ($enabledCount = count($bayListDoc/enclosureBayList/enclosure/bay))" />
		<xsl:variable name="allBaysReset" select="($resetCount != 0) and ($resetCount = count($bayListDoc/enclosureBayList/enclosure/bay))" />

		<xsl:variable name="tableId">
			<xsl:choose>
				<xsl:when test="$deviceType='server'">
					<xsl:value-of select="'ebipav6DeviceSummary'" />
				</xsl:when>
				<xsl:when test="$deviceType='interconnect'">
					<xsl:value-of select="'ebipav6InterconnectSummary'" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="deviceListTable">
			<xsl:with-param name="tableId" select="$tableId" />
			<xsl:with-param name="enclosureCount" select="$enclosureCount" />
			<xsl:with-param name="allBaysEnabled" select="$allBaysEnabled" />
			<xsl:with-param name="allBaysReset" select="$allBaysReset" />
		</xsl:call-template>

	</xsl:template>

	<xsl:template name="deviceListTable">
		<xsl:param name="tableId" />
		<xsl:param name="enclosureCount" />
		<xsl:param name="allBaysEnabled" />
		<xsl:param name="allBaysReset" />
    
    <xsl:variable name="supportsGateway" select="string(count($bayListDoc/enclosureBayList//enclosure/bay/hpoa:bay/hpoa:gateway) &gt; 0)" />
    <xsl:variable name="colWidth">
      <xsl:choose>
        <xsl:when test="$supportsGateway = 'true'">25%</xsl:when>
        <xsl:otherwise>33%</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

		<xsl:element name="table">
			<xsl:attribute name="cellpadding">0</xsl:attribute>
			<xsl:attribute name="cellspacing">0</xsl:attribute>
			<xsl:attribute name="class">dataTable</xsl:attribute>

			<xsl:attribute name="id">
				<xsl:value-of select="$tableId"/>
			</xsl:attribute>

			<thead>
				<tr class="captionRow">

					<th style="vertical-align:middle; width:20px;" nowrap="true">
						<xsl:value-of select="$stringsDoc//value[@key='bay']" />
					</th>

					<!-- Bay enabled checkbox master. -->
					<th style="vertical-align:middle; width:75px;" nowrap="true">

						<xsl:element name="input">

							<xsl:attribute name="type">checkbox</xsl:attribute>

							<xsl:attribute name="id">
								<xsl:value-of select="concat($deviceType, 'MasterCheckboxEnabled')"/>
							</xsl:attribute>

							<xsl:if test="$allBaysEnabled">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>

							<xsl:if test="$serviceUserAcl='USER'">
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:if>

							<xsl:attribute name="ebipav6DevType"><xsl:value-of select="$deviceType"/></xsl:attribute>
							<xsl:attribute name="onclick">checkboxToggle(this, 'ebipav6DevType', '<xsl:value-of select="$deviceType"/>', '<xsl:value-of select="$tableId"/>', true);</xsl:attribute>

						</xsl:element>

						<xsl:value-of select="$stringsDoc//value[@key='enabled']" />

					</th>

					<th style="vertical-align:middle;" width="{$colWidth}" nowrap="true">
						<xsl:value-of select="$stringsDoc//value[@key='ebipaAddress']" />
					</th>
          <!-- Gateway field -->
          <xsl:if test="$supportsGateway = 'true'">
            <th style="vertical-align:middle;" width="{$colWidth}" nowrap="true">
						  <xsl:value-of select="$stringsDoc//value[@key='gateway']" />
					  </th>
          </xsl:if>
					<th style="vertical-align:middle;" width="{$colWidth}" nowrap="true">
						<xsl:value-of select="$stringsDoc//value[@key='domain']" />
					</th>
					<th style="vertical-align:middle;" width="{$colWidth}" nowrap="true">
						<xsl:value-of select="$stringsDoc//value[@key='dnsServers']" />
					</th>
					<th style="vertical-align:middle;" nowrap="true">
						<xsl:value-of select="$stringsDoc//value[@key='autofill']" />
					</th>
					<th style="vertical-align:middle;" nowrap="true">
						<xsl:value-of select="$stringsDoc//value[@key='currentAddress']" />
					</th>
					<!-- Hide if VLAN disabled -->
					<xsl:if test="count($bayListDoc/enclosureBayList//enclosure[@vlanEnabled=1]) &gt; 0">
						<th style="vertical-align:middle;" nowrap="true">
							VLAN ID
						</th>
					</xsl:if>
				</tr>
			</thead>

			<xsl:for-each select="$bayListDoc/enclosureBayList/enclosure">
				<xsl:variable name="encNum" select="@encNum" />
				<xsl:variable name="encUuid" select="@uuid" />
				<xsl:variable name="enclosurePosition" select="position()" />

				<xsl:element name="tbody">
					<xsl:attribute name="deviceType">
						<xsl:value-of select="$deviceType"/>
					</xsl:attribute>
					<xsl:attribute name="encUuid">
						<xsl:value-of select="$encUuid"/>
					</xsl:attribute>

					<xsl:if test="count($bayListDoc/enclosureBayList/enclosure) &gt; 1">
						<xsl:element name="tr">
							<xsl:attribute name="class">treeTableTopLevel</xsl:attribute>

							<td class="sorted" colspan="1">
								<xsl:call-template name="enclosureIcon">
									<xsl:with-param name="encType" select="@encType" />
									<xsl:with-param name="isTower" select="@isTower" />
									<!-- following params not needed for this usage, supply phony values -->
									<xsl:with-param name="isLocal" select="'false'" />
									<xsl:with-param name="isAuthenticated" select="'true'" />
								</xsl:call-template>
							</td>

							<td class="sorted" colspan="9" style="vertical-align:middle;">
								<xsl:value-of select="$stringsDoc//value[@key='enclosure:']" />&#160;<xsl:value-of select="@encName"/>
							</td>
						</xsl:element>
					</xsl:if>

					<xsl:for-each select="bay">
						<xsl:variable name="bayNumber" select="number(@number)"/>
						<xsl:variable name="presence" select="@presence" />
						<xsl:variable name="wrapperId" select="concat('enc', $encNum, $deviceType, $bayNumber, 'AddressWrapper')"/>

						<xsl:element name="tr">
							<!-- Bay identification -->
							<xsl:attribute name="bayNumber">
								<xsl:value-of select="$bayNumber"/>
							</xsl:attribute>

							<xsl:if test="position() mod 2 != 0">
								<xsl:attribute name="class">altRowColor</xsl:attribute>
							</xsl:if>

							<td style="width:20px;">
								<xsl:value-of select="@bayDisplayNumber"/>
							</td>

							<!-- Enabled/disabled for bay checkbox -->
							<td style="width:10px;">
								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>

									<xsl:attribute name="ebipav6DevType">
										<xsl:value-of select="$deviceType"/>
									</xsl:attribute>

									<xsl:attribute name="id">
										<xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'Ebipav6BayEnabled')" />
									</xsl:attribute>

									<xsl:if test="$serviceUserAcl='USER'">
										<xsl:attribute name="disabled">true</xsl:attribute>
									</xsl:if>

									<xsl:if test="hpoa:bay/hpoa:enabled = 'true'">
										<xsl:attribute name="checked">true</xsl:attribute>
									</xsl:if>
								</xsl:element>
							</td>

							<!-- Variable is used for both the text input and the image. -->
							<xsl:variable name="inputId" select="concat('enc', $encNum, $deviceType, $bayNumber, 'Ebipav6BayAddress')" />

							<td nowrap="true" width="auto">
								<!-- Wrap this cell in a div so we can call toggleFormEnabled. -->
								<xsl:element name="div">
									<xsl:attribute name="id">
										<xsl:value-of select="$wrapperId"/>
									</xsl:attribute>

									<xsl:element name="input">
										<xsl:attribute name="type">text</xsl:attribute>

										<xsl:attribute name="id">
											<xsl:value-of select="$inputId" />
										</xsl:attribute>

										<xsl:if test="$serviceUserAcl='USER'">
											<xsl:attribute name="readonly">true</xsl:attribute>
										</xsl:if>

										<xsl:attribute name="class">stdInput</xsl:attribute>
										<xsl:attribute name="style">width:98%;min-width:90px;</xsl:attribute>

										<xsl:attribute name="value">
											<xsl:value-of select="hpoa:bay/hpoa:ipAddress"/>
										</xsl:attribute>
									</xsl:element>

								</xsl:element>

							</td>
              
              <!-- Gateway field -->
              <xsl:if test="$supportsGateway = 'true'">
                <td width="auto">
								  <xsl:element name="input">
									  <xsl:attribute name="type">text</xsl:attribute>
									  <xsl:attribute name="class">stdInput</xsl:attribute>
									  <xsl:attribute name="style">width:98%;min-width:90px;</xsl:attribute>
									  <xsl:attribute name="id">
										  <xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'Ebipav6Gateway')"/>
									  </xsl:attribute>
									  <xsl:attribute name="value">
										  <xsl:value-of select="hpoa:bay/hpoa:gateway"/>
									  </xsl:attribute>
								  </xsl:element>
							  </td>
              </xsl:if>

							<!-- Domain name field -->
							<td width="auto">
								<xsl:element name="input">
									<xsl:attribute name="type">text</xsl:attribute>
									<xsl:attribute name="class">stdInput</xsl:attribute>
									<xsl:attribute name="style">width:98%;min-width:90px;</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'Ebipav6Domain')"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="hpoa:bay/hpoa:domain"/>
									</xsl:attribute>
								</xsl:element>
							</td>

							<!-- DNS fields -->
							<td width="auto">
								<!-- DNS 1 field -->
								<xsl:element name="input">
									<xsl:attribute name="type">text</xsl:attribute>
									<xsl:attribute name="class">stdInput</xsl:attribute>
									<xsl:attribute name="style">width:98%;min-width:90px;</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'Ebipav6Dns1')"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="hpoa:bay/hpoa:dns1"/>
									</xsl:attribute>
								</xsl:element>
								<br />
								<!-- DNS 2 field -->
								<xsl:element name="input">
									<xsl:attribute name="type">text</xsl:attribute>
									<xsl:attribute name="class">stdInput</xsl:attribute>
									<xsl:attribute name="style">width:98%;min-width:90px;</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'Ebipav6Dns2')"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="hpoa:bay/hpoa:dns2"/>
									</xsl:attribute>
								</xsl:element>
								<br />
								<!-- DNS 3 field -->
								<xsl:element name="input">
									<xsl:attribute name="type">text</xsl:attribute>
									<xsl:attribute name="class">stdInput</xsl:attribute>
									<xsl:attribute name="style">width:98%;min-width:90px;</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'Ebipav6Dns3')"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="hpoa:bay/hpoa:dns3"/>
									</xsl:attribute>
								</xsl:element>
							</td>

							<!-- Autofill -->
							<td style="width:10px;whitespace:nowrap;">
								<xsl:if test="($enclosureCount!=$enclosurePosition) or position() != last()">
									<xsl:element name="img">
										<xsl:attribute name="src">/120814-042457/images/icon_tray_expand_down_filled.gif</xsl:attribute>
										<xsl:if test="$serviceUserAcl!='USER'">
											<xsl:attribute name="onclick">doAutoFillv6('<xsl:value-of select="$tableId"/>', '<xsl:value-of select="$encNum"/>', '<xsl:value-of select="$bayNumber"/>', '<xsl:value-of select="$deviceType"/>', <xsl:value-of select="$enclosureCount"/>);</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="class">autoFill</xsl:attribute>

										<xsl:attribute name="id">
											<xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'AutofillImage')" />
										</xsl:attribute>

										<xsl:attribute name="relatedInputId">
											<xsl:value-of select="$inputId"/>
										</xsl:attribute>
										<xsl:attribute name="enclosureCount">
											<xsl:value-of select="$enclosureCount"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>

							</td>
							<td style="width:10px;" nowrap="true">

								<xsl:element name="span">

									<xsl:attribute name="id">
										<xsl:value-of select="concat('enc', $encNum, $deviceType, $bayNumber, 'MpAddress')"/>
									</xsl:attribute>

									<xsl:choose>
										<xsl:when test="$deviceType='server'">

											<xsl:choose>
												<xsl:when test="@bladeType='BLADE_TYPE_SERVER' or @productId='8213'">

													<xsl:choose>
														<xsl:when test="@currentIpv6 != '' and @currentIpv6 != '::' and @currentIpv6 != '::/0'">
															<!-- This value comes from the blade's mp info struct. -->
															<xsl:value-of select="@currentIpv6"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
														</xsl:otherwise>
													</xsl:choose>

												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
												</xsl:otherwise>
											</xsl:choose>

										</xsl:when>
										<xsl:when test="$deviceType='interconnect'">
											<xsl:value-of select="@currentIpv6"/>
										</xsl:when>
									</xsl:choose>

								</xsl:element> <!-- end span -->

							</td>
							<!-- Hide if VLAN disabled -->
							<xsl:if test="count($bayListDoc/enclosureBayList//enclosure[@vlanEnabled=1]) &gt; 0">
								<td style="text-align:center;">
									<xsl:value-of select="@vlanId"/>
								</td>
							</xsl:if>

						</xsl:element>

					</xsl:for-each>

				</xsl:element>

			</xsl:for-each>

		</xsl:element>

	</xsl:template>

</xsl:stylesheet>
