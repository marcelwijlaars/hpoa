<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	
	<xsl:template name="directorySettings">

		<xsl:variable name="ldapEnabled" select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:ldapEnabled"/>
    <xsl:variable name="ntMappingEnabled" select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:userNtAccountNameMapping" />
		
		<xsl:element name="input">
			<xsl:attribute name="type">checkbox</xsl:attribute>
			<xsl:attribute name="class">stdCheckBox</xsl:attribute>
			<xsl:attribute name="id">ldapEnabled</xsl:attribute>
			<xsl:if test="$ldapEnabled='true'">
				<xsl:attribute name="checked">true</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="onclick">toggleFormEnabled('directorySettingsForm', this.checked); showLDAPIPv6DisabledNote('<xsl:value-of select="$isWizard"/>', '<xsl:value-of select="$encNum"/>');</xsl:attribute>
			
		</xsl:element><label id="lblEnableLdap"  for="ldapEnabled"><xsl:value-of select="$stringsDoc//value[@key='enableLDAPAuth']" /></label>
		<br />
	
		<xsl:element name="input">
			<xsl:attribute name="type">checkbox</xsl:attribute>
			<xsl:attribute name="class">stdCheckBox</xsl:attribute>
			<xsl:attribute name="id">localEnabled</xsl:attribute>
			<xsl:if test="$ldapInfoDoc//hpoa:ldapInfo/hpoa:localUsersEnabled='true'">
				<xsl:attribute name="checked">true</xsl:attribute>
			</xsl:if>
		</xsl:element><label id="lblEnableLocal"  for="localEnabled"><xsl:value-of select="$stringsDoc//value[@key='enableLocalUsers']" /></label>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<div class="wizardTextContainer">
			<b>
				<span class="invalidFormLabel"><xsl:value-of select="$stringsDoc//value[@key='caution:']" /></span>
			</b> <xsl:value-of select="$stringsDoc//value[@key='cautionDisableLocalUser']" />
			<br />

			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:value-of select="$stringsDoc//value[@key='iLO2SingleSignOnDesc']" />

		</div>
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<div id="directorySettingsForm">

			<em>
				<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
			</em>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ID="directorySettingsTable">
				<TR>
					<TD id="lblDsAddress"><xsl:value-of select="$stringsDoc//value[@key='directorySrvAddress:']" /></TD>
					<TD width="10">&#160;</TD>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">dsAddress</xsl:attribute>
							<xsl:attribute name="id">dsAddress</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:directoryServerAddress"/>
							</xsl:attribute>

							<xsl:choose>
								<xsl:when test="$ldapEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="validate-me">true</xsl:attribute>
                                                        <xsl:attribute name="rule-list">6;8</xsl:attribute>
							<xsl:attribute name="range">1;64</xsl:attribute>
							<xsl:attribute name="caption-label">lblDsAddress</xsl:attribute>
							
							<xsl:attribute name="maxlength">64</xsl:attribute>
							<xsl:attribute name="onchange">showLDAPIPv6DisabledNote('<xsl:value-of select="$isWizard"/>', '<xsl:value-of select="$encNum"/>')</xsl:attribute>
						</xsl:element>
					</TD>
					<TD width="10">&#160;</TD>
					<TD> <div id="LDAPIPv6DisabledDisplay" style="display:none"></div></TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<TR>
					<TD id="lblLdapPort"><xsl:value-of select="$stringsDoc//value[@key='directorySrvSSLPort:']" /></TD>
					<TD width="10">&#160;</TD>
					<TD>

            <xsl:variable name="port" select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:directoryServerSslPort" />

            <xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">ldapPort</xsl:attribute>
							<xsl:attribute name="id">ldapPort</xsl:attribute>
							  <xsl:attribute name="validate-me">true</xsl:attribute>
								<xsl:attribute name="rule-list">9</xsl:attribute>
								<xsl:attribute name="range">1;65535</xsl:attribute>
							  <xsl:attribute name="caption-label">lblLdapPort</xsl:attribute>

              <xsl:choose>
                <xsl:when test="not(contains($port, '-')) and $port != 0">
                  
                  <xsl:attribute name="value">
                    <xsl:value-of select="$port"/>
                  </xsl:attribute>
                  
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="$ldapInfoDoc//hpoa:ldapInfo/hpoa:extraData[@hpoa:name='UnsignedDirectorySSLPort'] != 0">
                    <xsl:attribute name="value">
                      <xsl:value-of select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:extraData[@hpoa:name='UnsignedDirectorySSLPort']"/>
                    </xsl:attribute>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
							<xsl:attribute name="maxlength">15</xsl:attribute>
                  
							<xsl:choose>
								<xsl:when test="$ldapEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:element>
					</TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<TR>
					<TD id="lblSearch1"><xsl:value-of select="$stringsDoc//value[@key='searchContext']" />&#160;1:</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">searchContext1</xsl:attribute>
							<xsl:attribute name="id">searchContext1</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:searchContext1"/>
							</xsl:attribute>

							<xsl:choose>
								<xsl:when test="$ldapEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:attribute name="maxlength">127</xsl:attribute>
						</xsl:element>
					</TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<TR>
					<TD id="lblSearch2"><xsl:value-of select="$stringsDoc//value[@key='searchContext']" />&#160;2:</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">searchContext2</xsl:attribute>
							<xsl:attribute name="id">searchContext2</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:searchContext2"/>
							</xsl:attribute>
							<xsl:attribute name="maxlength">127</xsl:attribute>

							<xsl:choose>
								<xsl:when test="$ldapEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:element>
					</TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<TR>
					<TD id="lblSearch3"><xsl:value-of select="$stringsDoc//value[@key='searchContext']" />&#160;3:</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">searchContext3</xsl:attribute>
							<xsl:attribute name="id">searchContext3</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:searchContext3"/>
							</xsl:attribute>

							<xsl:choose>
								<xsl:when test="$ldapEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:attribute name="maxlength">127</xsl:attribute>
						</xsl:element>
					</TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>

				<xsl:for-each select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:extraData[contains(@hpoa:name, 'searchContext')]">
					<xsl:variable name="contextNum" select="substring(@hpoa:name, 14, 1)" />
					<tr>
						<xsl:element name="td">
							<xsl:attribute name="id"><xsl:value-of select="concat('lblSearch', $contextNum)"/></xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='searchContext']" />&#160;<xsl:value-of select="$contextNum" />:
						</xsl:element>
						<td width="10">&#160;</td>
						<td>
							<xsl:element name="input">
								<xsl:attribute name="type">text</xsl:attribute>
								<xsl:attribute name="name"><xsl:value-of select="@hpoa:name"/></xsl:attribute>
								<xsl:attribute name="id"><xsl:value-of select="@hpoa:name"/></xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="."/>
								</xsl:attribute>

								<xsl:choose>
									<xsl:when test="$ldapEnabled='true'">
										<xsl:attribute name="class">stdInput</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
										<xsl:attribute name="disabled">true</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:attribute name="maxlength">127</xsl:attribute>
							</xsl:element>
						</td>
					</tr>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
				</xsl:for-each>
				
			</TABLE>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<hr />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="class">stdCheckBox</xsl:attribute>
				<xsl:attribute name="id">ntAccountMapping</xsl:attribute>
                                <xsl:if test="$ntMappingEnabled ='true'">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>

				<xsl:if test="not($ldapEnabled='true')">
					<xsl:attribute name="disabled">true</xsl:attribute>
				</xsl:if>
	                				
			</xsl:element>
			<label id="lblNtAccount" for="ntAccountMapping"><xsl:value-of select="$stringsDoc//value[@key='useNTAccountMapping']" /></label>
			<br />

			<span class="whiteSpacer">&#160;</span>
			<br />
			<xsl:if test="$ldapInfoDoc//hpoa:ldapInfo/hpoa:extraData[@hpoa:name='directoryGCPort'] != ''">
			<div style="padding-left: 25px;">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ID="directoryGCPortTable">
			<TR>
				<TD id="lblGCPort"><xsl:value-of select="$stringsDoc//value[@key='directorySrvGCPort:']" /></TD>
				<TD width="10">&#160;</TD>
				<TD>
				    <xsl:element name="input">
					<xsl:attribute name="type">text</xsl:attribute>
					<xsl:attribute name="name">gcPort</xsl:attribute>
					<xsl:attribute name="id">gcPort</xsl:attribute>
					<xsl:attribute name="validate-me">true</xsl:attribute>
					<xsl:attribute name="rule-list">0;9</xsl:attribute>
					<xsl:attribute name="range">1;65535</xsl:attribute>
					<xsl:attribute name="caption-label">lblGCPort</xsl:attribute>
					<xsl:attribute name="maxlength">15</xsl:attribute>
					
          <xsl:choose>
            <xsl:when test="$ldapEnabled = 'true'">
              <xsl:attribute name="class">stdInput</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>             
              
					<xsl:attribute name="value">
					<xsl:if test="$ldapInfoDoc//hpoa:ldapInfo/hpoa:extraData[@hpoa:name='directoryGCPort'] != 0">
						<xsl:value-of select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:extraData[@hpoa:name='directoryGCPort']"/>
					</xsl:if>	
					</xsl:attribute>
				    </xsl:element>

				</TD>
			</TR>
			</TABLE>
			</div>
			</xsl:if>


		</div>
	</xsl:template>

</xsl:stylesheet>

