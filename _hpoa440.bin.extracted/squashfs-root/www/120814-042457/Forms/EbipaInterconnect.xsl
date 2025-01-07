<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Forms/Ebipa.xsl" />

	<xsl:include href="../Templates/guiConstants.xsl"/>
	
    <xsl:param name="ebipaInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="serviceUserAcl" />
	
	<xsl:template match="*">
		
		<xsl:value-of select="$stringsDoc//value[@key='ebipaIntrConnectBayRange']" />&#160;
		<em>
			<xsl:value-of select="$stringsDoc//value[@key='ebipaIntrConnectBayRangeDesc']" />
		</em>
		<br />
		<span class="whiteSpacer">&#160;</span><br />

		<em>
			<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
			<xsl:value-of select="$stringsDoc//value[@key='ebipaIntrConnectBayRangeDescNote']" />
		</em><br />

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />
    
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td>
					
					<div id="interconnectErrorDisplay" class="errorDisplay"></div>
					<xsl:call-template name="ebipaInterconnect" />

					<span class="whiteSpacer">&#160;</span>
					<br />

					<xsl:if test="$serviceUserAcl != $USER">
						<div align="right">
							<div class='buttonSet' style="margin-bottom:0px;">
								<div class='bWrapperUp'>
									<div>
										<div>
											<button type='button' class='hpButton' onclick="setupEbipa('INTERCONNECT_TRAY_BAY');">
												<xsl:value-of select="$stringsDoc//value[@key='apply']" />
											</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</xsl:if>
					
				</td>
				<td>
					<img src="/120814-042457/images/one_white.gif" width="10" />
				</td>
			</tr>
		</table>
		
	</xsl:template>


</xsl:stylesheet>

