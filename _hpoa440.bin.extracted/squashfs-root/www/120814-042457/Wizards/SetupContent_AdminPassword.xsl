<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="enclosureInfoDoc" />
	<xsl:param name="enclosureNetworkInfoDoc" />
	<xsl:param name="lcdStatusDoc" />
  <xsl:param name="lcdInfoDoc" />
	<xsl:param name="userInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="passwordSettingsDoc" />

	<!-- Unused parameters that must be included to reuse the Users stylesheet. -->
	<xsl:param name="action" select="'edit'" />
	<xsl:param name="serviceUserAcl" select="$ADMINISTRATOR" />
	<xsl:param name="userOaAccess" select="'true'" />
	<xsl:param name="encNum" select="'1'" />
	<xsl:param name="isCurrentUser" select="'false'" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="numIoBays" select="8" />
	<xsl:param name="numDeviceBays" select="16" />
  
	<xsl:include href="../Forms/Users.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />

	<!-- Enclosure type doesn't matter here because we are not setting any bay permissions. -->
	<xsl:param name="enclosureType" select="0" />
	
	<xsl:template name="Setup_AdminPassword" match="*">

		<div id="stepInnerContent">
			
			<!-- Current step description text -->
			<div class="wizardTextContainer">
			<xsl:value-of select="$stringsDoc//value[@key='adminAccountPara1']"/><br />

				<span class="whiteSpacer">&#160;</span>
				<br />
				
				<xsl:value-of select="$stringsDoc//value[@key='adminAccountPara2']"/>
				
			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			
			<div id="adminErrorDisplay" class="errorDisplay">&#160;</div>
			
			<xsl:call-template name="userInformation" />
			
			<span class="whiteSpacer">&#160;</span>
			<br />

			<hr />

			<span class="whiteSpacer">&#160;</span>
			<br />
			<div class="wizardTextContainer">
				<xsl:value-of select="$stringsDoc//value[@key='adminAccountPara3']"/>
			</div>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="onclick">toggleFormEnabled('LCDPinForm', this.checked);</xsl:attribute>
				<xsl:attribute name="class">stdCheckBox</xsl:attribute>        
				<xsl:attribute name="id">enablePinProtection</xsl:attribute>

				<xsl:if test="$lcdStatusDoc//hpoa:lcdStatus/hpoa:lcdPin='true'">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$enclosureNetworkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $enclosureNetworkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
					<xsl:attribute name="disabled">true</xsl:attribute>
				</xsl:if>

			</xsl:element>
			
			<label id="lblEnablePin"  for="enablePinProtection">
				<xsl:value-of select="$stringsDoc//value[@key='enableLcdPinProtection']"/>
				<xsl:call-template name="fipsHelpMsg">
					<xsl:with-param name="fipsMode" select="$enclosureNetworkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']" />
					<xsl:with-param name="msgType">tooltip</xsl:with-param>
					<xsl:with-param name="msgKey">fipsRequired</xsl:with-param>
				</xsl:call-template>
			</label>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<div id="LCDPinForm">
				<table cellpadding="0" cellspacing="0">
					<tr>
						<TD>
							<span id="lblLcdPin"><xsl:value-of select="$stringsDoc//value[@key='lcdPin:']"/></span>
						</TD>
						<TD width="10">&#160;</TD>
						<TD>

							<xsl:element name="input">

								<xsl:choose>
									<xsl:when test="$lcdStatusDoc//hpoa:lcdStatus/hpoa:lcdPin='true'">
										<xsl:attribute name="class">stdInput</xsl:attribute>
                    <xsl:attribute name="rule-list">0;6;8</xsl:attribute>
                    <xsl:attribute name="alreadyEnabled">true</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
										<xsl:attribute name="disabled">true</xsl:attribute>
                    <xsl:attribute name="rule-list">6;8</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:attribute name="id">lcdPin</xsl:attribute>
								<xsl:attribute name="validate-pin">true</xsl:attribute>
								<xsl:attribute name="caption-label">lblLcdPin</xsl:attribute>
                <xsl:attribute name="range">1;6</xsl:attribute>
                <xsl:attribute name="maxlength">6</xsl:attribute>
								<xsl:attribute name="autocomplete">off</xsl:attribute>
								<xsl:attribute name="type">password</xsl:attribute>
								
							</xsl:element>
							
						</TD>
					</tr>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<tr>
						<TD>
							<span id="lblLcdPinConfirm"><xsl:value-of select="$stringsDoc//value[@key='lcdPinConfirm:']"/></span>
						</TD>
						<TD width="10">&#160;</TD>
						<TD>
							<xsl:element name="input">

								<xsl:choose>
									<xsl:when test="$lcdStatusDoc//hpoa:lcdStatus/hpoa:lcdPin='true'">
										<xsl:attribute name="class">stdInput</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
										<xsl:attribute name="disabled">true</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:attribute name="id">lcdPinConfirm</xsl:attribute>
								<xsl:attribute name="validate-pin">true</xsl:attribute>
								<xsl:attribute name="rule-list">7</xsl:attribute>
								<xsl:attribute name="caption-label">lblLcdPin</xsl:attribute>
								<xsl:attribute name="related-inputs">lcdPin</xsl:attribute>
								<xsl:attribute name="autocomplete">off</xsl:attribute>
								<xsl:attribute name="type">password</xsl:attribute>
                <xsl:attribute name="maxlength">6</xsl:attribute>

							</xsl:element>
						</TD>
					</tr>
				</table>
			</div>
			
		</div>
		<div id="waitContainer" class="waitContainer"></div>

	</xsl:template>

</xsl:stylesheet>

