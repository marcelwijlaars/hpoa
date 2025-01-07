<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
    <xsl:include href="../Forms/NetworkAccess.xsl" />
	
	<xsl:include href="../Templates/guiConstants.xsl"/>

    <xsl:param name="networkInfoDoc" />
    <xsl:param name="stringsDoc" />

	<xsl:param name="serviceUserAcl" />
	
	<xsl:template match="*">
    
		<b>
            <xsl:value-of select="$stringsDoc//value[@key='networkAccess']" />
        </b><br />
		<span class="whiteSpacer">&#160;</span><br />

        <xsl:value-of select="$stringsDoc//value[@key='protocolRestrictions:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='prDescription']" /></em>
        <br />
		<span class="whiteSpacer">&#160;</span><br />
  	
		<div class="groupingBox">
			<div id="protocolErrorDisplay" class="errorDisplay"></div>
			<xsl:call-template name="networkAccessProtocols" />
		</div>

		<span class="whiteSpacer">&#160;</span><br />

		<xsl:choose>
			<xsl:when test="$serviceUserAcl != $USER">
				<div align="right">
					<div class='buttonSet' style="margin-bottom:0px;">
						<div class='bWrapperUp'>
							<div>
								<div>
									<button type='button' class='hpButton' id="btnSetProtocols" onclick="setNetworkProtocols();">
										<xsl:value-of select="$stringsDoc//value[@key='apply']" />
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<span class="whiteSpacer">&#160;</span>
				<br />
			</xsl:otherwise>
		</xsl:choose>

		<span class="whiteSpacer">&#160;</span><br />
		
        <xsl:value-of select="$stringsDoc//value[@key='ipSec:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='ipSecDescription']" /></em>
        <br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<div class="groupingBox">
			<div id="securityErrorDisplay" class="errorDisplay"></div>
			<xsl:call-template name="networkAccessSecurity" />
		</div>

		<xsl:if test="$serviceUserAcl != $USER">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnSetIPSec" onclick="setIpSecurity();">
									<xsl:value-of select="$stringsDoc//value[@key='apply']" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>

