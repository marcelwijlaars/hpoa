<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
			xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
				
  <xsl:output method="html" />

	<xsl:template match="help-index">
		<xsl:apply-templates select="quick-links" />
		<div class="navigationControlSet" style="padding:2px 0px 2px 2px;width:99.5%;height:100%;">
			<xsl:apply-templates select="indexes" />
		</div>
	</xsl:template>
	
	<xsl:template match="quick-links">
		<table cellpadding="0" border="0">
		  <tr>
		   <td class="quickLinkRow" nowrap="true">
		     <xsl:apply-templates />
		   </td>
		  </tr>
		</table>
	</xsl:template>
	
	<xsl:template match="indexes">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="quick-link">
		<xsl:choose>
			<xsl:when test="@hash">
				<xsl:element name="a">
					<xsl:attribute name="href"><xsl:value-of select="@hash" /></xsl:attribute>
					<xsl:attribute name="style">font-weight:bold;text-decoration:underline;</xsl:attribute>
					<xsl:attribute name="target">_self</xsl:attribute>
					<xsl:value-of select="." />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>		
		</xsl:choose>
		<xsl:text> </xsl:text>
	</xsl:template>	
	
	<xsl:template match="index">
		<div class="navigationControlHeader" style="padding-right:0px;">
			<xsl:element name="a">
				<xsl:attribute name="name"><xsl:value-of select="@hash" /></xsl:attribute>
				<xsl:attribute name="style">font-weight:bold;font-size:115%;</xsl:attribute>
				<xsl:value-of select="@letter" />
			</xsl:element>
			<xsl:apply-templates />
		</div>		
  </xsl:template>	
  
  <xsl:template match="group">
		<div class="navigationControlOff" style="padding-right:0px;"><xsl:value-of select="@title" />
		  <xsl:apply-templates select="entry" mode="groupEntry" />
		</div>
  </xsl:template>
	
	<xsl:template match="entry">
		<div class="navigationControlOff" style="padding-right:0px;">
			<xsl:element name="a">
				<xsl:attribute name="id"><xsl:value-of select="@topic-id" /></xsl:attribute>
				<xsl:attribute name="href"><xsl:value-of select="@src" /></xsl:attribute>
				<xsl:value-of select="." />
			</xsl:element>
		</div>
	</xsl:template>
  
  <xsl:template match="entry" mode="groupEntry">
		<div class="navigationControlOff" style="margin-left:10px;padding-right:0px;">
			<xsl:element name="a">        
				<xsl:attribute name="id"><xsl:value-of select="@topic-id" /></xsl:attribute>
				<xsl:attribute name="href"><xsl:value-of select="@src" /></xsl:attribute>
				<xsl:value-of select="." />
			</xsl:element>
		</div>
	</xsl:template>
  
</xsl:stylesheet>