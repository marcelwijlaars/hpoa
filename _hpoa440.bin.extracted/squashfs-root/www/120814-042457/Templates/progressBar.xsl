<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!-- 		
      © Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
      
      One Voice Progress Bar Template      
        @created : 11-03-2005      
        @author: michael.slama@hp.com
  -->

  <xsl:output method="html" />
  <!-- table attributes -->
  <xsl:param name="align">center</xsl:param>
  <xsl:param name="width">100%</xsl:param>
  <xsl:param name="style"></xsl:param>
  <!-- initialize the bar to 0 percent complete -->
	<xsl:param name="percentComplete">0</xsl:param>
	<!-- this is the localized name of a process, such as "File Upload" -->
	<xsl:param name="processName">Percent Complete</xsl:param>
	<!-- this is the localized version of the word "complete" -->
	<xsl:param name="complete">complete</xsl:param>
	<!-- optional; add an id to the bar for later reference -->
	<xsl:param name="barId"><xsl:value-of select="generate-id()" /></xsl:param>
  <!--  Bar types are 'default' or 'small'  -->
  <xsl:param name="barType" select="'default'" />

  <xsl:template match="*">
     <xsl:variable name="completed">
      <xsl:choose>
        <xsl:when test="number($percentComplete)">
          <xsl:value-of select="concat($percentComplete,'%')" />
        </xsl:when>
        <xsl:otherwise>
			<xsl:value-of select="concat(0, '%')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="remaining">
      <xsl:choose>
        <xsl:when test="number($percentComplete)">
          <xsl:value-of select="concat(100 - $percentComplete,'%')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(100, '%')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$barType='small'">
        <xsl:call-template name="progressBarSmall">
          <xsl:with-param name="completed" select="$completed" />
          <xsl:with-param name="remaining" select="$remaining" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="progressBar">          
          <xsl:with-param name="completed" select="$completed" />
          <xsl:with-param name="remaining" select="$remaining" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- default Bar -->
  <xsl:template name="progressBar">
    <xsl:param name="completed" />
    <xsl:param name="remaining" />

    <!-- this widget has style definitions in "widgets.css" -->
    <table id="progressContainer" width="{$width}" align="{$align}" style="{$style}" border="0" padding="0">
      <tr>
        <td style="width:100%;">
          <div class="progressWrapperOn" id="{$barId}">
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
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- small bar -->
  <xsl:template name="progressBarSmall">
    <xsl:param name="completed" />
    <xsl:param name="remaining" />
    <xsl:param name="myId" select="$barId" />
    
    <div class="progressWrapperOn" id="{$myId}">
      <table id="progressContainer" width="{$width}" align="{$align}" style="{$style}" border="0" padding="0">
        <tr>
          <td style="width:1%;border:0px;padding:0px;">            
            <div class="progressPercentage" style="padding:0px;">
              <span id="lblPercent" style="width:30px;padding-left:2px;display:block;">
                <xsl:value-of select="$completed" />
              </span>
            </div>
          </td>
          <td style="width:100%;border:0px;">
            <div class="progressOutline">
              <div class="progressMade" style="width:{$completed};"></div>
              <div class="progressLeft" style="width:{$remaining};"></div>
            </div>
          </td>
        </tr>
      </table> 
    </div>
  </xsl:template>
  
</xsl:stylesheet>

