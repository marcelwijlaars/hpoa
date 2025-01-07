<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->

  <!-- NOTE: The global templates file depends on the guiConstants.xsl file. -->
  

  <!--
    Status icon template. Takes a status code as a parameter and returns
    an img element with the correct status image path.
  -->

  <xsl:template name="statusIcon">

    <!-- Icon status code -->
    <xsl:param name="statusCode" />
    <xsl:param name="imgId" />
    <xsl:param name="top" select="''" />
    <xsl:param name="left" select="''" />
    <xsl:param name="visibility" select="'visible'" />
    <xsl:param name="optStyle" select="''" />

    <xsl:element name="img">

      <xsl:choose>
        <xsl:when test="$statusCode != $LOCKED">
          <xsl:attribute name="width">13</xsl:attribute>
          <xsl:attribute name="height">13</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="width">10</xsl:attribute>
          <xsl:attribute name="height">13</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:attribute name="border">0</xsl:attribute>
      <xsl:attribute name="alt"></xsl:attribute>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="$top != '' and $left != ''">          
            <xsl:value-of select="concat('position:absolute;visibility:', $visibility, ';top:', $top, 'px;', 'left:', $left, 'px;', $optStyle)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('border:0;visibility:', $visibility, ';', $optStyle)"/> 
          </xsl:otherwise>      
        </xsl:choose>
      </xsl:attribute>

      <xsl:if test="$imgId">
        <xsl:attribute name="id"><xsl:value-of select="$imgId"/></xsl:attribute>
      </xsl:if>
      <xsl:variable name="guiStatusCode">
        <xsl:call-template name="guiStatusCode" >
          <xsl:with-param name="statusCode" select="$statusCode" />
        </xsl:call-template>
      </xsl:variable>

      <!-- Determine the icon image's src attribute based on status parameter -->
      <xsl:attribute name="src">

        <xsl:choose>
          <!-- New operational status stuff -->
          <xsl:when test="$guiStatusCode='STATUS_OK_IMAGE'">
            <xsl:value-of select="$STATUS_OK_IMAGE" />
          </xsl:when>

          <xsl:when test="$guiStatusCode='STATUS_INFO_IMAGE'">
            <xsl:value-of select="$STATUS_INFO_IMAGE" />
          </xsl:when>

          <xsl:when test="$guiStatusCode='STATUS_MINOR_IMAGE'">
            <xsl:value-of select="$STATUS_MINOR_IMAGE" />
          </xsl:when>

          <xsl:when test="$guiStatusCode='STATUS_MAJOR_IMAGE'">
            <xsl:value-of select="$STATUS_MAJOR_IMAGE" />
          </xsl:when>

          <xsl:when test="$guiStatusCode='STATUS_FAILED_IMAGE'">
            <xsl:value-of select="$STATUS_FAILED_IMAGE" />
          </xsl:when>

          <xsl:when test="$guiStatusCode='STATUS_DISABLED_IMAGE'">
            <xsl:value-of select="$STATUS_DISABLED_IMAGE" />
          </xsl:when>

          <!-- Permission denied. -->
          <xsl:when test="$guiStatusCode='STATUS_LOCKED_IMAGE'">
            <xsl:value-of select="$STATUS_LOCKED_IMAGE" />
          </xsl:when>

          <xsl:when test="$guiStatusCode='STATUS_UNKNOWN_IMAGE'">
            <xsl:value-of select="$STATUS_UNKNOWN_IMAGE" />
          </xsl:when>

					<xsl:when test="$guiStatusCode='STATUS_STARTING_IMAGE'">
						<xsl:value-of select="$STATUS_STARTING_IMAGE" />
					</xsl:when>

          <!--
            A catch all. Displays status as unknown if one of the above
            cases is not matched.
          -->
          <xsl:otherwise>
            <xsl:value-of select="$STATUS_UNKNOWN_IMAGE" />
          </xsl:otherwise>

        </xsl:choose>
      </xsl:attribute>

    </xsl:element>

  </xsl:template>

  <xsl:template name="guiStatusCode">

    <!-- Icon status code -->
    <xsl:param name="statusCode" />
    <xsl:choose>

      <!-- New operational status stuff -->
      <xsl:when test="$statusCode=$OP_STATUS_OK or 
      $statusCode=$INTERCONNECT_TRAY_PORT_STATUS_OK or 
      $statusCode='Repaired' or 
      $statusCode=$OP_STATUS_ERROR or
      $statusCode=$OP_STATUS_COMPLETED">
        <xsl:value-of select="string('STATUS_OK_IMAGE')" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_OTHER or 
      $statusCode='Informational' or 
      statusCode=$OP_STATUS_DORMANT or 
      $statusCode=$OP_STATUS_POWER_MODE or
      $statusCode=$OP_STATUS_STOPPING">
        <xsl:value-of select="string('STATUS_INFO_IMAGE')" />
      </xsl:when>

			<xsl:when test="$statusCode=$OP_STATUS_STARTING">
				<xsl:value-of select="string('STATUS_STARTING_IMAGE')" />
			</xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STOPPED or 
      $statusCode=$OP_STATUS_DEGRADED or
      $statusCode='Caution' or
      $statusCode=$OP_STATUS_STRESSED">
        <xsl:value-of select="string('STATUS_MINOR_IMAGE')" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_PREDICTIVE_FAILURE or 
      $statusCode=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH or 
      $statusCode=$OP_STATUS_ABORTED or 
      $statusCode=$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR">
        <xsl:value-of select="string('STATUS_MAJOR_IMAGE')" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_NON_RECOVERABLE_ERROR or
      $statusCode=$OP_STATUS_LOST_COMMUNICATION or
      $statusCode='Critical'">
        <xsl:value-of select="string('STATUS_FAILED_IMAGE')" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_IN_SERVICE">
        <xsl:value-of select="string('STATUS_DISABLED_IMAGE')" />
      </xsl:when>

      <!-- Permission denied. -->
      <xsl:when test="$statusCode=$LOCKED">
        <xsl:value-of select="string('STATUS_LOCKED_IMAGE')" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_NO_CONTACT or
      $statusCode=$OP_STATUS_UNKNOWN">
        <xsl:value-of select="string('STATUS_UNKNOWN_IMAGE')" />
      </xsl:when>
      <!--
        A catch all. Displays status as unknown if one of the above
        cases is not matched.
      -->
      <xsl:otherwise>
        <xsl:value-of select="string('STATUS_UNKNOWN_IMAGE')" />
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>
  <!--
    The getStatusLabel template takes a blade status code and returns the HTML image and
    text associated with that status code.
  -->

  <xsl:template name="getStatusLabel">

    <xsl:param name="statusCode" />
    <xsl:param name="optStyle" />

    <xsl:choose>

      <xsl:when test="$statusCode=$OP_STATUS_OK">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusOK']" />
      </xsl:when>

      <xsl:when test="$statusCode=$INTERCONNECT_TRAY_PORT_STATUS_OK">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusOKConnected']" />
      </xsl:when>

      <xsl:when test="$statusCode=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusPortMismatch']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_COMPLETED">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusCompleted']" />
      </xsl:when>

      <!-- Codes that map to an informational icon state. -->
      <xsl:when test="$statusCode=$OP_STATUS_OTHER or $statusCode = 'Informational'">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;
        <xsl:choose>
          <xsl:when test="$statusCode = 'Informational'"><xsl:value-of select="$stringsDoc//value[@key='statusInfo']" /></xsl:when>
          <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='statusOther']" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_POWER_MODE">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusPowerMode']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_DORMANT">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusDormant']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STARTING">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusStarting']"/>
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STOPPING">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusStopping']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_UNKNOWN">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_NO_CONTACT">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusNoContact']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_IN_SERVICE">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusInService']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_DEGRADED">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusDegraded']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STRESSED">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusStressed']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STOPPED">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusStopped']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_PREDICTIVE_FAILURE">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusPredictiveFailure']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_ERROR">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusError']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_ABORTED">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusAborted']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='supportingEntityError']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_NON_RECOVERABLE_ERROR">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusCriticalError']" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_LOST_COMMUNICATION">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$statusCode" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusLostComm']" />
      </xsl:when>

      <xsl:when test="$statusCode=$FABRIC_STATUS_OK">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusOK']" />
      </xsl:when>

      <xsl:when test="$statusCode=$FABRIC_STATUS_MISMATCH">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusPortMismatch']" />
      </xsl:when>

      <!-- A catch all in case none of the above cases are matched against a status code. -->
      <xsl:otherwise>
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_UNKNOWN" />
          <xsl:with-param name="optStyle" select="$optStyle" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>
  
  <!-- UID Image -->
  <xsl:template name="getUidImage">
    <xsl:param name="imgId" />
    <xsl:param name="top">0</xsl:param>
    <xsl:param name="left">0</xsl:param>
    <xsl:param name ="uidState" /> 
    <xsl:param name="width" select="''" />
    <xsl:param name="height" select="''" />
    
    <xsl:element name="img">
      <xsl:if test="$imgId">
        <xsl:attribute name="id">
          <xsl:value-of select="$imgId" />
        </xsl:attribute>        
      </xsl:if>
      
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="$width != '' and $height != ''">
            <xsl:value-of select="concat('position:absolute;top:', $top, 'px;left:', $left, 'px;width:', $width, 'px;height:', $height, 'px;')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('position:absolute;top:', $top, 'px;left:', $left, 'px;width:4px;height:4px;')" />
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:attribute>
      
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="$uidState='UID_ON'">
            <xsl:value-of select="'/120814-042457/images/uid_small_on.gif'" />
          </xsl:when>
          <xsl:when test="$uidState='UID_OFF'">
            <xsl:value-of select="'/120814-042457/images/uid_small_off.gif'" />
          </xsl:when>
          <xsl:when test="$uidState='UID_BLINK'">
            <xsl:value-of select="'/120814-042457/images/uid_small_blink.gif'" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'/120814-042457/images/uid_small_off.gif'"/>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:attribute>
    </xsl:element>    
  </xsl:template>

  <xsl:template name="getThermalLabel">

    <xsl:param name="statusCode" />

    <xsl:choose>

      <xsl:when test="$statusCode = 'SENSOR_STATUS_OK'">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusOK']" />
      </xsl:when>

      <xsl:when test="$statusCode = 'SENSOR_STATUS_WARM'">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusWarm']" />
      </xsl:when>

      <xsl:when test="$statusCode = 'SENSOR_STATUS_CAUTION'">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_PREDICTIVE_FAILURE" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusCaution']" />
      </xsl:when>

      <xsl:when test="$statusCode = 'SENSOR_STATUS_CRITICAL'">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_NON_RECOVERABLE_ERROR" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusCritical']" />
      </xsl:when>

      <xsl:when test="$statusCode = 'SENSOR_STATUS_UNKNOWN'">
        <xsl:call-template name="statusIcon" >
          <xsl:with-param name="statusCode" select="$OP_STATUS_UNKNOWN" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
      </xsl:when>

    </xsl:choose>

  </xsl:template>

  <!-- Gets a readable label for the different power state enumeration codes. -->
  <xsl:template name="getPowerStateLabel">

    <xsl:param name="powerState" />

    <xsl:choose>
      <xsl:when test="$powerState = $PS_FULL"><xsl:value-of select="$stringsDoc//value[@key='statusFull']" /></xsl:when>
      <xsl:when test="$powerState = $POWER_ON"><xsl:value-of select="$stringsDoc//value[@key='on']" /></xsl:when>
      <xsl:when test="$powerState = $POWER_OFF"><xsl:value-of select="$stringsDoc//value[@key='off']" /></xsl:when>
      <xsl:when test="$powerState = $PS_UNKNOWN"><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></xsl:when>
      <xsl:when test="$powerState = $PS_CONSERVE"><xsl:value-of select="$stringsDoc//value[@key='conserve']" /></xsl:when>
      <xsl:when test="$powerState = $PS_LOW"><xsl:value-of select="$stringsDoc//value[@key='low']" /></xsl:when>
      <xsl:when test="$powerState = $PS_SLEEP"><xsl:value-of select="$stringsDoc//value[@key='sleep']" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Gets a readable label for the different power management enumeration codes. -->
  <xsl:template name="getPowerManagementLabel">

    <xsl:param name="pmState" />

    <xsl:choose>
      <xsl:when test="$pmState = $PM_ABSENT"><xsl:value-of select="$stringsDoc//value[@key='statusAbsent']" /></xsl:when>
      <xsl:when test="$pmState = $PM_PRESENT"><xsl:value-of select="$stringsDoc//value[@key='statusPresent']" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Gets a readable label for the different powered enumeration codes. -->
  <xsl:template name="getPowerLabel">

    <xsl:param name="powered" />

    <xsl:choose>
      <xsl:when test="$powered = $POWER_ON"><xsl:value-of select="$stringsDoc//value[@key='on']" /></xsl:when>
      <xsl:when test="$powered = $POWER_OFF"><xsl:value-of select="$stringsDoc//value[@key='off']" /></xsl:when>
      <xsl:when test="$powered = $POWER_STAGED_OFF"><xsl:value-of select="$stringsDoc//value[@key='stagedOff']" /></xsl:when>
      <xsl:when test="$powered = $POWER_SLEEP"><xsl:value-of select="$stringsDoc//value[@key='sleep']" /></xsl:when>
      <xsl:when test="$powered = $POWER_OFF_IMMEDIATE"><xsl:value-of select="$stringsDoc//value[@key='powerOffImmediately']" /></xsl:when>
      <xsl:when test="$powered = $POWER_REBOOT_IMMEDIATE"><xsl:value-of select="$stringsDoc//value[@key='rebootImmediately']" /></xsl:when>
      <xsl:when test="$powered = $POWER_REBOOT"><xsl:value-of select="$stringsDoc//value[@key='reboot']" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Gets a small led used to indicate power state on the front of the devices. -->
  <xsl:template name="getPowerLed">
    <xsl:param name="imgId" />
    <xsl:param name="top"/>
    <xsl:param name="left"/>
    <xsl:param name="powerState" />
    <xsl:param name="size" select="5" />

    <xsl:element name="img">

      <xsl:if test="$imgId">
        <xsl:attribute name="id">
          <xsl:value-of select="$imgId" />
        </xsl:attribute>
      </xsl:if>

      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="$top and $left">
            <xsl:value-of select="concat('position:absolute;top:',$top,'px;left:',$left,'px;width:',$size,'px;height:',$size,'px;')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('width:',$size,'px;height:',$size,'px;')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="$powerState=$POWER_ON">
            <xsl:value-of select="'/120814-042457/images/led.gif'" />
          </xsl:when>
          <xsl:when test="$powerState=$POWER_OFF">
            <xsl:value-of select="'/120814-042457/images/led_amber.gif'" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

    </xsl:element>

  </xsl:template>
  
  <xsl:template name="getHealthBarLed">
    <xsl:param name="imgId" />
    <xsl:param name="top" />
    <xsl:param name="left" />
    <xsl:param name="healthState" />
    <xsl:param name="powerState" />
    <xsl:param name="width" />
    <xsl:param name="height" />

    <xsl:variable name="imageSource">
      <xsl:choose>
        <xsl:when test="$healthState = $OP_STATUS_OK">
          <xsl:choose>
            <xsl:when test="$powerState = $POWER_ON">/120814-042457/images/led-bar-green.gif</xsl:when>
            <xsl:otherwise></xsl:otherwise><!-- bar turns off when blade is off and health is green -->
          </xsl:choose>          
        </xsl:when>
        <xsl:when test="$healthState = $OP_STATUS_DEGRADED">/120814-042457/images/led-bar-amber-blink.gif</xsl:when>
        <xsl:when test="$healthState = $OP_STATUS_NON_RECOVERABLE_ERROR">/120814-042457/images/led-bar-red-blink.gif</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose> 
    </xsl:variable>
    <xsl:if test="$imageSource != ''">
    <xsl:element name="img">
      <xsl:attribute name="id"><xsl:value-of select="$imgId" /></xsl:attribute>
      <xsl:attribute name="alt"></xsl:attribute>       
      <xsl:attribute name="style">
        <xsl:value-of select="concat('position:absolute;border:0px;top:', $top, 'px;left:', $left, 'px;width:', $width, 'px;height:', $height, 'px;')" />
      </xsl:attribute>      

      <xsl:attribute name="src">
          <xsl:value-of select="$imageSource" />
      </xsl:attribute>     
    </xsl:element>    
    </xsl:if>
  </xsl:template>

  <xsl:template name="getPowerLedCustom">
    <xsl:param name="ledImage"></xsl:param>
    <xsl:param name="top" select="0" />
    <xsl:param name="left" select="0" />
    <xsl:param name="width" select="0" />
    <xsl:param name="height" select="0" />

    <xsl:element name="img">
      <xsl:attribute name="alt"></xsl:attribute>       
      <xsl:attribute name="style">
        <xsl:value-of select="concat('position:absolute;border:0px;top:', $top, 'px;left:', $left, 'px;width:', $width, 'px;height:', $height, 'px;')" />
      </xsl:attribute>      

      <xsl:attribute name="src">
        <xsl:value-of select="$ledImage"/>
      </xsl:attribute>     
    </xsl:element>
  </xsl:template>
  
  <!-- used to make long strings wrap in tooltips -->
  <xsl:template name="split-string-at-index">
    <xsl:param name="sourceString" />
    <xsl:param name="splitIndex" />
    
    <xsl:choose>
      <xsl:when test="string-length($sourceString) &gt; $splitIndex">
        <!-- xsl string indexes are 1-based -->
        <xsl:value-of select="concat(substring($sourceString, 1, $splitIndex),'-')" /><br />
        <xsl:value-of select="substring($sourceString, $splitIndex+1)" />        
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sourceString"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Gets a label with a uid icon and associated text. -->
  <xsl:template name="getUIDLabel">

    <xsl:param name="statusCode" />

    <xsl:element name="img">
      <xsl:attribute name="id">uidImage</xsl:attribute>
      <xsl:attribute name="width">17</xsl:attribute>
      <xsl:attribute name="height">17</xsl:attribute>
      <xsl:attribute name="border">0</xsl:attribute>
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="$statusCode=$UID_ON">
            <xsl:value-of select="$UID_ON_IMAGE" />
          </xsl:when>
          <xsl:when test="$statusCode=$UID_OFF">
            <xsl:value-of select="$UID_OFF_IMAGE" />
          </xsl:when>
          <xsl:when test="$statusCode=$UID_BLINK">
            <xsl:value-of select="$UID_BLINK_IMAGE" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$UID_OFF_IMAGE" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>&#160;

    <xsl:choose>
      <xsl:when test="$statusCode=$UID_ON">
        <span id="uidText"><xsl:value-of select="$stringsDoc//value[@key='on']" /></span>
      </xsl:when>
      <xsl:when test="$statusCode=$UID_OFF">
        <span id="uidText"><xsl:value-of select="$stringsDoc//value[@key='off']" /></span>
      </xsl:when>
      <xsl:when test="$statusCode=$UID_BLINK">
        <span id="uidText"><xsl:value-of select="$stringsDoc//value[@key='blink']" /></span>
      </xsl:when>
      <xsl:otherwise>
        <span id="uidText"><xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" /></span>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Labels for the different types of interconnects. -->
  <xsl:template name="getInterconnectTypeLabel">

    <xsl:param name="type" />

    <xsl:choose>
      <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NIC">
        <xsl:value-of select="$stringsDoc//value[@key='ethernet']" />
      </xsl:when>
      <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_10GETH">
        <xsl:value-of select="$stringsDoc//value[@key='10GbEthernet']" />
      </xsl:when>
      <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_FC">
        <xsl:value-of select="$stringsDoc//value[@key='fibreChannel']" />
      </xsl:when>
      <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_SAS">
        <!-- Really is Serial Attached SCSI, but "SAS" is better used here -->
        <xsl:value-of select="$stringsDoc//value[@key='SAS']" />
      </xsl:when>
      <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_IB">
        <xsl:value-of select="$stringsDoc//value[@key='infiniband']" />
      </xsl:when>
      <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_PCIE">
        <xsl:value-of select="$stringsDoc//value[@key='PCIE']" />
      </xsl:when>
      <xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_MAX">
        <xsl:value-of select="$stringsDoc//value[@key='MAX']" />
      </xsl:when>
		<xsl:when test="$type=$INTERCONNECT_TRAY_TYPE_NO_CONNECTION">
			<!-- nothing is better used here -->
		</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$type" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="getApprovedMezzName">
    <xsl:param name="dataName" />
    <xsl:param name="bladeType" select="''" />
    <xsl:choose>
      <xsl:when test="$dataName = $FIXED_NIC_ID">
        <xsl:choose>
          <xsl:when test="$bladeType='BLADE_TYPE_STORAGE'">
            <xsl:value-of select="$stringsDoc//value[@key='fixedSAS']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$stringsDoc//value[@key='fixedNIC']" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dataName"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getRedundancyLabel">

    <xsl:param name="redundancyMode" />
	 <xsl:param name="isDC" />

    <xsl:choose>
      <xsl:when test="$redundancyMode='REDUNDANT'">
        <xsl:value-of select="$stringsDoc//value[@key='redundant']" />
      </xsl:when>
      <xsl:when test="$redundancyMode='NON_REDUNDANT' or $redundancyMode='NOT_REDUNDANT'">
        <xsl:value-of select="$stringsDoc//value[@key='notRedundant']" />
      </xsl:when>
      <xsl:when test="$redundancyMode='AC_REDUNDANT'">
			<xsl:choose>
				<xsl:when test="$isDC='true'">
					<xsl:value-of select="$stringsDoc//value[@key='redundant']" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$stringsDoc//value[@key='acRedundant']" />
				</xsl:otherwise>
			</xsl:choose>
      </xsl:when>
      <xsl:when test="$redundancyMode='POWER_SUPPLY_REDUNDANT'">
        <xsl:value-of select="$stringsDoc//value[@key='powerSupplyRedundant']" />
      </xsl:when>
      <xsl:when test="$redundancyMode='AC_REDUNDANT_WITH_POWER_CEILING'">
			<xsl:choose>
				<xsl:when test="$isDC='true'">
					<xsl:value-of select="$stringsDoc//value[@key='redundant']" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$stringsDoc//value[@key='acRedundant']" />
				</xsl:otherwise>
			</xsl:choose>&#160;<xsl:value-of select="$stringsDoc//value[@key='(powerCeilingEnabled)']" />
      </xsl:when>
      <xsl:when test="$redundancyMode='POWER_SUPPLY_REDUNDANT_WITH_POWER_CEILING'">
        <xsl:value-of select="$stringsDoc//value[@key='powerSupplyRedundant']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='(powerCeilingEnabled)']" />
      </xsl:when>
      <xsl:when test="$redundancyMode='NON_REDUNDANT_WITH_POWER_CEILING'">
        <xsl:value-of select="$stringsDoc//value[@key='notRedundant']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='(powerCeilingEnabled)']" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="getRedundancyStateLabel">

    <xsl:param name="redundant" />

    <xsl:choose>

      <xsl:when test="$redundant='REDUNDANT'">
        <xsl:call-template name="statusIcon">
          <xsl:with-param name="statusCode" select="'OP_STATUS_OK'" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='redundant']" />
      </xsl:when>
      <xsl:when test="$redundant='NOT_REDUNDANT'">
        <xsl:call-template name="statusIcon">
          <xsl:with-param name="statusCode" select="'OP_STATUS_DEGRADED'" />
        </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='redundancyLost']" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
      </xsl:otherwise>
    
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name="substring-after-last">
    <xsl:param name="input" />
    <xsl:param name="marker">
      <xsl:value-of select="' '"/>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="contains($input,$marker)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="input" 
            select="substring-after($input,$marker)" />
          <xsl:with-param name="marker" select="$marker" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$input" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Template used to convert a Fahrenheit temperature to Celsius. -->
  <xsl:template name="FtoC">
    <xsl:param name="tempF" />
    <xsl:value-of select="((number($tempF)-32) div 9)*5"/>
  </xsl:template>

  <xsl:template name="CtoF">
    <xsl:param name="tempC" />
    <xsl:value-of select="(number($tempC*9) div 5) + 32"/>
  </xsl:template>

  <!-- Gets a status icon for the specified diagnostic code. -->
  <xsl:template name="getDiagnosticStatusIcon">

    <xsl:param name="diagnosticCode" />
    <xsl:param name="statusCode" />

    <!-- First get the correct status code for the diagnostic check. -->
    <xsl:variable name="diagnosticLabelStatus">

      <xsl:choose>
        <xsl:when test="$diagnosticCode='NO_ERROR'">
          <xsl:value-of select="$OP_STATUS_OK"/>
        </xsl:when>
        <xsl:when test="$diagnosticCode='ERROR'">
          <xsl:value-of select="$statusCode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$OP_STATUS_UNKNOWN"/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:variable>

    <xsl:call-template name="statusIcon" >
      <xsl:with-param name="statusCode" select="$diagnosticLabelStatus" />
    </xsl:call-template>

  </xsl:template>

  <!--
    This template renders the diagnostic table for the diagnostic checks for
    each device.  It is called from the context of the hpoa:diagnosticData element
    in the status structs.
  -->
  <xsl:template name="diagnosticStatusView">
    <xsl:param name="statusCode" />
    <xsl:param name="deviceType" select="string('')" />
    <xsl:param name="encType" select="string('')" />
	  <xsl:param name="imlErrorClass" />

    <xsl:if test="count(hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED') and not(node()='NOT_RELEVANT')]) &gt; 0 or count(hpoa:diagnosticChecksEx/hpoa:diagnosticData) &gt; 0">

      <span class="whiteSpacer">&#160;</span>
      <br />

      <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
        <caption><xsl:value-of select="$stringsDoc//value[@key='diagnosticInformation']" /></caption>
        <tbody>

          <xsl:for-each select="hpoa:diagnosticChecks/*[not(node()='DIAGNOSTIC_CHECK_NOT_PERFORMED') and not(node()='NOT_RELEVANT')]">

            <xsl:variable name="nodeName" select="name(current())" />

            <xsl:call-template name="diagnosticCheckRow">
              <xsl:with-param name="nodeName" select="$nodeName" />
              <xsl:with-param name="statusCode" select="$statusCode" />
              <xsl:with-param name="deviceType" select="$deviceType" />
              <xsl:with-param name="encType" select="$encType" />
					<xsl:with-param name="imlErrorClass" select="$imlErrorClass" />
				</xsl:call-template>

			</xsl:for-each>

			<xsl:for-each select="hpoa:diagnosticChecksEx/hpoa:diagnosticData">

				<!--
              In order to reuse the xml document we need to add 'hpoa:' to the
              name attribute.
            -->
				<xsl:variable name="nodeName" select="concat('hpoa:', @hpoa:name)" />

				<xsl:call-template name="diagnosticCheckRow">
					<xsl:with-param name="nodeName" select="$nodeName" />
					<xsl:with-param name="statusCode" select="$statusCode" />
					<xsl:with-param name="deviceType" select="$deviceType" />
					<xsl:with-param name="encType" select="$encType" />
					<xsl:with-param name="imlErrorClass" select="$imlErrorClass" />
            </xsl:call-template>

          </xsl:for-each>

        </tbody>
      </table>

    </xsl:if>

  </xsl:template>

  <!--
    Template used to renders one row in the diagnostic check table.
  -->
  <xsl:template name="diagnosticCheckRow">
    <xsl:param name="nodeName" />
    <xsl:param name="statusCode" />
    <xsl:param name="deviceType" />
    <xsl:param name="encType" />
	  <xsl:param name="imlErrorClass" />
    <xsl:variable name="fieldLabel" select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/fieldLabel"/>

    <tr class="altRowColor">
      <th class="propertyName">
        <xsl:choose>
          <xsl:when test="$fieldLabel!=''">
            <xsl:choose>
              <xsl:when test="$deviceType!=''">
                <xsl:choose>
                  <xsl:when test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/fieldLabel[@deviceType=$deviceType] != ''">
                    <xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/fieldLabel[@deviceType=$deviceType]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/fieldLabel"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$fieldLabel"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$nodeName"/>
          </xsl:otherwise>
        </xsl:choose>
      </th>
      <td class="propertyValue">

        <!-- Get the appropriate status icon. -->
        <xsl:choose>
          <xsl:when test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/successStatusOverride != ''">
            <xsl:call-template name="getDiagnosticStatusIcon">
              <xsl:with-param name="diagnosticCode" select="'ERROR'" />
              <xsl:with-param name="statusCode" select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/successStatusOverride" />
            </xsl:call-template>&#160;
          </xsl:when>
          <xsl:when test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusOverride != '' and current() != 'NO_ERROR'">
            <xsl:call-template name="getDiagnosticStatusIcon">
              <xsl:with-param name="diagnosticCode" select="current()" />
              <xsl:with-param name="statusCode" select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusOverride" />
            </xsl:call-template>&#160;
          </xsl:when>
          <xsl:otherwise>            
            <xsl:choose>
              <xsl:when test="../../hpoa:serverStatus != ''">
                <xsl:call-template name="getDiagnosticStatusIcon">
                  <xsl:with-param name="diagnosticCode" select="current()" />
                  <xsl:with-param name="statusCode" select="../../hpoa:serverStatus" />
                </xsl:call-template>&#160;
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="getDiagnosticStatusIcon">
                  <xsl:with-param name="diagnosticCode" select="current()" />
                  <xsl:with-param name="statusCode" select="$statusCode" />
                </xsl:call-template>&#160;
              </xsl:otherwise>        
            </xsl:choose>            
          </xsl:otherwise>
        </xsl:choose>

        <!-- Get the appropriate status text for an ok or failed condition. -->
        <xsl:choose>
          <xsl:when test="$deviceType!=''">
            <xsl:choose>
              <xsl:when test="current()='NO_ERROR'">
                <xsl:choose>
                  <xsl:when test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/successStatusLabel[@deviceType=$deviceType] != ''">
                    <xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/successStatusLabel[@deviceType=$deviceType]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/successStatusLabel" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusLabel[@deviceType=$deviceType] != ''">
							<xsl:choose>
								<xsl:when test="$encType!=''">
									<xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusLabel[@deviceType=$deviceType and @encType=$encType]"/>
									<xsl:if test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/showImlLink">
										&#160;<xsl:value-of select="../../hpoa:extraData[@hpoa:name='mainMemoryErrors']"/>.
										&#160;<xsl:value-of select="$stringsDoc//value[@key='reviewIml1']"/>&#160;<xsl:element name="a">
											<xsl:attribute name="href">javascript:filterIml('');</xsl:attribute>
											<xsl:value-of select="$stringsDoc//value[@key='iml']"/>
										</xsl:element>&#160;<xsl:value-of select="$stringsDoc//value[@key='reviewIml2']"/>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusLabel[@deviceType=$deviceType]"/>
									<xsl:if test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/showImlLink">
										&#160;<xsl:value-of select="../../hpoa:extraData[@hpoa:name='mainMemoryErrors']"/>.
										&#160;<xsl:value-of select="$stringsDoc//value[@key='reviewIml1']"/>&#160;<xsl:element name="a">
											<xsl:attribute name="href">javascript:filterIml('');</xsl:attribute>
											<xsl:value-of select="$stringsDoc//value[@key='iml']"/>
										</xsl:element>&#160;<xsl:value-of select="$stringsDoc//value[@key='reviewIml2']"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusLabel"/>
							<xsl:if test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/showImlLink">
								&#160;<xsl:value-of select="../../hpoa:extraData[@hpoa:name='mainMemoryErrors']"/>.
								&#160;<xsl:value-of select="$stringsDoc//value[@key='reviewIml1']"/>&#160;<xsl:element name="a">
									<xsl:attribute name="href">javascript:filterIml('');</xsl:attribute>
									<xsl:value-of select="$stringsDoc//value[@key='iml']"/>
								</xsl:element>&#160;<xsl:value-of select="$stringsDoc//value[@key='reviewIml2']"/>
							</xsl:if>
							<xsl:if test="$nodeName='hpoa:deviceInvalidPowerValue'">
								&#160;<xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusLabel1"/>
								<xsl:value-of select="../../hpoa:extraData[@hpoa:name='invalidPowerValue']"/>W&#160;<xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusLabel2"/>
								<xsl:value-of select="../../hpoa:powerConsumed"/>W.
							</xsl:if>
						</xsl:otherwise>
						
					</xsl:choose>

                <!-- Optional error tooltip. -->
                <xsl:if test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/helpTipString != ''">

                  <xsl:call-template name="errorTooltip">
                    <xsl:with-param name="stringsFileKey" select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/helpTipString" />
                  </xsl:call-template>

                </xsl:if>

              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="current()='NO_ERROR'">
            <xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/successStatusLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/failedStatusLabel"/>
				 <xsl:if test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/showImlLink">
					 &#160;<xsl:element name="a">
						 <xsl:attribute name="href">javascript:filterIml('<xsl:value-of select="$imlErrorClass"/>');</xsl:attribute>
						 <xsl:value-of select="$stringsDoc//value[@key='clickHere']"/>
					 </xsl:element>
				 </xsl:if>

				 <!-- Optional error tooltip. -->
            <xsl:if test="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/helpTipString != ''">

              <xsl:call-template name="errorTooltip">
                <xsl:with-param name="stringsFileKey" select="$stringsDoc//diagnosticStrings/diagnosticString[@name=$nodeName]/helpTipString" />
              </xsl:call-template>

            </xsl:if>

          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>

  </xsl:template>

  <!-- Renders one Table Row with a label: InputBox -->
  <xsl:template name="labelAndInputRow">
    <xsl:param name="id_row" />
    <xsl:param name="label_row" />
    <xsl:param name="value_row" />
    <xsl:param name="max_row" />
    <xsl:param name="validate_row" />
    <xsl:param name="validate_name" />
    <xsl:param name="rule-list" />
    <xsl:param name="range" />
    <xsl:param name="title_row" />
    <xsl:param name="reg_exp" />
    <xsl:param name="msg_insert_key" />

    <tr>
      <td>
        <xsl:element name="span">
          <xsl:attribute name="class">widgetLabel</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="concat($id_row,'Label')"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$title_row"/>
          </xsl:attribute>
          <xsl:value-of select="$label_row"/>:
        </xsl:element>
      </td>
      <td width="10">&#160;</td>
      <td>
        <xsl:element name="input">
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$id_row"/>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="$id_row"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$value_row"/>
          </xsl:attribute>
          <xsl:attribute name="class">stdInput</xsl:attribute>
          <xsl:attribute name="maxlength">
            <xsl:value-of select="$max_row"/>
          </xsl:attribute>
          <!-- validation: required field -->
          <xsl:choose>
            <xsl:when test="$validate_row='true'">
              <xsl:attribute name="{$validate_name}">true</xsl:attribute>
              <xsl:attribute name="rule-list">
                <xsl:value-of select="$rule-list"/>
              </xsl:attribute>
              <xsl:attribute name="range">
                <xsl:value-of select="$range"/>
              </xsl:attribute>
              <xsl:attribute name="caption-label">
                <xsl:value-of select="concat($id_row,'Label')"/>
              </xsl:attribute>
              <!-- additional attribs for regular expression validation -->
              <xsl:if test="$reg_exp != '' and $msg_insert_key != ''">
                <xsl:attribute name="reg-exp">
                  <xsl:value-of select="$reg_exp"/>
                </xsl:attribute>
                <xsl:attribute name="msg-insert-key">
                  <xsl:value-of select="$msg_insert_key"/>
                </xsl:attribute>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:element>
      </td>
    </tr>
  </xsl:template>

	<xsl:template name="deviceBaySymbolicNumber">
		<xsl:param name="bladeInfo" />
		<xsl:choose>
			<xsl:when test="$bladeInfo/hpoa:extraData[@hpoa:name='SymbolicBladeNumber'] and $bladeInfo/hpoa:extraData[@hpoa:name='SymbolicBladeNumber'] != ''">
				<xsl:value-of select="$bladeInfo/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$bladeInfo/hpoa:bayNumber" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template name="deviceBayTooltip">
    <xsl:param name="myId" />
    <xsl:param name="bladeInfo" />
    <xsl:param name="bladeStatus" />
    <xsl:param name="bladeThermal" select="false()" />
    <xsl:param name="bladeMpInfo" />
    <xsl:param name="mpIpAddress" />
	  <xsl:param name="presence" select="''" />

	  <xsl:variable name="determinedPresence">
		  <xsl:choose>
			  <xsl:when test="$presence!=''">
				  <xsl:value-of select="$presence"/>
			  </xsl:when>
			  <xsl:otherwise>
				  <xsl:value-of select="$bladeInfo/hpoa:presence"/>
			  </xsl:otherwise>
		  </xsl:choose>
	  </xsl:variable>

	  <xsl:variable name="symbolicBladeNumber" >
		  <xsl:call-template name="deviceBaySymbolicNumber">
			  <xsl:with-param name="bladeInfo" select="$bladeInfo" />
		  </xsl:call-template>
	  </xsl:variable>
    
      <table cellspacing="0" style="border:1px solid #333;width:100%;table-layout:fixed;">
        <tr>
          <td style="border:0px;text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
            <xsl:value-of select="concat($stringsDoc//value[@key='serverBay'] ,' ', $symbolicBladeNumber)"/>
          </td>
        </tr>
        <tr>
          <td style="text-align:left;padding-left:4px;background:white;border:0px;">
            <xsl:choose>
              <xsl:when test="$determinedPresence=$LOCKED or $determinedPresence='PRESENCE_NO_OP'">
                <span style="color:#666;font-style:italic;"><xsl:value-of select="$stringsDoc//value[@key='locked']" /></span>
              </xsl:when>
              <xsl:when test="determinedPresence='SUBSUMED'" >
                <span style="color:#666;font-style:italic;"><xsl:value-of select="$stringsDoc//value[@key='subsumed']" /></span>
              </xsl:when>
              <xsl:when test="determinedPresence='ABSENT'" >
                <b><xsl:value-of select="$stringsDoc//value[@key='emptyBay']" /></b>
              </xsl:when>
              <xsl:when test="$bladeInfo/hpoa:name = ''">
                <span style="color:#666;"><xsl:value-of select="$stringsDoc//value[@key='unknownDevice']" /></span>
              </xsl:when>
              <xsl:otherwise>
                <b>
                  <xsl:value-of select="$bladeInfo/hpoa:name" />
                </b>
                <xsl:choose>
                  <xsl:when test="($bladeInfo/hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]') and $bladeInfo/hpoa:extraData[@hpoa:name='serverHostName'] != 'Status is not available' and $bladeInfo/hpoa:extraData[@hpoa:name='serverHostName'] != ''">
                    <br />
                    <xsl:value-of select="$stringsDoc//value[@key='name:']" />&#160;<xsl:value-of select="$bladeInfo/hpoa:extraData[@hpoa:name='serverHostName']" />
                  </xsl:when>
                </xsl:choose>                
                
                <xsl:if test="$mpIpAddress and $mpIpAddress != '' and $mpIpAddress != '[Unknown]' and $mpIpAddress != '0.0.0.0'">
                  <xsl:if test="$bladeInfo/hpoa:bladeType='BLADE_TYPE_SERVER'">
                    <br />
                    <b><xsl:value-of select="$stringsDoc//value[@key='iLoIpv4Address']" />:</b>&#160;<xsl:value-of select="$mpIpAddress" />
                  </xsl:if>
                </xsl:if>
                
                <xsl:if test="$bladeMpInfo">
                  <xsl:if test="count($bladeMpInfo//hpoa:bladeMpInfo/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]) &gt; 0" >
                    <br /><b><xsl:value-of select="$stringsDoc//value[@key='iLoIpv6Addresses']" />:</b>
                    <ul style="padding:0px;margin:0px;">
					            <xsl:for-each select="$bladeMpInfo//hpoa:bladeMpInfo/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]">                    
                        <li style="list-style-image:none;margin:0px;padding:0px 0px 0px 4px;">
                          <div style="width:100%;overflow:hidden;text-overflow:ellipsis;">
                          
								            <xsl:choose>
									            <xsl:when test="starts-with(@hpoa:name, 'iLOIPv6LLAddress')">
										            <xsl:value-of select="$stringsDoc//value[@key='linkLocal']" />
									            </xsl:when>
									            <xsl:when test="starts-with(@hpoa:name, 'iLOIPv6DHCPAddress')">
										            <xsl:value-of select="$stringsDoc//value[@key='dhcp']" />
									            </xsl:when>
									            <xsl:when test="starts-with(@hpoa:name, 'iLOIPv6SLAACAddress')">
										            <xsl:value-of select="$stringsDoc//value[@key='slaac']" />
									            </xsl:when>
									            <xsl:when test="starts-with(@hpoa:name, 'iLOIPv6StaticAddress')">
										            <xsl:value-of select="$stringsDoc//value[@key='static']" />
									            </xsl:when>
									            <xsl:when test="starts-with(@hpoa:name, 'iLOIPv6EBIPAAddress')">
										            <xsl:value-of select="$stringsDoc//value[@key='ebipa']" />
									            </xsl:when>
								            </xsl:choose>

								            :&#160;<xsl:value-of select="current()" />
                          
                          </div>
                        </li>
					            </xsl:for-each>                   
                    </ul>
		              </xsl:if>
                </xsl:if>
                
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>

      </table>
    
  </xsl:template>

	<xsl:template name="deviceBayTooltipDD">
		<xsl:param name="myId" />

		<xsl:param name="bladeInfoA" />
		<xsl:param name="bladeStatusA" />

		<xsl:param name="bladeInfoB" />
		<xsl:param name="bladeStatusB" />
		
		<xsl:param name="mpIpAddress" />

		<xsl:variable name="symbolicBladeNumberA" >
			<xsl:call-template name="deviceBaySymbolicNumber">
				<xsl:with-param name="bladeInfo" select="$bladeInfoA" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="symbolicBladeNumberB" >
			<xsl:call-template name="deviceBaySymbolicNumber">
				<xsl:with-param name="bladeInfo" select="$bladeInfoB" />
			</xsl:call-template>
		</xsl:variable>

		<table cellspacing="0" style="border:1px solid #333;width:100%;">
			<tr>
				<td style="border:0px;text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
					<xsl:value-of select="concat($stringsDoc//value[@key='serverBay'] ,' ', $symbolicBladeNumberA)"/>, <xsl:value-of select="concat($stringsDoc//value[@key='serverBay'] ,' ', $symbolicBladeNumberB)"/>
				</td>
			</tr>
			<tr>
				<td style="text-align:left;padding-left:4px;background:white;border:0px;">
					<xsl:choose>
						<xsl:when test="$bladeInfoA/hpoa:presence=$LOCKED or $bladeInfoA/hpoa:presence='PRESENCE_NO_OP'">
							<span style="color:#666;font-style:italic;">
								<xsl:value-of select="$stringsDoc//value[@key='locked']" />
							</span>
						</xsl:when>
						<xsl:when test="$bladeInfoA/hpoa:presence='SUBSUMED'" >
							<span style="color:#666;font-style:italic;">
								<xsl:value-of select="$stringsDoc//value[@key='subsumed']" />
							</span>
						</xsl:when>
						<xsl:when test="$bladeInfoA/hpoa:presence='ABSENT'" >
							<b>
								<xsl:value-of select="$stringsDoc//value[@key='emptyBay']" />
							</b>
						</xsl:when>
						<xsl:when test="$bladeInfoA/hpoa:name = ''">
							<span style="color:#666;">
								<xsl:value-of select="$stringsDoc//value[@key='unknownDevice']" />
							</span>
						</xsl:when>
						<xsl:otherwise>
							<b>
								<xsl:value-of select="$bladeInfoA/hpoa:name" />
							</b>
							<xsl:choose>
								<xsl:when test="($bladeInfoA/hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]') and $bladeInfoA/hpoa:extraData[@hpoa:name='serverHostName'] != 'Status is not available' and $bladeInfoA/hpoa:extraData[@hpoa:name='serverHostName'] != ''">
									<br />
									<xsl:value-of select="$stringsDoc//value[@key='name:']" />&#160;<xsl:value-of select="$bladeInfoA/hpoa:extraData[@hpoa:name='serverHostName']" />
								</xsl:when>
							</xsl:choose>
							<xsl:if test="$mpIpAddress and $mpIpAddress != '' and $mpIpAddress != '[Unknown]'">
								<xsl:if test="$bladeInfoA/hpoa:bladeType='BLADE_TYPE_SERVER'">
									<br />
									<xsl:value-of select="$stringsDoc//value[@key='iLoIp:']" />&#160;<xsl:value-of select="$mpIpAddress" />
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>

			<tr>
				<td style="text-align:left;padding-left:4px;background:white;border:0px;">
					<xsl:choose>
						<xsl:when test="$bladeInfoB/hpoa:presence=$LOCKED or $bladeInfoB/hpoa:presence='PRESENCE_NO_OP'">
							<span style="color:#666;font-style:italic;">
								<xsl:value-of select="$stringsDoc//value[@key='locked']" />
							</span>
						</xsl:when>
						<xsl:when test="$bladeInfoB/hpoa:presence='SUBSUMED'" >
							<span style="color:#666;font-style:italic;">
								<xsl:value-of select="$stringsDoc//value[@key='subsumed']" />
							</span>
						</xsl:when>
						<xsl:when test="$bladeInfoB/hpoa:presence='ABSENT'" >
							<b>
								<xsl:value-of select="$stringsDoc//value[@key='emptyBay']" />
							</b>
						</xsl:when>
						<xsl:when test="$bladeInfoB/hpoa:name = ''">
							<span style="color:#666;">
								<xsl:value-of select="$stringsDoc//value[@key='unknownDevice']" />
							</span>
						</xsl:when>
						<xsl:otherwise>
							<b>
								<xsl:value-of select="$bladeInfoB/hpoa:name" />
							</b>
							<xsl:choose>
								<xsl:when test="($bladeInfoB/hpoa:extraData[@hpoa:name='serverHostName'] != '[Unknown]') and $bladeInfoB/hpoa:extraData[@hpoa:name='serverHostName'] != 'Status is not available' and $bladeInfoB/hpoa:extraData[@hpoa:name='serverHostName'] != ''">
									<br />
									<xsl:value-of select="$stringsDoc//value[@key='name:']" />&#160;<xsl:value-of select="$bladeInfoB/hpoa:extraData[@hpoa:name='serverHostName']" />
								</xsl:when>
							</xsl:choose>
							<xsl:if test="$mpIpAddress and $mpIpAddress != '' and $mpIpAddress != '[Unknown]'">
								<xsl:if test="$bladeInfoB/hpoa:bladeType='BLADE_TYPE_SERVER'">
									<br />
									<xsl:value-of select="$stringsDoc//value[@key='iLoIp:']" />&#160;<xsl:value-of select="$mpIpAddress" />
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>

		</table>

	</xsl:template>

  <xsl:template name="fanBayTooltip">
    <xsl:param name="bayNum" />
    <xsl:param name="fanInfoDoc" />
    <xsl:param name="fanZone" />
    <xsl:param name="encNum" />

    <!--<xsl:variable name="myId" ></xsl:variable>-->
    <xsl:variable name="myId" >
		 <xsl:choose>
			 <xsl:when test="$fanZone='true'" >
				 <xsl:value-of select="concat('fanZoneFanBay_', $bayNum)" />
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:value-of select="concat('enc', $encNum, 'fan', $bayNum, 'Select')" />
			 </xsl:otherwise>
		 </xsl:choose>
    </xsl:variable>
    <xsl:variable name="fanInfo" select="$fanInfoDoc//hpoa:fanInfo[hpoa:bayNumber=$bayNum]" />

    <xsl:variable name="fanSpeed" >
      <xsl:call-template name="getFanSpeedPercent">
        <xsl:with-param name="rpm" select="$fanInfo/hpoa:fanSpeed" />
        <xsl:with-param name="maxFanSpeed" select="$fanInfo/hpoa:maxFanSpeed" />
      </xsl:call-template>
    </xsl:variable>

  <xsl:element name="div" >
      <xsl:attribute name="class">deviceInfo</xsl:attribute>
	  <xsl:attribute name="encNum">1</xsl:attribute>
      <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="concat($myId,'InfoTip')"/>
      </xsl:attribute>
      <table cellspacing="0" style="border:1px solid #333;width:100%;">
        <tr>
          <td style="border:0px;text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
            <xsl:value-of select="concat($stringsDoc//value[@key='fanBay'] ,' ', $fanInfo/hpoa:bayNumber)"/>
          </td>
        </tr>
        <tr>
          <td style="text-align:left;padding-left:4px;background:white;border:0px;">
            <xsl:choose>
              <xsl:when test="$fanInfo/hpoa:presence=$LOCKED or $fanInfo/hpoa:presence='PRESENCE_NO_OP'">
                <span style="color:#666;font-style:italic;"><xsl:value-of select="$stringsDoc//value[@key='locked']" /></span>
              </xsl:when>
              <xsl:when test="$fanInfo/hpoa:presence!='PRESENT'" >
                <b><xsl:value-of select="$stringsDoc//value[@key='emptyBay']" /></b>
              </xsl:when>
              <xsl:otherwise>
                <b>
                  <xsl:value-of select="$fanInfo/hpoa:name" />
                </b>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>

        <xsl:if test="$fanInfo/hpoa:presence='PRESENT' or $fanInfo/hpoa:operationalStatus!='OP_STATUS_UNKNOWN'">
          <tr>
            <td style="text-align:left;padding-left:4px;background:white;border:0px;">
              <xsl:value-of select="$stringsDoc//value[@key='status:']" />&#160;
              <xsl:choose>
                <xsl:when test="hpoa:presence='ABSENT' and hpoa:diagnosticChecksEx/hpoa:diagnosticData[@hpoa:name='deviceMissing']='ERROR'">
                  <xsl:call-template name="statusIcon" >
                    <xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
                  </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='fanNeeded']" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="getStatusLabel">
                    <xsl:with-param name="statusCode" select="$fanInfo/hpoa:operationalStatus" />
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <xsl:if test="$fanInfo/hpoa:presence='PRESENT'">
            <tr>
              <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                <xsl:value-of select="$stringsDoc//value[@key='fanSpeed:']" />&#160;
                <xsl:value-of select="$fanSpeed"/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="$fanInfo/hpoa:operationalStatus!='OP_STATUS_OK'" >
            <tr>
              <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                <hr />
              </td>
            </tr>
            <!-- Possilbe Diagnostic values:
            "NOT_RELEVANT","DIAGNOSTIC_CHECK_NOT_PERFORMED","NO_ERROR","ERROR"/>-->
            <xsl:if test="$fanInfo//hpoa:internalDataError='ERROR'" >
              <tr>
                <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                  <xsl:call-template name="getDiagnosticStatusIcon" >
                    <xsl:with-param name="diagnosticCode" select="$fanInfo//hpoa:internalDataError" />
                    <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                  </xsl:call-template>
                  &#160;<xsl:value-of select="$stringsDoc//value[@key='deviceIdError']" />
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="$fanInfo//hpoa:deviceLocationError='ERROR'" >
              <tr>
                <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                  <xsl:call-template name="getDiagnosticStatusIcon" >
                    <xsl:with-param name="diagnosticCode" select="$fanInfo//hpoa:deviceLocationError" />
                    <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                  </xsl:call-template>
                  &#160;<xsl:value-of select="$stringsDoc//value[@key='improperLocation']" />
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="$fanInfo//hpoa:deviceFailure='ERROR'" >
              <tr>
                <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                  <xsl:call-template name="getDiagnosticStatusIcon" >
                    <xsl:with-param name="diagnosticCode" select="$fanInfo//hpoa:deviceFailure" />
                    <xsl:with-param name="statusCode" select="$OP_STATUS_NON_RECOVERABLE_ERROR" />
                  </xsl:call-template>
                  &#160;<xsl:value-of select="$stringsDoc//value[@key='deviceFailure']" />
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="$fanInfo//hpoa:deviceDegraded='ERROR'" >
              <tr>
                <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                  <xsl:call-template name="getDiagnosticStatusIcon" >
                    <xsl:with-param name="diagnosticCode" select="$fanInfo//hpoa:deviceDegraded" />
                    <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                  </xsl:call-template>
                  &#160;<xsl:value-of select="$stringsDoc//value[@key='deviceDegraded']" />
                </td>
              </tr>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </table>
    </xsl:element>
  </xsl:template>

  <xsl:template name="interconnectBayTooltip">
    <xsl:param name="myId" />
    <xsl:param name="trayInfo" />
    <!-- boolean, true to show thermal info in tip -->
    <xsl:param name="fanZone" />
    <xsl:param name="trayStatus" />

    <xsl:element name="div">

      <xsl:attribute name="class">deviceInfo</xsl:attribute>
      <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="concat($myId,'InfoTip')"/></xsl:attribute>
      <table cellspacing="0" style="border:1px solid #333;width:100%;">
        <tr>
          <td style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
            <xsl:value-of select="concat($stringsDoc//value[@key='interconnectBay'] ,' ', $trayInfo/hpoa:bayNumber)"/>
          </td>
        </tr>
        <tr>
          <td style="text-align:left;padding-left:4px;background:white;border:0px;">
            <xsl:choose>
              <xsl:when test="$trayInfo/hpoa:name = ''">
                <span style="color:#666;"><xsl:value-of select="$stringsDoc//value[@key='unknownDevice']" /></span>
              </xsl:when>
              <xsl:otherwise>
                <b>
                  <xsl:value-of select="$trayInfo/hpoa:name" />
                </b>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <xsl:if test="$trayStatus and $trayStatus/hpoa:presence='PRESENT' ">
          <tr>
            <td style="text-align:left;padding-left:4px;background:white;border:0px;">
              <xsl:value-of select="$stringsDoc//value[@key='status:']" />&#160;<xsl:call-template name="getStatusLabel">
                <xsl:with-param name="statusCode" select="$trayStatus/hpoa:operationalStatus" />
              </xsl:call-template>
            </td>
          </tr>
          <xsl:if test="$fanZone='true'" >
            <tr>
              <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                <hr />
              </td>
            </tr>
            <!-- Possilbe Diagnostic values:
            "NOT_RELEVANT","DIAGNOSTIC_CHECK_NOT_PERFORMED","NO_ERROR","ERROR"/>-->
            <tr>
              <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                <xsl:value-of select="$stringsDoc//value[@key='thermalStatus:']" />&#160;
                <xsl:call-template name="getThermalLabel" >
                  <xsl:with-param name="statusCode" select="$trayStatus/hpoa:thermal" />
                </xsl:call-template>
              </td>
            </tr>
            <xsl:choose>
              <xsl:when test="$trayStatus//hpoa:thermalDanger='ERROR'" >
                <tr>
                  <td style="text-align:left;padding-left:4px;background:white;border:0px;" >
                    <xsl:value-of select="$stringsDoc//value[@key='thermalDanger!']" />&#160;
                    <xsl:call-template name="getDiagnosticStatusIcon" >
                      <xsl:with-param name="diagnosticCode" select="$trayStatus//hpoa:thermalDanger" />
                      <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                    </xsl:call-template>
                  </td>
                </tr>
              </xsl:when>
              <xsl:when test="$trayStatus//hpoa:thermalWarning='ERROR'" >
                <tr>
                  <td style="text-align:left;padding-left:4px;background:white;border:0px;">
                    <xsl:value-of select="$stringsDoc//value[@key='thermalWarning!']" />&#160;
                    <xsl:call-template name="getDiagnosticStatusIcon" >
                      <xsl:with-param name="diagnosticCode" select="$trayStatus//hpoa:thermalWarning" />
                      <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                    </xsl:call-template>
                  </td>
                </tr>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:if>
      </table>
    </xsl:element>
  </xsl:template>

  <!-- Gets a readable label for the different power state enumeration codes. -->
  <xsl:template name="getFanLink">
    <xsl:param name="fanInfo" />
    <xsl:param name="background-color" />
    <xsl:param name="foreground-color" />
    <xsl:param name="encNum" />

    <xsl:variable name="myId">
      <xsl:value-of select="concat('fanZoneFanBay_', $fanInfo//hpoa:bayNumber)" />
    </xsl:variable>
    <xsl:variable name="fanStatus">
      <xsl:call-template name="guiStatusCode" >
        <xsl:with-param name="statusCode" select="$fanInfo/hpoa:operationalStatus" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="bgColor">
      <xsl:if test="$background-color">
        <xsl:value-of select="concat('background-color:',$background-color,';')" />
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="fgColor">
      <xsl:if test="$foreground-color">
        <xsl:value-of select="concat('color:',$foreground-color,';')" />
      </xsl:if>
    </xsl:variable>
    <xsl:element name="span">
		 <xsl:attribute name="encNum">
			 <xsl:value-of select="$encNum" />
		 </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="$myId" />
      </xsl:attribute>
		 <xsl:attribute name="blah">blah2</xsl:attribute>
      <xsl:attribute name="style">z-index:10;cursor:default;</xsl:attribute>
      <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,150,'zone_fan');}catch(e){}</xsl:attribute>
      <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
      <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
      <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
      <!--Settheclassattributeofthetablecellforalternating-->
      <xsl:attribute name="style">
        <xsl:value-of select="concat($bgColor,$fgColor,'cursor:default;')" />
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$fanInfo//hpoa:presence='ABSENT' and $fanInfo/hpoa:operationalStatus='OP_STATUS_UNKNOWN'">
          <xsl:value-of select="$fanInfo//hpoa:bayNumber" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$fanStatus='STATUS_FAILED_IMAGE' ">
              <xsl:attribute name="style">
                color:black;border: 2px solid red;padding: 0px 1px 0px 1px;cursor:default;<xsl:value-of select="$bgColor" /><xsl:value-of select="$fgColor" />
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$fanStatus='STATUS_MAJOR_IMAGE' ">
              <xsl:attribute name="style">
                color:black;border: 2px solid orange;padding: 0px 1px 0px 1px;cursor:default;<xsl:value-of select="$bgColor" /><xsl:value-of select="$fgColor" />
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$fanStatus='STATUS_MINOR_IMAGE' ">
              <xsl:attribute name="style">
                color:black;border: 2px solid yellow;padding: 0px 1px 0px 1px;cursor:default;<xsl:value-of select="$bgColor" /><xsl:value-of select="$fgColor" />
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:element name="a">
            <xsl:attribute name="style">
              <xsl:value-of select="$bgColor" />
              <xsl:value-of select="$fgColor" />
            </xsl:attribute>
            <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="$fanInfo//hpoa:bayNumber" />,FAN())</xsl:attribute>
            <xsl:value-of select="$fanInfo//hpoa:bayNumber" />
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template name="getFanSpeedPercent">
    <xsl:param name="rpm" />
    <xsl:param name="maxFanSpeed" />

    <xsl:variable name ="speed">
      <xsl:choose>
        <xsl:when test="not($maxFanSpeed='' or string($maxFanSpeed)='NaN')">
          <xsl:value-of select="round(($rpm div $maxFanSpeed)*100)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="round($rpm div 180)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string($speed)='NaN' or $speed &lt; 0">
        0%
      </xsl:when>
      <xsl:when test="$speed &gt; 100">
        100%
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$speed"/>%
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="emBayTooltip">   
    <xsl:param name="bayNum" />
    <xsl:param name="oaInfo" />
    <xsl:param name="oaStatus" />
		<xsl:param name="oaNetInfo" />
		<xsl:param name="oaIp" />
    
    <xsl:variable name="description" select="$oaInfo//hpoa:oaInfo[hpoa:bayNumber=$bayNum]/hpoa:name" />
    <xsl:variable name="fwVersion" select="$oaInfo//hpoa:oaInfo[hpoa:bayNumber=$bayNum]/hpoa:fwVersion" />
    <xsl:variable name="role" select="$oaStatus//hpoa:oaStatus[hpoa:bayNumber=$bayNum]/hpoa:oaRole" />
    <xsl:variable name="status" select="$oaStatus//hpoa:oaStatus[hpoa:bayNumber=$bayNum]/hpoa:operationalStatus" />
		<xsl:variable name="ipAddress">
			<xsl:choose>
				<xsl:when test="count($oaNetInfo//hpoa:oaNetworkInfo[hpoa:bayNumber=$bayNum]/hpoa:ipAddress) &gt; 0">
					<xsl:value-of select="$oaNetInfo//hpoa:oaNetworkInfo[hpoa:bayNumber=$bayNum]/hpoa:ipAddress"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$oaIp"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
  
    <table cellspacing="0" style="border:1px solid #333;width:100%;table-layout:fixed;">
      <tr>
        <td style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
          <xsl:value-of select="concat($stringsDoc//value[@key='bay'] ,' ', $bayNum)"/>
        </td>
      </tr>
      <tr>
        <td style="text-align:left;padding-left:4px;background:white;border:0px;">
          <b><xsl:value-of select="$description"/></b>
        </td>
      </tr>
      <tr>
        <td style="text-align:left;padding-left:4px;background:white;border:0px;">         
          
          <xsl:if test="$ipAddress and $ipAddress != '' and $ipAddress != '[Unknown]' and $ipAddress != '0.0.0.0'">            
            <b><xsl:value-of select="$stringsDoc//value[@key='ipv4Address']" />:</b>
            &#160;<xsl:value-of select="$ipAddress" />        
          </xsl:if>
                
          <xsl:if test="count($oaNetInfo//hpoa:oaNetworkInfo[hpoa:bayNumber=$bayNum]/hpoa:extraData[starts-with(@hpoa:name,'Ipv6AddressType') and . != 'NotSet']) &gt; 0" >
            <br /><b>IPv6 Addresses:</b>
            <ul style="padding:0px;margin:0px;">
					    <xsl:for-each select="$oaNetInfo//hpoa:oaNetworkInfo[hpoa:bayNumber=$bayNum]/hpoa:extraData[starts-with(@hpoa:name,'Ipv6AddressType') and . != 'NotSet']">   
                <xsl:variable name="currentNodeName" select="@hpoa:name" />
                
                <li style="list-style-image:none;margin:0px;padding:0px 0px 0px 4px;">
                  <div style="width:100%;overflow:hidden;text-overflow:ellipsis;">
                    
                    <xsl:choose>
									    <xsl:when test=". = 'STATIC'">
										    <xsl:value-of select="$stringsDoc//value[@key='static']" />
									    </xsl:when>
                      <xsl:when test=". = 'LINKLOCAL'">
										    <xsl:value-of select="$stringsDoc//value[@key='linkLocal']" />
									    </xsl:when>
                      <xsl:when test=". = 'ROUTERADV'">
										    <xsl:value-of select="$stringsDoc//value[@key='slaac']" />
									    </xsl:when>
                      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
								    </xsl:choose>                  
                    
                    <!-- address type is associated by number: Ipv6Address0 matches Ipv6AddressType0 -->
                    :&#160;<xsl:value-of select="$oaNetInfo//hpoa:oaNetworkInfo[hpoa:bayNumber=$bayNum]/hpoa:extraData[@hpoa:name = (concat('Ipv6Address', substring-after($currentNodeName, 'Ipv6AddressType')))]" />
                    
                  </div>
                </li>
					    </xsl:for-each>                   
            </ul>
		      </xsl:if>       
          
        </td>
      </tr>
      <tr>
        <td style="text-align:left;padding-left:4px;background:white;border:0px;">
          <xsl:value-of select="$stringsDoc//value[@key='firmwareVersion:']" />&#160;<xsl:value-of select="$fwVersion"/>
        </td>
      </tr>
      <tr>
        <td style="text-align:left;padding-left:4px;background:white;border:0px;">
          <xsl:choose>
            <xsl:when test="$role=$ACTIVE">
              <xsl:value-of select="$stringsDoc//value[@key='role:']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='active']" />
            </xsl:when>
            <xsl:when test="$role=$STANDBY">
              <xsl:value-of select="$stringsDoc//value[@key='role:']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='standby']" />
            </xsl:when>
          </xsl:choose>
        </td>
      </tr>        
      <tr>
        <td style="text-align:left;padding-left:4px;background:white;border:0px;">
          <xsl:value-of select="$stringsDoc//value[@key='status:']" />&#160;
          <xsl:call-template name="getStatusLabel">
            <xsl:with-param name="statusCode" select="$status" />
          </xsl:call-template>
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <!-- Power Supply Tooltip -->
  <xsl:template name="powerSupplyTooltip">
    <xsl:param name="bayNum" />
    <xsl:param name="psInfoDoc" />
    <xsl:param name="psStatusDoc" />    

		<xsl:variable name="status" select="$psStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$bayNum]/hpoa:operationalStatus" />
    <xsl:variable name="inputStatus" select="$psStatusDoc//hpoa:powerSupplyStatus[hpoa:bayNumber=$bayNum]/hpoa:inputStatus" />    
    
    <table cellspacing="0" style="border:1px solid #333;width:100%;">
      <tr>
        <td style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
          <xsl:value-of select="concat($stringsDoc//value[@key='powerSupply'],' ', $bayNum)"/>
        </td>
      </tr>
      <tr>
        <td style="text-align:left;padding-left:4px;padding-top:4px;background:white;border:0px;">
          <xsl:value-of select="$stringsDoc//value[@key='status:']" /><span style="width:5px;">&#160;</span>
          <xsl:call-template name="getStatusLabel">
            <xsl:with-param name="statusCode" select="$status" />
          </xsl:call-template>
        </td>
      </tr>       
      <tr>
        <td style="white-space:nowrap;text-align:left;padding-left:4px;background:white;border:0px;">
          <xsl:value-of select="$stringsDoc//value[@key='inputStatus:']" /><span style="width:5px">&#160;</span>
          <xsl:call-template name="getStatusLabel">
            <xsl:with-param name="statusCode" select="$inputStatus" />
          </xsl:call-template>          
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- DVD Drive Tooltip -->
  <xsl:template name="dvdDriveTooltip">

    <xsl:param name="encNum" />
    <xsl:param name="drivePresence" />
    <xsl:param name="mediaPresence" />    

    <table cellspacing="0" style="border:1px solid #333;width:100%;">
      <tr>
        <td colspan="2" style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
          <xsl:value-of select="$stringsDoc//value[@key='mediaDevice']" />
        </td>
      </tr>
      <tr>
        <td style="text-align:left;padding-left:4px;background:white;border:0px;">
          <xsl:choose>
            <xsl:when test="$drivePresence">
              <b><xsl:value-of select="$stringsDoc//value[@key='dvdDrive']" /></b>

              <xsl:choose>
                <xsl:when test="$mediaPresence">
				  <br /><xsl:value-of select="$stringsDoc//value[@key='mediaPresent']" />
                </xsl:when>
                <xsl:otherwise>
				  <br /><xsl:value-of select="$stringsDoc//value[@key='trayOpenOrNoMedia']" />
                </xsl:otherwise>
              </xsl:choose>
              
            </xsl:when>
            <xsl:otherwise>
              <b><xsl:value-of select="$stringsDoc//value[@key='driveBayEmpty']" /></b>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>      
    </table>

  </xsl:template>

  <!-- Power Input Module tooltip template -->
  <xsl:template name="pimTooltip">

    <xsl:param name="encNum" />
    <xsl:param name="pimTypeText" />
    
    <xsl:element name="div">
      <xsl:attribute name="class">deviceInfo</xsl:attribute>
      <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="concat('enc', $encNum, 'pim1SelectInfoTip')"/>
      </xsl:attribute>
      <table cellspacing="0" style="border:1px solid #333;width:100%;">
        <tr>
          <td colspan="2" style="text-align:left;padding-left:2px;width:20%;background-color:#666;color:white;">
            <xsl:value-of select="$stringsDoc//value[@key='pim']" />
          </td>
        </tr>
        <tr>
          <td style="text-align:left;padding-left:4px;background:white;border:0px;">
            <xsl:value-of select="$pimTypeText"/>
          </td>
        </tr>

      </table>
    </xsl:element>

  </xsl:template>

  <!-- error tooltip. -->
  <xsl:template name="errorTooltip">
    <xsl:param name="stringsFileKey" />
    <xsl:param name="clickHandler" />

    <xsl:element name="a">
      <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
      <xsl:attribute name="onmouseover">
        try{showHelpTip(event,this,true,'<xsl:value-of select="$stringsFileKey" />','250');}catch(e){}
      </xsl:attribute>
      <xsl:attribute name="onmouseout">try{showHelpTip(event,this,false);}catch(e){}</xsl:attribute>
      <xsl:attribute name="style">margin-left:8px;</xsl:attribute>
      
      <xsl:variable name="imgStyle">
        <xsl:choose>
          <xsl:when test="$clickHandler = ''">width:12px;height:12px;vertical-align:middle;border:0px;cursor:default;pointer:default;</xsl:when>
          <xsl:otherwise>width:12px;height:12px;vertical-align:middle;border:0px;</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:element name="img">
        <xsl:attribute name="src">/120814-042457/images/icons/icon_help_square.gif</xsl:attribute>
        <xsl:attribute name="alt"></xsl:attribute>
        <xsl:attribute name="style"><xsl:value-of select="$imgStyle"/></xsl:attribute>
        
        <xsl:if test="$clickHandler != ''">
          <xsl:attribute name="onclick"><xsl:value-of select="$clickHandler"/></xsl:attribute>
        </xsl:if>
      </xsl:element>

    </xsl:element>
  </xsl:template>

  <xsl:template name="getIloFwVersionLabel">
    <xsl:param name="productId"/>
    <xsl:param name="fwVersion"/>
		<xsl:param name="iloModel"/>

		<!-- This template is no longer used to validate versions. Previous iLO version was 1.81 -->
		<xsl:value-of select="$fwVersion"/>
		
  </xsl:template>

  <xsl:template name="getDvdStatusLabel">

    <xsl:param name="dvdStatus" />
    <xsl:param name="dvdSupport" />

    <xsl:choose>

      <xsl:when test="$dvdSupport='VM_FIRMWARE_UPDATE_NEEDED'">
        <xsl:value-of select="$stringsDoc//value[@key='incompatibleFirmware']" />
      </xsl:when>
      <xsl:when test="$dvdSupport='VM_NOT_SUPPORTED'">
        <xsl:value-of select="$stringsDoc//value[@key='notSupported']" />
      </xsl:when>
      <!-- This should never happen, but it's here in case -->
      <xsl:when test="$dvdSupport='VM_DEV_ABSENT'">
        <xsl:value-of select="$stringsDoc//value[@key='deviceAbsent']" />
      </xsl:when>
      <!-- This should also never happen, but it's here in case -->
      <xsl:when test="$dvdSupport='VM_BAY_SUBSUMED'">
        <xsl:value-of select="$stringsDoc//value[@key='baySubsumed']" />
      </xsl:when>
      <xsl:when test="$dvdSupport='VM_SUPPORT_UNKNOWN'">
        <xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
      </xsl:when>
      <xsl:otherwise>
			<xsl:choose>
				<xsl:when test="$dvdStatus='VM_DEV_STATUS_DISCONNECTED'">
					<xsl:value-of select="$stringsDoc//value[@key='disconnected']" />
				</xsl:when>
				<xsl:when test="$dvdStatus='VM_DEV_STATUS_CONNECTED'">
					<xsl:value-of select="$stringsDoc//value[@key='connected']" />
				</xsl:when>
				<xsl:when test="$dvdStatus='VM_DEV_STATUS_DISCONNECTING'">
					<xsl:value-of select="$stringsDoc//value[@key='disconnecting']" />
				</xsl:when>
				<xsl:when test="$dvdStatus='VM_DEV_STATUS_CONNECTING'">
					<xsl:value-of select="$stringsDoc//value[@key='connecting']" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
				</xsl:otherwise>
			</xsl:choose>

		</xsl:otherwise>

	</xsl:choose>

