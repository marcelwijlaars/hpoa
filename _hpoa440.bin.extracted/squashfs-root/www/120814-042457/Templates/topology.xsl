<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
  xmlns:hpoa="hpoa.xsd">
  
  <xsl:output method="xml" />

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  
  <!--
    Variables indicating the connection and authentication state
    of each of the enclosures on the link.
  -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="topology" />  
  
  <xsl:include href="../Templates/guiConstants.xsl"/>
  <xsl:include href="../Templates/globalTemplates.xsl"/>
  
  <xsl:template match="*">
  
  <table class="treeTable" border="0" cellpadding="0" cellspacing="0" id="enclosureSelectTable">
      <caption class="displayForAuralBrowsersOnly">Enclosure Topology View</caption>
      <thead>
        <tr class="captionRow">
          <th class="checkboxCell" style="padding:0px 5px 0px 5px;">      
            <xsl:if test="count($topology//hpoa:enclosure) &gt; 1">
              <input type="checkbox" tableid="enclosureSelectTable" id="encSelectAll" name="encSelectAll" />
            </xsl:if>
          </th>
          <th nowrap="true" colspan="2"><xsl:value-of select="$stringsDoc//value[@key='allEnclosures']"/></th>
          <th nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='status']"/></th>
          <th nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='connection']"/></th>
          <th nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='firmware']"/></th>
          <th nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='oaName']"/></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$topology//hpoa:enclosure">
          <!-- don't include enclosures with partial data -->
          <xsl:if test="./hpoa:enclosureUuid">
            
            <xsl:variable name="topologyType">
              <xsl:choose>
                <xsl:when test="./hpoa:encLinkOaArray/hpoa:encLinkOa">2</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

         <xsl:variable name="guiLoginData">
           <xsl:choose>
             <xsl:when test="./hpoa:extraData[@hpoa:name='GuiLoginDetail']='false'">false</xsl:when>
             <xsl:otherwise>true</xsl:otherwise>
           </xsl:choose>
         </xsl:variable>
            
            <xsl:variable name="encNum">
              <xsl:value-of select="./hpoa:enclosureNumber"/>
            </xsl:variable>            
            
            <xsl:variable name="encId">
              <xsl:value-of select="concat('tc_enc', $encNum)"/>
            </xsl:variable>
            
            <xsl:variable name="ipAddress1">
              <xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:ipAddress" />
            </xsl:variable>
            <xsl:variable name="ipAddress2">
              <xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:ipAddress" />
            </xsl:variable>
      
            <xsl:variable name="ipv6Enabled">
              <xsl:value-of select="./hpoa:extraData[@hpoa:name='Ipv6Enabled']" />
            </xsl:variable>
            <xsl:variable name="ipv6Address1">
              <xsl:value-of select="substring-before(./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:extraData[@hpoa:name='ipv6Address'], '/')" />
            </xsl:variable>
            <xsl:variable name="ipv6Address2">
              <xsl:value-of select="substring-before(./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:extraData[@hpoa:name='ipv6Address'], '/')" />
            </xsl:variable>
            
            <xsl:element name="tr">              
              <xsl:choose>
                <xsl:when test="./hpoa:primaryEnclosure='true'">
                  <xsl:attribute name="class">treeTableTitleRowClosed treeTableTopLevel rowHighlight</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">treeTableTitleRowClosed treeTableTopLevel</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:attribute name="style">cursor:default;</xsl:attribute>
              <xsl:attribute name="id"><xsl:value-of select="$encId"/></xsl:attribute>

              <xsl:call-template name="enclosureInfoCells">
                <xsl:with-param name="enclosure" select="." />
                <xsl:with-param name="topologyType" select="$topologyType" />
           <xsl:with-param name="guiLoginData" select="$guiLoginData" />
          </xsl:call-template>

            </xsl:element>
            
            <!-- Enclosure Details -->
         <xsl:if test="$guiLoginData='true'">
            <tr class="contentsRow" parentid="{$encId}" style="display:none;">
              <td colspan="7" style="padding:0px;border:0px;">
                <table class="dataTable" align="center" border="0" cellpadding="0" cellspacing="0">
                  <tr class="captionRow">
                    <th colspan="3" style="background-color:#716B66;border:0px;"><xsl:value-of select="$stringsDoc//value[@key='enclosureInformation']"/></th>
                  </tr>
                  <tr>
                    <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='productName']"/></th>
                    <td class="propertyValue" colspan="2"><xsl:value-of select="./hpoa:enclosureProductName" /></td>                     
                  </tr> 
                  <tr>
                    <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='serialNumber']"/></th>
                    <td class="propertyValue" colspan="2" style="background-color:#eee;"><xsl:value-of select="./hpoa:enclosureSerialNumber" /></td>                     
                  </tr>
                  <tr>
                    <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='serviceIpAddress']"/></th>
                    <td class="propertyValue" colspan="2"><xsl:value-of select="./hpoa:enclosureRackIpAddress" /></td>                     
                  </tr> 
                  <tr>
                    <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='rackName']"/></th>
                    <td class="propertyValue" colspan="2" style="background-color:#eee;border-bottom:1px solid #ccc;"><xsl:value-of select="./hpoa:rackName" /></td>                     
                  </tr>
                  
                  <xsl:if test="./hpoa:extraData[@hpoa:name='enclosureLocationState'] and ./hpoa:extraData[@hpoa:name='enclosureLocationState']!='0' and ./hpoa:extraData[@hpoa:name='enclosureLocationState']!='2'">
                  <tr>
                    <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='rackSerialNumber']"/></th>
                    <td class="propertyValue" colspan="2">
                      <xsl:choose>
                        <xsl:when test="./hpoa:extraData[@hpoa:name='enclosureLocationState']='1'">
                          <xsl:value-of select="./hpoa:extraData[@hpoa:name='enclosureRackIdentifier']"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$stringsDoc//value[@key='dataError']" />&#160;
                          <xsl:call-template name="statusIcon" >
                            <xsl:with-param name="statusCode" select="string('Informational')" />
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>                     
                  </tr>                      
                  <tr>
                    <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='uLocation']"/></th>
                    <td class="propertyValue" colspan="2" style="background-color:#eee;border-bottom:1px solid #ccc;">                        
                      <xsl:choose>
                        <xsl:when test="./hpoa:extraData[@hpoa:name='enclosureLocationState']='1'">
                          <xsl:value-of select="./hpoa:extraData[@hpoa:name='enclosureUPosition']"/>
                        </xsl:when>     
                        <xsl:otherwise>
                          <xsl:value-of select="$stringsDoc//value[@key='dataError']" />&#160;
                          <xsl:call-template name="statusIcon" >
                              <xsl:with-param name="statusCode" select="string('Informational')" />
                          </xsl:call-template>
                        </xsl:otherwise>    
                      </xsl:choose>                       
                    </td>                     
                  </tr>
                 </xsl:if> 
                  <xsl:choose>
                    <xsl:when test="$topologyType='2'">
                      <tr class="captionRow">
                        <th style="background-color:#716B66;border:0px;width:165px;"><xsl:value-of select="$stringsDoc//value[@key='onboardAdministrators']"/></th>
                        <th style="background-color:#716B66;border:0px;width:33%;"><xsl:value-of select="$stringsDoc//value[@key='bay']"/>&#160;1</th>
                        <th style="background-color:#716B66;border:0px;width:33%;"><xsl:value-of select="$stringsDoc//value[@key='bay']"/>&#160;2</th>
                      </tr>
                      <tr>
                        <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='role']"/></th>
                        <td class="propertyValue">
                          <xsl:choose>
                            <xsl:when test="not(./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1])"><xsl:value-of select="$stringsDoc//value[@key='notPresent']"/></xsl:when>
                            <xsl:when test="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:activeOa='true'"><xsl:value-of select="$stringsDoc//value[@key='active']"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='standby']"/></xsl:otherwise>
                          </xsl:choose>
                        </td>   
                        <td class="propertyValue">
                          <xsl:choose>
                            <xsl:when test="not(./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2])"><xsl:value-of select="$stringsDoc//value[@key='notPresent']"/></xsl:when>
                            <xsl:when test="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:activeOa='true'"><xsl:value-of select="$stringsDoc//value[@key='active']"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='standby']"/></xsl:otherwise>
                          </xsl:choose>
                        </td> 
                      </tr> 
                      <tr>
                        <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='name']"/></th>
                        <td class="propertyValue" style="background-color:#eee;"><xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:oaName" /></td>                     
                        <td class="propertyValue" style="background-color:#eee;"><xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:oaName" /></td>
                      </tr>
                      <tr>
                        <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='firmware']"/></th>
                        <td class="propertyValue"><xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:fwVersion" /></td>                     
                        <td class="propertyValue"><xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:fwVersion" /></td>
                      </tr>
                      <tr>
                        <th class="propertyName" style="width:165px;"><xsl:value-of select="$stringsDoc//value[@key='ipAddress']"/></th>
                        <td class="propertyValue" style="background-color:#eee;">
                          <xsl:choose>
                            <xsl:when test="$ipAddress1 = '0.0.0.0'"><i><xsl:value-of select="$stringsDoc//value[@key='acquiring']"/></i></xsl:when>
                            <xsl:otherwise><a target="_new" href="{concat('https://', $ipAddress1, '/')}"><xsl:value-of select="$ipAddress1"/></a></xsl:otherwise>
                          </xsl:choose>
                        </td> 
                        <td class="propertyValue" style="background-color:#eee;">
                          <xsl:choose>
                            <xsl:when test="$ipAddress2 = '0.0.0.0'"><i><xsl:value-of select="$stringsDoc//value[@key='acquiring']"/></i></xsl:when>
                            <xsl:otherwise><a target="_new" href="{concat('https://', $ipAddress2, '/')}"><xsl:value-of select="$ipAddress2"/></a></xsl:otherwise>
                          </xsl:choose>
                        </td>  
                      </tr>
                      <xsl:if test="$ipv6Enabled = 'true'">
                        <tr>
                          <th class="propertyName" style="width:165px;">
                            <xsl:value-of select="$stringsDoc//value[@key='ipv6Address']"/>
                          </th>
                          <td class="propertyValue">
                            <xsl:choose>
                              <xsl:when test="$ipv6Address1 = '0000:0000:0000:0000:0000:0000:0000:0000'">
                                <i>
                                  <xsl:value-of select="$stringsDoc//value[@key='acquiring']"/>
                                </i>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:variable name="ipv6Link1" select="concat('https://&#91;', $ipv6Address1, '&#93;/')" />
                                <xsl:element name="a">
                                  <xsl:attribute name="href">
                                    <xsl:value-of select="$ipv6Link1" />
                                  </xsl:attribute>
                                  <xsl:attribute name="onclick">window.open('<xsl:value-of select="$ipv6Link1" />');return false;</xsl:attribute>
                                  <xsl:value-of select="$ipv6Address1" />
                                </xsl:element>
                                <xsl:if test="starts-with($ipv6Address1, $LL_PREFIX)">
                                  <xsl:call-template name="errorTooltip">
                                    <xsl:with-param name="stringsFileKey">
                                      <xsl:choose>
                                        <xsl:when test="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:activeOa='true'">llIpv6AccessHelpTip</xsl:when>
                                        <xsl:otherwise>llIpv6StandbyAccessHelpTip</xsl:otherwise>
                                      </xsl:choose>
                                    </xsl:with-param>
                                  </xsl:call-template>
                                </xsl:if>
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                          <td class="propertyValue">
                            <xsl:choose>
                              <xsl:when test="$ipv6Address2 = '0000:0000:0000:0000:0000:0000:0000:0000'">
                                <i>
                                  <xsl:value-of select="$stringsDoc//value[@key='acquiring']"/>
                                </i>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:variable name="ipv6Link2" select="concat('https://&#91;', $ipv6Address2, '&#93;/')" />
                                <xsl:element name="a">
                                  <xsl:attribute name="href">
                                    <xsl:value-of select="$ipv6Link2" />
                                  </xsl:attribute>
                                  <xsl:attribute name="onclick">window.open('<xsl:value-of select="$ipv6Link2" />');return false;</xsl:attribute>
                                  <xsl:value-of select="$ipv6Address2" />
                                </xsl:element>
                                <xsl:if test="starts-with($ipv6Address2, $LL_PREFIX)">
                                  <xsl:call-template name="errorTooltip">
                                    <xsl:with-param name="stringsFileKey">
                                      <xsl:choose>
                                        <xsl:when test="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:activeOa='true'">llIpv6AccessHelpTip</xsl:when>
                                        <xsl:otherwise>llIpv6StandbyAccessHelpTip</xsl:otherwise>
                                      </xsl:choose>
                                    </xsl:with-param>
                                  </xsl:call-template>
                                </xsl:if>
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                        </tr>
                      </xsl:if>
                      <tr>
                        <th class="propertyName" style="width:165px;">
                          <xsl:value-of select="$stringsDoc//value[@key='macAddress']"/>
                        </th>
                        <xsl:choose>
                          <xsl:when test="$ipv6Enabled = 'true'">
                            <td class="propertyValue" style="background-color:#eee;">
                              <xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:macAddress" />
                            </td>
                            <td class="propertyValue" style="background-color:#eee;">
                              <xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:macAddress" />
                            </td>
                          </xsl:when>
                          <xsl:otherwise>
                            <td class="propertyValue">
                              <xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=1]/hpoa:macAddress" />
                            </td>
                            <td class="propertyValue">
                              <xsl:value-of select="./hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:bayNumber=2]/hpoa:macAddress" />
                            </td>
                          </xsl:otherwise>
                        </xsl:choose>
                      </tr>
                    </xsl:when>
                    <xsl:otherwise>
                      <tr class="captionRow">
                        <th style="background-color:#716B66;border:0px;">
                          <xsl:value-of select="$stringsDoc//value[@key='onboardAdministrators']"/>
                        </th>
                        <th style="background-color:#716B66;border:0px;width:33%;">&#160;</th>
                        <th style="background-color:#716B66;border:0px;width:33%;">&#160;</th>
                      </tr>
                      <tr>
                        <th class="propertyName" style="width:165px;">
                          <xsl:value-of select="$stringsDoc//value[@key='firmware']"/>
                        </th>
                        <td class="propertyValue" colspan="2" style="font-style:italic;">
                          <xsl:value-of select="$stringsDoc//value[@key='oa-fw-old-topology']"/>
                        </td>
                      </tr>
                    </xsl:otherwise>                      
                  </xsl:choose>
                </table>               
              </td>
            </tr>
         </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </tbody>
    </table>
    
    <div id="helpTooltip" class="popupSmallWrapper">
      <div class="popupSmallTitle"><img alt="" src="/120814-042457/images/icons/help-popup.gif" /></div>
      <div id="tooltipText" class="helpPopupSmallBody"></div>
    </div>
    
    <xsl:if test="$topology//hpoa:extraData[@hpoa:name='maxConnectionsExceeded']">
      <span class="whiteSpacer">&#160;</span><br />
      
      <div style="color:#ff0000;margin-left:10px;">        
        <xsl:call-template name="statusIcon">
          <xsl:with-param name="statusCode" select="$OP_STATUS_IN_SERVICE" />
        </xsl:call-template>&#160;
        <label style="vertical-align:top;">
          <xsl:value-of select="$stringsDoc//value[@key='maxEnclosuresExceeded1']"/>
          <xsl:value-of select="$topology//hpoa:extraData[@hpoa:name='maxConnectionsExceeded']"/>
          <xsl:value-of select="$stringsDoc//value[@key='maxEnclosuresExceeded2']"/>
        </label>
      </div>
    </xsl:if>
    
  </xsl:template>
  
  <!--
    Template used to display an icon for the enclosures on the link.
   -->
  <xsl:template name="enclosureInfoCells">
    
    <xsl:param name="enclosure" />
    <xsl:param name="topologyType" />
    <xsl:param name="guiLoginData" />
    
    <xsl:variable name="loginDetail">
      <xsl:choose>
        <xsl:when test="$enclosure/hpoa:extraData[@hpoa:name='GuiLoginDetail']">  
          <xsl:value-of select="$enclosure/hpoa:extraData[@hpoa:name='GuiLoginDetail']"/>
        </xsl:when>
        <xsl:otherwise>true</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="displayName">
      <xsl:choose>
        <xsl:when test="$enclosure/hpoa:enclosureName != ''">
          <xsl:value-of select="$enclosure/hpoa:enclosureName"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$enclosure/hpoa:enclosureNumber">
              <xsl:value-of select="concat('Enclosure ', $enclosure/hpoa:enclosureNumber)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$stringsDoc//value[@key='unnamedEnclosure']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="encType">
      <xsl:if test="$enclosure/hpoa:enclosureProductName != ''">
        <xsl:value-of select="$enclosure/hpoa:enclosureProductName"/>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="isLocal">
      <xsl:choose>
        <xsl:when test="$enclosure/hpoa:primaryEnclosure='true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="uuid">
      <xsl:value-of select="$enclosure/hpoa:enclosureUuid"/>
    </xsl:variable>
    
    <xsl:variable name="url">
      <xsl:value-of select="$enclosure/hpoa:enclosureUrl"/>
    </xsl:variable>
    
    <td style="padding:5px;vertical-align:middle;" class="checkboxCell">
      <xsl:element name="input">
        <xsl:attribute name="type">checkbox</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="$displayName" />
        </xsl:attribute>
        <xsl:attribute name="encNum">
          <xsl:value-of select="$enclosure/hpoa:enclosureNumber" />
        </xsl:attribute>
        <xsl:attribute name="local">
          <xsl:value-of select="$isLocal" />
        </xsl:attribute>
        <xsl:attribute name="authenticated">
          <xsl:value-of select="false" />
        </xsl:attribute>
        <xsl:attribute name="rowselector">yes</xsl:attribute>
        <xsl:if test="$isLocal='true'">
          <xsl:attribute name="checked">true</xsl:attribute>
        </xsl:if>
        <xsl:if test="$uuid">
          <xsl:choose>
            <xsl:when test="$uuid = ''">
              <xsl:attribute name="uuid"><xsl:value-of select="$url"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="uuid"><xsl:value-of select="$uuid"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>          
        </xsl:if>
        
        <!-- special attribs to make the local row permanently selected -->
        <xsl:if test="$isLocal='true'">
          <xsl:attribute name="disabled">true</xsl:attribute>
          <xsl:attribute name="allowRowSelect">false</xsl:attribute>
        </xsl:if>
      </xsl:element>
    </td>
    
    <!-- tree disclosure cell -->
    <td class="treeControlTopPadded14">
      <xsl:if test="not($enclosure/hpoa:enclosureClone) and $guiLoginData='true'">
        <div class="treeTitle" style="width:14px;"><div class="treeControl"></div></div> 
      </xsl:if>
    </td>
    
    <!-- Icon with label table cell -->
    <td style="padding:0px;vertical-align:middle;" nowrap="true">      
      <table valign="top" cellpadding="8" cellspacing="0" border="1" style="border: 0px none;">
        <tr>
          <td style="border: 0px none;padding:5px;">
            <xsl:call-template name="enclosureIcon">
              <xsl:with-param name="encType">
                <xsl:choose>
                  <xsl:when test="contains($encType, 'c7000')">0</xsl:when>
                  <xsl:when test="contains($encType, 'c3000')">1</xsl:when>
                  <xsl:otherwise>-1</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name="isTower" select="($enclosure/hpoa:extraData[@hpoa:name='isTower'] = 'true') or ($enclosure/hpoa:extraData[@hpoa:name='LcdPartNumber'] = '458075-001')" />
              <xsl:with-param name="isLocal" select="$isLocal" />
              <xsl:with-param name="isAuthenticated" select="'true'" /><!-- phony value to prevent padlocks -->
              <xsl:with-param name="productName" select="$encType" />
            </xsl:call-template>
          </td>
          <td style="border: 0px none;vertical-align:middle;" nowrap="true">
            <b><xsl:value-of select="$displayName" /></b>
          </td>
        </tr>
      </table>
    </td>
    
    <td style="padding:10px;vertical-align:middle;" nowrap="true">
      <xsl:choose>
        <xsl:when test="$topologyType='2' and $loginDetail = 'true'">
          <xsl:call-template name="getStatusLabel">
            <xsl:with-param name="statusCode" select="$enclosure/hpoa:enclosureStatus" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='n/a']"/></xsl:otherwise>
      </xsl:choose>
    </td>

    <!-- Security table cell -->
    <td style="padding:10px;vertical-align:middle;" nowrap="true">
      <xsl:choose>
        <xsl:when test="$isLocal='true'">
          <xsl:value-of select="$stringsDoc//value[@key='primary']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$stringsDoc//value[@key='linked']"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$enclosure/hpoa:extraData[@hpoa:name='FipsSecurityStatus1']='FIPS_ERROR_LDAP_CERT_SIZE' and $enclosure/hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON'">
          <img style="vertical-align:middle;margin-left:14px;" src="/120814-042457/images/secure_degraded.gif" title="{$stringsDoc//value[@key='fipsErrorLdapCertSize']}" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$enclosure/hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON'">
            <img style="vertical-align:middle;margin-left:14px;" src="/120814-042457/images/secure.gif" title="{$stringsDoc//value[@key='fipsEnabled']}" />
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
	  <xsl:choose>
        <xsl:when test="$enclosure/hpoa:extraData[@hpoa:name='FipsSecurityStatus1']='FIPS_ERROR_LDAP_CERT_SIZE' and $enclosure/hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
          <img style="vertical-align:middle;margin-left:14px;" src="/120814-042457/images/debug_degraded.gif" title="{$stringsDoc//value[@key='fipsErrorLdapCertSize']}" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$enclosure/hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
            <img style="vertical-align:middle;margin-left:14px;" src="/120814-042457/images/fips-debug.gif" title="{$stringsDoc//value[@key='fipsDebugEnabled']}" />
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$enclosure/hpoa:extraData[@hpoa:name='TwoFactorEnabled'] = 'true'">
        <img style="vertical-align:middle;margin-left:14px;" title="{$stringsDoc//value[@key='twoFactorSecurity']}" src="/120814-042457/images/card-reader.gif" />
      </xsl:if>
    </td>

    <xsl:element name="td">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('enc', $enclosure/hpoa:enclosureNumber, 'fw')"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$enclosure/hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:activeOa = 'true']/hpoa:fwVersion">
          <xsl:attribute name="style">padding:10px;vertical-align:middle;color:#000;</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="style">padding:10px;vertical-align:middle;color:#cc0000;</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>      
      <xsl:attribute name="nowrap">true</xsl:attribute>
      <xsl:if test="$enclosure/hpoa:encLinkOaArray/hpoa:encLinkOa/hpoa:activeOa = 'true'">
        <xsl:choose>
          <xsl:when test="$enclosure/hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:activeOa = 'true']/hpoa:fwVersion = '[Access Denied]'">
            &#160;
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$enclosure/hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:activeOa = 'true']/hpoa:fwVersion"/></xsl:otherwise>
        </xsl:choose>        
      </xsl:if>
    </xsl:element>

    <xsl:element name="td">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('enc', $enclosure/hpoa:enclosureNumber, 'oaName')"/>
      </xsl:attribute>
      <xsl:attribute name="style">padding:10px;vertical-align:middle;</xsl:attribute>
      <xsl:attribute name="nowrap">true</xsl:attribute>
      <xsl:if test="$enclosure/hpoa:encLinkOaArray/hpoa:encLinkOa/hpoa:activeOa = 'true'">
        <xsl:variable name="oaLinkName">
      <xsl:value-of select="$enclosure/hpoa:encLinkOaArray/hpoa:encLinkOa[hpoa:activeOa = 'true']/hpoa:oaName"/>
    </xsl:variable>
    <xsl:if test="$oaLinkName != ''">
          <a href="{concat('https://', $oaLinkName, '/')}" target="_new"><xsl:value-of select="$oaLinkName"/></a>
        </xsl:if>
      </xsl:if>
    </xsl:element>


  </xsl:template>
  
</xsl:stylesheet>

