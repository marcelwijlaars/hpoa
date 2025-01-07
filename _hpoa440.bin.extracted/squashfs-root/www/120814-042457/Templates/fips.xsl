<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

<!--(C) Copyright 2012 Hewlett-Packard Development Company, L.P.-->
  <xsl:include href="../Templates/guiConstants.xsl"/>

  <xsl:param name="oaSessionKey" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="vcmMode" />
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="networkInfoDoc" />
  <xsl:param name="sslSettingsInfoDoc" />
  <xsl:param name="inWizard" />
  <xsl:param name="fwVersion" select="''" />
	
	<xsl:template match="*">

	<div id="stepInnerContent">
		
	<xsl:value-of select="$stringsDoc//value[@key='fipsMode']" />&#160;<em>
		<xsl:value-of select="$stringsDoc//value[@key='fipsDesc']" />
		<xsl:if test = "$inWizard = 'true'">
			<span class="whiteSpacer">&#160;</span><br/><br/>
			<xsl:value-of select="$stringsDoc//value[@key='fipsFtsw']" />
			<span class="whiteSpacer">&#160;</span><br/><br/>
			<xsl:value-of select="$stringsDoc//value[@key='fipsPressSkip']" />
		</xsl:if>
	</em>
	
	<span class="whiteSpacer">&#160;</span><br/><br/>

	<div id="fipsErrorDisplay" class="errorDisplay"></div>
	
	<xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsSecurityStatus1']='FIPS_ERROR_LDAP_CERT_SIZE'">
	<div class="groupingBox">
          <table BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <tr>
              <td style="vertical-align:top;">
                <img src="/120814-042457/images/status_minor_32.gif" style="vertical-align:middle;margin-right:10px;" />
              </td>
              <td style="font-weight:bold;">
                
                    <xsl:value-of select="$stringsDoc//value[@key='fipsErrorLdapCertSize']" />  
              </td>
            </tr>
          </table>
	</div>
    </xsl:if><br />
	
	<div class="groupingBox">
		<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<tr>
				<td valign="top">
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">fipsMode</xsl:attribute>			
						<xsl:attribute name="id">fipsModeOn</xsl:attribute>
						<xsl:attribute name="value">FIPS-ON</xsl:attribute>
						<xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:if test="$serviceUserAcl = $USER">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="onclick">fipsRadioOnChange(this)</xsl:attribute>
					</xsl:element>
				</td>
				<td valign="middle">
                    <label for="fipsModeOn">
                        <xsl:value-of select="$stringsDoc//value[@key='fipsModeOn']" />
                    </label>
                </td>
			</tr>
			<tr>
				<td valign="top">
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">fipsMode</xsl:attribute>			
						<xsl:attribute name="id">fipsModeDebug</xsl:attribute>
						<xsl:attribute name="value">FIPS-DEBUG</xsl:attribute>
						<xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:if test="$serviceUserAcl = $USER">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="onclick">fipsRadioOnChange(this)</xsl:attribute>
					</xsl:element>
				</td>
				<td valign="middle">
                    <label for="fipsModeDebug">
                        <xsl:value-of select="$stringsDoc//value[@key='fipsModeDebug']" />
                    </label>
                </td>
			</tr>
			<tr>
				<td valign="top">
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="name">fipsMode</xsl:attribute>			
						<xsl:attribute name="id">fipsModeOff</xsl:attribute>
						<xsl:attribute name="value">FIPS-OFF</xsl:attribute>
						<xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-OFF'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:if test="$serviceUserAcl = $USER">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="onclick">fipsRadioOnChange(this)</xsl:attribute>
					</xsl:element>
				</td>
				<td valign="middle">
                    <label for="fipsModeOff">
                        <xsl:value-of select="$stringsDoc//value[@key='fipsModeOff']" />
                    </label>
                </td>
			</tr>
		</table>
		<span class="whiteSpacer">&#160;</span><br />
		<hr />
		<span class="whiteSpacer">&#160;</span><br />

		<b><xsl:value-of select="$stringsDoc//value[@key='fipsPassEnforcement']"/></b>
		<span class="whiteSpacer">&#160;</span><br/>
		<span class="whiteSpacer">&#160;</span><br/>		

		<xsl:value-of select="$stringsDoc//value[@key='fipsPassEnforcementDesc']"/>
		<i><xsl:value-of select="$stringsDoc//value[@key='fipsPassEnforcementDescPass']"/></i>

		<span class="whiteSpacer">&#160;</span><br/>
		<span class="whiteSpacer">&#160;</span><br/>

		<i><xsl:value-of select="$stringsDoc//value[@key='fipsReqField']"/></i>
		<br/>

		<span class="whiteSpacer">&#160;</span><br/>

		<div id="passContainer">
		<table cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td id="lblPwd" nowrap="true">
					<xsl:value-of select="$stringsDoc//value[@key='password:']" />
					<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
				</td>
				<td width="10">&#160;</td>
				<td>
					<xsl:element name="input">
					<xsl:attribute name="type">password</xsl:attribute>
					<xsl:attribute name="id">password</xsl:attribute>
					<xsl:attribute name="name">password</xsl:attribute>
					<!-- validation rules: string, 8 to 40 chars -->
					<xsl:attribute name="validate-me">true</xsl:attribute>	
					<xsl:choose>
						<xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']!='FIPS-OFF' or $fwVersion &gt;=4.35">
							<xsl:attribute name="class">stdInput</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="rule-list">6</xsl:attribute>
					<xsl:attribute name="range">8;40</xsl:attribute>
					<xsl:attribute name="caption-label">lblPwd</xsl:attribute>
					<xsl:attribute name="maxlength">40</xsl:attribute>
					<xsl:if test="$serviceUserAcl = $USER">
						<xsl:attribute name="readonly">true</xsl:attribute>
					</xsl:if>
					</xsl:element>
				</td>
			</tr>
			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>
			<tr>
				<td nowrap="true">
					<xsl:value-of select="$stringsDoc//value[@key='passwordConfirm:']" />
					<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
				</td>
				<td width="10">&#160;</td>
				<td>
					<xsl:element name="input">
					<xsl:choose>
						<xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']!='FIPS-OFF' or $fwVersion &gt;=4.35">
							<xsl:attribute name="class">stdInput</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="type">password</xsl:attribute>
					<xsl:attribute name="id">passwordConfirm</xsl:attribute>
					<xsl:attribute name="validate-me">true</xsl:attribute>
					<xsl:attribute name="rule-list">7</xsl:attribute>
					<xsl:attribute name="caption-label">lblPwd</xsl:attribute>
					<xsl:attribute name="related-inputs">password</xsl:attribute>
					<xsl:if test="$serviceUserAcl = $USER">
						<xsl:attribute name="readonly">true</xsl:attribute>
					</xsl:if>
              				</xsl:element>
					<!--input class="stdInput" maxlength="40"  validate-me="true" rule-list="7" caption-label="lblPwd" related-inputs="password" type="password" id="passwordConfirm" name="passwordConfirm" /-->
				</td>
			</tr>
		</table>
		</div>
	</div>

	<xsl:if test="$inWizard = 'false'">
		<span class="whiteSpacer">&#160;</span><br />
		<xsl:if test="$serviceUserAcl != $USER">
			<div align="right">
				<div class='buttonSet' style="margin-bottom:0px;">
					<div class='bWrapperUp'>
						<div><div>
						<button type='button' class='hpButton' id="btnSetFips" onclick="setFipsMode();">
							<xsl:value-of select="$stringsDoc//value[@key='apply']" />
						</button>
						</div></div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:if>

	<span class="whiteSpacer">&#160;</span>
	<br/>     

		<span class="whiteSpacer">&#160;</span>
		<br />
		<!-- Clear VC Mode -->
		<xsl:value-of select="$stringsDoc//value[@key='clearVcMode:']"/>&#160;<em>
		<xsl:value-of select="$stringsDoc//value[@key='fipsClearVcModeDesc']"/>
		</em><br />
		<div id="clearVcErrorDisplay" class="errorDisplay"></div>
		<span class="whiteSpacer">&#160;</span><br />
		<div class="groupingBox">

			<xsl:value-of select="$stringsDoc//value[@key='vcCurrently:']"/>&#160;<xsl:choose>
				<xsl:when test="$vcmMode//hpoa:vcmMode/hpoa:isVcmMode='true'">
					<span id="vcModeLbl"><xsl:value-of select="$stringsDoc//value[@key='enabled']"/></span>
				</xsl:when>
				<xsl:otherwise>
					<span id="vcModeLbl"><xsl:value-of select="$stringsDoc//value[@key='disabled']"/></span>
				</xsl:otherwise>
			</xsl:choose><br />
			
			<span class="whiteSpacer">&#160;</span>
			<br />
			<table cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td>
						<div align="right">
							<div class='buttonSet'>
								<div class='bWrapperUp'>
									<div>
										<div>
											<button type="button" class="hpButton" onclick="clearVcmMode();" id="clearVcButton">
												<xsl:value-of select="$stringsDoc//value[@key='clearVcMode']"/>
											</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<xsl:if test="$inWizard = 'true'">
		<div id="waitContainer" class="waitContainer"></div>
	</xsl:if>  
  
  <xsl:if test="$inWizard != 'true'">
    <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
      <xsl:if test="$sslSettingsInfoDoc">
        <xsl:if test="count($sslSettingsInfoDoc//hpoa:protocol) &gt; 0 or count($sslSettingsInfoDoc//hpoa:cipher) &gt; 0">      
        <div style="display:block;margin-top:10px;">
          <br />
          <span class="whiteSpacer">&#160;</span><br />
          <xsl:value-of select="$stringsDoc//value[@key='advancedSecuritySettings']" />:&#160;<em>
          <xsl:value-of select="$stringsDoc//value[@key='advancedSecuritySettingsDesc']" />
          </em>        
          <span class="whiteSpacer">&#160;</span><br /><br />
          <div id="sslSettingsErrorDisplay" class="errorDisplay"></div>
          <div class="groupingBox">
            <div id="editContainer">
              <font style="color:cc0000;"><b><xsl:value-of select="$stringsDoc//value[@key='warning']" /></b></font>&#160;<xsl:value-of select="$stringsDoc//value[@key='modifySettingsCauseWebRestart']" />
              <br />
              <span class="whiteSpacer">&#160;</span><br />
              <table cellpadding="0" cellspacing="0" border="0" align="center">
				        <tr>
					        <td>
                    <div align="right">
				              <div class='buttonSet' style="margin-top:8px;">
					              <div class='bWrapperUp'>
						              <div>
							              <div>
								              <button type="button" class="hpButton" onclick="document.getElementById('securityContainer').style.display='block';document.getElementById('editContainer').style.display='none';reconcilePage();">
									              <xsl:value-of select="$stringsDoc//value[@key='editSecuritySettings']"/>
								              </button>
							              </div>
						              </div>
					              </div>
				              </div>
			              </div>
                    <div class="clearFloats" />
                  </td>
                </tr>
              </table>          
            </div>          
            <div id="securityContainer" style="display:none;">
              <span class="whiteSpacer">&#160;</span><br />
              <xsl:value-of select="$stringsDoc//value[@key='cryptoProtocols']" />
              <span class="whiteSpacer">&#160;</span><br />            
              <div style="padding:5px;" id="protocolOptionsContainer">
                <table cellpadding="0" cellspacing="0" border="0">
                  <xsl:for-each select="$sslSettingsInfoDoc//hpoa:protocol">
                    <tr>
                      <td>                        
                        <div>
                          <table>
                            <tr>
                              <td style="padding-right:2px;">
                                <xsl:element name="input">
                                  <xsl:attribute name="type">checkbox</xsl:attribute>
                                  <xsl:attribute name="class">stdCheckBox</xsl:attribute>
                                  <xsl:attribute name="id"><xsl:value-of select="hpoa:name" /></xsl:attribute>
                                  <xsl:if test="hpoa:enabled ='true'">
                                    <xsl:attribute name="checked">true</xsl:attribute>
                                  </xsl:if>
                                  </xsl:element>
                                </td>
                                <td><label for="{hpoa:name}"><xsl:value-of select="hpoa:name" /></label></td>                  
                            </tr>
                          </table>
                        </div>  
                        </td>
                      </tr>
                  </xsl:for-each>
                </table>                   
              </div>
              <span class="whiteSpacer">&#160;</span><br />
              <xsl:value-of select="$stringsDoc//value[@key='securityCiphers']" />
              <span class="whiteSpacer">&#160;</span><br />
              <div style="padding:5px;" id="cipherOptionsContainer">
                  <xsl:for-each select="$sslSettingsInfoDoc//hpoa:cipher">                    
                    <div>
                      <table>
                        <tr>
                          <td style="padding-right:2px;">
                            <xsl:element name="input">
                              <xsl:attribute name="type">checkbox</xsl:attribute>
                              <xsl:attribute name="class">stdCheckBox</xsl:attribute>
                              <xsl:attribute name="id"><xsl:value-of select="hpoa:name" /></xsl:attribute>
                              <xsl:if test="hpoa:enabled='true'">
                                <xsl:attribute name="checked">true</xsl:attribute>
                              </xsl:if>                      
                            </xsl:element>                    
                          </td>
                          <td><label for="{hpoa:name}"><xsl:value-of select="hpoa:name" /></label></td>                  
                        </tr>
                      </table>
                    </div>  
                  </xsl:for-each>
              </div>
              <hr/>
              <div align="right">
                <div class='buttonSet' style="margin-bottom:0px;margin-top:5px;">
                  <div class='bWrapperUp'>
                    <div>
                      <div>
                        <button type='button' class='hpButton' id="btnSetSslSettings" onclick="setSslSettings();">
                          <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="clearFloats" />
              </div>
            </div>
          </div>
        </div>      
        </xsl:if>
      </xsl:if>
     </xsl:if>
  </xsl:if>
</xsl:template>
	
</xsl:stylesheet>

