<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../LCD/pin-protection.xsl"/>
  <xsl:include href="../Templates/guiConstants.xsl" />

  <!-- parameters -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="lcdInfoDoc" />
  <xsl:param name="pinInfoDoc" />
  <xsl:param name="enclosureNetworkInfoDoc" />
  <xsl:param name="accessLevel" />
  <xsl:param name="oaAccess" />
  
  <xsl:template name="LcdSecurity" match="*">
    
    <xsl:variable name="disabled">
      <xsl:choose>
        <xsl:when test="($accessLevel = $ADMINISTRATOR) and ($oaAccess = true())">false</xsl:when>
        <xsl:otherwise>true</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <table style="border-collapse:collapse;width:100%;padding:0px;">
      <tr>
        <td>
          <xsl:value-of select="$stringsDoc//value[@key='lcdPinInfo']"/>
        </td>
      </tr>
      <tr>
        <td style="padding-top:10px;">
          <xsl:call-template name="LcdPinTemplate">
            <xsl:with-param name="pinInfo" select="$pinInfoDoc" />
            <xsl:with-param name="screenInfo" select="$lcdInfoDoc" />
            <xsl:with-param name="disableAll" select="$disabled" />
            <xsl:with-param name="enclosureNetworkInfo" select="$enclosureNetworkInfoDoc" />
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td>
          &#160;
        </td>        
      </tr>
      <tr>
        <td>
          <div class="buttonSet">
            <div class="bWrapperUp">
              <div>
                <div>
                  <xsl:element name="button">
                    <xsl:attribute name="class">hpButton</xsl:attribute>
                    <xsl:attribute name="id">btnApply</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="$disabled = 'false'">
                        <xsl:attribute name="onclick">initUpdate();</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="disabled">true</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose> 
                    <xsl:value-of select="$stringsDoc//value[@key='apply']"/>
                  </xsl:element>
                </div>
              </div>
            </div>
            <div class="bWrapperUp">
              <div>
                <div>
                  <xsl:element name="button">
                    <xsl:attribute name="class">hpButton</xsl:attribute>
                    <xsl:attribute name="id">btnClear</xsl:attribute>                    
                    <xsl:choose>
                      <xsl:when test="$disabled = 'true'">
                        <xsl:attribute name="disabled">true</xsl:attribute>                        
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="onclick">clearPin();</xsl:attribute> 
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="$stringsDoc//value[@key='clear']"/>
                  </xsl:element>
                </div>
              </div>
            </div>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>


