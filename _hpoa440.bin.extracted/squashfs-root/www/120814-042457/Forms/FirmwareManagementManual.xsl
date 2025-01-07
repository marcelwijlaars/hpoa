<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Forms/ServerSelect.xsl" />
	<xsl:include href="../Forms/InterconnectSelect.xsl" />
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureType" select="0" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="numIoBays" select="8" />
	<xsl:param name="numDeviceBays" select="16" />
	<xsl:param name="encNum" />
	<xsl:param name="action" />
	<xsl:param name="fwManagementSettings" />
        <xsl:param name="serviceUserAcl" />
        <xsl:param name="bladeInfoDoc" />


	<xsl:template match="*">

		<xsl:choose>
			<xsl:when test="$action='discovery'">
				<b><xsl:value-of select="$stringsDoc//value[@key='manualDiscovery']" /></b>
			</xsl:when>
			<xsl:when test="$action='update'">
				<b><xsl:value-of select="$stringsDoc//value[@key='manualUpdate']" /></b>
			</xsl:when>
			<xsl:otherwise>
				<b><xsl:value-of select="$stringsDoc//value[@key='baysToInclude']" /></b>
			</xsl:otherwise>
		</xsl:choose>
		<br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:isoUrl='' and $action != 'include'">
			<div class="groupingBox">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td style="vertical-align:top;">
						<img src="/120814-042457/images/status_informational_32.gif" width="32" height="32" />
					</td>
					<td style="width:10px;">&#160;</td>
					<td>
						<xsl:value-of select="$stringsDoc//value[@key='fwManualUpdateFailDesc1']" />
					</td>
				</tr>
			</table>
			</div>
			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
		</xsl:if>

		<div class="errorDisplay"  id="errorDisplay"></div>

		<xsl:value-of select="$stringsDoc//value[@key='baySelection:']" />&#160;<em>
			<xsl:choose>
				<xsl:when test="$action='discovery'">
					<xsl:value-of select="$stringsDoc//value[@key='manualUpdateDesc']" />
				</xsl:when>
				<xsl:when test="$action='update'">
					<xsl:value-of select="$stringsDoc//value[@key='manualDiscDesc']" />
				</xsl:when>
				<!-- Bays to include -->
				<xsl:otherwise>
					<xsl:value-of select="$stringsDoc//value[@key='baysToIncludeDesc']" />
				</xsl:otherwise>
			</xsl:choose>
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div class="groupingBox">

			<xsl:if test="$action!='discovery'">
				<!--
				<xsl:variable name="oaLabel">
					<xsl:choose>
						<xsl:when test="$action='update'"><xsl:value-of select="$stringsDoc//value[@key='updateOA']" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='firmwareManageAllOA']" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:element name="input">
					<xsl:attribute name="type">checkbox</xsl:attribute>
					<xsl:attribute name="class">stdCheckBox</xsl:attribute>
					<xsl:attribute name="name">oaSelect</xsl:attribute>
					<xsl:attribute name="id">oaSelect</xsl:attribute>
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:element>&#160;<label for="oaSelect"><xsl:value-of select="$oaLabel"/></label>
				<span class="whiteSpacer">&#160;</span>
				<br />
				<hr />
				-->
			</xsl:if>

			<table cellpadding="0" cellspacing="0" border="0" width="96%" id="bayAccessContainer">
				<tr>
					<td width="50%" valign="top">
						<xsl:value-of select="$stringsDoc//value[@key='fwServerBays']" />
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						<xsl:variable name="chkAllLabelSvb">
							<xsl:choose>
								<xsl:when test="$action='discovery'"><xsl:value-of select="$stringsDoc//value[@key='discoverAllServers']" /></xsl:when>
								<xsl:when test="$action='update'"><xsl:value-of select="$stringsDoc//value[@key='updateAllServers']" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='firmwareManageAllServers']" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:choose>
							<xsl:when test="$action='discovery' or $action='update'">
								<xsl:call-template name="ServerSelect">
									<xsl:with-param name="enclosureNumber" select="$encNum" />
									<xsl:with-param name="checkAll" select="'true'" />
									<xsl:with-param name="disableAll" select="'false'" />
									<xsl:with-param name="enclosureType" select="$enclosureType" />
									<xsl:with-param name="numBays" select="$numDeviceBays" />
									<xsl:with-param name="checkAllLabel" select="$chkAllLabelSvb" />
                                                                        <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
                                                                        <xsl:with-param name="disableNotPresent" select="'true'" />
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:includedBays">
									<xsl:call-template name="ServerSelect">
										<xsl:with-param name="enclosureNumber" select="$encNum" />
										<!--<xsl:with-param name="checkAll" select="'true'" />-->
										<xsl:with-param name="disableAll" select="'false'" />
										<xsl:with-param name="enclosureType" select="$enclosureType" />
										<xsl:with-param name="numBays" select="$numDeviceBays" />
										<xsl:with-param name="checkAllLabel" select="$chkAllLabelSvb" />
									</xsl:call-template>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
					<xsl:if test="$action!='discovery'">
						<!--
						<xsl:variable name="chkAllLabelSwm">
							<xsl:choose>
								<xsl:when test="$action='update'"><xsl:value-of select="$stringsDoc//value[@key='updateAllVCmodules']" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='firmwareManageAllVCmodules']" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<td width="50%" valign="top">
							<xsl:value-of select="$stringsDoc//value[@key='virtualConnectBays']" />
							<br />
							<span class="whiteSpacer">&#160;</span>
							<br />
							<xsl:call-template name="InterconnectSelect">
								<xsl:with-param name="enclosureNumber" select="$encNum" />
								<xsl:with-param name="checkAll" select="'true'" />
								<xsl:with-param name="disableAll" select="'false'" />
								<xsl:with-param name="enclosureType" select="$enclosureType" />
								<xsl:with-param name="numBays" select="$numIoBays" />
								<xsl:with-param name="checkAllLabel" select="$chkAllLabelSwm" />
							</xsl:call-template>
						</td>
						-->
					</xsl:if>
				</tr>
			</table>
		</div>

		<span class="whiteSpacer">&#160;</span><br />
		
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
                                                        <xsl:element name="button">

                                                                <xsl:attribute name="type">button</xsl:attribute>
                                                                <xsl:attribute name="class">hpButton</xsl:attribute>
                                                                <xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:fwManagementEnabled!='true' or $serviceUserAcl != 'ADMINISTRATOR' ">
                                                                        <xsl:attribute name="disabled">true</xsl:attribute>
                                                                </xsl:if>
                                                                <xsl:choose>
                                                                <xsl:when test="$action='discovery'">
                                                                    <xsl:attribute name="onclick">doManualDiscoveryOrUpdate('DISCOVERY')</xsl:attribute>
                                                                    <xsl:value-of select="$stringsDoc//value[@key='startManualDiscovery']" />
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:attribute name="onclick">doManualDiscoveryOrUpdate('UPDATE')</xsl:attribute>
                                                                    <xsl:value-of select="$stringsDoc//value[@key='startManualUpdate']" />
                                                                </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:element>

						</div>
					</div>
				</div>
				
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>

