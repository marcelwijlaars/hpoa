<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="errorString" />
	
	<xsl:template match="*">
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td valign="top">
					<img border="0" src="/120814-042457/images/status_informational_32.gif"/>
				</td>
				<td style="padding-left:10px;" valign="top">
					<div style="width:500px;">
						<b>
							<xsl:value-of select="$stringsDoc//value[@key='contentNotFoundDesc']"/>
						</b>
						
						<ul>
							<li>
								<xsl:value-of select="$errorString"/>
							</li>
							<li>
								<xsl:value-of select="$stringsDoc//value[@key='manualLocate']"/>&#160;<a href="rackOverview.html">
									<xsl:value-of select="$stringsDoc//value[@key='rackOverview']"/>
								</a>.
							</li>
						</ul>
						
					</div>
				</td>
			</tr>

		</table>

	</xsl:template>
	
</xsl:stylesheet>

