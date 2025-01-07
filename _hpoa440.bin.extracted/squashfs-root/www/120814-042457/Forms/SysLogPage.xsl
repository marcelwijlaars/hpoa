<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl"/>
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="serviceUserAcl" />
        <xsl:param name="logType" select="''" />
	<xsl:param name="logTitle" select="''" />
  <xsl:param name="clearAllSupported" select="'false'" />
  
	<xsl:template match="*">
        
        <b>
			<xsl:choose>
				<xsl:when test="$logTitle=''">
					<xsl:value-of select="$stringsDoc//value[@key='systemLog']" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$logTitle" />
				</xsl:otherwise>
			</xsl:choose>
		</b><br />
	    <span class="whiteSpacer">&#160;</span><br />
        <!-- use wrap='off' for horizontal scroll bar / prevent line wrapping (mds) -->
        <textarea wrap="off" class="stdInput" style="line-height:150%;width:100%;font-size:9pt;" readonly="true" rows="24" id="sysLogText"></textarea>

		<xsl:if test="$serviceUserAcl != $USER">
      <xsl:variable name="clearFunction">
        <xsl:choose>
            <xsl:when test="$logType=''">
                    clearOASyslog();
            </xsl:when>
            <xsl:when test="$logType='FIRMWARE_MGMT'">
                    clearFirmwareMgmtLog();
            </xsl:when>
        </xsl:choose>
      </xsl:variable>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnApplyDateTime" onclick="{$clearFunction}">
									<xsl:value-of select="$stringsDoc//value[@key='clearLog']" />
								</button>
							</div>
						</div>
					</div>
          <xsl:if test="$logType='FIRMWARE_MGMT' and $clearAllSupported='true'">
            <div class="bWrapperUp">
						  <div>
							  <div>
								  <button class="hpButton" id="btnClearAll" onclick="clearAllLogs();" >
									  <xsl:value-of select="$stringsDoc//value[@key='clearAllLogs']" />
								  </button>
							  </div>
						  </div>
					  </div>
          </xsl:if>
					<div class="bWrapperUp">
						<div>
							<div>
								<button class="hpButton" id="btnRefresh" onclick="refreshPage();" >
									<xsl:value-of select="$stringsDoc//value[@key='refresh']" />
								</button>
							</div>
						</div>
					</div>        
        </div>
			</div>
		</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>

