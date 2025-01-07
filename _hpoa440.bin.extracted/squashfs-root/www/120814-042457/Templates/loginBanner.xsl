<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
          xmlns:hpoa="hpoa.xsd">
  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  
  <xsl:param name="stringsDoc" />
  <xsl:param name="bannerText" />
  
  <xsl:template match="*">  
    <table border="0" cellpadding="0" cellspacing="0" style="margin-left:20px;" id="loginBannerTable">
      <tbody>
        <tr>
          <td align="center">
            <textarea readonly="true" style="overflow:auto;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;width:700px;height:265px;border:1px solid #666;background-color:transparent;padding:10px;font-family:arial,verdana;font-size:110%;">
              <xsl:value-of select="$bannerText"/>
            </textarea>            
          </td>          
        </tr>
        <tr>
          <td align="center" style="vertical-align:top;">
            <table border="0" align="center;width:auto;">
              <tr>
                <td style="vertical-align:middle;text-align:right;">
                  <label for="chkAckBanner" style="vertical-align:middle;">
                    <xsl:value-of select="$stringsDoc//value[@key='iAgreeToTos']" />
                  </label>
                </td>
                <td style="vertical-align:middle;"><input type="checkbox" id="chkAckBanner" style="vertical-align:middle;margin:0px;padding:0px;width:15px;" onclick="if (this.checked){{window.setTimeout(acknowledgeBanner, 100);}}" /></td>
              </tr>
            </table>            
          </td>
        </tr>
      </tbody>
    </table>    
  </xsl:template>  
</xsl:stylesheet>

