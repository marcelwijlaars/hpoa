<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:param name="oaSessionKey" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="oaUrl" />
  <xsl:param name="usbConfigScriptDoc" />

	<xsl:template match="*">    
    
    <b><xsl:value-of select="$stringsDoc//value[@key='configurationScripts']"/></b><br />
		<span class="whiteSpacer">&#160;</span><br />
    <xsl:value-of select="$stringsDoc//value[@key='configurationScriptsDesc']"/><br />
	  <span class="whiteSpacer">&#160;</span><br />
		<em><xsl:value-of select="$stringsDoc//value[@key='note:']"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='configurationScriptsNote']"/>
		</em><br />
			<span class="whiteSpacer">&#160;</span><br />
    
    <xsl:variable name="queryString">
      <xsl:choose>
        <xsl:when test="$oaSessionKey != ''">
          <xsl:value-of select="concat('?oaSessionKey=', $oaSessionKey, '&amp;', 'stylesheetUrl=/120814-042457/Templates/cgiResponse')"/>
				</xsl:when>
				<xsl:otherwise>?stylesheetUrl=/120814-042457/Templates/cgiResponse</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

<!--
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="concat($oaUrl,'/cgi-bin/getConfigScript',$queryString)"/></xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:value-of select="$stringsDoc//value[@key='clickHere']"/>
		</xsl:element> -->
		

    <a id="link" href="javascript:load_config_script();"><xsl:value-of select="$stringsDoc//value[@key='showConfig']"/></a>

    <xsl:value-of select="$stringsDoc//value[@key='configurationScriptsView1']"/><br />
		<span class="whiteSpacer">&#160;</span><br />   
<!--
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="concat($oaUrl,'/cgi-bin/showAll',$queryString)"/>
			</xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:value-of select="$stringsDoc//value[@key='clickHere']"/>
		</xsl:element> -->
		
    <a id="link" href="javascript:load_show_all();"><xsl:value-of select="$stringsDoc//value[@key='showAll']"/></a>
		<xsl:value-of select="$stringsDoc//value[@key='configurationScriptsView2']"/><br />
		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />
    
		<div id="errorDisplay" class="errorDisplay"></div>

		<xsl:value-of select="$stringsDoc//value[@key='localFile:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='configScriptUploadDescription']"/></em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<form name="scriptUploadForm" id="scriptUploadForm" target="ifrmSCRIPT_UPLOAD" action="{concat($oaUrl,'/cgi-bin/uploadConfig')}" method="POST" ENCTYPE="multipart/form-data">
      <xsl:if test="$oaSessionKey != ''">
        <input type='hidden' name='oaSessionKey'  id='oaSessionKey' value='{$oaSessionKey}' /> 
      </xsl:if>			
			<input type='hidden' name='fileType' id='fileType' value='CONFIG_SCRIPT' />
			<input type='hidden' name='stylesheetUrl' id='stylesheetUrl' value='/120814-042457/Forms/UploadFileResponse.xsl' />

      
       <div class="groupingBox">
        <div id="uploadErrorDisplay" class="errorDisplay"></div>
			  <table cellpadding="0" cellspacing="0" border="0">
				  <tr>
					  <td>
						  <table cellpadding="0" cellspacing="0" border="0">
							  <tr>
								  <td>
									  <table cellpadding="0" cellspacing="0" border="0" width="100%">
										  <tr>
											  <td id="lblFile"><xsl:value-of select="$stringsDoc//value[@key='file:']" /></td>
											  <td width="10">&#160;</td>
											  <td><input class="stdInput" validate-upload-script="true" caption-label="lblFile" type="file" id="file" name="file" size="50" /></td>
											  <span class="whiteSpacer">&#160;</span><br />
																							  
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
                  <button type='button' class='hpButton'  id="btnUpload" onclick="return submitConfigScript();">
                      <xsl:value-of select="$stringsDoc//value[@key='upload']" />
                  </button>
              </div>
              </div>
          </div>
          </div>
      </div>        
      
      <iframe onload="try{{postFrameLoaded(this.contentWindow.document);}}catch(e){{}}" scrolling="no" src="../html/blank.html" id="ifrmSCRIPT_UPLOAD" name="ifrmSCRIPT_UPLOAD" width="0" height="0" frameborder="no"></iframe>
      
     </form>
    
    <span class="whiteSpacer">&#160;</span><br />        
	  			
    <xsl:value-of select="$stringsDoc//value[@key='url:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='configScriptUrlDescription']"/></em><br />
	  <span class="whiteSpacer">&#160;</span><br />
    
	  <div class="groupingBox">
		  <div id="downloadErrorDisplay" class="errorDisplay"></div>
		  <table cellpadding="0" cellspacing="0" border="0">
			  <tr>
				  <td>
					  <table cellpadding="0" cellspacing="0" border="0" width="100%">
						  <tr>
							  <td id="lblUrl"><xsl:value-of select="$stringsDoc//value[@key='url:']" /></td>
							  <td width="10">&#160;</td>
							  <td>
								  <input class="stdInput" type="text" validate-download-script="true" rule-list="1" caption-label="lblUrl" name="configUrl" id="configUrl" size="50" style="margin:2px;" />
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
                <button type='button' class='hpButton' id="btnDownload" onclick="return downloadConfigScript();">
                    <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                </button>
            </div>
            </div>
        </div>
        </div>
    </div>

		<div id="usbConfigContainer"></div>

	</xsl:template>
	
</xsl:stylesheet>

