<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:param name="stringsDoc" />
  <xsl:param name="encNum" />
  <xsl:param name="encType" />  
  <xsl:param name="isTower" />
  <xsl:param name="enclosureName" />
  <xsl:param name="isAuthenticated" />
  <xsl:param name="isTfaEnabled" />
  <xsl:param name="isLoaded" />
  <xsl:param name="isLocal" />

  <xsl:template name="rackOverviewEnclosure" match="*">
    
    <xsl:variable name="hash"><xsl:value-of select="concat('enc', $encNum)"/></xsl:variable>
    <xsl:variable name="linkId" select="concat('signOutEnc', $encNum)" />
    <xsl:variable name="linkStyle">
      <xsl:choose>
        <xsl:when test="$isLocal = 'true' or $isAuthenticated != 'true'">
          visibility:hidden;
        </xsl:when>
        <xsl:otherwise>visibility:visible;margin:0px;</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <table cellpadding="0" cellspacing="0" border="0" align="center" style="border-collapse:collapse;" width="100%">
      <tr>
        <td style="padding-right:1px;">

          <div style="width:100%;">

            <h3 class="subTitle">
              <a name="{$hash}" />
              
              <div class="subTitleIcon" id="{$linkId}" style="{$linkStyle}">
                <xsl:element name="a">
                  <xsl:attribute name="href">javascript:void(0)</xsl:attribute>
                  <xsl:attribute name="style">color:#fff;text-decoration:underline;font-weight:normal;padding-bottom:2px;</xsl:attribute>
                  <xsl:attribute name="onclick">
                    signOutEnclosure(<xsl:value-of select="$encNum"/>);
                  </xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='signOut']" />
                </xsl:element>
              </div>

