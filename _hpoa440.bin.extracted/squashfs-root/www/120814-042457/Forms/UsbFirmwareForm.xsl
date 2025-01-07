<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Templates/globalTemplates.xsl"/>

	<xsl:param name="usbFirmwareListDoc" />
	<xsl:param name="stringsDoc" />
  
	<xsl:template match="*">

		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='usbFile:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='usbFileDesc']" /></em><br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<div class="groupingBox">
			
			<xsl:choose>
				<xsl:when test="count($usbFirmwareListDoc//hpoa:usbMediaFirmwareImages/hpoa:image) &gt; 0">
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
												<xsl:for-each select="$usbFirmwareListDoc//hpoa:usbMediaFirmwareImages/hpoa:image">
													<xsl:element name="option">
														<xsl:attribute name="value"><xsl:value-of select="hpoa:fileName" /></xsl:attribute>
														<xsl:value-of select="concat(hpoa:fileName, ' (version ', hpoa:fwVersion, ')')" />
													</xsl:element>
												</xsl:for-each>
											</select>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$stringsDoc//value[@key='noUsbFirmware']" />
				</xsl:otherwise>
			</xsl:choose>
			
		</div>
		<xsl:if test="count($usbFirmwareListDoc//hpoa:usbMediaFirmwareImages/hpoa:image) &gt; 0">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnUpdateFirmware" onclick="flashOaRomFromUsb();">
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

