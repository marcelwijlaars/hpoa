<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!-- 		
      © Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
      
      One Voice Progress Bar Tray Template      
        @created : 11-03-2005      
        @author: michael.slama@hp.com | michael.slama@ptk.org 
  -->

  <xsl:output method="html" />
  
  <!-- this is the localized title of the progress tray -->
	<xsl:param name="title">Progress</xsl:param>
  <!-- initialize the bar to 0 percent complete -->
	<xsl:param name="percentComplete">0</xsl:param>
	<!-- this is the localized name of a process, such as "File Upload" -->
	<xsl:param name="processName">Percent Complete</xsl:param>
	<!-- this is the localized version of the word "complete" -->
	<xsl:param name="complete">complete</xsl:param>
	<!-- optional; add an id to the bar for later reference -->
	<xsl:param name="barId"><xsl:value-of select="generate-id()" /></xsl:param>	
    
  <xsl:template name="progressBarTray" match="*">
  
    <xsl:variable name="completed">
      <xsl:choose>
        <xsl:when test="number($percentComplete)">
          <xsl:value-of select="concat($percentComplete,'%')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(0,'%')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="remaining">
      <xsl:choose>
        <xsl:when test="number($percentComplete)">
          <xsl:value-of select="concat(100 - $percentComplete,'%')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(100,'%')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- this widget has style definitions in "widgets.css" -->
    <table border="0" cellpadding="0" width="100%">
      <tr>
        <td>
          <div class="progressWrapperOn" id="{$barId}">
            <h3 class="subTitle">
              <xsl:value-of select="$title" />
            </h3>
            <div class="subTitleBottomEdge" />
            <div style="background-color:#cccccc;">
              <br />
              <div class="progressProcess">
                <xsl:value-of select="$processName" />
              </div>
              <div style="padding:10px;">
                <div class="progressOutline">
                  <div class="progressMade" style="width:{$completed};"></div>
                  <div class="progressLeft" style="width:{$remaining};"></div>
                </div>
              </div>
              <div class="progressPercentage">
                <span id="lblPercent">
                  <xsl:value-of select="$completed" />
                </span>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$complete" />
              </div>
              <br />
            </div>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>

