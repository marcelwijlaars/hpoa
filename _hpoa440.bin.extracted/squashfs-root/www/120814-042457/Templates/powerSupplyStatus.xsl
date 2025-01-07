<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  
  <xsl:param name="stringsDoc" />
  <!-- Document fragment parameters containing power supply status and information -->
  <xsl:param name="powerSupplyStatusDoc" />
	<xsl:param name="powerSupplyInfoDoc" />
  <xsl:param name="powerConfigInfoDoc" />
	
	<xsl:template match="*">

    <xsl:variable name="psStatus" select="$powerSupplyStatusDoc//hpoa:powerSupplyStatus/hpoa:operationalStatus" />
    
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tbody>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='status']" /></th>
					<td class="propertyValue">
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$psStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='inputStatus']" /></th>
					<td class="propertyValue">							
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$powerSupplyStatusDoc//hpoa:powerSupplyStatus/hpoa:inputStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='persentOutput']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo/hpoa:actualOutput" />&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC
						<xsl:if test="($powerSupplyInfoDoc//hpoa:powerSupplyInfo/hpoa:actualOutput=0 and $powerSupplyStatusDoc//hpoa:powerSupplyStatus/hpoa:operationalStatus='OP_STATUS_OK') and ($powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:dynamicPowerSaverEnabled='true')">
							(<xsl:value-of select="$stringsDoc//value[@key='dynamicPwrSavingMode']" />)
						</xsl:if>
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='outputCapacity']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo/hpoa:capacity" />&#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />&#160;DC
				</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName">
						<xsl:value-of select="$stringsDoc//value[@key='model']" />
					</th>
					<td class="propertyValue">
						<xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo/hpoa:extraData[@hpoa:name='productName']" />
					</td>
				</tr>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='serialNumber']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo/hpoa:serialNumber" />
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='partNumber']" /></th>
					<td class="propertyValue">
						<xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo/hpoa:modelNumber" />
					</td>
				</tr>
			  <tr class="">
				<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='sparePartNumber']" /></th>
				<td class="propertyValue">
				  <xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo/hpoa:sparePartNumber" />
				</td>
			  </tr>
			</tbody>
		</table>

	  <span class="whiteSpacer">&#160;</span>
	  <br />

		<xsl:for-each select="$powerSupplyStatusDoc//hpoa:powerSupplyStatus">

			<xsl:if test="count(hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED')])&gt;0 and count(hpoa:diagnosticChecks/*[not(node()='NOT_RELEVANT')])&gt;0">
				<xsl:call-template name="diagnosticStatusView">
					<xsl:with-param name="statusCode" select="$psStatus" />
					<xsl:with-param name="deviceType" select="'PS'" />
				</xsl:call-template>
			</xsl:if>

		</xsl:for-each>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' onclick="refresh();">
								<xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>

</xsl:stylesheet>
