<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="usbConfigScriptDoc" />
	<xsl:param name="oaMediaDeviceDoc" />
	<xsl:param name="usbConfigSupported" />
	<xsl:param name="isWizard" select="'false'" />

	<xsl:template match="*">

		<xsl:if test="count($usbConfigScriptDoc//hpoa:configScripts/hpoa:script) &gt; 0">
			
			<span class="whiteSpacer">&#160;</span><br />
	        
			<xsl:value-of select="$stringsDoc//value[@key='usbFile:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='usbFileConfigDesc']" /></em><br />
			<span class="whiteSpacer">&#160;</span><br />
			
			<div class="groupingBox">
				<div id="usbErrorDisplay" class="errorDisplay"></div>
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr>
									<td id="lblUsbUrl"><xsl:value-of select="$stringsDoc//value[@key='url:']" /></td>
									<td width="10">&#160;</td>
									<td>
										<select id="usbFileList">
											<xsl:for-each select="$usbConfigScriptDoc//hpoa:configScripts/hpoa:script">
												<xsl:element name="option">
													<xsl:attribute name="value"><xsl:value-of select="hpoa:fileName" /></xsl:attribute>
													<xsl:value-of select="hpoa:fileName" />
												</xsl:element>
											</xsl:for-each>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			
			<span class="whiteSpacer">&#160;</span><br />
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
				<div class='bWrapperUp'>
					<div>
					<div>
						<button type='button' class='hpButton' id="btnUpdateFirmware" onclick="executeScriptFromUsb();">
							<xsl:value-of select="$stringsDoc//value[@key='apply']" />
						</button>
					</div>
					</div>
				</div>
				</div>
			</div>
			
		</xsl:if>

		<xsl:if test="count($oaMediaDeviceDoc//hpoa:oaMediaDevice[hpoa:deviceType=2 and hpoa:devicePresence='PRESENT']) &gt; 0 and $usbConfigSupported and $isWizard='false'">
			
			<span class="whiteSpacer">&#160;</span><br />

			<xsl:value-of select="$stringsDoc//value[@key='saveConfig:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='saveConfigDesc']" />
			</em><br />
			<span class="whiteSpacer">&#160;</span><br />

			<div class="groupingBox">
				<div id="saveConfigErrorDisplay" class="errorDisplay"></div>
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr>
									<td id="lblUsbFile">
										<xsl:value-of select="$stringsDoc//value[@key='filename:']" />
									</td>
									<td width="10">&#160;</td>
									<td>
										<input class="stdInput" type="text" validate-usb-script="true" rule-list="1" caption-label="lblUsbFile" name="usbFileName" id="usbFileName" size="128" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>

			<span class="whiteSpacer">&#160;</span><br />
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnApply" onclick="saveConfigScriptUsb();">
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

