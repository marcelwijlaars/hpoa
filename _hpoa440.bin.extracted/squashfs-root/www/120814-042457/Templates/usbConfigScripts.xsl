<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

<!--
      (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
-->

<xsl:param name="usbconfigscripts" />


<xsl:template match="*">
		<form id="usbform">
		Select a config file present on Enclosure USB Key to be uploaded to Onboard Administrator
		<span class="whiteSpacer">&#160;</span><br />

		
		Config Scripts
		<span class="whiteSpacer">&#160;</span>
		<xsl:element name="select">
				<xsl:attribute name="id">ddlist</xsl:attribute>
			
				<xsl:attribute name="onchange">JavaScript:window.clapp()</xsl:attribute>
						<xsl:element name="option">Select</xsl:element>
						<xsl:for-each select="$usbconfigscripts//hpoa:configScripts/hpoa:scripts">
									  <xsl:element name="option">
												
											  <xsl:value-of select="current()"/>	  
									  </xsl:element>		  
						</xsl:for-each>
		</xsl:element>
		</form>		
		
</xsl:template>
</xsl:stylesheet>

																			
