<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:include href="../Templates/guiConstants.xsl" />
  
  <xsl:param name="availableLanguagesDoc" />
  <xsl:param name="preferredLanguage" />
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="serviceUserOaAccess" />
	<xsl:param name="timeoutPref" />
	<xsl:param name="stringsDoc" />
  
  <xsl:variable name="langPacksInstalled" select="count($availableLanguagesDoc//hpoa:language[hpoa:filename != 'Embedded'])" />
    
	<xsl:template name="userPrefs" match="*">

		<b><xsl:value-of select="$stringsDoc//value[@key='appDisplayLang:']"/></b>&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='appDisplayLangDesc']"/>
		  </em><br />
      <span class="whiteSpacer">&#160;</span>
      <br />
    
      <xsl:if test="$serviceUserAcl!=$USER and $serviceUserOaAccess='true'">
        <xsl:value-of select="$stringsDoc//value[@key='pleaseGoToPrimaryOA']" />
        <a href="javascript:void(0);" onclick="selectLanguageUpdatePage();"><xsl:value-of select="$stringsDoc//value[@key='languagePack']" /></a>
        <xsl:value-of select="$stringsDoc//value[@key='screenToManageLangPacks']" />
        <br />
        <span class="whiteSpacer">&#160;</span>
        <br />
      </xsl:if>
      
    
        <div class="groupingBox">

            <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td>
						<xsl:value-of select="$stringsDoc//value[@key='availLang:']"/>
                    </td>
                    <td width="10">
                        &#160;
                    </td>
                    <td style="vertical-align:middle;">
                        <xsl:element name="select">
                          <xsl:attribute name="id">languages</xsl:attribute>
                          <xsl:attribute name="name">languages</xsl:attribute>
                          
                          <xsl:if test="$langPacksInstalled = 0">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                         
                            <option value="-"><xsl:value-of select="$stringsDoc//value[@key='langUseBrowser']"/></option>
                            <xsl:for-each select="$availableLanguagesDoc//hpoa:language">
                                <xsl:element name="option">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hpoa:code" />
                                    </xsl:attribute>

                                    <xsl:if test="hpoa:code = $preferredLanguage">
                                        <xsl:attribute name="selected">true</xsl:attribute>
                                    </xsl:if>
                                    
                                    <xsl:value-of select="concat(hpoa:name, ' [', hpoa:code, ']')" />
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                      
                        <xsl:if test="$langPacksInstalled = 0">
                          <img src="/120814-042457/images/icon_status_informational.gif" style="vertical-align:middle;margin-left:5px;margin-right:5px;" />
                          <em><xsl:value-of select="$stringsDoc//value[@key='noLanguagePacksInstalled']" /></em>
                        </xsl:if>
                    </td>
                </tr>
            </table>
            
        </div>

        <span class="whiteSpacer">&#160;</span><br />
        <div align="right">
            <div class='buttonSet' style="margin-bottom:0px;">
                <div class='bWrapperUp'>
                    <div>
                        <div>
                          <xsl:choose>
                            <xsl:when test="$langPacksInstalled &gt; 0">
                              <button type='button' class='hpButton' onclick='setLanguagePreference();'><xsl:value-of select="$stringsDoc//value[@key='apply']"/></button>
								            </xsl:when>
                            <xsl:otherwise>
                              <button type='button' class='hpButton' onclick='setLanguagePreference();' disabled="disabled"><xsl:value-of select="$stringsDoc//value[@key='apply']"/></button>
                            </xsl:otherwise>
                          </xsl:choose>                         
                        </div>
                    </div>
                </div>
                <div class='bWrapperUp'>
                    <div>
                        <div>                          
                          <button type='button' class='hpButton' onclick='top.refreshStrings();'><xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']"/></button>								                              
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
	</xsl:template>
  
</xsl:stylesheet>
