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
	<xsl:include href="../Forms/ServerSelect.xsl" />
	<xsl:include href="../Forms/InterconnectSelect.xsl" />
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureType" select="0" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="numIoBays" select="8" />
	<xsl:param name="numDeviceBays" select="16" />
	<xsl:param name="encNum" />
	<xsl:param name="fwManagementSettings" />
	<xsl:param name="virtualMediaUrlListDoc" />
	<xsl:param name="oaMediaDeviceList" />
  <xsl:param name="activeSupported" />

	<xsl:param name="serviceUserAcl" />
	<xsl:param name="templatePart" select="'ALL'"/>
	<xsl:template match="*">
    <xsl:choose>
      <xsl:when test="$templatePart='URL_STATUS'">
          <xsl:call-template name="urlStatus"/>
      </xsl:when>
      <xsl:when test="$templatePart='DVD_INFO'">
          <xsl:call-template name="dvdInfo"/>
      </xsl:when>
      <xsl:when test="$activeSupported = 'false'">
        <b><xsl:value-of select="$stringsDoc//value[@key='firmwareManagement']"/></b><br />
        <span class="whiteSpacer">&#160;</span>
        <br />

        <div id="activeWarningMessage" style="width:auto;margin-bottom:10px;padding:10px;border:1px solid #ccc;display:block;">
          <table cellpadding="0" cellspacing="0" border="0" width="auto">
            <tr>
              <td style="vertical-align:top;">
                <img border="0" src="/120814-042457/images/status_minor_32.gif"/>
              </td>
              <td style="padding-left:10px;width:98%;vertical-align:middle;">
                <xsl:value-of select="$stringsDoc//value[@key='efmActiveOaNotSupported']"/>&#160;
                <a href="javascript:void(0);" onclick="top.mainPage.getHelpLauncher().openContextHelp();"><img src="/120814-042457/images/icon_help_square.gif" title="{$stringsDoc//value[@key='mnuHelp']}" style="width:12px;height:12px;margin-bottom:-2px;border:0px;"/></a>
                <br />
              </td>
            </tr>
          </table>
        </div>
        <br /> 
      </xsl:when>
    <xsl:otherwise>
		<xsl:variable name="hasVirtualMedia" select="count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value!=' ' and @hpoa:value!='']) &gt; 0" />
		<xsl:variable name="firmwareIsoUrl" select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:isoUrl" />
		
		<b><xsl:value-of select="$stringsDoc//value[@key='firmwareManagement']"/></b><br />
		<span class="whiteSpacer">&#160;</span><br />  

		<div class="errorDisplay" id="generalErrorDisplay"></div>

		<xsl:value-of select="$stringsDoc//value[@key='settings:']"/>&#160;
      <em>
        <xsl:value-of select="$stringsDoc//value[@key='firmwareMgmtDesc']"/>
        <xsl:value-of select="$stringsDoc//value[@key='latestIsoDownloadsHere:']"/>&#160;
        <a href="http://www.hp.com/go/spp/download" target="_blank">http://www.hp.com/go/spp/download</a>
      </em>
    <br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<div class="groupingBox">

      <div id="standbyWarningMessage" style="-moz-box-sizing:border-box;-webkit-box-sizing:border-box;width:auto;margin-bottom:10px;padding:10px;border:1px solid #ccc;display:none;">
        <table cellpadding="0" cellspacing="0" border="0" width="auto">
          <tr>
            <td style="vertical-align:top;">
              <img border="0" src="/120814-042457/images/status_minor_32.gif"/>
            </td>
            <td style="padding-left:10px;width:98%;">
              <xsl:value-of select="$stringsDoc//value[@key='efmStandbyOaNotSupported']"/>
              <br />
            </td>
          </tr>
        </table>
      </div>

			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="id">fwManagementEnabled</xsl:attribute>
				<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:fwManagementEnabled='true'">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
        <xsl:attribute name="onclick">toggleFormEnabled('fwmgmtSettingsForm', this.checked);</xsl:attribute>
			</xsl:element><label for="fwManagementEnabled">&#160;<xsl:value-of select="$stringsDoc//value[@key='enableFwManagement']"/></label><br />
			<span class="whiteSpacer">&#160;</span><br />

      <div id="fwmgmtSettingsForm">

			<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<tr>
					<xsl:if test="$hasVirtualMedia">
						<td>
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="name">srcSelect</xsl:attribute>
								<xsl:attribute name="id">srcSelect_URL</xsl:attribute>
								<xsl:attribute name="onclick">toggleUrlForm(this.getAttribute('id'));</xsl:attribute>
								<xsl:if test="count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=$firmwareIsoUrl]) = 0">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
							</xsl:element>
						</td>
						<td width="10">&#160;</td>
					</xsl:if>
					<td>
						<span id="lblFirmwareIso">
							<label for="srcSelect_URL"><xsl:value-of select="$stringsDoc//value[@key='firmwareIsoUrl:']"/><xsl:value-of select="$stringsDoc//value[@key='asterisk']"/></label>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td id="frmIsoUrl">
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>

							<xsl:choose>
								<xsl:when test="$hasVirtualMedia and count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=$firmwareIsoUrl]) &gt; 0">
									<xsl:attribute name="disabled">true</xsl:attribute>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="style">width:300px;</xsl:attribute>
							<xsl:attribute name="id">isoUrl</xsl:attribute>
							<xsl:if test="count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=$firmwareIsoUrl]) = 0">
								<xsl:attribute name="value">
									<xsl:value-of select="$firmwareIsoUrl"/>
								</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</td>

                                        <xsl:choose>
                                            <xsl:when test="count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=$firmwareIsoUrl]) = 0">
                                                <td style="padding-left: 10px;" id="urlStatus">
                                                    <xsl:call-template name="urlStatus"/>
                                                </td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td>&#160;</td>
                                            </xsl:otherwise>
                                        </xsl:choose>
				</tr>
				<xsl:if test="$hasVirtualMedia">
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<tr>
						<td>
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="name">srcSelect</xsl:attribute>
								<xsl:attribute name="id">srcSelect_Local</xsl:attribute>
								<xsl:attribute name="onclick">toggleUrlForm(this.getAttribute('id'));</xsl:attribute>
								<xsl:if test="count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=$firmwareIsoUrl]) &gt; 0">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
							</xsl:element>
						</td>
						<td width="10">&#160;</td>
						<td>
							<span id="lblFirmwareIsoLocal">
								<label for="srcSelect_Local"><xsl:value-of select="$stringsDoc//value[@key='firmwareIsoLocalMedia:']"/></label>
							</span>
						</td>
						<td width="10">&#160;</td>
						<td id="frmIsoLocal">
							<xsl:element name="select">
								<xsl:attribute name="id">isoUrlLocal</xsl:attribute>
							
								<xsl:if test="count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=$firmwareIsoUrl]) = 0">
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:if>
								
								<option value="-">
									<xsl:value-of select="$stringsDoc//value[@key='select']"/>
								</option>
								<xsl:for-each select="$virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value!=' ' and @hpoa:value!='']">
									<xsl:element name="option">
										<xsl:if test="$firmwareIsoUrl=@hpoa:value">
											<xsl:attribute name="selected">true</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">
											<xsl:value-of select="@hpoa:value"/>
										</xsl:attribute>
										<xsl:value-of select="@hpoa:property" />
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</td>
                                        <xsl:choose>
                                            <xsl:when test="count($virtualMediaUrlListDoc//hpoa:virtualMediaProperty[@hpoa:value=$firmwareIsoUrl]) &gt; 0">
                                                <td style="padding-left: 10px;" id="urlStatus">
                                                    <xsl:call-template name="urlStatus"/>
                                                </td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td>&#160;</td>
                                            </xsl:otherwise>
                                        </xsl:choose>

					</tr>
				</xsl:if>
			</table>
			<br />
			<b>
            <span class="invalidFormLabel"><xsl:value-of select="$stringsDoc//value[@key='efmCaution:']"/></span>
            </b>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='efmSppSizeCaution']"/></em>&#160;<br />
                        <div id="dvdInfo"><span><xsl:call-template name="dvdInfo"/></span></div>
			<br />
			<hr />

      <xsl:value-of select="$stringsDoc//value[@key='forceDowngrades:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='forceDowngradeMessage']"/></em>
      <br /><span class="whiteSpacer">&#160;</span><br />
      <table width="auto" cellpadding="0" cellspacing="0" border="0" id="tblForceOption">
        <tr>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="id">chkForceOption</xsl:attribute>
              <xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:forceDowngrade='true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </xsl:element>
          </td>
          <td>
            <label for="chkForceOption" style="padding-left:5px;"><xsl:value-of select="$stringsDoc//value[@key='enableForceDowngrades']"/></label>
          </td>
        </tr>
      </table>
      

      <hr />
                          
			<xsl:value-of select="$stringsDoc//value[@key='powerPolicy']"/>:&#160;<em><xsl:value-of select="$stringsDoc//value[@key='powerPolicyDesc']"/></em>
			<br /><span class="whiteSpacer">&#160;</span><br />

			<table cellpadding="0" cellspacing="0" border="0" id="bayAccessContainer">
				<tr>
					<td>
						<span id="lblPowerPolicy0">

							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">powerPolicy0</xsl:attribute>
								<xsl:attribute name="name">powerPolicySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:powerPolicy='0'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">0</xsl:attribute>
							</xsl:element>

						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="powerPolicy0"><xsl:value-of select="$stringsDoc//value[@key='powerPolicyOff']"/></label>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td>
						<span id="lblPowerPolicy1">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">powerPolicy1</xsl:attribute>
								<xsl:attribute name="name">powerPolicySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:powerPolicy='1'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">1</xsl:attribute>
							</xsl:element>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="powerPolicy1"><xsl:value-of select="$stringsDoc//value[@key='powerPolicyPress']"/></label>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td>
						<span id="lblPowerPolicy2">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">powerPolicy2</xsl:attribute>
								<xsl:attribute name="name">powerPolicySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:powerPolicy='2'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">2</xsl:attribute>
							</xsl:element>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="powerPolicy2"><xsl:value-of select="$stringsDoc//value[@key='powerPolicyColdBoot']"/></label>
					</td>
				</tr>

			</table>


                        <br/>
                        <hr/>
			<xsl:value-of select="$stringsDoc//value[@key='updatePolicy:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='updatePolicyDesc']"/></em>
			<br /><span class="whiteSpacer">&#160;</span><br />

			<table cellpadding="0" cellspacing="0" border="0" id="bayAccessContainer">
				<tr>
					<td>
						<span id="lblPolicy0">

							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">policy0</xsl:attribute>
								<xsl:attribute name="name">policySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updatePolicy='0'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">0</xsl:attribute>
							</xsl:element>

						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="policy0"><xsl:value-of select="$stringsDoc//value[@key='manualDiscoveryManualUpdate']"/></label>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td>
						<span id="lblPolicy1">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">policy1</xsl:attribute>
								<xsl:attribute name="name">policySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updatePolicy='1'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">1</xsl:attribute>
							</xsl:element>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="policy1"><xsl:value-of select="$stringsDoc//value[@key='automaticDiscoveryFirmware']"/></label>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td>
						<span id="lblPolicy2">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">policy2</xsl:attribute>
								<xsl:attribute name="name">policySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updatePolicy='2'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">2</xsl:attribute>
							</xsl:element>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="policy2"><xsl:value-of select="$stringsDoc//value[@key='automaticUpdateFirmware']"/></label>
					</td>
				</tr>

			</table>

			<br />
			<hr />

			<xsl:value-of select="$stringsDoc//value[@key='scheduleUpdate:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='scheduleDesc']"/></em><br />
			<span class="whiteSpacer">&#160;</span><br />
			<form name="scheduleForm">
				<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
					<tr>
						<td>
							<span id="lblScheduleDate">
								<xsl:value-of select="$stringsDoc//value[@key='fwDate:']"/>
							</span>
						</td>
						<td width="10">&#160;</td>
						<td>
							<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
								<tr>
									<td>
										<xsl:element name="input">
											<xsl:attribute name="class">stdInput</xsl:attribute>
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="style">width:150px;</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updateDate"/>
											</xsl:attribute>
											<xsl:attribute name="id">scheduleDate</xsl:attribute>
										</xsl:element>
									</td>
									<td style="vertical-align:center; padding-left: 2px;" id="calendarContainer"></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<tr>
						<td>
							<span id="lblScheduleTime">
								<xsl:value-of select="$stringsDoc//value[@key='fwTime:']"/>
							</span>
						</td>
						<td width="10">&#160;</td>
						<td>
							<xsl:element name="input">
								<xsl:attribute name="class">stdInput</xsl:attribute>
								<xsl:attribute name="type">text</xsl:attribute>
								<xsl:attribute name="style">width:150px;</xsl:attribute>

								<xsl:attribute name="value">
									<xsl:value-of select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updateTime"/>
								</xsl:attribute>

								<xsl:attribute name="id">scheduleTime</xsl:attribute>

							</xsl:element>
						</td>
					</tr>
				</table>
			</form>

			<br />
			<hr />
			<xsl:value-of select="$stringsDoc//value[@key='baysToInclude']" />:&#160;<em><xsl:value-of select="$stringsDoc//value[@key='baysToIncludeDesc']" /></em>
			<br />
			<span class="whiteSpacer">&#160;</span><br />

			<!-- Remove OA 3.30 from tech preview
			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="class">stdCheckBox</xsl:attribute>
				<xsl:attribute name="name">oaSelect</xsl:attribute>
				<xsl:attribute name="id">oaSelect</xsl:attribute>
				<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:includedBays/hpoa:oaAccess='true'">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
			</xsl:element>&#160;<label for="oaSelect">
				<xsl:value-of select="$stringsDoc//value[@key='firmwareManageAllOA']" />
			</label>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<hr />
			-->
			
			<table cellpadding="0" cellspacing="0" border="0" width="96%" id="bayAccessContainer">
				<tr>
					<td width="50%" valign="top">
						<xsl:value-of select="$stringsDoc//value[@key='fwServerBays']" />
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						<xsl:variable name="chkAllLabelSvb">
							<xsl:value-of select="$stringsDoc//value[@key='firmwareManageAllServers']" />
						</xsl:variable>

						<xsl:for-each select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:includedBays">
							<xsl:call-template name="ServerSelect">
								<xsl:with-param name="enclosureNumber" select="$encNum" />
								<xsl:with-param name="disableAll" select="'false'" />
								<xsl:with-param name="enclosureType" select="$enclosureType" />
								<xsl:with-param name="numBays" select="$numDeviceBays" />
								<xsl:with-param name="checkAllLabel" select="$chkAllLabelSvb" />
							</xsl:call-template>
						</xsl:for-each>

					</td>
				</tr>
			</table>

                        </div>

		</div>
		<span class="whiteSpacer">&#160;</span><br />
		<div align="right">
			<div class='buttonSet'>
                            	<div class='bWrapperUp'>
					<div>
						<div>
              <button type="button" class="hpButton" onclick="setFirmwareManagementSettings();" id="">
								<xsl:value-of select="$stringsDoc//value[@key='apply']"/>
							</button>
						</div>
					</div>
				</div>
        <div class='bWrapperUp'>
          <div>
            <div>
              <button type='button' class='hpButton' id="" onclick="refreshPage();">
                  <xsl:value-of select="$stringsDoc//value[@key='refresh']" />
              </button>
            </div>
          </div>
        </div>
			</div>
		</div>
           </xsl:otherwise>
        </xsl:choose>
	</xsl:template>

    <xsl:template name="dvdInfo">
        <xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:dvdStatus='2'">
            <br />
            <table>
                <tr>
                    <td></td>
                    <td width="10">&#160;</td>
                    <td>
                        <xsl:value-of select="$stringsDoc//value[@key='firmwareDvdName:']"/>
                    </td>
                    <td width="10">&#160;</td>
                    <td>
                        <xsl:value-of select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:firmwareDvdName"/>
                    </td>
                    <td style="padding-left: 10px;"></td>
                </tr>
                <tr>
                    <td></td>
                    <td width="10">&#160;</td>
                    <td>
                        <xsl:value-of select="$stringsDoc//value[@key='firmwareDvdVersion:']"/>
                    </td>
                    <td width="10">&#160;</td>
                    <td>
                        <xsl:value-of select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:firmwareDvdVersion"/>
                    </td>
                    <td style="padding-left: 10px;"></td>
                </tr>
				<tr>
					<td></td>
					<td width="10">&#160;</td>
					<td>
						<xsl:value-of select="$stringsDoc//value[@key='dvdLastMountedAt:']"/>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:value-of select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:dvdLastMountedAt"/>
					</td>
					<td style="padding-left: 10px;"></td>
				</tr>
            </table>
        </xsl:if>


    </xsl:template>

    <xsl:template name="urlStatus">
    	<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:fwManagementEnabled='true'">
	       <xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:dvdStatus='2'">
	           <xsl:call-template name="statusIcon">
	               <xsl:with-param name="statusCode" select="'OP_STATUS_OK'" />
	           </xsl:call-template>&#160;
	           <xsl:value-of select="$stringsDoc//value[@key='validFwUrl']"/>
	       </xsl:if>
	       <xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:dvdStatus='3'">
	           <xsl:call-template name="statusIcon">
	               <xsl:with-param name="statusCode" select="'OP_STATUS_OTHER'" />
	           </xsl:call-template>&#160;
	           <xsl:value-of select="$stringsDoc//value[@key='invalidFwUrl']"/>
	       </xsl:if>
	     </xsl:if>  
	
    </xsl:template>
</xsl:stylesheet>

