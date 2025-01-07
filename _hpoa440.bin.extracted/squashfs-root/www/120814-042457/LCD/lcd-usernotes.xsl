<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
    
  <xsl:include href="../Templates/guiConstants.xsl" />

  <xsl:param name="stringsDoc" />
  <xsl:param name="userNoteDoc"/>
  <xsl:param name="accessLevel" />
  <xsl:param name="oaAccess" />

  <xsl:template name="LcdMessages" match="*">
    
      <xsl:variable name="disabled">
        <xsl:choose>
          <xsl:when test="($accessLevel = $USER) or ($oaAccess = false)">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
    
      <table style="border:0px;padding:0px;width:100%;">
        <tr>
          <td colspan="3">            
              <xsl:value-of select="$stringsDoc//value[@key='lcdUserNoteInstruction']"/>
            <br />
            <br />
          </td>
        </tr>
        <tr>
          <td class="stdLabelCell" nowrap="nowrap" style="width:1%;">
            <label devid="chatMode" id="lblLine1" for="txtLine1">
              <xsl:value-of select="$stringsDoc//value[@key='line1:']"/>
            </label>
          </td>
          <td style="width:205px;padding-bottom:5px;">
            <xsl:call-template name="usernoteInput">
              <xsl:with-param name="disabled" select="$disabled" />
              <xsl:with-param name="usernoteLine" select="1" />
              <xsl:with-param name="textValue" select="$userNoteDoc//hpoa:lcdUserNotesLine1" />
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td class="stdLabelCell">
            <label devid="chatMode" id="lblLine2" for="txtLine2">
              <xsl:value-of select="$stringsDoc//value[@key='line2:']"/>
            </label>
          </td>
          <td style="width:205px;padding-bottom:5px;">
            <xsl:call-template name="usernoteInput">
              <xsl:with-param name="disabled" select="$disabled" />
              <xsl:with-param name="usernoteLine" select="2" />
              <xsl:with-param name="textValue" select="$userNoteDoc//hpoa:lcdUserNotesLine2" />
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td class="stdLabelCell">
            <label id="lblLine3" for="txtLine3">
              <xsl:value-of select="$stringsDoc//value[@key='line3:']"/>
            </label>
          </td>
          <td style="width:205px;padding-bottom:5px;">
            <xsl:call-template name="usernoteInput">
              <xsl:with-param name="disabled" select="$disabled" />
              <xsl:with-param name="usernoteLine" select="3" />
              <xsl:with-param name="textValue" select="$userNoteDoc//hpoa:lcdUserNotesLine3" />
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td class="stdLabelCell">
            <label id="lblLine4" for="txtLine4">
              <xsl:value-of select="$stringsDoc//value[@key='line4:']"/>
            </label>
          </td>
          <td style="width:205px;padding-bottom:5px;">
            <xsl:call-template name="usernoteInput">
              <xsl:with-param name="disabled" select="$disabled" />
              <xsl:with-param name="usernoteLine" select="4" />
              <xsl:with-param name="textValue" select="$userNoteDoc//hpoa:lcdUserNotesLine4" />
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td class="stdLabelCell">
            <label id="lblLine5" for="txtLine5">
              <xsl:value-of select="$stringsDoc//value[@key='line5:']"/>
            </label>
          </td>
          <td style="width:205px;padding-bottom:5px;">
            <xsl:call-template name="usernoteInput">
              <xsl:with-param name="disabled" select="$disabled" />
              <xsl:with-param name="usernoteLine" select="5" />
              <xsl:with-param name="textValue" select="$userNoteDoc//hpoa:lcdUserNotesLine5" />
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td class="stdLabelCell">
            <label id="lblLine6" for="txtLine6">
              <xsl:value-of select="$stringsDoc//value[@key='line6:']"/>
            </label>
          </td>
          <td style="width:205px;padding-bottom:5px;">
            <xsl:call-template name="usernoteInput">
              <xsl:with-param name="disabled" select="$disabled" />
              <xsl:with-param name="usernoteLine" select="6" />
              <xsl:with-param name="textValue" select="$userNoteDoc//hpoa:lcdUserNotesLine6" />
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <tr>
          <td></td>
          <td colspan="2">
            <div class="buttonSet" style="margin-top:5px">
              <div class="bWrapperUp">
                <div>
                  <div>
                    <xsl:element name="button">
                    <xsl:attribute name="class">hpButton</xsl:attribute>
                    <xsl:attribute name="id">applyTextButton</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="$disabled != 'true'">
                        <xsl:attribute name="onclick">updateLcdText(false);</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
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
                      <xsl:attribute name="id">btnPreview</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="$disabled != 'true'">
                          <xsl:attribute name="onclick">previewUsernotes();</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="$stringsDoc//value[@key='viewUserNote']"/>
                    </xsl:element>
                  </div>
                </div>
              </div>
              <div class="bWrapperUp">
                <div>
                  <div>
                   <xsl:element name="button">
                    <xsl:attribute name="class">hpButton</xsl:attribute>
                    <xsl:attribute name="id">clearTextButton</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="$disabled != 'true'">
                        <xsl:attribute name="onclick">updateLcdText(true);</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                      <xsl:value-of select="$stringsDoc//value[@key='default']"/>
                    </xsl:element>
                  </div>
                </div>
              </div>
            </div>
          </td>
        </tr>
      </table>
  </xsl:template>                        
  
  <!-- input textbox template -->
  <xsl:template name="usernoteInput">
    <xsl:param name="disabled" />    
    <xsl:param name="usernoteLine" />
    <xsl:param name="textValue" />
    
    <xsl:element name="input">
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="maxlength">25</xsl:attribute>
      <xsl:attribute name="line-id"><xsl:value-of select="concat('lcdUserNotesLine',$usernoteLine)"/></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="concat('txtLine',$usernoteLine)"/></xsl:attribute>
      <xsl:attribute name="size">20</xsl:attribute>
      <xsl:attribute name="value"><xsl:value-of select="$textValue"/></xsl:attribute>
      <xsl:attribute name="style">width:200px;padding-left:2px;</xsl:attribute>
      
      <!-- validation: optional, invalid char list -->
      <xsl:attribute name="validate-me">true</xsl:attribute>
      <xsl:attribute name="caption-label">lblLine<xsl:value-of select="$usernoteLine"/></xsl:attribute>
      <xsl:attribute name="rule-list">0;11</xsl:attribute>
      <xsl:attribute name="invalid-list">~^'"</xsl:attribute>
      
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
  </xsl:template>
  
</xsl:stylesheet>


