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
    <xsl:include href="../Templates/uid.xsl" />

	<xsl:param name="stringsDoc" />
    <xsl:param name="oaStatusDoc" />

	<xsl:param name="serviceUserAcl" />
	<xsl:param name="serviceUserOaAccess" />
    
	<xsl:template match="*">

        <xsl:variable name="uidState" select="$oaStatusDoc//hpoa:uid" />
        
		<xsl:if test="$serviceUserAcl != $USER and $serviceUserOaAccess">
			<xsl:value-of select="$stringsDoc//value[@key='virtualPower:']" />&#160;<em>
				<xsl:value-of select="$stringsDoc//value[@key='virtualPowerDes']" />
			</em><br />
			<span class="whiteSpacer">&#160;</span><br />

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
												<button type="button" class="hpButton" onclick="restartEM();" id="restartEMButton">
													<xsl:value-of select="$stringsDoc//value[@key='reset']" />
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

			<span class="whiteSpacer">&#160;</span><br />
			<span class="whiteSpacer">&#160;</span><br />
		</xsl:if>
		
		<xsl:value-of select="$stringsDoc//value[@key='virtualIndicator']" /><br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<div class="groupingBox">
            
            <xsl:call-template name="uid">
                <xsl:with-param name="uidState" select="$uidState" />
            </xsl:call-template>
            
		</div>
		<br />
	</xsl:template>
	

</xsl:stylesheet>

