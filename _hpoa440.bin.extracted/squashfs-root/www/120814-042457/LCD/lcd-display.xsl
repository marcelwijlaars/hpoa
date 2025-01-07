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
  <xsl:param name="lcdInfoDoc" />
  <xsl:param name="accessLevel" />
  <xsl:param name="oaAccess" />
  
  <xsl:template name="LcdScreen" match="*">

    <xsl:variable name="displayType">
      <xsl:choose>
        <xsl:when test="$lcdInfoDoc//hpoa:partNumber = '' or $lcdInfoDoc//hpoa:partNumber = '415839-001'">
          <xsl:value-of select="'firstGeneration'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'secondGeneration'" />
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="disabled">
      <xsl:choose>
        <xsl:when test="$oaAccess = false">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="tableStyle">
      <xsl:choose>
        <xsl:when test="$displayType='firstGeneration'">height:315px;width:362px;</xsl:when>
        <xsl:when test="$displayType='secondGeneration'">height:262px;width:392px;</xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <table style="border:0px;padding:0px;width:90%;height:100%;">
      <tr>
        <!-- Begin LCD Table -->
        <td valign="top" style="width:1%">
          <table border="0" cellpadding="0" cellspacing="0" style="{$tableStyle}">
            <tr>
              <td class="deviceFrame deviceFrameTop" colspan="3">&#160;</td>
            </tr>
            <tr>
              <!-- LCD screen cell -->
              <td class="deviceFrame deviceFrameLeft" colspan="1">&#160;</td>
              <td id="lcdCell" class="lcdScreen">
                <xsl:element name="div">
                  <xsl:attribute name="id">lcdContainer</xsl:attribute>
                  <xsl:attribute name="style">width:320px;height:240px;</xsl:attribute>
                  <div id="txtNode" style="display:none;color:#ddd;font-weight:bold;">
                    <xsl:value-of select="$stringsDoc//value[@key='pressOkToActivate']" />
                  </div>
                  <img id="imgLcd" width="320" height="240" border="0" style="position:relative;display:none;"/>
                </xsl:element>                
              </td>
              <xsl:choose>
                <xsl:when test="$displayType='firstGeneration'">
                  <td class="deviceFrame deviceFrameRight" colspan="1">&#160;</td>
                </xsl:when>                
                <xsl:when test="$displayType='secondGeneration'">
                  <td class="deviceFrame deviceFrameRight" style="width:50px;" colspan="1">
                    <xsl:call-template name="verticalButtonSet">
                      <xsl:with-param name="isDisabled" select="$disabled" />
                    </xsl:call-template>
                  </td>
                </xsl:when>
              </xsl:choose>
            </tr>
            <tr>
              <td class="deviceFrame deviceFrameBottom" colspan="3">&#160;</td>
            </tr>            
            <xsl:choose>
              <xsl:when test="$displayType='firstGeneration'">
                <xsl:call-template name="horizontalButtonSet">
                  <xsl:with-param name="isDisabled" select="$disabled" />
                </xsl:call-template> 
              </xsl:when>
              <xsl:when test="$displayType='secondGeneration'">
                <!-- nothing -->
              </xsl:when>
            </xsl:choose>
          </table>
        </td>
        <!-- End LCD Table -->
        <td id="cellChatLog" style="text-align:left;vertical-align:top;width:1%;">
          <xsl:choose>
            <xsl:when test="$displayType='firstGeneration'">
              <textarea devid="chatMode" readonly="readonly" class="stdInput" style="margin-left:10px;margin-top:3px;visibility:hidden;height:314px;font-family:arial;font-size:11px;" rows="20" cols="1" id="txtChatLog"></textarea>
            </xsl:when>
            <xsl:when test="$displayType='secondGeneration'">
              <textarea devid="chatMode" readonly="readonly" class="stdInput" style="margin-left:10px;margin-top:3px;visibility:hidden;height:264px;font-family:arial;font-size:11px;" rows="18" cols="1" id="txtChatLog"></textarea>
            </xsl:when>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td colspan="2" style="height:40px;">
          <!-- Start Tabs -->
          <br style="height:20px;" />
          <div class="tabSet" style="width:100%;">
            <div class="tabOff" tabid="tabSecurity">
              <xsl:value-of select="$stringsDoc//value[@key='security']" />
            </div>
            <div class="tabOff" tabid="tabUserNote">
              <xsl:value-of select="$stringsDoc//value[@key='userNote']" />
            </div>
            <div class="tabOff" tabid="tabBackground">
              <xsl:value-of select="$stringsDoc//value[@key='background']" />
            </div>
            <div class="tabOff" tabid="tabChatMode">
              <xsl:value-of select="$stringsDoc//value[@key='chatMode']" />
            </div>
            <div class="tabBottomLine"></div>
          </div>
        </td>
        <!-- End Tabs -->
      </tr>
      <tr>
        <td id="frameCell" valign="top" style="width:100%;height:100%;" colspan="2">
          <iframe id="lcdTabContent" name="lcdTabContent" src="blank.html" frameborder="no" scrolling="no" style="width:460px;" onload="adjustFrameHeight(this);"></iframe>
        </td>
      </tr>
    </table>

  </xsl:template>

  <!--
    The first generation button set (bottom horizontal)
  -->
  <xsl:template name="horizontalButtonSet">
    <xsl:param name="isDisabled" />
    <tr>
      <td class="deviceButtonRow" rowspan="1" colspan="3">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td style="width:20px;">
              &#160;
            </td>
            <td style="height:42px;padding-top:4px;">
              <div class="buttonSet buttonsAreLeftAligned" style="padding-left:0px;margin-bottom:0px;height:30px;">
                <div class="bWrapperUp" style="margin-top:6px;margin-right:56px;">
                  <div>
                    <div>
                      <xsl:call-template name="refreshButton">
                        <xsl:with-param name="disabled" select="$isDisabled" />
                      </xsl:call-template>
                    </div>
                  </div>
                </div>
                <div class="bWrapperUp" style="margin-top:6px;">
                  <div>
                    <div>
                      <xsl:call-template name="upButton">
                        <xsl:with-param name="disabled" select="$isDisabled" />
                      </xsl:call-template>
                    </div>
                  </div>
                </div>
                <div class="bWrapperUp" style="margin-top:6px;">
                  <div>
                    <div>
                      <xsl:call-template name="downButton">
                        <xsl:with-param name="disabled" select="$isDisabled" />
                      </xsl:call-template>
                    </div>
                  </div>
                </div>
                <div class="bWrapperUp">
                  <div>
                    <div>
                      <xsl:call-template name="okButton">
                        <xsl:with-param name="disabled" select="$isDisabled" />
                      </xsl:call-template>
                    </div>
                  </div>
                </div>
                <div class="bWrapperUp" style="margin-top:6px;">
                  <div>
                    <div>
                      <xsl:call-template name="leftButton">
                        <xsl:with-param name="disabled" select="$isDisabled" />
                      </xsl:call-template>
                    </div>
                  </div>
                </div>
                <div class="bWrapperUp" style="margin-top:6px;">
                  <div>
                    <div>
                      <xsl:call-template name="rightButton">
                        <xsl:with-param name="disabled" select="$isDisabled" />
                      </xsl:call-template>
                    </div>
                  </div>
                </div>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td style="background:#9c9c9c;height:1px;" rowspan="1" colspan="3">
      </td>
    </tr>
  </xsl:template>

  <!--
    The second generation LCD button set (right-side vertical).
  -->
  <xsl:template name="verticalButtonSet">
    <xsl:param name="isDisabled" />

    <table style="width:40px;height:242px;padding:1px;margin-left:2px;">
      <tr>
        <td>
          <span style="line-height:10px;">&#160;</span>
        </td>
      </tr>
      <tr>
        <td style="padding-left:5px;">          
          <div class="bWrapperUp" style="margin:15px 0px 0px 3px;float:left;">
            <div>
              <div>
                <xsl:call-template name="upButton">
                  <xsl:with-param name="disabled" select="$isDisabled" />
                </xsl:call-template>
              </div>
            </div>
          </div>
        </td>
      </tr>
      <tr>
        <td style="padding-left:5px;">
          <div class="bWrapperUp" style="margin:5px 0px 0px 3px;float:left;">
            <div>
              <div>
                <xsl:call-template name="downButton">
                  <xsl:with-param name="disabled" select="$isDisabled" />
                </xsl:call-template>
              </div>
            </div>
          </div>
        </td>
      </tr>
      <tr>
        <td style="padding-left:2px;">
          <div class="bWrapperUp" style="margin:10px 0px 0px 2px;float:left;">
            <div>
              <div>
                <xsl:call-template name="okButton">
                  <xsl:with-param name="disabled" select="$isDisabled" />
                </xsl:call-template>
              </div>
            </div>
          </div>
          </td>
        </tr>
      <tr>
        <td style="padding-left:5px;">
          <div class="bWrapperUp" style="margin:9px 0px 0px 3px;float:left;">
            <div>
              <div>
                <xsl:call-template name="leftButton">
                  <xsl:with-param name="disabled" select="$isDisabled" />
                </xsl:call-template>
              </div>
            </div>
          </div>
        </td>
      </tr>
      <tr>
        <td style="padding-left:5px;">
          <div class="bWrapperUp" style="margin:5px 0px 0px 3px;float:left;">
            <div>
              <div>
                <xsl:call-template name="rightButton">
                  <xsl:with-param name="disabled" select="$isDisabled" />
                </xsl:call-template>
              </div>
            </div>
          </div>
          </td>
        </tr>
      <tr>
        <td align="center">
          <span style="line-height:8px;">&#160;</span>
        </td>
      </tr>
      <tr>
        <td style="vertical-align:top;padding-left:5px;">
          <div class="bWrapperUp" style="margin:10px 0px 0px 3px;float:left;">
            <div>
              <div>
                <xsl:call-template name="refreshButton">
                  <xsl:with-param name="disabled" select="$isDisabled" />
                </xsl:call-template>
              </div>
            </div>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- REFRESH BUTTON -->
  <xsl:template name="refreshButton">
    <xsl:param name="disabled" />
    <xsl:element name="button">
      <xsl:attribute name="class">hpButtonSmall shrinkWrapButton</xsl:attribute>
      <xsl:attribute name="style">width:25px;height:20px;padding-left:4px;</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$disabled = 'false'">
          <xsl:attribute name="onclick">buttonEvent('LCD_REFRESH');</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="disabled">disabled</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:element name="img">
        <xsl:attribute name="id">vertRefresh</xsl:attribute>
        <xsl:attribute name="src">refresh.gif</xsl:attribute>
        <xsl:attribute name="style">width:14px;height:16px;border:0px;padding:0px;</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$stringsDoc//value[@key='refresh']" />
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- UP BUTTON -->
  <xsl:template name="upButton">
    <xsl:param name="disabled" />

    <xsl:element name="button">
      <xsl:attribute name="class">hpButtonSmall shrinkWrapButton</xsl:attribute>
      <xsl:attribute name="style">width:25px;height:19px;padding-left:5px;padding-top:0px;</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$disabled = 'false'">
          <xsl:attribute name="onclick">buttonEvent('LCD_UP','CLICKED');</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="disabled">disabled</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:element name="img">
        <xsl:attribute name="src">up.gif</xsl:attribute>
        <xsl:attribute name="style">height:11px;width:14px;border:0px;</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$stringsDoc//value[@key='up']" />
        </xsl:attribute>
        <xsl:attribute name="alt"></xsl:attribute>
      </xsl:element>

    </xsl:element>
  </xsl:template>
  
  <!-- DOWN BUTTON -->
  <xsl:template name="downButton">
    <xsl:param name="disabled" />

    <xsl:element name="button">
      <xsl:attribute name="class">hpButtonSmall shrinkWrapButton</xsl:attribute>
      <xsl:attribute name="style">width:25px;height:19px;padding-left:5px;padding-top:2px;</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$disabled = 'false'">
          <xsl:attribute name="onclick">buttonEvent('LCD_DOWN','CLICKED');</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="disabled">disabled</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:element name="img">
        <xsl:attribute name="src">down.gif</xsl:attribute>
        <xsl:attribute name="style">height:11px;width:14px;border:0px;</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$stringsDoc//value[@key='down']" />
        </xsl:attribute>
        <xsl:attribute name="alt"></xsl:attribute>
      </xsl:element>

    </xsl:element>
  </xsl:template>

  <!-- OK BUTTON -->
  <xsl:template name="okButton">
    <xsl:param name="disabled" />

    <xsl:element name="button">
      <xsl:attribute name="class">hpButtonSmall shrinkWrapButton</xsl:attribute>
      <xsl:attribute name="style">width:34px;height:31px;</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$disabled = 'false'">
          <xsl:attribute name="onclick">buttonEvent('LCD_OK','CLICKED');</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="disabled">disabled</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <span id="lblOkButton" class="OkButton">OK</span>
    </xsl:element>
  </xsl:template>

  <!-- LEFT BUTTON -->
  <xsl:template name="leftButton">
    <xsl:param name="disabled" />
    
    <xsl:element name="button">
      <xsl:attribute name="class">hpButtonSmall shrinkWrapButton</xsl:attribute>
      <xsl:attribute name="style">width:25px;height:19px;padding-left:2px;padding-top:0px;</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$disabled = 'false'">
          <xsl:attribute name="onclick">buttonEvent('LCD_LEFT','CLICKED');</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="disabled">disabled</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:element name="img">
        <xsl:attribute name="src">left.gif</xsl:attribute>
        <xsl:attribute name="style">height:11px;width:14px;border:0px;</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$stringsDoc//value[@key='left']" />
        </xsl:attribute>
        <xsl:attribute name="alt"></xsl:attribute>
      </xsl:element>

    </xsl:element>
  </xsl:template>

  <!-- RIGHT BUTTON -->
  <xsl:template name="rightButton">
    <xsl:param name="disabled" />

    <xsl:element name="button">
      <xsl:attribute name="class">hpButtonSmall shrinkWrapButton</xsl:attribute>
      <xsl:attribute name="style">width:25px;height:19px;padding-left:6px;padding-top:0px;</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$disabled = 'false'">
          <xsl:attribute name="onclick">buttonEvent('LCD_RIGHT','CLICKED');</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="disabled">disabled</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:element name="img">
        <xsl:attribute name="src">right.gif</xsl:attribute>
        <xsl:attribute name="style">height:11px;width:14px;border:0px;</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$stringsDoc//value[@key='right']" />
        </xsl:attribute>
        <xsl:attribute name="alt"></xsl:attribute>
      </xsl:element>

    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>


