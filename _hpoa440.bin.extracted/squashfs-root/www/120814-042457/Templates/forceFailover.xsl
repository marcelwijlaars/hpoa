<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="mode" />
	
	<xsl:template match="*">

		<b><xsl:value-of select="$stringsDoc//value[@key='oaActiveStandbyTransition']" /></b><br />

		<span class="whiteSpacer">&#160;</span>
		<br />
		<xsl:value-of select="$stringsDoc//value[@key='useButtonToTransitionRedundancy']" />
		<xsl:if test="$mode='active'">
			&#160;<xsl:value-of select="$stringsDoc//value[@key='activeOaWillResetImmediately']" />
		</xsl:if>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
    
    <div class="errorDisplay" id="errorDisplay"></div>
		
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
											<button type="button" class="hpButton" onclick="forceFailover();" id="failoverButton">
												<xsl:choose>
													<xsl:when test="$mode='active'">														
                            <xsl:value-of select="$stringsDoc//value[@key='transitionActiveToStandby']" />
													</xsl:when>
													<xsl:otherwise>														
                            <xsl:value-of select="$stringsDoc//value[@key='transitionStandbyToActive']" />
													</xsl:otherwise>
												</xsl:choose>
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
		
	</xsl:template>
	
</xsl:stylesheet>