</xsl:template>
  
<xsl:template name="getDeviceTypeLabel">
  <xsl:param name="enumType" select="''" />
  
  <xsl:choose>
    <xsl:when test="$enumType = 'DEVICE_BLADE'"><xsl:value-of select="$stringsDoc//value[@key='serverBlade']" /></xsl:when>
    <xsl:when test="$enumType = 'DEVICE_INTERCONNECT_TRAY'"><xsl:value-of select="$stringsDoc//value[@key='interconnect']" /></xsl:when>
    <xsl:when test="$enumType = 'DEVICE_POWER_SUPPLY'"><xsl:value-of select="$stringsDoc//value[@key='powerSupply']" /></xsl:when>
    <xsl:when test="$enumType = 'DEVICE_FAN'"><xsl:value-of select="$stringsDoc//value[@key='fan']" /></xsl:when>
    <xsl:when test="$enumType = 'DEVICE_OA'"><xsl:value-of select="$stringsDoc//value[@key='EM']" /></xsl:when>
    <xsl:when test="$enumType = 'DEVICE_LCD'"><xsl:value-of select="$stringsDoc//value[@key='lcdScreen']" /></xsl:when>
    <xsl:when test="$enumType = 'DEVICE_ENCLOSURE'"><xsl:value-of select="$stringsDoc//value[@key='enclosure']" /></xsl:when>
    <xsl:when test="$enumType = 'DEVICE_INTERPOSER'"><xsl:value-of select="$stringsDoc//value[@key='oaTray']" /></xsl:when>
    <xsl:otherwise><xsl:value-of select="$enumType"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="enclosureIcon">

	<xsl:param name="encType" />
	<xsl:param name="isTower" />
	<xsl:param name="isLocal" />
	<xsl:param name="isAuthenticated" />
  <xsl:param name="productName" />

	<xsl:variable name="iconType">
		<xsl:choose>
			<xsl:when test="$encType=1">
				<xsl:choose>
					<xsl:when test="$isTower = 'true'">_tower</xsl:when>
					<xsl:otherwise>_c3000</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:element name="img">
		<xsl:attribute name="style">border:0;</xsl:attribute>
		<xsl:attribute name="align">center</xsl:attribute>
     <xsl:attribute name="alt">
      <xsl:if test="$productName != '' and $productName != '[Access Denied]'">
       <xsl:value-of select="$productName" />
      </xsl:if>
      <xsl:text></xsl:text>
    </xsl:attribute>
		<xsl:choose>
			<xsl:when test="$isAuthenticated='false'">
				<xsl:attribute name="src"><xsl:value-of select="concat('/120814-042457/images/icon_server_lock', $iconType, '.gif')" /></xsl:attribute>
			</xsl:when>
			<xsl:when test="$isLocal='true'">
				<xsl:attribute name="src"><xsl:value-of select="concat('/120814-042457/images/icon_server_connected', $iconType, '.gif')" /></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="src"><xsl:value-of select="concat('/120814-042457/images/icon_server_32', $iconType, '.gif')"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
