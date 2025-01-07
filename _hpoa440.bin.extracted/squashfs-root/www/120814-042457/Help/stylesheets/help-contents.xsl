<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/02/xpath-functions">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  
  <xsl:output method="html" />

  <!-- ignores -->
  <xsl:template match="category/keywords" />


  <xsl:template match="help-contents">
    <div class="treeWrapper" style="width:100%;height:100%;padding-right:0px;" id="treeHelpContents">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="category[@src]">
    <div class="treeClosed" style="width:100%;">
      <div class="treeControl">
        <div class="treeDisclosure"></div>
      </div>
      <xsl:choose>
        <xsl:when test="contains(@src,'#')">
          <div class="treeTitle" style="width:100%;font-weight:bold;" id="{@id}">
            <a href="{@src}" target="iframeContent" onclick="top.getHelpManager().loadTopic('{@src}','{@title}','{@id}');" class="treeSelectableLink">
              <xsl:value-of select="@title" />
            </a>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="treeTitle" style="width:100%;font-weight:bold;" id="{@id}">
            <a href="{@src}" target="iframeContent" class="treeSelectableLink">
              <xsl:value-of select="@title" />
            </a>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    
      <div class="treeContents">
        <xsl:apply-templates />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="category[not(@src)]">
    <xsl:choose>
      <xsl:when test="@id = 'HIDDEN'">
        <div style="display:none">
          <xsl:apply-templates />
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="treeClosed" style="width:100%;">
          <div class="treeControl">
            <div class="treeDisclosure"></div>
          </div>
          <div class="treeTitle" style="width:100%;font-weight:bold;">
            <xsl:value-of select="@title" />
          </div>
          <div class="treeContents">
            <xsl:apply-templates />
          </div>
        </div>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="topic">
    <xsl:variable name="imagePath">
      <xsl:choose>
        <xsl:when test="@procedure-id">/120814-042457/Help/images/procedure.gif</xsl:when>
        <xsl:when test="@reference-id">/120814-042457/Help/images/topic.gif</xsl:when>
        <xsl:otherwise>/120814-042457/Help/images/reference.gif</xsl:otherwise>
        <!-- original default icon was 'topic.gif' -->
      </xsl:choose>
    </xsl:variable>
    <div class="leafWrapper">      
        <xsl:choose>
          <xsl:when test="contains(@src,'#')">
            <div class="leaf" id="{@id}">
              <a href="{@src}" target="iframeContent" onclick="top.getHelpManager().loadTopic('{@src}','{@title}','{@id}');" class="treeSelectableLink">              
              <img border="0" height="14" width="11" alt="" src="{$imagePath}" />
                <span style="vertical-align:top;padding-left:4px;">
                  <xsl:value-of select="@title" />
                </span>
              </a>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="leaf" id="{@id}">
            <a href="{@src}" target="iframeContent" class="treeSelectableLink">
              <img border="0" height="14" width="11" alt="" src="{$imagePath}" />
              <span style="vertical-align:top;padding-left:4px;">
                <xsl:value-of select="@title" />
              </span>
            </a>
              </div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    <xsl:apply-templates select="category" />
  </xsl:template>

</xsl:stylesheet>