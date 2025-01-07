<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
          xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<!--
		Variables indicating the connection and authentication state
		of each of the enclosures on the link.
	-->
	<xsl:param name="stringsDoc" />
	<xsl:param name="fwVersion" />

	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Templates/globalTemplates.xsl"/>

	<xsl:template match="*">

		<table class="dataTable" align="center" border="0" cellpadding="0" cellspacing="0" style="width:300px;">
			<tr class="captionRow">
				<th style="background-color:#716B66;border:0px;" nowrap="true">
					<xsl:value-of select="$stringsDoc//value[@key='standby']"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='onboardAdministrator']"/>
				</th>
				<th style="background-color:#716B66;border:0px;width:33%;">&#160;</th>
				<th style="background-color:#716B66;border:0px;width:33%;">&#160;</th>
			</tr>
			<tr>
				<th class="propertyName" style="width:165px;">
					<xsl:value-of select="$stringsDoc//value[@key='firmwareVersion']"/>
				</th>
				<td class="propertyValue" colspan="2">
					<xsl:value-of select="$fwVersion"/>
				</td>
			</tr>

		</table>

	</xsl:template>
</xsl:stylesheet>

