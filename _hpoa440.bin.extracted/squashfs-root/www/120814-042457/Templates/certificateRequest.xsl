<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">
	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<!--<xsl:param name="certificateRequest" />-->
	<xsl:param name="certificateInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="isStandby" />
	<xsl:param name="hasStandby" />
	<xsl:param name="standbyOaName" />
	<xsl:param name="fwVersion" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:template match="*">
		<xsl:value-of select="$stringsDoc//value[@key='certRequestDesc']" />
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<xsl:value-of select="$stringsDoc//value[@key='certRequestSelect']" />
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div class="groupingBox">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="name">certType</xsl:attribute>
							<xsl:attribute name="value">selfSign</xsl:attribute>
							<xsl:attribute name="id">selfSign</xsl:attribute>
							<xsl:attribute name="class">stdRadioButton</xsl:attribute>
							<xsl:attribute name="checked">true</xsl:attribute>
							<xsl:attribute name="onclick">toggleFormEnabled('csrContainer', !this.checked);</xsl:attribute>
						</xsl:element>
						<label for="selfSign">
							<!--<xsl:value-of select="$stringsDoc//value[@key='dhcp']" />-->
							<xsl:value-of select="$stringsDoc//value[@key='generateSelfCert']" />
						</label>
						<br />
						<div id="selfSignContainer">
							<blockquote>
								<span>
								<xsl:value-of select="$stringsDoc//value[@key='generateIdcertbyOA']" />
								</span>
							</blockquote>
						</div>
					</td>
				</tr>
			</table>
			<hr />
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="name">certType</xsl:attribute>
							<xsl:attribute name="value">csrReq</xsl:attribute>
							<xsl:attribute name="id">csrReq</xsl:attribute>
							<xsl:attribute name="class">stdRadioButton</xsl:attribute>
							<xsl:attribute name="onclick">toggleFormEnabled('csrContainer', this.checked);</xsl:attribute>
						</xsl:element>
						<label for="csrReq">
							<!--<xsl:value-of select="$stringsDoc//value[@key='dhcp']" />-->
							<xsl:value-of select="$stringsDoc//value[@key='generateCertSignCSR']" />
						</label>
						<br />
						<div id="csrReqContainer">
							<blockquote>
								<span><xsl:value-of select="$stringsDoc//value[@key='generateReqFromThisPage']" /></span>
							</blockquote>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<xsl:value-of select="$stringsDoc//value[@key='RequiredInformation']" />:&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='RequiredCertificateDescription']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />
		<div class="groupingBox">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<div id="requiredErrorDisplay" class="errorDisplay"></div>
						<div id="requiredContainer">
							<em>
								<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
							</em>
							<br />
							<span class="whiteSpacer">&#160;</span>
							<br />
								<table border="0" cellspacing="0" cellpadding="0" id="requiredTable">
									<xsl:call-template name="labelAndInputRow">
									<xsl:with-param name="id_row" select="string('country')" />
                    <xsl:with-param name="label_row" select="concat($stringsDoc//value[@key='certCountry'],'*')" />
                    <xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:country)" />
                    <xsl:with-param name="max_row" select="number('2')" />
                    <xsl:with-param name="validate_row" select="string('true')" />
                    <xsl:with-param name="validate_name" select="string('validate-required')" />
                    <xsl:with-param name="rule-list" select="string('6;8;10')" />
                    <xsl:with-param name="range" select="string('2;2')" />
                    <xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certCountryDescription'])" />
                    <!-- client-side validation of special characters -->
                    <xsl:with-param name="reg_exp">
                      <xsl:value-of select="concat('[', '^', 'a-zA-Z0-9', '\', 's', &quot;'&quot;, '(', ')', '+', '.', ',', '/', ':', '=', '?', '_', '-', ']')" />
                    </xsl:with-param>
                    <xsl:with-param name="msg_insert_key" select="'alnumCustom1'" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
                    <xsl:with-param name="id_row" select="string('stateOrProvince')" />
                    <xsl:with-param name="label_row" select="concat($stringsDoc//value[@key='certStateOrProvince'],'*')" />
                    <xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:stateOrProvince)" />
                    <xsl:with-param name="max_row" select="number('30')" />
                    <xsl:with-param name="validate_row" select="string('true')" />
                    <xsl:with-param name="validate_name" select="string('validate-required')" />
                    <xsl:with-param name="rule-list" select="string('6')" />
                    <xsl:with-param name="range" select="string('1;30')" />
                    <xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certStateOrProvinceDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('cityOrLocality')" />
										<xsl:with-param name="label_row" select="concat($stringsDoc//value[@key='certCityOrLocality'],'*')" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:cityOrLocality)" />
										<xsl:with-param name="max_row" select="number('50')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-required')" />
									<xsl:with-param name="rule-list" select="string('6')" />
									<xsl:with-param name="range" select="string('1;50')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certCityOrLocalityDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('organizationName')" />
										<xsl:with-param name="label_row" select="concat($stringsDoc//value[@key='certOrganizationName'],'*')" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:organizationName)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-required')" />
									<xsl:with-param name="rule-list" select="string('6')" />
									<xsl:with-param name="range" select="string('1;60')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certOrganizationNameDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('subjectCommonName')" />
										<xsl:with-param name="label_row" select="concat($stringsDoc//value[@key='certSubjectCommonName'],'*')" />
										<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:sslCertificateInfo/hpoa:subjectCommonName)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-required')" />
									<xsl:with-param name="rule-list" select="string('6;8')" />
									<xsl:with-param name="range" select="string('1;60')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certSubjectCommonNameDescription'])" />
									</xsl:call-template>
								</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<xsl:if test="$hasStandby='true'">
			<br />
			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="class">stdCheckBox</xsl:attribute>
				<xsl:attribute name="name">standby</xsl:attribute>
				<xsl:attribute name="id">standby</xsl:attribute>
				<xsl:attribute name="align">left</xsl:attribute>
				<xsl:attribute name="onclick">toggleFormEnabled('standbyContainer', this.checked);</xsl:attribute>
			</xsl:element>
			<label for="standby">
				<xsl:choose>
					<xsl:when test="$isStandby='true'">
						<xsl:value-of select="$stringsDoc//value[@key='activeOAHostName']" />:&#160;<em>
							<xsl:value-of select="$stringsDoc//value[@key='activeOAHostNameDesc']" />
						</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$stringsDoc//value[@key='standbyOAHostName']" />:&#160;<em>
							<xsl:value-of select="$stringsDoc//value[@key='standbyOAHostNameDesc']" />
						</em>
					</xsl:otherwise>
				</xsl:choose>
			</label>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div class="groupingBox">
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<div id="standbyErrorDisplay" class="errorDisplay"></div>
							<div id="standbyContainer">
									<table border="0" cellspacing="0" cellpadding="0" id="standbyTable">
									<xsl:variable name="standbyOrActive">
										<xsl:choose>
											<xsl:when test="$isStandby='true'"><xsl:value-of select="$stringsDoc//value[@key='active']" />&#160;</xsl:when>
											<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='standby']" />&#160;</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
										<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('subjectCommonNameStandby')" />
											<xsl:with-param name="label_row" select="concat($standbyOrActive,$stringsDoc//value[@key='certSubjectCommonName'])" />
											<xsl:with-param name="value_row" select="string($standbyOaName)" />
											<xsl:with-param name="max_row" select="number('60')" />
											<xsl:with-param name="validate_row" select="string('true')" />
										<xsl:with-param name="validate_name" select="string('validate-standby')" />
										<xsl:with-param name="rule-list" select="string('6;8')" />
										<xsl:with-param name="range" select="string('1;60')" />
											<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certSubjectCommonNameDescription'])" />
										</xsl:call-template>
									</table>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</xsl:if>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<xsl:value-of select="$stringsDoc//value[@key='OptionalInformation']" />:&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='OptionalCertificateDescription']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />
		<div class="groupingBox">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<div id="optionalErrorDisplay" class="errorDisplay"></div>
						<div id="optionalContainer">
								<table border="0" cellspacing="0" cellpadding="0" id="optionalTable">

									<xsl:call-template name="labelAndInputRow">

										<xsl:with-param name="id_row" select="string('subjectAlternativeName')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certSubjectAltName'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:subjectAlternativeName)" />
										<xsl:with-param name="max_row" select="number('511')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-optional')" />
									<xsl:with-param name="rule-list" select="string('0;6')" />
									<xsl:with-param name="range" select="string('0;511')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certSubjectAltNameDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">

										<xsl:with-param name="id_row" select="string('contactPerson')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certContactPerson'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:contactPerson)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-optional')" />
									<xsl:with-param name="rule-list" select="string('0;6')" />
									<xsl:with-param name="range" select="string('0;60')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certContactPersonDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('emailAddress')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certEmailAddress'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:emailAddress)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-optional')" />
									<xsl:with-param name="rule-list" select="string('0;3;6;8')" />
									<xsl:with-param name="range" select="string('0;60')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certEmailAddressDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('organizationalUnit')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certOrganizationalUnit'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:organizationalUnit)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-optional')" />
									<xsl:with-param name="rule-list" select="string('0;6')" />
									<xsl:with-param name="range" select="string('0;60')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certOrganizationalUnitDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('surname')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certSurname'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:surname)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-optional')" />
									<xsl:with-param name="rule-list" select="string('0;6')" />
									<xsl:with-param name="range" select="string('0;60')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certSurnameDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('givenName')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certGivenName'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:givenName)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-optional')" />
									<xsl:with-param name="rule-list" select="string('0;6')" />
									<xsl:with-param name="range" select="string('0;60')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certGivenNameDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('initials')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certInitials'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:initials)" />
										<xsl:with-param name="max_row" select="number('20')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-optional')" />
									<xsl:with-param name="rule-list" select="string('0;6')" />
									<xsl:with-param name="range" select="string('0;20')" />
										<xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certInitialsDescription'])" />
									</xsl:call-template>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
                    <xsl:with-param name="id_row" select="string('dnQualifier')" />
                    <xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certdnQualifier'])" />
                    <xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:dnQualifier)" />
                    <xsl:with-param name="max_row" select="number('60')" />
                    <xsl:with-param name="validate_row" select="string('true')" />
                    <xsl:with-param name="validate_name" select="string('validate-optional')" />
                    <xsl:with-param name="rule-list" select="string('0;6;10')" />
                    <xsl:with-param name="range" select="string('0;60')" />
                    <xsl:with-param name="title_row" select="string($stringsDoc//value[@key='certdnQualifierDescription'])" />
                    <!-- client-side validation of special characters -->
                    <xsl:with-param name="reg_exp">
                      <xsl:value-of select="concat('[', '^', 'a-zA-Z0-9', '\', 's', &quot;'&quot;, '(', ')', '+', '.', ',', '/', ':', '=', '?', '_', '-', ']')" />
                    </xsl:with-param>
                    <xsl:with-param name="msg_insert_key" select="'alnumCustom1'" />
									</xsl:call-template>
								</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<xsl:value-of select="$stringsDoc//value[@key='CertificateSigningAttributes']" />:&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='CertificateSigningAttributesDescription']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />
		<div class="groupingBox">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<div id="csrErrorDisplay" class="errorDisplay"></div>
						<div id="csrContainer">
								<table border="0" cellspacing="0" cellpadding="0" id="csrTable">
									<tr>
										<td id="lblPwd" nowrap="true">
										<xsl:element name="span">
											<xsl:attribute name="title">
												<xsl:value-of select="string($stringsDoc//value[@key='certChallengePasswordDescription'])" />
											</xsl:attribute>
												<xsl:value-of select="string(concat($stringsDoc//value[@key='certChallengePassword'],':'))" />
										</xsl:element>
										</td>
										<td width="10">&#160;</td>
										<td>
											<xsl:element name="input">
												<xsl:attribute name="autocomplete">off</xsl:attribute>
												<xsl:attribute name="type">password</xsl:attribute>
												<xsl:attribute name="id">password</xsl:attribute>
												<xsl:attribute name="name">password</xsl:attribute>
												<xsl:attribute name="class">stdInput</xsl:attribute>
												<!-- validation rules: string, [optional if editing], to 30 chars -->
											<xsl:attribute name="validate-csr">true</xsl:attribute>
											<xsl:attribute name="range">1;30</xsl:attribute>
                      <xsl:attribute name="rule-list">0;6</xsl:attribute>
                      <xsl:attribute name="mirror-controlled">true</xsl:attribute>
												<xsl:attribute name="caption-label">lblPwd</xsl:attribute>
												<xsl:attribute name="maxlength">30</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of select="string($certificateInfoDoc//hpoa:certData/hpoa:challengePassword)" />
												</xsl:attribute>
												<xsl:attribute name="title">
													<xsl:value-of select="string($stringsDoc//value[@key='certUnstructuredNameDescription'])" />
												</xsl:attribute>
											</xsl:element>
										</td>
									</tr>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<tr>
										<td nowrap="true">
											<span>
											<xsl:value-of select="string(concat($stringsDoc//value[@key='confirmPassword'],':'))" />
											</span>
										</td>
										<td width="10">&#160;</td>
										<td>
											<!-- validation rules: mirror to 'password' input -->
										<input class="stdInput" maxlength="30"  validate-csr="true" rule-list="7" related-inputs="password" msg-key="InputPasswordConfirm" type="password" autocomplete="off" id="passwordConfirm" name="passwordConfirm" />
										</td>
									</tr>
									<tr>
										<td colspan="3" class="formSpacer">&#160;</td>
									</tr>
									<xsl:call-template name="labelAndInputRow">
										<xsl:with-param name="id_row" select="string('unstructuredName')" />
										<xsl:with-param name="label_row" select="string($stringsDoc//value[@key='certUnstructuredName'])" />
									<xsl:with-param name="value_row" select="string($certificateInfoDoc//hpoa:certData/hpoa:unstructuredName)" />
										<xsl:with-param name="max_row" select="number('60')" />
										<xsl:with-param name="validate_row" select="string('true')" />
									<xsl:with-param name="validate_name" select="string('validate-csr')" />
									<xsl:with-param name="rule-list" select="string('0;6')" />
									<xsl:with-param name="range" select="string('0;60')" />
										<xsl:with-param name="title_row"  select="string($stringsDoc//value[@key='certUnstructuredNameDescription'])" />
									</xsl:call-template>
								</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' onclick="certificateRequestSubmit();">
								<xsl:value-of select="$stringsDoc//value[@key='apply']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
