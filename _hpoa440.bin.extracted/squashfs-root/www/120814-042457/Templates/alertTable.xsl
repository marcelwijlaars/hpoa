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

  <xsl:param name="stringsDoc" />
  <xsl:param name="firmwareMgmtSupported" select="'false'" />
  <xsl:param name="sortCriteria" select="'none'" />
  <xsl:param name="filter" select="'all'" />
	<xsl:param name="sortAscending" />

  <xsl:template match="*">        
    <xsl:variable name="totalCritical">
			<xsl:value-of select="count(//device[severity=$OP_STATUS_NON_RECOVERABLE_ERROR]) + count(//device[severity=$OP_STATUS_LOST_COMMUNICATION])"/>
		</xsl:variable>
		
		<xsl:variable name="totalMajor">
			<xsl:value-of select="count(//device[severity=$OP_STATUS_PREDICTIVE_FAILURE]) + count(//device[severity=$OP_STATUS_ERROR]) + count(//device[severity=$OP_STATUS_ABORTED]) + count(//device[severity=$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR])"/>
		</xsl:variable>
		
		<xsl:variable name="totalMinor">
			<xsl:value-of select="count(//device[severity=$OP_STATUS_DEGRADED]) + count(//device[severity=$OP_STATUS_STRESSED]) + count(//device[severity=$OP_STATUS_STOPPED])"/>
		</xsl:variable>

		<xsl:variable name="totalInformation">
			<xsl:value-of select="count(//device[severity=$OP_STATUS_OTHER]) + count(//device[severity=$OP_STATUS_STOPPING]) + count(//device[severity=$OP_STATUS_DORMANT]) + count(//device[severity=$OP_STATUS_POWER_MODE]) + count(//device[severity='Informational'])"/>
		</xsl:variable>

		<xsl:variable name="totalUnknown">
			<xsl:value-of select="count(//device[severity=$OP_STATUS_UNKNOWN]) + count(//device[severity=$OP_STATUS_NO_CONTACT])"/>
		</xsl:variable>

		<xsl:variable name="totalStarting">
			<xsl:value-of select="count(//device[severity=$OP_STATUS_STARTING])"/>
		</xsl:variable>

    <xsl:value-of select="$stringsDoc//value[@key='summary:']" />&#160;&#160;
    <img src="/120814-042457/images/icon_status_critical.gif" />&#160;<xsl:value-of select="concat($totalCritical, ' ', $stringsDoc//value[@key='statusCritical'])" />&#160;&#160;
    <img src="/120814-042457/images/icon_status_major.gif" />&#160;<xsl:value-of select="concat($totalMajor, ' ', $stringsDoc//value[@key='statusMajor'])" />&#160;&#160;
    <img src="/120814-042457/images/icon_status_minor.gif" />&#160;<xsl:value-of select="concat($totalMinor, ' ', $stringsDoc//value[@key='statusMinor'])" />&#160;&#160;
    <img src="/120814-042457/images/icon_status_informational.gif" />&#160;<xsl:value-of select="concat($totalInformation, ' ', $stringsDoc//value[@key='statusInfo'])" />&#160;&#160;
    <img src="/120814-042457/images/icon_status_unknown.gif" />&#160;<xsl:value-of select="concat($totalUnknown, ' ', $stringsDoc//value[@key='statusUnknown'])" />&#160;&#160;
    <xsl:if test="$firmwareMgmtSupported = 'true'">
      <img src="/120814-042457/images/icon_status_waiting1.gif" />&#160;<xsl:value-of select="concat($totalStarting, ' ', $stringsDoc//value[@key='statusStarting'])" />&#160;&#160;
    </xsl:if>

		<xsl:variable name="totalAlerts" select="$totalCritical + $totalMajor + $totalMinor + $totalInformation + $totalUnknown + $totalStarting" />

		<xsl:value-of select="$stringsDoc//value[@key='totalAlerts']" />&#160;<xsl:value-of select="$totalAlerts" /><br />

    <span class="whiteSpacer">&#160;</span><br />

    <table border="0" cellpadding="0" cellspacing="0" class="dataTable">
      <caption class="displayForAuralBrowsersOnly">
          <!-- TODO: Caption? -->
      </caption>
      <thead>
          <tr class="captionRow">

              <xsl:call-template name="sortableColumnHeader">
                  <xsl:with-param name="cmpCriteria" select="'severity'" />
                  <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='severity']" />
              </xsl:call-template>

              <xsl:call-template name="sortableColumnHeader">
                  <xsl:with-param name="cmpCriteria" select="'deviceType'" />
                  <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='deviceType']" />
              </xsl:call-template>

              <xsl:call-template name="sortableColumnHeader">
                  <xsl:with-param name="cmpCriteria" select="'deviceName'" />
                  <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='deviceName']" />
              </xsl:call-template>

              <xsl:call-template name="sortableColumnHeader">
                  <xsl:with-param name="cmpCriteria" select="'enclosureName'" />
                  <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='enclosure']" />
              </xsl:call-template>
          </tr>
      </thead>
      <tbody>
        <xsl:variable name="sortOrder">
          <xsl:choose>
            <xsl:when test="$sortAscending = 'true'">ascending</xsl:when>
            <xsl:otherwise>descending</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="customCriteria">
          <xsl:choose>
            <xsl:when test="$sortCriteria = 'deviceType'">deviceLabel</xsl:when>
            <xsl:when test="$sortCriteria = 'severity'">severityLabel</xsl:when>
            <xsl:otherwise><xsl:value-of select="$sortCriteria" /></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
	        <xsl:when test="($totalAlerts) &gt; 0">
		        <xsl:choose>
              <!-- special case to deal with browser sort differences (only IE sorts the nodeset if all values in the sort column are identical) -->
              <xsl:when test="$sortCriteria='enclosureName' and (count(//deviceStatusDetail/enclosure) &lt; 2)">
                <xsl:for-each select="//deviceStatusDetail/enclosure/device">                  
					        <xsl:sort select="position()" data-type="number" order="{$sortOrder}" />
                  
					        <xsl:call-template name="alertTableRow">
						        <xsl:with-param name="severity" select="severity" />
						        <xsl:with-param name="deviceLabel" select="deviceLabel" />
						        <xsl:with-param name="deviceName" select="deviceName" />
						        <xsl:with-param name="deviceType" select="deviceType" />
						        <xsl:with-param name="enclosureName" select="enclosureName" />
						        <xsl:with-param name="enclosureNumber" select="enclosureNumber" />
					        </xsl:call-template>
				        </xsl:for-each>  
              </xsl:when>
			        <xsl:otherwise>                
                <xsl:for-each select="//deviceStatusDetail/enclosure/device">                  
					        <xsl:sort select="*[local-name()=$customCriteria]" data-type="text" order="{$sortOrder}" />
                  
					        <xsl:call-template name="alertTableRow">
						        <xsl:with-param name="severity" select="severity" />
						        <xsl:with-param name="deviceLabel" select="deviceLabel" />
						        <xsl:with-param name="deviceName" select="deviceName" />
						        <xsl:with-param name="deviceType" select="deviceType" />
						        <xsl:with-param name="enclosureName" select="enclosureName" />
						        <xsl:with-param name="enclosureNumber" select="enclosureNumber" />
					        </xsl:call-template>
				        </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        <xsl:otherwise>
          <tr class="noDataRow">
            <td colspan="4">
              <xsl:value-of select="$stringsDoc//value[@key='noAlerts']" />
            </td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>    	
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="sortableColumnHeader">
    <xsl:param name="cmpCriteria" />
    <xsl:param name="columnLabel" />
    <xsl:param name="sortOrder" />

    <xsl:element name="th">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$sortCriteria=$cmpCriteria">
            <xsl:choose>
              <xsl:when test="$sortAscending='true'">sortedAscending</xsl:when>
              <xsl:otherwise>sortedDescending</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>sortable</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="onclick">sortAlerts('<xsl:value-of select="$cmpCriteria" />');</xsl:attribute>
      <xsl:value-of select="$columnLabel" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="alertTableRow">
    <xsl:param name="severity" />
    <xsl:param name="deviceLabel" />
    <xsl:param name="deviceName" />
    <xsl:param name="deviceNumber" />
    <xsl:param name="deviceType" />
    <xsl:param name="enclosureName" />
    <xsl:param name="enclosureNumber" />

    <tr>
      <xsl:element name="td">
        <xsl:if test="$sortCriteria='severity'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="getStatusLabel">
          <xsl:with-param name="statusCode" select="$severity" />
        </xsl:call-template>
      </xsl:element>

      <xsl:element name="td">
        <xsl:if test="$sortCriteria='deviceType'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="$deviceLabel" />
      </xsl:element>

      <xsl:element name="td">
        <xsl:if test="$sortCriteria='deviceName'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:element name="a">
          <xsl:choose>
            <xsl:when test="$deviceType = 'ers'">
              <xsl:attribute name="href">../html/remoteSupport.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
              <xsl:attribute name="onclick">top.mainPage.getStatusContainer().showStatus(true);</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="deviceNumber" />, '<xsl:value-of select="deviceType" />', <xsl:value-of select="$enclosureNumber" />, true);</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="$deviceName" />
        </xsl:element>
      </xsl:element>

      <xsl:element name="td">
        <xsl:if test="$sortCriteria='enclosureName'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="$enclosureName" />
      </xsl:element>
    </tr>
  </xsl:template>
	
</xsl:stylesheet>
