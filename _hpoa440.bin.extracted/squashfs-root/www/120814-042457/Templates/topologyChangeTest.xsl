<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
          xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  
  <!-- text-only output -->
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  
  <!-- strip space from nodes that only contain child nodes -->
  <xsl:strip-space elements="hpoa:encLinkOaArray hpoa:encLinkOa"/>  
  
  <xsl:param name="topologyOld" />
  <xsl:param name="topologyNew" />
  
  <!--
    @purpose : Compare two topology documents for differences. 
    @notes   : Matching documents will return no data.
    @output  : text delimited by the caret (^) symbol.
  -->
  <xsl:template match="*">
    <xsl:variable name="totalOld" select="count($topologyOld//hpoa:enclosure)" />
    <xsl:variable name="totalNew" select="count($topologyNew//hpoa:enclosure)" />
    <xsl:variable name="maxOverOld" select="string($topologyOld//hpoa:extraData[@hpoa:name='maxConnectionsExceeded'])" />
    <xsl:variable name="maxOverNew" select="string($topologyNew//hpoa:extraData[@hpoa:name='maxConnectionsExceeded'])" />
    
    <xsl:variable name="comparable">
      <xsl:choose>
        <xsl:when test="$totalOld = $totalNew">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$maxOverOld = $maxOverNew">
        <xsl:if test="$comparable='false'">
          <!-- ignore validation if the new document has zero enclosures -->
          <xsl:if test="($totalNew > 0) and ($totalOld != $totalNew)">
            <xsl:value-of select="concat('Total | old:', $totalOld, ' new:', $totalNew, '^')"/>
          </xsl:if>
        </xsl:if>
        
        <xsl:if test="$comparable='true'">
          <xsl:for-each select="$topologyOld//hpoa:enclosure">        
            <xsl:variable name="encPosition" select="position()" />     
            
            <!-- compare the current enclosure from both documents -->
            <xsl:call-template name="nodesetCompare">          
              <xsl:with-param name="nodesetA" select ="." />
              <xsl:with-param name="nodesetB" select="$topologyNew//hpoa:enclosure[$encPosition]" />          
            </xsl:call-template>        
          </xsl:for-each>  
        </xsl:if> 
      </xsl:when>      
      <xsl:otherwise>
        <xsl:value-of select="concat('Link Exceeded | old:', $maxOverOld, ' new:', $maxOverNew, '^')"/>
      </xsl:otherwise>
    </xsl:choose> 
     
  </xsl:template>
  
  <!-- 
    @purpose  : compares two nodesets, including a recursive search of the childnodes. 
    @notes    : attribute names and values are output for non-matching nodes only.
  -->
  <xsl:template name="nodesetCompare">
    <xsl:param name="nodesetA" />
    <xsl:param name="nodesetB" />
    
    <!-- compare child nodes of each set -->
    <xsl:for-each select="$nodesetA/child::node()">  
      <xsl:variable name="nodePosition" select="position()" />
      <xsl:variable name="childA" select="." />
      <xsl:variable name="childB" select="$nodesetB/child::node()[$nodePosition]" />
      
      <!-- added test to fix lack of webkit strip-space support -->
      <xsl:if test="name($childA) != 'hpoa:encLinkOaArray' and name($childA) != 'hpoa:encLinkOa'">
        <!-- dev note: remove the bang (!) to view all nodes in the result -->
        <xsl:if test="$childA/text() != $childB/text()">
          <xsl:value-of select="concat(local-name(), ' | old:', $childA/text(), ' new:', $childB/text(), '^')"/>

          <!-- always output the attribs when the nodes don't match -->
          <xsl:for-each select="current()/@*">
            <xsl:variable name="attribName" select="name()" />
            <xsl:value-of select="concat('+--Attribute: @', $attribName, ' | old:', current(), ' new:', $childB/@*[name()=$attribName], '^')"/>
          </xsl:for-each>
        </xsl:if>
      </xsl:if>

      
      <!-- recurse through child nodes of each child node (if any) -->
      <xsl:if test="count($childA/child::node()) > 0 or count($childB/child::node()) > 0">
        <xsl:call-template name="nodesetCompare">
          <xsl:with-param name="nodesetA" select="$childA" />
          <xsl:with-param name="nodesetB" select="$childB" />
        </xsl:call-template>
      </xsl:if>  
    
    </xsl:for-each>    
  </xsl:template>
  
</xsl:stylesheet>