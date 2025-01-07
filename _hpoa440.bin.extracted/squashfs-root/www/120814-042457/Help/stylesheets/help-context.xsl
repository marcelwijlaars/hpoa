<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
	
	<!-- simple text output -->
	<xsl:output  method="text"  />
	
	<!-- ignores -->
	<xsl:template match="topic/keywords" />
	<xsl:template match="category/keywords" /> 
	
	<!-- not interested in non-printable chars -->
	<xsl:strip-space elements="help-contents category topic" />
	
	<!-- params: the id of the desired topic -->
	<xsl:param name="topicId" />

	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>			

	<!--	
	
		Purpose	: select the "@src" attribute of the topic that matches the 
							"$topicId" parameter. 
		Notes		: the "@id" should be unique within the TOC so there shouldn't 
							be any duplicate matches found.	
	-->
				
	<xsl:template match="category[@id]">
		<xsl:choose>
			<xsl:when test="@id=$topicId"><xsl:value-of select="@src" /></xsl:when>
			<xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template match="topic[@id]">
		<xsl:choose>
			<xsl:when test="@id=$topicId"><xsl:value-of select="@src" /></xsl:when>
			<xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
