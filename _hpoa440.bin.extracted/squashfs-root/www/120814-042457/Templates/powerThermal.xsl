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
	<xsl:include href="../Templates/powerThermalEnc.xsl" />
	
	<xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="powerConfigInfoDoc" />
	<xsl:param name="thermalSubsystemInfoDoc" />
	<xsl:param name="enclosureThermalsDoc" />
	<xsl:param name="powerCapConfigDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureType" select="string('0')" />
	<xsl:template match="*">
		
		<xsl:call-template name="powerThermalEnclosure" />

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnRefresh" onclick="refreshPtInfo();">
								<xsl:value-of select="$stringsDoc//value[@key='refresh']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>