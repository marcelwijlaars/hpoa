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

  <xsl:param name="powerSupplyStatusDoc" />
  <xsl:param name="powerSupplyInfoDoc" />
  <xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="currentUserInfo" />

  <xsl:param name="mpInfoDoc" select="string('')"  />

  <!--
    Variable indicating whether or not this enclosure transformation is
    part of a wizard or a status overview. If it is part of a wizard, the
    checkboxes will be shown. If not, they will be hidden.
  -->
  <xsl:param name="isWizard" select="'false'"/>

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  <xsl:include href="../Templates/deviceBay.xsl" />

	<xsl:variable name="BLADES_PER_ROW" select="8" />
	<xsl:variable name="SINGLE_BAY_WIDTH" select="27"></xsl:variable>
	<xsl:variable name="SINGLE_BAY_HEIGHT" select="77"></xsl:variable>
	<xsl:variable name="DOUBLE_BAY_WIDTH" select="54"></xsl:variable>
	<xsl:variable name="FULL_BAY_HEIGHT" select="156"></xsl:variable>
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
      <xsl:attribute name="width">225</xsl:attribute>      
      <xsl:attribute name="align">center</xsl:attribute>
      <xsl:if test="$isWizard!='true'">
        <xsl:attribute name="height">188</xsl:attribute>
      </xsl:if>
      <tr>
        <td width="225">
          <xsl:value-of select="$stringsDoc//value[@key='frontView']" />
        </td>
      </tr>
      <tr>
        <td width="225" height="158">

					<!-- this div provides an anchor point for the images below; do not remove -->
					<div style="position:relative; z-index:98;" id="{concat('frontViewInner', $encNum)}" isContainerDiv="true">

						<!-- Domain boards -->
						<xsl:if test="count($domainInfoDoc//hpoa:domainInfo/hpoa:domains/hpoa:domain[hpoa:size=1 or hpoa:size=2 or hpoa:size=4]) &gt; 0">
		      
				      <xsl:for-each select="$domainInfoDoc//hpoa:domainInfo/hpoa:domains/hpoa:domain[hpoa:size=1 or hpoa:size=2 or hpoa:size=4]">

					      <xsl:element name="div">

						      <xsl:variable name="x_pos" select="(number(hpoa:bays/hpoa:bay)-1)*28" />

						      <xsl:choose>
							      <xsl:when test="hpoa:size=4">
								      <xsl:attribute name="style">z-index:100; position:absolute; top:48px; left:<xsl:value-of select="$x_pos" />px; width:112px; height:52px; background:url('/120814-042457/images/domain_bar_4.gif');</xsl:attribute>
							      </xsl:when>
							      <xsl:when test="hpoa:size=2">
								      <xsl:attribute name="style">z-index:100; position:absolute; top:48px; left:<xsl:value-of select="$x_pos" />px; width:56px; height:52px; background:url('/120814-042457/images/domain_bar_2.gif');</xsl:attribute>
							      </xsl:when>
							      <xsl:when test="hpoa:size=1">
								      <xsl:attribute name="style">z-index:100; position:absolute; top:48px; left:<xsl:value-of select="$x_pos" />px; width:28px; height:52px; background:url('/120814-042457/images/domain_bar_1.gif');</xsl:attribute>
							      </xsl:when>
						      </xsl:choose>

						      <xsl:attribute name="id">
							      <xsl:value-of select="concat('enc', $encNum, 'monarch', hpoa:monarchBlade, 'Container')"/>
						      </xsl:attribute>

						      <table style="width:100%;" cellspacing="0" cellpadding="0" border="0">
							      <tr>
								      <td id="{concat('enc', $encNum, 'monarch', hpoa:monarchBlade, 'Select')}" devNum="{hpoa:monarchBlade}" style="height:52px;" encNum="{$encNum}" devType="monarch" class="deviceCell">
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

						<xsl:call-template name="enclosureBackground" />
						
					</div>
        </td>
      </tr>
      <!-- Only display the power supplies if we are not in the wizard -->
      <xsl:if test="$isWizard = 'false'">
        <tr>
          <td width="225" height="29">
            <!-- Front view power supply container -->
            <table align="center" width="225" height="29" style="border-left:1px solid #333;border-right:1px solid #333;border-top:0px;border-bottom:0px;" cellspacing="0" cellpadding="0">
              <tr>
                <!--
                  Loop through all of the value elements in the power supply status document
                  (one value element for each power supply).
                -->
                <xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo">

                  <!-- Get the power supply number for the current power supply. -->
                  <xsl:variable name="psNumber" select="hpoa:bayNumber" />
                  <xsl:variable name="psStatus" select="$powerSupplyStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$psNumber]/hpoa:operationalStatus"/>
                  <xsl:variable name="inputStatus" select="$powerSupplyStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$psNumber]/hpoa:inputStatus"/>

                  <!-- Retrieve the presence value -->
                  <xsl:variable name="presence" select="hpoa:presence" />

                  <!--
                    Draw a table cell container for each power supply.  NOTE: These table
                    cells will only line up with the above blade bays if there are six power
                    supplies. It is currently assumed that there are six power supplies.								
                  -->
                  <xsl:element name="td">

                    <!-- Set up the table cell's attributes -->
                    <xsl:attribute name="width">37</xsl:attribute>
                    <xsl:attribute name="height">29</xsl:attribute>
                    <xsl:attribute name="align">left</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>

                    <xsl:choose>
                      <xsl:when test="$presence=$PRESENT">
                        <xsl:attribute name="class">deviceCell</xsl:attribute>                       
                        
                        <xsl:attribute name="id">
                          <xsl:value-of select="concat('enc', $encNum, 'ps', $psNumber, 'Select')" />
                        </xsl:attribute>

                        <xsl:attribute name="devNum"><xsl:value-of select="$psNumber" /></xsl:attribute>
                        <xsl:attribute name="bayNum"><xsl:value-of select="$psNumber" /></xsl:attribute>
                        <xsl:attribute name="encNum"><xsl:value-of select="$encNum" /></xsl:attribute>
                        <xsl:attribute name="devType">ps</xsl:attribute>
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
                          <xsl:value-of select="$PS_PRESENT_IMAGE" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="'BlankPowerSupply'"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:choose>
                      <xsl:when test="$psImage != 'BlankPowerSupply'">
                        <xsl:attribute name="background"><xsl:value-of select="$psImage" /></xsl:attribute>

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
                            <xsl:with-param name="psInfoDoc" select="$powerSupplyInfoDoc" />
                            <xsl:with-param name="psStatusDoc" select="$powerSupplyStatusDoc" />                          
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
                          <xsl:value-of select="$psStatus" />
                        </xsl:when>
                        <xsl:when test="$presence=$LOCKED or $presence='PRESENCE_NO_OP'">
                          <xsl:value-of select="$LOCKED" />
                        </xsl:when>
                      </xsl:choose>
                    </xsl:variable>                    
                    
                    <xsl:choose>
                      <xsl:when test="$presence=$PRESENT or $psDisplayStatus=$LOCKED">                        
                        <xsl:element name="div">
                          
                          <xsl:attribute name="style">position:relative;width:35px;;height:27px;</xsl:attribute>

                          <xsl:variable name="psStatusVisibility">
                            <xsl:choose>
                              <xsl:when test="$psDisplayStatus=$OP_STATUS_OK">hidden</xsl:when>
                              <xsl:otherwise>visible</xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          
                          <!--Status Icon--> 
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
                        <img src="/120814-042457/images/icon_transparent.gif" border="0" height="1" width="35" alt="" />
                      </xsl:otherwise>
                    </xsl:choose>

                  </xsl:element>            

                </xsl:for-each>
              </tr>
            </table>
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
    <xsl:param name="presence" />
    <xsl:param name="isWizard" />
    
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
				<!-- 78+2 (1px top border plus 1px middle border -->
				<xsl:when test="$physicalBayNumber &gt; $BLADES_PER_ROW">
					<xsl:value-of select="number($SINGLE_BAY_HEIGHT+3)"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="left">
			<xsl:choose>
					<!-- The only left coordinate that must be adjusted is double dense side B. -->
					<xsl:when test="hpoa:extraData[@hpoa:name='NormalizedSideNumber']=2">
						<xsl:choose>
							<xsl:when test="$physicalBayNumber &gt; $BLADES_PER_ROW">
								<xsl:value-of select="((number($physicalBayNumber)-9)*28)+$DD_BAY_WIDTH+2"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="((number($physicalBayNumber)-1)*28)+$DD_BAY_WIDTH+2"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$physicalBayNumber &gt; $BLADES_PER_ROW">
								<xsl:value-of select="((number($physicalBayNumber)-9)*28)+1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<!-- Special case for double wide blades - the primary connector is physical bay+1 -->
									<xsl:when test="$width &gt;= 2">
										<xsl:value-of select="((number($physicalBayNumber)-2)*28)+1"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="((number($physicalBayNumber)-1)*28)+1"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
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
				<xsl:when test="$physicalBayNumber &gt; $BLADES_PER_ROW">BOTTOM</xsl:when>
				<xsl:otherwise>TOP</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="deviceImage">
			<xsl:choose>
				<xsl:when test="$height=1 or $height=0">
					<xsl:choose>
						<xsl:when test="hpoa:deviceId='82'">
							<xsl:choose>
								<xsl:when test="hpoa:productId='8213'">
									<xsl:value-of select="$BLADE_IO_AMC_IMAGE"/>
								</xsl:when>
								<xsl:when test="hpoa:productId='8211' and not(contains(hpoa:name, 'PCI'))">
									<xsl:value-of select="$BLADE_IO_XW_GRAPHICS"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_STORAGE_IO_EXPANSION_IMAGE" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$bladeType='BLADE_TYPE_STORAGE'">
							<xsl:choose>
								<xsl:when test="hpoa:productId='8218'">
                  <xsl:choose>
                    <xsl:when test="contains($bladeName, 'D2220sb') or contains($bladeName, 'G2')">
                      <xsl:value-of select='"/120814-042457/images/d2200sbG2.gif"'/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select='"/120814-042457/images/d2200sb.gif"'/>
                    </xsl:otherwise>
                  </xsl:choose>								
								</xsl:when>
								<xsl:when test="hpoa:productId='8210'">
									<xsl:value-of select="$BLADE_STORAGE_TAPE_IMAGE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_STORAGE_IMAGE" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$bladeType='BLADE_TYPE_SERVER'">
							<xsl:choose>
								<xsl:when test="number($bayNumber)&gt;16 and number($bayNumber)&lt;=32">
									<xsl:value-of select="$BLADE_HALF_IMAGE_2X220_SIDE_A" />
								</xsl:when>
								<xsl:when test="number($bayNumber)&gt;32 and number($bayNumber)&lt;=48">
									<xsl:value-of select="$BLADE_HALF_IMAGE_2X220_SIDE_B" />
								</xsl:when>
                <xsl:when test="contains($bladeName, 'Gen9')">
                  <xsl:choose>
                    <xsl:when test="contains($bladeName, 'BL460c') or contains($bladeName, 'WS460c')">
                      <xsl:value-of select="$BLADE_IMAGE_BL460C_G9"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$BLADE_UNKNOWN_IMAGE" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </xsl:when>
                <xsl:when test="contains($bladeName, 'Gen8') or contains($bladeName, 'StoreEasy 38') or contains($bladeName, 'FlexServer')">
                  <xsl:choose>
                    <xsl:when test="contains($bladeName, 'BL420c')">
                      <xsl:value-of select="$BLADE_IMAGE_BL420C_G8"/>
                    </xsl:when>
                    <xsl:when test="contains($bladeName, 'BL460c') or contains($bladeName, 'WS460c') or contains($bladeName, 'StoreEasy 38') or contains($bladeName, 'FlexServer B390')">
                      <xsl:value-of select="$BLADE_IMAGE_BL460C_G8"/>
                    </xsl:when>
                    <xsl:when test="contains($bladeName, 'BL465c')">
                      <xsl:value-of select="$BLADE_IMAGE_BL465C_G8"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$BLADE_UNKNOWN_IMAGE" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </xsl:when>
								<xsl:when test="contains($bladeName, 'BL260') or contains($bladeName, 'BL280')">
									<xsl:value-of select="$BLADE_IMAGE_BL260C"/>
								</xsl:when>
								<xsl:when test="contains($bladeName, 'BL495') or contains($bladeName, 'BL490')">
									<xsl:value-of select="$BLADE_IMAGE_BL495C"/>
								</xsl:when>
								<xsl:when test="contains($bladeName, 'BL460') and contains($bladeName, 'G6')">
									<xsl:value-of select="$BLADE_IMAGE_BL460CG6"/>
								</xsl:when>
								<xsl:when test="contains($bladeName, 'BL465') and contains($bladeName, 'G7')">
									<xsl:value-of select="$BLADE_IMAGE_BL465CG7"/>
								</xsl:when>
								<xsl:when test="$height=1">
									<xsl:value-of select="$BLADE_HALF_IMAGE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_UNKNOWN_IMAGE" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$BLADE_UNKNOWN_IMAGE" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$height=2">
					<xsl:choose>
						<!-- BL485c 44477[5,6,7]-B21-->
						<xsl:when test="(contains($bladeName, '485')) or (substring(hpoa:partNumber,1,5)='44477' and substring-after(hpoa:partNumber,'-')='B21')">
							<xsl:value-of select="$BLADE_FULL_IMAGE_485" />
						</xsl:when>
						<!--	check for Integrity Blade  -->
						<xsl:when test="hpoa:deviceId='72' or hpoa:productId='4609'">
							<xsl:choose>
								<xsl:when test="contains($bladeName, '870')">
									<xsl:value-of select="$BLADE_FULL_IMAGE_870" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_FULL_IMAGE_IA64" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="hpoa:deviceId='51' and hpoa:productId='33282'">
							<xsl:value-of select='"/120814-042457/images/enclosure_blade_BL860c_g7.gif"' />
						</xsl:when>
            <xsl:when test="contains($bladeName, 'Gen9')">
              <xsl:choose>
                <xsl:when test="contains($bladeName, 'BL660c')">
                  <xsl:value-of select="$BLADE_IMAGE_BL660C_G9"/>
                </xsl:when>
              </xsl:choose>                  
            </xsl:when>
            <xsl:when test="contains($bladeName, 'Gen8') or contains($bladeName, 'FlexServer')">
              <xsl:choose>
                <xsl:when test="contains($bladeName, 'BL685c')">
                  <xsl:value-of select="$BLADE_IMAGE_BL685C_G8"/>
                </xsl:when>
                <xsl:when test="contains($bladeName, 'BL660c') or contains($bladeName, 'FlexServer B590')">
                  <xsl:value-of select="$BLADE_IMAGE_BL660C_G8"/>
                </xsl:when>
              </xsl:choose>                  
            </xsl:when>
						<xsl:when test="contains($bladeName, '480')">
							<xsl:value-of select="$BLADE_FULL_IMAGE_I" />
						</xsl:when>
						<xsl:when test="contains($bladeName, '680') and not(contains($bladeName, 'G7'))">
							<xsl:value-of select="$BLADE_FULL_IMAGE_I4" />
						</xsl:when>
						<xsl:when test="contains($bladeName, '680') and contains($bladeName, 'G7')">
							<xsl:value-of select='"/120814-042457/images/enclosure_blade_680c_g7_4.gif"'/>
						</xsl:when>
						<xsl:when test="contains($bladeName, '685') or contains($bladeName, '620')">
							<xsl:choose>
								<xsl:when test="contains($bladeName, 'G6') or contains($bladeName, 'G7')">
									<xsl:value-of select="$BLADE_FULL_IMAGE_A_G6" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$BLADE_FULL_IMAGE_A" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$BLADE_UNKNOWN_IMAGE" />
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
				width: <xsl:value-of select="$bladeWidth" />px;
				height: <xsl:value-of select="$bladeHeight" />px;
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

		<table style="background-color:#333;" width="225" height="158" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<!-- bays 1-8 -->
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="1" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="2" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="3" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="4" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="5" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="6" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="7" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="8" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<!-- bays 9-16 -->
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="9" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="10" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="11" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="12" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="13" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="14" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="15" />
					</xsl:call-template>
				</td>
				<td class="deviceCellUnselectable" style="width:26px;height:77px;vertical-align:top;">
					<xsl:call-template name="cellContent">
						<xsl:with-param name="bayNumber" select="16" />
					</xsl:call-template>
				</td>
			</tr>
		</table>

	</xsl:template>

	<xsl:template name="cellContent">
		<xsl:param name="bayNumber" />
        
    <xsl:variable name="vOffset">
      <xsl:choose>
        <xsl:when test="$bayNumber &lt;= $BLADES_PER_ROW">2px</xsl:when>
        <xsl:otherwise>62px</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

		<xsl:choose>
      <xsl:when test="($bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber+16]/hpoa:height!=0 or $bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber+32]/hpoa:height!=0)">
        <xsl:choose>
          <xsl:when test="($currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='false')">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-top: {$vOffset}; margin-left: 8px;" />
          </xsl:when>					
          <xsl:when test="($currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber]/hpoa:access='true' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='false')">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-top: {$vOffset}; margin-left: 8px;" />
          </xsl:when>
          <xsl:when test="$currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='true' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='false'">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-top: {$vOffset}; margin-left: 15px;" />
          </xsl:when>
          <xsl:when test="$currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+16]/hpoa:access='false' and $currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber+32]/hpoa:access='true'">
            <img src="/120814-042457/images/icon_lock_16.gif" style="margin-top: {$vOffset}; margin-left: 2px; align: left" />
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$currentUserInfo//hpoa:bladeBays/hpoa:blade[hpoa:bayNumber=$bayNumber]/hpoa:access='false'">
        <img src="/120814-042457/images/icon_lock_16.gif" style="margin-top: {$vOffset}; margin-left: 8px;" />
      </xsl:when>
      <xsl:otherwise>&#160;</xsl:otherwise>
	  </xsl:choose>

	</xsl:template>

</xsl:stylesheet>
