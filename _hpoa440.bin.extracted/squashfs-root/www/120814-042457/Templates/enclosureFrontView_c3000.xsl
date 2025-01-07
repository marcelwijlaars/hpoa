<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->

  <xsl:param name="encNum" />

  <xsl:param name="stringsDoc"/>
  <xsl:param name="graphicsMap" />

  <xsl:param name="enclosureInfoDoc" />
  <xsl:param name="enclosureStatusDoc" />

  <xsl:param name="bladeInfoDoc" />
  <xsl:param name="bladeStatusDoc" />
	<xsl:param name="domainInfoDoc" />

  <xsl:param name="oaStatusDoc" />
  <xsl:param name="oaInfoDoc" />
  <xsl:param name="oaNetworkInfoDoc" />

  <xsl:param name="mpInfoDoc" select="string('')"  />
  <xsl:param name="currentUserAcl" />
	<xsl:param name="currentUserInfo" />

  <xsl:param name="oaMediaDeviceList" />
  
  <!--
    Variable indicating whether or not this enclosure transformation is
    part of a wizard or a status overview. If it is part of a wizard, the
    checkboxes will be shown. If not, they will be hidden.
  -->
  <xsl:param name="isWizard" select="'false'"/>

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  <xsl:include href="../Templates/deviceBay.xsl" />
  <xsl:include href="../Templates/emBay.xsl" />

  <!-- Width and height are opposite for the c3000 enclosure. -->
	<xsl:variable name="BLADES_PER_ROW" select="4" />
	<xsl:variable name="SINGLE_BAY_WIDTH" select="26"></xsl:variable>
	<xsl:variable name="SINGLE_BAY_HEIGHT" select="90"></xsl:variable>
	<xsl:variable name="DOUBLE_BAY_WIDTH" select="54"></xsl:variable>
	<xsl:variable name="FULL_BAY_HEIGHT" select="182"></xsl:variable>
	<xsl:variable name="DD_BAY_WIDTH" select="13"></xsl:variable>
  
  <!--
      Front view template containing the enclosure bays and power supply bays.
      Blade and storage bays call the bay template (bay.xsl) to render each bay.
      Power supply bays call the powerSupply template (powerSupply.xsl) to render
      power supply information. Template matches all nodes because actual XML
      information is taken from XML document fragment parameters declared above.
  -->
  <xsl:template name="enclosureFrontView" match="*">
    
    <!-- Front view table container -->
    <xsl:element name="table">
      <xsl:attribute name="id">frontView</xsl:attribute>
      <xsl:attribute name="class">systemStatusTable</xsl:attribute>
      <xsl:attribute name="cellpadding">0</xsl:attribute>
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="border">0</xsl:attribute>
      <xsl:attribute name="width">224</xsl:attribute>
      <xsl:attribute name="height">138</xsl:attribute>
      <xsl:attribute name="align">center</xsl:attribute>

      <tr>
        <td>
            <xsl:value-of select="$stringsDoc//value[@key='frontView']" />
        </td>
      </tr>
      
      <tr>
        
        <td width="224">

      <table cellpadding="0" cellspacing="0" border="0" width="224">
        <tr>

          <td width="18" height="106" class="deviceCellUnselectable" background="/120814-042457/images/leftside_c3000.gif">
            <img src="/120814-042457/images/icon_transparent.gif" border="0" height="1" width="18" alt="" />
          </td>
          
          <td width="182">

						<!-- this div provides an anchor point for the images below; do not remove -->
						<div style="position:relative; z-index:98;" id="{concat('frontViewInner', $encNum)}" isContainerDiv="true">

							<!-- Domain boards -->
							<xsl:if test="count($domainInfoDoc//hpoa:domainInfo/hpoa:domains/hpoa:domain[hpoa:size=1 or hpoa:size=2 or hpoa:size=4]) &gt; 0">

								<xsl:for-each select="$domainInfoDoc//hpoa:domainInfo/hpoa:domains/hpoa:domain[hpoa:size=1 or hpoa:size=2 or hpoa:size=4]">

									<xsl:element name="div">

										<xsl:variable name="firstBay" select="number(hpoa:bays/hpoa:bay)" />

										<xsl:variable name="height">
											<xsl:choose>
												<xsl:when test="number(hpoa:size)=4">112</xsl:when>
												<xsl:when test="number(hpoa:size)=2">56</xsl:when>
												<xsl:when test="number(hpoa:size)=1">28</xsl:when>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="y_pos">
											<xsl:choose>
												<xsl:when test="$firstBay=1">
													<xsl:value-of select="(28*4)-number($height)"/>
												</xsl:when>
												<xsl:when test="$firstBay=2">
													<xsl:value-of select="(28*3)-number($height)"/>
												</xsl:when>
												<xsl:when test="$firstBay=3">
													<xsl:value-of select="(28*2)-number($height)"/>
												</xsl:when>
												<xsl:when test="$firstBay=4">
													<xsl:value-of select="(28*1)-number($height)"/>
												</xsl:when>
											</xsl:choose>
										</xsl:variable>

										<xsl:choose>
											<xsl:when test="hpoa:size=4">
												<xsl:attribute name="style">
													z-index:100; position:absolute; left:49px; top:<xsl:value-of select="$y_pos" />px; width:72px; height:<xsl:value-of select="$height" />px; background:url('/120814-042457/images/domain_bar_4_90.gif');
												</xsl:attribute>
											</xsl:when>
											<xsl:when test="hpoa:size=2">
												<xsl:attribute name="style">
													z-index:100; position:absolute; left:49px; top:<xsl:value-of select="$y_pos" />px; width:72px; height:<xsl:value-of select="$height" />px; background:url('/120814-042457/images/domain_bar_2_90.gif');
												</xsl:attribute>
											</xsl:when>
											<xsl:when test="hpoa:size=1">
												<xsl:attribute name="style">
													z-index:100; position:absolute; left:49px; top:<xsl:value-of select="$y_pos" />px; width:72px; height:<xsl:value-of select="$height" />px; background:url('/120814-042457/images/domain_bar_1_90.gif');
												</xsl:attribute>
											</xsl:when>
										</xsl:choose>

										<xsl:attribute name="id">
											<xsl:value-of select="concat('enc', $encNum, 'monarch', hpoa:monarchBlade, 'Container')"/>
										</xsl:attribute>

										<table style="width:100%;" cellspacing="0" cellpadding="0" border="0">
											<tr>
												<td id="{concat('enc', $encNum, 'monarch', hpoa:monarchBlade, 'Select')}" devNum="{hpoa:monarchBlade}" style="height:{$height}px;" encNum="{$encNum}" devType="monarch" class="deviceCell">
													<table style="width:100%;" cellspacing="0" cellpadding="0" border="0">
														<tr>
															<td>&#160;</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>

									</xsl:element>

								</xsl:for-each>
							</xsl:if>
							<!-- End domain boards -->

							<!-- tooltip element -->
							<xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:presence='PRESENT']">
								<xsl:variable name="bayNumber" select="hpoa:bayNumber" />
								<xsl:variable name="mpIpAddress">
									<xsl:choose>
										<xsl:when test="$mpInfoDoc!=''">
											<xsl:value-of select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$bayNumber]/hpoa:ipAddress"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="string('')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<xsl:element name="div" >
									<xsl:attribute name="class">deviceInfo</xsl:attribute>
									<xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat('enc', $encNum, 'bay', $bayNumber, 'SelectInfoTip')" />
									</xsl:attribute>
									<xsl:attribute name="encNum">
										<xsl:value-of select="$encNum"/>
									</xsl:attribute>
									<xsl:attribute name="bayNum">
										<xsl:value-of select="$bayNumber"/>
									</xsl:attribute>

									<xsl:call-template name="deviceBayTooltip">
										<xsl:with-param name="myId" select="'frontViewInner'" />
										<xsl:with-param name="bladeInfo" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]" />
                    <xsl:with-param name="bladeMpInfo" select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$bayNumber]" />
										<xsl:with-param name="mpIpAddress" select="$mpIpAddress"/>
									</xsl:call-template>

								</xsl:element>
							</xsl:for-each>

							<xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:presence='PRESENT']">

								<xsl:call-template name="serverBay">
									<xsl:with-param name="bayNumber" select="hpoa:bayNumber" />
									<xsl:with-param name="presence" select="hpoa:presence" />
									<xsl:with-param name="isWizard" select="$isWizard" />
								</xsl:call-template>

							</xsl:for-each>

							<xsl:call-template name="enclosureBackground">
								
							</xsl:call-template>
							
						</div>
					</td>

          <!-- DVD Table cell -->
          <xsl:element name="td">

			  <xsl:variable name="dvdImage">
				  <xsl:choose>
					  <xsl:when test="count($oaMediaDeviceList//hpoa:oaMediaDevice[hpoa:deviceType=1 and hpoa:devicePresence='PRESENT']) &gt; 0">
						  <xsl:value-of select="$MEDIA_DVD_PRESENT_c3000"/>
					  </xsl:when>
					  <xsl:otherwise>
						  <xsl:value-of select="$MEDIA_DVD_NOT_PRESENT_c3000"/>
					  </xsl:otherwise>
				  </xsl:choose>
			  </xsl:variable>
            
            <xsl:attribute name="width">20</xsl:attribute>
				 <xsl:choose>
					 <xsl:when test="$currentUserAcl='USER'">
						 <xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>
					 </xsl:when>
					 <xsl:otherwise>
						 <xsl:attribute name="class">deviceCell</xsl:attribute>
					 </xsl:otherwise>
				 </xsl:choose>

            <xsl:attribute name="background">
              <xsl:value-of select="$dvdImage"/>
            </xsl:attribute>

            <xsl:attribute name="devNum">12</xsl:attribute>
            <xsl:attribute name="encNum">
              <xsl:value-of select="$encNum" />
            </xsl:attribute>
            <xsl:attribute name="devType">dvd</xsl:attribute>

            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $encNum, 'dvd12Select')" />
            </xsl:attribute>

            <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,120,"dvd");}catch(e){}</xsl:attribute>
            <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
            <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
            <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
            
            <xsl:element name="div">
              <xsl:attribute name="class">deviceInfo</xsl:attribute>
              <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $encNum, 'dvd12SelectInfoTip')"/>
              </xsl:attribute>
               <!-- required attribs for dynamic loading -->
              <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
              <xsl:attribute name="bayNum"><xsl:value-of select="'1'" /></xsl:attribute>

              <xsl:call-template name="dvdDriveTooltip">
                <xsl:with-param name="encNum" select="$encNum" />
                <xsl:with-param name="drivePresence" select="(count($oaMediaDeviceList//hpoa:oaMediaDevice[hpoa:deviceType=1 and hpoa:devicePresence='PRESENT']) &gt; 0)" />
			          <xsl:with-param name="mediaPresence" select="(count($oaMediaDeviceList//hpoa:oaMediaDevice[hpoa:deviceType=1 and hpoa:mediaPresence='PRESENT']) &gt; 0)" />
              </xsl:call-template>
            </xsl:element>

            <xsl:element name="div">
              <xsl:attribute name="style">position:relative;border:0px;width:18px;height:106px;</xsl:attribute>

              <xsl:if test="count($oaMediaDeviceList//hpoa:oaMediaDevice[hpoa:deviceType=1 and hpoa:mediaPresence='PRESENT']) &gt; 0">
                <xsl:call-template name="getPowerLedCustom">
                  <xsl:with-param name="ledImage" select="'/120814-042457/images/dvd_led.gif'"/>
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$dvdImage]/coords/@powerTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$dvdImage]/coords/@powerLeft" />
                  <xsl:with-param name="width" select="2" />
                  <xsl:with-param name="height" select="2" />
                </xsl:call-template>
              </xsl:if>
            </xsl:element>
          </xsl:element>

        </tr>
      </table>
        </td>
      
      </tr>
    
      <!-- Only display the OAs if we are not in the wizard -->
      <xsl:if test="$isWizard = 'false'">
        <tr>
          <td width="224" height="18">
            <!-- OA Row Container -->
            <table align="center" width="224" style="border:0px;" cellspacing="0" cellpadding="0">				
              <tr>
              <xsl:element name="td">

                <xsl:attribute name="width">90</xsl:attribute>
                <xsl:attribute name="height">16</xsl:attribute>
                <xsl:attribute name="align">left</xsl:attribute>
                <xsl:attribute name="valign">top</xsl:attribute>
                <xsl:attribute name="style">line-height:16px;padding:0px;</xsl:attribute>

                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $encNum, 'em1Select')" />
                </xsl:attribute>

                <xsl:attribute name="devNum">1</xsl:attribute>
                <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="bayNum">1</xsl:attribute>

                <xsl:variable name="roleBay1" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=1]/hpoa:oaRole" />

                <xsl:choose>
                  <xsl:when test="$roleBay1!=$OA_ABSENT and $roleBay1!=$ABSENT">
                    <xsl:attribute name="background">
                      <xsl:choose>
                        <xsl:when test="$roleBay1 = $STANDBY">
                          <xsl:value-of select="$EM_PRESENT_IMAGE_STANDBY_C3000" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$EM_PRESENT_IMAGE_C3000" />
                        </xsl:otherwise>
                      </xsl:choose>									
                    </xsl:attribute>
                    <xsl:attribute name="class">deviceCell</xsl:attribute>
                    
                    <!-- tooltip events -->
                    <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,220,'oabay');}catch(e){}</xsl:attribute>
                    <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
                    <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
                    <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
                    
                    <!-- tooltip element -->
                    <xsl:element name="div">
                      <xsl:attribute name="class">deviceInfo</xsl:attribute>
                      <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('enc', $encNum, 'em1', 'SelectInfoTip')"/>
                      </xsl:attribute>
                       <!-- required attribs for dynamic loading -->
                      <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
                      <xsl:attribute name="bayNum"><xsl:value-of select="'1'" /></xsl:attribute>
                       
                      <xsl:call-template name="emBayTooltip">
                        <xsl:with-param name="encNum" select="$encNum" />
                        <xsl:with-param name="bayNum" select="'1'" />
                        <xsl:with-param name="oaInfo" select="$oaInfoDoc" />
                        <xsl:with-param name="oaStatus" select="$oaStatusDoc" />
                        <xsl:with-param name="oaNetInfo" select="$oaNetworkInfoDoc" />                      
                      </xsl:call-template>
                    </xsl:element>

                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:variable name="presence1">
                  <xsl:choose>
                    <xsl:when test="$roleBay1!=$OA_ABSENT">
                      <xsl:value-of select="$PRESENT"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$ABSENT"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>

                <xsl:call-template name="emBay">
                  <xsl:with-param name="emNumber" select="1" />
                  <xsl:with-param name="presence" select="$presence1" />
                  <xsl:with-param name="status" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=1]/hpoa:operationalStatus" />
                  <xsl:with-param name="isWizard" select="$isWizard" />
                  <xsl:with-param name="encNum" select="$encNum" />
                  <xsl:with-param name="uidState" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=1]/hpoa:uid" />
                  <xsl:with-param name="width" select="90" />
                  <xsl:with-param name="displayImage" select="$EM_PRESENT_IMAGE_C3000" />
                </xsl:call-template>

              </xsl:element>

              <!-- Insight Display -->
              <xsl:element name="td">
					  <xsl:attribute name="class">deviceCell</xsl:attribute>
					  <xsl:attribute name="width">38</xsl:attribute>
					  <xsl:attribute name="height">16</xsl:attribute>
					  <xsl:attribute name="align">left</xsl:attribute>
					  <xsl:attribute name="valign">top</xsl:attribute>
					  <xsl:attribute name="title">Insight Display</xsl:attribute>
					  <xsl:attribute name="style">
						  background-image:url(<xsl:value-of select="$LCD_BLANK_IMAGE_C3000"/>);
					  </xsl:attribute>

					  <xsl:attribute name="id">
						  <xsl:value-of select="concat('enc', $encNum, 'lcd', '1', 'Select')" />
                </xsl:attribute>
                
                <xsl:attribute name="devNum">1</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$encNum" />
                </xsl:attribute>
                <xsl:attribute name="devType">lcd</xsl:attribute>
                
                <img src="/120814-042457/images/icon_transparent.gif" border="0" height="1" width="38" alt="" />
                
              </xsl:element>

              <!-- Standby OA Module -->
              <xsl:element name="td">

                <xsl:attribute name="width">90</xsl:attribute>
                <xsl:attribute name="height">16</xsl:attribute>
                <xsl:attribute name="align">left</xsl:attribute>
                <xsl:attribute name="valign">top</xsl:attribute>
                <xsl:attribute name="style">line-height:16px;padding:0px;</xsl:attribute>

                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $encNum, 'em2Select')" />
                </xsl:attribute>
                
                <xsl:attribute name="devNum">2</xsl:attribute>
                <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="bayNum">2</xsl:attribute>
                
                <xsl:variable name="roleBay2" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=2]/hpoa:oaRole" />

                <xsl:choose>
                  <xsl:when test="$roleBay2!=$OA_ABSENT">
                    <xsl:attribute name="background">
                      <xsl:choose>
                        <xsl:when test="$roleBay2 = $STANDBY">
                          <xsl:value-of select="$EM_PRESENT_IMAGE_STANDBY_C3000" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$EM_PRESENT_IMAGE_C3000" />
                        </xsl:otherwise>
                      </xsl:choose>									
                    </xsl:attribute>
                    <xsl:attribute name="class">deviceCell</xsl:attribute>
                    
                    <!-- tooltip events -->
                    <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,220,'oabay');}catch(e){}</xsl:attribute>
                    <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
                    <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
                    <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
                    
                    <!-- tooltip element -->
                    <xsl:element name="div">
                      <xsl:attribute name="class">deviceInfo</xsl:attribute>
                      <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('enc', $encNum, 'em2', 'SelectInfoTip')"/>
                      </xsl:attribute>
                       <!-- required attribs for dynamic loading -->
                      <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
                      <xsl:attribute name="bayNum"><xsl:value-of select="'2'" /></xsl:attribute>
                       
                      <xsl:call-template name="emBayTooltip">
                        <xsl:with-param name="encNum" select="$encNum" />
                        <xsl:with-param name="bayNum" select="'2'" />
                        <xsl:with-param name="oaInfo" select="$oaInfoDoc" />
                        <xsl:with-param name="oaStatus" select="$oaStatusDoc" />
                        <xsl:with-param name="oaNetInfo" select="$oaNetworkInfoDoc" />                      
                      </xsl:call-template>
                    </xsl:element>                  
                    
                    <xsl:variable name="presence2">
                      <xsl:choose>
                        <xsl:when test="$roleBay2!=$OA_ABSENT">
                          <xsl:value-of select="$PRESENT"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$ABSENT"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>

                    <xsl:call-template name="emBay">
                      <xsl:with-param name="emNumber" select="2" />
                      <xsl:with-param name="presence" select="$presence2" />
                      <xsl:with-param name="status" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=2]/hpoa:operationalStatus" />
                      <xsl:with-param name="isWizard" select="$isWizard" />
                      <xsl:with-param name="encNum" select="$encNum" />
                      <xsl:with-param name="uidState" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=2]/hpoa:uid" />
                      <xsl:with-param name="width" select="90" />
                      <xsl:with-param name="displayImage" select="$EM_PRESENT_IMAGE_C3000" />
                    </xsl:call-template>
                    
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>
                    <xsl:attribute name="background"><xsl:value-of select="$EM_RESERVED_IMAGE_C3000" /></xsl:attribute>
                    <img src="/120814-042457/images/icon_transparent.gif" border="0" height="1" width="90" alt="" />
                  </xsl:otherwise>              
                </xsl:choose>
              </xsl:element>
          </tr>			
         </table>
        </td>			
      </tr>
      <!-- OA Tray -->
      <tr>
        <td title="Onboard Administrator Tray" class="deviceCellUnselectable" style="line-height:6px;width:224px;height:6px;background-image:url('/120814-042457/images/oa_tray_c3000.gif');">
          <img src="/120814-042457/images/icon_transparent.gif" border="0" height="6" width="1" alt="" />
        </td>
      </tr>
      </xsl:if>
    </xsl:element>

  </xsl:template>

  <!--
    Bay table cell template.  Sets up the bay cell for the blade by setting
    the table cell attributes and adding the blade icons to the cell.
  -->
  <xsl:template name="serverBay">

    <xsl:param name="bayNumber" />
    <xsl:param name="isWizard" />
    <xsl:param name="presence" />

		<xsl:variable name="statusDoc" select="$bladeStatusDoc//hpoa:bladeStatus[hpoa:bayNumber=$bayNumber]" />
		<xsl:variable name="status" select="$statusDoc/hpoa:operationalStatus" />
		<xsl:variable name="uidState" select="$statusDoc/hpoa:uid" />
		<xsl:variable name="powered" select="$statusDoc/hpoa:powered" />
    <xsl:variable name="deviceDegraded" select="$statusDoc/hpoa:diagnosticChecks/hpoa:deviceDegraded" />
    <xsl:variable name="deviceFailure" select="$statusDoc/hpoa:diagnosticChecks/hpoa:deviceFailure" />
    <xsl:variable name="healthStatus">
      <xsl:choose>
        <xsl:when test="$deviceFailure='ERROR' and $deviceDegraded='NO_ERROR'">OP_STATUS_NON-RECOVERABLE_ERROR</xsl:when>
        <xsl:when test="$deviceFailure='NO_ERROR' and $deviceDegraded='ERROR'">OP_STATUS_DEGRADED</xsl:when>
        <xsl:when test="$deviceFailure='NO_ERROR' and $deviceDegraded='NO_ERROR'">OP_STATUS_OK</xsl:when>
        <xsl:otherwise>OP_STATUS_UNKNOWN</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
		<xsl:variable name="cellId"><xsl:value-of select="concat('enc', $encNum, 'bay', $bayNumber, 'Select')" /></xsl:variable>
		<xsl:variable name="bladeType" select="hpoa:bladeType" />
		<xsl:variable name="bladeName" select="hpoa:name"/>
		<xsl:variable name="height" select="hpoa:height" />
		<xsl:variable name="width" select="hpoa:width" />
		<xsl:variable name="physicalBayNumber" select="hpoa:extraData[@hpoa:name='NormalizedBayNumber']" />
		
		<xsl:variable name="top">

			<xsl:choose>
				<xsl:when test="$physicalBayNumber &lt;= $BLADES_PER_ROW">
					<xsl:choose>
						<!-- The only top coordinate that must be adjusted is double dense side A. -->
						<xsl:when test="hpoa:extraData[@hpoa:name='NormalizedSideNumber']=1">
							<xsl:value-of select="85-(28*(number($physicalBayNumber)-1))+$DD_BAY_WIDTH"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="85-(28*(number($physicalBayNumber)-1))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<!-- The only top coordinate that must be adjusted is double dense side A. -->
						<xsl:when test="hpoa:extraData[@hpoa:name='NormalizedSideNumber']=1">
							<xsl:value-of select="85-(28*(number($physicalBayNumber)-5))+$DD_BAY_WIDTH"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="85-(28*(number($physicalBayNumber)-5))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>


		</xsl:variable>

		<xsl:variable name="left">
			<xsl:choose>
				<!-- 78+2 (1px top border plus 1px middle border -->
				<xsl:when test="$physicalBayNumber &lt;= $BLADES_PER_ROW">1</xsl:when>
				<xsl:otherwise>93</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="bladeHeight">
			<xsl:choose>
				<xsl:when test="$height=2">
					<xsl:value-of select="$FULL_BAY_HEIGHT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$SINGLE_BAY_HEIGHT"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="bladeWidth">

			<xsl:choose>
				<xsl:when test="hpoa:extraData[@hpoa:name='NormalizedSideNumber']=0">
					<!-- Single Density Blades-->
					<xsl:choose>
						<xsl:when test="$width=2">
							<xsl:value-of select="$DOUBLE_BAY_WIDTH"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$SINGLE_BAY_WIDTH"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- Double Dense Blades -->
					<xsl:value-of select="$DD_BAY_WIDTH"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Position for the status icons. -->
		<xsl:variable name="position">
			<xsl:choose>
				<xsl:when test="$physicalBayNumber &gt; $BLADES_PER_ROW">RIGHT</xsl:when>
				<xsl:otherwise>LEFT</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="deviceImage">
			<xsl:choose>
				<xsl:when test="$height=1 or $height=0">
					<xsl:choose>
						<xsl:when test="hpoa:deviceId='82'">
							<xsl:choose>
								<xsl:when test="hpoa:productId='8213'">
									<xsl:value-of select="$BLADE_IO_AMC_IMAGE_90"/>
								</xsl:when>
								<xsl:when test="hpoa:productId='8211' and not(contains(hpoa:name, 'PCI'))">
									<xsl:value-of select="$BLADE_IO_XW_GRAPHICS_90"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_STORAGE_IO_EXPANSION_IMAGE_90" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$bladeType='BLADE_TYPE_STORAGE'">
							<xsl:choose>
								<xsl:when test="hpoa:productId='8218'">
                  <xsl:choose>
                    <xsl:when test="contains($bladeName, 'D2220sb') or contains($bladeName, 'G2')">
                      <xsl:value-of select='"/120814-042457/images/d2200sbG2_90.gif"'/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select='"/120814-042457/images/d2200sb_90.gif"'/>
                    </xsl:otherwise>
                  </xsl:choose>
								</xsl:when>
								<xsl:when test="hpoa:productId='8210'">
									<xsl:value-of select="$BLADE_STORAGE_TAPE_IMAGE_90" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_STORAGE_IMAGE_90" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$bladeType='BLADE_TYPE_SERVER'">

							<xsl:choose>
								<xsl:when test="number($bayNumber)&gt;16 and number($bayNumber)&lt;=32">
									<xsl:value-of select="$BLADE_HALF_IMAGE_2X220_SIDE_A_90" />
								</xsl:when>
								<xsl:when test="number($bayNumber)&gt;32 and number($bayNumber)&lt;=48">
									<xsl:value-of select="$BLADE_HALF_IMAGE_2X220_SIDE_B_90" />
								</xsl:when>
                <xsl:when test="contains($bladeName, 'Gen9')">
                  <xsl:choose>
                    <xsl:when test="contains($bladeName, 'BL460c') or contains($bladeName, 'WS460c')">
                      <xsl:value-of select="$BLADE_IMAGE_BL460C_G9_90"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$BLADE_UNKNOWN_IMAGE_90" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </xsl:when>
                <xsl:when test="contains($bladeName, 'Gen8') or contains($bladeName, 'StoreEasy 38') or contains($bladeName, 'FlexServer')">
                  <xsl:choose>
                    <xsl:when test="contains($bladeName, 'BL420c')">
                      <xsl:value-of select="$BLADE_IMAGE_BL420C_G8_90"/>
                    </xsl:when>
                    <xsl:when test="contains($bladeName, 'BL460c') or contains($bladeName, 'WS460c') or contains($bladeName, 'StoreEasy 38') or contains($bladeName, 'FlexServer B390')">
                      <xsl:value-of select="$BLADE_IMAGE_BL460C_G8_90"/>
                    </xsl:when>
                    <xsl:when test="contains($bladeName, 'BL465c')">
                      <xsl:value-of select="$BLADE_IMAGE_BL465C_G8_90"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$BLADE_UNKNOWN_IMAGE_90" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </xsl:when>
								<xsl:when test="contains($bladeName, 'BL260') or contains($bladeName, 'BL280')">
									<xsl:value-of select="$BLADE_IMAGE_BL260C_90"/>
								</xsl:when>
								<xsl:when test="contains($bladeName, 'BL495') or contains($bladeName, 'BL490')">
									<xsl:value-of select="$BLADE_IMAGE_BL495C_90"/>
								</xsl:when>
								<xsl:when test="contains($bladeName, 'BL460') and contains($bladeName, 'G6')">
									<xsl:value-of select="$BLADE_IMAGE_BL460CG6_90"/>
								</xsl:when>
								<xsl:when test="contains($bladeName, 'BL465') and contains($bladeName, 'G7')">
									<xsl:value-of select="$BLADE_IMAGE_BL465CG7_90"/>
								</xsl:when>
								<xsl:when test="$height=1">
									<xsl:value-of select="$BLADE_HALF_IMAGE_90" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_UNKNOWN_IMAGE_90" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$BLADE_UNKNOWN_IMAGE_90" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$height=2">
					<xsl:choose>
						<!-- BL485c 44477[5,6,7]-B21-->
						<xsl:when test="(contains($bladeName, '485')) or (substring(hpoa:partNumber,1,5)='44477' and substring-after(hpoa:partNumber,'-')='B21')">
							<!-- FC Passthru image here -->
							<xsl:value-of select="$BLADE_FULL_IMAGE_485_90" />
						</xsl:when>
						<!--	check for Integrity Blade  -->
						<xsl:when test="hpoa:deviceId='72' or hpoa:productId='4609'">
							<xsl:choose>
								<xsl:when test="contains($bladeName, '870')">
									<xsl:value-of select="$BLADE_FULL_IMAGE_870_90" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_FULL_IMAGE_IA64_90" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="hpoa:deviceId='51' and hpoa:productId='33282'">
							<xsl:value-of select='"/120814-042457/images/enclosure_blade_BL860c_g7_90.gif"' />
						</xsl:when>
            <xsl:when test="contains($bladeName, 'Gen9')">
              <xsl:choose>
                <xsl:when test="contains($bladeName, 'BL660c')">
                  <xsl:value-of select="$BLADE_IMAGE_BL660C_G9_90"/>
                </xsl:when>
              </xsl:choose>                  
            </xsl:when>
            <xsl:when test="contains($bladeName, 'Gen8') or contains($bladeName, 'FlexServer')">
              <xsl:choose>
                <xsl:when test="contains($bladeName, 'BL685c')">
                  <xsl:value-of select="$BLADE_IMAGE_BL685C_G8_90"/>
                </xsl:when>
                <xsl:when test="contains($bladeName, 'BL660c') or contains($bladeName, 'FlexServer B590')">
                  <xsl:value-of select="$BLADE_IMAGE_BL660C_G8_90"/>
                </xsl:when>
              </xsl:choose>                  
            </xsl:when>
						<xsl:when test="contains($bladeName, '480')">
							<xsl:value-of select="$BLADE_FULL_IMAGE_I_90" />
						</xsl:when>
						<xsl:when test="contains($bladeName, '680') and not(contains($bladeName, 'G7'))">
							<xsl:value-of select="$BLADE_FULL_IMAGE_I4_90" />
						</xsl:when>
						<xsl:when test="contains($bladeName, '680') and contains($bladeName, 'G7')">
							<xsl:value-of select='"/120814-042457/images/enclosure_blade_680c_g7_4_90.gif"'/>
						</xsl:when>
						<xsl:when test="contains($bladeName, '685') or contains($bladeName, '620')">
							<xsl:choose>
								<xsl:when test="contains($bladeName, 'G6') or contains($bladeName, 'G7')">
									<xsl:value-of select="$BLADE_FULL_IMAGE_A_G6_90" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_FULL_IMAGE_A_90" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$BLADE_UNKNOWN_IMAGE_90" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="div">

			<xsl:attribute name="style">
				z-index:99;
				position:absolute;
				top: <xsl:value-of select="$top" />px;
				left: <xsl:value-of select="$left" />px;
				width: <xsl:value-of select="$bladeHeight" />px;
				height: <xsl:value-of select="$bladeWidth" />px;
				background: url('<xsl:value-of select="$deviceImage"/>');
			</xsl:attribute>

			<xsl:attribute name="onclick">top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$bayNumber" />, 'bay', <xsl:value-of select="$encNum" />, true);</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$cellId"/></xsl:attribute>
			<xsl:attribute name="class">deviceCell</xsl:attribute>
      <xsl:attribute name="encNum"><xsl:value-of select="$encNum"/></xsl:attribute>
      <xsl:attribute name="bayNum"><xsl:value-of select="$bayNumber"/></xsl:attribute>

			<xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,220,'device');}catch(e){}</xsl:attribute>
			<xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
			<xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
			<xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>

			<xsl:call-template name="deviceBay">
				<xsl:with-param name="deviceImage" select="$deviceImage" />
				<xsl:with-param name="isWizard" select="$isWizard" />
				<xsl:with-param name="bayNumber" select="$bayNumber" />
				<xsl:with-param name="presence" select="$presence" />
				<xsl:with-param name="status" select="$status" />
        <xsl:with-param name="healthStatus" select="$healthStatus" />
				<xsl:with-param name="uidState" select="$uidState" />
				<xsl:with-param name="powerState" select="$powered" />
				<xsl:with-param name="position" select="$position" />
				<xsl:with-param name="bladeType" select="$bladeType" />
			</xsl:call-template>

		</xsl:element>
		
  </xsl:template>

	<xsl:template name="enclosureBackground">
		
		<!-- Bay table container background. -->
		<table style="background-color:#333; width:184px; height:112px;" border="0" cellspacing="0" cellpadding="0" align="center">

			<tr>
				<!-- bays 4,8 -->
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="4" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="8" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<!-- bays 3,7 -->
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="3" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="7" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<!-- bays 2,6 -->
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="2" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="6" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<!-- bays 1,5 -->
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="1" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:90px;height:26px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="5" />
					</xsl:call-template>
				</td>
			</tr>

		</table>
	</xsl:template>

	<xsl:template name="cellContent">
    <xsl:param name="bayNumber" />

    <xsl:variable name="hOffset">
      <xsl:choose>
        <xsl:when test="$bayNumber &lt;= $BLADES_PER_ROW">4px</xsl:when>
        <xsl:otherwise>76px</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="($bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber+16]/hpoa:height!=0 or $bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber+32]/hpoa:height!=0)">
        <xsl:choose>
          <xsl:when test="($currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='false')">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-left: {$hOffset}; margin-top: 7px;" />
          </xsl:when>
          <xsl:when test="($currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber]/hpoa:access='true' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='false')">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-left: {$hOffset}; margin-top: 7px;" />
          </xsl:when>
          <xsl:when test="$currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='true' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='false'">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-left: {$hOffset}; margin-top: 1px;" />
          </xsl:when>
          <xsl:when test="$currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='true'">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-left: {$hOffset}; margin-top: 12px;" />
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber]/hpoa:access='false'">
        <img src="/120814-042457/images/icon_lock_16.gif" style="margin-left: {$hOffset}; margin-top: 7px;" />
      </xsl:when>
      <xsl:otherwise>&#160;</xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
