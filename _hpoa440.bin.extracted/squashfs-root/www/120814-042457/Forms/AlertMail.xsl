<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="alertMailSettings">
		
		<xsl:param name="nameSupported" />

    <xsl:element name="input">
      <xsl:attribute name="style">margin-left:0px;</xsl:attribute>
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="class">stdCheckBox</xsl:attribute>
      <xsl:attribute name="id">alertMailEnabled</xsl:attribute>
      <xsl:attribute name="onclick">toggleAlertMailEnabled(this);</xsl:attribute>
      <xsl:if test="$serviceUserAcl = $USER">
        <xsl:attribute name="disabled">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="$networkInfoDoc//hpoa:alertmailEnabled='true'">
        <xsl:attribute name="checked">true</xsl:attribute>
      </xsl:if>
    </xsl:element>
    <label for="alertMailEnabled">
      <xsl:value-of select="$stringsDoc//value[@key='enableAlertMail']" />
    </label>
    <br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<div id="alertMailForm">
			
			<table border="0" cellspacing="0" cellpadding="0" style="margin-left:18px;">
				<tr>
					<td nowrap="true" style="width:1%;">
						<span id="lblEmail"><xsl:value-of select="$stringsDoc//value[@key='emailAddress*']" /></span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">
              <xsl:attribute name="style">width:290px;</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:alertmailEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">mailBox</xsl:attribute>
							<xsl:attribute name="id">mailBox</xsl:attribute>
							<xsl:if test="$serviceUserAcl = $USER">
								<xsl:attribute name="readonly">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">
								<xsl:value-of select="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:receiver" />
							</xsl:attribute>

							<xsl:attribute name="validate-me">true</xsl:attribute>
							<xsl:attribute name="rule-list">6;8</xsl:attribute>
							<xsl:attribute name="range">1;64</xsl:attribute>
							<xsl:attribute name="caption-label">lblEmail</xsl:attribute>
							
							<xsl:attribute name="maxlength">64</xsl:attribute>
							
						</xsl:element>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<xsl:if test="$nameSupported!='true'">
				<xsl:element name="tr">
					<td nowrap="true">
						<span id="lblDomain"><xsl:value-of select="$stringsDoc//value[@key='alertSenderDomain']" /></span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<div id="senderDomainForm">
						<xsl:element name="input">
              <xsl:attribute name="style">width:290px;</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:alertmailEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">domain</xsl:attribute>
							<xsl:attribute name="id">domain</xsl:attribute>
							<xsl:if test="$serviceUserAcl = $USER">
								<xsl:attribute name="readonly">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">
								<xsl:value-of select="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:domain" />
							</xsl:attribute>
							
							<xsl:attribute name="maxlength">64</xsl:attribute>
							
						</xsl:element>
						</div>
					</td>
				</xsl:element>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>

				</xsl:if>
				<tr>
					<td nowrap="true">
						<span id="lblServer"><xsl:value-of select="$stringsDoc//value[@key='smtpServer']" /></span>
					</td>
					<td width="10" nowrap="true">&#160;</td>
					<td nowrap="true">
            <div>
						<xsl:element name="input">
							<xsl:attribute name="style">width:290px;</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:alertmailEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">smtp</xsl:attribute>
							<xsl:attribute name="id">smtp</xsl:attribute>
							<xsl:if test="$serviceUserAcl = $USER">
								<xsl:attribute name="readonly">true</xsl:attribute>
							</xsl:if>
							<xsl:if test="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:server!=$EMPTY_IP_TEST">
								<xsl:attribute name="value">
									<xsl:value-of select="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:server" />
								</xsl:attribute>
							</xsl:if>

							<xsl:attribute name="validate-me">true</xsl:attribute>
							<xsl:attribute name="rule-list">6;8</xsl:attribute>
							<xsl:attribute name="range">1;64</xsl:attribute>
							<xsl:attribute name="caption-label">lblServer</xsl:attribute>
							
							<xsl:attribute name="maxlength">64</xsl:attribute>
						</xsl:element>&#160;<xsl:value-of select="$stringsDoc//value[@key='ipDnsExample']" />
						</div>
						
					</td>
				</tr>
				<xsl:if test="$nameSupported='true'">
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<xsl:element name="tr">
					<td nowrap="true">
						<span id="lblSenderName"><xsl:value-of select="$stringsDoc//value[@key='alertSenderName']" /></span>
					</td>
					<td width="10">&#160;</td>
					<td>            
						<xsl:element name="input">
              <xsl:attribute name="style">width:290px;</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:alertmailEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">senderName</xsl:attribute>
							<xsl:attribute name="id">senderName</xsl:attribute>
							<xsl:if test="$serviceUserAcl = $USER">
								<xsl:attribute name="readonly">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">
								<xsl:value-of select="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:extraData[@hpoa:name='SenderName']" />
							</xsl:attribute>
							
							<xsl:attribute name="maxlength">40</xsl:attribute>
							
						</xsl:element>
					</td>
				</xsl:element>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<xsl:element name="tr">
					<td nowrap="true">
						<xsl:element name="input">
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="name">senderEmailOption</xsl:attribute>
							<xsl:attribute name="id">senderDomainOption</xsl:attribute>
              <xsl:attribute name="style">margin-left:0px;</xsl:attribute>
							<xsl:attribute name="value">domain</xsl:attribute>
							<xsl:if test="$networkInfoDoc//hpoa:alertmailEnabled!='true'">
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:if>
							<xsl:if test="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:domain != ''">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="onclick">toggleSenderOption(this);</xsl:attribute>
						</xsl:element>
						<label for="senderDomainOption">
						<span id="lblDomain"><xsl:value-of select="$stringsDoc//value[@key='alertSenderDomain']" /></span>
						</label>
					</td>
					<td width="10">&#160;</td>
					<td>
						<div id="senderDomainForm">
						<xsl:element name="input">
              <xsl:attribute name="style">width:290px;</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:alertmailEnabled='true' and $alertMailInfoDoc//hpoa:alertmailInfo/hpoa:domain != ''">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">domain</xsl:attribute>
							<xsl:attribute name="id">domain</xsl:attribute>
							<xsl:if test="$serviceUserAcl = $USER">
								<xsl:attribute name="readonly">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">
								<xsl:value-of select="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:domain" />
							</xsl:attribute>
							
							<xsl:attribute name="maxlength">64</xsl:attribute>
							
						</xsl:element>
						</div>
					</td>
				</xsl:element>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<xsl:element name="tr">
					<td nowrap="true">
						<xsl:element name="input">
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="name">senderEmailOption</xsl:attribute>
							<xsl:attribute name="id">senderEmailOption</xsl:attribute>
              <xsl:attribute name="style">margin-left:0px;</xsl:attribute>
							<xsl:attribute name="value">email</xsl:attribute>
							<xsl:if test="$networkInfoDoc//hpoa:alertmailEnabled!='true'">
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:if>
							<xsl:if test="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:extraData[@hpoa:name='SenderEmail'] != ''">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="onclick">toggleSenderOption(this);</xsl:attribute>
						</xsl:element>
						<label for="senderEmailOption">
						<span id="lblSenderEmail"><xsl:value-of select="$stringsDoc//value[@key='alertSenderEmail']" /></span>
						</label>
					</td>
					<td width="10">&#160;</td>
					<td>
						<div id="senderEmailForm">
						<xsl:element name="input">
              <xsl:attribute name="style">width:290px;</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:alertmailEnabled='true' and $alertMailInfoDoc//hpoa:alertmailInfo/hpoa:extraData[@hpoa:name='SenderEmail'] != ''">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="name">senderEmail</xsl:attribute>
							<xsl:attribute name="id">senderEmail</xsl:attribute>
							<xsl:if test="$serviceUserAcl = $USER">
								<xsl:attribute name="readonly">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">
								<xsl:value-of select="$alertMailInfoDoc//hpoa:alertmailInfo/hpoa:extraData[@hpoa:name='SenderEmail']" />
							</xsl:attribute>
							
							<xsl:attribute name="maxlength">64</xsl:attribute>
							
						</xsl:element>
						</div>
					</td>
				</xsl:element>
				</xsl:if> <!-- nameSupported='true' -->
			</table>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

