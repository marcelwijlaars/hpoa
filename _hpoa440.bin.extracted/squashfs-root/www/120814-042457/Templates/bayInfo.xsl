<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
  xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->

  <!-- Document fragment parameters containing blade status and information -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="bladeInfoDoc" />
  <xsl:param name="bladePortMapDoc" />
  <xsl:param name="bladeMezzInfoExDoc" />
  <xsl:param name="encNum" />

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />

  <!--
    Device Bay Information - Information tab - Device Information section
  -->
  <xsl:template match="*">
    <xsl:variable name="productId" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:productId" />
    
    <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
      <caption>
        <xsl:value-of select="$stringsDoc//value[@key='deviceFruInformation']" />
      </caption>
      <tbody>
        <tr class="">
          <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='bladeType']" />
          </th>
          <td class="propertyValue">
            <xsl:choose>
              <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_SERVER'">
                <xsl:value-of select="$stringsDoc//value[@key='serverBlade']" />
              </xsl:when>
              <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_STORAGE'">
                <xsl:value-of select="$stringsDoc//value[@key='storageBlade']" />
              </xsl:when>
              <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_IO'">
                <xsl:value-of select="$stringsDoc//value[@key='ioBlade']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr class="altRowColor">
          <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='manufacturer']" />
          </th>
          <td class="propertyValue">
            <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:manufacturer" />
          </td>
        </tr>
        <tr class="">
          <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='productName']" />
          </th>
          <td class="propertyValue">
            <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:name" />
          </td>
        </tr>
        <tr class="altRowColor">
          <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='partNumber']" />
          </th>
          <td class="propertyValue">
            <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:partNumber" />
          </td>
        </tr>
        <tr>
          <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='boardSparePartNumber']" />
          </th>
          <td class="propertyValue">
            <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:sparePartNumber" />
          </td>
        </tr>
        <tr class="altRowColor">
          <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='serialNumber']" />
          </th>
          <td class="propertyValue">
            <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:serialNumber" />
          </td>
        </tr>
        <xsl:if test="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='virtualSerialNumber1']) &gt; 0">
          <tr class="">
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='virtualSerialNumber']" />
            </th>
            <td class="propertyValue">
              <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='virtualSerialNumber1']" />
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_SERVER'">
          <tr class="altRowColor">
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='uuid']" />
            </th>
            <td class="propertyValue">
            <xsl:choose>
              <xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='cUUID']) &gt; 0">
                <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='cUUID']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:uuid" />
              </xsl:otherwise>
            </xsl:choose>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='virtualUuid1']) &gt; 0">
          <tr class="altRowColor">
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='virtualUuid']" />
            </th>
            <td class="propertyValue">
              <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='virtualUuid1']" />
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_SERVER'">
          <xsl:choose>
            <xsl:when test="$productId=8224">
              <tr class="altRowColor">
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='biosAssetTag']" />
                </th>
                <td class="propertyValue">
                  <xsl:choose>
                    <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:assetTag != '[Unknown]'">
                      <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:assetTag" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$stringsDoc//value[@key='Not set']" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]'">
                <tr class="altRowColor">
                  <th class="propertyName">
                    <xsl:value-of select="$stringsDoc//value[@key='serverName']" />
                  </th>
                  <td class="propertyValue">
                    <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='serverHostName']" />
                  </td>
                </tr>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <tr class="altRowColor">
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='serverHostName']" />
                </th>
                <td class="propertyValue">
                  <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='serverHostName']" />
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <tr class="">
          <th class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='romVersion']" />
          </th>
          <td class="propertyValue">
            <xsl:choose>
              <xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='romVersionEx']) &gt; 0">                
                <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='romVersionEx']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:romVersion" />
              </xsl:otherwise>
            </xsl:choose>            
          </td>
        </tr>
        <!-- only show UEFI mode if the server is reporting capable -->
        <xsl:if test="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='uefiCapable' and . = 'true']) &gt; 0">
          <xsl:variable name="bootMode" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='uefiBootMode']" />
          <tr class="">
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='bootMode']" />
            </th>
            <td class="propertyValue">
              <xsl:value-of select="$stringsDoc//value[@key=$bootMode]" />
            </td>
          </tr>                    
        </xsl:if>   
        <!-- only show Secure Boot if supported -->
        <xsl:variable name="secureBoot" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='secureBoot']" />
        <xsl:if test="string-length($secureBoot) &gt; 0">            
          <tr class="">
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='secureBoot']" />
            </th>
            <td class="propertyValue">
              <xsl:value-of select="$stringsDoc//value[@key=$secureBoot]" />
            </td>
          </tr>
        </xsl:if>
      </tbody>
    </table>

    <!--
      Device Bay Information - Information tab - Server NIC Information section
    -->
    <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType='BLADE_TYPE_SERVER'">

      <span class="whiteSpacer">&#160;</span>
      <br />
      <span class="whiteSpacer">&#160;</span>
      <br />

      <table align="center" border="0" cellpadding="0" cellspacing="0" class="treeTable">
        <tr class="captionRow">
          <th style="white-space:nowrap;padding-right:20px;">
            <xsl:value-of select="$stringsDoc//value[@key='serverNICInfo']" />
          </th>
          <th style="width:80%;">
            <xsl:value-of select="$stringsDoc//value[@key='deviceID']"/>
          </th>
        </tr>
        <tbody>
          <!--
            Display embedded LOM NICs
          -->
          <xsl:choose>
            <!-- if there are any mezzes with mezz number greater than $FLB_START_IX -->
            <xsl:when test="count($bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:mezzDevices) &gt; 0">

              <xsl:variable name="bladeNicInfoMatches">
                <xsl:call-template name="totalGuidMatches">
                  <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                  <xsl:with-param name="bladePortMap" select="$bladePortMapDoc" />
                  <xsl:with-param name="bladeMezzInfo" select="$bladeMezzInfoExDoc" />
                </xsl:call-template>
              </xsl:variable>
              
              <xsl:for-each select="$bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:mezzDevices">
                <xsl:variable name="mezzNumber" select="../hpoa:mezzNumber" />
                
                <!-- add title row when needed -->
                <xsl:choose>
                  <xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port/hpoa:guid) &gt; 0">
                    <tr class="treeTableTopLevel">
                      <td colspan="2" style="font-weight:normal;">
                        <xsl:choose>
                          <xsl:when test="hpoa:type = $MEZZ_DEV_TYPE_FIXED">
                            <xsl:value-of select="hpoa:name"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="../hpoa:extraData[@hpoa:name = 'aMezzNum'] != '0'">
                                <xsl:value-of select="concat('FLB Adapter ', ../hpoa:extraData[@hpoa:name = 'aMezzNum'], ': ', hpoa:name)"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="concat('FLB Adapter ', position(), ': ', hpoa:name)"/>
                              </xsl:otherwise>
                            </xsl:choose>                           
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </xsl:when>
                  <xsl:when test="count($bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port) &gt; 0 and count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port/hpoa:guid) = 0">
                    <xsl:choose>
                      <xsl:when test="$bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:name != ''">
                        <tr class="treeTableTopLevel">
                          <td colspan="2" style="font-weight:normal;">
                            <xsl:value-of select="$bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:name"/>
                          </td>
                        </tr> 
                      </xsl:when>
                      <xsl:otherwise>
                        <tr class="treeTableTopLevel">
                          <td colspan="2" style="font-weight:normal;">
                            <xsl:value-of select="$stringsDoc//value[@key='fixedNIC']"/>
                          </td>
                        </tr> 
                      </xsl:otherwise>
                    </xsl:choose>                    
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="$bladeNicInfoMatches &gt; 0">
                      <xsl:if test="count($bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:mezzDevices/hpoa:port[hpoa:wwpn = $bladeInfoDoc//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo[not(contains(hpoa:port, 'iLO'))]/hpoa:macAddress]) = 0 and count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:port/hpoa:guid[hpoa:guid = $bladeInfoDoc//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo[not(contains(hpoa:port, 'iLO'))]/hpoa:macAddress]) = 0">
                        <tr class="treeTableTopLevel">
                          <td colspan="2" style="font-weight:normal;">
                            <xsl:value-of select="$stringsDoc//value[@key='fixedNIC']"/>
                          </td>
                        </tr>                     
                      </xsl:if>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>

                <!-- loop through each port for this mezz -->
                <xsl:for-each select="$bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber=$mezzNumber]/hpoa:mezzDevices/hpoa:port">
                  <xsl:variable name="portNumber" select="hpoa:portNumber" />                  

                  <xsl:choose>
                    <!-- if it has a GUID give it an expanded label -->
                    <xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$portNumber]/hpoa:guid) &gt; 0">

                      <xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$portNumber]/hpoa:guid">
                        <tr>
                          <td class="nested1" style="text-align:right;width:1%;white-space:nowrap;">
                            <xsl:call-template name="getGuidLabel">
                              <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                              <xsl:with-param name="guidStruct" select="." />
                              <xsl:with-param name="mezzNumber" select="$mezzNumber" />
                            </xsl:call-template>
                          </td>
                          <td class="properyValue">
                            <xsl:value-of select="hpoa:guid"/>
                          </td>
                        </tr>
                      </xsl:for-each>

                    </xsl:when>
                    <xsl:otherwise>
                      <!-- if no GUID give it a simple label -->                      
                      <tr>
                        <td class="nested1" style="text-align:right;width:1%;white-space:nowrap;">
                          <xsl:call-template name="getNonGuidLabel">
                            <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                            <xsl:with-param name="portNumber" select="hpoa:portNumber" />
                            <xsl:with-param name="wwpn" select="hpoa:wwpn" />
                          </xsl:call-template>
                        </td>
                        <td>
                          <xsl:value-of select="hpoa:wwpn"/>
                        </td>
                      </tr>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>

              </xsl:for-each>              
              
              <!-- 	display iSCSI for iLO2 -->             
              <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo">
                <xsl:variable name="macAddress" select="hpoa:macAddress" />

                <!-- only show embedded iSCSI ports if they are defined in portmap doc as extraData, and prevent duplicates -->
                <xsl:if test="(contains(hpoa:port, 'iSCSI')) and not(preceding-sibling::hpoa:bladeNicInfo/hpoa:macAddress = $macAddress)">
                  <xsl:if test="count($bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:mezzDevices/hpoa:port/hpoa:extraData[@hpoa:name='iSCSIwwpn' and . = $macAddress]) &gt; 0">
                    <tr>
                      <td class="nested1" style="text-align:right;width:1%;white-space:nowrap;">
                        <xsl:value-of select="hpoa:port"/>
                      </td>
                      <td>
                        <xsl:value-of select="hpoa:macAddress"/>
                      </td>
                    </tr>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>              
              
              <!-- always show iLO ports last -->
              <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo">
                <xsl:variable name="macAddress" select="hpoa:macAddress" />
                
                <xsl:if test="contains(hpoa:port, 'iLO')">
                  <tr class="treeTableTopLevel">
                    <td colspan="2" style="font-weight:normal;">
                      <xsl:value-of select="$stringsDoc//value[@key='managementProc']"/>
                    </td>
                  </tr>
                  <tr>
                    <td class="nested1" style="text-align:right;width:1%;white-space:nowrap;">
                      <xsl:value-of select="hpoa:port"/>
                    </td>
                    <td>
                      <xsl:value-of select="hpoa:macAddress"/>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>		
              <!-- 
                No Embedded LOM >>> GUID <<< NIC entries were found above. 
                Get iLO and iSCSI with virtual NICs.
              -->
              <xsl:choose>
                <xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo) &gt; 0">
                  <tr class="treeTableTopLevel">
                    <td colspan="2" style="font-weight:normal;">
                      <xsl:value-of select="$stringsDoc//value[@key='fixedNIC']"/>
                    </td>
                  </tr>
                  <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo">
                    <tr>
                      <td class="nested1" style="text-align:right;width:1%;white-space:nowrap;">
                        <xsl:value-of select="hpoa:port"/>
                      </td>
                      <td>
                        <xsl:value-of select="hpoa:macAddress"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <!--
                  "The server does not contain any LOM ports"
                  -->
                  <tr class="noDataRow">
                    <td colspan="2">
                      <xsl:value-of select="$stringsDoc//value[@key='serverNotContainLOM']" />
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>             
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </table>

      <span class="whiteSpacer">&#160;</span>
      <br />
      <span class="whiteSpacer">&#160;</span>
      <br />

      <!--
        Device Bay Information - Information tab - Mezzanine Card Information section
      -->
      <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
        <caption>
          <xsl:value-of select="$stringsDoc//value[@key='mezzCardInfo']" />
        </caption>

        <thead>
          <tr class="captionRow">
            <th><xsl:value-of select="$stringsDoc//value[@key='mezzSlot']" /></th>
            <th><xsl:value-of select="$stringsDoc//value[@key='mezzDevice']" /></th>
            <th><xsl:value-of select="$stringsDoc//value[@key='mezzDevicePort']" /></th>
            <th><xsl:value-of select="$stringsDoc//value[@key='deviceID']" /></th>
          </tr>
        </thead>

        <tbody>

          <xsl:choose>
            <!-- How many Physical Mezzes or FLB Adapters are present? -->
            <xsl:when test="count($bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber &lt;= $FLB_START_IX]/hpoa:mezzDevices[hpoa:type!='MEZZ_DEV_TYPE_MT' and hpoa:type!='MEZZ_DEV_TYPE_FIXED' and hpoa:type!='MEZZ_DEV_TYPE_NA']) &gt; 0">

              <!-- Show only Physical and FLB Adapters -->
              <xsl:for-each select="$bladePortMapDoc//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber &lt;= $FLB_START_IX]/hpoa:mezzDevices[hpoa:type!='MEZZ_DEV_TYPE_MT' and hpoa:type!='MEZZ_DEV_TYPE_FIXED' and hpoa:type!='MEZZ_DEV_TYPE_NA']">
                <xsl:variable name="mezzNumber" select="../hpoa:mezzNumber"/>
               
                <xsl:element name="tr">
                  <xsl:attribute name="class">treeTableTopLevel</xsl:attribute>
                  <td><xsl:value-of select="$mezzNumber"/></td>								
                  <td class="nested1"><xsl:value-of select="hpoa:name"/></td>
                  <td>&#160;</td>
                  <td>&#160;</td>

                  <xsl:for-each select="hpoa:port">
                    <xsl:variable name="portNumber" select="hpoa:portNumber" />
                    
                    <xsl:if test="count(hpoa:extraData[@hpoa:name='portPartnerActive']) = 0">
                      <tr>
                        <td>
                          &#160;
                        </td>
                        <td>
                          &#160;
                        </td>                        
                        <xsl:choose>
                          <!-- 
                          Do any mezzes contain GUIDs that need to be displayed? 
                          -->
                          <xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$portNumber]/hpoa:guid) &gt; 0">
                            <td nowrap="true">
                              <xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$portNumber]/hpoa:guid">
                                <xsl:call-template name="getGuidLabel">
                                  <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                                  <xsl:with-param name="guidStruct" select="." />
                                  <xsl:with-param name="mezzNumber" select="$mezzNumber" />
                                </xsl:call-template>
                                <br />
                              </xsl:for-each>
                            </td>
                            <td>
                              <xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber=$mezzNumber]/hpoa:port[hpoa:portNumber=$portNumber]/hpoa:guid">
                                <xsl:value-of select="hpoa:guid"/>
                                <br />
                              </xsl:for-each>
                            </td>
                          </xsl:when>
                          <xsl:otherwise>
                            <td>
                              <xsl:value-of select="$stringsDoc//value[@key='port']" />&#160;<xsl:value-of select="$portNumber"/>
                            </td>
                            <td>
                              <xsl:value-of select="hpoa:wwpn"/>
                            </td>
                          </xsl:otherwise>
                        </xsl:choose>                        
                      </tr>
                    </xsl:if>										
                  </xsl:for-each>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <!--
              "The server does not contain any mezzanine cards"
              -->
              <tr class="noDataRow">
                <td colspan="4">
                  <xsl:value-of select="$stringsDoc//value[@key='serverNotContaintMezzCard']" />
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>

        </tbody>
      </table>

      <span class="whiteSpacer">&#160;</span>
      <br />
      <span class="whiteSpacer">&#160;</span>
      <br />

      <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
        <caption>
          <xsl:value-of select="$stringsDoc//value[@key='cpuAndMemInfo']" />
        </caption>
        <tbody>

          <xsl:choose>
            <xsl:when test="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:cpus/hpoa:bladeCpuInfo) &gt; 0">

              <xsl:for-each select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:cpus/hpoa:bladeCpuInfo">

                <xsl:element name="tr">

                  <xsl:if test="position() mod 2 != 0">
                    <xsl:attribute name="class">altRowColor</xsl:attribute>
                  </xsl:if>

                  <xsl:choose>
                    <xsl:when test="hpoa:cpuSpeed=0">

                      <th class="propertyName">
                        CPU&#160;<xsl:value-of select="position()"/>
                      </th>
                      <td class="properyValue">
                        <xsl:value-of select="$stringsDoc//value[@key='notPresent']" />
                      </td>
                    </xsl:when>
                    <xsl:otherwise>
                      <th class="propertyName">
                        CPU&#160;<xsl:value-of select="position()"/>
                      </th>
                      <td class="properyValue">
						<xsl:variable name="verIndex" select="concat('procVer', position())" />
						<xsl:variable name="coreIndex" select="concat('procCores', position())" />
						<xsl:choose>
							<xsl:when test="not($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name=$verIndex])=false()">
		                        <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name=$verIndex]"/>
									<xsl:choose>
										<xsl:when test="not($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name=$coreIndex])=false()">
											<xsl:value-of select="concat(' (', $bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name=$coreIndex], ' ', $stringsDoc//value[@key='cores'], ')')"/>
										</xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
		                        <xsl:value-of select="hpoa:cpuType"/>, <xsl:value-of select="hpoa:cpuSpeed"/>&#160;MHz
							</xsl:otherwise>
						</xsl:choose>
                      </td>
                    </xsl:otherwise>
                  </xsl:choose>

                </xsl:element>

              </xsl:for-each>

            </xsl:when>
            <xsl:otherwise>

              <tr class="noDataRow">
                <td colspan="2">
                  <xsl:value-of select="$stringsDoc//value[@key='cpuInfoNotRetrieved']" />
                </td>
              </tr>

            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>

            <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:memory = 0">
              <tr class="noDataRow">
                <td colspan="2">
                  <xsl:value-of select="$stringsDoc//value[@key='memoryInfoNotRetrieved']" />
                </td>
              </tr>
            </xsl:when>
            <xsl:otherwise>

              <tr>
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='memory']" />
                </th>
                <td class="properyValue">
                  <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:memory"/> MB
                </td>
              </tr>

            </xsl:otherwise>

          </xsl:choose>

        </tbody>
      </table>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
