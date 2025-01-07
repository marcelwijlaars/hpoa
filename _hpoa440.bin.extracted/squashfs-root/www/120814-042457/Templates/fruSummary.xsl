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

    <!-- Document fragment parameters containing blade status and information -->
	<xsl:param name="stringsDoc" />

	<xsl:param name="enclosureInfoDoc" />
	
	<xsl:param name="bladeInfoDoc" />

	<xsl:param name="netTrayInfoDoc" />
	<xsl:param name="netTrayStatusDoc" />

	<xsl:param name="fanInfoDoc" />
	
	<xsl:param name="powerSupplyInfoDoc" />
	
	<xsl:param name="lcdInfoDoc" />
	<xsl:param name="kvmInfoDoc" />

	<xsl:param name="oaInfoDoc" />
	<xsl:param name="oaStatusDoc" />

	<xsl:param name="bladeMezzDevInfoExDoc"/>
	
	<xsl:template match="*">

		<xsl:variable name="modelString"        select="$stringsDoc//value[@key='model']" />
		<xsl:variable name="bayNumberString"    select="$stringsDoc//value[@key='bayNumber']" />
		<xsl:variable name="manufacturerString" select="$stringsDoc//value[@key='manufacturer']" />
		<xsl:variable name="serialNumberString" select="$stringsDoc//value[@key='serialNumber']" />
		<xsl:variable name="partNumberString"   select="$stringsDoc//value[@key='partNumber']" />
		<xsl:variable name="sparePartNumberString"   select="$stringsDoc//value[@key='sparePartNumber']" />
		<xsl:variable name="firmwareVersionString"   select="$stringsDoc//value[@key='firmwareVersion']" />
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='encFRUInfo']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$stringsDoc//value[@key='part']"/></th>
					<th><xsl:value-of select="$modelString" /></th>
					<th><xsl:value-of select="$manufacturerString" /></th>
					<th><xsl:value-of select="$serialNumberString" /></th>
					<th><xsl:value-of select="$partNumberString" /></th>
					<th><xsl:value-of select="$sparePartNumberString" /></th>
				</tr>
			</thead>
			<TBODY>
				<xsl:for-each select="$enclosureInfoDoc//hpoa:enclosureInfo">

					<tr>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='enclosure']"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:name" />
						</td>
						<td>
							<xsl:value-of select="hpoa:manufacturer"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:serialNumber"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:partNumber"/>
						</td>
						<td>
						  N/A
						</td>
					</tr>

					<tr class="altRowColor">
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='encMidPlane']"/>
						</td>
						<td>
							N/A
						</td>
						<td>
							<xsl:value-of select="hpoa:manufacturer"/>
						</td>
						<td>
							N/A
						</td>
						<td>
							N/A
						</td>
						<td>
							<xsl:value-of select="hpoa:chassisSparePartNumber"/>
						</td>
					</tr>
					
					<xsl:if test="not(contains(hpoa:name, 'c3000'))">
						
						<tr>
							<td>
								<xsl:value-of select="$stringsDoc//value[@key='onAdminTray']"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerName" />
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerManufacturer"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerSerialNumber"/>
							</td>
							<td>
								N/A
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerPartNumber"/>
							</td>
						</tr>
					
						<tr class="altRowColor">
							<td>
								<xsl:value-of select="$stringsDoc//value[@key='pim']"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:extraData[@hpoa:name='pduProductName']"/>
							</td>
							<td>
								HP
							</td>
							<td>
								N/A
							</td>
							<td>
								<!--
									This is not an orderable part number for the PDU.  The
									spare part number should be used instead.
								-->
								<!--<xsl:value-of select="hpoa:pduPartNumber"/>-->
								N/A
							</td>
							<td>
								<xsl:value-of select="hpoa:pduSparePartNumber"/>
							</td>
						</tr>

					</xsl:if>
					
				</xsl:for-each>
			</TBODY>
		</table>

		<xsl:if test="$kvmInfoDoc//hpoa:kvmInfo/hpoa:presence='PRESENT'">

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
				<caption><xsl:value-of select="$stringsDoc//value[@key='kvmFRUInfo']"/></caption>
				<thead>
					<tr class="captionRow">
						<th><xsl:value-of select="$stringsDoc//value[@key='part']"/></th>
						<th><xsl:value-of select="$manufacturerString" /></th>
						<th><xsl:value-of select="$serialNumberString" /></th>
						<th><xsl:value-of select="$partNumberString" /></th>
						<th><xsl:value-of select="$sparePartNumberString" /></th>
					</tr>
				</thead>
				<TBODY>

					<tr>
						<td>
							<xsl:value-of select="$kvmInfoDoc//hpoa:kvmInfo/hpoa:name"/>
						</td>
						<td>
							<xsl:value-of select="$kvmInfoDoc//hpoa:kvmInfo/hpoa:manufacturer"/>
						</td>
						<td>
							<xsl:value-of select="$kvmInfoDoc//hpoa:kvmInfo/hpoa:serialNumber"/>
						</td>
						<td>
							<xsl:value-of select="$kvmInfoDoc//hpoa:kvmInfo/hpoa:partNumber"/>
						</td>
						<td>
							<xsl:value-of select="$kvmInfoDoc//hpoa:kvmInfo/hpoa:sparePartNumber"/>
						</td>
					</tr>
					
				</TBODY>
			</table>
			
		</xsl:if>
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='oaFRUInfo']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$bayNumberString" /></th>
					<th><xsl:value-of select="$modelString" /></th>
					<th><xsl:value-of select="$manufacturerString" /></th>
					<th><xsl:value-of select="$serialNumberString" /></th>
					<th><xsl:value-of select="$partNumberString" /></th>
					<th><xsl:value-of select="$sparePartNumberString" /></th>
					<th><xsl:value-of select="$firmwareVersionString"/></th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='hardwareVersion']"/>
					</th>
				</tr>
			</thead>
			<TBODY>

				<xsl:for-each select="$oaInfoDoc//hpoa:oaInfo">

					<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />

					<xsl:if test="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:oaRole!=$OA_ABSENT">

						<xsl:element name="tr">

							<xsl:if test="position() mod 2 != 0">
								<xsl:attribute name="class">altRowColor</xsl:attribute>
							</xsl:if>

							<td>
								<xsl:value-of select="hpoa:bayNumber"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:name" />
							</td>
						  <td>
							<xsl:value-of select="hpoa:manufacturer" />
						  </td>
							<td>
								<xsl:value-of select="hpoa:serialNumber"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:partNumber"/>
							</td>
							<td>
							  <xsl:value-of select="hpoa:sparePartNumber"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:fwVersion"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:hwVersion"/>
							</td>

						</xsl:element>
						
					</xsl:if>
					
				</xsl:for-each>

			</TBODY>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
	
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='bladeFRUInfo']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$bayNumberString" /></th>
					<th><xsl:value-of select="$modelString" /></th>
					<th><xsl:value-of select="$manufacturerString" /></th>
					<th><xsl:value-of select="$serialNumberString" /></th>
					<th><xsl:value-of select="$partNumberString" /></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='boardSparePartNumber']"/></th>
				</tr>
			</thead>
			<TBODY>

				<xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:presence=$PRESENT]">
				<xsl:sort select="hpoa:extraData[@hpoa:name='NormalizedBayNumber']" data-type="number" />
				<xsl:sort select="hpoa:extraData[@hpoa:name='NormalizedSideNumber']" />

					<xsl:element name="tr">

						<xsl:if test="position() mod 2 != 0">
							<xsl:attribute name="class">altRowColor</xsl:attribute>
						</xsl:if>

						<td>
					  <xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
       <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
						</td>
						<td>
							<xsl:value-of select="hpoa:name" />
						</td>
					  <td>
						<xsl:value-of select="hpoa:manufacturer"/>
					  </td>
						<td>
							<xsl:value-of select="hpoa:serialNumber"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:partNumber"/>
						</td>
					  <td>
						<xsl:value-of select="hpoa:sparePartNumber"/>
					  </td>
						
					</xsl:element>
					
				</xsl:for-each>
				
			</TBODY>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption>
				<xsl:value-of select="$stringsDoc//value[@key='bladeMezzFRUInfo']"/>
			</caption>
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='bay']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='mezzSlotShort']"/>
					</th>
					<th>
						<xsl:value-of select="$modelString" />
					</th>
					<th>
						<xsl:value-of select="$manufacturerString" />
					</th>
					<th>
						<xsl:value-of select="$serialNumberString" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='pcaSerialNum']" />
					</th>
					<th>
						<xsl:value-of select="$partNumberString" />
					</th>
					<th>
						<xsl:value-of select="$sparePartNumberString" />
					</th>
				</tr>
			</thead>
			<TBODY>
				<xsl:for-each select="$bladeMezzDevInfoExDoc//hpoa:bladeMezzDevInfoEx">
					<xsl:sort select="hpoa:NormalizedBayNumber" data-type="number" />
					<xsl:sort select="hpoa:NormalizedSideNumber" />
					
					<xsl:if test="count(hpoa:mezzDevInfoEx) &gt; 0">

						<xsl:for-each select="hpoa:mezzDevInfoEx">
							<xsl:element name="tr">
								<td>
									<xsl:value-of select="../hpoa:SymbolicBladeNumber"/>
								</td>
								<td>
									<!-- Physical Mezz or FLB -->
									<xsl:choose>
										<!-- If FLB, convert mezzNumber to FLB value and add FLB notation -->
										<xsl:when test="hpoa:mezzNumber &gt; $FLB_START_IX">
											<xsl:variable name="FLBNumber" select="hpoa:mezzNumber - $FLB_START_IX"/>
											<xsl:value-of select="concat('FLB', ' ', $FLBNumber)"/>
										</xsl:when>
										<xsl:otherwise>									
											<!-- Otherwise, display mezzNumber directly -->
											<xsl:value-of select="hpoa:mezzNumber"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="hpoa:productName"/>
								</td>
								<td>
									<xsl:value-of select="hpoa:manufacturer"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="hpoa:extraData[@hpoa:name='ProductSerialNumber']='0000000000'">
											<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="hpoa:extraData[@hpoa:name='ProductSerialNumber']"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="hpoa:serialNumber='0000000000'">
											<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="hpoa:serialNumber"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="hpoa:partNumber"/>
								</td>
								<td>
									<xsl:value-of select="hpoa:sparePartNumber"/>
								</td>
								
							</xsl:element>
						</xsl:for-each>
					
					</xsl:if>
					
				</xsl:for-each>
				
			</TBODY>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='intrConnectFRUInfo']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$bayNumberString" /></th>
					<th><xsl:value-of select="$modelString" /></th>
					<th><xsl:value-of select="$manufacturerString" /></th>
					<th><xsl:value-of select="$serialNumberString" /></th>
					<th><xsl:value-of select="$partNumberString" /></th>
					<th><xsl:value-of select="$sparePartNumberString" /></th>
				</tr>
			</thead>
			<TBODY>

				<xsl:for-each select="$netTrayInfoDoc//hpoa:interconnectTrayInfo">

					<xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />

					<xsl:if test="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:presence=$PRESENT">

						<xsl:element name="tr">

							<xsl:if test="position() mod 2 != 0">
								<xsl:attribute name="class">altRowColor</xsl:attribute>
							</xsl:if>

							<td>
								<xsl:value-of select="hpoa:bayNumber"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:name" />
							</td>
						  <td>
							<xsl:value-of select="hpoa:manufacturer"/>
						  </td>
							<td>
								<xsl:value-of select="hpoa:serialNumber"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:partNumber"/>
							</td>
						  <td>
							<xsl:value-of select="hpoa:sparePartNumber"/>
						  </td>

						</xsl:element>
						
					</xsl:if>
					
				</xsl:for-each>

			</TBODY>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='fanFRUInfo']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$bayNumberString" /></th>
					<th><xsl:value-of select="$modelString" /></th>
					<th><xsl:value-of select="$partNumberString" /></th>
					<th><xsl:value-of select="$sparePartNumberString" /></th>
				</tr>
			</thead>
			<TBODY>

				<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[hpoa:presence=$PRESENT]">
					
					<xsl:element name="tr">

						<xsl:if test="position() mod 2 != 0">
							<xsl:attribute name="class">altRowColor</xsl:attribute>
						</xsl:if>

						<td>
							<xsl:value-of select="hpoa:bayNumber"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:name" />
						</td>
						<td>
							<xsl:value-of select="hpoa:partNumber"/>
						</td>
					  <td>
						<xsl:value-of select="hpoa:sparePartNumber"/>
					  </td>

					</xsl:element>
					
				</xsl:for-each>

			</TBODY>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='pwrSupplyFRUInfo']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$bayNumberString" /></th>
					<th><xsl:value-of select="$modelString"/></th>
					<th><xsl:value-of select="$partNumberString" /></th>
					<th><xsl:value-of select="$serialNumberString" /></th>
					<th><xsl:value-of select="$sparePartNumberString" /></th>
				</tr>
			</thead>
			<TBODY>

				<xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:presence=$PRESENT]">

					<xsl:element name="tr">

						<xsl:if test="position() mod 2 != 0">
							<xsl:attribute name="class">altRowColor</xsl:attribute>
						</xsl:if>

						<td>
							<xsl:value-of select="hpoa:bayNumber"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:extraData[@hpoa:name='productName']"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:modelNumber"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:serialNumber"/>
						</td>
					  <td>
						<xsl:value-of select="hpoa:sparePartNumber"/>
					  </td>
					</xsl:element>

				</xsl:for-each>

			</TBODY>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<caption><xsl:value-of select="$stringsDoc//value[@key='insightDisplayFRUInfo']"/></caption>
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$modelString" /></th>
					<th><xsl:value-of select="$sparePartNumberString" /></th>
					<th><xsl:value-of select="$manufacturerString" /></th>
					<th><xsl:value-of select="$firmwareVersionString"/></th>
				</tr>
			</thead>
			<TBODY>

				<tr>
					<td>
						<xsl:value-of select="$lcdInfoDoc//hpoa:lcdInfo/hpoa:name"/>
					</td>
					<td>
						<xsl:value-of select="$lcdInfoDoc//hpoa:lcdInfo/hpoa:partNumber"/>
					</td>
					<td>
						<xsl:value-of select="$lcdInfoDoc//hpoa:lcdInfo/hpoa:manufacturer"/>
					</td>
					<td>
						<xsl:value-of select="$lcdInfoDoc//hpoa:lcdInfo/hpoa:fwVersion"/>
					</td>
				</tr>

			</TBODY>
		</table>

	</xsl:template>

	
</xsl:stylesheet>
