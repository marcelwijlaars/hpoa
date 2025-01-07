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
	
	<xsl:param name="oaSessionKey" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="oaUrl" />
	<xsl:param name="vcmMode" />
	<xsl:param name="fipsMode" />
	
	<xsl:template match="*">

		<b><xsl:value-of select="$stringsDoc//value[@key='resetFactoryDefaults']" />
		<xsl:call-template name="fipsHelpMsg">
			<xsl:with-param name="fipsMode" select="$fipsMode" />
			<xsl:with-param name="msgType">tooltip</xsl:with-param>
			<xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
		</xsl:call-template>
		</b><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='factoryRstDesc1']" />
		<br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='factoryRstDesc2']" />
		<br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<a id="link" href="javascript:load_config_script();"><xsl:value-of select="$stringsDoc//value[@key='showConfig']"/></a>

		<xsl:value-of select="$stringsDoc//value[@key='click']" /><xsl:value-of select="$stringsDoc//value[@key='factoryRstDownload']"/><br />

		<span class="whiteSpacer">&#160;</span>
		<br />

		<div id="resetErrorDisplay" class="errorDisplay"></div>
		<span class="whiteSpacer">&#160;</span>
		<br />     
		<div class="groupingBox">
			<span class="whiteSpacer">&#160;</span>      
			<br />
			<table cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td>
						<div align="right">
							<div class='buttonSet'>
								<div class='bWrapperUp'>
									<div>
										<div>
											<xsl:element name="button">
												<xsl:attribute name="type">button</xsl:attribute>
												<xsl:attribute name="class">hpButton</xsl:attribute>
												<xsl:attribute name="onclick">resetDefaults();</xsl:attribute>
												<xsl:attribute name="id">restartEMButton</xsl:attribute>
												<xsl:if test="$fipsMode='FIPS-ON' or $fipsMode='FIPS-DEBUG'">
													<xsl:attribute name="disabled">true</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="$stringsDoc//value[@key='resetFactoryDefaults']" />
											</xsl:element>
										</div>
									</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:value-of select="$stringsDoc//value[@key='clearVcMode:']"/>&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='clearVcModeDesc']"/>
		</em><br />
		<div id="clearVcErrorDisplay" class="errorDisplay"></div>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div class="groupingBox">

			<xsl:value-of select="$stringsDoc//value[@key='vcCurrently:']"/>&#160;<xsl:choose>
				<xsl:when test="$vcmMode//hpoa:vcmMode/hpoa:isVcmMode='true'">
					<span id="vcModeLbl"><xsl:value-of select="$stringsDoc//value[@key='enabled']"/></span>
				</xsl:when>
				<xsl:otherwise>
					<span id="vcModeLbl"><xsl:value-of select="$stringsDoc//value[@key='disabled']"/></span>
				</xsl:otherwise>
			</xsl:choose><br />
			
			<span class="whiteSpacer">&#160;</span>
			<br />
			<table cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td>
						<div align="right">
							<div class='buttonSet'>
								<div class='bWrapperUp'>
									<div>
										<div>
											<button type="button" class="hpButton" onclick="clearVcmMode();" id="clearVcButton">
												<xsl:value-of select="$stringsDoc//value[@key='clearVcMode']"/>
											</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

