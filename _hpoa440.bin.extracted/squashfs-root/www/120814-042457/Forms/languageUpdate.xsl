<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	  <!--
		  (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	  -->
    <xsl:include href="../Templates/guiConstants.xsl"/>
    <xsl:include href="../Templates/globalTemplates.xsl"/>
	
    <xsl:param name="availableLanguagesDoc" />
    <xsl:param name="preferredLanguage" />
    <xsl:param name="stringsDoc" />
  	<xsl:param name="oaSessionKey" /> 
    <xsl:param name="isSupported" />
    <xsl:param name="isLocal" />
    <xsl:param name="oaUrl" />
  
    <xsl:variable name="LANG_PK_DOWNLOAD_URL" select="'http://www.hp.com/go/oa'" />
  
    <xsl:template name="langugePackForm" match="*">      
      <xsl:choose>
        <!-- only supported on 3.80+ -->
        <xsl:when test="$isSupported != 'true'">
          <xsl:call-template name="notifyLanguagePacksUnsupported" />
        </xsl:when>
        <xsl:otherwise>
          <!-- change language notice here -->
          <xsl:call-template name="languageTableHeader" />
          
          <!-- language table here -->
          <xsl:call-template name="languageTable" />
          
          <!-- add language header -->
          <xsl:call-template name="addLanguageHeader" />
          
          <!-- file upload here -->
           <xsl:call-template name="uploadLanguagePack" />
          
          <!-- file download here -->
           <xsl:call-template name="downloadLanguagePack" />    
          
          <!-- download link here -->
          <xsl:call-template name="downloadLink" />
          
        </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
  
  
  <!-- 
        Section: CHANGE CURRENT LANGUAGE
        Notes  : only supported on the primary OA. 
  -->  
  <xsl:template name="languageTableHeader">      
    <h5 style="margin-bottom:5px;"><xsl:value-of select="$stringsDoc//value[@key = 'availableLanguages']" /></h5>
      
    <div class="errorDisplay" id="languageTableErrorDisplay"></div>
    
    <xsl:choose>
      <xsl:when test="$isLocal = 'true'">
        <em><xsl:value-of select="$stringsDoc//value[@key = 'primaryOaLanguageChangeNotice']" /> 
        <a href="javascript:void(0);" onclick="window.location='../html/userPrefs.html';"><xsl:value-of select="$stringsDoc//value[@key = 'userPreferences']" /></a></em>       
      </xsl:when>      
      <xsl:otherwise>
        <em><xsl:value-of select="$stringsDoc//value[@key = 'linkedOaLanguageChangeNotice']" /></em>
      </xsl:otherwise>
    </xsl:choose>
    <span class="whiteSpacer">&#160;</span><br />    
  </xsl:template>
  
  <!-- 
        Section: ADD LANGUAGE HEADER
        Notes  : shows title and description. 
  -->  
  <xsl:template name="addLanguageHeader">
    <h5 style="margin-bottom:5px;"><xsl:value-of select="$stringsDoc//value[@key='addLanguagePack']" /></h5>
    <xsl:value-of select="$stringsDoc//value[@key='addLanguagePackDesc']" /><br />
    <xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='addLanguagePackNote']" /></em>
    <br />
    <span class="whiteSpacer">&#160;</span><br />
    <span class="whiteSpacer">&#160;</span><br />
  </xsl:template>
    
      
  <!-- 
        Section: LANGUAGE DISPLAY TABLE
        Notes  : shows embedded and installed language packs. 
  -->     
  <xsl:template name="languageTable">
    <table onclick="updateButtons(this.getElementsByTagName('input'));" align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" id="tblAvailLang" style="margin-top:5px;">
      <tbody>        
        <tr class="captionRow">
          <th width="10">&#160;</th>
          <th class="propertyName" style="width:25%;">
            <xsl:value-of select="$stringsDoc//value[@key = 'language']" />
          </th>
          <th class="propertyName" style="width:25%;">
            <xsl:value-of select="$stringsDoc//value[@key = 'translatedName']" />
          </th>
          <th class="propertyName" style="width:25%;">
            <xsl:value-of select="$stringsDoc//value[@key = 'languageVersion']" />
          </th>
          <th class="propertyName" style="width:25%;">
            <xsl:value-of select="$stringsDoc//value[@key = 'fileName']" />
          </th>
        </tr>        
        <xsl:for-each select="$availableLanguagesDoc//hpoa:language">
          <tr style="vertical-align:middle;">
            <td style="vertical-align:middle;">
              <xsl:choose>
                <xsl:when test="hpoa:filename = 'Embedded'">
                  <input type="checkbox" disabled="disabled" lang-code="{hpoa:code}" />
                </xsl:when>
                <xsl:otherwise>
                  <input type="checkbox" rowselector="yes" lang-code="{hpoa:code}" />
                </xsl:otherwise>
              </xsl:choose>              
            </td>
            <td class="propertyValue" style="vertical-align:middle;">
              <xsl:value-of select="concat(hpoa:name, ' [', hpoa:code, ']')" />
            </td>
            <td class="propertyValue" style="vertical-align:middle;">
              <xsl:value-of select="hpoa:localized" />
            </td>
            <td class="propertyValue" style="vertical-align:middle;">
              <xsl:value-of select="concat(hpoa:version, ' ', hpoa:buildTime)" />
            </td>
            <td class="propertyValue" style="vertical-align:middle;">
              <xsl:value-of select="hpoa:filename" />
            </td>
          </tr>         
        </xsl:for-each>
      </tbody>
    </table>
    <span class="whiteSpacer">&#160;</span>
    <br />
    <div align="right">
      <div class='buttonSet' style="margin-bottom:0px;">
        <div class='bWrapperUp'>
          <div>
            <div>
              <button type='button' disabled="disabled" class='hpButton' id="btnRemove" onclick="removeLanguagePack();">
                <xsl:value-of select="$stringsDoc//value[@key='remove']" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <span class="whiteSpacer">&#160;</span><br />   
  </xsl:template>

      <!-- 
            Section: UPLOAD LANGUAGE PACK
            Notes  : supports primary and linked OAs. 
      -->      
   <xsl:template name="uploadLanguagePack">	
    <xsl:value-of select="$stringsDoc//value[@key = 'upload:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='uploadLanguagePackDesc']" /></em>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
     
    <form id="uploadLanguageForm" target="ifrmLANGUAGE_UPLOAD" action="{concat($oaUrl,'/cgi-bin/uploadFile')}" method="POST" ENCTYPE="multipart/form-data">
      
      <input type='hidden' name='oaSessionKey'  id='oaSessionKey' value='{$oaSessionKey}' />
			<input type='hidden' name='fileType' id='fileType' value='LANGUAGE-PACK_FILE' />
			<input type='hidden' name='stylesheetUrl' id='stylesheetUrl' value='/120814-042457/Forms/UploadFileResponse.xsl' />
      
      <div class="groupingBox">
        <div id="uploadLangPackErrorDisplay" class="errorDisplay"></div>
        <table cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td>
              <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td>
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                      <tr>
                        <td id="lblFile">
                          <xsl:value-of select="$stringsDoc//value[@key='file:']" />
                        </td>
                        <td width="10">&#160;</td>
                        <td>
                          <input validate-lang-pack="true" rule-list="1" caption-label="lblFile" type="file" id="file" name="file" size="85" />
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
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
                <button type='button' class='hpButton' onclick="return checkLanguagePackInput();">
                  <xsl:value-of select="$stringsDoc//value[@key='upload']" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form>

    <span class="whiteSpacer">&#160;</span><br />
      
  </xsl:template>
  
  
      
  <!-- 
        Section: DOWNLOAD LANGUAGE PACK
        Notes  : supports primary and linked OAs. 
  -->    
  <xsl:template name="downloadLanguagePack">    
    <xsl:value-of select="$stringsDoc//value[@key = 'download:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key = 'downloadLanguagePackDesc']" /></em>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />

    <div class="groupingBox">
      <div id="downloadLangPackErrorDisplay" class="errorDisplay"></div>
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
              <tr>
                <td id="lblUrl">
                  <xsl:value-of select="$stringsDoc//value[@key='url:']" />
                </td>
                <td width="10">&#160;</td>
                <td>
                  <input type="text" validate-download="true" rule-list="1;8" caption-label="lblUrl" name="downloadUrl" id="downloadUrl" size="80" />
                </td>
              </tr>
            </table>
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
              <button type='button' class='hpButton' id="btnApplyDownload" onclick="downloadLanguagePack();">
                <xsl:value-of select="$stringsDoc//value[@key='apply']" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>
  
   <!-- 
      Section: DOWNLOAD LINK
      Notes  : leave url variable empty to prevent displaying this section.
  -->
  <xsl:template name="downloadLink">
    <xsl:if test="$LANG_PK_DOWNLOAD_URL != ''">
      <br />
      <br />
      <xsl:value-of select="$stringsDoc//value[@key='languagePacksDownloadHere']" />
      <a href="{$LANG_PK_DOWNLOAD_URL}" target="_new"><xsl:value-of select="$LANG_PK_DOWNLOAD_URL" /></a>
    </xsl:if>
  </xsl:template>
  
  <!-- 
      Section: NO SUPPORT WARNING
      Notes  : OA versions older than 3.80 do not support language packs.
  -->
  <xsl:template name="notifyLanguagePacksUnsupported">
    <div id="activeWarningMessage" style="width:auto;margin-bottom:10px;padding:10px;border:1px solid #ccc;display:block;">
      <table cellpadding="0" cellspacing="0" border="0" width="auto">
        <tr>
          <td style="vertical-align:top;">
            <img border="0" src="/120814-042457/images/status_minor_32.gif"/>
          </td>
          <td style="padding-left:10px;width:98%;vertical-align:middle;">
            <xsl:value-of select="$stringsDoc//value[@key='languagePackUnsupported']" />
            <br />
          </td>
        </tr>
      </table>
    </div>  
  </xsl:template>
 
</xsl:stylesheet>
