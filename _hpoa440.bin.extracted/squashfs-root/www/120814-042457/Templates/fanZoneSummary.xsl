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

	<!-- XML document parameters containing bay information and status -->
	<xsl:param name="fanInfoDoc" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="bladeStatusDoc" />
	<xsl:param name="fanZoneDoc" />
	<xsl:param name="thermalSubsystemInfoDoc" />
	<xsl:param name="netTrayStatusDoc" />
	<xsl:param name="netTrayInfoDoc" />
	<xsl:param name="enclosureType" select="string('0')" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="numFansPerRow" select="5" />
	<xsl:param name="numFansPerEnclosure" select="10" />
	<xsl:param name="encNum" />

  <xsl:variable name="sharedText" select="$stringsDoc//value[@key='shared']" />
  <xsl:variable name="zoneText" select="$stringsDoc//value[@key='zone']" />

	<xsl:template match="*">

		<table border="0" cellpadding="0" cellspacing="0" class="dataTable" ID="interconnectTable">
			<thead>
				<tr class="captionRow">
					<th title="{$stringsDoc//value[@key='thermalZoneTips']}">
						<xsl:value-of select="$stringsDoc//value[@key='thermalZone']" /></th>
					<th title="{$stringsDoc//value[@key='zoneSpeedTips']}">
						<xsl:value-of select="$stringsDoc//value[@key='zoneSpeed']" /></th>
					<th title="{$stringsDoc//value[@key='serverBaysTips']}">
						<xsl:value-of select="$stringsDoc//value[@key='serverBays']" /> (Virtual Fan)</th>
					<th title="{$stringsDoc//value[@key='fanBayTips']}">
						<xsl:value-of select="$stringsDoc//value[@key='fanBay']" /></th>
					<th title="{$stringsDoc//value[@key='fanStatusTips']}">
						<xsl:value-of select="$stringsDoc//value[@key='fanStatus']" /></th>
					<th title="{$stringsDoc//value[@key='fanSpeedTips']}" style="text-align: right;">
						<xsl:value-of select="$stringsDoc//value[@key='fanSpeed']" /></th>
				</tr>
			</thead>
			<tbody>
				<xsl:choose>
					<xsl:when test="count($fanInfoDoc//hpoa:fanInfo[hpoa:presence=$PRESENT])&gt;0">

						<xsl:for-each select="$fanZoneDoc//hpoa:fanZone">
							<xsl:sort data-type="text" select="hpoa:zoneNumber" order="ascending" />
							<tr class="" style="height:20px;">
								<xsl:element name="td">
									<xsl:attribute name="class">sorted</xsl:attribute>
									<xsl:element name="span">
										<xsl:attribute name="id">
											fanZoneLabelTable<xsl:value-of select="hpoa:zoneNumber" />
										</xsl:attribute>
										<xsl:attribute name="class">sorted</xsl:attribute>
										<xsl:attribute name="onmouseover">
											try{highlightZone(<xsl:value-of select="hpoa:zoneNumber" />,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousemove">
											try{highlightZone(<xsl:value-of select="hpoa:zoneNumber" />,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousedown">
											try{highlightZone(<xsl:value-of select="hpoa:zoneNumber" />,false);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmouseout">
											try{highlightZone(<xsl:value-of select="hpoa:zoneNumber" />,false);}catch(e){}
										</xsl:attribute>
										<xsl:value-of select="$zoneText" />&#160;<xsl:value-of select="hpoa:zoneNumber" />
									</xsl:element>
								</xsl:element>
								<td>
									<xsl:call-template name="getFanSpeedPercent">
										<xsl:with-param name="rpm" select="hpoa:targetRpm" />
									</xsl:call-template>
								</td>
								<td>
									<xsl:for-each select="hpoa:deviceBayArray/hpoa:bay">
										<xsl:variable name="bayNumber" select="." />

										<xsl:choose>
											<xsl:when test="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$bayNumber]/hpoa:presence='PRESENT'">

												<xsl:element name="a">
													<xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$bayNumber" />, "bay", <xsl:value-of select="$encNum" />, true)</xsl:attribute>
													<xsl:value-of select="$bayNumber"/>
												</xsl:element>
												
												&#160;(<xsl:value-of select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$bayNumber]/hpoa:extraData[@hpoa:name='VirtualFan']"/>%)
											</xsl:when>
											<!-- Double Dense -->
											<xsl:when test="$bladeStatusDoc//hpoa:bladeStatus[hpoa:extraData[@hpoa:name='NormalizedBayNumber']=$bayNumber]/hpoa:presence='PRESENT'">
												<xsl:for-each select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:extraData[@hpoa:name='NormalizedBayNumber']=$bayNumber and hpoa:presence='PRESENT']">
													<xsl:element name="a">
														<xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="hpoa:bayNumber" />, "bay", <xsl:value-of select="$encNum" />, true)</xsl:attribute>
														<xsl:value-of select="hpoa:extraData[@hpoa:name='SymbolicBladeNumber']"/>
													</xsl:element>

													&#160;(<xsl:value-of select="hpoa:extraData[@hpoa:name='VirtualFan']"/>%)
													<xsl:if test="position() != last()">
														<br />
													</xsl:if>
												</xsl:for-each>
												
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$bayNumber"/>&#160;(<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']"/>)
											</xsl:otherwise>
										</xsl:choose>
										
										<xsl:if test="position() != last()">
											<br />
										</xsl:if>
									</xsl:for-each>

								</td>
								<td>
									<xsl:for-each select="hpoa:fanInfoArray/hpoa:fanInfo">
										<xsl:variable name="fanBayNumber">
											<xsl:value-of select="hpoa:bayNumber" />
										</xsl:variable>

										<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=$fanBayNumber]" >
											<xsl:variable name="sharedFan">
												<xsl:choose>
													<xsl:when test="($enclosureType='1' and ($fanBayNumber = '2' or $fanBayNumber = '5')) or
													($enclosureType!='1' and ($fanBayNumber = '3' or $fanBayNumber = '8'))">
														<xsl:value-of select="true()"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="false()"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>


											<xsl:choose>
												<xsl:when test="hpoa:presence='ABSENT' and hpoa:operationalStatus='OP_STATUS_UNKNOWN'">
														<xsl:call-template name="getFanLink">
															<xsl:with-param name="fanInfo" select="current()" />
															<xsl:with-param name="encNum" select="$encNum" />
														</xsl:call-template>
														<xsl:if test="$sharedFan = 'true'">
															&#160;<span title="Middle fan shared with the two adjacent zones – this fan tracks the hottest zone.">
																(<xsl:value-of select="$sharedText" />)
															</span>
														</xsl:if>
														<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
												</xsl:when>
												<xsl:otherwise>

													<xsl:call-template name="getFanLink">
														<xsl:with-param name="fanInfo" select="current()" />
														<xsl:with-param name="encNum" select="$encNum" />
													</xsl:call-template>
													<xsl:if test="$sharedFan = 'true'">
														&#160;<span title="Middle fan shared with the two adjacent zones – this fan tracks the hottest zone.">
															(<xsl:value-of select="$sharedText" />)
														</span>
													</xsl:if>
												</xsl:otherwise>
													
											</xsl:choose>
											
										</xsl:for-each>
										<xsl:if test="position() != last()">
											<br />
										</xsl:if>
									</xsl:for-each>
								</td>
								<td>
									<xsl:for-each select="hpoa:fanInfoArray/hpoa:fanInfo">
										<xsl:variable name="fanBayNumber">
											<xsl:value-of select="hpoa:bayNumber" />
										</xsl:variable>

										<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=$fanBayNumber]">
											<xsl:for-each select="current()">
												<xsl:choose>
													<xsl:when test="hpoa:diagnosticChecks/hpoa:deviceLocationError='ERROR'">
														<xsl:call-template name="statusIcon" >
															<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
														</xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='improperLocation']" />
													</xsl:when>
													<xsl:when test="hpoa:presence='ABSENT' and hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='deviceMissing']='ERROR'">
														<xsl:call-template name="statusIcon" >
															<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
														</xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='fanNeeded']" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="getStatusLabel">
															<xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xsl:for-each>
										<xsl:if test="position() != last()">
											<br />
										</xsl:if>
									</xsl:for-each>
								</td>
								<td>
									<xsl:for-each select="hpoa:fanInfoArray/hpoa:fanInfo">
										<xsl:variable name="fanBayNumber">
											<xsl:value-of select="hpoa:bayNumber" />
										</xsl:variable>

										<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=$fanBayNumber]">
											<xsl:for-each select="current()">

												<xsl:choose>
													<xsl:when test="hpoa:presence='ABSENT' and hpoa:operationalStatus!='OP_STATUS_UNKNOWN'">
														<xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" />
													</xsl:when>
													<xsl:when test="hpoa:presence='ABSENT' and hpoa:operationalStatus='OP_STATUS_UNKNOWN'">
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="getFanSpeedPercent">
															<xsl:with-param name="rpm" select="hpoa:fanSpeed" />
															<xsl:with-param name="maxFanSpeed" select="hpoa:maxFanSpeed" />
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
												
											</xsl:for-each>
										</xsl:for-each>
										<xsl:if test="position() != last()">
											<br />
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="count($fanInfoDoc//hpoa:fanInfo[hpoa:presence='PRESENCE_NO_OP'])=$numFansPerEnclosure">
						<tr class="noDataRow">
							<td colspan="6"><xsl:value-of select="$stringsDoc//value[@key='noPermissionFan']" /></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr class="noDataRow">
							<td colspan="6"><xsl:value-of select="$stringsDoc//value[@key='thereNoFanToDisplay']" /></td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>

			</tbody>
		</table>

		<br />
		<table border="0" cellpadding="0" cellspacing="0" width="100%" style="vertical-align: top;
		margin: 0px auto; padding: 0px; border: 0px;">
			<tbody>
				<tr>
					<td valign="top">
						<table border="0" cellpadding="0" cellspacing="0" style="width: 250px; top: 0px;
						left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border: 0px;">
							<tbody>
								<tr style="width: 250px;">
									<td align="left" colspan="2">
										<xsl:value-of select="$stringsDoc//value[@key='frontView']" />
									</td>
								</tr>
								<tr style="width: 250px;height:18px">
									<xsl:element name="td">
										<xsl:attribute name="align">center</xsl:attribute>
										<xsl:attribute name="id">fanZoneLabelFront1</xsl:attribute>
										<xsl:attribute name="onmouseover">
											try{highlightZone(1,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousemove">
											try{highlightZone(1,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousedown">
											try{highlightZone(1,false);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmouseout">
											try{highlightZone(1,false);}catch(e){}
										</xsl:attribute>
										&#160;&#160;&#160;&#160;<xsl:value-of select="$zoneText" />&#160;1
									</xsl:element>
									<xsl:element name="td">
										<xsl:attribute name="align">center</xsl:attribute>
										<xsl:attribute name="id">fanZoneLabelFront2</xsl:attribute>
										<xsl:attribute name="onmouseover">
											try{highlightZone(2,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousemove">
											try{highlightZone(2,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousedown">
											try{highlightZone(2,false);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmouseout">
											try{highlightZone(2,false);}catch(e){}
										</xsl:attribute>
										<xsl:value-of select="$zoneText" />&#160;2&#160;&#160;&#160;&#160;
									</xsl:element>
								</tr>
								<tr>
									<td style="height: 184px; border-width: 0px; vertical-align: top;">
										<div style="z-index: 0; position: relative; top: 0px; left: 0px; margin: 0px auto;
										padding: 0px; border: 0px; border-spacing: 0px;" title="">
											<img src="/120814-042457/images/front_view.gif" alt='' style="z-index: 2; position: absolute; vertical-align: top;
											margin: 0px auto; padding: 0px; border: 0px;" />
											<xsl:call-template name="frontViewZone">
												<xsl:with-param name="zone" select="string('1')" />
												<xsl:with-param name="x" select="string('18')" />
												<xsl:with-param name="y" select="string('6')" />
												<xsl:with-param name="valign" select="string('top')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=1]" />
												<xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
											</xsl:call-template>
											<xsl:call-template name="frontViewZone">
												<xsl:with-param name="zone" select="string('2')" />
												<xsl:with-param name="x" select="string('125')" />
												<xsl:with-param name="y" select="string('6')" />
												<xsl:with-param name="valign" select="string('top')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=2]" />
												<xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
											</xsl:call-template>
											<xsl:call-template name="frontViewZone">
												<xsl:with-param name="zone" select="string('3')" />
												<xsl:with-param name="x" select="string('18')" />
												<xsl:with-param name="y" select="string('102')" />
												<xsl:with-param name="valign" select="string('bottom')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=3]" />
												<xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
											</xsl:call-template>
											<xsl:call-template name="frontViewZone">
												<xsl:with-param name="zone" select="string('4')" />
												<xsl:with-param name="x" select="string('125')" />
												<xsl:with-param name="y" select="string('102')" />
												<xsl:with-param name="valign" select="string('bottom')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=4]" />
												<xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
											</xsl:call-template>

											<div id="Div11" name="idc" style="z-index: 4; position: absolute; top: 196px; left: 54px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 45px;
											height: 20px; color:White;" title="">
												<!--<span id="fanZoneLabelRear3" >Zone 3</span>-->
												<xsl:element name="span">
													<xsl:attribute name="align">center</xsl:attribute>
													<xsl:attribute name="id">fanZoneLabelFront3</xsl:attribute>
													<xsl:attribute name="onmouseover">
														try{highlightZone(3,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousemove">
														try{highlightZone(3,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousedown">
														try{highlightZone(3,false);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmouseout">
														try{highlightZone(3,false);}catch(e){}
													</xsl:attribute>
													<xsl:value-of select="$zoneText" />&#160;3
												</xsl:element>
											</div>
											<div id="Div12" name="idc" style="z-index: 4; position: absolute; top: 196px; left: 164px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 45px;
											height: 20px; color:White;" title="">
												<!--<span id="fanZoneLabelRear4" >Zone 4</span>-->
												<xsl:element name="span">
													<xsl:attribute name="align">center</xsl:attribute>
													<xsl:attribute name="id">fanZoneLabelFront4</xsl:attribute>
													<xsl:attribute name="onmouseover">
														try{highlightZone(4,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousemove">
														try{highlightZone(4,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousedown">
														try{highlightZone(4,false);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmouseout">
														try{highlightZone(4,false);}catch(e){}
													</xsl:attribute>
													<xsl:value-of select="$zoneText" />&#160;4
												</xsl:element>
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
					<td valign="top">
						<table border="0" cellpadding="0" cellspacing="0" style="width: 250px; top: 0px;
						left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border: 0px;">
							<tbody>
								<tr style="width: 250px;">
									<td align="left" colspan="2">
										<xsl:value-of select="$stringsDoc//value[@key='rearView']" />
									</td>
								</tr>
								<tr style="width: 250px;height: 18px">
									<xsl:element name="td">
										<xsl:attribute name="align">center</xsl:attribute>
										<xsl:attribute name="id">fanZoneLabelRear2</xsl:attribute>
										<xsl:attribute name="onmouseover">
											try{highlightZone(2,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousemove">
											try{highlightZone(2,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousedown">
											try{highlightZone(2,false);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmouseout">
											try{highlightZone(2,false);}catch(e){}
										</xsl:attribute>
										&#160;&#160;&#160;&#160;<xsl:value-of select="$zoneText" />&#160;2
									</xsl:element>
									<xsl:element name="td">
										<xsl:attribute name="align">center</xsl:attribute>
										<xsl:attribute name="id">fanZoneLabelRear1</xsl:attribute>
										<xsl:attribute name="onmouseover">
											try{highlightZone(1,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousemove">
											try{highlightZone(1,true);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmousedown">
											try{highlightZone(1,false);}catch(e){}
										</xsl:attribute>
										<xsl:attribute name="onmouseout">
											try{highlightZone(1,false);}catch(e){}
										</xsl:attribute>
										<xsl:value-of select="$zoneText" />&#160;1&#160;&#160;&#160;&#160;
									</xsl:element>
								</tr>
								<tr>
									<td style="height: 184px; border-width: 0px; vertical-align: top;">
										<div style="z-index: 1; position: relative; top: 0px; left: 0px; margin: 0px auto;
										padding: 0px; border: 0px; border-spacing: 0px;" title="">
											<img src="/120814-042457/images/rear_view.gif" alt='' style="z-index: 2; position: absolute; vertical-align: top;
											margin: 0px auto; padding: 0px; border: 0px;" />
											<xsl:call-template name="rearViewZone">
												<xsl:with-param name="zone" select="string('2')" />
												<xsl:with-param name="x" select="string('23')" />
												<xsl:with-param name="y" select="string('5')" />
												<xsl:with-param name="valign" select="string('top')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=2]" />
											</xsl:call-template>
											<xsl:call-template name="rearViewZone">
												<xsl:with-param name="zone" select="string('1')" />
												<xsl:with-param name="x" select="string('126')" />
												<xsl:with-param name="y" select="string('5')" />
												<xsl:with-param name="valign" select="string('top')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=1]" />
											</xsl:call-template>
											<xsl:call-template name="rearViewZone">
												<xsl:with-param name="zone" select="string('4')" />
												<xsl:with-param name="x" select="string('23')" />
												<xsl:with-param name="y" select="string('140')" />
												<xsl:with-param name="valign" select="string('bottom')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=4]" />
											</xsl:call-template>
											<xsl:call-template name="rearViewZone">
												<xsl:with-param name="zone" select="string('3')" />
												<xsl:with-param name="x" select="string('126')" />
												<xsl:with-param name="y" select="string('140')" />
												<xsl:with-param name="valign" select="string('bottom')" />
												<xsl:with-param name="zoneInfo" select="$fanZoneDoc//hpoa:fanZone[hpoa:zoneNumber=3]" />
											</xsl:call-template>
											<div id="Div9" name="idc" style="z-index: 4; position: absolute; top: 7px; left: 26px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 196px;
											height: 26px;" title="">
												<table border="0" cellpadding="0" cellspacing="0" style="top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width:0px;
												width: 100%; height: 100%; border-color:Background; border-style:none; font-size: 13px;
												font-weight: bold; font-family: Arial; background:none">
													<tbody>
														<tr>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=1]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=2]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=3]" />
																	<xsl:with-param name="background-color" select="string('#CCCCCC')" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=4]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=5]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											<div id="Div10" name="idc" style="z-index: 4; position: absolute; top: 162px; left: 24px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 202px;
											height: 26px;" title="">
												<table border="0" cellpadding="0" cellspacing="0" style="top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width:0px;
												width: 100%; height: 100%; border-color:Background; border-style:none; font-size: 13px;
												font-weight: bold; font-family: Arial; background:none">
													<tbody>
														<tr>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=6]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=7]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=8]" />
																	<xsl:with-param name="background-color" select="string('#CCCCCC')" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=9]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
															<td  align="center" style="border-width:0px;width:40px;">
																<xsl:call-template name="getFanLink">
																	<xsl:with-param name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=10]" />
																	<xsl:with-param name="encNum" select="$encNum" />
																</xsl:call-template>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											<div id="Div13" name="idc" style="z-index: 4; position: absolute; top: 192px; left: 54px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 42px;
											height: 18px; color:White;background-color:Black;text-align:center;vertical-align:middle;" title="">
												<xsl:element name="span">
													<xsl:attribute name="align">center</xsl:attribute>
													<xsl:attribute name="id">fanZoneLabelRear4</xsl:attribute>
													<xsl:attribute name="onmouseover">
														try{highlightZone(4,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousemove">
														try{highlightZone(4,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousedown">
														try{highlightZone(4,false);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmouseout">
														try{highlightZone(4,false);}catch(e){}
													</xsl:attribute>
													<xsl:value-of select="$zoneText" />&#160;4
												</xsl:element>
												<!--<span id="fanZoneLabelRear4" onmouseover="text(try{highlightZone(4,true);}catch(e){})"
													  onmousemove="text(try{highlightZone(4,false);}catch(e){})" onmousedown="text(try{highlightZone(4,false);}catch(e){})"
													  onmouseout="text(try{highlightZone(4,false);}catch(e){})">Zone 4</span>-->
											</div>
											<div id="Div14" name="idc" style="z-index: 4; position: absolute; top: 192px; left: 164px;
											vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 42px;
											height: 18px; color:White;background-color:Black;text-align:center;vertical-align:middle;" title="">
												<!--<span id="fanZoneLabelRear3" >Zone 3</span>-->
												<xsl:element name="span">
													<xsl:attribute name="align">center</xsl:attribute>
													<xsl:attribute name="id">fanZoneLabelRear3</xsl:attribute>
													<xsl:attribute name="onmouseover">
														try{highlightZone(3,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousemove">
														try{highlightZone(3,true);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmousedown">
														try{highlightZone(3,false);}catch(e){}
													</xsl:attribute>
													<xsl:attribute name="onmouseout">
														try{highlightZone(3,false);}catch(e){}
													</xsl:attribute>
													<xsl:value-of select="$zoneText" />&#160;3
												</xsl:element>
											</div>
											<!-- draw interconnect tray status icons when not OK -->
											<xsl:if test="count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence=$PRESENT])&gt;0">
												<!-- Loop through each of the tray bay values in the blade info document. -->
												<xsl:for-each select="$netTrayStatusDoc//hpoa:interconnectTrayStatus">
													<xsl:if test="hpoa:presence = $PRESENT">
														<!-- Determine if the row is odd or even using Mod division -->
														<xsl:variable name="traySide">
															<xsl:if test="position() mod 2 = 0">right</xsl:if>
														</xsl:variable>
														<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
														<xsl:if test="hpoa:presence != $ABSENT and hpoa:presence != $SUBSUMED">
															<xsl:variable name="interconnectId">
																<xsl:value-of select="concat('fanZoneICBay_', hpoa:bayNumber)" />
															</xsl:variable>

															<xsl:element name="div">
																<xsl:attribute name="id">
																	<xsl:value-of select="$interconnectId" />
																</xsl:attribute>
																<xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,160);}catch(e){}</xsl:attribute>
																<xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
																<xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
																<xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
																<xsl:attribute name="style">
																	z-index: 4; position: absolute; top: <xsl:value-of select="39+16*(ceiling(hpoa:bayNumber div 2))" />px; left:
																	<xsl:choose>
																		<xsl:when test="position() mod 2 = 0">120px;</xsl:when>
																		<xsl:otherwise>24px;</xsl:otherwise>
																	</xsl:choose>vertical-align: top; margin: 0px auto; padding: 0px; border: 0px; width: 100px;
																	height: 18px;text-align:center;vertical-align:middle;color:white
																</xsl:attribute>

																<xsl:attribute name="title" />
																<xsl:element name="span">

																	<xsl:attribute name="align">center</xsl:attribute>
																	<!--
																		Get the current bay's blade thermal status value. Call the Status Label template
																		to set the text and image for the current bay's blade status.
																	-->
																	<xsl:call-template name="getThermalLabel">
																		<xsl:with-param name="statusCode" select="hpoa:thermal" />
																	</xsl:call-template>

																</xsl:element>
															</xsl:element>
														</xsl:if>
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
		<div>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
		</div>
		<!-- standard tooltip element -->
		<div id="tooltip" class="popupSmallWrapper" >
			<div id="tooltipText" class="popupSmallBody"></div>
		</div>
		<!-- the fan tooltip elements -->
		<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo">
			<xsl:variable name="myId">
				<xsl:value-of select="concat('fanZoneFanBay_', hpoa:bayNumber)" />
			</xsl:variable>
			<xsl:call-template name="fanBayTooltip">
				<xsl:with-param name="bayNum" select="hpoa:bayNumber" />
				<xsl:with-param name="fanInfoDoc" select="$fanInfoDoc" />
				<xsl:with-param name="fanZone" select="true()" />
			</xsl:call-template>
		</xsl:for-each>
		<!-- the interconnect tooltip elements -->
		<xsl:for-each select="$netTrayStatusDoc//hpoa:interconnectTrayStatus">
			<xsl:variable name="interconnectId">
				<xsl:value-of select="concat('fanZoneICBay_', hpoa:bayNumber)" />
				<!--<xsl:value-of select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Select')" />-->
			</xsl:variable>
			<xsl:variable name="currentBayNumber">
				<xsl:value-of select="hpoa:bayNumber" />
			</xsl:variable>
			<xsl:call-template name="interconnectBayTooltip">
				<xsl:with-param name="myId" select="$interconnectId" />
				<xsl:with-param name="trayInfo" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]" />
				<xsl:with-param name="trayStatus" select="current()" />
				<xsl:with-param name="fanZone" select="true()" />
			</xsl:call-template>
		</xsl:for-each>

	</xsl:template>

	<!-- Gets a readable label for the device bay links. -->
	<xsl:template name="getDeviceBayLink">
		<xsl:param name="bladeStatus" />
		<xsl:param name="bladeInfo" />

		<xsl:param name="dontCreateTipDiv" />
		<xsl:variable name="bayNumber">
			<xsl:value-of select="$bladeInfo//hpoa:bayNumber" />
		</xsl:variable>
		<xsl:variable name="myId">
			<xsl:value-of select="concat('fanZoneDeviceBay_', $bayNumber)" />
		</xsl:variable>

		<xsl:variable name="bladePresence" select="$bladeInfo/hpoa:presence" />
		<xsl:variable name="bladeThermal">
			<xsl:call-template name="guiStatusCode" >
				<xsl:with-param name="statusCode" select="$bladeStatus/hpoa:thermal" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="bladeThermalWarning">
			<xsl:call-template name="guiStatusCode" >
				<xsl:with-param name="statusCode" select="$bladeStatus//hpoa:thermalWarning" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="bladeThermalDanger">
			<xsl:call-template name="guiStatusCode" >
				<xsl:with-param name="statusCode" select="$bladeStatus//hpoa:thermalDanger" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="bladeInsufficientCooling">
			<xsl:call-template name="guiStatusCode" >
				<xsl:with-param name="statusCode" select="$bladeStatus//hpoa:insufficientCooling" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="$myId" />
			</xsl:attribute>
			<xsl:attribute name="style">z-index:10;cursor:default;</xsl:attribute>
			<xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,200);}catch(e){}</xsl:attribute>
			<xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
			<xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
			<xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>

			<xsl:value-of select="$bayNumber" />

			<xsl:if test="$dontCreateTipDiv!='true' and $bladePresence!='ABSENT'">
				<xsl:element name="div" >
					<xsl:attribute name="class">deviceInfo</xsl:attribute>
					<xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($myId,'InfoTip')"/>
					</xsl:attribute>
					<xsl:choose>

						<!-- double dense case - both bays present -->
						<xsl:when test="$bladePresence='SUBSUMED' and ($bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/../hpoa:presence='PRESENT' and $bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/../hpoa:presence='PRESENT')">
							<xsl:call-template name="deviceBayTooltipDD">
								<xsl:with-param name="myId" select="$myId" />
								<xsl:with-param name="bladeInfoA" select="$bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/.." />
								<xsl:with-param name="bladeStatusA" select="$bladeStatusDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/.." />
								<xsl:with-param name="bladeInfoB" select="$bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/.." />
								<xsl:with-param name="bladeStatusB" select="$bladeStatusDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/.." />
							</xsl:call-template>
						</xsl:when>
						<!-- double dense case - both bays permission denied -->
						<xsl:when test="$bladePresence='SUBSUMED' and ($bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/../hpoa:presence='PRESENCE_NO_OP' and $bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/../hpoa:presence='PRESENCE_NO_OP')">
							<xsl:call-template name="deviceBayTooltip">
								<xsl:with-param name="myId" select="$myId" />
								<xsl:with-param name="bladeInfo" select="$bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/.." />
								<xsl:with-param name="bladeStatus" select="$bladeStatusDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/.." />
								<xsl:with-param name="presence" select="'LOCKED'" />
							</xsl:call-template>
						</xsl:when>
						<!-- double dense case - only side A is present -->
						<xsl:when test="$bladePresence='SUBSUMED' and ($bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/../hpoa:presence='PRESENT' and $bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/../hpoa:presence!='PRESENT')">
							<xsl:call-template name="deviceBayTooltip">
								<xsl:with-param name="myId" select="$myId" />
								<xsl:with-param name="bladeInfo" select="$bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/.." />
								<xsl:with-param name="bladeStatus" select="$bladeStatusDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/.." />
							</xsl:call-template>
						</xsl:when>
						<!-- double dense case - only side B is present -->
						<xsl:when test="$bladePresence='SUBSUMED' and ($bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'A')]/../hpoa:presence!='PRESENT' and $bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/../hpoa:presence='PRESENT')">
							<xsl:call-template name="deviceBayTooltip">
								<xsl:with-param name="myId" select="$myId" />
								<xsl:with-param name="bladeInfo" select="$bladeInfoDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/.." />
								<xsl:with-param name="bladeStatus" select="$bladeStatusDoc//hpoa:extraData[@hpoa:name='SymbolicBladeNumber' and .=concat($bayNumber, 'B')]/.." />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="deviceBayTooltip">
								<xsl:with-param name="myId" select="$myId" />
								<xsl:with-param name="bladeInfo" select="$bladeInfo" />
								<xsl:with-param name="bladeStatus" select="$bladeStatus" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template name ="frontViewZone">

		<xsl:param name="zoneInfo" />
		<xsl:param name="bladeInfo"/>
		<xsl:param name="zone" />
		<xsl:param name="x" />
		<xsl:param name="y" />
		<xsl:param name="valign" />

		<xsl:element name="div">
			<xsl:attribute name="onmouseover">
				try{highlightZone(<xsl:value-of select="$zone" />,true);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="onmousemove">
				try{highlightZone(<xsl:value-of select="$zone" />,true);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="onmousedown">
				try{highlightZone(<xsl:value-of select="$zone" />,false);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="onmouseout">
				try{highlightZone(<xsl:value-of select="$zone" />,false);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="class">zone</xsl:attribute>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('front_zone_',$zone)" />
			</xsl:attribute>
			<xsl:attribute name="name">
				<xsl:value-of select="concat('front_zone_',$zone)" />
			</xsl:attribute>
			<xsl:attribute name="title"></xsl:attribute>
			<xsl:attribute name="style">
				<xsl:value-of select="concat('z-index: 3; position: absolute; top: ',$y,'px; left: ',$x,
				'px;vertical-align: top; margin: 0px auto; padding: 0px; width: 102px;height: 84px;')" />
			</xsl:attribute>
			<!--<table border="2" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%; border-color:black; border-spacing:0px; border-style: solid;  border-width:2px; background:none; margin:0px; padding:0px;">
				<tbody border="0">
					<tr border="0">
						<td border="0">-->
			<xsl:element name="table">
				<xsl:variable name="guiStatusCode">
					<xsl:call-template name="guiStatusCode" >
						<xsl:with-param name="statusCode" select="$zoneInfo/hpoa:operationalStatus" />
					</xsl:call-template>
				</xsl:variable>
				<!-- Currently, each zone does not have a seperate status value -->
				<!--<xsl:choose>
					<xsl:when test="$guiStatusCode='STATUS_OK_IMAGE'">
						<xsl:attribute name="class">trans_box_green</xsl:attribute>
					</xsl:when>
					<xsl:when test="$guiStatusCode='STATUS_MINOR_IMAGE' or $guiStatusCode='STATUS_MAJOR_IMAGE'">
						<xsl:attribute name="class">trans_box_yellow</xsl:attribute>
					</xsl:when>
					<xsl:when test="$guiStatusCode='STATUS_FAILED_IMAGE'">
						<xsl:attribute name="class">trans_box_red</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						-->
				<xsl:attribute name="class">trans_box</xsl:attribute>
				<!--</xsl:otherwise>
				</xsl:choose>-->
				<xsl:attribute name="border">2</xsl:attribute>
				<xsl:attribute name="cellpadding">0</xsl:attribute>
				<xsl:attribute name="cellspacing">0</xsl:attribute>
				<xsl:attribute name="style">
					<xsl:value-of select="string('top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width: 2px;
												width: 100%; height: 100%; border-color: #99CCFF; border-style: solid; font-size: 13px;
												font-weight: bold; font-family: Arial;padding-bottom:2px;padding-top:2px;')" />
				</xsl:attribute>
				<tbody>
					<xsl:if test="$valign='top'">
						<tr>
							<td colspan="1" style="border-width: 0px; vertical-align: top;">
								<table border="0" width="100%" style="font-size: 13px; font-weight: bold; font-family: Arial;
																	vertical-align: top;">
									<tbody>
										<tr>
											<xsl:for-each select="$zoneInfo/hpoa:deviceBayArray/hpoa:bay">
												<xsl:sort data-type="number" select="." order="ascending" />
												<xsl:variable name="bayNumber">
													<xsl:value-of select="." />
												</xsl:variable>
												<td align="center" style="position:relative;border-width: 0px;">
													<xsl:call-template name="getDeviceBayLink">
														<xsl:with-param name="bladeInfo" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]" />
														<xsl:with-param name="bladeStatus" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$bayNumber]" />
														<xsl:with-param name="dontCreateTipDiv" select="true()" />
													</xsl:call-template>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr style="vertical-align:middle;">
							<td colspan="1" align="center" style="border-width: 0px;font-size: 18px;vertical-align:middle;">
								<xsl:call-template name="getFanSpeedPercent">
									<xsl:with-param name="rpm" select="$zoneInfo/hpoa:targetRpm" />
								</xsl:call-template>
							</td>
						</tr>
						<tr border="0" style="border-width: 0px;">
							<td border="0" style="border-width: 0px;">
								<span border="0" style="border-width: 0px;">&#160;</span>
							</td>
						</tr>
					</xsl:if>
					<!-- Currently, each zone does not have a seperate status value -->
					<!-- <tr>
						<td colspan="1" align="center" style="border-width: 0px;">
							<xsl:call-template name="getStatusLabel">
								<xsl:with-param name="statusCode" select="$zoneInfo/hpoa:operationalStatus" />
							</xsl:call-template>
						</td>

					</tr>-->

					<xsl:if test="$valign='bottom'">
						<tr border="0" style="border-width: 0px;">
							<td border="0" style="border-width: 0px;">
								<span border="0" style="border-width: 0px;">&#160;</span>
							</td>
						</tr>

						<tr style="vertical-align:middle;">
							<td colspan="1" align="center" style="border-width: 0px;font-size: 18px;vertical-align:middle;">
								<!-- <xsl:value-of select="$zoneInfo/hpoa:targetFanSpeedPercentage" />% - ->
								<xsl:value-of select="round($zoneInfo/hpoa:targetRpm div 180)"/>%-->
								<xsl:call-template name="getFanSpeedPercent">
									<xsl:with-param name="rpm" select="$zoneInfo/hpoa:targetRpm" />
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td colspan="1" style="border-width: 0px; vertical-align: bottom;">
								<table border="0" width="100%" style="font-size: 13px; font-weight: bold; font-family: Arial;
																vertical-align: bottom;">
									<tbody>
										<tr>
											<xsl:for-each select="$zoneInfo/hpoa:deviceBayArray/hpoa:bay">
												<xsl:sort data-type="number" select="." order="ascending" />
												<xsl:variable name="bayNumber">
													<xsl:value-of select="." />
												</xsl:variable>
												<td align="center" style="border-width: 0px;position:relative;">
													<xsl:call-template name="getDeviceBayLink">
														<xsl:with-param name="bladeStatus" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$bayNumber]" />
														<xsl:with-param name="bladeInfo" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]" />
													</xsl:call-template>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</xsl:if>
				</tbody>
			</xsl:element>
			<!--	</td>
					</tr>
				</tbody>
			</table>-->
		</xsl:element>

	</xsl:template>

	<xsl:template name ="rearViewZone">

		<xsl:param name="zoneInfo" />
		<xsl:param name="zone" />
		<xsl:param name="x" />
		<xsl:param name="y" />
		<xsl:param name="valign" />

		<xsl:element name="div">
			<xsl:attribute name="onmouseover">
				try{highlightZone(<xsl:value-of select="$zone" />,true);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="onmousemove">
				try{highlightZone(<xsl:value-of select="$zone" />,true);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="onmousedown">
				try{highlightZone(<xsl:value-of select="$zone" />,false);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="onmouseout">
				try{highlightZone(<xsl:value-of select="$zone" />,false);}catch(e){}
			</xsl:attribute>
			<xsl:attribute name="class">zone</xsl:attribute>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('rear_zone_',$zone)" />
			</xsl:attribute>
			<xsl:attribute name="name">
				<xsl:value-of select="concat('rear_zone_',$zone)" />
			</xsl:attribute>
			<xsl:attribute name="title"></xsl:attribute>
			<xsl:attribute name="style">
				<xsl:value-of select="concat('z-index: 3; position: absolute; top: ',$y,'px; left: ',$x,
				'px;vertical-align: top; margin: 0px auto; padding: 0px; width: 98px;height: 46px;')" />
			</xsl:attribute>
			<xsl:element name="table">
				<xsl:variable name="guiStatusCode">
					<xsl:call-template name="guiStatusCode" >
						<xsl:with-param name="statusCode" select="$zoneInfo/hpoa:operationalStatus" />
					</xsl:call-template>
				</xsl:variable>
				<!-- Currently, each zone does not have a seperate status value -->
				<!--<xsl:choose>
					<xsl:when test="$guiStatusCode='STATUS_OK_IMAGE'">
						<xsl:attribute name="class">trans_box_green</xsl:attribute>
					</xsl:when>
					<xsl:when test="$guiStatusCode='STATUS_MINOR_IMAGE' or $guiStatusCode='STATUS_MAJOR_IMAGE'">
						<xsl:attribute name="class">trans_box_yellow</xsl:attribute>
					</xsl:when>
					<xsl:when test="$guiStatusCode='STATUS_FAILED_IMAGE'">
						<xsl:attribute name="class">trans_box_red</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>-->
				<xsl:attribute name="class">trans_box</xsl:attribute>
				<!--</xsl:otherwise>
				</xsl:choose>-->
				<xsl:attribute name="border">2</xsl:attribute>
				<xsl:attribute name="cellpadding">0</xsl:attribute>
				<xsl:attribute name="cellspacing">0</xsl:attribute>
				<xsl:attribute name="style">
					<xsl:value-of select="string('top: 0px;
												left: 0px; vertical-align: top; margin: 0px auto; padding: 0px; border-width: 2px;
												width: 100%; height: 100%; border-color: #99CCFF; border-style: solid; font-size: 13px;
												font-weight: bold; font-family: Arial;padding-bottom:2px;padding-top:2px;')" />
				</xsl:attribute>
				<tbody>
					<xsl:element name="tr">
						<xsl:choose>
							<xsl:when test="$valign='top'">
								<xsl:attribute name="valign">bottom</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="valign">top</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<!-- Currently, each zone does not have a seperate status value -->
						<!--
							<td colspan="1" align="center" style="border-width: 0px;">
								&#160;<xsl:call-template name="statusIcon" >
									<xsl:with-param name="statusCode" select="$zoneInfo/hpoa:operationalStatus" />
								</xsl:call-template>&#160;
							</td>-->
						<td colspan="1" align="center" style="border-width: 0px;">
							&#160;&#160;<xsl:call-template name="getFanSpeedPercent">
												<xsl:with-param name="rpm" select="$zoneInfo/hpoa:targetRpm" />
											</xsl:call-template>
						</td>
					</xsl:element>
				</tbody>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>


