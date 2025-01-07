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
	<xsl:param name="side" />

	<xsl:template match="*">
		
		<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceBayRange']" /><em>&#160;
			<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceBayRangeDesc']" />
		</em>

		<br />
		<span class="whiteSpacer">&#160;</span><br />

		<em>
			<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
			<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceBayRangeDescNote']" />
		</em>
		<br />

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td>
					<div id="serverErrorDisplay" class="errorDisplay"></div>
					<xsl:call-template name="ebipaServer" />

					<span class="whiteSpacer">&#160;</span>
					<br />

					<xsl:choose>
						<xsl:when test="$serviceUserAcl != $USER">
							<div align="right">
								<div class='buttonSet' style="margin-bottom:0px;">
									<div class='bWrapperUp'>
										<div>
											<div>
												<button type='button' class='hpButton' onclick="setupEbipa('SERVER_BLADE_BAY',{$side});">
													<xsl:value-of select="$stringsDoc//value[@key='apply']" />
												</button>
											</div>
										</div>
									</div>
									
								</div>
							</div>
							<span class="whiteSpacer">&#160;</span>
							<br />
						</xsl:when>
						<xsl:otherwise>
							<span class="whiteSpacer">&#160;</span>
							<br />
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<img src="/120814-042457/images/one_white.gif" width="10" />
				</td>
			</tr>
		</table>
		
	</xsl:template>


</xsl:stylesheet>

