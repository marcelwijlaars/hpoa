<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
				
  <xsl:output method="html" />
  
  <!-- ignores -->
  <xsl:template match="category/keywords" />
  <xsl:template match="topic/keywords" />
  
  <xsl:param name="procedure-id"><xsl:value-of select="0" /></xsl:param>

  <xsl:template match="help-contents">
    <div class="treeWrapper" style="width:100%;height:100%;" id="treeHelpContents">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <xsl:template match="category[@src]">
    <xsl:choose>
    <xsl:when test="@procedure-id = $procedure-id">
      <div class="treeOpen" style="width:100%;">
        <div class="treeControl"><div class="treeDisclosure"></div></div>
        <div class="treeTitle" style="width:100%;font-weight:bold;" id="{@id}"><a href="{@src}" target="iframeContent" class="treeSelectableLink"><xsl:value-of select="@title" /></a>      
      </div><div class="treeContents"><xsl:apply-templates /></div></div>
    </xsl:when>
    <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="category[not(@src)]">
    <xsl:choose>
    <xsl:when test="@procedure-id = $procedure-id">
      <div class="treeOpen" style="width:100%;">
        <div class="treeControl"><div class="treeDisclosure"></div></div>
        <div class="treeTitle" style="width:100%;font-weight:bold;"><xsl:value-of select="@title" />
      </div><div class="treeContents"><xsl:apply-templates /></div></div>
     </xsl:when>
     <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
     </xsl:choose>
  </xsl:template>
  
  <xsl:template match="topic[@procedure-id]">
    <xsl:if test="@procedure-id = $procedure-id">	
		<div class="leafWrapper">
			<div class="leaf" id="{@id}">
				<a href="{@src}" target="iframeContent" class="treeSelectableLink">
					<img border="0" height="14" width="11" alt="" src="/120814-042457/Help/images/procedure.gif" />
					<span style="vertical-align:top;padding-left:4px;"><xsl:value-of select="@title" /></span>
				</a>
			</div>
		</div>
		</xsl:if>
    <xsl:apply-templates select="category" />
  </xsl:template>
  
</xsl:stylesheet>