<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<!-- Document fragment parameters containing power supply status and information -->
	<xsl:param name="powerSupplyStatusDoc" />
	<xsl:param name="powerSupplyInfoDoc" />
	<xsl:param name="powerSubsystemInfoDoc" />
  <xsl:param name="powerConfigInfoDoc" />
	<xsl:param name="stringsDoc" />

	<xsl:param name="totalActualOutput" />
	<xsl:param name="totalCapacity" />
	
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

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<tbody>
				<tr>
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='powerSubsystemStatus']" /></th>
					<td class="propertyValue">
						<xsl:call-template name="getStatusLabel">
							<xsl:with-param name="statusCode" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:operationalStatus" />
						</xsl:call-template>
					</td>
				</tr>
				<tr class="altRowColor">
					<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='powerMode']" /></th>
					<td class="propertyValue">
						<xsl:call-template name="getRedundancyLabel">
							<xsl:with-param name="redundancyMode" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:redundancyMode" />
							<xsl:with-param name="isDC" select="$isDC" />
						</xsl:call-template>
					</td>
				</tr>

				<xsl:variable name="redundancy" select="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:redundancy" />

				<xsl:if test="$redundancy != 'REDUNDANCY_UNKNOWN'">
					<tr>
						<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='redundacyState']" /></th>
						<td class="propertyValue">

							<xsl:call-template name="getRedundancyStateLabel">
								<xsl:with-param name="redundant" select="$redundancy" />
							</xsl:call-template>

						</td>
					</tr>
				</xsl:if>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<table border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$stringsDoc//value[@key='bay']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='model']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='status']" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='inputStatus']" /></th>
					<th style="text-align:right;"><xsl:value-of select="$stringsDoc//value[@key='presentOutputDC']" /></th>
					<th style="text-align:right;"><xsl:value-of select="$stringsDoc//value[@key='outputCapacityDC']" /></th>
				</tr>
			</thead>
			<tbody>

        <xsl:choose>

          <xsl:when test="count($powerSupplyStatusDoc//hpoa:powerSupplyStatus[hpoa:presence=$PRESENT]) &gt; 0">

            <xsl:for-each select="$powerSupplyStatusDoc//hpoa:powerSupplyStatus">

              <xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />

              <xsl:if test="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:presence=$PRESENT">

                <xsl:element name="tr">

                  <xsl:attribute name="class">
                    <xsl:if test="position() mod 2 = 0">altRowColor</xsl:if>
                  </xsl:attribute>
                  <td>
                    <xsl:element name="a">
                      <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$currentBayNumber"/>);</xsl:attribute>
                      <xsl:value-of select="hpoa:bayNumber" />
                    </xsl:element>
                  </td>
						 <td>
							 <xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='productName']"/>
						 </td>
                  <td>
                    <xsl:call-template name="getStatusLabel">
                      <xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
                    </xsl:call-template>
                  </td>
                  <td>
                    <xsl:call-template name="getStatusLabel">
                      <xsl:with-param name="statusCode" select="hpoa:inputStatus" />
                    </xsl:call-template>
                  </td>
					<td class="numericalCell">
						<xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:actualOutput" />
						<xsl:if test="($powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:actualOutput=0 and $powerSupplyStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:operationalStatus='OP_STATUS_OK') and ($powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:dynamicPowerSaverEnabled='true')">
							(<xsl:value-of select="$stringsDoc//value[@key='dynamicPwrSavingMode']" />)
						</xsl:if>
					</td>
                  <td class="numericalCell">
                    <xsl:element name="div">
                      <xsl:attribute name="available"><xsl:value-of select="$currentBayNumber"/></xsl:attribute>
                      <xsl:value-of select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:capacity"/>
                    </xsl:element>
                  </td>

                </xsl:element>

              </xsl:if>
            </xsl:for-each>

			  <tr class="summaryRow">
				  <td>&#160;</td>
				  <td>&#160;</td>
				  <td>&#160;</td>
				  <td><xsl:value-of select="$stringsDoc//value[@key='encTotal']" /></td>
				  <td style="border-left:1px solid #000000;">
					  <xsl:value-of select="$totalActualOutput"/>
				  </td>
				  <td style="border-left:1px solid #000000;">
					  <xsl:value-of select="$totalCapacity"/>
				  </td>
			  </tr>

		  </xsl:when>
		  <xsl:otherwise>
			  <tr class="noDataRow">
				  <td colspan="5"><xsl:value-of select="$stringsDoc//value[@key='noPermissionPowerSupply']" /></td>
			  </tr>
		  </xsl:otherwise>
          
        </xsl:choose>
        
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<em>
			<xsl:value-of select="$stringsDoc//value[@key='presentOutputReadingNote']" />
		</em>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnApplyDateTime" onclick="refreshSummary();">
								<xsl:value-of select="$stringsDoc//value[@key='refresh']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	

</xsl:stylesheet>

