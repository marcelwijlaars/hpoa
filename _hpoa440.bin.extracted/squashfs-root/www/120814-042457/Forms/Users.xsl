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
	<xsl:include href="../Templates/globalTemplates.xsl" />
	
	<xsl:template name="userInformation">
	
		<xsl:param name="showTooltip" />
		
		<table border="0" cellpadding="0" cellspacing="0" id="table6">
			<tbody>
				<tr>
					<td valign="top">
						<table cellpadding="0" cellspacing="0" border="0">
							<tbody>
								<tr>
									<td valign="top">

										<em>
											<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
										</em>
										<br />
										<span class="whiteSpacer">&#160;</span>
										<br />
										
										<table border="0" cellspacing="0" cellpadding="0">
											<tbody>
												<tr>
													<td id="lblUsername" nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='username:']" /><xsl:value-of select="$stringsDoc//value[@key='asterisk']" /></td>
													<td width="10">&#160;</td>
													<td>

														<xsl:choose>
															<!-- Display a text box when we're adding a user. -->
															<xsl:when test="$action='add'">
																<xsl:element name="input">
																	<xsl:attribute name="type">text</xsl:attribute>
																	<xsl:attribute name="id">username</xsl:attribute>
																	<xsl:attribute name="name">username</xsl:attribute>
																	<xsl:attribute name="class">stdInput</xsl:attribute>
																  <!-- validation rules: string, no spaces, 1 to 40 chars -->
																  <xsl:attribute name="validate-me">true</xsl:attribute>
																  <xsl:attribute name="rule-list">6;8</xsl:attribute>
																  <xsl:attribute name="caption-label">lblUsername</xsl:attribute>
																  <xsl:attribute name="range">1;40</xsl:attribute>
																	<xsl:attribute name="maxlength">40</xsl:attribute>
																  <!-- end validation rules-->
																</xsl:element>
															</xsl:when>
															<!-- Only display the username when we're editing user information. -->
															<xsl:otherwise>
																<span id="username">
																	<xsl:value-of select="$userInfoDoc//hpoa:userInfo/hpoa:username"/>
																</span>
															</xsl:otherwise>

														</xsl:choose>
														
													</td>
												</tr>
												<tr>
													<td colspan="3" class="formSpacer">&#160;</td>
												</tr>
												<tr>
													<td id="lblPwd" nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='password:']" /><xsl:value-of select="$stringsDoc//value[@key='asterisk']" /></td>
													<td width="10">&#160;</td>
													<td>
													<xsl:element name="input">
													  <xsl:attribute name="autocomplete">off</xsl:attribute>
													  <xsl:attribute name="type">password</xsl:attribute>
													  <xsl:attribute name="id">password</xsl:attribute>
													  <xsl:attribute name="name">password</xsl:attribute>
													  <xsl:attribute name="class">stdInput</xsl:attribute>
													  <!-- validation rules: string, [optional if editing], N to 8 chars -->
													  <xsl:attribute name="validate-me">true</xsl:attribute>
													  <!-- use the optional rule if not in add mode -->
													  <xsl:attribute name="rule-list"><xsl:if test="not($action='add')">0;</xsl:if>6</xsl:attribute>
													  <xsl:attribute name="range"><xsl:value-of select="$passwordSettingsDoc//hpoa:passwordSettings/hpoa:minPasswordLength" />;40</xsl:attribute>
													  <xsl:attribute name="caption-label">lblPwd</xsl:attribute>
                            <xsl:attribute name="mirror-controlled">true</xsl:attribute>
														<xsl:attribute name="maxlength">40</xsl:attribute>
													</xsl:element>
													<xsl:if test="$showTooltip">
														<xsl:call-template name="simpleTooltip">
															<xsl:with-param name="msg" select="$stringsDoc//value[@key='passwordsMayVary']" />
														</xsl:call-template>
													</xsl:if>
													</td>
												</tr>
												<tr>
													<td colspan="3" class="formSpacer">&#160;</td>
												</tr>
												<tr>
													<td nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='passwordConfirm:']" /><xsl:value-of select="$stringsDoc//value[@key='asterisk']" /></td>
													<td width="10">&#160;</td>
													<td>
													<!-- validation rules: mirror to 'password' input -->
														<input class="stdInput" maxlength="40"  validate-me="true" rule-list="7" caption-label="lblPwd" related-inputs="password" autocomplete="off" type="password" id="passwordConfirm" name="passwordConfirm" />
													</td>
												</tr>
												<tr>
													<td colspan="3" class="formSpacer">&#160;</td>
												</tr>
												<tr>
													<td id="lblFullname" nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='fullName:']" /></td>
													<td width="10">&#160;</td>
													<td>
														<xsl:element name="input">
															<xsl:attribute name="type">text</xsl:attribute>
															<xsl:attribute name="id">fullName</xsl:attribute>
															<xsl:attribute name="name">fullName</xsl:attribute>
															<xsl:attribute name="class">stdInput</xsl:attribute>
														  <!-- validation rules: optional, string, up to 20 chars -->
														  <xsl:attribute name="validate-me">true</xsl:attribute>
														  <xsl:attribute name="rule-list">0;6</xsl:attribute>
														  <xsl:attribute name="range">1;20</xsl:attribute>
														  <xsl:attribute name="caption-label">lblFullname</xsl:attribute>
														  <!-- end validation rules -->
															<xsl:attribute name="value">
																<xsl:value-of select="$userInfoDoc//hpoa:userInfo/hpoa:fullname"/>
															</xsl:attribute>
															<xsl:attribute name="maxlength">20</xsl:attribute>
														</xsl:element>
													</td>
												</tr>
												<tr>
													<td colspan="3" class="formSpacer">&#160;</td>
												</tr>
												<tr>
													<td id="lblContact" nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='contact:']" /></td>
													<td width="10">&#160;</td>
													<td>
														<xsl:element name="input">
															<xsl:attribute name="type">text</xsl:attribute>
															<xsl:attribute name="id">contact</xsl:attribute>
															<xsl:attribute name="name">contact</xsl:attribute>
															<xsl:attribute name="class">stdInput</xsl:attribute>
															<!-- validation rules: optional, string, up to 20 chars -->
															<xsl:attribute name="validate-me">true</xsl:attribute>
															<xsl:attribute name="rule-list">0;6</xsl:attribute>
															<xsl:attribute name="range">1;20</xsl:attribute>
															<xsl:attribute name="caption-label">lblContact</xsl:attribute>
															<!-- end validation rules -->
															<xsl:attribute name="value">
																<xsl:value-of select="$userInfoDoc//hpoa:userInfo/hpoa:contactInfo"/>
															</xsl:attribute>
															<xsl:attribute name="maxlength">20</xsl:attribute>
														</xsl:element>
													</td>
												</tr>
												<xsl:if test="($serviceUserAcl=$ADMINISTRATOR and $userOaAccess='true') and not($userInfoDoc//hpoa:userInfo/hpoa:username='Administrator')">
													<tr>
														<td colspan="3" class="formSpacer">&#160;</td>
													</tr>
													<tr>
														<td nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='privilegeLevel:']" /></td>
														<td width="10">&#160;</td>
														<td>
															<xsl:call-template name="accessPermissionsMenu">
																<xsl:with-param name="currentAcl" select="$userInfoDoc//hpoa:userInfo/hpoa:acl" />
															</xsl:call-template>
														</td>
													</tr>
													<tr>
														<td colspan="3">
															<span class="whiteSpacer">&#160;</span>
															<br />
														</td>
													</tr>
													<tr>
														<td colspan="3">
															<xsl:element name="input">
																<xsl:attribute name="type">checkbox</xsl:attribute>
																<xsl:attribute name="class">stdCheckBox</xsl:attribute>
																<xsl:attribute name="id">chkUserEnabled</xsl:attribute>
																<xsl:if test="$userInfoDoc//hpoa:userInfo/hpoa:isEnabled='true' or $action='add'">
																	<xsl:attribute name="checked">true</xsl:attribute>
																	<!-- don't allow the current user to uncheck their own account -->                                 
																	<xsl:if test="$isCurrentUser='true'">
																		<xsl:attribute name="disabled">disabled</xsl:attribute>
																	</xsl:if>                                 
																</xsl:if>
															</xsl:element>
															<label for="chkUserEnabled"><xsl:value-of select="$stringsDoc//value[@key='userEnabled:']" />&#160;</label>
															<em><xsl:value-of select="$stringsDoc//value[@key='unCheckToDisableUserAccount']" /></em>
														</td>
													</tr>

												</xsl:if>
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

	<xsl:template name="userPermissions">
		
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
				<xsl:variable name="disableBoxes">
					<xsl:value-of select="hpoa:oaAccess='true' and $userInfoDoc//hpoa:userInfo/hpoa:acl='ADMINISTRATOR'"/>
				</xsl:variable>
				<td width="50%" valign="top">
					<xsl:value-of select="$stringsDoc//value[@key='deviceBayAccess']" /><br />
					<span class="whiteSpacer">&#160;</span>
					<br />
					<xsl:call-template name="ServerSelect">
						<xsl:with-param name="enclosureNumber" select="$encNum" />
						<xsl:with-param name="checkAll" select="$disableBoxes" />
						<xsl:with-param name="disableAll" select="$disableBoxes" />
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
						<xsl:with-param name="checkAll" select="$disableBoxes" />
						<xsl:with-param name="disableAll" select="$disableBoxes" />
						<xsl:with-param name="enclosureType" select="$enclosureType" />
						<xsl:with-param name="numBays" select="$numIoBays" />
					</xsl:call-template>
				</td>
			</tr>
		</table>

	</xsl:template>

	<xsl:template name="accessPermissionsMenu">

		<xsl:param name="currentAcl" select="''"/>
		<select id="userBayAcl" onchange='javascript:setUserAcl({$encNum}, this.options[this.selectedIndex].value )'>

			<xsl:element name="option">
				<xsl:attribute name="value">ADMINISTRATOR</xsl:attribute>
				<xsl:if test="$currentAcl='ADMINISTRATOR'">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$stringsDoc//value[@key='administrator']" />
			</xsl:element>

			<xsl:element name="option">
				<xsl:attribute name="value">OPERATOR</xsl:attribute>
				<xsl:if test="$currentAcl='OPERATOR'">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$stringsDoc//value[@key='operator']" />
			</xsl:element>

			<xsl:element name="option">
				<xsl:attribute name="value">USER</xsl:attribute>
				<xsl:if test="$currentAcl='USER' or string-length($currentAcl)=0">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$stringsDoc//value[@key='user']" />
			</xsl:element>
			
		</select>
		
	</xsl:template>


</xsl:stylesheet>

