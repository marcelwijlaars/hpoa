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
  <xsl:param name="bladeStatusDoc" />
  <xsl:param name="bladeInfoDoc" />
  <xsl:param name="bladeThermalInfoArrayDoc" />
  <xsl:param name="partnerProduct" />
  <xsl:param name="partnerProduct2" />
  <xsl:param name="thermalsOnly">false</xsl:param>
  <xsl:param name="firmwareMgmtSupported">false</xsl:param>
  <xsl:param name="bladeMpInfoDoc" />
  <xsl:param name="isMonarch" />
  <xsl:param name="domainInfoDoc" />
  
  <xsl:template match="*">

    <xsl:variable name="bladeType" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bladeType" />
    <xsl:variable name="associatedBlade" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='AssociatedBlade']" />
   <xsl:variable name="associatedBlade2" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='AssociatedBlade2']" />
    <xsl:variable name="bladeStatus" select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:operationalStatus" />
  
    <xsl:if test="$thermalsOnly='false'">

      <xsl:if test="($bladeType='BLADE_TYPE_SERVER') or ($bladeInfoDoc//hpoa:bladeInfo/hpoa:productId = '8213') or contains($bladeInfoDoc//hpoa:bladeInfo/hpoa:name, 'SB50')">

      <xsl:value-of select="$stringsDoc//value[@key='serverManagement']" /><br />
      <span class="whiteSpacer">&#160;</span>
      <br />

    <xsl:variable name="monarchPresent" select="count($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='monarchBlade']) &gt; 0" />
      
      <div class="groupingBox">

        <ul>
      <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:productId != '8213' and not(contains($bladeInfoDoc//hpoa:bladeInfo/hpoa:name, 'SB50')) and (($monarchPresent and $isMonarch) or not($monarchPresent))">
        <li>
          <a href="javascript:top.mainPage.getHiddenFrame().selectDevice(bayNum, MP(), encNum, true);">iLO</a>
        </li>
      </xsl:if>
      <!-- AMC Telco Blade -->
      <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:productId = '8213'">
        <li>
          <a href="javascript:top.mainPage.getHiddenFrame().selectDevice(bayNum, MP(), encNum, true);"><xsl:value-of select="$stringsDoc//value[@key='managementConsole']" /></a>
        </li>
      </xsl:if>
      <li>
        <a href="javascript:top.mainPage.getHiddenFrame().selectDevice(bayNum, PM_BLADE(), encNum, true);"><xsl:value-of select="$stringsDoc//value[@key='portMapping-Info']" /></a>
      </li>
          <xsl:if test="$firmwareMgmtSupported = 'true'">          
            <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:productId != '8213' and not(contains($bladeInfoDoc//hpoa:bladeInfo/hpoa:name, 'SB50')) and contains($bladeInfoDoc//hpoa:bladeInfo/hpoa:productId, '8224')">
              <li>
                <a href="javascript:top.mainPage.getHiddenFrame().selectDevice(bayNum, 'fw_blade', encNum, true);"><xsl:value-of select="$stringsDoc//value[@key='firmware']" /></a>
              </li>
            </xsl:if>
          </xsl:if>
        </ul>
      </div>

      <span class="whiteSpacer">&#160;</span>
      <br />
      <span class="whiteSpacer">&#160;</span>
      <br />
      
    </xsl:if>
    
    <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
      <TBODY>

        <xsl:variable name="delayRemaining" select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:extraData[@hpoa:name='PowerDelayRemaining']" />
        <xsl:variable name="systemHealth" select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:extraData[@hpoa:name='SystemHealth']" />

        <xsl:if test="$systemHealth != '' and $systemHealth != 'UNKNOWN'">
          <TR class="altRowColor">
            <TH class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='systemHealth']" />
            </TH>
            <TD class="propertyValue">

              <xsl:call-template name="getStatusLabel">
                <xsl:with-param name="statusCode" select="$systemHealth" />
              </xsl:call-template>

            </TD>
          </TR>
        </xsl:if>
        <TR>
          <TH class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='status']" />
          </TH>
          <TD class="propertyValue">

            <xsl:call-template name="getStatusLabel">
              <xsl:with-param name="statusCode" select="$bladeStatus" />
            </xsl:call-template>

          </TD>
        </TR>
        <TR class="altRowColor">
          <TH class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='statusPowered']" />
          </TH>
          <TD class="propertyValue">

            <xsl:choose>
              <xsl:when test="number($delayRemaining) &gt; 0">
                <xsl:value-of select="$stringsDoc//value[@key='delayed']" />
              </xsl:when>
              <xsl:when test="number($delayRemaining)=-1">
                <xsl:value-of select="$stringsDoc//value[@key='delayed']" /> - <xsl:value-of select="$stringsDoc//value[@key='noPoweron']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="getPowerLabel">
                  <xsl:with-param name="powered" select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:powered" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            
          </TD>
        </TR>

        <xsl:if test="number($delayRemaining) &gt; 0">
          <TR>
            <TH class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='delayRemaining']" />
            </TH>
            <TD class="propertyValue">
              <xsl:value-of select="$delayRemaining"/>
            </TD>
          </TR>
        </xsl:if>

        <xsl:element name="TR">

          <xsl:variable name="rowClass">
            <xsl:if test="number($delayRemaining) &gt; 0">altRowColor</xsl:if>
          </xsl:variable>

          <xsl:attribute name="class"><xsl:value-of select="$rowClass"/></xsl:attribute>

          <TH class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='powerAllocated']" />
          </TH>
          <TD class="propertyValue">
            <xsl:value-of select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:powerConsumed" />&#160;
            <xsl:value-of select="$stringsDoc//value[@key='watts']" />
          </TD>
          
        </xsl:element>

        <tr>
          <TH class="propertyName">
            <xsl:value-of select="$stringsDoc//value[@key='virtualFan:']" />
          </TH>
          <TD class="propertyValue">
            <xsl:value-of select="$bladeStatusDoc//hpoa:bladeStatus/hpoa:extraData[@hpoa:name='VirtualFan']" />%
          </TD>
        </tr>
        
        <xsl:if test="$associatedBlade != 0 or $associatedBlade2 != 0">
          <TR>
            <TH class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='partnerDevice']" />
            </TH>
            <TD class="propertyValue">

          <xsl:if test="$associatedBlade != 0">
            <xsl:choose>
              <xsl:when test="$partnerProduct != ''">
                <xsl:element name="a">
                  <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$associatedBlade"/>);</xsl:attribute>
                  <xsl:value-of select="$partnerProduct"/>
                  (<xsl:value-of select="$stringsDoc//value[@key='bay']" /> <xsl:value-of select="$associatedBlade"/>)
                </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='bay']" /> <xsl:value-of select="$associatedBlade"/>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          
          <xsl:if test="$associatedBlade2 != 0">
            <xsl:choose>
              <xsl:when test="$partnerProduct2 != ''">
                <xsl:element name="a">
                  <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$associatedBlade2"/>);</xsl:attribute>
                  <xsl:value-of select="$partnerProduct2"/>
                  (<xsl:value-of select="$stringsDoc//value[@key='bay']" /> <xsl:value-of select="$associatedBlade2"/>)
                </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='bay']" /> <xsl:value-of select="$associatedBlade2"/>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
              
            </TD>
          </TR>
        </xsl:if>
    
      </TBODY>
    </table>

    <span class="whiteSpacer">&#160;</span>
    <br />
    <div align="right">
      <div class='buttonSet'>
        <div class='bWrapperUp'>
          <div>
            <div>
              <button type='button' class='hpButton' id="btnApplyDateTime" onclick="refreshTabContent();">
                <xsl:value-of select="$stringsDoc//value[@key='refresh']" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

     <xsl:variable name="bayNumber" select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:bayNumber" />
     <xsl:variable name="domainSize" select="$domainInfoDoc//hpoa:domainInfo/hpoa:domains//hpoa:bays[hpoa:bay=$bayNumber]/../hpoa:size" />
     
     <xsl:if test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='domainNumber'] != '' and number($domainSize) &gt; 1">
     
     <span class="whiteSpacer">&#160;</span>
     <br />
     <span class="whiteSpacer">&#160;</span>
     <br />

     <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" ID="Table7">
       <caption>Multi-Blade Server Information</caption>
       <tbody>
         <tr class="altRowColor">
           <th class="propertyName">
             <xsl:value-of select="$stringsDoc//value[@key='productName']"/>
           </th>
           <td class="propertyValue">
             <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:name"/>
           </td>
         </tr>
         <tr>
           <th class="propertyName">
             Monarch Blade:
           </th>
           <td class="propertyValue">
             <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='monarchBlade']"/>
           </td>
         </tr>
         <tr class="altRowColor">
           <th class="propertyName">
             All Blades:
           </th>
           <td class="propertyValue">
             <xsl:choose>
               <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='auxiliaryBlades']=''">
                 <xsl:value-of select="$bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='monarchBlade']"/>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:value-of select="concat($bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='monarchBlade'], ',', $bladeInfoDoc//hpoa:bladeInfo/hpoa:extraData[@hpoa:name='auxiliaryBlades'])"/>
               </xsl:otherwise>
             </xsl:choose>
           </td>
         </tr>
       </tbody>
     </table>
    </xsl:if>
     
     <span class="whiteSpacer">&#160;</span>
     <br />

    <xsl:for-each select="$bladeStatusDoc//hpoa:bladeStatus">

      <xsl:if test="count(hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED')])&gt;0 and count(hpoa:diagnosticChecks/*[not(node()='NOT_RELEVANT')])&gt;0">

        <xsl:choose>
          <xsl:when test="$bladeType='BLADE_TYPE_STORAGE' or $bladeType='BLADE_TYPE_IO'">
            <xsl:call-template name="diagnosticStatusView">
              <xsl:with-param name="statusCode" select="$bladeStatus" />
              <xsl:with-param name="deviceType" select="'BLADE_TYPE_STORAGE'" />
              <xsl:with-param name="imlErrorClass" select="hpoa:extraData[@hpoa:name='ImlErrorClasses']" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            
            <xsl:choose>
              <xsl:when test="$bladeInfoDoc//hpoa:bladeInfo/hpoa:productId=8224">
                <xsl:call-template name="diagnosticStatusView">
                  <xsl:with-param name="statusCode" select="$bladeStatus" />
                  <xsl:with-param name="deviceType" select="'SERVER_P'" />
                  <xsl:with-param name="imlErrorClass" select="hpoa:extraData[@hpoa:name='ImlErrorClasses']" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="diagnosticStatusView">
                  <xsl:with-param name="statusCode" select="$bladeStatus" />
                  <xsl:with-param name="deviceType" select="'SERVER'" />
                  <xsl:with-param name="imlErrorClass" select="hpoa:extraData[@hpoa:name='ImlErrorClasses']" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:otherwise>
        </xsl:choose>

        
      </xsl:if>

    </xsl:for-each>
    
    <div id="helpTooltip" class="popupSmallWrapper">
      <div class="popupSmallTitle"><img alt="" src="/120814-042457/images/icons/help-popup.gif" /></div>
      <div id="tooltipText" class="helpPopupSmallBody"></div>
    </div>	
    
    <span class="whiteSpacer">&#160;</span>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
      <div id="bladeThermalTable"> 
        <xsl:call-template name="thermalGraph">
          <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
          <xsl:with-param name="bladeStatusDoc" select="$bladeStatusDoc" />
          <xsl:with-param name="bladeThermalInfoArrayDoc" select="$bladeThermalInfoArrayDoc" />
        </xsl:call-template>
      </div>      
    </xsl:if>
    <xsl:if test="$thermalsOnly='true'">
      <xsl:call-template name="thermalGraph">
        <xsl:with-param name="bladeInfoDoc" select="$bladeInfoDoc" />
        <xsl:with-param name="bladeStatusDoc" select="$bladeStatusDoc" />
        <xsl:with-param name="bladeThermalInfoArrayDoc" select="$bladeThermalInfoArrayDoc" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
  <!-- the table for the themal bars -->
  <xsl:template name="thermalGraph">
     <xsl:param name="bladeInfoDoc" />
     <xsl:param name="bladeStatusDoc" />
     <xsl:param name="bladeThermalInfoArrayDoc" />
    
     <table cellpadding="0" cellspacing="0" border="0" class="dataTable">
      <caption><xsl:value-of select="$stringsDoc//value[@key='tempSensors']" /></caption>
      <thead>
        <tr class="captionRow">
          <th style="vertical-align:middle;padding-right:10px;white-space:nowrap;" width="1%">
            <xsl:value-of select="$stringsDoc//value[@key='location']" />
          </th>
          <th style="vertical-align:middle;padding-right:10px;white-space:nowrap;" width="1%">
            <xsl:value-of select="$stringsDoc//value[@key='status']" />
          </th>
          <th style="vertical-align:middle;">
            <xsl:value-of select="$stringsDoc//value[@key='temperature']" />
          </th>
        </tr>
      </thead>

      <xsl:choose>
        <xsl:when test="count($bladeThermalInfoArrayDoc//hpoa:bladeThermalInfoArray/hpoa:bladeThermalInfo) &gt; 0">

          <xsl:for-each select="$bladeThermalInfoArrayDoc//hpoa:bladeThermalInfoArray/hpoa:bladeThermalInfo">
            
            <xsl:variable name="sensorPresent" select="hpoa:extraData[@hpoa:name = 'SensorPresent'] = 'true'"/>

            <xsl:variable name="supportsCaution">
              <xsl:value-of select="$sensorPresent and not(hpoa:cautionThreshold = '0' or hpoa:cautionThreshold = '125')"/>
            </xsl:variable>
            
            <xsl:variable name="supportsCritical">
              <xsl:value-of select="$sensorPresent and not(hpoa:criticalThreshold = '0' or hpoa:criticalThreshold = '125')"/>
            </xsl:variable>

            <xsl:variable name="cautionThreshold">
              <xsl:choose>
                <xsl:when test="$supportsCaution = 'true'">
                  <xsl:value-of select="hpoa:cautionThreshold"/>
                </xsl:when>
                <xsl:otherwise>125</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="criticalThreshold">
              <xsl:choose>
                <xsl:when test="$supportsCritical = 'true'">
                  <xsl:value-of select="hpoa:criticalThreshold"/>
                </xsl:when>
                <xsl:otherwise>125</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="currentPercentage">
              <xsl:choose>
                <xsl:when test="round(number(hpoa:temperatureC) div number($criticalThreshold)*100) &gt; 100">
                  <xsl:value-of select="100"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="round(number(hpoa:temperatureC) div number($criticalThreshold)*100)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="cautionPercentage" select="round(number($cautionThreshold) div number($criticalThreshold)*100)" />
            <xsl:variable name="criticalPercentage" select="100" />

            <xsl:variable name="cssClass">
              <xsl:choose>
                <xsl:when test="$currentPercentage &gt;= $criticalPercentage">percentageBarCritical</xsl:when>
                <xsl:when test="$currentPercentage &gt;= $cautionPercentage">percentageBarWarning</xsl:when>
                <xsl:otherwise>percentageBar</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="tempStatus">
              <xsl:choose>
                <xsl:when test="not($sensorPresent)">
                  <xsl:value-of select="$OP_STATUS_IN_SERVICE"/>
                </xsl:when>
                <xsl:when test="$currentPercentage &gt;= $criticalPercentage">
                  <xsl:value-of select="$OP_STATUS_NON_RECOVERABLE_ERROR"/>
                </xsl:when>
                <xsl:when test="$currentPercentage &gt;= $cautionPercentage">
                  <xsl:value-of select="$OP_STATUS_DEGRADED"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$OP_STATUS_OK"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:element name="tr">

              <xsl:if test="position() mod 2 != 0">
                <xsl:attribute name="class">altRowColor</xsl:attribute>
              </xsl:if>

              <td style="vertical-align:middle;padding-right:10px;white-space:nowrap;" width="1%">
                <xsl:value-of select="hpoa:description"/>
                <xsl:if test="count(hpoa:extraData[@hpoa:name='idString']) &gt; 0"> - <xsl:value-of select="hpoa:extraData[@hpoa:name='idString']"/></xsl:if>
              </td>
              <td align="center">
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$tempStatus" />
                </xsl:call-template>
              </td>
              <td>

                <div class="percentageOutline">

                  <xsl:choose>
                    <xsl:when test="hpoa:extraData[@hpoa:name='SensorPresent'] = 'true'">
                      
                      <xsl:element name="div">

                        <xsl:attribute name="devID">
                          <xsl:value-of select="concat('TempSensor', hpoa:sensorNumber)" />
                        </xsl:attribute>
                        <xsl:attribute name="class">
                          <xsl:value-of select="$cssClass" />
                        </xsl:attribute>
                        <xsl:attribute name="style">width:<xsl:value-of select="$currentPercentage" />%;</xsl:attribute>
                        <xsl:attribute name="title"><xsl:value-of select="hpoa:description" /></xsl:attribute>
                        
                        <xsl:value-of select="hpoa:temperatureC" />&#176;C&#160;
                        
                      </xsl:element>
                      
                    </xsl:when>
                    <xsl:otherwise>
                      N/A&#160;
                    </xsl:otherwise>
                  </xsl:choose>
                  
                </div>

                <xsl:if test="$supportsCaution = 'true'">

                  <div class="limitIndicatorOutline">
                    <xsl:element name="div">
                      <xsl:attribute name="class">limitIndicator</xsl:attribute>
                      <xsl:attribute name="style">
                        width:<xsl:value-of select="$cautionPercentage"/>%;border-color:orange;
                      </xsl:attribute>
                      <xsl:value-of select="$stringsDoc//value[@key='caution:']" />&#160;<xsl:value-of select="$cautionThreshold"/>&#176;C&#160;
                    </xsl:element>
                  </div>
                </xsl:if>

                <xsl:if test="$supportsCritical = 'true'">

                  <div class="limitIndicatorOutline" style="margin-top:3px;margin-bottom:3px;">
                    <xsl:element name="div">
                      <xsl:attribute name="class">limitIndicator</xsl:attribute>
                      <xsl:attribute name="style">width:100%</xsl:attribute>
                      <xsl:value-of select="$stringsDoc//value[@key='critical:']" />&#160;<xsl:value-of select="$criticalThreshold" />&#176;C&#160;
                    </xsl:element>
                  </div>

                </xsl:if>
              </td>

            </xsl:element>

          </xsl:for-each>
          
        </xsl:when>
        <xsl:otherwise>
          <tr class="noDataRow">
            <td colspan="4"><xsl:value-of select="$stringsDoc//value[@key='unableToReadTempData']" /></td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
      
    </table>
    
  </xsl:template>

</xsl:stylesheet>
