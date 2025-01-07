<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="userInfoDoc" />
	<xsl:param name="action" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="encNum" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="userOaAccess" />
	<xsl:param name="isCurrentUser">false</xsl:param>
	<xsl:param name="enclosureType" select="0" />
	<xsl:param name="lcdInfoDoc" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="numIoBays" select="8" />
	<xsl:param name="numDeviceBays" select="16" />
	<xsl:param name="passwordSettingsDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Forms/Users.xsl" />	
  
	<xsl:template match="*" name="editUser">
		
		<xsl:value-of select="$stringsDoc//value[@key='userInformation']" /><br />
		<span class="whiteSpacer">&#160;</span><br />
    
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td class="groupingBox">
					<div id="errorDisplay" class="errorDisplay"></div>
					<xsl:call-template name="userInformation" />
				</td>
			</tr>
		</table>

		<span class="whiteSpacer">&#160;</span><br />
		
		<xsl:if test="($serviceUserAcl=$ADMINISTRATOR and $userOaAccess='true') and not($userInfoDoc//hpoa:userInfo/hpoa:username='Administrator')">

			<span class="whiteSpacer">&#160;</span><br />

			<xsl:value-of select="$stringsDoc//value[@key='userPermissions:']" />&#160;
			<em><xsl:value-of select="$stringsDoc//value[@key='clickIndividualBayOrAllBay']" /></em><br />
			<span class="whiteSpacer">&#160;</span><br />

			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td class="groupingBox">
						<xsl:for-each select="$userInfoDoc//hpoa:bayPermissions">
							<xsl:call-template name="userPermissions" />
						</xsl:for-each>
					</td>
				</tr>
			</table>
			<span class="whiteSpacer">&#160;</span><br />

		</xsl:if>

		<div align="right">
			<div class='buttonSet' style="margin-bottom:0px;">
				<div class='bWrapperUp'>
					<div>
						<div>

							<xsl:choose>
								<xsl:when test="$action='add'">
									<button type='button' class='hpButton' id="addButton" onclick="addUser();">
										<xsl:value-of select="$stringsDoc//value[@key='addUser']" />
									</button>
								</xsl:when>
								<xsl:otherwise>
									<button type='button' class='hpButton' id="applyButton" onclick="applyUserSettings();">
										<xsl:value-of select="$stringsDoc//value[@key='updateUser']" />
									</button>
								</xsl:otherwise>
							</xsl:choose>

						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>
