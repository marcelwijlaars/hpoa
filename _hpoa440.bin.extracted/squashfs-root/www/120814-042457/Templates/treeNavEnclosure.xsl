<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  
  <xsl:output method="html" />

  <xsl:param name="stringsDoc" />

  <xsl:param name="oaStatusDoc" />
  <xsl:param name="oaInfoDoc" />
  <xsl:param name="activefwVersion" />
  
  <!-- Document fragment containing fan information. -->
  <xsl:param name="fanInfoDoc" />
  <xsl:param name="thermalSubsystemInfoDoc" />

  <!-- Document fragments containing network tray (interconnect bay) information and status. -->
  <xsl:param name="netTrayInfoDoc" />
  <xsl:param name="netTrayStatusDoc" />

  <!-- Document fragement paramaters containing blade status and information -->
  <xsl:param name="bladeInfoDoc" />
  <xsl:param name="bladeStatusDoc" />
  <xsl:param name="domainInfoDoc" />

  <!-- Document fragment parameters containing power supply status and information -->
  <xsl:param name="powerSupplyStatusDoc" />
  <xsl:param name="powerSupplyInfoDoc" />
  <xsl:param name="powerSubsystemInfoDoc" />

  <xsl:param name="enclosureInfoDoc" />
  <xsl:param name="enclosureStatusDoc" />
  
  <xsl:param name="ersConfigInfoDoc" />
  
  <xsl:param name="userInfoDoc" />
  <xsl:param name="groupInfoDoc" />

  <xsl:param name="enclosureNumber" />
  <xsl:param name="isAuthenticated" />
  <xsl:param name="isLoaded" />

  <!-- Current service username and Access Control Level. -->
  <xsl:param name="serviceUsername" />
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="serviceUserOaAccess" />
  <xsl:param name="serviceUserType" />
  <xsl:param name="isLocal" />
  <xsl:param name="proxyUrl" />

  <xsl:param name="vcmInfoDoc" />
  <xsl:param name="activeOaNetworkInfo" />
  <xsl:param name="firmwareMgmtSupported" select="'false'" />
  <xsl:param name="ersLocked" select="'true'" />
  
  <!--
    Include the gui and enclosure connstants files.
    NOTE: The enclosure constants file is dependant on the $enclosureInfoDoc variable.
   -->
  <xsl:include href="../Templates/guiConstants.xsl" />

  <!-- Include the global templates file -->
  <xsl:include href="../Templates/globalTemplates.xsl" />
  <xsl:include href="../Templates/escape-uri.xsl" />

  <!--
        Variables used to hold terms that are used multiple times
        in the tree.  Terms for devices such as power supplies can
        be reused from these variables instead of having to do a key
        lookup every time from the strings document.
    -->
  <xsl:variable name="powerSupplyText" select="$stringsDoc//value[@key='powerSupply']" />
  <xsl:variable name="fanText" select="$stringsDoc//value[@key='fan']" />
  <xsl:variable name="interconnectText" select="$stringsDoc//value[@key='interconnectBay']" />
  <xsl:variable name="bayText" select="$stringsDoc//value[@key='bay']" />

  <!-- Leaf templates for users, blades, and other devices. -->
  <xsl:include href="../Templates/treeNavEnclosureLeaf.xsl" />
  <xsl:include href="../Templates/treeUserLeaf.xsl" />
  <xsl:include href="../Templates/treeGroupLeaf.xsl" />
  <xsl:include href="../Templates/treeBladeLeaf.xsl" />
  <xsl:include href="../Templates/treeInterconnectLeaf.xsl" />
  <xsl:include href="../Templates/treeRemoteSupportLeaf.xsl" />

  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="$isAuthenticated='true' and $isLoaded='true'">
        <xsl:call-template name="treeNavEnclosure" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="enclosureNotAuthorized" />    
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
    Enclosure tree navigation template. Contains tree and nodes for one enclosure's
    devices and users.		
  -->
  <xsl:template name="treeNavEnclosure">

    <xsl:variable name="bayNum">
      <xsl:value-of select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole='ACTIVE']/hpoa:bayNumber"/>
    </xsl:variable>
    
    <div class="treeControl">
      <div class="treeDisclosure"></div>
    </div>

    <!-- Tree title main Enclosure -->
    <xsl:element name="div">

      <xsl:attribute name="class">treeTitle</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="concat('enc', $enclosureNumber, 'enc', 0, 'Select')" />
      </xsl:attribute>

      <xsl:element name="a">
        
        <xsl:attribute name="devId">
          <xsl:value-of select="concat('enc', $enclosureNumber, 'enc', 0, 'Select')" />
        </xsl:attribute>
        <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
        <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
        <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

        <xsl:attribute name="devNum">0</xsl:attribute>
        <xsl:attribute name="devType">enc</xsl:attribute>
        <xsl:attribute name="encNum"><xsl:value-of select="$enclosureNumber" /></xsl:attribute>

        <xsl:value-of select="$stringsDoc//value[@key='mnuEncInfo']" />

      </xsl:element>

    </xsl:element>
    
    <xsl:variable name="activeEMId" select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$ACTIVE]/hpoa:bayNumber" />
    <xsl:variable name="emSelectId" select="concat('enc', $enclosureNumber, 'em', $activeEMId, 'Select')" />

    <!-- Tree contents including bays, enclosure managers, power supplies, fans, and users -->
    <div class="treeContents">

    <xsl:choose>
      <xsl:when test="$serviceUserOaAccess='true'">
        <xsl:element name="div">

          <xsl:attribute name="class">treeClosed</xsl:attribute>

          <div class="treeControl">
          <div class="treeDisclosure"></div>
          </div>

          <xsl:element name="div">

          <xsl:attribute name="class">treeTitle</xsl:attribute>
          <xsl:attribute name="id">enc1Settings</xsl:attribute>

          <xsl:value-of select="$stringsDoc//value[@key='enclosureSettings']" />

          </xsl:element>

          <div class="treeContents">

          <div class="leafWrapper">
            <div class="treeStatusIcon" />
            <xsl:element name="div">

            <xsl:attribute name="class">leaf</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'AlertMailSelect')" />
            </xsl:attribute>

            <xsl:element name="a">
                      
              <xsl:attribute name="devId">
              </xsl:attribute>
              <xsl:attribute name="href">../html/alertmail.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
              <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
              <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

              <!-- 
              The devNum attribute doesn't mean anything here. It is used
              in hiddenFrame to set the title appropriately when we are in
              the enclosure settings node.
              -->
              <xsl:attribute name="devNum">
              <xsl:value-of select="2" />
              </xsl:attribute>
              <xsl:attribute name="devType">enc</xsl:attribute>
              <xsl:attribute name="encNum">
              <xsl:value-of select="$enclosureNumber" />
              </xsl:attribute>

              <xsl:value-of select="$stringsDoc//value[@key='alertMail']" />

            </xsl:element>
            </xsl:element>
          </div>

            <div class="leafWrapper">
              <div class="treeStatusIcon" />
              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'PowerDelaySelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="devId">
                  </xsl:attribute>
                  <xsl:attribute name="href">../html/powerDelay.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <!-- 
                  The devNum attribute doesn't mean anything here. It is used
                  in hiddenFrame to set the title appropriately when we are in
                  the enclosure settings node.
                  -->
                  <xsl:attribute name="devNum">
                    <xsl:value-of select="2" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">enc</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='devicePowerSeq']" />

                </xsl:element>
              </xsl:element>
            </div>

            <div class="leafWrapper">
              <div class="treeStatusIcon" />
              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'DateTimeSelect')" />
                </xsl:attribute>

                <xsl:element name="a">
                  <xsl:attribute name="href">../html/datetime.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="3" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">enc</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='dateTime']" />

                </xsl:element>
              </xsl:element>
            </div>
            <div class="leafWrapper">
              <div class="treeStatusIcon" />
              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'enc_network', '20', 'Select')" /></xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="devId"><xsl:value-of select="concat('enc', $enclosureNumber, 'enc_network', '0', 'Select')" /></xsl:attribute>
                  <xsl:attribute name="href">../html/enclosureNetSettings.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="20" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">enc_network</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='enclosure']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='ipSettings']" />

                </xsl:element>
              </xsl:element>
            </div>
            <xsl:if test="($serviceUserAcl=$ADMINISTRATOR or $serviceUserAcl=$OPERATOR) and $serviceUserOaAccess='true'">
              <div class="leafWrapper">
                <div class="treeStatusIcon" />
                <xsl:element name="div">

                  <xsl:attribute name="class">leaf</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('enc', $enclosureNumber, 'net_access', '4', 'Select')" />
                  </xsl:attribute>

                  <xsl:element name="a">

                    <xsl:attribute name="href">../html/networkAccess.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                    <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                    <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                    <xsl:attribute name="devNum">
                      <xsl:value-of select="4" />
                    </xsl:attribute>
                    <xsl:attribute name="devType">net_access</xsl:attribute>
                    <xsl:attribute name="encNum">
                      <xsl:value-of select="$enclosureNumber" />
                    </xsl:attribute>

                    <xsl:value-of select="$stringsDoc//value[@key='networkAccess']" />

                  </xsl:element>
                </xsl:element>
              </div>
            </xsl:if>

            <div class="leafWrapper">
              <div class="treeStatusIcon" />
              <xsl:element name="div">
                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'llfSelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="href">../html/linkfailover.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="5" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">enc</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='llf']" />

                </xsl:element>
              </xsl:element>
            </div>
            
            <div class="leafWrapper">
              <div class="treeStatusIcon" />
              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'SNMPSelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="href">../html/snmp.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="6" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">enc</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='snmpSettings']" />

                </xsl:element>
              </xsl:element>
            </div>

            <!-- Enclosure Bay IP Addressing -->
            <xsl:element name="div">
              <xsl:attribute name="class">treeClosed</xsl:attribute>
              <div class="treeControl">
                <div class="treeDisclosure"></div>
              </div>
            
              <xsl:element name="div">
                <xsl:attribute name="class">treeTitle</xsl:attribute>
                <xsl:attribute name="id">ebipaSettings</xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='ebipaLong']" />
              </xsl:element>
            
              <div class="treeContents">
                <!-- for IPv4 -->
                <div class="leafWrapper">
                  <div class="treeStatusIcon" />
                  <xsl:element name="div">
                    <xsl:attribute name="class">leaf</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="concat('enc', $enclosureNumber, 'ebipaSelect')" />
                    </xsl:attribute>

                    <xsl:element name="a">
                      <xsl:attribute name="href">../html/ebipa.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                      <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                      <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                      <xsl:attribute name="devNum">
                        <xsl:value-of select="2" />
                      </xsl:attribute>
                      <xsl:attribute name="devType">enc</xsl:attribute>
                      <xsl:attribute name="encNum">
                        <xsl:value-of select="$enclosureNumber" />
                      </xsl:attribute>

                      <xsl:value-of select="$stringsDoc//value[@key='forIPv4']" />
                    </xsl:element>
                  </xsl:element>
                </div>
                
                <xsl:if test="number($activefwVersion) &gt;= number('3.80')">
                  <!-- for IPv6 -->
                  <div class="leafWrapper">
                    <div class="treeStatusIcon" />
                    <xsl:element name="div">
                      <xsl:attribute name="class">leaf</xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('enc', $enclosureNumber, 'ebipav6Select')" />
                      </xsl:attribute>

                      <xsl:element name="a">
                        <xsl:attribute name="href">../html/ebipav6.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                        <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                        <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                        <xsl:attribute name="devNum">
                          <xsl:value-of select="21" />
                        </xsl:attribute>
                        <xsl:attribute name="devType">enc</xsl:attribute>
                        <xsl:attribute name="encNum">
                          <xsl:value-of select="$enclosureNumber" />
                        </xsl:attribute>
            
                        <xsl:value-of select="$stringsDoc//value[@key='forIPv6']" />
                      </xsl:element>
                    </xsl:element>
                  </div>
                </xsl:if>

              </div>
            </xsl:element>

          <xsl:if test="$serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true'">
            <div class="leafWrapper">
              <div class="treeStatusIcon" />
              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'config_script', $activeEMId, 'Select')" />
                </xsl:attribute>

                <xsl:element name="a">

                <xsl:attribute name="href">../html/configScript.html?encNum=<xsl:value-of select="$enclosureNumber" />&amp;emNum=<xsl:value-of select="$bayNum" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="$activeEMId" />
                </xsl:attribute>
                <xsl:attribute name="devType">config_script</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='configurationScripts']" />
                          
                </xsl:element>
              </xsl:element>
            </div>
          </xsl:if>

          <!--
            Only the built-in Administrator account can perform this action
            because all other user accounts will be removed from the oa.
          -->
          <xsl:if test="$serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true'">

            <div class="leafWrapper">
              <div class="treeStatusIcon" />
              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'defaultsSelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                <xsl:attribute name="href">../html/enclosureFactoryDefaults.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="9" />
                </xsl:attribute>
                <xsl:attribute name="devType">enc</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>
                          
                <xsl:value-of select="$stringsDoc//value[@key='resetFactoryDefaults']" />

                </xsl:element>
              </xsl:element>
            </div>

          </xsl:if>
                
          <div class="leafWrapper">
            <div class="treeStatusIcon" />
            <xsl:element name="div">

            <xsl:attribute name="class">leaf</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'fruSummarySelect')" />
            </xsl:attribute>

            <xsl:element name="a">

              <xsl:attribute name="href">../html/fruSummary.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
              <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
              <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

              <xsl:attribute name="devNum"><xsl:value-of select="10" /></xsl:attribute>
              <xsl:attribute name="devType">enc</xsl:attribute>
              <xsl:attribute name="encNum"><xsl:value-of select="$enclosureNumber" /></xsl:attribute>

              <xsl:value-of select="$stringsDoc//value[@key='fruSummary']" />

            </xsl:element>
            </xsl:element>
          </div>
              
          <xsl:if test="$serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true'">

            <xsl:element name="div">
              <xsl:attribute name="class">leafWrapper</xsl:attribute>              

              <xsl:if test="count($oaStatusDoc//hpoa:oaStatus[hpoa:oaRole = 'STANDBY'])=0">
                <xsl:attribute name="style">display:none;</xsl:attribute>
              </xsl:if>

              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'FailoverLeaf')"/>
              </xsl:attribute>
                
              <div class="treeStatusIcon" />
                      
              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'FailoverLink')" /></xsl:attribute>

                <xsl:element name="a">

                <xsl:attribute name="href"><xsl:value-of select="concat('../html/forceFailover.html?encNum=', $enclosureNumber, '&amp;mode=active')" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="11" />
                </xsl:attribute>
                <xsl:attribute name="devType">enc</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='activeToStandby']" />
                          
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:if>

            <div class="leafWrapper">
              <div class="treeStatusIcon" />

              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'dvd12Select')" />
                </xsl:attribute>

                <xsl:element name="a">

                <xsl:attribute name="href">../html/dvdSharing.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="12" />
                </xsl:attribute>
                <xsl:attribute name="devType">dvd</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='dvdDrive']" />

                </xsl:element>
              </xsl:element>
            </div>
            
            <!--VLAN leaf - begin -->
            <xsl:if test="number($activefwVersion) &gt;= number('3.00')">
                <div class="leafWrapper">
                  <div class="treeStatusIcon" />
                  <xsl:element name="div">

                    <xsl:attribute name="class">leaf</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="concat('enc', $enclosureNumber, 'vlanSelect')" />
                    </xsl:attribute>

                    <xsl:element name="a">

                      <xsl:attribute name="href">../html/vlan.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                      <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                      <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                      <xsl:attribute name="devNum">
                        <xsl:value-of select="13" />
                      </xsl:attribute>
                      <xsl:attribute name="devType">enc</xsl:attribute>
                      <xsl:attribute name="encNum">
                        <xsl:value-of select="$enclosureNumber" />
                      </xsl:attribute>

                      <xsl:value-of select="$stringsDoc//value[@key='vlanLong']" />

                    </xsl:element>
                  </xsl:element>
                </div>
            </xsl:if>

            <!-- Firmware Management Link -->
            <xsl:if test="$serviceUserAcl=$ADMINISTRATOR">
                <xsl:if test="number($activefwVersion) &gt;= number('3.35') and $firmwareMgmtSupported = 'true'">
                 <div class="leafWrapper">
                 <div class="treeStatusIcon" />
                 <xsl:element name="div">

                  <xsl:attribute name="class">leaf</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('enc', $enclosureNumber, 'fwMgmtSelect')" />
                  </xsl:attribute>

                  <xsl:element name="a">

                    <xsl:attribute name="href">../html/encFirmwareManagement.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                    <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                    <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                    <xsl:attribute name="devNum">
                      <xsl:value-of select="14" />
                    </xsl:attribute>
                    <xsl:attribute name="devType">enc</xsl:attribute>
                    <xsl:attribute name="encNum">
                      <xsl:value-of select="$enclosureNumber" />
                    </xsl:attribute>

                    <xsl:value-of select="$stringsDoc//value[@key='firmwareManagement']" />

                  </xsl:element>
                </xsl:element>
              </div>
              </xsl:if>
            </xsl:if>
            
            <!--
              Support added in version 3.50					    
            -->
            <xsl:if test="$serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true'">
              <xsl:if test="number($activefwVersion) &gt;= number('3.50')">
                <div class="leafWrapper">
                  <div class="treeStatusIcon" />
                  <xsl:element name="div">
                    <xsl:attribute name="class">leaf</xsl:attribute>
                    <xsl:attribute name="id">
                    <xsl:value-of select="concat('enc', $enclosureNumber, 'activeHealthSystemSelect')" />
                    </xsl:attribute>
                    <xsl:element name="a">
                    <xsl:attribute name="href">../html/activeHealthSystem.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                    <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                    <xsl:attribute name="class">treeSelectableLink</xsl:attribute>
                    <xsl:attribute name="devNum">
                      <xsl:value-of select="15" />
                    </xsl:attribute>
                    <xsl:attribute name="devType">enc</xsl:attribute>
                    <xsl:attribute name="encNum">
                      <xsl:value-of select="$enclosureNumber" />
                    </xsl:attribute>    		                    
                    <xsl:value-of select="$stringsDoc//value[@key='ActiveHealthSystem']" />
                    </xsl:element>
                  </xsl:element>
                </div>
              </xsl:if>
            </xsl:if>         
            
            <!--
              Remote Support: added in version 3.50					    
            -->
            <xsl:if test="$ersLocked != 'true' and $serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true'">
              <xsl:if test="number($activefwVersion) &gt;= number('3.50')">
                <xsl:call-template name="treeRemoteSupportLeaf">
                  <xsl:with-param name="ersConfigInfoDoc" select="$ersConfigInfoDoc" />
                  <xsl:with-param name="activeFwVersion" select="$activefwVersion" />
                  <xsl:with-param name="bayNum" select="$bayNum" />
                  <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                </xsl:call-template>
              </xsl:if>
            </xsl:if>
            
          </div>
          <!--End tree contents-->

        </xsl:element>
      </xsl:when>
      <!-- Some enclosure settings nodes are available to users without oa permission -->
      <xsl:otherwise>
        <xsl:element name="div">

          <xsl:attribute name="class">treeClosed</xsl:attribute>

          <div class="treeControl">
            <div class="treeDisclosure"></div>
          </div>

          <xsl:element name="div">

            <xsl:attribute name="class">treeTitle</xsl:attribute>
            <xsl:attribute name="id">enc1Settings</xsl:attribute>

            <xsl:value-of select="$stringsDoc//value[@key='enclosureSettings']" />

          </xsl:element>

          <div class="treeContents">
            <div class="leafWrapper">

              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'DateTimeSelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="devId">
                  </xsl:attribute>
                  <xsl:attribute name="href">../html/powerDelay.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="2" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">enc</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='devicePowerSeq']" />

                </xsl:element>
              </xsl:element>
            </div>

            <div class="leafWrapper">

              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'dvd12Select')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="href">../html/dvdSharing.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="12" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">dvd</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='dvdDrive']" />

                </xsl:element>
              </xsl:element>
            </div>
            
            <div class="leafWrapper">

              <xsl:element name="div">

              <xsl:attribute name="class">leaf</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'fruSummarySelect')" />
              </xsl:attribute>

              <xsl:element name="a">

                <xsl:attribute name="href">../html/fruSummary.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum"><xsl:value-of select="10" /></xsl:attribute>
                <xsl:attribute name="devType">enc</xsl:attribute>
                <xsl:attribute name="encNum"><xsl:value-of select="$enclosureNumber" /></xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='fruSummary']" />

              </xsl:element>
              </xsl:element>
            </div>

          </div>
        </xsl:element>

      </xsl:otherwise>
    </xsl:choose>
    
      
      <!-- End enc settings div element -->
      
      <!-- Active OA -->
      <xsl:element name="div">

        <xsl:attribute name="class">treeClosed</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('enc', $enclosureNumber, 'em', $activeEMId, 'Anchor')" />
        </xsl:attribute>

        <div class="treeControl">

          <xsl:variable name="oaStatus" select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$ACTIVE]/hpoa:operationalStatus" />

      <xsl:element name="div">
        <xsl:attribute name="class">treeStatusIcon</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('enc', $enclosureNumber, 'oaACTIVEStatus')"/>
        </xsl:attribute>

        <xsl:if test="$oaStatus!=$OP_STATUS_OK">
          <xsl:call-template name="statusIcon">
            <xsl:with-param name="statusCode" select="$oaStatus" />
          </xsl:call-template>
        </xsl:if>
        
      </xsl:element>
      
          <div class="treeDisclosure"></div>
        </div>
        <!-- Main EM Tree Title -->
        <xsl:element name="div">

          <xsl:attribute name="class">treeTitle</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="$emSelectId" />
          </xsl:attribute>

          <xsl:element name="a">

            <xsl:attribute name="devId">
              <xsl:value-of select="$emSelectId" />
            </xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
            <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

            <xsl:attribute name="devNum">
              <xsl:value-of select="$activeEMId" />
            </xsl:attribute>
            <xsl:attribute name="devType">em</xsl:attribute>
            <xsl:attribute name="encNum">
              <xsl:value-of select="$enclosureNumber" />
            </xsl:attribute>

            <xsl:value-of select="$stringsDoc//value[@key='activeEM']" />

          </xsl:element>

        </xsl:element>

        <!-- Main EM function links -->
        <div class="treeContents">
          
          <div class="leafWrapper">
            
            <xsl:element name="div">

              <xsl:attribute name="class">leaf</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'NetSettingsSelect')" />
              </xsl:attribute>

              <xsl:element name="a">

                <xsl:attribute name="devId">
                  <xsl:value-of select="$emSelectId" />
                </xsl:attribute>
                <xsl:attribute name="href">../html/oaNetSettings.html?emNum=<xsl:value-of select="$activeEMId" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="$activeEMId" />
                </xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='ipSettings']" />

              </xsl:element>
            </xsl:element>
          </div>

          <div class="leafWrapper">

            <xsl:element name="div">

              <xsl:attribute name="class">leaf</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'CertAdminSelect')" />
              </xsl:attribute>

              <xsl:element name="a">

                <xsl:attribute name="devId">
                  <xsl:value-of select="$emSelectId" />
                </xsl:attribute>
                <xsl:attribute name="href">../html/certificateAdministration.html?emNum=<xsl:value-of select="$activeEMId" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="$activeEMId" />
                </xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='certificateAdmin']" />

              </xsl:element>
            </xsl:element>
          </div>
          
          <xsl:if test="$serviceUserAcl!=$USER and $serviceUserOaAccess='true'">

            <div class="leafWrapper">

              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'FirmwareUpdateSelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="devId">
                    <xsl:value-of select="$emSelectId" />
                  </xsl:attribute>
                  <xsl:attribute name="href">../html/oaFirmwareUpdate.html?emNum=<xsl:value-of select="$activeEMId" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="$activeEMId" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">em</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='firmwareUpdate']" />

                </xsl:element>
              </xsl:element>
            </div>
            
          </xsl:if>

          <xsl:if test="$serviceUserOaAccess='true'">
            <div class="leafWrapper">

              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'SysLogSelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="devId">
                    <xsl:value-of select="$emSelectId" />
                  </xsl:attribute>
                  <xsl:attribute name="href">../html/oaSystemLog.html?emNum=<xsl:value-of select="$activeEMId" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="$activeEMId" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">em</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='systemLog']" />

                </xsl:element>
              </xsl:element>
            </div>
          </xsl:if>
          
        </div>
      </xsl:element>
      
      <!-- Standby OA -->
      <xsl:element name="div">
        
        <xsl:variable name="standbyEMId">
          <xsl:choose>
            <xsl:when test="count($oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$STANDBY])=1">
              <xsl:value-of select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$STANDBY]/hpoa:bayNumber"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$ACTIVE]/hpoa:bayNumber=1">2</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="emRedundantSelectId" select="concat('enc', $enclosureNumber, 'em', $standbyEMId, 'Select')" />
        
        <xsl:if test="count($oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$STANDBY])=0">
          <xsl:attribute name="style">display:none;</xsl:attribute>
        </xsl:if>
        
        <xsl:attribute name="class">treeClosed</xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'StandbyLeaf')" /></xsl:attribute>

        <xsl:variable name="standbyOaStatus" select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole=$STANDBY]/hpoa:operationalStatus"/>

      <div class="treeControl">

        <xsl:element name="div">
          <xsl:attribute name="class">treeStatusIcon</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="concat('enc', $enclosureNumber, 'oaSTANDBYStatus')"/>
          </xsl:attribute>

          <xsl:if test="$standbyOaStatus!=$OP_STATUS_OK">
            <xsl:call-template name="statusIcon">
              <xsl:with-param name="statusCode" select="$standbyOaStatus" />
            </xsl:call-template>
          </xsl:if>

        </xsl:element>

          <div class="treeDisclosure"></div>
        </div>

        <xsl:element name="div">
          <xsl:attribute name="class">treeTitle</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="$emRedundantSelectId" />
          </xsl:attribute>

          <xsl:element name="a">

            <xsl:attribute name="devId">
              <xsl:value-of select="$emRedundantSelectId" />
            </xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
            <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

            <xsl:attribute name="devNum">
              <xsl:value-of select="$standbyEMId" />
            </xsl:attribute>
            <xsl:attribute name="devType">em</xsl:attribute>
            <xsl:attribute name="encNum">
              <xsl:value-of select="$enclosureNumber" />
            </xsl:attribute>

            <xsl:value-of select="$stringsDoc//value[@key='standbyEM']" />

          </xsl:element>

        </xsl:element>

        <div class="treeContents">

          <div class="leafWrapper">

            <xsl:element name="div">

              <xsl:attribute name="class">leaf</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'StandbyNetSettingsSelect')" />
              </xsl:attribute>

              <xsl:element name="a">

                <xsl:attribute name="devId">
                  <xsl:value-of select="$emSelectId" />
                </xsl:attribute>
                <xsl:attribute name="href">../html/oaNetSettings.html?emNum=<xsl:value-of select="$standbyEMId" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="$standbyEMId" />
                </xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='ipSettings']" />

              </xsl:element>
            </xsl:element>
          </div>
          
          <div class="leafWrapper">

            <xsl:element name="div">

              <xsl:attribute name="class">leaf</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'CertAdminSelect')" />
              </xsl:attribute>

              <xsl:element name="a">

                <xsl:attribute name="devId">
                  <xsl:value-of select="$emSelectId" />
                </xsl:attribute>
                <xsl:attribute name="href">../html/certificateAdministration.html?emNum=<xsl:value-of select="$standbyEMId" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="$standbyEMId" />
                </xsl:attribute>
                <xsl:attribute name="devType">em</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='certificateAdmin']" />

              </xsl:element>
            </xsl:element>
          </div>

          <xsl:if test="$serviceUserOaAccess='true'">
            <div class="leafWrapper">

              <xsl:element name="div">

                <xsl:attribute name="class">leaf</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'SysLogSelect')" />
                </xsl:attribute>

                <xsl:element name="a">

                  <xsl:attribute name="devId">
                    <xsl:value-of select="$emSelectId" />
                  </xsl:attribute>
                  <xsl:attribute name="href">../html/oaSystemLog.html?emNum=<xsl:value-of select="$standbyEMId" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">
                    <xsl:value-of select="$standbyEMId" />
                  </xsl:attribute>
                  <xsl:attribute name="devType">em</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>

                  <xsl:value-of select="$stringsDoc//value[@key='systemLog']" />

                </xsl:element>
              </xsl:element>
            </div>
          </xsl:if>
        </div>
      </xsl:element>

      <xsl:variable name="bayTitleId">
        <xsl:value-of select="concat('enc', $enclosureNumber, 'bay0Select')" />
      </xsl:variable>
    
      <!-- Server Bays -->
      <xsl:element name="div">

        <xsl:attribute name="class">treeClosed</xsl:attribute>

        <xsl:attribute name="id">
          <xsl:value-of select="concat('enc', $enclosureNumber, 'ServersAnchor')" />
        </xsl:attribute>

        <div class="treeControl">
          <div class="treeDisclosure"></div>
        </div>

        <xsl:element name="div">
          <xsl:attribute name="class">treeTitle</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="$bayTitleId" />
          </xsl:attribute>

          <xsl:element name="a">

            <xsl:attribute name="devId">
              <xsl:value-of select="$bayTitleId" />
            </xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
            <xsl:attribute name="class">treeSelectableLink</xsl:attribute>
            <xsl:attribute name="devNum">0</xsl:attribute>
            <xsl:attribute name="devType">bay</xsl:attribute>
            <xsl:attribute name="encNum">
              <xsl:value-of select="$enclosureNumber" />
            </xsl:attribute>

            <xsl:value-of select="$stringsDoc//value[@key='serverBays']" />

          </xsl:element>

        </xsl:element>

        <div class="treeContents" id="bladeContents">

          <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo">
            <xsl:variable name="curBladeNum" select="hpoa:bayNumber" />

            <xsl:choose>
              <!-- Multi-blade servers -->
              <xsl:when test="(hpoa:extraData[@hpoa:name='isConjoinable']=1 and hpoa:extraData[@hpoa:name='monarchBlade']=$curBladeNum) and (number($domainInfoDoc//hpoa:domains/hpoa:domain[hpoa:monarchBlade=$curBladeNum]/hpoa:size) &gt; 1)">

                <xsl:for-each select="$domainInfoDoc//hpoa:domains/hpoa:domain[hpoa:monarchBlade=$curBladeNum]">

                  <xsl:variable name="monarchBladeNum" select="hpoa:monarchBlade" />

                  <xsl:element name="div">

                    <xsl:attribute name="class">treeClosed</xsl:attribute>

                    <xsl:attribute name="id">
                      <xsl:value-of select="concat('enc', $enclosureNumber, 'Domain', $monarchBladeNum, 'Anchor')" />
                    </xsl:attribute>

                    <div class="treeControl">
                      <div class="treeDisclosure"></div>
                    </div>

                    <xsl:element name="div">
                      <xsl:attribute name="class">treeTitle</xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('enc', $enclosureNumber, 'monarch', $monarchBladeNum, 'Select')" />
                      </xsl:attribute>
                      <xsl:element name="a">

                        <xsl:attribute name="devId">
                          <xsl:value-of select="concat('enc', $enclosureNumber, 'monarch', $monarchBladeNum, 'Select')" />
                        </xsl:attribute>
                        <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                        <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                        <xsl:attribute name="class">treeSelectableLink</xsl:attribute>
                        <xsl:attribute name="devNum">
                          <xsl:value-of select="$monarchBladeNum"/>
                        </xsl:attribute>
                        <xsl:attribute name="devType">monarch</xsl:attribute>
                        <xsl:attribute name="encNum">
                          <xsl:value-of select="$enclosureNumber" />
                        </xsl:attribute>
                        <xsl:attribute name="id">
                          <xsl:value-of select="concat('enc', $enclosureNumber, 'blade', $monarchBladeNum, 'Label')"/>
                        </xsl:attribute>

                        <xsl:variable name="bayListLabel">
                          <xsl:choose>
                            <xsl:when test="number(hpoa:size) &gt; 1">
                              <xsl:value-of select="concat(hpoa:bays/hpoa:bay, '-', hpoa:bays/hpoa:bay[last()])"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="hpoa:bays/hpoa:bay"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>

                        <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$monarchBladeNum]">
                          <xsl:value-of select="concat($bayListLabel, '. ', hpoa:name)" />
                          <!--
                          <xsl:choose>
                            <xsl:when test="hpoa:serverName and hpoa:serverName != '' and hpoa:serverName != '[Unknown]' and hpoa:serverName != 'Status is not available'">
                              <xsl:value-of select="concat($bayListLabel, '. ', hpoa:serverName)" />
                            </xsl:when>
                            <xsl:when test="hpoa:extraData[@hpoa:name='serverHostName'] and (hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]') and hpoa:extraData[@hpoa:name='serverHostName'] != 'Status is not available' and hpoa:extraData[@hpoa:name='serverHostName'] != ''">
                              <xsl:value-of select="concat($bayListLabel, '. ', hpoa:extraData[@hpoa:name='serverHostName'])" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:variable name="serialNumber">
                                <xsl:choose>
                                  <xsl:when test="hpoa:serialNumber and hpoa:serialNumber != '' and hpoa:serialNumber != '[Unknown]' and hpoa:serialNumber != 'Status is not available'">
                                    <xsl:value-of select="concat('-', hpoa:serialNumber)" />
                                  </xsl:when>
                                  <xsl:otherwise></xsl:otherwise>
                                </xsl:choose>
                              </xsl:variable>
                              <xsl:value-of select="concat($bayListLabel, '. ', hpoa:name,$serialNumber)" />
                            </xsl:otherwise>
                          </xsl:choose>
                          -->
                        </xsl:for-each>

                      </xsl:element>
                    </xsl:element>

                    <!-- Conjoined Blade list for current domain -->
                    <div class="treeContents">

                      <xsl:choose>

                        <xsl:when test="count(hpoa:partitions/hpoa:partition) &gt; 0">

                          <xsl:for-each select="hpoa:partitions/hpoa:partition">

                            <xsl:variable name="mmpBlade" select="hpoa:mmpBlade" />
                            
                            <xsl:for-each select="hpoa:bays/hpoa:bay">
                              <xsl:variable name="domainBayNum" select="." />
                              <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$domainBayNum]">
                                <xsl:call-template name="treeBladeLeaf">
                                  <xsl:with-param name="monarchBlade" select="$mmpBlade" />
                                  <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                                  <xsl:with-param name="activefwVersion" select="$activefwVersion" />
                                  <xsl:with-param name="serviceUserAcl" select="$serviceUserAcl" />
                                </xsl:call-template>
                              </xsl:for-each>
                            </xsl:for-each>

                          </xsl:for-each>

                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select="hpoa:bays/hpoa:bay">
                            <xsl:variable name="domainBayNum" select="." />
                            <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$domainBayNum]">
                              <xsl:call-template name="treeBladeLeaf">
                                <xsl:with-param name="monarchBlade" select="$monarchBladeNum" />
                                <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                                <xsl:with-param name="activefwVersion" select="$activefwVersion" />
                                <xsl:with-param name="serviceUserAcl" select="$serviceUserAcl" />
                              </xsl:call-template>
                            </xsl:for-each>
                          </xsl:for-each>
                        </xsl:otherwise>

                      </xsl:choose>

                    </div>

                  </xsl:element>

                </xsl:for-each>
                
              </xsl:when>
              <!-- Single blades -->
              <xsl:otherwise>

                <xsl:if test="(count($domainInfoDoc//hpoa:domains//hpoa:bays[hpoa:bay=$curBladeNum])=0) or (number($domainInfoDoc//hpoa:domains/hpoa:domain[hpoa:monarchBlade=$curBladeNum]/hpoa:size) = 1)">
                  <xsl:call-template name="treeBladeLeaf">
                    <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                    <xsl:with-param name="activefwVersion" select="$activefwVersion" />
                    <xsl:with-param name="serviceUserAcl" select="$serviceUserAcl" />
                  </xsl:call-template>
                </xsl:if>
                
              </xsl:otherwise>
            </xsl:choose>
            
          </xsl:for-each>

    </div>
  </xsl:element>
      
      <xsl:variable name="ioTitleId" select="concat('enc', $enclosureNumber, 'interconnect0Select')" />
      
      <!-- Interconnect Bays -->
      <xsl:element name="div">

        <xsl:attribute name="class">treeClosed</xsl:attribute>

        <xsl:attribute name="id">
          <xsl:value-of select="concat('enc', $enclosureNumber, 'IOAnchor')" />
        </xsl:attribute>

        <div class="treeControl">
          <div class="treeDisclosure"></div>
        </div>

        <xsl:element name="div">
          <xsl:attribute name="class">treeTitle</xsl:attribute>
          <xsl:attribute name="id"><xsl:value-of select="$ioTitleId" /></xsl:attribute>

          <xsl:element name="a">

            <xsl:attribute name="devId"><xsl:value-of select="$ioTitleId" /></xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
            <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

            <xsl:attribute name="devNum">0</xsl:attribute>
            <xsl:attribute name="devType">interconnect</xsl:attribute>
            <xsl:attribute name="encNum">
              <xsl:value-of select="$enclosureNumber" />
            </xsl:attribute>

            <xsl:value-of select="$stringsDoc//value[@key='interconnectBays']" />

          </xsl:element>

        </xsl:element>

        <div class="treeContents">

          <!-- Loop through all of the interconnect bays -->
          <xsl:for-each select="$netTrayStatusDoc//hpoa:interconnectTrayStatus">
            <xsl:call-template name="treeInterconnectLeaf">
              <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
            </xsl:call-template>
          </xsl:for-each>
        </div>

      </xsl:element>
      
      <!-- End interconnect bays -->

      <!-- Power and Thermal -->
      <xsl:variable name="psTitleId" select="concat('enc', $enclosureNumber, 'ps0Select')" />
      <xsl:variable name="fanTitleId" select="concat('enc', $enclosureNumber, 'fan0Select')" />

      <xsl:element name="div">
        
        <xsl:attribute name="class">treeClosed</xsl:attribute>

        <xsl:attribute name="id">
          <xsl:value-of select="concat('enc', $enclosureNumber, 'PSAnchor')" />
        </xsl:attribute>

        <div class="treeControl">
          <div class="treeDisclosure"></div>
        </div>

        <xsl:variable name="ptTitleId" select="concat('enc', $enclosureNumber, 'pt0Select')" />

        <xsl:element name="div">
          <xsl:attribute name="class">treeTitle</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="$ptTitleId" />
          </xsl:attribute>

          <xsl:element name="a">

            <xsl:attribute name="devId">
              <xsl:value-of select="$ptTitleId" />
            </xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
            <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

            <xsl:attribute name="devNum">0</xsl:attribute>
            <xsl:attribute name="devType">pt</xsl:attribute>
            <xsl:attribute name="encNum">
              <xsl:value-of select="$enclosureNumber" />
            </xsl:attribute>

            <xsl:value-of select="$stringsDoc//value[@key='powerThermal']" />

          </xsl:element>

        </xsl:element>
        
        <div class="treeContents">
          <xsl:if test="$serviceUserOaAccess='true'">
              <div class="leafWrapper">
                <div class="leaf" id="powerManagement">
                <xsl:element name="a">
                  <xsl:attribute name="devId">
                    <xsl:value-of select="powerManagementSelect" />
                  </xsl:attribute>
                  <xsl:attribute name="href">../html/powerManagement.html?encNum=<xsl:value-of select="$enclosureNumber"/></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                  <xsl:attribute name="devNum">0</xsl:attribute>
                  <xsl:attribute name="devType">powerManagement</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='powerManagement']" />
                </xsl:element>
              </div>
            </div>
          </xsl:if>
          <div class="leafWrapper">
            <div class="leaf" id="powerUsage">
              <xsl:element name="a">
                <xsl:attribute name="devId">
                  <xsl:value-of select="powerUsageSelect" />
                </xsl:attribute>
                <xsl:attribute name="href">../html/devicePowerUsage.html?encNum=<xsl:value-of select="$enclosureNumber"/></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>
                <xsl:attribute name="devNum">0</xsl:attribute>
                <xsl:attribute name="devType">devicePowerUsage</xsl:attribute>
                <xsl:attribute name="encNum"><xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='enclosurePowerAllocation']" />
              </xsl:element>
            </div>
          </div>
      <xsl:if test="number($activefwVersion) &gt;= number('2.50')">
        <xsl:if test="$serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true'">
          <div class="leafWrapper">
            <div class="leaf" id="powerSummary">
              <xsl:element name="a">
                <xsl:attribute name="devId">
                  <xsl:value-of select="powerSummarySelect" />
                </xsl:attribute>
                <xsl:attribute name="href">../html/enclosurePowerSummary.html?encNum=<xsl:value-of select="$enclosureNumber"/></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>
                <xsl:attribute name="devNum">0</xsl:attribute>
                <xsl:attribute name="devType">enclosurePowerSummary</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='encPowerSummary']" />
              </xsl:element>
            </div>
          </div>
        </xsl:if>
      </xsl:if>
          <xsl:if test="$serviceUserOaAccess='true'">
            <div class="leafWrapper">
              <div class="leaf" id="powerMeter">
                <xsl:element name="a">
                  <xsl:attribute name="devId">
                    <xsl:value-of select="powerMeterSelect" />
                  </xsl:attribute>
                  <xsl:attribute name="href">../html/powerMeter.html?encNum=<xsl:value-of select="$enclosureNumber"/></xsl:attribute>
                  <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                  <xsl:attribute name="class">treeSelectableLink</xsl:attribute>
                  <xsl:attribute name="devNum">0</xsl:attribute>
                  <xsl:attribute name="devType">powerMeter</xsl:attribute>
                  <xsl:attribute name="encNum">
                    <xsl:value-of select="$enclosureNumber" />
                  </xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='powerMeter']" />
                </xsl:element>
              </div>
            </div>
          </xsl:if>
          <!-- Power Supply List -->
          <xsl:element name="div">
            
            <xsl:attribute name="class">treeClosed</xsl:attribute>

            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'PSAnchor')" />
            </xsl:attribute>

            <div class="treeControl">
              <xsl:element name="div">
                <xsl:attribute name="class">treeStatusIcon</xsl:attribute>
                <xsl:attribute name="id"><xsl:value-of select="concat('enc', $enclosureNumber, 'pssStatus')"/></xsl:attribute>
                <xsl:if test="$powerSubsystemInfoDoc//hpoa:operationalStatus != $OP_STATUS_OK">
                  <xsl:call-template name="statusIcon">
                    <xsl:with-param name="statusCode" select="$powerSubsystemInfoDoc//hpoa:operationalStatus" />
                  </xsl:call-template>
                </xsl:if>
              </xsl:element>
              <div class="treeDisclosure"></div>
            </div>
            <xsl:element name="div">
              <xsl:attribute name="class">treeTitle</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="$psTitleId" />
              </xsl:attribute>

              <xsl:element name="a">

                <xsl:attribute name="devId">
                  <xsl:value-of select="$psTitleId" />
                </xsl:attribute>
                <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">0</xsl:attribute>
                <xsl:attribute name="devType">ps</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='powerSubsystem']" />

              </xsl:element>

            </xsl:element>
            <div class="treeContents">

              <!-- List of individual power supplies -->
              <xsl:for-each select="$powerSupplyInfoDoc//hpoa:powerSupplyInfo">
                <xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />
                <xsl:call-template name="treeNavEnclosureLeaf">
                  <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                  <xsl:with-param name="deviceNumber" select="hpoa:bayNumber" />
                  <xsl:with-param name="deviceLabel" select="'ps'" />
                  <xsl:with-param name="deviceStatus" select="$powerSupplyStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:operationalStatus" />
                  <xsl:with-param name="presence" select="hpoa:presence" />
                  <xsl:with-param name="encNum" select="$enclosureNumber" />
                </xsl:call-template>
              </xsl:for-each>

            </div>

          </xsl:element>

          <!-- Fan List -->
          <xsl:element name="div">
            
            <xsl:attribute name="class">treeClosed</xsl:attribute>

            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'FansAnchor')" />
            </xsl:attribute>

            <div class="treeControl">
              <div class="treeStatusIcon">
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'tssStatus')"/>
                </xsl:attribute>
                <xsl:variable name="thermalSubsystemStatus" select="$thermalSubsystemInfoDoc//hpoa:thermalSubsystemInfo/hpoa:operationalStatus" />
                <xsl:if test="$thermalSubsystemStatus != 'OP_STATUS_OK'">

                  <xsl:call-template name="statusIcon">
                    <xsl:with-param name="statusCode" select="$thermalSubsystemStatus" />
                  </xsl:call-template>

                </xsl:if>
                
              </div>
              <div class="treeDisclosure"></div>
            </div>

            <xsl:element name="div">

              <xsl:attribute name="class">treeTitle</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="$fanTitleId" />
              </xsl:attribute>

              <xsl:element name="a">

                <xsl:attribute name="devId">
                  <xsl:value-of select="$fanTitleId" />
                </xsl:attribute>
                <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">0</xsl:attribute>
                <xsl:attribute name="devType">fan</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>

                <xsl:value-of select="$stringsDoc//value[@key='thermalSubsystem']" />

              </xsl:element>

            </xsl:element>

            <div class="treeContents" id="treeFanContents">

              <!-- List of individual fans -->
              <xsl:for-each select="$fanInfoDoc//hpoa:fanInfo">

            <xsl:variable name="fanPresence">
              <xsl:choose>
                <xsl:when test="hpoa:presence=$PRESENT or hpoa:operationalStatus!='OP_STATUS_UNKNOWN'">PRESENT</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="hpoa:presence"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
                <xsl:call-template name="treeNavEnclosureLeaf">
                  <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                  <xsl:with-param name="deviceNumber" select="hpoa:bayNumber" />
                  <xsl:with-param name="deviceLabel" select="'fan'" />
                  <xsl:with-param name="deviceStatus" select="hpoa:operationalStatus" />
                  <xsl:with-param name="presence" select="$fanPresence" />
                  <xsl:with-param name="encNum" select="$enclosureNumber" />
                </xsl:call-template>
              </xsl:for-each>

            </div>
          </xsl:element>
          <!-- End Fan List -->
        </div>

      </xsl:element>
      <!-- End Power and Thermal -->
      
      <!-- Security -->
      <xsl:if test="($serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true') or ($serviceUserType=0)">

        <xsl:element name="div">

          <xsl:variable name="securitySelectId" select="concat('enc', $enclosureNumber, 'security0Select')" />
          <xsl:attribute name="class">treeClosed</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="concat('enc', $enclosureNumber, 'SecurityAnchor')" />
          </xsl:attribute>

          <div class="treeControl">
            <div class="treeDisclosure"></div>
          </div>
          <!-- Security node tree title -->
          <xsl:element name="div">
            <xsl:attribute name="class">treeTitle</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="$securitySelectId" />
            </xsl:attribute>

            <xsl:value-of select="$stringsDoc//value[@key='usersAuthentication']" />

          </xsl:element>

          <div class="treeContents">

            <xsl:choose>
              <!-- Only an Administrator with OA bay access can change these settings. -->
              <xsl:when test="$serviceUserAcl=$ADMINISTRATOR and $serviceUserOaAccess='true'">
                <!-- Local users tree contents -->
                <xsl:variable name="userTitleId">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'user0Select')" />
                </xsl:variable>
                <xsl:element name="div">

                  <xsl:attribute name="class">treeClosed</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('enc', $enclosureNumber, 'LocalUsersAnchor')" />
                  </xsl:attribute>

                  <div class="treeControl">
                    <div class="treeDisclosure"></div>
                  </div>

                  <xsl:element name="div">

                    <xsl:attribute name="class">treeTitle</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="$userTitleId" />
                    </xsl:attribute>

                    <xsl:element name="a">
                      <xsl:attribute name="devId">
                        <xsl:value-of select="$userTitleId" />
                      </xsl:attribute>
                      <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                      <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                      <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                      <xsl:attribute name="devNum">0</xsl:attribute>
                      <xsl:attribute name="devType">user</xsl:attribute>
                      <xsl:attribute name="encNum">
                        <xsl:value-of select="$enclosureNumber" />
                      </xsl:attribute>

                      <xsl:value-of select="$stringsDoc//value[@key='localUsers']" />

                    </xsl:element>

                  </xsl:element>

                  <xsl:element name="div">

                    <xsl:attribute name="class">treeContents</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="concat('enc', $enclosureNumber, 'Users')"/>
                    </xsl:attribute>

                    <xsl:for-each select="$userInfoDoc//hpoa:userInfo[hpoa:acl!=$ANONYMOUS]">

                      <xsl:element name="div">

                        <xsl:attribute name="class">leafWrapper</xsl:attribute>
                        <xsl:attribute name="id">
                          <xsl:value-of select="concat('enc', $enclosureNumber, 'userLeafWrapper', hpoa:username)"/>
                        </xsl:attribute>
                        <xsl:attribute name="username">
                          <xsl:value-of select="hpoa:username" />
                        </xsl:attribute>

                        <xsl:call-template name="treeUserLeaf">
                          <xsl:with-param name="encNum" select="$enclosureNumber" />
                          <xsl:with-param name="username" select="hpoa:username" />
                        </xsl:call-template>

                      </xsl:element>

                    </xsl:for-each>

                  </xsl:element>
                </xsl:element>
                <!--//End Local Users-->

          <xsl:if test="number($activefwVersion) &gt;= number('2.20')">
            <xsl:call-template name="treeNavEnclosureLeaf">
              <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
              <xsl:with-param name="deviceNumber" select="1" />
              <xsl:with-param name="deviceLabel" select="'security'" />
              <xsl:with-param name="customLabel" select="$stringsDoc//value[@key='passwordSettings']" />
              <xsl:with-param name="href" select="concat('../html/strictPasswords.html?encNum=', $enclosureNumber)" />
              <xsl:with-param name="presence" select="$PRESENT" />
            </xsl:call-template>
          </xsl:if>
          
                <xsl:call-template name="treeNavEnclosureLeaf">
                  <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                  <xsl:with-param name="deviceNumber" select="1" />
                  <xsl:with-param name="deviceLabel" select="'security'" />
                  <xsl:with-param name="customLabel" select="$stringsDoc//value[@key='directorySettings']" />
                  <xsl:with-param name="href" select="concat('../html/directorySettings.html?encNum=', $enclosureNumber)" />
                  <xsl:with-param name="presence" select="$PRESENT" />
                </xsl:call-template>

                <xsl:element name="div">

                  <xsl:variable name="groupTitleId">
                    <xsl:value-of select="concat('enc', $enclosureNumber, 'group0Select')" />
                  </xsl:variable>

                  <xsl:attribute name="class">treeClosed</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('enc', $enclosureNumber, 'groupsleafWrapper')" />
                  </xsl:attribute>

                  <div class="treeControl">
                    <xsl:element name="div">
                      <xsl:attribute name="class">treeDisclosure</xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('enc', $enclosureNumber, 'GroupsTreeDisclosure')"/>
                      </xsl:attribute>
                    </xsl:element>
                  </div>

                  <xsl:element name="div">

                    <xsl:attribute name="class">treeTitle</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="$groupTitleId" />
                    </xsl:attribute>

                    <xsl:element name="a">
                      <xsl:attribute name="devId">
                        <xsl:value-of select="$groupTitleId" />
                      </xsl:attribute>
                      <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                      <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                      <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                      <xsl:attribute name="devNum">0</xsl:attribute>
                      <xsl:attribute name="devType">group</xsl:attribute>
                      <xsl:attribute name="encNum">
                        <xsl:value-of select="$enclosureNumber" />
                      </xsl:attribute>

                      <xsl:value-of select="$stringsDoc//value[@key='directoryGroups']" />

                    </xsl:element>

                  </xsl:element>

                  <xsl:element name="div">

                    <xsl:attribute name="class">treeContents</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="concat('enc', $enclosureNumber, 'Groups')"/>
                    </xsl:attribute>

                    <xsl:for-each select="$groupInfoDoc//hpoa:ldapGroupInfo">

            <xsl:variable name="groupNameURI"><xsl:call-template name="my-escape-uri">
                <xsl:with-param name="str" select="hpoa:ldapGroupName"/>
                <xsl:with-param name="allow-utf8" select="true()"/>
                <xsl:with-param name="escape-amp" select="true()"/>
              </xsl:call-template></xsl:variable>

            <xsl:element name="div">

              <xsl:attribute name="class">leafWrapper</xsl:attribute>
                        <xsl:attribute name="id">
                          <xsl:value-of select="concat('enc', $enclosureNumber, 'groupLeafWrapper', $groupNameURI)"/>
                        </xsl:attribute>
                        <xsl:attribute name="groupName">
                          <xsl:value-of select="$groupNameURI" />
                        </xsl:attribute>

                        <xsl:call-template name="treeGroupLeaf">
                          <xsl:with-param name="groupEncNum" select="$enclosureNumber" />
                          <xsl:with-param name="groupNameURI" select="$groupNameURI" />
              <xsl:with-param name="groupName" select="hpoa:ldapGroupName" />
                        </xsl:call-template>

                      </xsl:element>

                    </xsl:for-each>

                  </xsl:element>
                </xsl:element>
                
                <!-- Only the built in Administrator account can administer SSH settings -->
                <xsl:if test="$serviceUsername='Administrator'">

                  <xsl:call-template name="treeNavEnclosureLeaf">
                    <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                    <xsl:with-param name="deviceNumber" select="2" />
                    <xsl:with-param name="deviceLabel" select="'security'" />
                    <xsl:with-param name="customLabel" select="$stringsDoc//value[@key='SSHAdmin']" />
                    <xsl:with-param name="href" select="concat('../html/sshAdministration.html?encNum=', $enclosureNumber)" />
                    <xsl:with-param name="presence" select="$PRESENT" />
                  </xsl:call-template>
                  
                </xsl:if>
                
                <xsl:call-template name="treeNavEnclosureLeaf">
                  <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                  <xsl:with-param name="deviceNumber" select="3" />
                  <xsl:with-param name="deviceLabel" select="'security'" />
                  <xsl:with-param name="customLabel" select="$stringsDoc//value[@key='hpSimIntegration']" />
                  <xsl:with-param name="href" select="concat('../html/hpSimIntegration.html?encNum=', $enclosureNumber)" />
                  <xsl:with-param name="presence" select="$PRESENT" />
                </xsl:call-template>

          <xsl:if test="$serviceUserAcl=$ADMINISTRATOR and number($activefwVersion) &gt;= number('2.10')">
        <xsl:call-template name="treeNavEnclosureLeaf">
                    <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                    <xsl:with-param name="deviceNumber" select="4" />
                    <xsl:with-param name="deviceLabel" select="'security'" />
                    <xsl:with-param name="customLabel" select="$stringsDoc//value[@key='twoFactorSecurity']" />
                    <xsl:with-param name="href" select="concat('../html/cacertificateAdministration.html?encNum=', $enclosureNumber, '&amp;emNum=', $activeEMId)" />
                    <xsl:with-param name="presence" select="$PRESENT" />
                  </xsl:call-template>
                </xsl:if>
  

                <xsl:call-template name="treeNavEnclosureLeaf">
                  <xsl:with-param name="enclosureNumber" select="$enclosureNumber" />
                  <xsl:with-param name="deviceNumber" select="5" />
                  <xsl:with-param name="deviceLabel" select="'security'" />
                  <xsl:with-param name="customLabel" select="$stringsDoc//value[@key='signedInUsers']" />
                  <xsl:with-param name="href" select="concat('../html/activeSessions.html?encNum=', $enclosureNumber, '&amp;emNum=', $bayNum)" />
                  <xsl:with-param name="presence" select="$PRESENT" />
          </xsl:call-template>

                                                                           
                
              </xsl:when>

              <!--
                If the user is not an administrator only allow them to edit
                their own settings.
              -->
              <xsl:when test="$serviceUserType=0">

                <xsl:element name="div">
                  <xsl:attribute name="class">treeOpen</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('userWrapper', $serviceUsername, $enclosureNumber)" />
                  </xsl:attribute>

                  <div class="leafWrapper">
                    <xsl:call-template name="treeUserLeaf">
                      <xsl:with-param name="encNum" select="$enclosureNumber" />
                      <xsl:with-param name="username" select="$serviceUsername" />
                    </xsl:call-template>
                  </div>
                </xsl:element>

              </xsl:when>
              
            </xsl:choose>

          </div>
        </xsl:element>
        <!-- End Users -->
        
      </xsl:if>
      
    <!-- LCD -->        
      <xsl:element name="div">

        <xsl:attribute name="class">treeOpen</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('LCDTreeWrapper', $enclosureNumber)" />
        </xsl:attribute>

        <div class="leafWrapper">

          <xsl:element name="div">

            <xsl:attribute name="class">leaf</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'lcd', $bayNum, 'Select')" />
            </xsl:attribute>

            <xsl:element name="a">
              <xsl:attribute name="devId">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'lcd', $bayNum, 'Select')" />
              </xsl:attribute>
              <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
              <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
              <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

              <xsl:attribute name="devNum">
                <xsl:value-of select="$bayNum"/>
              </xsl:attribute>
              <xsl:attribute name="devType">lcd</xsl:attribute>
              <xsl:attribute name="encNum">
                <xsl:value-of select="$enclosureNumber" />
              </xsl:attribute>

              <xsl:value-of select="$stringsDoc//value[@key='lcdScreen']" />

            </xsl:element>

          </xsl:element>
        </div>

      </xsl:element>
    <!-- End LCD -->

	<!-- VCM component -->
	<!-- If the IPv4 address field is not empty -->
	<xsl:variable name="vcmHasIpv4Address">
		<xsl:choose>
			<xsl:when test="$vcmInfoDoc//hpoa:vcmUrl != 'empty' and $vcmInfoDoc//hpoa:vcmUrl != '' and contains($vcmInfoDoc//hpoa:vcmUrl, '0.0.0.0') != 'true'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- If IPv6 is enabled and if there are non-empty IPv6 addresses to be displayed -->
	<xsl:variable name="vcmHasIpv6Address">
		<xsl:choose>
			<xsl:when test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true' and count($vcmInfoDoc//hpoa:extraData[@hpoa:name='IPv6URL']/text()) &gt; 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="vcmfqdn" select="$vcmInfoDoc//hpoa:extraData[@hpoa:name='VCMFQDNURL']" />
	<!-- If the FQDN address field is not empty -->
	<xsl:variable name="vcmHasFqdnAddress">
		<xsl:choose>
			<xsl:when test="string-length($vcmfqdn) &gt; 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:element name="div">
		<xsl:attribute name="class">treeOpen</xsl:attribute>
		<xsl:attribute name="id">
			<xsl:value-of select="concat('VcmTreeWrapper', $enclosureNumber)" />
		</xsl:attribute>

		<xsl:if test="$vcmHasIpv4Address='true' or $vcmHasIpv6Address='true' or $vcmHasFqdnAddress='true'">
			<div class="leafWrapper">
				<xsl:element name="div">
					<xsl:attribute name="class">leaf</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('enc', $enclosureNumber, 'vcm', '1', 'Select')" />
					</xsl:attribute>
					<xsl:element name="a">
						<xsl:attribute name="devId">
							<xsl:value-of select="concat('enc', $enclosureNumber, 'vcm', '1', 'Select')" />
						</xsl:attribute>
						<xsl:if test="$vcmHasFqdnAddress='true'">
							<xsl:attribute name="href">
								<xsl:value-of select="$vcmfqdn" />
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="$vcmHasFqdnAddress='false' and $vcmHasIpv4Address='true'">
							<xsl:attribute name="href">
								<xsl:value-of select="$vcmInfoDoc//hpoa:vcmUrl" />
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="target">_blank</xsl:attribute>
						<xsl:attribute name="class">treeSelectableLink</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='vcManager']" />
						<xsl:if test="$vcmHasIpv6Address='true' or $vcmHasFqdnAddress='true'">
							<xsl:call-template name="urlListTooltip">
								<xsl:with-param name="fqdn" select="$vcmfqdn" />
								<xsl:with-param name="defaultUrl" select="$vcmInfoDoc//hpoa:vcmUrl" />
								<xsl:with-param name="urlList" select="$vcmInfoDoc//hpoa:extraData[@hpoa:name='IPv6URL']" />
								<xsl:with-param name="itemProxyUrl" select="$proxyUrl" />
								<xsl:with-param name="isLocal" select="$isLocal" />
							</xsl:call-template>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</div>
		</xsl:if>

	</xsl:element>

  </div>

  </xsl:template>

</xsl:stylesheet>

