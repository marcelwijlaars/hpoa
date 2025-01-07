<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="groupInfoDoc" />
	<xsl:param name="action" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="encNum" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="userOaAccess" />
	<xsl:param name="enclosureType" select="0" />
	<xsl:param name="lcdInfoDoc" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="numIoBays" select="8" />
	<xsl:param name="numDeviceBays" select="16" />
	
	<xsl:include href="../Forms/Groups.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />
	
	<xsl:template match="*">

		<span id="actionLabel">
			<xsl:choose>

				<xsl:when test="$action='add'">
					<b>
					<xsl:value-of select="$stringsDoc//value[@key='addLdapgrp']" />
					</b>
					<br />
				</xsl:when>
				<xsl:otherwise>
					<b>
					<xsl:value-of select="$stringsDoc//value[@key='edtLdapgrp']" />
					</b>
					<br />
				</xsl:otherwise>

			</xsl:choose>
			
		</span>
		<span class="whiteSpacer">&#160;</span><br />
		
		<xsl:value-of select="$stringsDoc//value[@key='groupInformation']" /><br />
		<span class="whiteSpacer">&#160;</span><br />
    
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td class="groupingBox">
					<div id="errorDisplay" class="errorDisplay"></div>
					<xsl:call-template name="groupInformation" />
				</td>
			</tr>
		</table>

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<xsl:value-of select="$stringsDoc//value[@key='groupPermissions']" /><br />
		<span class="whiteSpacer">&#160;</span><br />

		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td class="groupingBox">
					<xsl:for-each select="$groupInfoDoc//hpoa:bayPermissions">
						<xsl:call-template name="groupPermissions" />
					</xsl:for-each>
				</td>
			</tr>
		</table>
		<span class="whiteSpacer">&#160;</span><br />
		
		<div align="right">
			<div class='buttonSet' id="groupButtonWrapper" style="margin-bottom:0px;">
				<div class='bWrapperUp' id='actionButtonWrapper'>
					<div>
						<div>
							<xsl:choose>
								<xsl:when test="$action='add'">
									<button type='button' class='hpButton' id="settingsButton" onclick="addGroup();">
										<xsl:value-of select="$stringsDoc//value[@key='addGroup']" />
									</button>
								</xsl:when>
								<xsl:otherwise>
									<button type='button' class='hpButton' id="settingsButton" onclick="applyGroupSettings();">
										<xsl:value-of select="$stringsDoc//value[@key='updateGroup']" />
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
