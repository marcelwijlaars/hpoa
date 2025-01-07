<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  
  <xsl:include href="../Templates/guiConstants.xsl" />

  <!-- parameters -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="chatInfoDoc" />
  <xsl:param name="accessLevel" />
  <xsl:param name="oaAccess" />

  <xsl:template name="LcdChatMode" match="*">
    
    <xsl:variable name="disabled">
      <xsl:choose>
        <xsl:when test="($accessLevel = $USER) or ($oaAccess = false())">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <table style="width:100%;border:0px;padding:0px;">
      <tr>
        <td colspan="2" style="padding-bottom:5px;">
          <xsl:value-of select="$stringsDoc//value[@key='chatModeInfo']"/>
        </td>
      </tr>
      <tr>
        <td>
          <table style="width:430px;border:0px;padding:0px;">
            <tr>
              <td colspan="2" style="padding:0px;vertical-align:top;width:45%">
                <table style="border:0px;padding:0px 30px 0px 0px;">
                  <tr>
                    <td colspan="2" style="padding-bottom:5px;">
                      <b>
                        <xsl:value-of select="$stringsDoc//value[@key='message:']"/>
                      </b>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space:nowrap;padding-bottom:3px;padding-right:5px;width:1%;">
                      <label id="lblUser" for="txtUser">
                        <xsl:value-of select="$stringsDoc//value[@key='username:']"/>
                      </label>
                    </td>
                    <td style="padding-bottom:3px;">
                      <xsl:element name="input">
                        <xsl:attribute name="id">txtUser</xsl:attribute>
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:attribute name="style">width:161px;padding-left:2px;</xsl:attribute>
                        <xsl:attribute name="size">25</xsl:attribute>
                        <xsl:attribute name="maxlength">15</xsl:attribute>
                        <xsl:attribute name="validate-me">true</xsl:attribute>
                        <xsl:attribute name="caption-label">lblUser</xsl:attribute>
                        <xsl:attribute name="rule-list">6</xsl:attribute>
                        <xsl:attribute name="range">1;15</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$chatInfoDoc//hpoa:lcdChatName"/></xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$disabled = 'true'">
                            <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">stdInput</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>                        
                      </xsl:element>
                    </td>
                  </tr>
                  <tr>                    
                    <td style="white-space:nowrap;vertical-align:top;padding-bottom:3px;padding-right:5px;width:1%;">
                      <label id="lblMsg" for="txtMessage">
                        <xsl:value-of select="$stringsDoc//value[@key='chatText:']"/>
                      </label>
                    </td>                      
                    <td style="padding-bottom:3px;">
                      <xsl:element name="textarea">
                        <xsl:attribute name="id">txtMessage</xsl:attribute>
                        <xsl:attribute name="cols">22</xsl:attribute>
                        <xsl:attribute name="rows">4</xsl:attribute>                        
                        <xsl:attribute name="wrap">hard</xsl:attribute>
                        <xsl:attribute name="style">overflow:hidden;width:161px; height:60px;font-family:'courier new', courier, monospace;font-size:8pt;padding-left:2px;border:1px solid #7F9D89;</xsl:attribute>
                        <xsl:attribute name="validate-me">true</xsl:attribute>
                        <xsl:attribute name="caption-label">lblMsg</xsl:attribute>
                        <xsl:attribute name="rule-list">6</xsl:attribute>  
                        <xsl:choose>
                          <xsl:when test="$disabled = 'true'">
                            <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">stdInput</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>  
                        <xsl:value-of select="$chatInfoDoc//hpoa:lcdChatMessage"/>
                      </xsl:element>                      
                    </td>                    
                  </tr>
                </table>
              </td>
              <td style="vertical-align:top;width:55%;">
                <table align="center" style="width:90%;border:0px;padding:0px;">
                  <tr>
                    <td colspan="2" style="padding-bottom:5px;">
                      <b>
                        <xsl:value-of select="$stringsDoc//value[@key='responses:']"/>
                      </b>
                    </td>
                  </tr>
                  <tr>
                    <td style="width:1%;padding-bottom:3px;text-align:right;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="id">chkMenu1</xsl:attribute>
                        <xsl:if test="$chatInfoDoc//hpoa:menu1[@checked]">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disabled = 'true'">
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td style="padding-bottom:3px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:attribute name="size">16</xsl:attribute>
                        <xsl:attribute name="maxlength">16</xsl:attribute>
                        <xsl:attribute name="id">txtMenu1</xsl:attribute>
                        <xsl:attribute name="style">padding-left:2px;</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$chatInfoDoc//hpoa:menu1"/></xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$disabled = 'true'">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                            <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">stdInput</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:element>
                    </td>
                  </tr>
                  <tr>
                    <td style="width:1%;padding-bottom:3px;text-align:right;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="id">chkMenu2</xsl:attribute>
                        <xsl:if test="$chatInfoDoc//hpoa:menu2[@checked]">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disabled = 'true'">
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:if>
                      </xsl:element>
                    </td>
                    <td style="padding-bottom:3px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:attribute name="size">16</xsl:attribute>
                        <xsl:attribute name="maxlength">16</xsl:attribute>
                        <xsl:attribute name="id">txtMenu2</xsl:attribute>
                        <xsl:attribute name="style">padding-left:2px;</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$chatInfoDoc//hpoa:menu2"/></xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$disabled = 'true'">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                            <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">stdInput</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:element>
                    </td>
                  </tr>
                  <tr>
                    <td style="width:1%;padding-bottom:3px;text-align:right;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="id">chkMenu3</xsl:attribute>
                        <xsl:if test="$chatInfoDoc//hpoa:menu3[@checked]">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disabled = 'true'">
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:if>                        
                      </xsl:element>
                    </td>
                    <td style="padding-bottom:3px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:attribute name="size">16</xsl:attribute>
                        <xsl:attribute name="maxlength">16</xsl:attribute>
                        <xsl:attribute name="id">txtMenu3</xsl:attribute>
                        <xsl:attribute name="style">padding-left:2px;</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$chatInfoDoc//hpoa:menu3"/></xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$disabled = 'true'">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                            <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">stdInput</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:element>
                    </td>
                  </tr>
                  <tr>
                    <td style="width:1%;padding-bottom:3px;text-align:right;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">checkbox</xsl:attribute>
                        <xsl:attribute name="id">chkMenu4</xsl:attribute>
                        <xsl:if test="$chatInfoDoc//hpoa:menu4[@checked]">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$disabled = 'true'">
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:if>                        
                      </xsl:element>
                    </td>
                    <td style="padding-bottom:3px;">
                      <xsl:element name="input">
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:attribute name="size">16</xsl:attribute>
                        <xsl:attribute name="maxlength">16</xsl:attribute>
                        <xsl:attribute name="id">txtMenu4</xsl:attribute>
                        <xsl:attribute name="style">padding-left:4px;</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$chatInfoDoc//hpoa:menu4"/></xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$disabled = 'true'">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                            <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">stdInput</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:element>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <div class="buttonSet" style="padding-right:10px;padding-top:10px;">
            <div class="bWrapperUp">
              <div>
                <div>
                  <xsl:element name="button">
                    <xsl:attribute name="class">hpButton</xsl:attribute>
                    <xsl:attribute name="id">btnSend</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="$disabled = 'true'">
                        <xsl:attribute name="disabled">true</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="onclick">submitChatMessage();</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="$stringsDoc//value[@key='send']"/>
                  </xsl:element>
                </div>
              </div>
            </div>
            <div class="bWrapperUp">
              <div>
                <div>
                  <xsl:element name="button">
                    <xsl:attribute name="class">hpButton</xsl:attribute>
                    <xsl:attribute name="id">btnWithdraw</xsl:attribute>
                    <xsl:attribute name="disabled">true</xsl:attribute>
                    <xsl:attribute name="onclick">withdrawChatMessage();</xsl:attribute>
                    <xsl:value-of select="$stringsDoc//value[@key='withdraw']"/>
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


