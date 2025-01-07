<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">
	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<!--
		Utility template for Enclosure Status and Information
	
		The getEnclosureInfoValue template takes a key, and returns the value of the key from the
		XML Information Document parameter (defined at the top of baySummary.xsl).
		TODO: Add error checking to make sure document exists.
	-->
	<xsl:template name="getEnclosureInfoValue">
		
		<xsl:param name="key" />
		
		<xsl:for-each select="$enclosureInfoDoc/struct/member">
			<xsl:if test="name=$key">
				<xsl:value-of select="normalize-space(string(value))" />
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<!--
		The getEnclosureInfoValue template takes a key, and returns the value of the key from the
		XML Information Document parameter (defined at the top of baySummary.xsl).
		TODO: Add error checking to make sure document exists.
	-->
  
	<xsl:template name="getEnclosureStatusValue">
		
		<xsl:param name="key" />
		
		<xsl:for-each select="$enclosureStatusDoc/struct/member">
			<xsl:if test="name=$key">
				<xsl:value-of select="normalize-space(string(value))" />
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
  

</xsl:stylesheet>