</xsl:template>
	
	
  <xsl:template name="getPowerConsumed">
    <xsl:param name="powerSubsystemInfoDoc" />
    <xsl:variable name="powerConsumed">
      <xsl:choose>
        <xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerVa=0">
          <xsl:choose>
            <xsl:when test="string(round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPower)))='NaN'">
              <xsl:value-of select="$stringsDoc//value[@key='notAvailable']" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPower))" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="string(round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerVa)))='NaN'">
              <xsl:value-of select="$stringsDoc//value[@key='notAvailable']" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="round(number($powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:inputPowerVa))" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$powerConsumed" />
  </xsl:template>

	<xsl:template name="getRomLabel">
		<xsl:param name="oaVersion"/>
		<xsl:param name="romVersion"/>
		<xsl:param name="romVersionString"/>
		<xsl:param name="suggestedVersion"/>

		<xsl:choose>
			<xsl:when test="$oaVersion &lt;= 1.30" >
				<xsl:value-of select="$romVersionString"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:when test="$oaVersion &gt; 1.30" > -->
				<xsl:choose>
					<xsl:when test="$romVersion &lt; $suggestedVersion " >
						<xsl:call-template name="statusIcon" >
							<xsl:with-param name="statusCode" select="string('Informational')" />
						</xsl:call-template>&#160;
						<xsl:value-of select="$romVersionString"/>
						<xsl:call-template name="errorTooltip">
							<xsl:with-param name="stringsFileKey" select="'rom-fw-old'" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$romVersionString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <hpoa:guidLabelFormats>
    <labelFormat type=""  ilo_label=""      f_label="FlexNIC" />
    <labelFormat type="E" ilo_label="NIC"   f_label="Ethernet FlexNIC" />
    <labelFormat type="F" ilo_label=""      f_label="FCoE FlexHBA" />
    <labelFormat type="I" ilo_label="iSCSI" f_label="iSCSI FlexHBA" />
    <labelFormat type="C" ilo_label="NIC"   f_label="Ethernet" />
    <labelFormat type="G" ilo_label=""      f_label="FCoE HBA" />
    <labelFormat type="H" ilo_label="iSCSI" f_label="iSCSI HBA" />
  </hpoa:guidLabelFormats>

  <xsl:variable name="guidLabelFormats" select="document('')//hpoa:guidLabelFormats" />
  
  <!--
    @purpose  : uses portName and portType to determine if a known iLO label format exists.
    
    @params   : portType (char) see type attribute in hpoa:guidLabelFormats
              : portName (string) example: 'iSCSI 2'
              
    @notes    :
  -->
  <xsl:template name="isILOPortType">
    <xsl:param name="portType" />
    <xsl:param name="portName" />

    <xsl:choose>
      <xsl:when test="count($guidLabelFormats/labelFormat[@type = $portType]) &gt; 0">
        <xsl:variable name="labelFormat" select="$guidLabelFormats/labelFormat[@type = $portType]" />
        <xsl:choose>
          <xsl:when test="$labelFormat/@ilo_label = ''">
            <xsl:value-of select="false()" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($portName, 1, string-length($labelFormat/@ilo_label)) = $labelFormat/@ilo_label"/>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="false()" /></xsl:otherwise>
    </xsl:choose>   
  </xsl:template>

  <!--
    @purpose  : assigns a label that will match the CLI output
    
    @params   : bladeInfo (doc) for a single device
              : guidStruct (hpoa:guid) from bladeMezzInfoEx
              : mezzNumber (int) mezz location
    
    @notes    :
  -->
  <xsl:template name="getGuidLabel">
    <xsl:param name="bladeInfo" />
    <xsl:param name="guidStruct" />
    <xsl:param name="mezzNumber" />        
    
    <xsl:variable name="lblType">
      <!-- 
        if the blade nic info contains ports that are already represented by port map or mezz info, 
        we will show the blade nic port labels, with the iSCSI label being preferred if present.
      -->
      <xsl:if test="count($bladeInfo//hpoa:nics/hpoa:bladeNicInfo[hpoa:macAddress = $guidStruct/hpoa:guid]) &gt; 0">
        <xsl:choose>
          <xsl:when test="($guidStruct/hpoa:type = 'I' or $guidStruct/hpoa:type = 'H') and count($bladeInfo//hpoa:nics/hpoa:bladeNicInfo[(hpoa:macAddress = $guidStruct/hpoa:guid) and contains(hpoa:port, 'iSCSI')]) &gt; 0">
            <xsl:value-of select="concat('(', $bladeInfo//hpoa:nics/hpoa:bladeNicInfo[hpoa:macAddress = $guidStruct/hpoa:guid and contains(hpoa:port, 'iSCSI')]/hpoa:port, ') ')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('(', $bladeInfo//hpoa:nics/hpoa:bladeNicInfo[hpoa:macAddress = $guidStruct/hpoa:guid]/hpoa:port, ') ')"/>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:if> 
      <xsl:choose>       
        <xsl:when test="$mezzNumber = $MEZZ_NUMBER_FIXED">LOM</xsl:when>
        <xsl:when test="$mezzNumber &lt;= $FLB_START_IX"><xsl:value-of select="concat('MZ', $mezzNumber)"/></xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('LOM', ($mezzNumber - $FLB_START_IX))" />
        </xsl:otherwise>        
      </xsl:choose>
    </xsl:variable>
	
    <xsl:variable name="prefix" select="$guidLabelFormats/labelFormat[@type = $guidStruct/hpoa:type]/@f_label" />
    <xsl:variable name="funcString" select="concat($guidStruct/../hpoa:portNumber, '-', $guidStruct/hpoa:physicalFunction)" />

    <xsl:value-of select="concat($prefix, ' ', $lblType, ':', $funcString)" />
    
  </xsl:template>
  
  
  <!--
    @purpose  : assigns a label that will match the CLI output
    
    @params   : bladeInfo (doc) for a single device
              : portNumber (int) port location
              : wwpn (string) unique identifier
    
    @notes    :
  -->
  <xsl:template name="getNonGuidLabel">
    <xsl:param name="bladeInfo" />
    <xsl:param name="portNumber" />
    <xsl:param name="wwpn" />

    <xsl:choose>
      <xsl:when test="count($bladeInfo//hpoa:nics/hpoa:bladeNicInfo[hpoa:macAddress = $wwpn]) &gt; 0">
        <xsl:value-of select="$bladeInfo//hpoa:nics/hpoa:bladeNicInfo[hpoa:macAddress = $wwpn]/hpoa:port" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($stringsDoc//value[@key='port'], ' ', $portNumber)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--
    @purpose  : determines if blade nic info contains any port matches with the blade mezz data or blade port map data.
    
    @params   : bladeInfo (doc) for a single device
              : bladeMezzInfo (doc) for a single device
              
    @notes    :
  -->
  <xsl:template name="totalGuidMatches">
    <xsl:param name="bladeInfo" />
    <xsl:param name="bladePortMap" />
    <xsl:param name="bladeMezzInfo" />

    <xsl:variable name="totalGuid" select="count($bladeMezzInfo//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:port/hpoa:guid[hpoa:guid = $bladeInfo//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo/hpoa:macAddress])" />
    <xsl:variable name="totalWwpn" select="count($bladePortMap//hpoa:bladePortMap//hpoa:mezz[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:mezzDevices/hpoa:port[hpoa:wwpn = $bladeInfo//hpoa:bladeInfo/hpoa:nics/hpoa:bladeNicInfo/hpoa:macAddress])" />

    <xsl:choose>
      <xsl:when test="count($bladeMezzInfo//hpoa:bladeMezzInfoEx/hpoa:mezzInfo[hpoa:mezzNumber &gt; $FLB_START_IX]/hpoa:port/hpoa:guid) &gt; 0">
        <xsl:value-of select="$totalGuid" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$totalWwpn" />
      </xsl:otherwise>
    </xsl:choose>
       
  </xsl:template>

	<!--
		@purpose	: creates a simple tooltip for short messages
		
		@params		: msg (string to be displayed)

		@notes		:
	-->
	<xsl:template name="simpleTooltip">

		<xsl:param name="msg" />

		&#160;&#160;
		<xsl:element name="img">
			<xsl:attribute name="src">/120814-042457/images/icons/icon_help_square.gif</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="$msg" />
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:value-of select="$stringsDoc//value[@key='mnuHelp']" />
			</xsl:attribute>
			<xsl:attribute name="style">tooltipIcon</xsl:attribute>
		</xsl:element>

	</xsl:template>

	<!--
		@purpose	: checks the FIPS mode and presents an error/warning message of the specified type if it is active
		
		@params		: fipsMode (string; possible values are 'FIPS-ON', 'FIPS-DEBUG' or 'FIPS-OFF' (default), and the empty string for linked enclosures with older firmware)
					  msgType (string; either 'tooltip' or 'warning')
					  msgKey (string; possible values are 'fipsRequired', 'fipsUnavailable' and 'fipsNotRecommended', which are keys to messages in strings.??.xml)
					  
		@notes		:
	-->
	<xsl:template name="fipsHelpMsg">
		
		<xsl:param name="fipsMode" />
		<xsl:param name="msgType" />
		<xsl:param name="msgKey" />
		
		<xsl:if test="$fipsMode='FIPS-ON' or $fipsMode='FIPS-DEBUG'">
			<xsl:choose>
				<xsl:when test="$msgType='tooltip'">
					<xsl:call-template name="simpleTooltip">
						<xsl:with-param name="msg" select="$stringsDoc//value[@key=$msgKey]" />
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$msgType='warning'">
					&#160;&#160;
					<span class="strongWarningLabel">
						<xsl:value-of select="$stringsDoc//value[@key='warning']" />&#160;
					</span>
					<span class="disabledText">
						<xsl:value-of select="$stringsDoc//value[@key=$msgKey]" />
					</span>
				</xsl:when>
				<xsl:otherwise> <!-- Debug only; we should never reach this point -->
					<span class="strongWarningLabel">
						INVALID OPTION [<xsl:value-of select="$msgType" />]
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

	</xsl:template>
	
	<xsl:template name="printUrl">
		<xsl:param name="url" />
		<xsl:param name="additionalInfo" />
		<xsl:param name="customOnClickUrl" select="''" />
		<xsl:param name="isIPv4" select="'false'" />
		<xsl:param name="isFqdn" select="'false'" />
		<xsl:if test="$url != ''">
			<xsl:variable name="quote">"</xsl:variable>
			<xsl:choose>
				<xsl:when test="$customOnClickUrl = ''">
					<!-- Adds the 'http://' prefix if 'http' or 'https' is not present; otherwise, if we receive an URL that's only like 'www.something.com', the new page won't open -->
					<xsl:variable name="fixedUrl"><xsl:if test="substring($url, 1, 4) != 'http'">http://</xsl:if><xsl:value-of select="$url" /></xsl:variable>
					<xsl:value-of select="concat('&lt;li style=', $quote, 'list-style:none;list-style-image:none;margin:0px 0px 0px 0px; border: 0px;', $quote, '>&lt;a target=', $quote, '_new', $quote, ' href=', $quote, $fixedUrl, $quote, ' style=', $quote, ' text-overflow: ellipsis; overflow: hidden; display: block; white-space: nowrap; border: 0px; width: 100%;', $quote, '>', $url, $additionalInfo, '&lt;/a>&lt;/li>')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="onClickText" select="concat(' onclick=', $quote, 'return ', $customOnClickUrl, ';', $quote, ' isIPv4=', $quote, $isIPv4, $quote, ' isFqdn=', $quote, $isFqdn, $quote, ' ')" />
					<xsl:value-of select="concat('&lt;li style=', $quote, 'list-style:none;list-style-image:none;margin:2px 0px 2px 0px;', $quote, '>&lt;a href=', $quote, 'javascript:void(0);', $quote, $onClickText, '>', $url, $additionalInfo, '&lt;/a>&lt;/li>')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="urlListTooltip">
		<xsl:param name="fqdn" />
		<xsl:param name="defaultUrl" />
		<xsl:param name="urlList" />
		<xsl:param name="width" select="280" />
		<xsl:param name="customOnClickUrl" select="''" />
		<xsl:param name="itemProxyUrl" select="''"/>
		<xsl:param name="isLocal" select="false"/>

		<xsl:variable name="quote">"</xsl:variable>
		<xsl:element name="a">
			<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
			<xsl:attribute name="onclick">
				showTooltip(event,this,true,<xsl:value-of select="$width"/>);
				preventEventBubble(event);
			</xsl:attribute>
			<xsl:attribute name="bodyText">
				<xsl:value-of select="concat('&lt;ul id=', $quote, 'urlTooltipUL', $quote, ' style=', $quote, 'border: 0px; margin:0px 0px 0px 0px; ', $quote, '>')" />
				<xsl:if test="string-length($fqdn) &gt; 0">
					<xsl:call-template name="printUrl">
						<xsl:with-param name="url" select="concat($itemProxyUrl, $fqdn)" />
						<xsl:with-param name="customOnClickUrl" select="$customOnClickUrl" />
						<xsl:with-param name="isFqdn" select="'true'" />
						<xsl:with-param name="additionalInfo" select="''" />
					</xsl:call-template>
				</xsl:if>
				<!-- IPv4 URL is shown as default when FQDN URL is absent -->
				<xsl:variable name="ipv4AdditionalInfo">
					<xsl:choose>
						<xsl:when test="string-length($fqdn) &gt; 0">
							<xsl:value-of select="''" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('(', $stringsDoc//value[@key='default'], ')')" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$defaultUrl != 'empty' and $defaultUrl != '' and contains($defaultUrl, '0.0.0.0') != 'true'">
					<xsl:choose>
						<xsl:when test="starts-with(defaultUrl, '/') and $isLocal='false'">
							<xsl:call-template name="printUrl">
								<xsl:with-param name="url" select="concat($itemProxyUrl, $defaultUrl)" />
								<xsl:with-param name="customOnClickUrl" select="$customOnClickUrl" />
								<xsl:with-param name="isIPv4" select="'true'" />
								<xsl:with-param name="additionalInfo">&#160;<xsl:value-of select="$ipv4AdditionalInfo" /></xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="printUrl">
								<xsl:with-param name="url" select="$defaultUrl" />
								<xsl:with-param name="customOnClickUrl" select="$customOnClickUrl" />
								<xsl:with-param name="isIPv4" select="'true'" />
								<xsl:with-param name="additionalInfo">&#160;<xsl:value-of select="$ipv4AdditionalInfo" /></xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:for-each select="$urlList">
					<xsl:choose>
						<xsl:when test="starts-with(current(), '/') and $isLocal='false'">
							<xsl:call-template name="printUrl">
								<xsl:with-param name="url" select="concat($itemProxyUrl, current())" />
								<xsl:with-param name="customOnClickUrl" select="$customOnClickUrl" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="printUrl">
								<xsl:with-param name="url" select="." />
								<xsl:with-param name="customOnClickUrl" select="$customOnClickUrl" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:value-of select="'&lt;/ul>'" />
			</xsl:attribute>
			<xsl:element name="img">
				<xsl:attribute name="src">/120814-042457/images/menu-trigger-small.gif</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="style">width:14px;height:14px;margin-left:3px;margin-bottom:-3px;</xsl:attribute>
				<xsl:attribute name="onmouseover">clearTooltipTimer();</xsl:attribute>
				<xsl:attribute name="onmouseout">updateTooltipTimer();</xsl:attribute>
				<xsl:attribute name="title">
					<!-- optional for menu style tooltip -->
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:template>
  
  <hpoa:errorsWithSyslogDetail>
    <errorCode key="368" />
    <errorCode key="383" />
    <errorCode key="385" />
    <errorCode key="528" />
    <errorCode key="532" />
    <errorCode key="561" />
    <errorCode key="562" />
  </hpoa:errorsWithSyslogDetail>
  
  <xsl:variable name="errorsWithSyslogDetail" select="document('')//hpoa:errorsWithSyslogDetail" />
  
  <!--
		@purpose	: attempts to locate a string by key, otherwise returns the original.
		
		@params		: localizedStringsDoc - the currently loaded stringsDOM document.
                key - unique identifier in the strings file.
                originalString - return value if a localized version is not found.
					  
		@notes		: error strings contain a key and a type attribute in the strings file, 
                however all SOAP fault error codes are unique and can be retrieved without 
                specifying a type; there are some CGI and client-side error strings that
                have error codes matching the lowest SOAP fault codes, but they are located
                later in the document, and XPATH always returns the first occurrence.
                
              : added test for soap fault codes requiring syslog message.
	-->
  <xsl:template name="assertLocalizedString">
    <xsl:param name="localizedStringsDoc" />
    <xsl:param name="key" select="''" />
    <xsl:param name="originalString" select="''" />
    
    <xsl:variable name="localizedString" select="$localizedStringsDoc//value[@key=$key]" />
    <xsl:variable name="errorMatchCount" select="count($errorsWithSyslogDetail/errorCode[@key=$key])" />
    <xsl:choose>
      <xsl:when test="$localizedString != ''"><xsl:value-of select="$localizedString" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$originalString" /></xsl:otherwise>
    </xsl:choose> 
    <xsl:if test="$errorMatchCount &gt; 0">
      <xsl:variable name="stringMatchCount" select="count($stringsDoc//value[@key=$key and (@type='ONBOARD_ADMINISTRATOR' or @type='USER_REQUEST')])" />
      
      <xsl:if test="$stringMatchCount &gt; 0">
        <xsl:text> </xsl:text><xsl:value-of select="$stringsDoc//value[@key='seeSyslogForMoreInfo']" />
      </xsl:if>
    </xsl:if>
  </xsl:template>


	<xsl:template name="checkIfExistBayIPv6">
		<xsl:param name="mpInfoDoc" />
		<xsl:param name="currentBayNumber" />

		<xsl:choose>
			<xsl:when test="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[starts-with(@hpoa:name,'iLOIPv6')]/text()!=''">
				<xsl:value-of select="'true'" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
  <!--
    @purpose  : renders a hidden div that can be exposed at runtime to allow the user to control when a tab page gets refreshed.    
    @params   : none              
    @notes    : this concept was used on the VC Commander GUI form pages to allow support for events without blasting user input
              : or validation/error messages currently on display.
  -->
  <xsl:template name="reloadTabPageNotice">
    <div id="loadNotice" style="display:none;">      
      <img src='/120814-042457/images/refresh-anim.gif' style="width:16px;height:16px;margin-right:5px;margin-bottom:-3px;" />
      <xsl:value-of select="$stringsDoc//value[@key='anEventReqestingPageReload']" />
      <a href='javascript:void(0);' style="margin-left:3px;" onclick="javascript:setTabContent(getCurrentTab());document.getElementById('loadNotice').style.display='none';">
        <xsl:value-of select="$stringsDoc//value[@key='clickHere']" />
      </a>
      <xsl:value-of select="$stringsDoc//value[@key='reloadThePage']" />
      <div class="formSpacer">&#160;</div><br />
    </div>
  </xsl:template>
	
</xsl:stylesheet>
