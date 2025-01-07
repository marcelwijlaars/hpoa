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
	<xsl:param name="syslogSettingsDoc" />

	<xsl:template match="*">

		<xsl:variable name="syslogEnabled" select="$syslogSettingsDoc//hpoa:syslogSettings/hpoa:remoteEnabled" />

		<div class="errorDisplay" id="errorDisplay"></div>
		
			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="class">stdCheckBox</xsl:attribute>
				<xsl:attribute name="id">remoteEnabled</xsl:attribute>
				<xsl:attribute name="onclick">toggleOptionsForm(this.checked);</xsl:attribute>
				<xsl:if test="$syslogEnabled='true'">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
			</xsl:element>
			<label id="lblEnableRemote"  for="remoteEnabled"><xsl:value-of select="$stringsDoc//value[@key='enableRemoteSysLog']" /></label>
			<br />

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ID="syslogSettingsForm">
				<TR>
					<TD id=""><xsl:value-of select="$stringsDoc//value[@key='syslogSrvAddress:']" /></TD>
					<TD width="10">&#160;</TD>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id">syslogAddress</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$syslogEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="value">
								<xsl:value-of select="$syslogSettingsDoc//hpoa:syslogSettings/hpoa:syslogServer" />
							</xsl:attribute>
						</xsl:element>
					</TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<TR>
					<TD id="lblPort"><xsl:value-of select="$stringsDoc//value[@key='port:']" /></TD>
					<TD width="10">&#160;</TD>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id">syslogPort</xsl:attribute>

							<xsl:attribute name="validate-port">true</xsl:attribute>
							<xsl:attribute name="rule-list">9</xsl:attribute>
							<xsl:attribute name="range">1;65535</xsl:attribute>
							<xsl:attribute name="caption-label">lblPort</xsl:attribute>
							
							<xsl:choose>
								<xsl:when test="$syslogEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="value">
								<xsl:value-of select="$syslogSettingsDoc//hpoa:syslogSettings/hpoa:syslogPort" />
							</xsl:attribute>
						</xsl:element>
					</TD>
				</TR>
			</TABLE>
			
			<xsl:if test="$serviceUserAcl != $USER">
			
				<span class="whiteSpacer">&#160;</span>
				<br />
				<div align="right">
					<div class='buttonSet'>
						<div class='bWrapperUp'>
							<div>
								<div>
									<button type='button' class='hpButton' id="btnApply" onclick="setSyslogSettings();">
										<xsl:value-of select="$stringsDoc//value[@key='apply']" />
									</button>
								</div>
							</div>
						</div>
						<div class='bWrapperUp'>
							<div>
								<div>

									<xsl:element name="button">
										
										<xsl:attribute name="type">button</xsl:attribute>
										<xsl:attribute name="class">hpButton</xsl:attribute>
										<xsl:attribute name="style">width:130px;</xsl:attribute>
										<xsl:attribute name="id">btnTest</xsl:attribute>
										<xsl:attribute name="onclick">testSyslog();</xsl:attribute>

										<xsl:if test="$syslogEnabled != 'true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>

										<xsl:value-of select="$stringsDoc//value[@key='testRemoteLog']" />

									</xsl:element>
									
								</div>
							</div>
						</div>
					</div>
				</div>
			</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>

