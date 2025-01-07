<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
    
  <xsl:include href="../Templates/guiConstants.xsl" />

  <!-- parameters for post back -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="accessLevel" />
  <xsl:param name="oaAccess" />
  <xsl:param name="oaSessionKey" />
  <xsl:param name="oaUrl" />
  <xsl:param name="fileType" />
  <xsl:param name="stylesheet">/120814-042457/Forms/UploadFileResponse.xsl</xsl:param>

  <xsl:template name="LcdBackgroundImage" match="*">
    
    <xsl:variable name="disabled">
      <xsl:choose>
        <xsl:when test="($accessLevel = $USER) or ($oaAccess = false())">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <form target="iframeHidden" name="frmUpload" id="frmUpload" method='POST' enctype='multipart/form-data' action="{concat($oaUrl,'/cgi-bin/uploadFile')}">
      <input type='hidden' name ='oaSessionKey' id='oaSessionKey' value='{$oaSessionKey}' />
      <input type='hidden' name='fileType' id='fileType' value='{$fileType}' />
      <input type='hidden' name='stylesheetUrl' id='stylesheetUrl' value='{$stylesheet}' />
      <table style="border:0px;padding:0px;width:100%;">
        <tr>
          <td colspan="3">
            <xsl:value-of select="$stringsDoc//value[@key='lcdImageInstruction']"/>
            <br />
            <br />
          </td>
        </tr>
        <tr>
          <td style="padding-bottom:3px;white-space:nowrap;">
            <label devid="chatMode" id="lblFile" for="file">
              <xsl:value-of select="$stringsDoc//value[@key='localFile:']"/>
            </label>
          </td>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="type">file</xsl:attribute>
              <xsl:attribute name="size">40</xsl:attribute>              
              <xsl:attribute name="name">file</xsl:attribute>
              <xsl:attribute name="validate-me">true</xsl:attribute>
              <xsl:attribute name="rule-list">1</xsl:attribute>
              <xsl:attribute name="caption-label">lblFile</xsl:attribute>              
              <xsl:choose>
                <xsl:when test="$disabled = 'true'">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="style">width:300px;margin-left:5px;</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="id">file</xsl:attribute>
                  <xsl:attribute name="style">border:1px solid #7F9D89;width:300px;margin-left:5px;</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </td>
          <td></td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td width="100%">
            <div class="buttonSet" style="margin-top:10px;">
              <div class="bWrapperUp">
                <div>
                  <div>
                    <xsl:element name="button">
                      <xsl:attribute name="type">submit</xsl:attribute>
                      <xsl:attribute name="onclick">return submitMe(true);</xsl:attribute>
                      <xsl:attribute name="class">hpButton</xsl:attribute>
                      <xsl:attribute name="id">btnApplyBackground</xsl:attribute>
                      <xsl:if test="$disabled = 'true'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$stringsDoc//value[@key='apply']"/>
                    </xsl:element>
                  </div>
                </div>
              </div>
              <div class="bWrapperUp">
                <div>
                  <div>
                    <xsl:element name="button">
                      <xsl:attribute name="onclick">return previewUsernotes();</xsl:attribute>
                      <xsl:attribute name="class">hpButton</xsl:attribute>
                      <xsl:attribute name="id">btnPreview</xsl:attribute>
                      <xsl:if test="$disabled = 'true'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$stringsDoc//value[@key='viewUserNote']"/>
                    </xsl:element>
                  </div>
                </div>
              </div>
              <div class="bWrapperUp">
                <div>
                  <div>
                    <xsl:element name="button">
                      <xsl:attribute name="onclick">return submitMe(false);</xsl:attribute>
                      <xsl:attribute name="class">hpButton</xsl:attribute>
                      <xsl:attribute name="id">btnRemoveBackground</xsl:attribute>
                      <xsl:if test="$disabled = 'true'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$stringsDoc//value[@key='default']"/>
                    </xsl:element>  
                  </div>
                </div>
              </div>
            </div>
          </td>
          <td width="100%">&#160;</td>
        </tr>
      </table>
    </form>
  </xsl:template>

</xsl:stylesheet>


