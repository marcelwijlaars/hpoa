<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
	
	<xsl:output method="html" />
	
	<xsl:template match="/">
		<xsl:element name="select">
			<xsl:attribute name="style">width:200;</xsl:attribute>
			<xsl:attribute name="onchange">javascript:updateTextbox(this.options[this.selectedIndex].value);</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>			
				
	<xsl:template match="context">
		<xsl:element name="option">
			<xsl:if test="position() = 1">
				<xsl:attribute name="selected">true</xsl:attribute>
			</xsl:if>
      <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
			<xsl:value-of select="@key" />
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
