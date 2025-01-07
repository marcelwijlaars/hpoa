<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="powerThermalEnclosure" match="*">
		
		<xsl:variable name="notAvailableString" select="$stringsDoc//value[@key='notAvailable']" />
		<xsl:variable name="noteString" select="$stringsDoc//value[@key='note:']" />
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

		<xsl:variable name="powerUnits">
			<xsl:choose>
				<xsl:when test="$isDC='true'"><xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC</xsl:when>
				<xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;AC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="totalCapacity">
			<xsl:choose>
				<xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerCapacityVa=0">
					<xsl:choose>
						<xsl:when test="string(round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerCapacity)))='NaN'">
							<xsl:value-of select="$notAvailableString"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerCapacity))" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="string(round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerCapacityVa)))='NaN'">
							<xsl:value-of select="$notAvailableString"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerCapacityVa))" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="powerConsumed">
			<xsl:call-template name="getPowerConsumed">
				<xsl:with-param name="powerSubsystemInfoDoc" select="$powerSubsystemInfoDoc" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="powerCap">
			<xsl:choose>
				<xsl:when
					test="string(round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:powerCap))) != 'NaN'">
					<xsl:value-of
						select="round(number($powerCapConfigDoc//hpoa:powerCapConfig/hpoa:powerCap)) " />
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="number(0)" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tbody>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='encAmbientTemp']" /></th>
					<td>
						<xsl:variable name="tempC" select="$enclosureThermalsDoc//hpoa:thermalInfo/hpoa:temperatureC" />

						<xsl:choose>
							<xsl:when test="$tempC != 0">
								<xsl:variable name="tempF">
									<xsl:call-template name="CtoF">
										<xsl:with-param name="tempC" select="$tempC" />
									</xsl:call-template>
								</xsl:variable>

								<xsl:value-of select="$tempC"/>&#176;C / <xsl:value-of select="$tempF"/>&#176;F
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="$notAvailableString"/></xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='thermalSubsystemStatus']" /></th>
					<td>
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:operationalStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='powerSubsystemStatus']" /></th>
					<td>
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:operationalStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='powerMode']" /></th>
					<td>
						<xsl:call-template name="getRedundancyLabel">
							<xsl:with-param name="redundancyMode" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:redundancyMode" />
							<xsl:with-param name="isDC" select="$isDC" />
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='presentPwr']" /></th>
					<td>
						<xsl:value-of select="$powerConsumed" />&#160;<xsl:value-of select="$powerUnits" />
					</td>
				</tr>

				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='pwrLimit']" /></th>
					<td>
						<xsl:value-of select="$totalCapacity" />&#160;<xsl:value-of select="$powerUnits" />
					</td>
				</tr>
				<xsl:if test="$powerCap != 0">
					<tr>
					    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='pwrCapLabel']" /></th>
					    <td>
						<xsl:value-of select="$powerCap" />&#160;<xsl:value-of select="$powerUnits" />
					    </td>
					</tr>
				</xsl:if>
			</tbody>
		</table>
		
		<span class="whiteSpacer">&#160;</span>
		<br />
    <span class="whiteSpacer">&#160;</span>
    <br />

		<xsl:value-of select="$stringsDoc//value[@key='encPower']" />&#160;
		<xsl:if test="not($isDC='true')">(<xsl:value-of select="$stringsDoc//value[@key='acInputPower']" />)</xsl:if>:
		<xsl:choose>
			<xsl:when test="$enclosureType='1'">
				<xsl:choose>
					<xsl:when test="$isDC='true'">
						<em><xsl:value-of select="$stringsDoc//value[@key='presentPwrDesc']" /></em>
						<br /><br /><xsl:value-of select="$noteString" />&#160;
						<xsl:value-of select="$stringsDoc//value[@key='pwrLimitValueDesc']" />
					</xsl:when>
					<xsl:otherwise>
						<em><xsl:value-of select="$stringsDoc//value[@key='presentPwrACDesc2']" /></em>
						<br /><br /><xsl:value-of select="$noteString" />&#160;<xsl:value-of select="$stringsDoc//value[@key='acInputWattageDesc1']" />&#160;  <xsl:value-of select="$stringsDoc//value[@key='pwrLimitValueDesc']" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isDC='true'">
						<em><xsl:value-of select="$stringsDoc//value[@key='presentPwrDesc2']" /></em>
						<br /><br /><xsl:value-of select="$noteString" />&#160;<xsl:value-of select="$stringsDoc//value[@key='dcInputWattageDesc1']" />&#160;  <xsl:value-of select="$stringsDoc//value[@key='pwrLimitValueDesc']" />
					</xsl:when>
					<xsl:otherwise>
						<em><xsl:value-of select="$stringsDoc//value[@key='presentPwrACDesc2']" /></em>
						<br /><br /><xsl:value-of select="$noteString" />&#160;<xsl:value-of select="$stringsDoc//value[@key='acInputWattageDesc2']" />&#160;  <xsl:value-of select="$stringsDoc//value[@key='pwrLimitValueDesc']" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose><br />
		<span class="whiteSpacer">&#160;</span><br />
		
		<table border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tr class="captionRow">
				<th nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='presentPwr']" />
				<xsl:if test="$powerCap != 0">
					/&#160;<xsl:value-of select="$stringsDoc//value[@key='pwrCapLabel']" />
				</xsl:if>				
				/&#160;<xsl:value-of select="$stringsDoc//value[@key='pwrLimit']" />
				</th>
			</tr>
			<tr>
				<td>
					
					<xsl:variable name="percentageUsed">
						<xsl:choose>
							<xsl:when test="$powerConsumed=$notAvailableString or $totalCapacity=$notAvailableString">0</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="(($powerConsumed div $totalCapacity)*100) &gt; 100">100</xsl:when>
									<xsl:otherwise><xsl:value-of select="($powerConsumed div $totalCapacity)*100"/></xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<div class="percentageOutline">
						
						<xsl:element name="div">
							<xsl:attribute name="class">percentageBar</xsl:attribute>
							<xsl:attribute name="devID">PS1</xsl:attribute>
							<xsl:attribute name="style">width:<xsl:value-of select="$percentageUsed"/>%;color:#000000;</xsl:attribute>
							
							<xsl:choose>
								<xsl:when test="$powerConsumed=$notAvailableString">
									<xsl:value-of select="$notAvailableString"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$powerConsumed"/>&#160;<xsl:value-of select="$powerUnits" />
								</xsl:otherwise>
						</xsl:choose>

					</xsl:element>

				</div>

				<xsl:if test="$powerCap != 0 and $powerCap &lt; $totalCapacity">
					<div class="limitIndicatorOutline">
						<xsl:element name="div">
							<xsl:attribute name="class">limitIndicator</xsl:attribute>
							<xsl:attribute name="style">
								width:<xsl:value-of select="($powerCap div $totalCapacity)*100"/>%;border-color:orange;
							</xsl:attribute>
							<xsl:value-of select="$stringsDoc//value[@key='pwrCapLabel']" />:&#160;<xsl:value-of select="$powerCap"/>&#160;<xsl:value-of select="$powerUnits" />&#160;&#160;
						</xsl:element>
					</div>

				</xsl:if>
				
				<div class="limitIndicatorOutline">
					<div class="limitIndicatorNormal" style="width:100%">

						<xsl:choose>
							<xsl:when test="$totalCapacity=$notAvailableString">
								<xsl:value-of select="$notAvailableString"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$stringsDoc//value[@key='pwrLimit']" />:&#160;<xsl:value-of select="$totalCapacity"/>&#160;<xsl:value-of select="$powerUnits" />&#160;&#160;
								</xsl:otherwise>
							</xsl:choose>
							
						</div>
					</div>	

				</td>
			</tr>
		</table>
		
    <span class="whiteSpacer">&#160;</span>
    
	</xsl:template>
	
</xsl:stylesheet>
