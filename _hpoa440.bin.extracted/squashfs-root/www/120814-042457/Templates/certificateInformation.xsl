<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="certificateInfoDoc" />
	<xsl:param name="oaName" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="emSelectId" />
	<xsl:param name="enclosureNumber" />
	<xsl:param name="fwVersion" />

	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />

	<xsl:template match="*">
		<xsl:value-of select="$stringsDoc//value[@key='certInfoDesc1']" /><br/>
		<xsl:value-of select="$stringsDoc//value[@key='certInfoDesc2']" /><br/>
		<xsl:value-of select="$stringsDoc//value[@key='certInfoDesc3']" />
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<xsl:for-each select="$certificateInfoDoc//hpoa:sslCertificateInfo">
			<table class="dataTable" cellpadding="0" cellspacing="0" border="0">
				<!--<xsl:variable name="boolOaNameMatch">
					<xsl:choose>
						<xsl:when test="$oaName=hpoa:subjectCommonName">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr class="altRowColor">
					<th class="propertyName">
						<xsl:value-of select="$stringsDoc//value[@key='status']" />
					</th>
					<td class="propertyValue">
						<xsl:choose>
							<xsl:when test="$boolOaNameMatch='true'">
								<xsl:call-template name="statusIcon" >
									<xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
								</xsl:call-template>&#160;Onboard Administrator Name and Certificate Subject Common Name Match
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="statusIcon" >
									<xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
								</xsl:call-template>&#160;Warning: Onboard Administrator Name and Certificate Subject Common Name do not Match
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certCurrentName']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="$oaName"/>&#160;&#160;&#160;&#160;
						<xsl:element name="a">
							<xsl:attribute name="href">
								javascript:editOaName();
							</xsl:attribute>
							[ edit ]
						</xsl:element>
					</td>
				</tr>-->
				<tr class="altRowColor">
					<!-- This is the OA name that appears in the browser Web address field. This is the MOST important item.  To prevent security alerts, the value of this item must exactly match the host name as it is known by the Web browser.  The browser compares the host name in the resolved Web address to the name that appears in the certificate.  The item may contain a maximum of 60 characters. 
