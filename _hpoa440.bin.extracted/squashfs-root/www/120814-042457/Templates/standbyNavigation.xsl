<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="serviceUserOaAccess" />

	<xsl:template match="*">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td valign="top" style="width:180px;">
					
					<div style="width:180px;border:7px solid #ccc;">
						<div style="padding:2px;">

							<div class="navigationControlSet">
								<div class="navigationControlOn" id="navStatus"><a onclick="loadStandbyContent('oaContent.html');" href="javascript:void(0);"><xsl:value-of select="$stringsDoc//value[@key='statusInformation']"/></a></div>
								<div class="navigationControlOff" id="navNetworkSettings"><a onclick="loadStandbyContent('standbyNetSettings.html');" href="javascript:void(0);"><xsl:value-of select="$stringsDoc//value[@key='ipSettings']"/></a></div>
								
								<xsl:if test="$serviceUserOaAccess='true'">
									<div class="navigationControlOff" id="navSyslog"><a onclick="loadStandbyContent('oaSystemLog.html');" href="javascript:void(0);"><xsl:value-of select="$stringsDoc//value[@key='systemLog']"/></a></div>
								</xsl:if>

								<xsl:if test="$serviceUserAcl='ADMINISTRATOR' and $serviceUserOaAccess='true'">
									<div class="navigationControlOff" id="navFailover"><a onclick="loadStandbyContent('forceFailover.html?mode=standby');" href="javascript:void(0);"><xsl:value-of select="$stringsDoc//value[@key='standbyToActive']"/></a></div>
								</xsl:if>
								
							</div>
						</div>
					</div>
				</td>
				<td valign="top" style="text-align:left;border:0px;">
					<iframe src="blank.html" scrolling="auto" name="STANDBY_INNER_CONTENT" id="STANDBY_INNER_CONTENT" width="100%" height="100%" frameborder="0"></iframe>
				</td>
			</tr>
			
		</table>
	</xsl:template>
	
</xsl:stylesheet>