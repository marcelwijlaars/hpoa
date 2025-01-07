<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:template name="ServerSelect">

		<xsl:param name="enclosureNumber" />
		<xsl:param name="checkAll" />
		<xsl:param name="disableAll" />
		<xsl:param name="enclosureType" select="0" />
		<xsl:param name="checkAllLabel" select="''" />
                <xsl:param name="bladeInfoDoc" select="document('')" />
                <xsl:param name="disableNotPresent" select="'false'" />

		<xsl:variable name="numBays">
			<xsl:choose>
				<xsl:when test="$enclosureType=0 or $enclosureType=-1">
					<xsl:value-of select="number(16)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(8)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<xsl:element name="input">

						<xsl:attribute name="onclick">checkboxToggle(this, 'devid', 'bay', '<xsl:value-of select="concat('svbSelectEnc', $enclosureNumber)" />');</xsl:attribute>
						<xsl:attribute name="type">checkbox</xsl:attribute>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($enclosureNumber,' Bay Select')" />
						</xsl:attribute>
						<xsl:attribute name="devid">bay</xsl:attribute>
						<xsl:attribute name="style">margin-right:5px;</xsl:attribute>
						<xsl:if test="$checkAll = 'true'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:if test="count(hpoa:bladeBays/hpoa:blade[hpoa:access='true'])=number($numBays)*3">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:if test="$disableAll = 'true'">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>
					</xsl:element>

					<xsl:element name="label">
						<xsl:attribute name="for">
							<xsl:value-of select="concat($enclosureNumber,' Bay Select')" />
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$checkAllLabel != ''">
								<xsl:value-of select="$checkAllLabel"/>
							</xsl:when>
							<xsl:otherwise>
						<xsl:value-of select="$stringsDoc//value[@key='allServerBays']" />
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:element>
				</td>
			</tr>
			<tr>
				<td align="center">

					<xsl:choose>

						<xsl:when test="$enclosureType=0 or $enclosureType=-1">

							<xsl:element name="div">

								<xsl:attribute name="id">
									<xsl:value-of select="concat('svbSelectEnc', $enclosureNumber)" />
								</xsl:attribute>

								<table cellpadding="1" cellspacing="0" class="baysSmall">
									<tr>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom"></td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">1</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">2</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">3</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">4</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">5</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">6</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">7</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">8</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom"></td>
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;height:42px;">
											
										</td>

                                                                                <xsl:call-template name="forLoop">
                                                                                    <xsl:with-param name="index" select="number(1)"/>
                                                                                    <xsl:with-param name="count" select="number(8)"/>
                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                </xsl:call-template>

										<td style="background:none;border:none;color:#000000;height:42px;">
											
										</td>
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;height:42px;">
											A
										</td>

                                                                                <xsl:call-template name="forLoop">
                                                                                    <xsl:with-param name="index" select="number(17)"/>
                                                                                    <xsl:with-param name="count" select="number(24)"/>
                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                </xsl:call-template>

                                                                                <td style="background:none;border:none;color:#000000;height:42px;">
											A
										</td>
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;height:42px;">
											B
										</td>


                                                                                <xsl:call-template name="forLoop">
                                                                                    <xsl:with-param name="index" select="number(33)"/>
                                                                                    <xsl:with-param name="count" select="number(40)"/>
                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                </xsl:call-template>

										<td style="background:none;border:none;color:#000000;height:42px;">
											B
										</td>
										
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom"></td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">1</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">2</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">3</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">4</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">5</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">6</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">7</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom">8</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom"></td>
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top"></td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">9</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">10</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">11</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">12</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">13</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">14</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">15</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">16</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="bottom"></td>
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;height:42px;">
											
										</td>

                                                                                <xsl:call-template name="forLoop">
                                                                                    <xsl:with-param name="index" select="number(9)"/>
                                                                                    <xsl:with-param name="count" select="number(16)"/>
                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                </xsl:call-template>

									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;height:42px;">
											A
										</td>

                                                                                <xsl:call-template name="forLoop">
                                                                                    <xsl:with-param name="index" select="number(25)"/>
                                                                                    <xsl:with-param name="count" select="number(32)"/>
                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                </xsl:call-template>

										<td style="background:none;border:none;color:#000000;height:42px;">
											A
										</td>
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;height:42px;">
											B
										</td>

                                                                                <xsl:call-template name="forLoop">
                                                                                    <xsl:with-param name="index" select="number(41)"/>
                                                                                    <xsl:with-param name="count" select="number(48)"/>
                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                </xsl:call-template>

										<td style="background:none;border:none;color:#000000;height:42px;">
											B
										</td>
									</tr>
									<tr>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top"></td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">9</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">10</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">11</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">12</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">13</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">14</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">15</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top">16</td>
										<td style="background:none;border:none;color:#000000;" align="center" valign="top"></td>
									</tr>
								</table>
							</xsl:element>
							
						</xsl:when>
						<!-- c3000 permissions -->
						<xsl:otherwise>

							<span class="whiteSpacer">&#160;</span>
							<br />
							
							<xsl:element name="div">

								<xsl:attribute name="id">
									<xsl:value-of select="concat('svbSelectEnc', $enclosureNumber)" />
								</xsl:attribute>

								<xsl:choose>
								  <xsl:when test="$isTower = 'true'">
									<table cellpadding="1" cellspacing="0">
									  <tr>
										<td align="center">Top</td>
									  </tr>
									</table>
				                    
									<table cellpadding="1" cellspacing="0" class="baysSmall">
									  <tr>
										<td style="height:110px;">
											1<br/>
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="1" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											1A<br/>
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="17" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											1B<br/>
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="33" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
										<td>
											2<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="2" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											2A<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="18" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											2B<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="34" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
										<td>
											3<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="3" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											3A<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="19" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											3B<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="35" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
										<td>
											4<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="4" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											4A<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="20" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											4B<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="36" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
									  </tr>
									  <tr>
										<td style="height:110px;">
											5<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="5" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											5A<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="21" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											5B<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="37" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
										<td>
											6<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="6" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											6A<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="22" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											6B<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="38" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
										<td>
											7<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="7" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											7A<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="23" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											7B<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="39" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
										<td>
											8<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="8" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											8A<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="24" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
											8B<br />
                                                                                        <xsl:call-template name="displayCheckBox_c7000">
                                                                                            <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                            <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                            <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                            <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                            <xsl:with-param name="bayNumber" select="40" />
                                                                                            <xsl:with-param name="type" select="3" />
                                                                                        </xsl:call-template><br />
										</td>
									  </tr>
									</table>
								  </xsl:when>
								  <!-- Not tower mode -->
								  <xsl:otherwise>
									<table cellpadding="0" cellspacing="0" border="0" height="74" class="ioBaysSmall" ID="Table3">
									  <tr>
										<td style="width:110px;">
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">4</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="4" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>

													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">4A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="20" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">4B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="36" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
												</tr>
											</table>
										
										</td>
										<td style="width:110px;">
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">8</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="8" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">8A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="24" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">8B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="40" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
												</tr>
											</table>
										</td>
									  </tr>
									  <tr>
										<td>
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">3</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="3" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">3A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="19" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>

													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">3B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="35" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
												</tr>
											</table>
										</td>
										<td>
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">7</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="7" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">7A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="23" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">7B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="39" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
                                                                                                        </td>
												</tr>
											</table>
										</td>
									  </tr>
									  <tr>
										<td>
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">2</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="2" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">2A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="18" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">2B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="34" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
												</tr>
											</table>
										</td>
										<td>
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">6</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="6" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">6A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="22" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">6B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="38" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
												</tr>
											</table>
										</td>
									  </tr>
									  <tr>
										<td>
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">1</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="1" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">1A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="17" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>

													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">1B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="33" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
												</tr>
											</table>
										</td>
										<td>
											<table cellspacing="0" cellpadding="0" border="0" style="border:0px none;">
												<tr>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">5</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="5" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">5A</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="21" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
													<td style="border: 0px none;">
														<span style="color:#FFFFFF;">5B</span>
                                                                                                                <xsl:call-template name="displayCheckBox_c7000">
                                                                                                                    <xsl:with-param name="checkAll" select="$checkAll" />
                                                                                                                    <xsl:with-param name="disableAll" select="$disableAll" />
                                                                                                                    <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                                                                    <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                                                                                                                    <xsl:with-param name="bayNumber" select="37" />
                                                                                                                    <xsl:with-param name="type" select="2" />
                                                                                                                </xsl:call-template>
													</td>
												</tr>
											</table>
										</td>
									  </tr>
									</table>
								  </xsl:otherwise>
								</xsl:choose>
                
							</xsl:element>
							
						</xsl:otherwise>
						
					</xsl:choose>
					
				</td>
			</tr>
		</table>
	</xsl:template>


        <xsl:template name="forLoop">
          <xsl:param name="index"/>
          <xsl:param name="count"/>
          <xsl:param name="disableNotPresent" />
          <xsl:param name="checkAll" />
          <xsl:param name="bladeInfoDoc" />
          <xsl:param name="disableAll" />
          
          <xsl:if test="$index &lt;= $count">
            <td>
            <xsl:call-template name="displayCheckBox_c7000">
                <xsl:with-param name="checkAll" select="$checkAll" />
                <xsl:with-param name="disableAll" select="$disableAll" />
                <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
                <xsl:with-param name="bayNumber" select="$index" />
                <xsl:with-param name="type" select="1" />
            </xsl:call-template>
            </td>
            <xsl:call-template name="forLoop">
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="count" select="$count"/>
                <xsl:with-param name="checkAll" select="$checkAll" />
                <xsl:with-param name="disableAll" select="$disableAll" />
                <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                <xsl:with-param name="disableNotPresent" select="$disableNotPresent" />
          </xsl:call-template>
        </xsl:if>
       </xsl:template>


        <xsl:template name="displayCheckBox_c7000">
            <xsl:param name="disableNotPresent" />
            <xsl:param name="checkAll" />
            <xsl:param name="bladeInfoDoc" />
            <xsl:param name="bayNumber" />
            <xsl:param name="disableAll" />
            <xsl:param name="type" select="1" />
            
            <xsl:variable name="secureBoot" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber = $bayNumber]/hpoa:extraData[@hpoa:name='secureBoot']" />
            <xsl:variable name="img-style">
              <xsl:choose>
                <xsl:when test="$type=2">margin-left:4px;margin-top:2px</xsl:when>
                <xsl:otherwise>margin:3px</xsl:otherwise>               
              </xsl:choose>
            </xsl:variable>
          
             <xsl:choose>
              <xsl:when test="$disableNotPresent='false' or ($disableNotPresent='true' and $bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]/hpoa:presence=$PRESENT)">
                <xsl:choose>
                  <xsl:when test="$secureBoot = 'enabled'">
                    <img src="/120814-042457/images/disabled_checkbox_locked.gif" style="{$img-style}" width="13" height="13" title="{$stringsDoc//value[@key='unavailableInSecureBootMode']}" />
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:element name="input">
                      <xsl:attribute name="type">checkbox</xsl:attribute>
                      <xsl:attribute name="devid">bay</xsl:attribute>
                      <xsl:attribute name="bayId"><xsl:value-of select="$bayNumber" /></xsl:attribute>
                      <xsl:if test="$checkAll = 'true'">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber]/hpoa:access='true'">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$disableAll = 'true'">
                        <xsl:attribute name="disabled">true</xsl:attribute>
                      </xsl:if>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>                  
             </xsl:when>
             <xsl:otherwise>
               <img src="/120814-042457/images/disabled_checkbox.gif" style="{$img-style}" width="13" height="13" />
             </xsl:otherwise>
           </xsl:choose>            
          </xsl:template>
</xsl:stylesheet>

