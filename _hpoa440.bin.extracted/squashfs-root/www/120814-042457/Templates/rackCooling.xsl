<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="stringsDoc" />
	<xsl:param name="rackBtuCurrent" />
	<xsl:param name="rackBtuMax" />
	
	<xsl:template match="*">

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='rackCoolingReq']" />
			</caption>
			<tbody>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='currentBTU']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="$rackBtuCurrent"/>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='maxBTU']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="$rackBtuMax"/>
					</td>
				</tr>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		
	</xsl:template>
	
</xsl:stylesheet>