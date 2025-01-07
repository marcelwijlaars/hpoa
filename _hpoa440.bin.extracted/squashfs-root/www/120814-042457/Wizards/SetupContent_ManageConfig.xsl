<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:param name="enclosureList" />
  <xsl:param name="oaSessionKey" />
  <xsl:param name="stringsDoc" />

	<xsl:template match="*">    
    
		<div id="stepInnerContent">
			<!-- Current step description text -->
			<div class="wizardTextContainer">
				
        <xsl:value-of select="$stringsDoc//value[@key='configManagePara1']"/><br />
				<span class="whiteSpacer">&#160;</span><br />
				
        <xsl:value-of select="$stringsDoc//value[@key='configManagePara2']"/><br />
				<span class="whiteSpacer">&#160;</span><br />
				<em>
          <xsl:value-of select="$stringsDoc//value[@key='note:']"/>&#160;
          <xsl:value-of select="$stringsDoc//value[@key='configManagePara3']"/>
			  </em><br />
			</div>
			
			<xsl:if test="count($enclosureList//enclosure[selected='true']) &gt; 1">

				<span class="whiteSpacer">&#160;</span>
				<br />

				<table cellpadding="0" cellspacing="0" border="0" ID="Table1">
					<tr>
						<td>							
							<xsl:value-of select="$stringsDoc//value[@key='configManagePara4']"/>
						</td>
						<td style="padding-left:10px;">
							<select ID="selectedEnclosure" NAME="selectedEnclosure" onchange="document.getElementById('scriptUploadForm').action = this.options[this.selectedIndex].value+'/cgi-bin/uploadConfig'; document.getElementById('oaSessionKey').value = this.options[this.selectedIndex].getAttribute('session-key'); transformUsbConfigForm(this.options[this.selectedIndex].getAttribute('encNum'));">

								<xsl:for-each select="$enclosureList//enclosure">
									<xsl:if test="selected='true'">
										<xsl:element name="option">
					                    
										<!-- we'll store the url,encNum and session key here, and update the form as each option is selected -->
										<xsl:attribute name="value"><xsl:value-of select="oaPath" /></xsl:attribute>
										<xsl:attribute name="encNum"><xsl:value-of select="enclosureNum" /></xsl:attribute>
										<xsl:attribute name="session-key"><xsl:value-of select="oaSessionKey" /></xsl:attribute>  										
					                    
										<!-- default to primary enclosure -->
										<xsl:if test="local='true'">
										  <xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>  
					                    
										<xsl:value-of select="concat($stringsDoc//value[@key='enclosure:'],' ', enclosureName)" />
	                    
										</xsl:element>
									</xsl:if>

								</xsl:for-each>

							</select>
						</td>
					</tr>
				</table>

			</xsl:if>
      
      <xsl:variable name="initialPath">
        <xsl:value-of select="concat($enclosureList//enclosure[local='true']/oaPath, '/cgi-bin/uploadConfig')"/>
      </xsl:variable>

			<span class="whiteSpacer">&#160;</span><br />
			<span class="whiteSpacer">&#160;</span><br />

			<div id="errorDisplay" class="errorDisplay"></div>

			<xsl:value-of select="$stringsDoc//value[@key='localFile:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='configScriptUploadDescription']"/></em><br />
			<span class="whiteSpacer">&#160;</span><br />

			<form name="scriptUploadForm" id="scriptUploadForm" target="ifrmSCRIPT_UPLOAD" action="{$initialPath}" method="post" enctype="multipart/form-data">

				<input type='hidden' name='oaSessionKey'  id='oaSessionKey' value='{$oaSessionKey}' />
				<input type='hidden' name='fileType' id='fileType' value='CONFIG_SCRIPT' />
				<input type='hidden' name='stylesheetUrl' id='stylesheetUrl' value='/120814-042457/Forms/UploadFileResponse.xsl' />

        
         <div class="groupingBox" style="width:500px;">
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
			
        <div align="right" style="width:500px;">
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
      <span class="whiteSpacer">&#160;</span><br />        
		  			
      <xsl:value-of select="$stringsDoc//value[@key='url:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='configScriptUrlDescription']"/></em><br />
		  <span class="whiteSpacer">&#160;</span><br />
      
		  <div class="groupingBox" style="width:500px;">
			  <div id="downloadErrorDisplay" class="errorDisplay"></div>
			  <table cellpadding="0" cellspacing="0" border="0">
				  <tr>
					  <td>
						  <table cellpadding="0" cellspacing="0" border="0" width="100%">
							  <tr>
								  <td id="lblUrl"><xsl:value-of select="$stringsDoc//value[@key='url:']" /></td>
								  <td width="10">&#160;</td>
								  <td>
									  <input class="stdInput" type="text" validate-download-script="true" rule-list="1" caption-label="lblUrl" name="configUrl" id="configUrl" size="50" />
								  </td>
							  </tr>
						  </table>
					  </td>
				  </tr>
			  </table>
		  </div>
		
		  <span class="whiteSpacer">&#160;</span><br />
      <div align="right" style="width:500px;">
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
			<div id="usbFormContainer" style="width: 500px;"></div>
		</div>
		
		<div id='waitContainer'></div>
	</xsl:template>
	
</xsl:stylesheet>