<!--              <span>Enclosure: </span> -->
              <span><xsl:value-of select="$stringsDoc//value[@key='enclosure']" />: </span>
              <xsl:element name="span">
                <xsl:attribute name="style">display:inline;</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('encNameLabel', $encNum)"/>
                </xsl:attribute>                
                <xsl:value-of select="$enclosureName"/>
              </xsl:element>              
            </h3>

            <div class="subTitleBottomEdge"></div>

            <xsl:element name="div">

              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $encNum, 'Content')" />
              </xsl:attribute>
              <xsl:attribute name="style">padding:10px 0px 10px 10px;border:1px solid #000000;</xsl:attribute>

              <xsl:choose>
                <xsl:when test="$isAuthenticated='true' and $isLoaded='true'">
                  <xsl:call-template name="authenticatedEnclosure" />
                </xsl:when>
                <xsl:when test="$isLoaded='false' and $isAuthenticated='true'">
                  <xsl:call-template name="nonLoadedEnclosure" />
                </xsl:when>
                <xsl:when test="$isAuthenticated='false'">
                  <xsl:call-template name="nonAuthenticatedEnclosure" />
                </xsl:when>
              </xsl:choose>

            </xsl:element>

            <xsl:element name="div">
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $encNum, 'ContentPadding')" />
              </xsl:attribute>
              <xsl:attribute name="style">display:none;font-size:10px;border:1px solid #000000;</xsl:attribute>
              &#160;
            </xsl:element>

          </div>

        </td>
      </tr>
    </table>

  </xsl:template>

  <xsl:template name="authenticatedEnclosure">

    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <!-- Front view cell -->
        <td width="224" valign="top">
          
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enclosureFrontView', $encNum)"/>
            </xsl:attribute>
          </xsl:element>

        </td>
        <td valign="top">
          <img src="/120814-042457/images/one_white.gif" width="15" />
        </td>
        <!-- Rear view cell -->
        <td width="224" valign="top">
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enclosureRearView', $encNum)"/>
            </xsl:attribute>
          </xsl:element>

        </td>
        <td>
          <img src="/120814-042457/images/one_white.gif" width="15" />
        </td>
        <!-- System information cell -->
        <td width="350" valign="top">
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enclosureInfoView', $encNum)"/>
            </xsl:attribute>
          </xsl:element>
        </td>
        
        <td>
          <img src="/120814-042457/images/one_white.gif" width="15" />
        </td>

        
         <td width="350" valign="top">
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('rackInfoView', $encNum)"/>
            </xsl:attribute>
          </xsl:element>
        </td>

        
      </tr>
    </table>

  </xsl:template>

  <xsl:template name="nonAuthenticatedEnclosure">
    
    <xsl:variable name="validateTag">
      <xsl:value-of select="concat('validate-login',$encNum)"/>
    </xsl:variable>  
    
    <xsl:variable name="formName">
      <xsl:value-of select="concat('formLogin',$encNum)"/>
    </xsl:variable>
    
    <xsl:variable name="imageType">
      <xsl:choose>
        <xsl:when test="$encType=1">
          <xsl:choose>
            <xsl:when test="$isTower = 'true'">_tower</xsl:when>
            <xsl:otherwise>_c3000</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <form id="{$formName}">
    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <!-- Front view cell -->
        <td width="224">
           <xsl:call-template name="enclosureBlankImage">
             <xsl:with-param name="type" select="$encType" />
             <xsl:with-param name="isTowerView" select="$isTower" />
           </xsl:call-template>
        </td>
        <td>
          <img src="/120814-042457/images/one_white.gif" width="10" />
        </td>
        <!-- Rear view cell -->
        <xsl:choose>
          <xsl:when test="$isTfaEnabled='true'">
            <td width="276" valign="middle"  style="padding-left:10px;">
              &#160;
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td width="276" align="center">
              <table id="signInInfo" border="0" cellpadding="0" cellspacing="0" width="276">
                <tr>              
                  <td colspan="3"><div style="width:100%;padding-left:3px;" id="{concat('loginErrorEnc',$encNum)}" class="errorDisplay"></div></td>
                </tr>
                <tr>
                  <td>&#160;</td>
                  <td class="signInText" id="usernameBox" style="white-space:nowrap;padding-bottom:15px;"><xsl:value-of select="$stringsDoc//value[@key='username:']"/></td>
                  <td class="signInInput" style="padding-bottom:15px;">            

                    <xsl:element name="input">
                      <xsl:attribute name="autocomplete">on</xsl:attribute>
                      <xsl:attribute name="class">stdInput</xsl:attribute>                                                      
                      <xsl:attribute name="{$validateTag}">true</xsl:attribute>
                      <xsl:attribute name="rule-list">1</xsl:attribute>
                      <xsl:attribute name="caption-label">usernameBox</xsl:attribute>
                      <xsl:attribute name="style">border:1px solid #666666;width:178px;</xsl:attribute>
                      <xsl:attribute name="onkeypress">return checkEnter(event,<xsl:value-of select="$encNum"/>);</xsl:attribute>
                      <xsl:attribute name="onfocus">javascript:this.select();</xsl:attribute>
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('usernameInput', $encNum)"/>
                      </xsl:attribute>
                      <xsl:attribute name="maxlength">256</xsl:attribute>
                    </xsl:element>

                  </td>
                </tr>

                <tr>
                  <td>&#160;</td>
                  <td class="signInText" style="padding-left:1px;padding-top:5px;" id="passwordBox">
                    <xsl:value-of select="$stringsDoc//value[@key='password:']"/>
                  </td>
                  <td class="signInInput" style="padding-top:5px;">
                    <xsl:element name="input"> 
                      <xsl:attribute name="class">stdInput</xsl:attribute>
                      <xsl:attribute name="{$validateTag}">true</xsl:attribute>
                      <xsl:attribute name="rule-list">1</xsl:attribute>
                      <xsl:attribute name="caption-label">passwordBox</xsl:attribute>
                      <xsl:attribute name="style">border:1px solid #666666;width:178px;</xsl:attribute>
                      <xsl:attribute name="onkeypress">return checkEnter(event,<xsl:value-of select="$encNum"/>);</xsl:attribute>
                      <xsl:attribute name="onfocus">javascript:this.select();</xsl:attribute>
                      <xsl:attribute name="autocomplete">off</xsl:attribute>
                      <xsl:attribute name="type">password</xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('passwordInput', $encNum)"/>
                      </xsl:attribute>
                      <xsl:attribute name="maxlength">40</xsl:attribute>
                    </xsl:element>
                  </td>
                </tr>

                <tr>
                  <td>&#160;</td>
                  <td>&#160;</td>
                  <td>                
                    <div class="buttonSet buttonsAreLeftAligned" style="margin:0px;padding-top:13px;padding-left:4px;">
                      <div class="bWrapperUp bEmphasized">
                        <div>
                          <div>
                            <xsl:element name="button">
                              <xsl:attribute name="class">hpButton</xsl:attribute>
                              <xsl:attribute name="id">
                                <xsl:value-of select="concat('ID_LOGON', $encNum)"/>
                              </xsl:attribute>
                              <xsl:attribute name="onclick">return signIn(<xsl:value-of select="$encNum" />);</xsl:attribute>
                              <xsl:value-of select="$stringsDoc//value[@key='signIn']"/>
                            </xsl:element>
                          </div>
                        </div>
                      </div>
                      <div class="bWrapperUp">
                        <div>
                          <div>
                            <xsl:element name="button">
                              <xsl:attribute name="class">hpButton</xsl:attribute>
                              <xsl:attribute name="id">
                                <xsl:value-of select="concat('ID_CLEAR', $encNum)"/>
                              </xsl:attribute>
                              <xsl:attribute name="onclick">return clearLoginInputs(<xsl:value-of select="$encNum"/>);</xsl:attribute>
                              <xsl:value-of select="$stringsDoc//value[@key='clear']"/>
                            </xsl:element>
                          </div>
                        </div>
                      </div>
                    </div>
                  </td>
                </tr>
              </table>
            </td>            
          </xsl:otherwise>
        </xsl:choose>

        <!-- System information cell -->
        <td valign="top">
          <table cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td style="padding:10px 10px 10px 0px;" nowrap="true">
                <img src="{concat('/120814-042457/images/icon_server_lock', $imageType, '.gif')}" align="center" />               
              </td>
              <td style="padding:10px;vertical-align:middle;" nowrap="true">
                <xsl:value-of select="$stringsDoc//value[@key='linkedNotLoggedIn']" />
                <xsl:if test="$isTfaEnabled = 'true'">
                  <img style="vertical-align:middle;margin-left:5px;" title="{$stringsDoc//value[@key='twoFactorSecurity']}" src="/120814-042457/images/card-reader.gif" />
                </xsl:if>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
   </form>
  </xsl:template>

  <xsl:template name="nonLoadedEnclosure">
    <xsl:variable name="imageType">
      <xsl:choose>
        <xsl:when test="$encType=1">
          <xsl:choose>
            <xsl:when test="$isTower = 'true'">_tower</xsl:when>
            <xsl:otherwise>_c3000</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <!-- Front view cell -->
        <td width="224">
          <xsl:call-template name="enclosureBlankImage">
             <xsl:with-param name="type" select="$encType" />
             <xsl:with-param name="isTowerView" select="$isTower" />
           </xsl:call-template>
        </td>
        <td>
          <img src="/120814-042457/images/one_white.gif" width="30" />
        </td>
        <!-- Rear view cell -->
        <td width="224">
          <span class="whiteSpacer">&#160;</span>
          <br />
          <div style="width:224px;">
            <div class='buttonSet' style='margin:0px;'>
              <div class='bWrapperUp'>
                <div>
                  <div>
                    <xsl:element name='button'>                      
                      <xsl:attribute name='type'>button</xsl:attribute>
                      <xsl:attribute name='id'>
                        <xsl:value-of select='concat("ID_LOGON", $encNum)'/>
                      </xsl:attribute>
                      <xsl:attribute name='style'>padding-left:2px;padding-right:2px;</xsl:attribute>
                      <xsl:attribute name='class'>hpButton</xsl:attribute>
                      <xsl:attribute name='onclick'>dataLoadFunction(<xsl:value-of select="$encNum"/>, true);</xsl:attribute>
                      <xsl:value-of select="$stringsDoc//value[@key='loadEnclosureInfo']" />
                    </xsl:element>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </td>
        <td>
          <img src="/120814-042457/images/one_white.gif" width="30" />
        </td>
        <!-- System information cell -->
        <td style="text-align:left;vertical-align:top;width:100%;">
          <table cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td style="padding:10px 10px 10px 0px;" nowrap="true">
                <img src="/120814-042457/images/icon_server_32.gif" align="center"/>
              </td>
              <td style="padding:10px;vertical-align:middle;" nowrap="true">
                <xsl:value-of select="$stringsDoc//value[@key='linkedLoggedIn']" />
                <xsl:if test="$isTfaEnabled = 'true'">
                  <img style="vertical-align:middle;margin-left:5px;" title="{$stringsDoc//value[@key='twoFactorSecurity']}" src="/120814-042457/images/card-reader.gif" />
                </xsl:if>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>

  </xsl:template>
  
  <xsl:template name="enclosureBlankImage">
    <xsl:param name="type" />
    <xsl:param name="isTowerView" />
    
    <xsl:choose>
      <xsl:when test="$type=1">
        <xsl:choose>
          <xsl:when test="$isTowerView = 'true'">
            <div style="text-align:center; background-image:url(/120814-042457/images/enclosure_front_blank_tower.gif); width:138px; height:224px;"></div>
          </xsl:when>
          <xsl:otherwise>
            <div style="text-align:center; background-image:url(/120814-042457/images/enclosure_front_blank_c3000.gif); width:224px; height:138px;"></div>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <div style="text-align:center; background-image:url(/120814-042457/images/enclosure_front_blank.gif); width:224px; height:188px;"></div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
