<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:param name="waitText"></xsl:param>
  <xsl:param name="waitDescription">&#160;</xsl:param>
  <xsl:param name="progressImage">/120814-042457/images/progress_bar_large.gif</xsl:param>
  <xsl:param name="waitTextStyle"></xsl:param>

  <xsl:template name="WaitContainerTemplate" match="*">
    <div style="padding:10px;">
      <div id="waitTextContainer" class="waitTextContainer" style="{$waitTextStyle}">
        <xsl:value-of select="$waitText"/>
      </div>
      <div style="text-align:center;">
        <img src="{$progressImage}" style="border:0px;" />
      </div>
      <div id="waitDescriptionContainer" class="waitDescriptionContainer">
        <xsl:value-of select="$waitDescription"/>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>