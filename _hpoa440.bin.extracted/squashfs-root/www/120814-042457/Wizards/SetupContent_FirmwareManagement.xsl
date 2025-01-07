<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl"/>

  <xsl:param name="stringsDoc" />
	<xsl:param name="encNum" />
	<xsl:param name="fwManagementSettings" />

  <xsl:template match="*">

		<div id="stepInnerContent">

			<xsl:value-of select="$stringsDoc//value[@key='firmwareMgmtDesc']"/>
			<br />
			<span class="whiteSpacer">&#160;</span><br />

			<xsl:variable name="firmwareIsoUrl" select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:isoUrl" />

			<div class="errorDisplay" id="generalErrorDisplay"></div>

			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="id">fwManagementEnabled</xsl:attribute>
				<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:fwManagementEnabled='true'">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
			</xsl:element>
			<xsl:value-of select="$stringsDoc//value[@key='enableFwManagement']"/>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<tr>
					<td>
						<span id="lblFirmwareIso">
							<label for="srcSelect_URL">
								<xsl:value-of select="$stringsDoc//value[@key='firmwareIsoUrl:']"/>
							</label>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td id="frmIsoUrl">
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="class">stdInput</xsl:attribute>
							<xsl:attribute name="style">width:300px;</xsl:attribute>
							<xsl:attribute name="id">isoUrl</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$firmwareIsoUrl"/>
							</xsl:attribute>
						</xsl:element>
					</td>
					<td style="padding-left: 10px;">
						<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:dvdStatus='true'">
							<xsl:call-template name="statusIcon">
								<xsl:with-param name="statusCode" select="'OP_STATUS_OK'" />
							</xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='validFwUrl']"/>
						</xsl:if>
					</td>
				</tr>
			</table>
			<br />
			<hr />
			<br />
			<xsl:value-of select="$stringsDoc//value[@key='updatePolicy:']"/>&#160;<em>
				<xsl:value-of select="$stringsDoc//value[@key='updatePolicyDesc']"/>
			</em>
			<br /><span class="whiteSpacer">&#160;</span><br />

			<table cellpadding="0" cellspacing="0" border="0" id="bayAccessContainer">
				<tr>
					<td>
						<span id="lblPolicy0">

							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">policy0</xsl:attribute>
								<xsl:attribute name="name">policySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updatePolicy='0'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">0</xsl:attribute>
							</xsl:element>

						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="policy0">
							<xsl:value-of select="$stringsDoc//value[@key='manualDiscoveryManualUpdate']"/>
						</label>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td>
						<span id="lblPolicy1">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">policy1</xsl:attribute>
								<xsl:attribute name="name">policySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updatePolicy='1'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">1</xsl:attribute>
							</xsl:element>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="policy1">
							<xsl:value-of select="$stringsDoc//value[@key='automaticDiscoveryFirmware']"/>
						</label>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
					<td>
						<span id="lblPolicy2">
							<xsl:element name="input">
								<xsl:attribute name="type">radio</xsl:attribute>
								<xsl:attribute name="id">policy2</xsl:attribute>
								<xsl:attribute name="name">policySelect</xsl:attribute>
								<xsl:if test="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updatePolicy='2'">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">2</xsl:attribute>
							</xsl:element>
						</span>
					</td>
					<td width="10">&#160;</td>
					<td>
						<label for="policy2">
							<xsl:value-of select="$stringsDoc//value[@key='automaticUpdateFirmware']"/>
						</label>
					</td>
				</tr>

			</table>

			<br />
			<hr />
			<br />

			<xsl:value-of select="$stringsDoc//value[@key='scheduleUpdate:']"/>&#160;<em>
				<xsl:value-of select="$stringsDoc//value[@key='wizScheduleDesc']"/>
			</em><br />
			<span class="whiteSpacer">&#160;</span><br />
			<form name="scheduleForm">
				<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
					<tr>
						<td>
							<span id="lblScheduleDate">
								<xsl:value-of select="$stringsDoc//value[@key='fwDate:']"/>
							</span>
						</td>
						<td width="10">&#160;</td>
						<td>
							<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
								<tr>
									<td>
										<xsl:element name="input">
											<xsl:attribute name="class">stdInput</xsl:attribute>
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="style">width:150px;</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updateDate"/>
											</xsl:attribute>
											<xsl:attribute name="id">scheduleDate</xsl:attribute>
										</xsl:element>
									</td>
									<td style="vertical-align:center; padding-left: 2px;" id="calendarContainer"></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<tr>
						<td>
							<span id="lblScheduleTime">
								<xsl:value-of select="$stringsDoc//value[@key='fwTime:']"/>
							</span>
						</td>
						<td width="10">&#160;</td>
						<td>
							<xsl:element name="input">
								<xsl:attribute name="class">stdInput</xsl:attribute>
								<xsl:attribute name="type">text</xsl:attribute>
								<xsl:attribute name="style">width:150px;</xsl:attribute>

								<xsl:attribute name="value">
									<xsl:value-of select="$fwManagementSettings//hpoa:firmwareManagementSettings/hpoa:updateTime"/>
								</xsl:attribute>

								<xsl:attribute name="id">scheduleTime</xsl:attribute>

							</xsl:element>
						</td>
					</tr>
				</table>
			</form>

		</div>
		<div id="waitContainer" class="waitContainer"></div>
		
	</xsl:template>
	
</xsl:stylesheet>

