<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/DirectorySettings.xsl" />

	<xsl:param name="stringsDoc" />
	<xsl:param name="ldapInfoDoc" />
	<xsl:param name="encNum" />
	<xsl:param name="isWizard" select="'false'" />
	
	<xsl:template match="*">
		
		<div id="errorDisplay" class="errorDisplay"></div>
		<xsl:call-template name="directorySettings" />
		
		<span class="whiteSpacer">&#160;</span><br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' onclick="setLdapSettings();">
								<xsl:value-of select="$stringsDoc//value[@key='apply']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