For example, if the Web address in the address field is https://oa-0016355e5cc6.xyz.com then the value must be oa-0016355e5cc6.xyz.com.  If the Web address in the address field is https://oa-1 then the value must be oa-1.  If the Web address in the address field is https://192.168.1.1 then the value must be 192.168.1.1.
This certificate attribute is generally referred to as the common name.-->
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certCommonName']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:subjectCommonName"/>
					</td>
				</tr>
			</table>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<table class="dataTable" cellpadding="0" cellspacing="0" border="0">
				<caption><xsl:value-of select="$stringsDoc//value[@key='certificateInformation']" /></caption>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certIssuedBy']" /></th>
					<td>
						<xsl:value-of select="hpoa:issuerCommonName"/>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certValidFrom']" /></th>
					<td>
						<xsl:value-of select="hpoa:validFrom"/>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certValidUntil']" /></th>
					<td>
						<xsl:value-of select="hpoa:validTo"/>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='serialNumber']" /></th>
					<td>
						<xsl:value-of select="hpoa:serialNumber"/>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='version']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:certificateVersion"/>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='md5Fingerprint']" /></th>
					<td>
						<xsl:value-of select="hpoa:md5Fingerprint"/>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='sha1Fingerprint']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:sha1Fingerprint"/>
					</td>
				</tr>
				<xsl:if test="not(hpoa:extraData[@hpoa:name='algorithm'])= false()">
				<tr class="altRowColor">
                    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='publicKey']" /></th>
                    <td class="propertyValue">
						<xsl:choose>
							<xsl:when test="hpoa:extraData[@hpoa:name='algorithm']!='Unknown'">
								<xsl:value-of select="hpoa:extraData[@hpoa:name='algorithm']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="hpoa:extraData[@hpoa:name='keyStrength']!='0'">
								<xsl:value-of select="concat(' (', hpoa:extraData[@hpoa:name='keyStrength'], ' ', $stringsDoc//value[@key='bits'], ')')"/>
							</xsl:when>
						</xsl:choose>
                    </td>
                </tr>
				</xsl:if>
			</table>
			<span class="whiteSpacer">&#160;</span>
			<br />
		</xsl:for-each>
			<span class="whiteSpacer">&#160;</span>
			<br />
		<div id="fwVersionContent"/>
		<xsl:for-each select="$certificateInfoDoc//hpoa:certData">
			<xsl:choose>
				<xsl:when test="number($fwVersion) &lt; number('1.20')">
				
				</xsl:when>
				<xsl:otherwise>
			<table class="dataTable" cellpadding="0" cellspacing="0" border="0">
				<caption title="{$stringsDoc//value[@key='RequiredCertificateDescription']}">
				<xsl:value-of select="$stringsDoc//value[@key='RequiredInformation']" /></caption>
				<!-- Required:
				The following items are required for generating a self-signed certificate or a certificate-signing request.
				-->
				<tr>
					<!-- This item identifies the country in which the OA is located.
					The item must contain the 2-character country code.-->
					<th  title="{$stringsDoc//value[@key='certCountryDescription']}" class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certCountry']" /></th>
					<td class="propertyValue">
								<xsl:value-of select="hpoa:country"/>
					</td>
				</tr>
				<tr>
					<!-- This item identifies the state or province in which the OA is located.
					The item can contain a maximum of 30 characters.-->
					<th  title="{$stringsDoc//value[@key='certStateOrProvinceDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certStateOrProvince']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:stateOrProvince"/>
					</td>
				</tr>
				<tr>
					<!-- This item identifies the city or locality in which the OA is located.
					The item can contain a maximum of 50 characters.-->
					<th  title="{$stringsDoc//value[@key='certCityOrLocalityDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certCityOrLocality']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:cityOrLocality"/>
					</td>
				</tr>
				<tr>
					<!-- This item identifies the company or organization that owns the OA.
					When this information is used to generate a certificate-signing request,
					the issuing certificate authority can verify that the organization that
					is requesting the certificate is legally entitled to claim ownership of
					the given company or organization name. 
					The item can contain a maximum of 60 characters.-->
					<th  title="{$stringsDoc//value[@key='certOrganizationNameDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certOrganizationName']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:organizationName"/>
					</td>
				</tr>
			</table>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<table class="dataTable" cellpadding="0" cellspacing="0" border="0">
				<caption title="{$stringsDoc//value[@key='OptionalCertificateDescription']}" >
				<xsl:value-of select="$stringsDoc//value[@key='optionalData']" /></caption>
				<!-- Optional certificate data
					The following items are optional.
				-->
				<tr>
					<!-- This item is the name of the contact person who is responsible for the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certSubjectAltNameDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certSubjectAltName']" /></th>
					
					<td class="propertyValue">
						<xsl:value-of select="hpoa:subjectAlternativeName"/>	
					
					</td>
				</tr>
				<tr>
					<!-- This item is the name of the contact person who is responsible for the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certContactPersonDescription']}"  class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certContactPerson']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:contactPerson"/>
					</td>
				</tr>
				<tr>
					<!-- This item is the email address of the contact person who is responsible for the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certEmailAddressDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certEmailAddress']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:emailAddress"/>
					</td>
				</tr>
				<tr>
					<!-- This item is the unit within the company or organization that owns the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certOrganizationalUnitDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certOrganizationalUnit']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:organizationalUnit"/>
					</td>
				</tr>
				<tr>
					<!-- This item is used for the surname of the person responsible for the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certSurnameDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certSurname']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:surname"/>
					</td>
				</tr>
				<tr>
					<!-- This item is used for the given name of the person who is responsible for the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certGivenNameDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certGivenName']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:givenName"/>
					</td>
				</tr>
				<tr>
					<!-- This item is used for the initials of the person who is responsible for the OA.
					The item may contain a maximum of 20 characters.-->
					<th title="{$stringsDoc//value[@key='certInitialsDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certInitials']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:initials"/>
					</td>
				</tr>
				<tr>
					<!-- This item is used for the distinguished name qualifier for the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certdnQualifierDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certdnQualifier']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:dnQualifier"/>
					</td>
				</tr>
			</table>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<table class="dataTable" cellpadding="0" cellspacing="0" border="0">
				<caption title="{$stringsDoc//value[@key='CertificateSigningAttributesDescription']}" >
				<xsl:value-of select="$stringsDoc//value[@key='CertificateSigningReqAttributes']" /></caption>
				<!-- Certificate-signing request attributes
					The following items are optional unless they are required by your selected certificate authority.
				-->
					<!-- 
				<tr>
					-->
					<!-- This item is used to assign a password to the certificate-signing request.
					The item may contain a maximum of 30 characters.-->
			<!-- <th title="Password to the certificate-signing request" class="propertyName">Challenge Password:</th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:challengePassword"/>
					</td>
				</tr>-->
				<tr>
			<!-- This item is used for additional information, such as an unstructured name that is assigned to the OA.
					The item may contain a maximum of 60 characters.-->
					<th title="{$stringsDoc//value[@key='certUnstructuredNameDescription']}" class="propertyName">
					<xsl:value-of select="$stringsDoc//value[@key='certUnstructuredName']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="hpoa:unstructuredName"/>
					</td>
				</tr>
			</table>
			<!--<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<xsl:element name='button'>
									<xsl:attribute name='type'>button</xsl:attribute>
									<xsl:attribute name='class'>hpButton</xsl:attribute>
									<xsl:attribute name='id'>btnRemoveCertificate</xsl:attribute>
									<xsl:attribute name='onclick'>createSelfSignedCert();</xsl:attribute>
									Remove
								</xsl:element>

							</div>
						</div>
					</div>
				</div>
			</div>-->
				</xsl:otherwise>
			</xsl:choose>

		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>
