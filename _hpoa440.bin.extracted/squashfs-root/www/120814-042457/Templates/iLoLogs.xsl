<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../Templates/guiConstants.xsl"/>
  <xsl:include href="../Templates/globalTemplates.xsl"/>

  <xsl:param name="stringsDoc" />
  <xsl:param name="logDoc" />

	<!--SEVERITY CLASS LAST_UPDATE INITIAL_UPDATE COUNT DESCRIPTION -->

	<xsl:param name="sortOrder" select="''" />
	<xsl:param name="sortField" select="''" />
	<xsl:param name="filter" select="''" />

  <xsl:template match="*">

	  <table border="0" cellspacing="0" cellpadding="0" style="width:100%;">
		  <tr>
			  <td>
				  <h5>
					  <xsl:choose>
						  <xsl:when test="$filter=''">
							  <xsl:value-of select="$logDoc//EVENT_LOG/@DESCRIPTION"/>
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of select="concat($logDoc//EVENT_LOG/@DESCRIPTION, ' - ', $filter, ' ', $stringsDoc//value[@key='class'])"/>
						  </xsl:otherwise>
					  </xsl:choose>
				  </h5>
			  </td>
			  <td style="text-align:right;">
				  <xsl:if test="$filter != ''">
					  <a href="javascript:filterIml('');">
						  <xsl:value-of select="$stringsDoc//value[@key='viewAll']"/>
					  </a>
				  </xsl:if>
			  </td>
		  </tr>
	  </table>
	  
	  <table id="logTable" class="dataTable" border="0" cellspacing="0" cellpadding="0" style="width:100%;">
      <thead>
		    <tr valign="top" class="captionRow">
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'SEVERITY'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='severity']" />
          </xsl:call-template>	
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'CLASS'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='class']" />
          </xsl:call-template>	

          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'LAST_UPDATE'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='lastUpdate']" />
          </xsl:call-template>
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'INITIAL_UPDATE'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='initUpdate']" />
          </xsl:call-template>	

					<xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'COUNT'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='count']" />
          </xsl:call-template>
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'DESCRIPTION'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='description']" />
          </xsl:call-template>
						
					</tr>
        </thead>
          <tbody>
            
          <xsl:variable name="dataType">
            <xsl:choose>
              <xsl:when test="$sortField = 'COUNT'">number</xsl:when>
              <xsl:otherwise>text</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>        

				  <xsl:choose>
					  <xsl:when test="$sortOrder='ASC'">
              
						  <xsl:for-each select="$logDoc//EVENT_LOG/EVENT">

							  <xsl:sort select="@*[local-name()=$sortField]" order="ascending" data-type="{$dataType}"/>
							  <xsl:if test="($filter='') or $filter!='' and @CLASS=$filter">
								  <xsl:call-template name="iLOLogContents" />
							  </xsl:if>

						  </xsl:for-each>
						  
					  </xsl:when>
					  <xsl:otherwise>

						  <xsl:for-each select="$logDoc//EVENT_LOG/EVENT">
                <xsl:sort select="@*[local-name()=$sortField]" order="descending" data-type="{$dataType}"/>
								<xsl:call-template name="iLOLogContents" />
						  </xsl:for-each>
						  
					  </xsl:otherwise>
				  </xsl:choose>
				  
			  </tbody>
		  </table>
</xsl:template>

<!-- This template is used so that we can tweak the sorting above. -->
<xsl:template name="iLOLogContents">

  <xsl:variable name="alternateRowClass">
    <xsl:if test="position() mod 2 = 0">    
      <xsl:value-of select="'altRowColor'" />
	  </xsl:if>
	</xsl:variable>

	<!-- use if conditional formatting is desired -->
	<xsl:variable name="fontStyle">
		<xsl:if test="@SEVERITY = 'Critical'">
			<xsl:value-of select="'color:#000;'"/>
		</xsl:if>
	</xsl:variable>

	<tr class="{$alternateRowClass}">
		<!-- ok to set some styles here, but don't set widths on 'liquidWidth' tables (mds) -->
		<td class="iconCell" title="{@SEVERITY}">
      <xsl:if test="$sortField='SEVERITY'">
        <xsl:attribute name="class">sorted</xsl:attribute>
      </xsl:if>
			<xsl:call-template name="statusIcon">
				<xsl:with-param name="statusCode">
					<xsl:value-of select="@SEVERITY"/>
				</xsl:with-param>
			</xsl:call-template>
		</td>
		<td style="padding-right:2px;{$fontStyle}">
      <xsl:if test="$sortField='CLASS'">
        <xsl:attribute name="class">sorted</xsl:attribute>
      </xsl:if>
			<xsl:value-of select="@CLASS"/>
		</td>
		<td style="padding-right:2px;">
      <xsl:if test="$sortField='LAST_UPDATE'">
        <xsl:attribute name="class">sorted</xsl:attribute>
      </xsl:if>
			<xsl:value-of select="@LAST_UPDATE"/>
		</td>
		<td style="padding-right:2px;">
      <xsl:if test="$sortField='INITIAL_UPDATE'">
        <xsl:attribute name="class">sorted</xsl:attribute>
      </xsl:if>
			<xsl:value-of select="@INITIAL_UPDATE"/>
		</td>
		<td style="text-align:center;">
      <xsl:if test="$sortField='COUNT'">
        <xsl:attribute name="class">sorted</xsl:attribute>
      </xsl:if>
			<xsl:value-of select="@COUNT"/>
		</td>
		<td>
      <xsl:if test="$sortField='DESCRIPTION'">
        <xsl:attribute name="class">sorted</xsl:attribute>
      </xsl:if>
			<xsl:value-of select="@DESCRIPTION"/>
		</td>
	</tr>
		
</xsl:template>
  
    <!--
    @purpose    : creates a single column header with click handler.
    @notes      : the format will differ depending on sort order or if unsorted.
  -->
  <xsl:template name="sortableColumnHeader">
    <xsl:param name="cmpCriteria" />
    <xsl:param name="columnLabel" />
    <xsl:param name="optStyle" select="''" />

    <xsl:element name="th">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$sortField=$cmpCriteria">
            <xsl:choose>
              <xsl:when test="$sortOrder='ASC'">sortedAscending</xsl:when>
              <xsl:otherwise>sortedDescending</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>sortable</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="style">vertical-align:top;white-space:nowrap;<xsl:value-of select="$optStyle"/></xsl:attribute>
      <xsl:attribute name="onclick">sortEventLog('<xsl:value-of select="$cmpCriteria" />');</xsl:attribute>
      <xsl:value-of select="$columnLabel" />
    </xsl:element>
  </xsl:template>
	
	
</xsl:stylesheet>