<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="vlanInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="serviceUserAcl" />
	
	<xsl:template name="vlanControl" match="*">

		<xsl:value-of select="$stringsDoc//value[@key='vlanSettings:']"/>&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='vlanSettingsDesc']"/>
		</em>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div class="errorDisplay" id="errorDisplay"></div>
		<div class="groupingBox">

			<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<tr>
					<td id="">
						<xsl:value-of select="$stringsDoc//value[@key='vlanMode:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="type">checkbox</xsl:attribute>
							<xsl:attribute name="id">vlanEnabled</xsl:attribute>
							<xsl:if test="$vlanInfoDoc//hpoa:vlanInfo/hpoa:vlanEnable='1'">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>
						</xsl:element>&#160;<label for="vlanEnabled">
							<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
						</label>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td id="defaultVlanIdLabel">
						<xsl:value-of select="$stringsDoc//value[@key='defaultVlanId:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="class">stdInput</xsl:attribute>
							<xsl:attribute name="id">defaultVlanId</xsl:attribute>
							<xsl:attribute name="style">width:160px;</xsl:attribute>
							<xsl:attribute name="rule-list">1;9</xsl:attribute>
							<xsl:attribute name="range">1;4094</xsl:attribute>
							<xsl:attribute name="validate-me">true</xsl:attribute>
							<xsl:attribute name="caption-label">defaultVlanIdLabel</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg/hpoa:vlanId"/>
							</xsl:attribute>
						</xsl:element>&#160;(<xsl:value-of select="$stringsDoc//value[@key='untagged']"/>)
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td id="defaultVlanNameLabel">
						<xsl:value-of select="$stringsDoc//value[@key='defaultVlanName:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="class">stdInput</xsl:attribute>
							<xsl:attribute name="id">defaultVlanName</xsl:attribute>
							<xsl:attribute name="style">width:160px;</xsl:attribute>
							<xsl:attribute name="range">1:31</xsl:attribute>
							<xsl:attribute name="rule-list">0;6</xsl:attribute>
							<xsl:attribute name="validate-me">true</xsl:attribute>
							<xsl:attribute name="maxlength">31</xsl:attribute>
							<xsl:attribute name="caption-label">defaultVlanNameLabel</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg/hpoa:vlanName"/>
							</xsl:attribute>
						</xsl:element>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td id="">
						<xsl:value-of select="$stringsDoc//value[@key='oaVlanId:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:variable name="oaVlanId" select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:portArray/hpoa:port[@hpoa:deviceType='OA']/hpoa:portVlanId" />
						<xsl:element name="select">
							<xsl:attribute name="style">width:160px;</xsl:attribute>
							<xsl:attribute name="id">oaVlanSelect</xsl:attribute>
							<xsl:for-each select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg">
								<xsl:element name="option">
									<xsl:if test="hpoa:vlanId=$oaVlanId">
										<xsl:attribute name="selected">true</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="value">
										<xsl:value-of select="hpoa:vlanId"/>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when test="hpoa:vlanName=''">
											<xsl:value-of select="concat(hpoa:vlanId, ' - ', $stringsDoc//value[@key='unnamed'])"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat(hpoa:vlanId, ' - ', hpoa:vlanName)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</td>
				</tr>
			</table>

			<span class="whiteSpacer">&#160;</span>
			<br />
			
			<hr />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<xsl:value-of select="$stringsDoc//value[@key='revertDelayDesc']"/><br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<tr>
					<td id="revertDelayLabel">
						<xsl:value-of select="$stringsDoc//value[@key='revertDelay:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<!-- Validation is for 0 to 99999 -->
						<input type="text" class="stdInput" id="revertDelay" validate-me="true" rule-list="0;9" range="1;99999" caption-label="revertDelayLabel" style="width:160px;"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='seconds']"/>)
					</td>
				</tr>
			</table>
			
		</div>
		<xsl:if test="$serviceUserAcl != 'USER'">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
					<div class='bWrapperUp'>
						<div>
							<div>

								<button type='button' class='hpButton' onclick="setVlanSettings();">
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

 
