<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="graphicsMap" />
  <xsl:param name="enclosureInfoDoc" />
  <xsl:param name="enclosureStatusDoc" />

  <xsl:param name="fanInfoDoc" />

  <xsl:param name="netTrayInfoDoc" />
  <xsl:param name="netTrayStatusDoc" />

  <xsl:param name="powerSupplyStatusDoc" />
  <xsl:param name="powerSupplyInfoDoc" />
  <xsl:param name="powerSubsystemInfoDoc" />
	
  <xsl:param name="kvmInfoDoc" />

  <xsl:include href="../Templates/interconnectBay.xsl" />
  <xsl:include href="../Templates/emBay.xsl" />

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  
  <xsl:param name="encNum" />
  <xsl:param name="isWizard" select="'false'" />

  <xsl:variable name="FANS_PER_ROW" select="3" />
  
  <!-- Main rear enclosure view template -->
  <xsl:template name="enclosureRearView" match="*">

    <!-- Table container for rear enclosure view. Contains fans, interconnects, Link NICs, and OAs. -->
    <xsl:element name="table">
      <xsl:attribute name="id">rearView</xsl:attribute>    
      <xsl:attribute name="class">systemStatusTable</xsl:attribute>
      <xsl:attribute name="cellpadding">0</xsl:attribute>
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="border">0</xsl:attribute>
      <xsl:attribute name="width">224</xsl:attribute>
      <xsl:attribute name="height">138</xsl:attribute>
      <xsl:attribute name="align">center</xsl:attribute>

      <tr>
        <td></td>
        <td>
          <xsl:value-of select="$stringsDoc//value[@key='rearView']" />
        </td>
      </tr>
      
      <!-- Interconnect bays (top two) -->
      <tr>

        <td width="5" style="padding-right: 2px;" rowspan="3">
          <xsl:if test="0">
            b<br />
            o<br />
            t<br />
            t<br />
            o<br />
            m<br />
          </xsl:if>
        </td>
        
        <td width="224">
          <!-- Interconnect bay table container -->
          <table width="224" border="0" cellspacing="0" cellpadding="0" style="border-bottom:1px solid #333;">

			  <xsl:for-each select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=1]">

				  <xsl:variable name="bayNumber" select="hpoa:bayNumber" />
				  <xsl:variable name="ioWidth" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:width" />

				  <xsl:element name="tr">

					  <xsl:call-template name="interConnectBayCell">
						  <xsl:with-param name="trayNumber" select="number($bayNumber)" />
						  <xsl:with-param name="encNum" select="$encNum" />
						  <xsl:with-param name="isWizard" select="$isWizard" />
						  <xsl:with-param name="ioWidth" select="$ioWidth" />
					  </xsl:call-template>

					  <xsl:if test="number($ioWidth)&lt;2">

						  <xsl:call-template name="interConnectBayCell">
							  <xsl:with-param name="trayNumber" select="number($bayNumber)+1" />
							  <xsl:with-param name="encNum" select="$encNum" />
							  <xsl:with-param name="isWizard" select="$isWizard" />
							  <xsl:with-param name="ioWidth" select="$ioWidth" />
						  </xsl:call-template>

					  </xsl:if>

				  </xsl:element>

			  </xsl:for-each>
			  
          </table>
        </td>
      </tr>

		<tr>
			<td width="224">

				<table cellspacing="0" cellpadding="0" style="border-top:1px solid #333;border-bottom:1px solid #333;">

					<tr>

						<!-- First column with video and USB, and power supplies below -->
						<td width="53" class="deviceCellUnselectable" valign="top" style="border-top:0px solid #333;">

							<!-- USB and video out -->
							<table cellspacing="0" cellpadding="0" border="0" height="16" width="53">
								<tr>
									<xsl:element name="td">
										<xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>
										<xsl:choose>
											<xsl:when test="$kvmInfoDoc//hpoa:kvmInfo/hpoa:presence='PRESENT'">
												<xsl:attribute name="background">/120814-042457/images/enclosure_kvm_c3000.gif</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="background">/120814-042457/images/enclosure_usb_c3000.gif</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										<img src="/120814-042457/images/icon_transparent.gif" border="0" height="1" width="1" alt="" />
									</xsl:element>
									
								</tr>
							</table>

							<!-- Left side power supplies. -->
							<table cellpadding="0" cellspacing="0" border="0" width="53" height="76">

								<tr>

									<xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=3]">
										<xsl:call-template name="powerSupply">                      
                      <xsl:with-param name="psNumber" select="'3'" />
                      <xsl:with-param name="psInfoDoc" select="$powerSupplyInfoDoc" />
                      <xsl:with-param name="psStatusDoc" select="$powerSupplyStatusDoc" />
										</xsl:call-template>										
									</xsl:for-each>
									
								</tr>

								<tr>

									<xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=2]">
										<xsl:call-template name="powerSupply">
                      <xsl:with-param name="psNumber" select="'2'" />
                      <xsl:with-param name="psInfoDoc" select="$powerSupplyInfoDoc" />
                      <xsl:with-param name="psStatusDoc" select="$powerSupplyStatusDoc" />
										</xsl:call-template>
									</xsl:for-each>
									
								</tr>

								<tr>

									<xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=1]">
										<xsl:call-template name="powerSupply">
											<xsl:with-param name="psNumber" select="'1'" />
                      <xsl:with-param name="psInfoDoc" select="$powerSupplyInfoDoc" />
                      <xsl:with-param name="psStatusDoc" select="$powerSupplyStatusDoc" />
										</xsl:call-template>
									</xsl:for-each>

								</tr>
								
							</table>
							<!-- End left side power supplies. -->
							
						</td>

						<!-- Fans -->
						<td width="108" align="center" style="border-bottom:1px solid #333;border-top:1px solid #333;background-color:#333;">

							<table cellspacing="0" cellpadding="0" border="0" width="108" height="92">
								<!-- Top row fans -->
								<tr>
									
									<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[number(hpoa:bayNumber) &gt; 0 and number(hpoa:bayNumber) &lt;= $FANS_PER_ROW]">

										<xsl:call-template name="fanCell">
											<xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
											<xsl:with-param name="encNum" select="$encNum" />
											<xsl:with-param name="fanInfo" select="current()" />
										</xsl:call-template>

									</xsl:for-each>

								</tr>

								<!-- Bottom row fans -->
								<tr>
									
									<xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[number(hpoa:bayNumber) &gt; $FANS_PER_ROW and number(hpoa:bayNumber) &lt;= (2 * $FANS_PER_ROW)]">

										<xsl:call-template name="fanCell">
											<xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
											<xsl:with-param name="encNum" select="$encNum" />
											<xsl:with-param name="fanInfo" select="current()" />
										</xsl:call-template>

									</xsl:for-each>

								</tr>
							</table>
							
						</td>

						<td width="53" class="deviceCellUnselectable" valign="top" style="border-top:0px solid #333;">

							<!-- OA Nics and Link Nics -->
							<table cellspacing="0" cellpadding="0" border="0" height="14" width="51">
								<tr>

									<td class="deviceCellUnselectable"  background="{$LINKNIC_IMAGE_C3000}" height="14">
										
										<div style="position:relative;width:51px;height:14px;">
											
											<xsl:call-template name="getUidImage">
												<xsl:with-param name="imgId" select="concat('enc', $encNum, 'linkNic')" />
												<xsl:with-param name="top" select="$graphicsMap//device[@image=$LINKNIC_IMAGE_C3000]/coords/@uidTop" />
												<xsl:with-param name="left" select="$graphicsMap//device[@image=$LINKNIC_IMAGE_C3000]/coords/@uidLeft" />
												<xsl:with-param name="uidState" select="$enclosureStatusDoc//hpoa:enclosureStatus/hpoa:uid" />
											</xsl:call-template>											
										
										</div>
									</td>
									
								</tr>
							</table>

							<!-- Right side power supplies. -->
							<table cellpadding="0" cellspacing="0" border="0" width="53">

								<tr>
									<xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=6]">
										<xsl:call-template name="powerSupply">
											<xsl:with-param name="psNumber" select="'6'" />
                      <xsl:with-param name="psInfoDoc" select="$powerSupplyInfoDoc" />
                      <xsl:with-param name="psStatusDoc" select="$powerSupplyStatusDoc" />
										</xsl:call-template>
									</xsl:for-each>
									
								</tr>

								<tr>
									<xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=5]">
										<xsl:call-template name="powerSupply">
                      <xsl:with-param name="psNumber" select="'5'" />
                      <xsl:with-param name="psInfoDoc" select="$powerSupplyInfoDoc" />
                      <xsl:with-param name="psStatusDoc" select="$powerSupplyStatusDoc" />
										</xsl:call-template>
									</xsl:for-each>
								</tr>

								<tr>
									<xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=4]">
										<xsl:call-template name="powerSupply">
											<xsl:with-param name="psNumber" select="'4'" />
                      <xsl:with-param name="psInfoDoc" select="$powerSupplyInfoDoc" />
                      <xsl:with-param name="psStatusDoc" select="$powerSupplyStatusDoc" />
										</xsl:call-template>

									</xsl:for-each>
								</tr>

							</table>
							<!-- End Right side power supplies. -->
							
						</td>
						
					</tr>
					
				</table>
				
			</td>
		</tr>

		<!-- Interconnect bays (bottom two) -->
		<tr>
			<td width="224">
				<!-- Interconnect bay table container -->
				<table width="224" border="0" cellspacing="0" cellpadding="0">

					<xsl:for-each select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=3]">

						<xsl:variable name="bayNumber" select="hpoa:bayNumber" />
						<xsl:variable name="ioWidth" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:width" />

						<xsl:element name="tr">

							<xsl:call-template name="interConnectBayCell">
								<xsl:with-param name="trayNumber" select="number($bayNumber)" />
								<xsl:with-param name="encNum" select="$encNum" />
								<xsl:with-param name="isWizard" select="$isWizard" />
								<xsl:with-param name="ioWidth" select="$ioWidth" />
							</xsl:call-template>

							<xsl:if test="number($ioWidth)&lt;2">

								<xsl:call-template name="interConnectBayCell">
									<xsl:with-param name="trayNumber" select="number($bayNumber)+1" />
									<xsl:with-param name="encNum" select="$encNum" />
									<xsl:with-param name="isWizard" select="$isWizard" />
									<xsl:with-param name="ioWidth" select="$ioWidth" />
								</xsl:call-template>

							</xsl:if>

						</xsl:element>

					</xsl:for-each>

				</table>
			</td>
		</tr>

    </xsl:element>
    
  </xsl:template>
  
  <!-- Interconnect bay template -->
  <xsl:template name="interConnectBayCell">
  
    <xsl:param name="isWizard" />
    <xsl:param name="trayNumber" />		
    <xsl:param name="encNum" />
    <xsl:param name="ioWidth" />    
    <!--
      Determine cell alignment based on cell number. Cells on the left hand side
      of the table (1, 3, 5, etc.) are aligned left.  Cells on the right hand side
      (2, 4, 6, etc.) are aligned right. NOTE: This must change if bay numbering
      scheme is changed.
    -->    
    <xsl:variable name="status" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$trayNumber]/hpoa:operationalStatus" />
    <xsl:variable name="presence" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$trayNumber]/hpoa:presence" />
    <xsl:variable name="powered" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$trayNumber]/hpoa:powered" />
    <xsl:variable name="uidState" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$trayNumber]/hpoa:uid" />
    
    <xsl:variable name="colspan">			
      <xsl:choose>				
        <xsl:when test="number($trayNumber) mod 2 != 0">					
          <xsl:choose>
            <xsl:when test="number($ioWidth)&lt;2">1</xsl:when>
            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>					
        </xsl:when>				
        <xsl:otherwise>1</xsl:otherwise>				
      </xsl:choose>			
    </xsl:variable>
    
    <xsl:variable name="cellWidth">
      <xsl:value-of select="number($colspan)*111"/>
    </xsl:variable>
    
    <xsl:if test="$presence!=$SUBSUMED or ((number($trayNumber) mod 2 = 0) and ($ioWidth &lt; 2))">

      <xsl:element name="td">

        <xsl:attribute name="colspan"><xsl:value-of select="$colspan" /></xsl:attribute>
        <xsl:attribute name="width"><xsl:value-of select="$cellWidth"/></xsl:attribute>
        <xsl:attribute name="height">18</xsl:attribute>
        <xsl:attribute name="valign">top</xsl:attribute>

        <xsl:choose>
          <xsl:when test="$presence=$PRESENT">
            <xsl:attribute name="class">deviceCell</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:variable name="myId">
          <xsl:value-of select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Select')" />
        </xsl:variable>

        <xsl:variable name="interconnectName">
          <xsl:value-of select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:name"/>
        </xsl:variable>

        <xsl:variable name="extendedType">
          <xsl:value-of select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:extraData[@hpoa:name='ExtendedFabricType']"/>
        </xsl:variable>

        <xsl:attribute name="id">
          <xsl:value-of select="$myId" />
        </xsl:attribute>
        
        <xsl:attribute name="style">line-height:18px;padding:0px;</xsl:attribute>
        <xsl:attribute name="devNum"><xsl:value-of select="$trayNumber" /></xsl:attribute>
        <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
        <xsl:attribute name="devType">interconnect</xsl:attribute>

        <xsl:variable name="deviceImage">
          <xsl:choose>
            <xsl:when test="$presence=$PRESENT">
              <xsl:variable name="type" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:interconnectTrayType" />
              <xsl:variable name="partnumber" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:partNumber" />
              <xsl:choose>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_10GETH and (substring-before($partnumber,'-')='438031' or contains($interconnectName, 'HP 10Gb Ethernet'))">
                  <xsl:value-of select="$IO_10GB_ENET_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_10GETH and contains($interconnectName, 'KX4')">
                  <xsl:value-of select="$IO_10GB_PASS_THRU" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, 'Cisco Fabric Extender')">
                  <xsl:value-of select="$IO_CISCO_FC_HP-FEX_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, '1:10Gb')">
                  <xsl:value-of select="$IO_4XGBEC_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:name, '3020')">
                  <xsl:value-of select="$IO_CISCO_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and (contains($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:name, '3120') or contains($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:name, '3125'))">
                  <xsl:value-of select="$IO_CISCO_IMAGE_3120" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, 'GbE2c Layer 2/3')">
                  <xsl:value-of select="$IO_GBE2C_LAYER2_3_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, 'GbE2c Ethernet')">
                  <xsl:value-of select="$IO_GBE2C_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, '6125XLG Blade Switch')">
                  <xsl:value-of select="$IO_6125_XLG_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, '6125G/XG Blade Switch')">
                  <xsl:value-of select="$IO_6125G_XG_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, '6125G Blade Switch')">
                  <xsl:value-of select="$IO_6125G_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, '6127XLG')">
                  <xsl:value-of select="$IO_6125_XLG_IMAGE" />
                  <!-- Ventina 6127XLG is identical hardware to 6125 -->
                </xsl:when>
                <xsl:when test="contains($interconnectName, '1/10Gb-F VC-Enet') or contains($interconnectName, '6120G')">
                  <xsl:value-of select="$IO_VC_FC_ENET_IMAGE"/>
                </xsl:when>
                <xsl:when test="contains($interconnectName, 'VC Flex-10/10D')">
                  <xsl:value-of select="$IO_VC_ENET_10GB_30port_IMAGE"/>
                </xsl:when>
                <xsl:when test="contains($interconnectName, 'VC Flex-20/40D')">
                  <xsl:value-of select="$IO_VC_ENET_40GB_20port_IMAGE"/>
                </xsl:when>
                <xsl:when test="contains($interconnectName, 'VC FlexFabric-20/40 F8')">
                  <xsl:value-of select="$IO_VC_ENET_40GB_20port_F8_IMAGE"/>
                </xsl:when>
                <xsl:when test="contains($interconnectName, 'Flex-10') or contains($interconnectName, 'ProCurve 6120XG')">
                  <xsl:value-of select="$IO_VC_ENET_10GB_IMAGE"/>
                </xsl:when>
                <xsl:when test="contains($interconnectName, 'FlexFabric')">
                  <xsl:value-of select="$IO_VC_ENET_10GB_24port_IMAGE"/>
                </xsl:when>
                <xsl:when test="contains($interconnectName, 'VC-Enet')">
                  <xsl:value-of select="$IO_VC_ENET_IMAGE"/>
                </xsl:when>
                <xsl:when test="contains($interconnectName, 'VC-FC') or contains($interconnectName, 'Virtual Connect 4Gb FC') or contains($interconnectName, '8Gb 20-Port')">
                  <xsl:value-of select="$IO_VC_FC_IMAGE"/>
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and $netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:passThroughSupport='false'">
                  <xsl:value-of select="$IO_GBE2C_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC and contains($interconnectName, '10GbE Pass-Thru')">
                  <xsl:value-of select="$IO_10GB_PASSTHRU_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC">
                  <xsl:value-of select="$IO_PASSTHRU_IMAGE" />
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_FC">
                  <xsl:choose>
                    <xsl:when test="contains($interconnectName, 'Brocade 16Gb/28c') or contains($interconnectName, 'Brocade 16Gb/16c')">
                      <xsl:value-of select="$IO_16GB_BROCADE_SAN_IMAGE" />
                    </xsl:when>
                    <!-- check for FC Passthru part number here -->
                    <xsl:when test="substring-before($partnumber,'-')='405943' or substring-before($partnumber,'-')='403626'">
                      <!-- FC Passthru image here -->
                      <xsl:value-of select="$IO_FC_PASSTHRU_IMAGE" />
                    </xsl:when>
                    <xsl:when test="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:passThroughSupport='true'">
                      <xsl:value-of select="$IO_FC_PASSTHRU_IMAGE" />
                    </xsl:when>
                    <xsl:when test="contains($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]/hpoa:manufacturer, 'Cisco')">
                      <xsl:value-of select="$IO_CISCO_FC_IMAGE" />
                    </xsl:when>
                    <xsl:when test="contains($interconnectName, '8Gb 20-Port')">
                      <xsl:value-of select="$IO_VC_FC_IMAGE"/>
                    </xsl:when>
                    <xsl:when test="contains($interconnectName, '8Gb') and contains($interconnectName, 'VC')">
                      <xsl:value-of select="$IO_VC_8GB_IMAGE"/>
                    </xsl:when>
                    <xsl:when test="contains($interconnectName, '16Gb') and contains($interconnectName, 'VC')">
                      <xsl:value-of select="$IO_VC_16GB_IMAGE"/>
                    </xsl:when>
                    <!-- Brocade -->
                    <xsl:otherwise>
                      <xsl:value-of select="$IO_FC_IMAGE" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_IB">
                  <xsl:choose>
                    <xsl:when test="contains($interconnectName, 'QDR')">
                      <xsl:choose>
                        <xsl:when test="contains($interconnectName, 'Managed')">
                          <xsl:value-of select="$IO_IB3_IMAGE"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$IO_IB2_IMAGE"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($interconnectName, ' FDR ')">
                      <xsl:choose>
                        <xsl:when test="contains($interconnectName, 'Managed')">
                          <xsl:value-of select="$IO_IB4_IMAGE"/><!-- TODO: will the managed switch look different? -->
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$IO_IB4_IMAGE"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="contains($interconnectName, 'Gen 2')">
                          <xsl:value-of select="$IO_IB2_IMAGE" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$IO_IB_IMAGE" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_SAS">
                  <xsl:choose>
                    <xsl:when test="$ioWidth=2">
                      <xsl:value-of select="$IO_SAS_PASSTHRU_IMAGE"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="contains($interconnectName, '12Gb SAS')">
                          <xsl:value-of select='"/120814-042457/images/io_12Gb_SAS.gif"'/>
                        </xsl:when>
                        <xsl:when test="contains($interconnectName, '6Gb SAS')">
                          <xsl:value-of select='"/120814-042457/images/io_6Gb_SAS.gif"'/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$IO_SAS_SWITCH_IMAGE"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_MAX">
                  <xsl:choose>
                    <xsl:when test="$extendedType='40G Ethernet' and contains($interconnectName, 'Mellanox SX1018HP')">
                      <xsl:value-of select="$IO_IB4_IMAGE"/><!-- identical hardware to IB FDR switch -->
                    </xsl:when>
                    <xsl:when test="$extendedType='ServerNet' and contains($interconnectName, 'ServerNet')">
                      <xsl:value-of select="$IO_SERVERNET"/>
                    </xsl:when>                    
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$IO_STANDARD_IMAGE"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
          <xsl:when test="$deviceImage = ''">
            <xsl:attribute name="bgColor">#000000</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="background"><xsl:value-of select="$deviceImage" /></xsl:attribute>
            <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,160);}catch(e){}</xsl:attribute>
            <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
            <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
            <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
            
				 <!-- tooltip element -->
				 <xsl:call-template name="interconnectBayTooltip">
					 <xsl:with-param name="myId" select="$myId" />
					 <xsl:with-param name="trayInfo" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$trayNumber]" />
					 <xsl:with-param name="trayStatus" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$trayNumber]" />
					 <xsl:with-param name="fanZone" select="false()" />
				 </xsl:call-template>
			 </xsl:otherwise>

		 </xsl:choose>

		 <!-- Interconnect bay container -->
		 <xsl:call-template name="interconnectBay">
			 <xsl:with-param name="deviceImage" select="$deviceImage" />
			 <xsl:with-param name="isWizard" select="$isWizard" />
			 <xsl:with-param name="trayNumber" select="$trayNumber" />
			 <xsl:with-param name="presence" select="$presence" />
			 <xsl:with-param name="status" select="$status" />
			 <xsl:with-param name="uidState" select="$uidState" />
			 <xsl:with-param name="powerState" select="$powered" />
		 </xsl:call-template>

	 </xsl:element>

 </xsl:if>

