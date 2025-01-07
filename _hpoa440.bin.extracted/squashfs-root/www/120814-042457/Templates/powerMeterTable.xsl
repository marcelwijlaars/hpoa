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
  <xsl:param name="sortOrder" />
  <xsl:param name="presentPower" />
  <xsl:param name="avgUnits" />
  <xsl:param name="lineVoltage" />
  <xsl:param name="isRedundant" />
  <xsl:param name="powerUnits" />
  <xsl:param name="powerScaleFactor" />
  <xsl:variable name="sampleCount" select="//hpoa:enclosurePowerStatistics/hpoa:sampleCount" />
  
  <xsl:variable name="powerData" select="//hpoa:enclosurePowerRecords/*[name() = 'hpoa:enclosurePowerRecord']" />
  <xsl:variable name="groupCapData" select="//hpoa:extraData[starts-with(@hpoa:name, 'groupCap_')]" />
  <xsl:variable name="groupDeratedData" select="//hpoa:extraData[starts-with(@hpoa:name, 'groupDerated_')]" />
  <xsl:variable name="groupRatedData" select="//hpoa:extraData[starts-with(@hpoa:name, 'groupRated_')]" />

  <xsl:template match="*">

    <xsl:variable name="numSidesSuffix">
      <xsl:choose>
        <xsl:when test="$isRedundant='true'">
          <br />
          <xsl:value-of select="$stringsDoc//value[@key='leftPlusRightSuffixStart']" />
          <a href="#LeftRightNote">
            <span style="vertical-align: super;">*</span>
          </a>
          <xsl:value-of select="$stringsDoc//value[@key='leftPlusRightSuffixEnd']" />
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
      <caption>
        <xsl:value-of select="$stringsDoc//value[@key='encPowerSummary']" />
      </caption>
      <tbody>

        <xsl:for-each select="//hpoa:enclosurePowerStatistics">

          <tr>
            <th class="propertyName" style="width:220px;">
              <xsl:value-of select="$stringsDoc//value[@key='samples']" />
            </th>
            <td class="propertyValue">
              <xsl:value-of select="hpoa:sampleCount"/>
            </td>
          </tr>
          <tr class="altRowColor">
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='average']" />&#160;<xsl:value-of select="$powerUnits"/>
            </th>
            <td class="propertyValue">
              <xsl:value-of select="number(round(hpoa:averageWattage*$powerScaleFactor))"/>
            </td>
          </tr>
          <tr>
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='minimum']" />&#160;<xsl:value-of select="$powerUnits"/>
            </th>
            <td class="propertyValue">
              <xsl:value-of select="number(round(hpoa:minWattage*$powerScaleFactor))"/>
            </td>
          </tr>
          <tr class="altRowColor">
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='maximum']" />&#160;<xsl:value-of select="$powerUnits"/>
                                    <xsl:copy-of select="$numSidesSuffix"/>
            </th>
            <td class="propertyValue">
              <xsl:value-of select="number(round(hpoa:peakWattage*$powerScaleFactor))"/>
            </td>
          </tr>
          <tr>
            <th class="propertyName">
              <xsl:value-of select="$stringsDoc//value[@key='presentPwr']" />
            </th>
            <td class="propertyValue">
              <xsl:value-of select="number(round($presentPower*$powerScaleFactor))"/>
            </td>
          </tr>

        </xsl:for-each>

      </tbody>
    </table>

    <span class="whiteSpacer">&#160;</span>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />

    <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
      <caption>
        <xsl:value-of select="$stringsDoc//value[@key='encPowerDetail']" />
      </caption>
      <thead>
        <tr class="captionRow">
          <xsl:choose>
            <xsl:when test="$sortOrder='asc'">
              <th class="sortedAscending" onclick="sortTable();">
                <xsl:value-of select="$stringsDoc//value[@key='date']" />
              </th>
            </xsl:when>
            <xsl:otherwise>
              <th class="sortedDescending" onclick="sortTable();">
                <xsl:value-of select="$stringsDoc//value[@key='date']" />
              </th>
            </xsl:otherwise>
          </xsl:choose>
          <th>
            <xsl:value-of select="$stringsDoc//value[@key='time']" />
          </th>
          <th>
            <xsl:value-of select="$stringsDoc//value[@key='peak']" />&#160;<xsl:value-of select="$powerUnits"/><xsl:copy-of select="$numSidesSuffix"/>
          </th>
          <th>
            <xsl:value-of select="$stringsDoc//value[@key='min']" />&#160;<xsl:value-of select="$powerUnits"/>
          </th>
          <th>
            <xsl:value-of select="$stringsDoc//value[@key='average']" />&#160;<xsl:value-of select="$powerUnits"/>
          </th>
          <th>
            <xsl:value-of select="$stringsDoc//value[@key='cap']" />&#160;<xsl:value-of select="$powerUnits"/>
          </th>
          <th>
            <xsl:value-of select="$stringsDoc//value[@key='derated']" />&#160;<xsl:value-of select="$powerUnits"/>
          </th>
          <th>
            <xsl:value-of select="$stringsDoc//value[@key='rated']" />&#160;<xsl:value-of select="$powerUnits"/>
          </th>
        </tr>
      </thead>
      <tbody>

        <xsl:choose>
          <xsl:when test="$sortOrder='asc'">
            <xsl:for-each select="$powerData//.">
              <xsl:sort select="@hpoa:timeStamp" order="ascending"/>
              <xsl:call-template name="powerDetailTableRow" />
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$powerData//.">              
              <xsl:sort select="@hpoa:timeStamp" order="descending"/>
              <xsl:call-template name="powerDetailTableRow" />
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>

      </tbody>
    </table>
    <br />
    <table style="width:100%;">
      <tr>
        <td align="left">
          <xsl:value-of select="$stringsDoc//value[@key='showValuesIn']" />
        </td>
        <td align="left">
          <select name="avgUnits" id="avgUnits" onchange="convertTable();">
            <xsl:element name="option">
              <xsl:if test="$avgUnits='watts'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">watts</xsl:attribute>
              &#160;<xsl:value-of select="$stringsDoc//value[@key='watts']" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$avgUnits='btus'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">btus</xsl:attribute>
              &#160;<xsl:value-of select="$stringsDoc//value[@key='btus']" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$avgUnits='amps'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">amps</xsl:attribute>
              &#160;<xsl:value-of select="$stringsDoc//value[@key='amps']" />
            </xsl:element>
          </select>
        </td>
      </tr>
      <tr>
        <td align="left">
          <xsl:value-of select="$stringsDoc//value[@key='lineVoltageLabel']" />
        </td>
        <td align="left">
          <select name="lineVoltage" id="lineVoltage" onchange="convertTable();">
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='100'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">100</xsl:attribute>
              <xsl:value-of select="'100V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='110'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">110</xsl:attribute>
              <xsl:value-of select="'110V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='115'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">115</xsl:attribute>
              <xsl:value-of select="'115V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='120'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">120</xsl:attribute>
              <xsl:value-of select="'120V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='200'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">200</xsl:attribute>
              <xsl:value-of select="'200V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='208'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">208</xsl:attribute>
              <xsl:value-of select="'208V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='220'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">220</xsl:attribute>
              <xsl:value-of select="'220V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='230'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">230</xsl:attribute>
              <xsl:value-of select="'230V'" />
            </xsl:element>
            <xsl:element name="option">
              <xsl:if test="$lineVoltage='240'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="value">240</xsl:attribute>
              <xsl:value-of select="'240V'" />
            </xsl:element>
          </select>
        </td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td>
          <table align="right" style="width:80%;">
            <tr>
              <td>
                <div class="buttonSet">
                  <div class="bWrapperUp">
                    <div>
                      <div>
                        <button class="hpButton" id="btnRefreshTable" name="btnRefreshTable" onclick="return refreshPageTable();">
                          <xsl:value-of select="$stringsDoc//value[@key='refreshPage']" />
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>

    <xsl:if test="$isRedundant='true'">
      <p style="width: 576px;margin-left:10px;">
        <a name="LeftRightNote"></a>
        <b>
          <i>*</i>
        </b>
        <xsl:value-of select="$stringsDoc//value[@key='leftRightNote']" />
      </p>
    </xsl:if>

  </xsl:template>

  <xsl:template name="powerDetailTableRow">

    <xsl:variable name="cap_idx">
      <xsl:choose>
        <xsl:when test="$sortOrder='asc'">
          <xsl:value-of select="position() - 1" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number($sampleCount)-position()" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="groupCapNodeValue" select="//hpoa:enclosurePowerRecords/hpoa:extraData[@hpoa:name = concat('groupCap_', $cap_idx)]" />
    <xsl:variable name="groupDeratedNodeValue" select="//hpoa:enclosurePowerRecords/hpoa:extraData[@hpoa:name = concat('groupDerated_', $cap_idx)]" />
    <xsl:variable name="groupRatedNodeValue" select="//hpoa:enclosurePowerRecords/hpoa:extraData[@hpoa:name = concat('groupRated_', $cap_idx)]" /> 
    
    <xsl:variable name="capValue">
      <xsl:choose>
        <xsl:when test="number($groupCapNodeValue)">
          <xsl:value-of select="$groupCapNodeValue" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="deratedValue">
      <xsl:choose>
        <xsl:when test="number($groupDeratedNodeValue)">
          <xsl:value-of select="$groupDeratedNodeValue" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ratedValue">
      <xsl:choose>
        <xsl:when test="number($groupRatedNodeValue)">
          <xsl:value-of select="$groupRatedNodeValue" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="timeStamp" select="@hpoa:timeStamp" />
    <xsl:variable name="tsDate" select="substring-before($timeStamp, 'T')" />
    <xsl:variable name="tsTime" select="substring-after($timeStamp, 'T')" />

    <xsl:element name="tr">

      <xsl:if test="position() mod 2 != 0">
        <xsl:attribute name="class">altRowColor</xsl:attribute>
      </xsl:if>

      <td class="sorted">
        <xsl:value-of select="$tsDate"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="contains($tsTime, '-')">
            <xsl:value-of select="substring-before($tsTime, '-')" />
          </xsl:when>
          <xsl:when test="contains($tsTime, '+')">
            <xsl:value-of select="substring-before($tsTime, '+')" />
          </xsl:when>
          <xsl:when test="contains($tsTime, 'Z')">
            <xsl:value-of select="substring-before($tsTime, 'Z')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$tsTime" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="round(@hpoa:peakWattage*$powerScaleFactor)"/>
      </td>
      <td>
        <xsl:value-of select="round(@hpoa:minWattage*$powerScaleFactor)"/>
      </td>
      <td>
        <xsl:value-of select="round(@hpoa:averageWattage*$powerScaleFactor)"/>
      </td>
      <td>
        <xsl:value-of select="round($capValue*$powerScaleFactor)"/>
      </td>
      <td>
        <xsl:value-of select="round($deratedValue*$powerScaleFactor)"/>
      </td>
      <td>
        <xsl:value-of select="round($ratedValue*$powerScaleFactor)"/>
      </td>

    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
