<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  
  <xsl:param name="stringsDoc" />
  <xsl:param name="allowFirmwareMismatch">false</xsl:param>
  <xsl:param name="traditionalWizard">false</xsl:param>
	
	<xsl:template name="Setup_EncSelect" match="*">
		
		<div id="stepInnerContent">
			<!-- Current step description text -->
			<div class="wizardTextContainer">
				
				<xsl:value-of select="$stringsDoc//value[@key='encSelectPara1']"/><br />
				<span class="whiteSpacer">&#160;</span><br />

        <!-- Only include if Wizard not applies settings on every step -->
        <xsl:if test="$traditionalWizard = 'false'">
          <xsl:value-of select="$stringsDoc//value[@key='encSelectPara2a']"/>				
          <b><xsl:value-of select="$stringsDoc//value[@key='ALL']"/></b>
				  <xsl:value-of select="$stringsDoc//value[@key='encSelectPara2b']"/> 
          <b><xsl:value-of select="$stringsDoc//value[@key='next']"/></b>
          <xsl:value-of select="$stringsDoc//value[@key='encSelectPara2c']"/><br />
				  <span class="whiteSpacer">&#160;</span><br />
				</xsl:if>
				
        <xsl:value-of select="$stringsDoc//value[@key='encSelectPara3']"/><br />
				<span class="whiteSpacer">&#160;</span><br />
				
        <xsl:value-of select="$stringsDoc//value[@key='encSelectPara4']"/><br />
				<span class="whiteSpacer">&#160;</span><br />

        <xsl:if test="$allowFirmwareMismatch != 'true'">
          <b><xsl:value-of select="$stringsDoc//value[@key='note:']" /></b>&#160;
          <xsl:value-of select="$stringsDoc//value[@key='encSelectPara5']"/><br />
				  <span class="whiteSpacer">&#160;</span><br />
				</xsl:if>
			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />

			<div class="errorDisplay" id="errorDisplay"></div>

			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<div id="encSelectContainer"></div>
					</td>
				</tr>
			</table>
			
		</div>
		<div id="waitContainer"></div>
		
	</xsl:template>
	
</xsl:stylesheet>