<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />

  <xsl:param name="stringsDoc" />
  <xsl:param name="bladeBayNumber" />
  <xsl:param name="bladeInfoDoc" />
  <xsl:param name="bladeMezzInfoExDoc" />
  <xsl:param name="portMapInfoDoc" />
  <xsl:param name="interconnectTrayPortMapDoc" />
  <xsl:param name="interconnectTrayInfoDoc" />
  <xsl:param name="interconnectTrayStatusDoc" />
  <xsl:param name="enclosureType" />

  <xsl:variable name="PORTS_PER_ROW" select="8" />

  <xsl:template match="*">
    
    <div>
      <xsl:value-of select="$stringsDoc//value[@key='bayGraphicalPortDesc1']" /><br />
      <span class="whiteSpacer" >&#160;</span>
      <br />
      <xsl:value-of select="$stringsDoc//value[@key='bayGraphicalPortDesc2']" /><!-- When a mezzanine card is not present, individual ports can be selected to see the
      reserved mapping for that port. NOT POSSIBLE WHEN NO DEVICE IS PRESENT, RIGHT? -->
    </div>
    <span class="whiteSpacer" >&#160;</span>
    <div style="text-align:center;width:520px;">
      <table cellpadding="0" cellspacing="0" border="0" align="center">
        <tr>

          <xsl:for-each select="$portMapInfoDoc//hpoa:mezz[hpoa:mezzNumber=$MEZZ_NUMBER_FIXED and (hpoa:mezzSlots/hpoa:type='MEZZ_SLOT_TYPE_FIXED' and hpoa:mezzDevices/hpoa:type != 'MEZZ_DEV_TYPE_MT')]">
            <xsl:call-template name="checkboxMap" />
          </xsl:for-each>

          <xsl:for-each select="$portMapInfoDoc//hpoa:mezz[hpoa:mezzNumber!=$MEZZ_NUMBER_FIXED]">
            <xsl:call-template name="checkboxMap" />
          </xsl:for-each>

        </tr>
      </table>
      <br />
      <table style="margin-left:10px;"  border="0" cellpadding="0" cellspacing="0" class="fabricTable">
        <caption><xsl:value-of select="$stringsDoc//value[@key='interconnectBays']" /></caption>
        <tbody>
          <xsl:for-each select="$interconnectTrayStatusDoc//hpoa:interconnectTrayStatus">
            <xsl:variable name="currentBayNumber" select="number(hpoa:bayNumber)" />

            <xsl:if test="$currentBayNumber mod 2 != 0">
              <xsl:variable name="presence" select="hpoa:presence" />
              <xsl:variable name="nextPresence" select="../hpoa:interconnectTrayStatus[hpoa:bayNumber=$currentBayNumber+1]/hpoa:presence" />

              <xsl:variable name="ioWidth" select="number($interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:width)" />

              <xsl:element name="tr">

                <!-- Left label cells containing links to the interconnect bays. -->
                <td class="labelCellLeft" nowrap="true" style="padding-top:3px;width:50px;">
                  <xsl:variable name="bayNumbering" select="concat($stringsDoc//value[@key='bay'],' ', $currentBayNumber)" />
                  <xsl:variable name="linkLeftId" select="concat('ioDevice',$currentBayNumber)"/>
                  <xsl:variable name="interconnectNameLeft" select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:name"/>

                  <xsl:choose>
                    <xsl:when test="$presence=$PRESENT">
                      <xsl:element name="a">
                        <xsl:attribute name="id">
                          <xsl:value-of select="$linkLeftId" />
                        </xsl:attribute>
                        <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$currentBayNumber"/>);</xsl:attribute>
                        <xsl:attribute name="style">text-decoration:underline;</xsl:attribute>
                        <!-- tooltip events -->
                        <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,165);}catch(e){}</xsl:attribute>
                        <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
                        <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
                        <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>

                        <xsl:value-of select="$bayNumbering"/>
                        <br />
                        
                          <xsl:choose>
                            <xsl:when test="$enclosureType=1">

                              <!-- special interconnect icons for c3000 -->
                              <xsl:choose>
                                <xsl:when test="$currentBayNumber=1">
                                  <img src="/120814-042457/images/io_icon_20_1.gif" width="20" height="20" style="border:0px;" />
                                </xsl:when>
                                <xsl:when test="$currentBayNumber=3">
                                  <img src="/120814-042457/images/io_icon_20_3_round.gif" width="20" height="20" style="border:0px;" />
                                  <img src="/120814-042457/images/io_icon_20_3_diamond.gif" width="20" height="20" style="border:0px;" />
                                </xsl:when>
                              </xsl:choose>
                              
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:element name="img">
                                <xsl:attribute name="width">20</xsl:attribute>
                                <xsl:attribute name="height">20</xsl:attribute>
                                <xsl:attribute name="style">border:0px;</xsl:attribute>
                                <xsl:attribute name="src">
                                  <xsl:value-of select="concat('/120814-042457/images/io_icon_20_', $currentBayNumber, '.gif')"/>
                                </xsl:attribute>
                              </xsl:element>
                            </xsl:otherwise>
                          </xsl:choose>

                      </xsl:element>

                      <!-- tooltip element -->
                      <xsl:element name="div">
                        <xsl:attribute name="class">deviceInfo</xsl:attribute>
                        <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
                        <xsl:attribute name="id">
                          <xsl:value-of select="concat($linkLeftId,'InfoTip')"/>
                        </xsl:attribute>
                        <table  cellspacing="0" style="border:1px solid #333;width:100%;">
                          <tr>
                            <td style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
                              <xsl:value-of select="concat($stringsDoc//value[@key='interconnectBay'],' ', $currentBayNumber)"/>
                            </td>
                          </tr>
                          <tr>
                            <td  style="text-align:left;padding-left:4px;background:white;border:0px;">
                              <xsl:choose>
                                <xsl:when test="$interconnectNameLeft = ''">
                                  <span style="color:#666;"><xsl:value-of select="$stringsDoc//value[@key='unknownDevice']" /></span>
                                </xsl:when>
                                <xsl:otherwise>
                                  <b>
                                    <xsl:value-of select="$interconnectNameLeft" />
                                  </b>
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                          </tr>
                        </table>
                      </xsl:element>

                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$bayNumbering"/>
                      <br />
                      
                        <xsl:choose>
                          <xsl:when test="$enclosureType=1">

                            <!-- special interconnect icons for c3000 -->
                            <xsl:choose>
                              <xsl:when test="$currentBayNumber=1">
                                <img src="/120814-042457/images/io_icon_20_1.gif" width="20" height="20" style="border:0px;" />
                              </xsl:when>
                              <xsl:when test="$currentBayNumber=3">
                                <img src="/120814-042457/images/io_icon_20_3_round.gif" width="20" height="20" style="border:0px;" />
                                <img src="/120814-042457/images/io_icon_20_3_diamond.gif" width="20" height="20" style="border:0px;" />
                              </xsl:when>
                            </xsl:choose>

                          </xsl:when>
                          <xsl:otherwise>

                            <xsl:element name="img">
                              <xsl:attribute name="width">20</xsl:attribute>
                              <xsl:attribute name="height">20</xsl:attribute>
                              <xsl:attribute name="src">
                                <xsl:value-of select="concat('/120814-042457/images/io_icon_20_', $currentBayNumber, '.gif')"/>
                              </xsl:attribute>
                            </xsl:element>

                          </xsl:otherwise>
                        </xsl:choose>

                    </xsl:otherwise>
                  </xsl:choose>

                </td>

                <!-- Left side bay port map. -->
                <xsl:choose>
                  <xsl:when test="$presence=$PRESENT">
                    <xsl:choose>
                      <!-- Call the double wide template if the next bay is subsumed. -->
                      <xsl:when test="$ioWidth=2">
                        <xsl:call-template name="bayPortMapDouble">
                          <xsl:with-param name="bayNumber" select="$currentBayNumber" />
                        </xsl:call-template>
                      </xsl:when>
                      <!-- Otherwise call the single wide bay. -->
                      <xsl:otherwise>
                        <!-- Call the single bay template. -->
                        <xsl:call-template name="bayPortMapSingle">
                          <xsl:with-param name="bayNumber" select="$currentBayNumber" />
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="portDisplayCellEmpty">&#160;</td>
                  </xsl:otherwise>
                </xsl:choose>

                <!-- Right side bay information. -->
                <xsl:if test="$ioWidth!=2">
                  <xsl:choose>
                    <xsl:when test="$nextPresence=$PRESENT">
                      <!-- Call the single bay template. -->
                      <xsl:call-template name="bayPortMapSingle">
                        <xsl:with-param name="bayNumber" select="($currentBayNumber+1)" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <td class="portDisplayCellEmpty">&#160;</td>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>

                <!-- Right label cells containing links to the interconnect bays. -->
                <td class="labelCellRight" nowrap="true" style="padding-top:3px;width:50px;">
                  <xsl:variable name="rightBayNumbering" select="concat($stringsDoc//value[@key='bay'],' ', $currentBayNumber+1)" />
                  <xsl:variable name="linkRightId" select="concat('ioDevice',$currentBayNumber+1)"/>
                  <xsl:variable name="interconnectNameRight" select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber+1]/hpoa:name"/>
                  <!--<xsl:if test="$nextPresence!=$SUBSUMED">-->
                  <xsl:if test="1">
                    <xsl:choose>
                      <xsl:when test="$nextPresence=$PRESENT">
                        <xsl:element name="a">
                          <xsl:attribute name="id">
                            <xsl:value-of select="$linkRightId" />
                          </xsl:attribute>
                          <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$currentBayNumber+1"/>);</xsl:attribute>
                          <xsl:attribute name="style">text-decoration:underline;</xsl:attribute>
                          <!-- tooltip events -->
                          <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,185);}catch(e){}</xsl:attribute>
                          <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
                          <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
                          <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>

                          <xsl:value-of select="$rightBayNumbering"/>
                          <br />

                            <xsl:choose>
                              <xsl:when test="$enclosureType=1">
                                
                                <!-- special interconnect icons for c3000 -->
                                <xsl:choose>
                                  <xsl:when test="($currentBayNumber+1)=2">
                                    <img src="/120814-042457/images/io_icon_20_2_square.gif" width="20" height="20" style="border:0px;" />
                                  </xsl:when>
                                  <xsl:when test="($currentBayNumber+1)=4">
                                    <span>
                                      <img src="/120814-042457/images/io_icon_20_4_round.gif" width="20" height="20" style="border:0px;" />
                                      <img src="/120814-042457/images/io_icon_20_4_diamond.gif" width="20" height="20" style="border:0px;" />
                                    </span>
                                  </xsl:when>
                                </xsl:choose>

                              </xsl:when>
                              <xsl:otherwise>

                                <xsl:element name="img">
                                  <xsl:attribute name="width">20</xsl:attribute>
                                  <xsl:attribute name="height">20</xsl:attribute>
                                  <xsl:attribute name="style">border:0px;</xsl:attribute>
                                  <xsl:attribute name="src">
                                    <xsl:value-of select="concat('/120814-042457/images/io_icon_20_', $currentBayNumber+1, '.gif')"/>
                                  </xsl:attribute>
                                </xsl:element>

                              </xsl:otherwise>
                            </xsl:choose>

                        </xsl:element>

                        <!-- tooltip element -->
                        <xsl:element name="div">
                          <xsl:attribute name="class">deviceInfo</xsl:attribute>
                          <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
                          <xsl:attribute name="id">
                            <xsl:value-of select="concat($linkRightId,'InfoTip')"/>
                          </xsl:attribute>
                          <table cellspacing="0" style="border:1px solid #333;width:100%;">
                            <tr>
                              <td style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
                                <xsl:value-of select="concat($stringsDoc//value[@key='interconnectBay'],' ', $currentBayNumber+1)"/>
                              </td>
                            </tr>
                            <tr>
                              <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                                <xsl:choose>
                                  <xsl:when test="$interconnectNameRight = ''">
                                    <span style="color:#666;"><xsl:value-of select="$stringsDoc//value[@key='unknownDevice']" /></span>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <b>
                                      <xsl:value-of select="$interconnectNameRight" />
                                    </b>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
                            </tr>
                          </table>
                        </xsl:element>

                      </xsl:when>
                      <xsl:otherwise>
                        
                        <xsl:value-of select="$rightBayNumbering"/>
                        <br />
                        
                          <xsl:choose>
                            <xsl:when test="$enclosureType=1">

                              <!-- special interconnect icons for c3000 -->
                              <xsl:choose>
                                <xsl:when test="($currentBayNumber+1)=2">
                                  <img src="/120814-042457/images/io_icon_20_2_square.gif" width="20" height="20" style="border:0px;" />
                                </xsl:when>
                                <xsl:when test="($currentBayNumber+1)=4">
                                  <div>
                                    <img src="/120814-042457/images/io_icon_20_4_round.gif" width="20" height="20" style="border:0px;" />
                                    <img src="/120814-042457/images/io_icon_20_4_diamond.gif" width="20" height="20" style="border:0px;" />
                                  </div>
                                </xsl:when>
                              </xsl:choose>

                            </xsl:when>
                            <xsl:otherwise>

                              <xsl:element name="img">
                                <xsl:attribute name="width">20</xsl:attribute>
                                <xsl:attribute name="height">20</xsl:attribute>
                                <xsl:attribute name="src">
                                  <xsl:value-of select="concat('/120814-042457/images/io_icon_20_', $currentBayNumber+1, '.gif')"/>
                                </xsl:attribute>
                              </xsl:element>

                            </xsl:otherwise>
                          </xsl:choose>
                        
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </td>
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </tbody>
      </table>
    </div>

    <br />
    <span class="whiteSpacer" >&#160;</span>
    <hr />
    <span class="whiteSpacer" >&#160;</span>
    <a href="javascript:void(0);" onclick="openPortLegend();"><xsl:value-of select="$stringsDoc//value[@key='viewPortLegend']" /> ...</a>
    <br />
    <span class="whiteSpacer" >&#160;</span>
    <br />
  </xsl:template>

  <xsl:template name="checkboxMap">

    <xsl:variable name="mezzNumber" select="hpoa:mezzNumber" />

    <xsl:variable name="present">
      <xsl:choose>
        <xsl:when test="hpoa:mezzDevices/hpoa:type=$MEZZ_DEV_TYPE_MT and hpoa:mezzDevices/hpoa:name='N/A'">
          <xsl:value-of select="'na'" />
        </xsl:when>
        <xsl:when test="hpoa:mezzDevices/hpoa:type=$MEZZ_DEV_TYPE_MT and hpoa:mezzDevices/hpoa:name!='N/A'">
          <xsl:value-of select="'false'" />
        </xsl:when>
        <!--
			The mezz is present in this case, but I am adding this to disable
			the checkbox.  This case is an ISVB mezz card (no rear connectivity).
		  -->
        <xsl:when test="hpoa:mezzDevices/hpoa:name != '' and count(hpoa:mezzDevices/hpoa:port) = 0">
          <xsl:value-of select="'false'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'true'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	
    <xsl:variable name="deviceType">
      <xsl:choose>
        <xsl:when test="hpoa:mezzDevices/hpoa:type=$MEZZ_DEV_TYPE_MT">
              <xsl:choose>
				<!-- If FLB, convert mezzNumber to FLB value and add FLB notation -->
				<xsl:when test="$mezzNumber &gt; $FLB_START_IX">
					<xsl:variable name="FLBNumber" select="../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:extraData[@hpoa:name='aMezzNum']"/>				
					<xsl:value-of select="concat('FLB', ' ', $FLBNumber)"/>
				</xsl:when>
				<xsl:otherwise>									
          				<xsl:value-of select="concat($stringsDoc//value[@key='mezzSlot'],' ', $mezzNumber)"/>
				</xsl:otherwise>
              </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="hpoa:mezzDevices/hpoa:type='MEZZ_DEV_TYPE_FIXED'">
              <xsl:choose>
                <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_STORAGE'">
                  <xsl:value-of select="$stringsDoc//value[@key='fixedSAS']" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='embedded']" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
            
			<!-- Physical Mezz or FLB -->
			<xsl:choose>
				<!-- If FLB, convert mezzNumber to FLB value and add FLB notation -->
				<xsl:when test="$mezzNumber &gt; $FLB_START_IX">
					<xsl:variable name="FLBNumber" select="../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:extraData[@hpoa:name='aMezzNum']"/>
					<xsl:value-of select="concat('FLB', ' ', $FLBNumber)"/>
					</xsl:when>
				<xsl:otherwise>									
					<!-- Otherwise, display mezzNumber directly -->
					<xsl:value-of select="concat($stringsDoc//value[@key='mezzSlot'],' ', $mezzNumber)"/>
				</xsl:otherwise>
			</xsl:choose>
              
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="deviceTitle">
      <xsl:choose>
        <xsl:when test="$present='na'">
          <xsl:value-of select="$stringsDoc//value[@key='notAvailable']"/>
        </xsl:when>
	<xsl:when test="$present='false' and hpoa:mezzDevices/hpoa:name = ''">
          <xsl:value-of select="$stringsDoc//value[@key='noDevicePresent']"/>
        </xsl:when>
        <xsl:when test="hpoa:mezzDevices/hpoa:name=$FIXED_NIC_ID">
          <xsl:choose>
            <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_STORAGE'">
              <xsl:value-of select="$stringsDoc//value[@key='fixedSAS']" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$stringsDoc//value[@key='fixedNIC']" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="hpoa:mezzDevices/hpoa:name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <td valign="top" style="padding:6px;">

      <table cellpadding="0" cellspacing="0" border="0" width="100">
        <tr>
          <td nowrap="true">

            <table cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td valign="top">
                  <xsl:element name="input">
                    <xsl:attribute name="type">checkbox</xsl:attribute>
                    <xsl:attribute name="class">stdCheckBox</xsl:attribute>
                    <xsl:if test="hpoa:mezzDevices/hpoa:type != 'MEZZ_DEV_TYPE_MT' and count(hpoa:mezzDevices/hpoa:port)&gt;0">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$present='false' or $present='na'">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="mezzNumber">
                      <xsl:value-of select="$mezzNumber"/>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="concat('mezzSelect', $mezzNumber)"/>
                    </xsl:attribute>
                    <xsl:attribute name="onclick">javascript:togglePortAll(this, this.checked);</xsl:attribute>
                  </xsl:element>
                </td>
                <td style="padding-top:3px;" title="{$deviceTitle}">
                  <xsl:element name="label">
                    <xsl:attribute name="for">
                      <xsl:value-of select="concat('mezzSelect', $mezzNumber)"/>
                    </xsl:attribute>
                    <b>
                      <xsl:value-of select="$deviceType"/>
                    </b>
                    <xsl:if test="$present='false' or $present='na'">
                      <!--<xsl:attribute name="disabled">disabled</xsl:attribute>-->
                    </xsl:if>
                  </xsl:element>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

      <xsl:element name="div">
        <xsl:attribute name="style">padding-left:16px;padding-top:5px;</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('mezzContainer', $mezzNumber)"/>
        </xsl:attribute>

        <xsl:choose>
          <xsl:when test="hpoa:mezzDevices/hpoa:type!=$MEZZ_DEV_TYPE_MT">

            <xsl:choose>
              <xsl:when test="hpoa:mezzDevices/hpoa:name != '' and count(hpoa:mezzDevices//hpoa:port) = 0">
                <xsl:value-of select="$stringsDoc//value[@key='mezzDeviceNotIOConnect']" />
              </xsl:when>
              <xsl:otherwise>

				  <xsl:choose>
					  <xsl:when test="count(hpoa:mezzSlots/hpoa:slot) &gt; 0">

                <xsl:for-each select="hpoa:mezzSlots/hpoa:slot">

                  <xsl:variable name="slotNumber" select="hpoa:slotNumber" />
                  <xsl:variable name="portNumber" select="hpoa:interconnectTrayPortNumber" />
                  <xsl:variable name="swmBayNumber" select="hpoa:interconnectTrayBayNumber" />
                  <xsl:variable name="previousTrayType" select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=number($swmBayNumber)-1]/hpoa:interconnectTrayType"/>
                  <xsl:variable name="hasSlot" select="(count($interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$swmBayNumber]/hpoa:slot[hpoa:interconnectTraySlotNumber=$slotNumber]) &gt; 0)" />

                  <xsl:variable name="isIb" select="($slotNumber=2 and $interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$swmBayNumber]/hpoa:slot[hpoa:interconnectTraySlotNumber=$slotNumber]/hpoa:type='INTERCONNECT_TRAY_TYPE_IB')" />
                  <xsl:variable name="portPartnerActive" select="../../../hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber]/hpoa:extraData[@hpoa:name='portPartnerActive']='true'"/>

                  <xsl:if test="count(../../hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$slotNumber])&gt;0 and not($portPartnerActive)">
                    <xsl:if test="count(current()[hpoa:interconnectTrayBayNumber=0])=0">

                      <!--
										  If the previous bay type is infiniband we know we are in a subsumed slot.
										  An even numbered bay (bay 6 for example) will have a NO_CONNECTION type
										  if subsumed by a double-wide interconnect module in bay 5.
										-->
                      <xsl:if test="(not($previousTrayType='INTERCONNECT_TRAY_TYPE_IB') or $hasSlot) and not($isIb)">

                        <table cellpadding="0" cellspacing="0" border="0">
                          <tr>
                            <td nowrap="true">

                              <xsl:element name="input">
                                <xsl:attribute name="type">checkbox</xsl:attribute>
                                <xsl:attribute name="class">stdCheckBox</xsl:attribute>

                                <!-- added logic so checkboxes are only enabled when there is a corresponding 
														  interconnect device, and only checked if there is a corresponding linked port - mds -->
                                <xsl:choose>
                                  <xsl:when test="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$swmBayNumber]/hpoa:slot//hpoa:port[hpoa:interconnectTraySlotPortNumber=$portNumber]/hpoa:bladeBayNumber != 0">
                                    <xsl:if test="../../hpoa:mezzDevices/hpoa:type != 'MEZZ_DEV_TYPE_MT'">
                                      <xsl:attribute name="checked">true</xsl:attribute>
                                    </xsl:if>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:if test="not($hasSlot)">
                                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                                    </xsl:if>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:attribute name="bayId">
                                  <xsl:value-of select="hpoa:interconnectTrayBayNumber"/>
                                </xsl:attribute>
                                <xsl:attribute name="mezzNumber">
                                  <xsl:value-of select="$mezzNumber"/>
                                </xsl:attribute>
                                <xsl:attribute name="portId">
                                  <xsl:value-of select="hpoa:interconnectTrayPortNumber"/>
                                </xsl:attribute>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="concat('portSelect', hpoa:interconnectTrayBayNumber, hpoa:interconnectTrayPortNumber, position())"/>
                                </xsl:attribute>
                                <xsl:attribute name="onclick">javascript:togglePort(this, this.checked);</xsl:attribute>
                              </xsl:element>

                              <xsl:element name="label">
                                <xsl:attribute name="for">
                                  <xsl:value-of select="concat('portSelect', hpoa:interconnectTrayBayNumber, hpoa:interconnectTrayPortNumber, position())"/>
                                </xsl:attribute>
                                <xsl:choose>
                                  <xsl:when test="../hpoa:type='MEZZ_SLOT_TYPE_FIXED' and $bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_STORAGE'">
									  SAS: <xsl:value-of select="$slotNumber"/>&#160;
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="$stringsDoc//value[@key='port:']" />&#160;<xsl:value-of select="$slotNumber"/>&#160;
                                  </xsl:otherwise>
                                </xsl:choose>

                                <xsl:choose>
                                  <xsl:when test="$enclosureType=1">

                                    <xsl:choose>
                                      <xsl:when test="hpoa:interconnectTrayBayNumber=1">
                                        <img src="/120814-042457/images/io_icon_13_1.gif" width="13" height="13" />
                                      </xsl:when>
                                      <xsl:when test="hpoa:interconnectTrayBayNumber=2">
                                        <img src="/120814-042457/images/io_icon_13_2_square.gif" width="13" height="13" />
                                      </xsl:when>
                                      <xsl:when test="hpoa:interconnectTrayBayNumber=3">
                                        <img src="/120814-042457/images/io_icon_13_3_round.gif" width="13" height="13" />
                                        <img src="/120814-042457/images/io_icon_13_3_diamond.gif" width="13" height="13" />
                                      </xsl:when>
                                      <xsl:when test="hpoa:interconnectTrayBayNumber=4">
                                        <img src="/120814-042457/images/io_icon_13_4_round.gif" width="13" height="13" />
                                        <img src="/120814-042457/images/io_icon_13_4_diamond.gif" width="13" height="13" />
                                      </xsl:when>
                                    </xsl:choose>
                                    
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:element name="img">
                                      <xsl:attribute name="width">13</xsl:attribute>
                                      <xsl:attribute name="height">13</xsl:attribute>
                                      <xsl:attribute name="src">
                                        <xsl:value-of select="concat('/120814-042457/images/io_icon_13_', hpoa:interconnectTrayBayNumber, '.gif')"/>
                                      </xsl:attribute>
                                    </xsl:element>
                                  </xsl:otherwise>
                                </xsl:choose>
                                
                                <br />
                              </xsl:element>
                            </td>
                          </tr>
                        </table>

                      </xsl:if>

                    </xsl:if>
                  </xsl:if>
						  </xsl:for-each>
						  
					  </xsl:when>
					  <xsl:otherwise>
						  <xsl:value-of select="$stringsDoc//value[@key='noConnectSlot']" />
					  </xsl:otherwise>
				  </xsl:choose>
				
              </xsl:otherwise>
            </xsl:choose>

          </xsl:when>
          <xsl:when test="hpoa:mezzDevices/hpoa:type=$MEZZ_DEV_TYPE_MT and hpoa:mezzDevices/hpoa:name='N/A'">
            <xsl:value-of select="$stringsDoc//value[@key='notAvailable']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$stringsDoc//value[@key='noDevicePresent']" />
          </xsl:otherwise>
        </xsl:choose>

      </xsl:element>

    </td>

  </xsl:template>

  <xsl:template name="bayPortMapSingle">

    <xsl:param name="bayNumber" />

    <xsl:element name="td">

      <xsl:attribute name="class">portDisplayCell</xsl:attribute>
      <xsl:attribute name="align">center</xsl:attribute>

      <xsl:element name="table">
        <xsl:attribute name="cellpadding">0</xsl:attribute>
        <xsl:attribute name="cellspacing">0</xsl:attribute>
        <xsl:attribute name="style">border:0px;</xsl:attribute>
        <xsl:attribute name="align">center</xsl:attribute>

        <tbody>

          <!-- First row of ports. -->
          <tr>
            <xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$bayNumber]/hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[position() &lt;= $PORTS_PER_ROW]">
              <xsl:call-template name="portTableCell" />
            </xsl:for-each>
          </tr>

          <!-- Second row of ports. -->
          <tr>
            <xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$bayNumber]/hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[position() &gt; $PORTS_PER_ROW]">
              <xsl:call-template name="portTableCell" />
            </xsl:for-each>
          </tr>

        </tbody>

      </xsl:element>

    </xsl:element>

  </xsl:template>

  <xsl:template name="bayPortMapDouble">

    <xsl:param name="bayNumber" />

    <xsl:element name="td">

      <xsl:attribute name="colspan">2</xsl:attribute>
      <xsl:attribute name="class">portDisplayCell portDisplayCellWide</xsl:attribute>
      <xsl:attribute name="align">center</xsl:attribute>
      <xsl:attribute name="height">50</xsl:attribute>

      <xsl:element name="table">
        <xsl:attribute name="cellpadding">0</xsl:attribute>
        <xsl:attribute name="cellspacing">0</xsl:attribute>
        <xsl:attribute name="style">border:0px;width:320px;</xsl:attribute>
        <xsl:attribute name="align">center</xsl:attribute>

        <tbody>

          <!-- First row of ports. -->
          <tr>

            <xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap[hpoa:interconnectTrayBayNumber=$bayNumber]">

              <xsl:choose>
					  <!-- This is a special case for the KX4 10Gb pass-thru. The ports have a strange numbering scheme on the faceplate. -->
					  <xsl:when test="contains($interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:name, 'KX4') and $interconnectTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$bayNumber]/hpoa:interconnectTrayType=$INTERCONNECT_TRAY_TYPE_10GETH">
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=16]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=8]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=15]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=7]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=14]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=6]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=13]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=5]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=12]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=4]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=11]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=3]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=10]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=2]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=9]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
						  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=1]">
							  <xsl:call-template name="portTableCell" />
						  </xsl:for-each>
					  </xsl:when>
                <xsl:when test="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:type=$INTERCONNECT_TRAY_TYPE_SAS and hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_ENABLED'">
                  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port">
                    <xsl:sort select="hpoa:interconnectTraySlotPortNumber" data-type="number" order="descending"/>
                    <xsl:call-template name="portTableCell" />
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port">
                    <xsl:call-template name="portTableCell" />
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>

            </xsl:for-each>

          </tr>

        </tbody>

      </xsl:element>

    </xsl:element>

  </xsl:template>

  <!-- Cell template used to display individual switch ports. -->
  <xsl:template name="portTableCell">

    <xsl:element name="td">

      <xsl:variable name="portType">
        <xsl:choose>
          <xsl:when test="../../hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_DISABLED'">internal</xsl:when>
          <xsl:otherwise>external</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="class">
        <xsl:choose>
          <xsl:when test="number(hpoa:bladeBayNumber)=number($bladeBayNumber)">
            <xsl:choose>
              <xsl:when test="../../hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_DISABLED'">
                <xsl:choose>
                  <xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_OK">portNumberCell portLinkedInternal</xsl:when>
                  <xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">portNumberCell portMismatchInternal</xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_OK">portNumberCell portLinkedExternal</xsl:when>
                  <xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">portNumberCell portMismatchExternal</xsl:when>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="../../hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_DISABLED'">
                portNumberCell portCellInternal
              </xsl:when>
              <xsl:otherwise>
                portNumberCell portCellExternal
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="linked">
        <xsl:value-of select="not(contains($class,'portCellInternal') or contains($class,'portCellExternal'))" />
      </xsl:variable>



      <xsl:variable name="cellId">
        <xsl:value-of select="concat('bay', ../../hpoa:interconnectTrayBayNumber, 'port', hpoa:interconnectTraySlotPortNumber)"/>
      </xsl:variable>

      <xsl:variable name="mezzNumber" select="hpoa:bladeMezzNumber" />
      <xsl:variable name="mezzPortNumber" select="hpoa:bladeMezzPortNumber" />

      <xsl:variable name="tipWidth">
        <xsl:choose>
          <xsl:when test="$linked = 'true'">
            <xsl:choose>
              <xsl:when test="string-length($portMapInfoDoc//hpoa:bladePortMap/hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:name) &gt; 30">
                <xsl:value-of select="330"/>
              </xsl:when>
				      <xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port/hpoa:guid) &gt; 0">
					      <xsl:value-of select="330"/>
				      </xsl:when>
              <xsl:otherwise>270</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>130</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:attribute name="class">
        <xsl:value-of select="$class"/>
      </xsl:attribute>
      <xsl:attribute name="portType">
        <xsl:value-of select="$portType"/>
      </xsl:attribute>
      <xsl:attribute name="portStatus">
        <xsl:value-of select="hpoa:portStatus"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="$cellId"/>
      </xsl:attribute>

      <!-- tooltip events -->
      <xsl:attribute name="onmouseover">
        try{loadDeviceInfoTip(event,this,<xsl:value-of select="$tipWidth"/>);}catch(e){};if(!document.all){this.style.backgroundPosition='1 1';}var el=this.getElementsByTagName('div')[1];el.style.border='1px solid #99CCFF';el.style.width=(document.all?'18px':'16px');el.style.height=(document.all?'18px':'16px');el.style.padding='2px 0px 0px 2px';
      </xsl:attribute>
      <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
      <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
      <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){};if(!document.all){this.style.backgroundPosition='0 0';}var el=this.getElementsByTagName('div')[1];el.style.border='0px';el.style.width=(document.all?'18px':'17px');el.style.height=(document.all?'18px':'17px');el.style.padding='1px 0px 0px 1px';</xsl:attribute>

      <!-- tooltip element -->
      <xsl:element name="div">
        <xsl:attribute name="class">deviceInfo</xsl:attribute>
        <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat($cellId,'InfoTip')"/>
        </xsl:attribute>
        <table cellspacing="0" style="border:1px solid #333;width:100%;">
          <tr>
            <td style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;white-space:nowrap;">
              <b>
                <xsl:value-of select="concat($stringsDoc//value[@key='port:'],' ')"/>
              </b>
            </td>
            <td style="text-align:left;padding-left:2px;width:80%;background-color:#666;color:white;">
              <b>
                <xsl:value-of select="hpoa:interconnectTraySlotPortNumber"/>
              </b>
            </td>
          </tr>
          <tr>
            <td style="text-align:left;padding-left:2px;background:white;border:0px;white-space:nowrap;">
              <b>
                <xsl:value-of select="concat($stringsDoc//value[@key='type:'],' ')"/>
              </b>
            </td>
            <td style="text-align:left;padding-left:2px;background:white;border:0px;">
              <xsl:choose>
                <xsl:when test="$portType='internal'">
                  <xsl:value-of select="$stringsDoc//value[@key='internal']"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='external']"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr>
            <td style="text-align:left;padding-left:2px;background:white;border:0px;white-space:nowrap;">
              <b>
                <xsl:value-of select="concat($stringsDoc//value[@key='status:'],' ')"/>
              </b>
            </td>
            <td style="text-align:left;padding-left:2px;background:white;border:0px;">
              <xsl:variable name="symbolicBayNumber" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bladeBayNumber]/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
              <xsl:choose>
                <xsl:when test="contains($class,'portLinkedInternal') or contains($class,'portLinkedExternal')">
                  <xsl:value-of select="concat($stringsDoc//value[@key='linkedToServerBay'],' ',$symbolicBayNumber)" />
                </xsl:when>
                <xsl:when test="contains($class,'portMismatchInternal') or contains($class,'portMismatchExternal')">
                  <xsl:value-of select="concat($stringsDoc//value[@key='portMismatchToServerInBay'],' ',$symbolicBayNumber)" />
                </xsl:when>
                <xsl:when test="$linked = 'false'">
                  <xsl:value-of select="$stringsDoc//value[@key='notLinked']" />
                </xsl:when>
              </xsl:choose>
            </td>
          </tr>
          <xsl:if test="$linked = 'true'">
            <xsl:if test="$mezzNumber != $MEZZ_NUMBER_FIXED">
              <tr>
                <td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
                  <b>
                    <xsl:value-of select="concat($stringsDoc//value[@key='mezzSlot:'],' ')"/>
                  </b>
                </td>
                <td style="text-align:left;padding-left:2px;background:white;border:0px;">
                  <xsl:choose>
                    <xsl:when test="$mezzNumber &gt; $FLB_START_IX">
                      FLB <xsl:value-of select="($mezzNumber - $FLB_START_IX)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$mezzNumber" />
                    </xsl:otherwise>
                  </xsl:choose>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
								<b>
									<xsl:value-of select="concat($stringsDoc//value[@key='mezzDesc:'],' ')"/>
                </b>
              </td>
              <td style="text-align:left;padding-left:2px;background:white;border:0px;">
                <xsl:call-template name="getApprovedMezzName">
                  <xsl:with-param name="bladeType" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType" />
                  <xsl:with-param name="dataName" select="$portMapInfoDoc//hpoa:bladePortMap/hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:name" />
                </xsl:call-template>
              </td>
            </tr>
				<xsl:choose>
					<xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$mezzPortNumber]/hpoa:guid) &gt; 0">

						<xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$mezzPortNumber]/hpoa:guid">
							<tr>
								<td style="vertical-align:top;white-space:nowrap;text-align:right;padding-left:2px;background:white;border:0px;">
									<b>
                    <xsl:call-template name="getGuidLabel">
                      <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                      <xsl:with-param name="guidStruct" select="." />
                      <xsl:with-param name="mezzNumber" select="$mezzNumber" />
                    </xsl:call-template>										
									</b>
								</td>
								<td style="text-align:left;padding-left:2px;background:white;border:0px;">
									<xsl:value-of select="hpoa:guid"/>
								</td>
							</tr>
							
						</xsl:for-each>

					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
								<b>
									<xsl:value-of select="concat($stringsDoc//value[@key='deviceId:'],' ')"/>
								</b>
							</td>
							<td style="text-align:left;padding-left:2px;background:white;border:0px;">
								<xsl:value-of select="$portMapInfoDoc//hpoa:bladePortMap/hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$mezzPortNumber]/hpoa:wwpn"/>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>

            <xsl:if test="count($portMapInfoDoc//hpoa:bladePortMap/hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$mezzPortNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']) &gt; 0">
				<xsl:if test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port/hpoa:guid)=0">
              <tr>
                <td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
                  <b>
                    <xsl:value-of select="concat($stringsDoc//value[@key='iScsiDeviceId:'],' ')"/>
                  </b>
                </td>
                <td style="text-align:left;padding-left:2px;background:white;border:0px;">
                  <xsl:value-of select="$portMapInfoDoc//hpoa:bladePortMap/hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$mezzPortNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']"/>
                </td>
              </tr>
				</xsl:if>
            </xsl:if>

          </xsl:if>
        </table>
      </xsl:element>

      <!-- div size and location here are critical to cell sizing and mouseovers - don't move/change :mds -->
      <div style="width:17px;height:17px;padding:1px 0px 0px 1px;">
        <xsl:value-of select="hpoa:interconnectTraySlotPortNumber"/>
      </div>

    </xsl:element>

  </xsl:template>

</xsl:stylesheet>
