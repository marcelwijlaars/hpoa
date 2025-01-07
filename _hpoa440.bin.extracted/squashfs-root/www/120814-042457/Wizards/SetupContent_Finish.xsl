<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:include href="../Templates/guiConstants.xsl" />

  <xsl:param name="oaSessionKey" />
  <xsl:param name="stringsDoc" />

  <xsl:template match="*">
    <xsl:value-of select="$stringsDoc//value[@key='finishPara1a']" />
    <b>
      <xsl:value-of select="$stringsDoc//value[@key='finish']" />
    </b>&#160;<xsl:value-of select="$stringsDoc//value[@key='finishPara1b']" /><br />

		
		<span class="whiteSpacer">&#160;</span><br />
    
   <xsl:variable name="queryString">
      <xsl:choose>
        <xsl:when test="$oaSessionKey != ''">
          <xsl:value-of select="concat('?oaSessionKey=', $oaSessionKey, '&amp;', 'stylesheetUrl=/120814-042457/Templates/cgiResponse')"/>
			  </xsl:when>
			  <xsl:otherwise>?stylesheetUrl=/120814-042457/Templates/cgiResponse</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="concat('/cgi-bin/getConfigScript',$queryString)"/></xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:value-of select="$stringsDoc//value[@key='showConfig']" />
    </xsl:element>
    <xsl:value-of select="$stringsDoc//value[@key='click']" /><xsl:value-of select="$stringsDoc//value[@key='finishPara2']" />

		<br />&#160;
		<br />&#160;
		<br />&#160;
		
		<input type="checkbox" style="margin-right:5px;" checked="true"  id="doNotShow" /><label for="doNotShow">
      <xsl:value-of select="$stringsDoc//value[@key='finishPara3']" /></label>
		
	</xsl:template>
	
</xsl:stylesheet>

