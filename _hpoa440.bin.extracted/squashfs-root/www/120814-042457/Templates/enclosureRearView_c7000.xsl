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

  <xsl:param name="oaStatusDoc" />
  <xsl:param name="oaInfoDoc" />
  <xsl:param name="oaNetworkInfoDoc" />

  <xsl:param name="fanInfoDoc" />

  <xsl:param name="netTrayInfoDoc" />
  <xsl:param name="netTrayStatusDoc" />

  <xsl:include href="../Templates/interconnectBay.xsl" />
  <xsl:include href="../Templates/emBay.xsl" />

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />

  <xsl:param name="encNum" />
  <xsl:param name="isWizard" select="'false'" />

  <xsl:variable name="FANS_PER_ROW" select="5" />

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
      <xsl:attribute name="align">center</xsl:attribute>
      <xsl:if test="$isWizard!='true'">
        <xsl:attribute name="height">187</xsl:attribute>
      </xsl:if>

      <tr>
        <td width="224">
          <xsl:value-of select="$stringsDoc//value[@key='rearView']" />
        </td>
      </tr>

      <!-- Top row of fans -->
      <tr>
        <td width="224" height="29">
          <!-- Table container for rear view top fans -->
          <table width="224" height="29" border="0" cellspacing="0" cellpadding="0">
            <!-- Top row of fans (1-5) -->
            <tr id="fanTopRow">

              <!--
                    Loop through all of the fan objects and render the top
                    row if the fan number is less than or equal to the number
                    of fans per row in the enclosure.
              -->
              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo[number(hpoa:bayNumber) &gt; 0 and number(hpoa:bayNumber) &lt;= $FANS_PER_ROW]">

                <xsl:call-template name="fanCell">
                  <xsl:with-param name="fanNumber" select="hpoa:bayNumber" />
                  <xsl:with-param name="encNum" select="$encNum" />
                  <xsl:with-param name="fanInfo" select="current()" />
                </xsl:call-template>

              </xsl:for-each>

            </tr>
          </table>
        </td>
      </tr>

      <!-- Interconnect bays -->
      <tr>
        <td width="224" height="80">
          <!-- Interconnect bay table container -->
          <table width="224" height="80" border="0" cellspacing="0" cellpadding="0">


            <xsl:for-each select="$netTrayStatusDoc//hpoa:interconnectTrayStatus">

              <xsl:variable name="bayNumber" select="hpoa:bayNumber" />

              <xsl:if test="number($bayNumber) mod 2 != 0">

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

              </xsl:if>


            </xsl:for-each>

          </table>
        </td>
      </tr>

      <!-- Onboard Administrators -->
      <tr>
        <td width="224" height="15">

          <table width="224" height="15" border="0" cellspacing="0" cellpadding="0">
            <tr>

              <xsl:element name="td">

                <xsl:attribute name="width">92</xsl:attribute>
                <xsl:attribute name="height">15</xsl:attribute>
                <xsl:attribute name="align">left</xsl:attribute>
                <xsl:attribute name="valign">top</xsl:attribute>
                <xsl:attribute name="style">line-height:15px;padding:0px;</xsl:attribute>

                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $encNum, 'em1Select')" />
                </xsl:attribute>

                <xsl:attribute name="devNum">1</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$encNum" />
                </xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="bayNum">1</xsl:attribute>

                <xsl:variable name="roleBay1" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=1]/hpoa:oaRole" />
                <xsl:variable name="BoardTypeBay1" select="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=1]/hpoa:extraData[@hpoa:name='BoardType']" />

                <xsl:variable name="displayImage1">
                  <xsl:choose>
                    <xsl:when test="$roleBay1 = $STANDBY and $BoardTypeBay1=2">
                      <xsl:value-of select="$EM_PRESENT_IMAGE_STANDBY_440" />
                    </xsl:when>
                    <xsl:when test="$roleBay1 = $STANDBY">
                      <xsl:value-of select="$EM_PRESENT_IMAGE_STANDBY" />
                    </xsl:when>
                    <xsl:when test="$roleBay1 = $ACTIVE and $BoardTypeBay1=2">
                      <xsl:value-of select="$EM_PRESENT_IMAGE_440" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$EM_PRESENT_IMAGE" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>

                <xsl:choose>
                  <xsl:when test="$roleBay1!=$OA_ABSENT and $roleBay1!=$ABSENT">
                    <xsl:attribute name="background">
                      <xsl:value-of select="$displayImage1"/>
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
                      <xsl:attribute name="encNum">
                        <xsl:value-of select="$encNum" />
                      </xsl:attribute>
                      <xsl:attribute name="bayNum">
                        <xsl:value-of select="'1'" />
                      </xsl:attribute>

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
                  <xsl:with-param name="displayImage" select="$displayImage1" />
                </xsl:call-template>

              </xsl:element>

              <!-- Link NICs -->
              <xsl:element name="td">

                <xsl:attribute name="width">38</xsl:attribute>
                <xsl:attribute name="height">15</xsl:attribute>
                <xsl:attribute name="align">left</xsl:attribute>
                <xsl:attribute name="valign">top</xsl:attribute>
                <xsl:attribute name="title">Enclosure Link NICs</xsl:attribute>
                <xsl:attribute name="style">line-height:15px;background-image:url(<xsl:value-of select="$LINKNIC_UID_OFF_IMAGE"/>);</xsl:attribute>

                <span style="position:relative;">

                  <!-- UID image -->
                  <xsl:call-template name="getUidImage">
                    <xsl:with-param name="imgId" select="concat('enc', $encNum, 'linkNic')" />
                    <xsl:with-param name="top" select="$graphicsMap//device[@image=$LINKNIC_UID_OFF_IMAGE]/coords/@uidTop" />
                    <xsl:with-param name="left" select="$graphicsMap//device[@image=$LINKNIC_UID_OFF_IMAGE]/coords/@uidLeft" />
                    <xsl:with-param name="uidState" select="$enclosureStatusDoc//hpoa:enclosureStatus/hpoa:uid" />
                  </xsl:call-template>

                </span>
              </xsl:element>

              <!-- Standby OA Module -->
              <xsl:element name="td">

                <xsl:attribute name="width">92</xsl:attribute>
                <xsl:attribute name="height">15</xsl:attribute>
                <xsl:attribute name="align">left</xsl:attribute>
                <xsl:attribute name="valign">top</xsl:attribute>
                <xsl:attribute name="style">line-height:15px;padding:0px;</xsl:attribute>

                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $encNum, 'em2Select')" />
                </xsl:attribute>

                <xsl:attribute name="devNum">2</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$encNum" />
                </xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="bayNum">2</xsl:attribute>

                <xsl:variable name="roleBay2" select="$oaStatusDoc//hpoa:oaStatus[hpoa:bayNumber=2]/hpoa:oaRole" />
                <xsl:variable name="BoardTypeBay2" select="$oaInfoDoc//hpoa:oaInfo[hpoa:bayNumber=2]/hpoa:extraData[@hpoa:name='BoardType']" />

                <xsl:variable name="displayImage2">
                  <xsl:choose>
                    <xsl:when test="$roleBay2 = $STANDBY and $BoardTypeBay2=2">
                      <xsl:value-of select="$EM_PRESENT_IMAGE_STANDBY_440" />
                    </xsl:when>
                    <xsl:when test="$roleBay2 = $STANDBY">
                      <xsl:value-of select="$EM_PRESENT_IMAGE_STANDBY" />
                    </xsl:when>
                    <xsl:when test="$roleBay2 = $ACTIVE and $BoardTypeBay2=2">
                      <xsl:value-of select="$EM_PRESENT_IMAGE_440" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$EM_PRESENT_IMAGE" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>

                <xsl:choose>
                  <xsl:when test="$roleBay2!=$OA_ABSENT">
                    <xsl:attribute name="background">
                      <xsl:value-of select="$displayImage2"/>
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
                      <xsl:attribute name="encNum">
                        <xsl:value-of select="$encNum" />
                      </xsl:attribute>
                      <xsl:attribute name="bayNum">
                        <xsl:value-of select="'2'" />
                      </xsl:attribute>

                      <xsl:call-template name="emBayTooltip">
                        <xsl:with-param name="encNum" select="$encNum" />
                        <xsl:with-param name="bayNum" select="'2'" />
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
                  <xsl:with-param name="displayImage" select="$displayImage2" />
                </xsl:call-template>

              </xsl:element>

            </tr>
          </table>

        </td>
      </tr>

      <!-- OA Tray -->
      <tr>
        <td title="Onboard Administrator Tray" class="deviceCellUnselectable" style="line-height:4px;width:224px;height:4px;background-image:url('/120814-042457/images/oa_tray.gif');">&#160;</td>
      </tr>

      <!-- Bottom row of fans -->
      <tr>
        <td width="224" height="29">
          <!-- Table container for rear view top fans -->
          <table width="224" height="29" border="0" cellspacing="0" cellpadding="0">
            <!-- Bottom row of fans (6-10) -->
            <tr id="fanBottomRow">

              <!--
                Loop through all of the fan objects and render the bottom
                row if the fan number is greater than the number of fans
                per row in the enclosure.
              -->
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
      </tr>

      <!-- Power Input Module -->
      <tr>
        <xsl:element name="td">

          <xsl:attribute name="height">25</xsl:attribute>

          <xsl:variable name="pduType" select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:pduPartNumber" />
          <xsl:attribute name="style">line-height:25px;</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="concat('enc', $encNum, 'pim1Select')" />
          </xsl:attribute>
          <xsl:attribute name="background">

            <xsl:choose>
              <xsl:when test="$pduType=$PDU_TYPE_1">
                <xsl:value-of select="$PS_REAR_IMAGE_1P" />
              </xsl:when>
              <xsl:when test="$pduType=$PDU_TYPE_2 or $pduType=$PDU_TYPE_3">
                <xsl:value-of select="$PS_REAR_IMAGE_3P" />
              </xsl:when>
              <xsl:when test="$pduType=$PDU_TYPE_4">
                <xsl:value-of select="$PS_REAR_IMAGE_DC" />
              </xsl:when>
              <xsl:when test="$pduType=$PDU_TYPE_5">
                <xsl:value-of select="$PS_REAR_IMAGE_IPD" />
              </xsl:when>
              <xsl:when test="$pduType=$PDU_TYPE_6">
                <xsl:value-of select="$PS_REAR_IMAGE_SAF-D_GRID" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$PS_REAR_IMAGE_1P" />
              </xsl:otherwise>
            </xsl:choose>
            
          </xsl:attribute>

			<xsl:variable name="pimTypeText" select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='pduProductName']" />

          <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,160);}catch(e){}</xsl:attribute>
          <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
          <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
          <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>

          <xsl:call-template name="pimTooltip">
            <xsl:with-param name="encNum" select="$encNum" />
            <xsl:with-param name="pimTypeText" select="$pimTypeText" />
          </xsl:call-template>
          
          <!--
          <xsl:attribute name="devNum">
            <xsl:value-of select="1" />
          </xsl:attribute>
          <xsl:attribute name="encNum">
            <xsl:value-of select="$encNum" />
          </xsl:attribute>
          <xsl:attribute name="devType">pim</xsl:attribute>

          <xsl:attribute name="class">deviceCell</xsl:attribute>
          -->
          <!-- Put a non-breaking space in the cell to ensure that it is drawn. -->
          &#160;
        </xsl:element>
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

        <xsl:attribute name="colspan">
          <xsl:value-of select="$colspan" />
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:value-of select="$cellWidth"/>
        </xsl:attribute>
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
        <xsl:attribute name="devNum">
          <xsl:value-of select="$trayNumber" />
        </xsl:attribute>
        <xsl:attribute name="encNum">
          <xsl:value-of select="$encNum" />
        </xsl:attribute>
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
                          <xsl:value-of select="$IO_IB4_IMAGE"/>
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
            <xsl:attribute name="background">
              <xsl:value-of select="$deviceImage" />
            </xsl:attribute>
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
          <xsl:when test="$presence=$PRESENT">

            <xsl:choose>
              <!-- Top row -->
              <xsl:when test="$fanNumber &lt;= $FANS_PER_ROW">
                <xsl:choose>
                  <!-- Value fan -->
                  <xsl:when test="$fan_part_number='507082-B21'">
                    <xsl:value-of select="$FAN_1_PRESENT_TOP_IMAGE" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$FAN_PRESENT_TOP_IMAGE" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- Bottom row -->
              <xsl:otherwise>
                <xsl:choose>
                  <!-- Value fan -->
                  <xsl:when test="$fan_part_number='507082-B21'">
                    <xsl:value-of select="$FAN_1_PRESENT_BOT_IMAGE" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$FAN_PRESENT_BOT_IMAGE" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>

            </xsl:choose>

          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$FAN_BLANK_IMAGE"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:attribute name="background">
        <xsl:value-of select="$fanImage"/>
      </xsl:attribute>
      <xsl:attribute name="height">29</xsl:attribute>
      <xsl:attribute name="width">43</xsl:attribute>
      <xsl:attribute name="align">left</xsl:attribute>
      <xsl:attribute name="valign">top</xsl:attribute>
      <!--
        TODO: This may always need to be selectable for fans in case
        an e-keying error has occurred and the user needs to know where
        to move fans.
      -->
      <xsl:variable name="myId">
        <xsl:value-of select="concat('enc', $encNum, 'fan', $fanNumber, 'Select')" />
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$presence=$PRESENT or $status!='OP_STATUS_UNKNOWN'">
          <xsl:attribute name="devNum">
            <xsl:value-of select="$fanNumber" />
          </xsl:attribute>
          <xsl:attribute name="bayNumber">
            <xsl:value-of select="$fanNumber"/>
          </xsl:attribute>
          <xsl:attribute name="encNum">
            <xsl:value-of select="$encNum" />
          </xsl:attribute>
          <xsl:attribute name="devType">fan</xsl:attribute>
          <xsl:attribute name="class">deviceCell</xsl:attribute>
          <xsl:attribute name="title" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">deviceCellUnselectable</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name="id">
        <xsl:value-of select="$myId" />
      </xsl:attribute>
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
        <xsl:attribute name="style">position:relative;width:40px;height:26px;</xsl:attribute>

        <xsl:variable name="fanStatusImgId" select="concat('enc', $encNum, 'fan', $fanNumber, 'Status')" />

        <xsl:variable name="fanStatus">
          <xsl:choose>
            <xsl:when test="$presence=$LOCKED or $presence='PRESENCE_NO_OP'">
              <xsl:value-of select="$LOCKED" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$status"/>
            </xsl:otherwise>
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

</xsl:stylesheet>

