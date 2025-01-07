<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl" />

	<xsl:param name="wizardComplete" />
  <xsl:param name="stringsDoc" />
    
	<xsl:template match="*">
		
		<div class="wizardTextContainer">
      <xsl:value-of select="$stringsDoc//value[@key='welcomePara1']" /><br />
			
			<span class="whiteSpacer">&#160;</span><br />
			<xsl:value-of select="$stringsDoc//value[@key='welcomePara2a']" />
      <b><xsl:value-of select="$stringsDoc//value[@key='skip']" /></b>
      <xsl:value-of select="$stringsDoc//value[@key='welcomePara2b']" />
      <b><xsl:value-of select="$stringsDoc//value[@key='next']" /></b>
      <xsl:value-of select="$stringsDoc//value[@key='welcomePara2c']" /><br />
			
			<br />&#160;
			<br />&#160;
			<br />&#160;

			<xsl:element name="input">

				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="style">margin-right:5px;</xsl:attribute>
				<xsl:attribute name="id">doNotShow</xsl:attribute>
				<xsl:if test="$wizardComplete!=$WIZARD_NOT_COMPLETED">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
				
			</xsl:element><label for="doNotShow"><xsl:value-of select="$stringsDoc//value[@key='doNotShowWizard']" /></label>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

