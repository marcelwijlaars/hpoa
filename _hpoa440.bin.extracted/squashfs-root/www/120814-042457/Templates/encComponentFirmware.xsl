<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<!-- Document fragment parameters containing blade status and information -->
	<xsl:param name="stringsDoc" />
	<xsl:param name="encComponentFirmware" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:template match="*">
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="treeTable">
			<caption style="background-color:transparent;color:black;font-weight:normal;padding-bottom:5px;">
				<xsl:value-of select="$stringsDoc//value[@key='encComponentFWInfo']" />
			</caption>

			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='bay']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='deviceModel']" />
					</th>
					<th><xsl:value-of select="$stringsDoc//value[@key='currentFWVersion']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='availableFWVersion']" /></th>
				</tr>
			</thead>
			<tbody>

				<xsl:for-each select="$encComponentFirmware//hpoa:hpqUpdateDeviceResponse/hpoa:show/hpoa:showEntry">
					<xsl:element name="tr">
						<xsl:if test="position() mod 2 != 0">
							<xsl:attribute name="class">altRowColor</xsl:attribute>
						</xsl:if>
						<td>
							<xsl:value-of select="hpoa:bayNumber"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:deviceDescription"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:currentVersion"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:availableVersion"/>
						</td>
					</xsl:element>
				</xsl:for-each>

			</tbody>
		</table>
	</xsl:template>

</xsl:stylesheet>
