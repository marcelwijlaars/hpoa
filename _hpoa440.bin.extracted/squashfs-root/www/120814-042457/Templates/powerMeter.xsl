<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="enclosurePowerCollectionInfoDoc" />
	<xsl:param name="enclosurePowerDataDoc" />
	<xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="showPeak" />
	<xsl:param name="showAverage" />
	<xsl:param name="showMin" />
	<xsl:param name="showCap" />
	<xsl:param name="showDerated" />
	<xsl:param name="showRated" />
	<xsl:param name="avgUnits" />
	<xsl:param name="peakUnits" />
	<xsl:param name="lineVoltage" />
	<xsl:param name="stringsDoc" />
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:template match="*">
		<xsl:variable name="isDC">
			<xsl:choose>
				<xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:subsystemType='EXTERNAL_DC'">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="isRedundant">
            		<xsl:choose>
                		<xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:redundancyMode='AC_REDUNDANT'">
                    			<xsl:value-of select="true()"/>
                		</xsl:when>
                		<xsl:otherwise>
                 			<xsl:value-of select="false()"/>
                		</xsl:otherwise>
            		</xsl:choose>
        	</xsl:variable>

		<xsl:variable name="powerUnits">
			<xsl:choose>
				<xsl:when test="$isDC='true'"><xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC</xsl:when>
				<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;AC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="maxPower" select="round(number($enclosurePowerDataDoc//hpoa:enclosurePowerData/hpoa:enclosurePowerStatistics/hpoa:peakWattage))" />
		<xsl:variable name="minPower" select="round(number($enclosurePowerDataDoc//hpoa:enclosurePowerData/hpoa:enclosurePowerStatistics/hpoa:minWattage))" />
		<xsl:variable name="avePower" select="round(number($enclosurePowerDataDoc//hpoa:enclosurePowerData/hpoa:enclosurePowerStatistics/hpoa:averageWattage))" />
		<xsl:variable name="timeStamp" select="$enclosurePowerDataDoc//hpoa:enclosurePowerData[last()]//@hpoa:timeStamp" />
		<xsl:variable name="validDate" select="substring-before($timeStamp, 'T')" />
		<xsl:variable name="validTime" select="substring(substring-after($timeStamp, 'T'),1,8)" />
		<xsl:variable name="curAvePower" select="round(number($enclosurePowerDataDoc//hpoa:enclosurePowerData/hpoa:enclosurePowerRecords/hpoa:enclosurePowerRecord[last()]//@hpoa:averageWattage))" />
		<xsl:variable name="powerConsumed">
			<xsl:call-template name="getPowerConsumed">
				<xsl:with-param name="powerSubsystemInfoDoc" select="$powerSubsystemInfoDoc" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">maxPowerValue</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="$maxPower"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">minPowerValue</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="$minPower"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">avePowerValue</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="$avePower"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">curAvePowerValue</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="$curAvePower"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">validTimeValue</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="$validDate"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">validDateValue</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="$validDate"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="id">presentPowerValue</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="$powerConsumed"/>
			</xsl:attribute>
		</xsl:element>
		<h3 style="text-align:center;">
			<xsl:value-of select="$stringsDoc//value[@key='pwrMeterReadings']" />
		</h3>
		<table align="center" style="width: 576px;padding-left: 0px;padding-right: 0px;">
			<tr>
				<td align="left">
					<font size="1">
						<xsl:value-of select="$stringsDoc//value[@key='pwrMeterGraphDesc']" />
					</font>
				</td>
				<td align="right">
					<xsl:value-of select="$stringsDoc//value[@key='showValuesIn']" />
					<select name="avgUnits" id="avgUnits" onchange="convert();">
						<xsl:element name="option">
							<xsl:if test="$avgUnits='watts'">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">watts</xsl:attribute>
							&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />
						</xsl:element>
						<xsl:element name="option">
							<xsl:if test="$avgUnits='btus'">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">btus</xsl:attribute>
							&#160;<xsl:value-of select="$stringsDoc//value[@key='btus']" />
						</xsl:element>
						<xsl:element name="option">
							<xsl:if test="$avgUnits='amps'">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="value">amps</xsl:attribute>
							&#160;<xsl:value-of select="$stringsDoc//value[@key='amps']" />
						</xsl:element>
					</select>
				</td>
			</tr>
		</table>
		<table align="center" class="graphWrapperTable">
			<tr>
				<td align="center">
					<table style="display: inline; width: 100%; margin:0px;padding:0px;border:0px;padding:0px;" border="0" cellpadding="0" cellspacing="0" >
						<tr>
							<td valign="top" align="right" >
								<b>
									<div id="leftTopRange" style="padding-right: 5px;">
									</div>
								</b>
							</td>
							<td rowspan="3">
								<div style="padding: 0px; width: 100%;">
									<div style="margin: 0px; padding: 0px;">
										<div id="bargraph" style="padding-left: 0px; padding-right: 0px; white-space: nowrap;	width: 576px; overflow: auto;height:220px">
										</div>
									</div>
								</div>
							</td>
							<td valign="top" align="left" >
								<b>
									<div id="rightTopRange" style="padding-left: 5px;">
									</div>
								</b>
							</td>
						</tr>
						<tr style="vertical-align:middle;">
							<td style="vertical-align:middle;" valign="middle" align="right" >
								<b>
									<div id="leftMidRange" style="padding-right: 5px;">
									</div>
								</b>
							</td>
							<td style="vertical-align:middle;" valign="middle" align="left">
								<b>
									<div id="rightMidRange" style="padding-left: 5px;">
									</div>
								</b>
							</td>
						</tr>
						<tr style="vertical-align:bottom;">
							<td style="vertical-align:bottom;" valign="bottom" align="right">
								<b>
									<div id="leftBtmRange" style="padding-right: 5px;">
									</div>
								</b>
							</td>
							<td style="vertical-align:bottom;" valign="bottom" align="left" >
								<b>
									<div id="rightBtmRange" style="padding-left: 5px;">
									</div>
								</b>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
				      
        <table align="center" style="width: 100%;padding-left: 0px;padding-right: 0px;">
            <tr>
               <xsl:if test="string($curAvePower)!='NaN'">
                 <td align="left">
                        <table border="0" cellpadding="2">
                            <tr>
                                <td align="left">
                                    <b><xsl:value-of select="$stringsDoc//value[@key='presentPwr']" />:&#160;&#160;</b>
                                </td>
                                <td align="left">
                                    <div id="curPowerConsumed">
                                        <xsl:value-of select="$powerConsumed" />&#160;<xsl:value-of select="$powerUnits" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <b><xsl:value-of select="$stringsDoc//value[@key='mostRecentPwrMeterReadings']" />:&#160;&#160;</b>
                                </td>
                                <td align="left">
                                    <div id="curAvePower">
                                        <xsl:value-of select="$curAvePower"/>&#160;<xsl:value-of select="$powerUnits" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <b><xsl:value-of select="$stringsDoc//value[@key='pwrCapLabel']" />:&#160;&#160;</b>
                                </td>
                                <td align="left">
                                    <div id="curPowerCap">
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
               </xsl:if>
                <td align="right">
                    <table border="0" cellpadding="2" cellspacing="0" style="width: 0%;">
                        <tr>
                            <td id="peakBgcolor" bgcolor="#cc0066" onClick="showBar('peak',event.shiftKey);">
                                <!--<input type="checkbox" name="peak" id="PeakCheck" style="background-color:#cc0066;color:#cc0066" accesskey="p" onClick="showBar(this.name, this.checked)" {$showPeak}/>-->
                                <xsl:element name="input">
                                    <xsl:attribute name="type">checkbox</xsl:attribute>
                                    <xsl:attribute name="name">peak</xsl:attribute>
                                    <xsl:attribute name="id">PeakCheck</xsl:attribute>
                                    <xsl:attribute name="style">background-color:#cc0066;color:#cc0066;visibility:hidden</xsl:attribute>
                                    <xsl:attribute name="accesskey">p</xsl:attribute>
                                    <xsl:attribute name="onClick">showBar(this.name, this.checked)</xsl:attribute>
                                    <xsl:if test="$showPeak='true'" >
                                        <xsl:attribute name="checked">true</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </td>
                            <td>
                                &#160;<xsl:value-of select="$stringsDoc//value[@key='peak']" />&#160;
                            </td>
                            <td  id="aveBgcolor" bgcolor="#1c6be3">
                                <!--<input type="checkbox" name="average" id="AvgCheck" style="background-color:#1c6be3;color:#1c6be3" accesskey="a" onClick="showBar(this.name, this.checked)" {$showAverage}/>-->
                                <xsl:element name="input">
                                    <xsl:attribute name="type">checkbox</xsl:attribute>
                                    <xsl:attribute name="name">average</xsl:attribute>
                                    <xsl:attribute name="id">AvgCheck</xsl:attribute>
                                    <xsl:attribute name="style">background-color:#1c6be3;color:#1c6be3</xsl:attribute>
                                    <xsl:attribute name="accesskey">a</xsl:attribute>
                                    <xsl:attribute name="onClick">showBar(this.name, this.checked)</xsl:attribute>
                                    <xsl:if test="$showAverage='true'" >
                                        <xsl:attribute name="checked">true</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </td>
                            <td>
                                &#160;<xsl:value-of select="$stringsDoc//value[@key='average']" />&#160;
                                <!-- &#160;<u>A</u>verage&#160; -->
                            </td>
                            <td  id="capBgcolor" bgcolor="#000000">
                                <!--<input type="checkbox" name="cap" id="CapCheck" style="background-color:#000000;color:#000000" accesskey="c" onClick="showBar(this.name, this.checked)" {$showCap}/>-->
                                <xsl:element name="input">
                                    <xsl:attribute name="type">checkbox</xsl:attribute>
                                    <xsl:attribute name="name">cap</xsl:attribute>
                                    <xsl:attribute name="id">CapCheck</xsl:attribute>
                                    <xsl:attribute name="style">background-color:#000000;color:#000000</xsl:attribute>
                                    <xsl:attribute name="accesskey">c</xsl:attribute>
                                    <xsl:attribute name="onClick">showBar(this.name, this.checked)</xsl:attribute>
                                    <xsl:if test="$showCap='true'" >
                                        <xsl:attribute name="checked">true</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </td>
                            <td>
                                &#160;<xsl:value-of select="$stringsDoc//value[@key='cap']" />&#160;
                            </td>   
                            <td  id="deratedBgcolor" bgcolor="#58c380">
                                <xsl:element name="input">
                                    <xsl:attribute name="type">checkbox</xsl:attribute>
                                    <xsl:attribute name="name">derated</xsl:attribute>
                                    <xsl:attribute name="id">DeratedCheck</xsl:attribute>
                                    <xsl:attribute name="style">background-color:#58c380;color:#58c380</xsl:attribute>
                                    <xsl:attribute name="accesskey">d</xsl:attribute>
                                    <xsl:attribute name="onClick">showBar(this.name, this.checked)</xsl:attribute>
                                    <xsl:if test="$showDerated='true'" >
                                        <xsl:attribute name="checked">true</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </td>
                            <td>
                                &#160;<xsl:value-of select="$stringsDoc//value[@key='derated']" />&#160;
                            </td>   
                            <td  id="ratedBgcolor" bgcolor="#1b763d">
                                <xsl:element name="input">
                                    <xsl:attribute name="type">checkbox</xsl:attribute>
                                    <xsl:attribute name="name">rated</xsl:attribute>
                                    <xsl:attribute name="id">RatedCheck</xsl:attribute>
                                    <xsl:attribute name="style">background-color:#1b763d;color:#1b763d</xsl:attribute>
                                    <xsl:attribute name="accesskey">r</xsl:attribute>
                                    <xsl:attribute name="onClick">showBar(this.name, this.checked)</xsl:attribute>
                                    <xsl:if test="$showRated='true'" >
                                        <xsl:attribute name="checked">true</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </td>
                            <td>
                                &#160;<xsl:value-of select="$stringsDoc//value[@key='rated']" />&#160;
                            </td>   
                            <td  id="minBgcolor" bgcolor="#acbad2">
                                <!--<input type="checkbox" name="min" id="MinCheck" tyle="background-color:#acbad2;color:#acbad2" accesskey="m" onClick="showBar(this.name, this.checked)" checked="{$showMin}"/>-->
                                <xsl:element name="input">
                                    <xsl:attribute name="type">checkbox</xsl:attribute>
                                    <xsl:attribute name="name">min</xsl:attribute>
                                    <xsl:attribute name="id">MinCheck</xsl:attribute>
                                    <xsl:attribute name="style">background-color:#acbad2;color:#acbad2</xsl:attribute>
                                    <xsl:attribute name="accesskey">m</xsl:attribute>
                                    <xsl:attribute name="onClick">showBar(this.name, this.checked)</xsl:attribute>
                                    <xsl:if test="$showMin='true'" >
                                        <xsl:attribute name="checked">true</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </td>
                            <td>
                                &#160;<xsl:value-of select="$stringsDoc//value[@key='min']" />&#160;
                                <!-- &#160;<u>M</u>in&#160; -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
        <xsl:choose>
            <xsl:when test="$isRedundant='true'" >
               <h3 style="text-align:center;margin-bottom:2px;">
                    <xsl:value-of select="$stringsDoc//value[@key='peakMeterHeadingLeftRight']" />
                    <xsl:value-of select="$stringsDoc//value[@key='leftRightSuffixStart']" />
                    <font size="2"><a href="#LeftRightNote"><span style="vertical-align: super;">*</span></a></font>
                    <xsl:value-of select="$stringsDoc//value[@key='leftRightSuffixEnd']" />
                </h3>
            </xsl:when>
            <xsl:otherwise>
               <h3 style="text-align:center;margin-bottom:2px;">
                <xsl:value-of select="$stringsDoc//value[@key='peakMeterHeadingTotal']" />
                </h3>
            </xsl:otherwise>
        </xsl:choose>

        <table align="center" style="width: 576px;padding-left: 0px;padding-right: 0px;">
            <tr>
                <td align="left">
                    <font size="1">
                    	<xsl:value-of select="$stringsDoc//value[@key='peakMeterGraphDesc']" />
                    </font>
                </td>
		<td align="right">
		    <xsl:value-of select="$stringsDoc//value[@key='showValuesIn']" />
		    <select name="peakUnits" id="peakUnits" onchange="convert();">
			<xsl:element name="option">
				<xsl:if test="$peakUnits='watts'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="value">watts</xsl:attribute>
				&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />
			</xsl:element>
			<xsl:element name="option">
				<xsl:if test="$peakUnits='btus'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="value">btus</xsl:attribute>
				&#160;<xsl:value-of select="$stringsDoc//value[@key='btus']" />
			</xsl:element>
			<xsl:element name="option">
				<xsl:if test="$peakUnits='amps'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="value">amps</xsl:attribute>
				&#160;<xsl:value-of select="$stringsDoc//value[@key='amps']" />
			</xsl:element>
		    </select>
		</td>
            </tr>
        </table>
        <table align="center" class="graphWrapperTable">
            <tr>
                <td align="center">
                    <table style="display: inline; width: 100%; margin:0px;padding:0px;border:0px;padding:0px;" border="0" cellpadding="0" cellspacing="0" >
                        <tr>
                            <td valign="top" align="right" >
                                <b>
                                    <div id="leftTopRangePeakSideA" style="padding-right: 5px;">
                                    </div>
                                </b>
                            </td>
                            <td rowspan="3">
                                <div style="padding: 0px; width: 100%;">
                                    <div style="margin: 0px; padding: 0px;">
                                        <div id="bargraphPeakSideA" style="padding-left: 0px; padding-right: 0px; white-space: nowrap;   width: 576px; overflow: auto;height:220px">
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td valign="top" align="left" >
                                <b>
                                    <div id="rightTopRangePeakSideA" style="padding-left: 5px;">
                                    </div>
                                </b>
                            </td>
                        </tr>
                        <tr style="vertical-align:middle;">
                            <td style="vertical-align:middle;" valign="middle" align="right" >
                                <b>
                                    <div id="leftMidRangePeakSideA" style="padding-right: 5px;">
                                    </div>
                                </b>
                            </td>
                            <td style="vertical-align:middle;" valign="middle" align="left">
                                <b>
                                    <div id="rightMidRangePeakSideA" style="padding-left: 5px;">
                                    </div>
                                </b>
                            </td>
                        </tr>
                        <tr style="vertical-align:bottom;">
                            <td style="vertical-align:bottom;" valign="bottom" align="right">
                                <b>
                                    <div id="leftBtmRangePeakSideA" style="padding-right: 5px;">
                                    </div>
                                </b>
                            </td>
                            <td style="vertical-align:bottom;" valign="bottom" align="left" >
                                <b>
                                    <div id="rightBtmRangePeakSideA" style="padding-left: 5px;">
                                    </div>
                                </b>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
        <xsl:if test="$isRedundant='true'">
        <table align="center" class="graphWrapperTable">
            <tr>
                <td align="center">
                    <table style="display: inline; width: 100%; margin:0px;padding:0px;border:0px;padding:0px;" border="0" cellpadding="0" cellspacing="0" >
                        <tr>
                            <td valign="top" align="right" >
                                <b>
                                    <div id="leftTopRangePeakSideB" style="padding-right: 5px;">
                                    </div>
                                </b>
                            </td>
                            <td rowspan="3">
                                <div style="padding: 0px; width: 100%;">
                                    <div style="margin: 0px; padding: 0px;">
                                        <div id="bargraphPeakSideB" style="padding-left: 0px; padding-right: 0px; white-space: nowrap;   width: 576px; overflow: auto;height:220px">
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td valign="top" align="left" >
                                <b>
                                    <div id="rightTopRangePeakSideB" style="padding-left: 5px;">
                                    </div>
                                </b>
                            </td>
                        </tr>
                        <tr style="vertical-align:middle;">
                            <td style="vertical-align:middle;" valign="middle" align="right" >
                                <b>
                                    <div id="leftMidRangePeakSideB" style="padding-right: 5px;">
                                    </div>
                                </b>
                            </td>
                            <td style="vertical-align:middle;" valign="middle" align="left">
                                <b>
                                    <div id="rightMidRangePeakSideB" style="padding-left: 5px;">
                                    </div>
                                </b>
                            </td>
                        </tr>
                        <tr style="vertical-align:bottom;">
                            <td style="vertical-align:bottom;" valign="bottom" align="right">
                                <b>
                                    <div id="leftBtmRangePeakSideB" style="padding-right: 5px;">
                                    </div>
                                </b>
                            </td>
                            <td style="vertical-align:bottom;" valign="bottom" align="left" >
                                <b>
                                    <div id="rightBtmRangePeakSideB" style="padding-left: 5px;">
                                    </div>
                                </b>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </xsl:if>
        
		
		<div id="errorDisplay" ></div>
		<xsl:if test="string($curAvePower)!='NaN'">
			<table style="width: 100%">
				<tr>
					<td>
						<hr color="#0F4780" />
						<xsl:value-of select="$stringsDoc//value[@key='24history']" />
						<table style="width:100%">
							<td>
								<table>
									<tr>
										<td align="left">
											<b><xsl:value-of select="$stringsDoc//value[@key='avePwrReading']" />:</b>
										</td>
										<td align="left">
											<div id="avePower">
												<xsl:value-of select="$avePower"/>&#160;<xsl:value-of select="$powerUnits" />
											</div>
										</td>
									</tr>
									<tr>
										<td align="left">
											<b><xsl:value-of select="$stringsDoc//value[@key='maxPwrReading']" />
											 <xsl:if test="$isRedundant='true'">
											 <xsl:value-of select="$stringsDoc//value[@key='leftPlusRightSuffixStart']" />
											 <a href="#LeftRightNote"><span style="vertical-align: super;">*</span></a>
											 <xsl:value-of select="$stringsDoc//value[@key='leftPlusRightSuffixEnd']" />
											 </xsl:if>
											:&#160;&#160;</b>
											
										</td>
										<td align="left">
											<div id="maxPower">
												<xsl:value-of select="$maxPower"/>&#160;<xsl:value-of select="$powerUnits" />
										</div>
									</td>
								</tr>
								<tr>
									<td align="left">
										<b><xsl:value-of select="$stringsDoc//value[@key='minPwrReading']" />:</b>
									</td>
									<td align="left">
										<div id="minPower">
											<xsl:value-of select="$minPower"/>&#160;<xsl:value-of select="$powerUnits" />
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td align="right" valign="top">
								<b><xsl:value-of select="$stringsDoc//value[@key='lineVoltageLabel']" /></b>
								<select name="lineVoltage" id="lineVoltage" onchange="convert();">
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='100'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">100</xsl:attribute>
										<xsl:value-of select="'100V'" />
									</xsl:element>
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='110'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">110</xsl:attribute>
										<xsl:value-of select="'110V'" />
									</xsl:element>
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='115'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">115</xsl:attribute>
										<xsl:value-of select="'115V'" />
									</xsl:element>
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='120'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">120</xsl:attribute>
										<xsl:value-of select="'120V'" />
									</xsl:element>
									
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='200'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">200</xsl:attribute>
										<xsl:value-of select="'200V'" />
									</xsl:element>
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='208'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">208</xsl:attribute>
										<xsl:value-of select="'208V'" />
									</xsl:element>
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='220'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">220</xsl:attribute>
										<xsl:value-of select="'220V'" />
									</xsl:element>
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='230'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">230</xsl:attribute>
										<xsl:value-of select="'230V'" />
									</xsl:element>
									<xsl:element name="option">
										<xsl:if test="$lineVoltage='240'">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="value">240</xsl:attribute>
										<xsl:value-of select="'240V'" />
									</xsl:element>
								</select>
							</td>
						</table>
						
						<br />
						<table style="width:100%;">
							<tr>
								<td style="width:100%;">
									<table align="right" style="width:80%;">
										<tr>
											<td>
												<div class="buttonSet">
                          <div class="bWrapperUp">
													  <div>
														  <div>
															  <button class="hpButton" id="btnRefresh" name="btnRefresh" onclick="return refreshPage();"><xsl:value-of select="$stringsDoc//value[@key='refreshPage']" /></button>
														  </div>
													  </div>
												  </div>                          
                        </div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</xsl:if>

		<xsl:if test="$isRedundant='true'">
			<p style="width: 576px;margin-left:10px;"><a name="LeftRightNote"></a>
			<b><i>*</i></b> 
			<xsl:value-of select="$stringsDoc//value[@key='leftRightNote']" />
			</p>
		</xsl:if>
		
		<!-- standard tooltip element -->
		<div id="tooltip" class="popupSmallWrapper">
			<div id="tooltipText" class="popupSmallBody"></div>
		</div>
	</xsl:template>

</xsl:stylesheet>
