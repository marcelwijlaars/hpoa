<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
			xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
				
  <xsl:output method="html" />
  
  <!-- ignores -->
  <xsl:template match="category/keywords" />
  
  <xsl:param name="searchString" />
  
  <!-- convert the searchString parameter to lower case for case-insensitive searches -->
	<xsl:variable name="lowSearchString">
		<xsl:call-template name="to-lower-case">
			<xsl:with-param name="param1" select="$searchString" />
		</xsl:call-template>		
	</xsl:variable>
		
	<xsl:template match="*">		
		<div class="navigationControlSet" style="padding:2px 0px 2px 2px;width:99.5%;height:100%;">
			<xsl:apply-templates />
		</div>
	</xsl:template>
	
	  <xsl:template match="category">
		<!-- convert compare words to lower case -->	
		<xsl:if test="@src">
			<xsl:variable name="lowKeywords">
				<xsl:call-template name="to-lower-case">
					<xsl:with-param name="param1" select="keywords" />
				</xsl:call-template>		
			</xsl:variable>
		
			<xsl:variable name="lowTitle">
				<xsl:call-template name="to-lower-case">
					<xsl:with-param name="param1" select="@title" />
				</xsl:call-template>		
			</xsl:variable>
		
			<!-- a param could be added to this template for "Match Case" type searches -->
			<xsl:if test="contains($lowKeywords,$lowSearchString) or contains($lowTitle,$lowSearchString)">
				<xsl:variable name="class">
					<xsl:choose>
						<xsl:when test="../@selected and position() = 1">navigationControlOn</xsl:when>
						<xsl:otherwise>navigationControlOff</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<div class="{$class}" style="padding-right:0px;">		
					<a href="{@src}" class="treeSelectableLink">
						<xsl:value-of select="@title" />
					</a>
				</div>
			</xsl:if>
		</xsl:if>	
    <xsl:apply-templates />   
  </xsl:template>  
  
  <xsl:template match="topic">
		<!-- convert compare words to lower case -->
		<xsl:variable name="lowKeywords">
			<xsl:call-template name="to-lower-case">
				<xsl:with-param name="param1" select="keywords" />
			</xsl:call-template>		
		</xsl:variable>	
		
		<xsl:variable name="lowTitle">
			<xsl:call-template name="to-lower-case">
				<xsl:with-param name="param1" select="@title" />
			</xsl:call-template>		
		</xsl:variable>
		
		<!-- a param could be added to this template for "Match Case" type searches -->
		<xsl:if test="contains($lowKeywords,$lowSearchString) or contains($lowTitle,$lowSearchString)">
			<xsl:variable name="class">
				<xsl:choose>
					<xsl:when test="../@selected and position() = 1">navigationControlOn</xsl:when>
					<xsl:otherwise>navigationControlOff</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="{$class}" style="paddding-right:0px;">		
				<a href="{@src}" target="iframeContent" class="treeSelectableLink">
					<xsl:value-of select="@title" />
				</a>
			</div>
    </xsl:if>
    <xsl:apply-templates select="category" />    
  </xsl:template> 
  
  <!-- method for converting strings to lowercase -->
	<xsl:template name="to-lower-case">
		<xsl:param name="param1"/>
		<xsl:variable name="ucase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		<xsl:variable name="lcase" select="'abcdefghijklmnopqrstuvwxyz'" />		
		<xsl:value-of select="translate($param1,$ucase,$lcase)"/>
	</xsl:template>

</xsl:stylesheet>