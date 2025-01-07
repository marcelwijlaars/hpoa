<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:include href="../Forms/NetworkSettings.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureName" />
	<xsl:param name="enclosureNum" />
	<xsl:param name="activeOaNetworkInfo" />
	<xsl:param name="standbyOaNetworkInfo" />
	<xsl:param name="hasStandby" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="enclosureType" select="0" />

	<xsl:template match="*">

		<b>
			<xsl:value-of select="$stringsDoc//value[@key='ipSettings']" /> - <xsl:value-of select="$stringsDoc//value[@key='nicOptions']" />
		</b>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div id="stepInnerContent">

			
			<span class="whiteSpacer">&#160;</span>
			<br />
			
			<div id="oaNetSettingsErrorDisplay" class="errorDisplay"></div>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
						<td>
						<xsl:value-of select="$stringsDoc//value[@key='nicSettingsActive']" />
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						<div class="groupingBox" >
							<div id="nicErrorDisplay" class="errorDisplay"></div>
							<xsl:call-template name="nicSettings">
								<xsl:with-param name="oaNetworkInfoDoc" select="$activeOaNetworkInfo" />
								<xsl:with-param name="oaMode" select="'ACTIVE'" />
								<xsl:with-param name="encNum" select="$enclosureNum" />
							</xsl:call-template>
						</div>
				
					</td>
					<xsl:if test="$hasStandby='true'">
						<td style="width:40px;">
							<img src="/120814-042457/images/one_white.gif" width="40" />
						</td>

							<td>
							<xsl:value-of select="$stringsDoc//value[@key='nicSettingsStandby']" />
							<br />
							<span class="whiteSpacer">&#160;</span>
							<br />
							<div class="groupingBox">
								<div id="nicErrorDisplay" class="errorDisplay"></div>
								<xsl:call-template name="nicSettings">
									<xsl:with-param name="oaNetworkInfoDoc" select="$standbyOaNetworkInfo" />
									<xsl:with-param name="oaMode" select="'STANDBY'" />
									<xsl:with-param name="encNum" select="$enclosureNum" />
								</xsl:call-template>
							</div>

						</td>
					</xsl:if>
				</tr>
			</table>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' onclick='setupOaNetSettingsNIC(true,successCallbackNic);'  class='hpButton' id="Button3">
									<xsl:value-of select="$stringsDoc//value[@key='apply']" />
									
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<span class="whiteSpacer">&#160;</span>
			<br />
		</div>
	</xsl:template>
</xsl:stylesheet>