</xsl:template>

<!-- Fan cell template -->
  <xsl:template name="fanCell">

    <xsl:param name="encNum" />
    <xsl:param name="fanNumber" />
	  <xsl:param name="fanInfo" />
    <xsl:param name="presence" select="hpoa:presence" />
    
    <xsl:element name="td">

      <xsl:variable name="status" select="hpoa:operationalStatus" />
      <xsl:variable name="fan_part_number" select="hpoa:partNumber" />

		 <xsl:variable name="fanImage">
			 <xsl:choose>
				 <xsl:when test="$presence=$PRESENT and $fan_part_number='507082-B21'">
					 <xsl:value-of select="$FAN_1_PRESENT_IMAGE_C3000" />
				 </xsl:when>
				 <!-- Green Fan Image -->
				 <xsl:when test="$presence=$PRESENT and $fan_part_number='507321-B21'">
					 <xsl:value-of select="'/120814-042457/images/enclosure_fan_c3000_green.gif'" />
				 </xsl:when>
				 <xsl:when test="$presence=$PRESENT">
					 <xsl:value-of select="$FAN_PRESENT_IMAGE_C3000" />
				 </xsl:when>
				 <xsl:otherwise>
					 <xsl:value-of select="$FAN_BLANK_IMAGE_C3000"/>
				 </xsl:otherwise>
			 </xsl:choose>
		 </xsl:variable>
		 
      <xsl:attribute name="background"><xsl:value-of select="$fanImage"/></xsl:attribute>
      <xsl:attribute name="height">44</xsl:attribute>
      <xsl:attribute name="width">36</xsl:attribute>
      <xsl:attribute name="align">left</xsl:attribute>
      <xsl:attribute name="valign">top</xsl:attribute>    

		 <xsl:variable name="myId">
			 <xsl:value-of select="concat('enc', $encNum, 'fan', $fanNumber, 'Select')" />
		 </xsl:variable>
      <xsl:choose>
			<xsl:when test="$presence=$PRESENT or $status!='OP_STATUS_UNKNOWN'">
          <xsl:attribute name="id"><xsl:value-of select="concat('enc', $encNum, 'fan', $fanNumber, 'Select')" /></xsl:attribute>      
          <xsl:attribute name="devNum"><xsl:value-of select="$fanNumber" /></xsl:attribute>
          <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>   
          <xsl:attribute name="devType">fan</xsl:attribute>
          <xsl:attribute name="class">deviceCell</xsl:attribute>
          <xsl:attribute name="title" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
		 <xsl:attribute name="id"><xsl:value-of select="$myId" /></xsl:attribute>
		 <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,150);}catch(e){}</xsl:attribute>
		 <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
		 <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
		 <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
      
     <!-- tooltip element -->
		 <xsl:call-template name="fanBayTooltip">
			 <xsl:with-param name="bayNum" select="$fanNumber" />
			 <xsl:with-param name="fanInfoDoc" select="$fanInfoDoc" />
			 <xsl:with-param name="fanZone" select="false()" />
			 <xsl:with-param name="encNum" select="$encNum" />
		 </xsl:call-template>
      
      <xsl:element name="div">      
        <xsl:attribute name="style">position:relative;width:36px;height:44px;</xsl:attribute>
        
        <xsl:variable name="fanStatusImgId" select="concat('enc', $encNum, 'fan', $fanNumber, 'Status')" />
		  
        <xsl:variable name="fanStatus">
          <xsl:choose>            
            <xsl:when test="$presence=$LOCKED or $presence='PRESENCE_NO_OP'"><xsl:value-of select="$LOCKED" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$status"/></xsl:otherwise>
          </xsl:choose>          
        </xsl:variable>
		
        <xsl:variable name="fanStatusVisibility">
          <xsl:choose>
				 <xsl:when test="$presence=$PRESENT or $status!='OP_STATUS_UNKNOWN'">
              <xsl:choose>
                <xsl:when test="$fanStatus=$OP_STATUS_OK">hidden</xsl:when>
                <xsl:otherwise>visible</xsl:otherwise>
              </xsl:choose>              
            </xsl:when> 
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$fanStatus=$LOCKED">visible</xsl:when>
                <xsl:otherwise>hidden</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
			<xsl:if test="$presence=$PRESENT or $status!='OP_STATUS_UNKNOWN' or $fanStatus=$LOCKED">
				<xsl:call-template name="statusIcon">
					<xsl:with-param name="statusCode" select="$fanStatus" />
					<xsl:with-param name="imgId" select="$fanStatusImgId"/>
					<xsl:with-param name="top" select="$graphicsMap//device[@image=$fanImage]/coords/@statusTop" />
					<xsl:with-param name="left" select="$graphicsMap//device[@image=$fanImage]/coords/@statusLeft" />
					<xsl:with-param name="visibility" select="$fanStatusVisibility" />
				</xsl:call-template>
			</xsl:if>
      </xsl:element>
    </xsl:element>    
  </xsl:template>

  <!-- Power Supply -->
	<xsl:template name="powerSupply">
		<xsl:param name="psNumber" />
    <xsl:param name="psInfoDoc" />
    <xsl:param name="psStatusDoc" />
    
		<xsl:variable name="presence" select="$psInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=$psNumber]/hpoa:presence" />
		<xsl:variable name="isDc" select="$psInfoDoc//hpoa:powerSupplyInfo[hpoa:bayNumber=$psNumber]/hpoa:extraData[@hpoa:name='IsDC']" />
    <xsl:variable name="inputStatus" select="$psStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$psNumber]/hpoa:inputStatus" /> 
		<xsl:variable name="status" select="$psStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$psNumber]/hpoa:operationalStatus" /> 

		<!-- Power supply table cell element -->
		<xsl:element name="td">

      <xsl:attribute name="height">24</xsl:attribute>
      <xsl:attribute name="width">36</xsl:attribute>
      <xsl:attribute name="align">left</xsl:attribute>
      <xsl:attribute name="valign">top</xsl:attribute>

      <xsl:attribute name="devNum">
				<xsl:value-of select="$psNumber" />
			</xsl:attribute>
			<xsl:attribute name="encNum">
				<xsl:value-of select="$encNum" />
			</xsl:attribute>
			<xsl:attribute name="devType">ps</xsl:attribute>
      <xsl:attribute name="bayNum"><xsl:value-of select="$psNumber"/></xsl:attribute>
      
			<xsl:attribute name="id">
				<xsl:value-of select="concat('enc', $encNum, 'ps', $psNumber, 'Select')" />
			</xsl:attribute>
      
			<xsl:choose>
				<xsl:when test="$presence=$PRESENT">
					<xsl:attribute name="class">deviceCell</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>        
				</xsl:otherwise>
			</xsl:choose>

			<!--
              Set the table cell's background image based on the presence
              of the power supply in the current bay.
            -->
			<xsl:variable name="psImage">
				<xsl:choose>
					<xsl:when test="$presence=$PRESENT">

						<xsl:choose>
							<xsl:when test="$isDc='true'">
								<xsl:choose>
									<xsl:when test="number($psNumber) &lt;= 3"><xsl:value-of select="$PS_PRESENT_DC_IMAGE" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$PS_PRESENT_DC_IMAGE_RIGHT" /></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="number($psNumber) &lt;= 3"><xsl:value-of select="$PS_PRESENT_IMAGE_C3000" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$PS_PRESENT_IMAGE_C3000_RIGHT" /></xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'BlankPowerSupply_c3000'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$psImage != 'BlankPowerSupply_c3000'">
					<xsl:attribute name="background">
						<xsl:value-of select="$psImage" />
					</xsl:attribute>
          
          <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,200,'ps');}catch(e){}</xsl:attribute>         
          <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
          <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
          <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute> 
                        
          <!-- tooltip element -->
          <xsl:element name="div">
            <xsl:attribute name="class">deviceInfo</xsl:attribute>
            <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $encNum, 'ps', $psNumber, 'SelectInfoTip')"/>
            </xsl:attribute>
           <!-- required attribs for dynamic loading -->
          <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
          <xsl:attribute name="bayNum"><xsl:value-of select="$psNumber" /></xsl:attribute> 
            
            <xsl:call-template name="powerSupplyTooltip">
              <xsl:with-param name="encNum" select="$encNum" />
              <xsl:with-param name="bayNum" select="$psNumber" />
              <xsl:with-param name="psInfoDoc" select="$psInfoDoc" />
              <xsl:with-param name="psStatusDoc" select="$psStatusDoc" />                          
            </xsl:call-template>
          </xsl:element>

				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="bgcolor">#000000;</xsl:attribute>          
				</xsl:otherwise>
			</xsl:choose>
			


			<xsl:variable name="psDisplayStatus">
				<xsl:choose>
					<xsl:when test="$presence=$PRESENT">
						<xsl:value-of select="$status" />
					</xsl:when>
					<xsl:when test="$presence=$LOCKED or $presence='PRESENCE_NO_OP'">
						<xsl:value-of select="$LOCKED" />
					</xsl:when>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$presence=$PRESENT or $psDisplayStatus=$LOCKED">
					
					<xsl:element name="div">

						<xsl:attribute name="style">position:relative;width:36px;height:24px;</xsl:attribute>

						<xsl:variable name="psStatusVisibility">
							<xsl:choose>
								<xsl:when test="$psDisplayStatus=$OP_STATUS_OK">hidden</xsl:when>
								<xsl:otherwise>visible</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:call-template name="statusIcon">
							<xsl:with-param name="statusCode" select="$psDisplayStatus" />
							<xsl:with-param name="imgId" select="concat('enc', $encNum, 'ps', $psNumber, 'Status')"/>
							<xsl:with-param name="top" select="$graphicsMap//device[@image=$psImage]/coords/@statusTop" />
							<xsl:with-param name="left" select="$graphicsMap//device[@image=$psImage]/coords/@statusLeft" />
							<xsl:with-param name="visibility" select="$psStatusVisibility" />
						</xsl:call-template>
						
					</xsl:element>
					
				</xsl:when>
				<xsl:otherwise>
					<img src="/120814-042457/images/icon_transparent.gif" border="0" height="24" width="1" alt="" />
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:element>
		<!-- End power supply table cell element. -->
		
	</xsl:template>

</xsl:stylesheet>
