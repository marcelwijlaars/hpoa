<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="ebipaServer">

		<xsl:param name="displaySettingsNote" select="'false'" />
		
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td valign="top" width="100%">

					<xsl:value-of select="$stringsDoc//value[@key='deviceList:']" />&#160;<em>
					<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceListDesc']" />&#160;
					<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
					<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceListNote']" />
					</em><br />
					<span class="whiteSpacer">&#160;</span>
					<br />

					<div id="ebipaDeviceListContainer"></div>

				</td>
			</tr>
		</table>
		
	</xsl:template>

	<xsl:template name="ebipaInterconnect">

		<xsl:param name="displaySettingsNote" select="'false'"/>

		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				
				<td width="89%" valign="top">

					<xsl:value-of select="$stringsDoc//value[@key='interconnectList:']" />
					<em>
						&#160;
						<xsl:value-of select="$stringsDoc//value[@key='ebipaInterConnectListDesc']" />&#160;&#160;
						<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
						<xsl:value-of select="$stringsDoc//value[@key='ebipaInterConnectListNote']" />
					</em>
					<br />
					<span class="whiteSpacer">&#160;</span>
					<br />

					<div id="ebipaInterconnectListContainer"></div>

				</td>
			</tr>
		</table>

	</xsl:template>

	<xsl:template name="ebipaServerWiz">

		<xsl:param name="displaySettingsNote" select="'false'" />

		<xsl:value-of select="$stringsDoc//value[@key='deviceList:']" />&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceListDesc']" />&#160;
			<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
			<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceListNote']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div id="ebipaDeviceListContainer"></div>
		
	</xsl:template>

</xsl:stylesheet>

 
