<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
    -->

  <xsl:param name="stringsDoc" />
  <xsl:param name="certRevocation" />
  <xsl:param name="twofactor" />
  <xsl:param name="subaltname" />
  <xsl:template match="*">
    
    <form name="frmTwoFactorSettings">
      <xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
      <em><xsl:value-of select="$stringsDoc//value[@key='changingTwoFactorRequiresReset']"/></em><br />
      <span class="whiteSpacer">&#160;</span>  
      
      <div id="errorDisplay" class="errorDisplay"></div>
      
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td align="left">
            <!-- Enable Two-Factor Authentication -->
            <xsl:element name="input">
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="id">chkTwoFactorEnabled</xsl:attribute>
              <xsl:if test="$twofactor='true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </xsl:element>
          </td>
          <td width="5">&#160;</td>
          <td>
            <label for="chkTwoFactorEnabled"><xsl:value-of select="$stringsDoc//value[@key='enableTwoFactor']" /></label>
          </td>
        </tr>
        <tr>
          <td align="left">
            <!-- Enable Certificate Revocation Checking -->
            <xsl:element name="input">
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="id">chkCertRevocation</xsl:attribute>
              <xsl:if test="$certRevocation='true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </xsl:element>
          </td>
          <td width="5">&#160;</td>
          <td>
            <label for="chkCertRevocation"><xsl:value-of select="$stringsDoc//value[@key='checkCertRevocation']" /></label>
          </td>
        </tr>
      </table>

      <span class="whiteSpacer">&#160;</span>
      <br />

      <!-- Certificate Owner Field (SAN or Subject) -->
      <xsl:value-of select="$stringsDoc//value[@key='certOwnerField']" /><br />
      
      <span class="sp7">&#160;</span>
      
      <div class="groupingBox">
        <table cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td align="left">
                <xsl:element name="input">
                  <xsl:attribute name="type">radio</xsl:attribute>
                  <xsl:attribute name="id">optSAN</xsl:attribute>
                  <xsl:attribute name="name">subject</xsl:attribute>
                  <xsl:attribute name="value">SAN</xsl:attribute>
                  <xsl:if test="$subaltname='true'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </xsl:element>
              </td>
              <td width="5">&#160;</td>
              <td>
                <label for="optSAN"><xsl:value-of select="$stringsDoc//value[@key='SAN']" /></label>
              </td>
            </tr>
            <tr>
              <td align="left">
                <xsl:element name="input">
                  <xsl:attribute name="type">radio</xsl:attribute>
                  <xsl:attribute name="id">optSubject</xsl:attribute>
                  <xsl:attribute name="name">subject</xsl:attribute>
                  <xsl:attribute name="value">SUBJECT</xsl:attribute>
                  <xsl:if test="$subaltname='false'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </xsl:element>
              </td>
              <td width="5">&#160;</td>
              <td>
                <label for="optSubject"><xsl:value-of select="$stringsDoc//value[@key='SUBJECT']" /></label>
              </td>
            </tr>
        </table>
      </div>

      <span class="whiteSpacer">&#160;</span>
      <br />
      
      <!-- Apply Button -->
      <div align="right">
        <div class="buttonSet" style="margin-bottom:0px;">
          <div class="bWrapperUp">
            <div>
              <div>
                <button type='button' class="hpButton" id="btnApply" onclick="tfa();">
                  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <span class="whiteSpacer">&#160;</span>
      <br />
    </form>
    <span class="whiteSpacer">&#160;</span>
    <br />
  </xsl:template>
</xsl:stylesheet>
