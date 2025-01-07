<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="encNum" />

	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureInfoDoc" />
  <xsl:param name="isCollapsed">false</xsl:param>
  <xsl:param name="isTower" select="'false'" />
	
	<!--
		Include the gui and enclosure constants files.
		NOTE: The enclosure constants file is dependant on the $enclosureInfoDoc variable.
	 -->
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	
	<xsl:template match="*">
     
    <xsl:variable name="iconSrc">
      <xsl:choose>
        <xsl:when test="$isCollapsed='true'">/120814-042457/images/icon_tray_expand_d.gif</xsl:when>
      <xsl:otherwise>/120814-042457/images/icon_tray_contract_u.gif</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="containerStyle">
      <xsl:choose>
        <xsl:when test="$isCollapsed='true'">visibility:hidden;</xsl:when>
        <xsl:otherwise>visibility:visible;</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="div">

      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="$isTower='true'">width:180px;</xsl:when>
          <xsl:otherwise>width:250px;</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td>
              <h3 class="subTitleRight">
                <div class="subTitleIconLeft">
                  <img src="{$iconSrc}" id="imgStatusTray" border="0" onclick="top.mainPage.getStatusContainer().toggleStatus(this);" width="11" height="11" />
                </div>
                <span id="enclosureName">
                  <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:enclosureName"/>
                </span>
              </h3>
              <div class="subTitleBottomEdge"></div>
            </td>
          </tr>
        </table>

        <div id="enclosureTrayContainer" style="{$containerStyle}">

          <span class="whiteSpacer">&#160;</span>
          <br />

          <!-- Table wrapper used to center the enclosure front view -->
          <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
              <td>
                <div id="{concat('enclosureFrontView', $encNum)}"></div>
              </td>
            </tr>
          </table>

          <span class="whiteSpacer">&#160;</span>
          <br />

          <!-- Table wrapper used to center the enclosure rear view -->
          <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
              <td>
                <div id="{concat('enclosureRearView', $encNum)}"></div>
              </td>
            </tr>
          </table>

        </div>

      </xsl:element>

	</xsl:template>

</xsl:stylesheet>