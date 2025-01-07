<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/ServerSelect.xsl" />
	<xsl:include href="../Forms/InterconnectSelect.xsl" />
	
	<xsl:template name="groupInformation">
		
		<table border="0" cellpadding="0" cellspacing="0" id="table6">
			<tbody>
				<tr>
					<td>
						<em><xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;*</em>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
					</td>
				</tr>
				<tr>
					<td valign="top">
						<table cellpadding="0" cellspacing="0" border="0">
							<tbody>
								<tr>
									<td valign="top">
										<table border="0" cellspacing="0" cellpadding="0">
											<tbody>
												<tr>
													<td id="lblGroupName" nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='groupName']" />:*</td>
													<td width="10">&#160;</td>
													<td>

														<xsl:choose>
															<!-- Display a text box when we're adding a user. -->
															<xsl:when test="$action='add'">
																<xsl:element name="input">
																	<xsl:attribute name="type">text</xsl:attribute>
																	<xsl:attribute name="id">groupName</xsl:attribute>
																	<xsl:attribute name="name">groupName</xsl:attribute>
																	<xsl:attribute name="class">stdInput</xsl:attribute>
																  <!-- validation rules: string, 1 to 255 chars -->
																  <xsl:attribute name="validate-me">true</xsl:attribute>
																  <xsl:attribute name="rule-list">6</xsl:attribute>
																  <xsl:attribute name="caption-label">lblGroupName</xsl:attribute>
																  <xsl:attribute name="range">1;255</xsl:attribute>
																	<xsl:attribute name="maxlength">255</xsl:attribute>
																	<!-- end validation rules-->
																</xsl:element>
															</xsl:when>
															<!-- Only display the username when we're editing user information. -->
															<xsl:otherwise>
																<span id="groupName">
																	<xsl:value-of select="$groupInfoDoc//hpoa:ldapGroupInfo/hpoa:ldapGroupName"/>
																</span>
															</xsl:otherwise>

														</xsl:choose>

													</td>
												</tr>
												<tr>
													<td colspan="3" class="formSpacer">&#160;</td>
												</tr>
												<tr>
													<td id="groupDescription" nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='description']" />:</td>
													<td width="10">&#160;</td>
													<td>
														<xsl:element name="input">
															<xsl:attribute name="type">text</xsl:attribute>
															<xsl:attribute name="id">description</xsl:attribute>
															<xsl:attribute name="name">description</xsl:attribute>
															<xsl:attribute name="class">stdInput</xsl:attribute>
															<!-- validation rules: optional, string, up to 20 chars -->
															<xsl:attribute name="validate-me">true</xsl:attribute>
															<xsl:attribute name="rule-list">0;6</xsl:attribute>
															<xsl:attribute name="range">1;58</xsl:attribute>
															<xsl:attribute name="caption-label">groupDescription</xsl:attribute>
															<!-- end validation rules -->
															<xsl:attribute name="value">
																<xsl:value-of select="$groupInfoDoc//hpoa:ldapGroupInfo/hpoa:description"/>
															</xsl:attribute>
															<xsl:attribute name="maxlength">58</xsl:attribute>
														</xsl:element>
													</td>
												</tr>
												<tr>
													<td colspan="3" class="formSpacer">&#160;</td>
												</tr>
												<tr>
													<td nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='privilegeLevel']" />:</td>
													<td width="10">&#160;</td>
													<td>
														<xsl:call-template name="accessPermissionsMenu">
															<xsl:with-param name="currentAcl" select="$groupInfoDoc//hpoa:ldapGroupInfo/hpoa:acl" />
														</xsl:call-template>
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="groupPermissions">
		
		<table cellpadding="0" cellspacing="0" border="0" width="100%" id="bayAccessContainer">
			<tr>
				<td colspan="2" valign="top">
					<xsl:element name="input">
            <xsl:attribute name="onclick">oaToggle(<xsl:value-of select="$encNum" />,this.checked);</xsl:attribute>
						<xsl:attribute name="type">checkbox</xsl:attribute>
						<xsl:attribute name="class">stdCheckBox</xsl:attribute>
						<xsl:attribute name="name">userOaAccess</xsl:attribute>
						<xsl:attribute name="id">userOaAccess</xsl:attribute>
						<xsl:if test="hpoa:oaAccess='true'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
					</xsl:element><label for="userOaAccess"><xsl:value-of select="$stringsDoc//value[@key='oaBays']" /></label>
					<span class="whiteSpacer">&#160;</span><br />
					<hr />
				</td>
			</tr>
			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>
			<tr>
				<td width="50%" valign="top">
					<xsl:value-of select="$stringsDoc//value[@key='deviceBayAccess']" /><br />
					<span class="whiteSpacer">&#160;</span>
					<br />
					<xsl:call-template name="ServerSelect">
						<xsl:with-param name="enclosureNumber" select="$encNum" />
						<xsl:with-param name="enclosureType" select="$enclosureType" />
						<xsl:with-param name="numBays" select="$numDeviceBays" />
					</xsl:call-template>
				</td>
				<td width="50%" valign="top">
					<xsl:value-of select="$stringsDoc//value[@key='interConnectBayAccess']" /><br />
					<span class="whiteSpacer">&#160;</span>
					<br />
					<xsl:call-template name="InterconnectSelect">
						<xsl:with-param name="enclosureNumber" select="$encNum" />
						<xsl:with-param name="enclosureType" select="$enclosureType" />
						<xsl:with-param name="numBays" select="$numIoBays" />
					</xsl:call-template>
				</td>
			</tr>
		</table>

	</xsl:template>
	
	<xsl:template name="accessPermissionsMenu">

		<xsl:param name="currentAcl" />
		
    <select id="userBayAcl" onchange='javascript:setUserAcl({$encNum}, this.options[selectedIndex].value )'>

			<xsl:element name="option">
				<xsl:attribute name="value">ADMINISTRATOR</xsl:attribute>
				<xsl:if test="$currentAcl='ADMINISTRATOR'">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				Administrator
			</xsl:element>

			<xsl:element name="option">
				<xsl:attribute name="value">OPERATOR</xsl:attribute>
				<xsl:if test="$currentAcl='OPERATOR'">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				Operator
			</xsl:element>

			<xsl:element name="option">
				<xsl:attribute name="value">USER</xsl:attribute>
				<xsl:if test="($currentAcl='USER') or (string-length($currentAcl)=0)">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				User
			</xsl:element>
			
		</select>
		
	</xsl:template>


</xsl:stylesheet>

