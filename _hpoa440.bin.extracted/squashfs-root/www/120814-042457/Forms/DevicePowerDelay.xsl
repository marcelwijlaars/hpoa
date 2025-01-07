<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl"/>
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="powerSequenceDoc" />
	<xsl:param name="side" select="'0'" />
	
	<xsl:param name="serviceUserAcl" />
	
	<xsl:template match="*">

		<div id="errorDisplay" class="errorDisplay"></div>
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" id="powerDelayContainer">
			<thead>
				<tr class="captionRow">
					<th style="min-width:10px;white-space:nowrap;"><xsl:value-of select="$stringsDoc//value[@key='bay']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='device']"/></th>
					<th style="min-width:10px;white-space:nowrap;">
						<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
					</th>
					<th id="delayHeader"><xsl:value-of select="$stringsDoc//value[@key='delay']"/></th>
				</tr>
			</thead>
			<TBODY>

				<xsl:choose>
					<xsl:when test="count($powerSequenceDoc//hpoa:powerdelaySettings/hpoa:servers/hpoa:bays/hpoa:extraData[@hpoa:name='NormalizedSideNumber' and .=$side]) &gt; 0">
						<xsl:for-each select="$powerSequenceDoc//hpoa:powerdelaySettings/hpoa:servers/hpoa:bays/hpoa:extraData[@hpoa:name='NormalizedSideNumber' and .=$side]/..">

								<xsl:variable name="symbolicBayNumber" select="hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
								<xsl:variable name="bayNumber" select="hpoa:bayNumber"/>
								<xsl:variable name="delay" select="hpoa:delay" />

								<xsl:element name="tr">

									<xsl:if test="position() mod 2 != 0">
										<xsl:attribute name="class">altRowColor</xsl:attribute>
									</xsl:if>

									<td>
										<xsl:value-of select="$symbolicBayNumber"/>
									</td>
									<td id="{concat('bay', $bayNumber, 'Label')}">

										<xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo">
											<xsl:if test="hpoa:extraData[@hpoa:name='SymbolicBladeNumber']=$symbolicBayNumber">
												<xsl:choose>
													<xsl:when test="hpoa:presence=$PRESENT">
														<xsl:value-of select="hpoa:name"/>
													</xsl:when>
													<xsl:when test="hpoa:presence=$SUBSUMED">
														<xsl:value-of select="$stringsDoc//value[@key='subsumed']"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:for-each>

									</td>
									<td>

										<xsl:choose>
											<xsl:when test="$serviceUserAcl = $ADMINISTRATOR">
												<xsl:element name="select">

													<xsl:attribute name="onchange">updateDelayInputs(this);</xsl:attribute>
													<xsl:attribute name="bayNumber">
														<xsl:value-of select="$symbolicBayNumber"/>
													</xsl:attribute>

													<xsl:element name="option">
														<xsl:if test="number($delay) &gt; 0">
															<xsl:attribute name="selected">true</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="value">
															<xsl:value-of select="1"/>
														</xsl:attribute>
														<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
													</xsl:element>

													<xsl:element name="option">
														<xsl:if test="number($delay) = 0">
															<xsl:attribute name="selected">true</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="value">
															<xsl:value-of select="0"/>
														</xsl:attribute>
														<xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
													</xsl:element>

													<xsl:element name="option">
														<xsl:if test="number($delay) &lt; 0">
															<xsl:attribute name="selected">true</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="value">
															<xsl:value-of select="-1"/>
														</xsl:attribute>
														<xsl:value-of select="$stringsDoc//value[@key='noPoweron']"/>
													</xsl:element>

												</xsl:element>
											</xsl:when>
											<xsl:otherwise>

												<xsl:choose>
													<xsl:when test="number($delay) &gt; 0">
														<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
													</xsl:when>
													<xsl:when test="number($delay) = 0">
														<xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
													</xsl:when>
													<xsl:when test="number($delay) &lt; 0">
														<xsl:value-of select="$stringsDoc//value[@key='noPoweron']"/>
													</xsl:when>
												</xsl:choose>

											</xsl:otherwise>
										</xsl:choose>

									</td>
									<td>

										<xsl:choose>
											<xsl:when test="$serviceUserAcl = $ADMINISTRATOR">
												<xsl:element name="input">

													<xsl:attribute name="type">text</xsl:attribute>
													<xsl:attribute name="class">stdInput</xsl:attribute>
													<xsl:attribute name="style">width:30px;</xsl:attribute>
													<xsl:attribute name="bayNumber">
														<xsl:value-of select="$bayNumber"/>
													</xsl:attribute>
													<xsl:attribute name="id">
														<xsl:value-of select="concat('delayInput', $symbolicBayNumber)"/>
													</xsl:attribute>
													
													
													<xsl:attribute name="rule-list">9</xsl:attribute>
													<xsl:attribute name="range">1;3600</xsl:attribute>
													<xsl:attribute name="caption-label">delayHeader</xsl:attribute>
													
													<xsl:choose>
														<xsl:when test="number($delay) &gt; 0">
														  <xsl:attribute name="validate-me">true</xsl:attribute>
															<xsl:attribute name="value">
																<xsl:value-of select="$delay"/>
															</xsl:attribute>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="number($delay)=0">
																<xsl:attribute name="value">0</xsl:attribute>
															</xsl:if>
															<xsl:attribute name="validate-me">false</xsl:attribute>
															<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
															<xsl:attribute name="disabled">true</xsl:attribute>
														</xsl:otherwise>
													</xsl:choose>

												</xsl:element>&#160;&#160;<xsl:value-of select="$stringsDoc//value[@key='seconds']" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="number($delay) &gt;= 0">
													<xsl:value-of select="$delay"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='seconds']" />
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>

									</td>

								</xsl:element>

						</xsl:for-each>
						
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td colspan="4" style="text-align:center;"><xsl:value-of select="$stringsDoc//value[@key='noDeviceToDisplay']" /></td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>

			</TBODY>
		</table>

		<xsl:if test="$serviceUserAcl = $ADMINISTRATOR">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' onclick="setPowerDelaySettings('device');" class='hpButton' id="btnApply">
									<xsl:value-of select="$stringsDoc//value[@key='apply']" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>

	</xsl:template>
	

</xsl:stylesheet>

