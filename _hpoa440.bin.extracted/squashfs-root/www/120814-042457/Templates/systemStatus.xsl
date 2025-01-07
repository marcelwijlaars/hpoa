<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->


	<xsl:param name="stringsDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:param name="systemStatusDocument" />
  <xsl:param name="firmwareMgmtSupported" select="'false'" />

	<xsl:template match="*">
		
		<xsl:variable name="totalCritical">
			<xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_NON_RECOVERABLE_ERROR]) + count($systemStatusDocument//device[severity=$OP_STATUS_LOST_COMMUNICATION])"/>
		</xsl:variable>

		<xsl:variable name="totalMajor">
			<xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_PREDICTIVE_FAILURE]) + count($systemStatusDocument//device[severity=$OP_STATUS_ERROR]) + count($systemStatusDocument//device[severity=$OP_STATUS_ABORTED]) + count($systemStatusDocument//device[severity=$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR])"/>
		</xsl:variable>

		<xsl:variable name="totalMinor">
			<xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_DEGRADED]) + count($systemStatusDocument//device[severity=$OP_STATUS_STRESSED]) + count($systemStatusDocument//device[severity=$OP_STATUS_STOPPED])"/>
		</xsl:variable>

		<xsl:variable name="totalInformation">
			<xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_OTHER]) + count($systemStatusDocument//device[severity=$OP_STATUS_STOPPING]) + count($systemStatusDocument//device[severity=$OP_STATUS_DORMANT]) + count($systemStatusDocument//device[severity=$OP_STATUS_POWER_MODE]) + count($systemStatusDocument//device[severity='Informational'])"/>
		</xsl:variable>

		<xsl:variable name="totalUnknown">
			<xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_UNKNOWN]) + count($systemStatusDocument//device[severity=$OP_STATUS_NO_CONTACT])"/>
		</xsl:variable>

		<xsl:variable name="totalStarting">
			<xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_STARTING])"/>
		</xsl:variable>
		
		<!-- System status table header -->
		<table cellpadding="0" cellspacing="0" border="0" id="ID_STATUS" width="100%">
			<tr>
				<td>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<h3 class="subTitle">
									<div class="subTitleIcon">
										<a name="1self" href="#1self" onclick="javascript:toggleStatusContainer(this);">
											<img src="/120814-042457/images/win_shrink.gif" width="11" height="11" border="0" alt="" />
										</a>
									</div>
									<xsl:value-of select="$stringsDoc//value[@key='systemStatus']" />
								</h3>
								<div class="subTitleBottomEdge"></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<div class="greyPanel" id="systemStatusContainer" style="display:block;">
						<span class="sp7">&#160;</span>
						<br />
						<div class="pad0x10">
							<div style="float:left;">
								<a href="javascript:launchLegend();">
									<xsl:value-of select="$stringsDoc//value[@key='viewLegend']" />
								</a>
							</div>
							<br clear="all" />
							<hr />
							<em><xsl:value-of select="$stringsDoc//value[@key='updated']"/>&#160;<span id="timeStamp"></span></em>
							<br clear="all" />
							<hr />
						</div>

						<table border="0" cellpadding="0" cellspacing="0" class="pad1x10" width="95%" ID="Table2">
							<tr>
								<td>&#160;</td>
								<th align="center">
									<img src="/120814-042457/images/icons/icon_status_critical_white.gif" width="15" height="15" border="0" alt="" />
								</th>
								<th align="center">
									<img src="/120814-042457/images/icons/icon_status_major_white.gif" width="15" height="15" border="0" alt="" />
								</th>
								<th align="center">
									<img src="/120814-042457/images/icons/icon_status_minor_white.gif" width="15" height="15" border="0" alt="" />
								</th>
								<th align="center">
									<img src="/120814-042457/images/icons/icon_status_informational_white.gif" width="15" height="15" border="0" alt="" />
								</th>
								<th align="center">
									<img src="/120814-042457/images/icons/icon_status_unknown_white.gif" width="15" height="15" border="0" alt="" />
								</th>
                <xsl:if test="$firmwareMgmtSupported = 'true'">
								  <th align="center">
									  <img src="/120814-042457/images/icon_status_waiting1.gif" width="13" height="13" border="0" alt="" />
								  </th>
                </xsl:if>
							</tr>
							<tr>
								<td>
									<a id="linkSystemStatus" href="javascript:void(0);" onclick="top.mainPage.getStatusContainer().showStatus(false);loadAlertTable('all');">
										<xsl:value-of select="$stringsDoc//value[@key='systemStatus']" />
									</a>
								</td>
								<td id="tdCritical" align="center">
									<xsl:value-of select="$totalCritical" />
								</td>
								<td id="tdMajor" align="center">
									<xsl:value-of select="$totalMajor" />
								</td>
								<td id="tdMinor" align="center">
									<xsl:value-of select="$totalMinor" />
								</td>
								<td id="tdInformation" align="center">
									<xsl:value-of select="$totalInformation" />
								</td>
								<td id="tdUnknown" align="center">
									<xsl:value-of select="$totalUnknown" />
								</td>
                <xsl:if test="$firmwareMgmtSupported = 'true'">
                  <td id="tdStarting" align="center">
                    <xsl:value-of select="$totalStarting" />
                  </td>
                </xsl:if>
							</tr>
						</table>

						<span class="sp7">&#160;</span>
						<br />
					</div>
				</td>
			</tr>
		</table>

	</xsl:template>
	
</xsl:stylesheet>
