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
	<xsl:include href="../Templates/firmwareStatusTable.xsl"/>
  
	<xsl:param name="stringsDoc" />
	<xsl:param name="oaSessionKey" />  
	<xsl:param name="oaInfoDoc" />
	<xsl:param name="oaStatusDoc" />
	<xsl:param name="enclosureStatusDoc" />
	<xsl:param name="firmwareManagementDoc" />
	<xsl:param name="oaUrl" />
	<xsl:param name="fwSyncSupported" select="'false'" />
	<xsl:param name="networkInfoDoc" />
  <xsl:param name="firmwareMgmtSupported" select="'false'" />
  
	<xsl:template match="*">

	    <xsl:variable name="activeBayNumber" select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole='ACTIVE']/hpoa:bayNumber" />
		<xsl:variable name="fwVersion" select="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=$activeBayNumber]/hpoa:fwVersion" />

		<xsl:variable name="hasMismatch" select="(count($oaStatusDoc//hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='firmwareMismatch' and .='ERROR']) &gt; 0)"/>
		
		<b><xsl:value-of select="$stringsDoc//value[@key='firmwareUpdate']" /></b><br />
		<span class="whiteSpacer">&#160;</span><br />

    <xsl:value-of select="$stringsDoc//value[@key='fwUpdateWebsite']" />
    <span class="whiteSpacer">&#160;</span>
    <a href="http://www.hp.com/go/oa" target="_blank">http://www.hp.com/go/oa</a><br />
    <br />

    <xsl:value-of select="$stringsDoc//value[@key='fwUpdatePlsnote']" /><br />

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />


	<xsl:element name="div">
		<xsl:attribute name="id">syncNeededMessage</xsl:attribute>

		<xsl:if test="not($hasMismatch)">
			<xsl:attribute name="style">display:none;</xsl:attribute>
		</xsl:if>

		<xsl:value-of select="$stringsDoc//value[@key='firmwareInfo']" />:<em>
			<xsl:value-of select="$stringsDoc//value[@key='mismatchFirmwareVersion']" />
			<xsl:if test="$fwSyncSupported='true'">
				<xsl:value-of select="$stringsDoc//value[@key='syncFirmwareDesc']" />
			</xsl:if>
		</em>
	</xsl:element>
	<xsl:element name="div">

		<xsl:attribute name="id">fwInformationLabel</xsl:attribute>
		<xsl:if test="$hasMismatch">
			<xsl:attribute name="style">display:none;</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="$stringsDoc//value[@key='firmwareInfo']" />
	</xsl:element>
		
    <span class="whiteSpacer">&#160;</span><br />
    
    <div class="errorDisplay" id="syncErrorDisplay"></div>

	<div id="firmwareTableContainer">
		<xsl:call-template name="firmwareStatusTable"></xsl:call-template>
	</div>
		
    <span class="whiteSpacer">&#160;</span>
    <br />
 
		<xsl:element name="div">
			<xsl:attribute name="align">right</xsl:attribute>
			<xsl:attribute name="id">syncButtonWrapper</xsl:attribute>

			<xsl:choose>
				<xsl:when test="($hasMismatch='true' and $fwSyncSupported='true')">
					<xsl:attribute name="style">display:block;</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style">display:none;</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<div class='buttonSet' style="margin-bottom:0px;">
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnSync" onclick="syncFirmware();">
								<xsl:value-of select="$stringsDoc//value[@key='syncFirmware']" />
							</button>
						</div>
					</div>
				</div>
			</div>
			
		</xsl:element>
	
    <hr />
    
    <xsl:if test="number($fwVersion) &gt;= number('1.20')">

      <span class="whiteSpacer">&#160;</span>
      <br />

      <table cellpadding="0" cellspacing="0" border="0">
        <TR>
          <TD valign="top">
			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="id">chkForceDowngrade</xsl:attribute>
				<xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
					<xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="onClick">showVcmOaMinFwVerNote()</xsl:attribute>
			</xsl:element>
          </TD>
          <TD width="5">&#160;</TD>
          <TD>
			<label for="chkForceDowngrade">
				<xsl:value-of select="$stringsDoc//value[@key='forceDowngrade:']"/>&#160;
				<xsl:call-template name="fipsHelpMsg">
					<xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']" />
					<xsl:with-param name="msgType">tooltip</xsl:with-param>
					<xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']!='FIPS-ON' and $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']!='FIPS-DEBUG'">
					<em><xsl:value-of select="$stringsDoc//value[@key='forceDowngradeDescription']" /></em>
				</xsl:if>
			</label>
          </TD>
        </TR>
      </table>

      <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']!='FIPS-ON' and $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']!='FIPS-DEBUG'">
        <div id="vcmOaMinFwVerDisplay" style="display:none"></div>
      </xsl:if>
    </xsl:if>
    

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<form id="firmwareUpdateForm" target="ifrmFIRMWARE_UPLOAD" action="{concat($oaUrl,'/cgi-bin/uploadFile')}" method="POST" ENCTYPE="multipart/form-data">

			<input type='hidden' name='oaSessionKey'  id='oaSessionKey' value='{$oaSessionKey}' />
			<input type='hidden' name='fileType' id='fileType' value='FIRMWARE_IMAGE' />
			<input type='hidden' name='stylesheetUrl' id='stylesheetUrl' value='/120814-042457/Forms/UploadFileResponse.xsl' />
			
			<xsl:value-of select="$stringsDoc//value[@key='localFile:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='imageFileDescription']" />&#160;
        <xsl:value-of select="$stringsDoc//value[@key='pleaseNote:']" />
        <xsl:value-of select="$stringsDoc//value[@key='imageFileNote']"/>
      </em>
      <br />
			<span class="whiteSpacer">&#160;</span><br />
			
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
												<td><input validate-file="true" rule-list="1" caption-label="lblFile" type="file" id="file" name="file" size="50" /></td>
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
	                    <button type='button' class='hpButton' onclick="return checkFileInput();">
	                        <xsl:value-of select="$stringsDoc//value[@key='upload']" />
	                    </button>
	                </div>
	                </div>
	            </div>
	            </div>
	        </div>
	    </form>
        
        <span class="whiteSpacer">&#160;</span><br />
        
        <xsl:value-of select="$stringsDoc//value[@key='imageURL:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='imageURLDescription']" /></em><br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<div class="groupingBox">
			<div id="urlErrorDisplay" class="errorDisplay"></div>
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td id="lblUrl"><xsl:value-of select="$stringsDoc//value[@key='url:']" /></td>
								<td width="10">&#160;</td>
								<td>
									<input type="text" validate-url="true" rule-list="1;8" caption-label="lblUrl" name="fileUpdateUrl" id="fileUpdateUrl" size="50" style="margin:2px;" />
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
                    <button type='button' class='hpButton' id="btnSetProtocols" onclick="updateFirmware();">
                        <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                    </button>
                </div>
                </div>
            </div>
            </div>
        </div>

		<div id="usbUpdateContainer"></div>

    <xsl:if test="number($fwVersion) &gt;= number('3.35') and $firmwareMgmtSupported = 'true'">
		  <xsl:for-each select="$firmwareManagementDoc//hpoa:firmwareManagementSettings">

			  <span class="whiteSpacer">&#160;</span>
			  <br />
			  <span class="whiteSpacer">&#160;</span>
			  <br />
			  <xsl:value-of select="$stringsDoc//value[@key='firmwareManagement']" />:&#160;<em><xsl:value-of select="$stringsDoc//value[@key='fwIsoOaDesc']" /></em>
			  <br />
			  <span class="whiteSpacer">&#160;</span>
			  <br />
			  <div class="groupingBox">
				  <div id="fwMgmtErrorDisplay" class="errorDisplay"></div>

				  <xsl:choose>
					  <xsl:when test="hpoa:fwManagementEnabled='true'">
					  <span id="fwIsoOaVer" style="visibility=hidden">
						 <xsl:value-of select="$stringsDoc//value[@key='fwIsoOaVer']" />&#160;<b><span id="oaVersion"><xsl:value-of select="hpoa:oaVersion"/></span></b>
					  </span>
					  <span id="noFwIsoOaVer" style="visibility=visible">
						  <xsl:value-of select="$stringsDoc//value[@key='fwIsoOaUpdate1']" />
					  </span>
					  </xsl:when>
					  <xsl:otherwise>
						  <xsl:value-of select="$stringsDoc//value[@key='fwIsoOaUpdate2']" />
					  </xsl:otherwise>
				  </xsl:choose>

			  </div>

			  <xsl:if test="hpoa:fwManagementEnabled='true'">
				  <span class="whiteSpacer">&#160;</span>
				  <br />
				  <div align="right">
					  <div class='buttonSet' style="margin-bottom:0px;">
						  <div class='bWrapperUp'>
							  <div>
								  <div>
									  <button type='button' class='hpButton' id="" onclick="updateFirmwareEFM();">
										  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
									  </button>
								  </div>
							  </div>
						  </div>
					  </div>
				  </div>
			  </xsl:if>
			
		  </xsl:for-each>
    </xsl:if>

	</xsl:template>
	

</xsl:stylesheet>

