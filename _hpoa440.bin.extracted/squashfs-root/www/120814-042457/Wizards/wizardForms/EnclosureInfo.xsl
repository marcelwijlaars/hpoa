<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:param name="enclosureInfoDoc" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="enclosureNumber" />
  <xsl:param name="totalEnclosures" select="1" />

  <xsl:template name="enclosureInfo" match="*">

    <xsl:variable name="enclosureName" select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:enclosureName" />

    <b>
		<xsl:value-of select="concat($stringsDoc//value[@key='enclosure:'],' ', $enclosureName)"/>
    </b>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
      <TR>
        <TD>
          <xsl:element name="span">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enclosureNameLabel', $enclosureNumber)"/>
            </xsl:attribute>
            <xsl:value-of select="$stringsDoc//value[@key='enclosureName:']" /><xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
          </xsl:element>
        </TD>
        <TD width="10">&#160;</TD>
        <TD>
          <xsl:element name="input">
            <xsl:attribute name="class">stdInput</xsl:attribute>
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('encName:', $enclosureNumber)" />
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="$enclosureName" />
            </xsl:attribute>
             <!-- validation -->           
            <xsl:attribute name="maxlength">32</xsl:attribute>
            <xsl:attribute name="validate-me">true</xsl:attribute>
            <xsl:attribute name="rule-list">6;8</xsl:attribute>
            <xsl:attribute name="range">1;32</xsl:attribute>
            <xsl:if test="$totalEnclosures &gt; 1">
              <xsl:attribute name="unique-id">
                <xsl:value-of select="concat('(', $enclosureName, ')')"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="caption-label">
              <xsl:value-of select="concat('enclosureNameLabel', $enclosureNumber)"/>
            </xsl:attribute>
          </xsl:element>
        </TD>
      </TR>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <TR>
        <TD>
          <xsl:element name="span">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('assetTagLabel', $enclosureNumber)"/>
            </xsl:attribute>
            <xsl:value-of select="$stringsDoc//value[@key='assetTag:']" />
          </xsl:element>
        </TD>
        <TD width="10">&#160;</TD>
        <TD>
          <xsl:element name="input">
            <xsl:attribute name="class">stdInput</xsl:attribute>
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('assetTag:', $enclosureNumber)" />
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:assetTag" />
            </xsl:attribute>            
            <!-- validation -->
            <xsl:attribute name="maxlength">32</xsl:attribute>
            <xsl:attribute name="validate-me">true</xsl:attribute>
            <xsl:attribute name="rule-list">0;6;8</xsl:attribute>
            <xsl:attribute name="range">0;32</xsl:attribute>
            <xsl:if test="$totalEnclosures &gt; 1">
              <xsl:attribute name="unique-id">
                <xsl:value-of select="concat('(', $enclosureName, ')')"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="caption-label">
              <xsl:value-of select="concat('assetTagLabel', $enclosureNumber)"/>
            </xsl:attribute>
          </xsl:element>
        </TD>
      </TR>
    </TABLE>

  </xsl:template>

</xsl:stylesheet>

