<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  
	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  
  <xsl:output method="text"/>  
	<xsl:include href="../Templates/guiConstants.xsl"/>	
	<xsl:param name="statusCode" />
	
	<xsl:template match="*">
    <xsl:choose>
      <!-- New operational status stuff -->
      <xsl:when test="$statusCode=$OP_STATUS_OK">
        <xsl:value-of select="$STATUS_OK_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$INTERCONNECT_TRAY_PORT_STATUS_OK">
        <xsl:value-of select="$STATUS_OK_IMAGE" />
      </xsl:when>

      <!-- TODO: Correct image. -->
      <xsl:when test="$statusCode=$OP_STATUS_UNKNOWN">
        <xsl:value-of select="$STATUS_UNKNOWN_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_OTHER">
        <xsl:value-of select="$STATUS_INFO_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_DEGRADED">
        <xsl:value-of select="$STATUS_MINOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STRESSED">
        <xsl:value-of select="$STATUS_MINOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_PREDICTIVE_FAILURE">
        <xsl:value-of select="$STATUS_MAJOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">
        <xsl:value-of select="$STATUS_MAJOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_ERROR">
        <xsl:value-of select="$STATUS_OK_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STARTING">
        <xsl:value-of select="$STATUS_STARTING_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STOPPING">
        <xsl:value-of select="$STATUS_INFO_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_STOPPED">
        <xsl:value-of select="$STATUS_MINOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_NON_RECOVERABLE_ERROR">
        <xsl:value-of select="$STATUS_FAILED_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_IN_SERVICE">
        <xsl:value-of select="$STATUS_DISABLED_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_NO_CONTACT">
        <xsl:value-of select="$STATUS_UNKNOWN_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_LOST_COMMUNICATION">
        <xsl:value-of select="$STATUS_FAILED_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_ABORTED">
        <xsl:value-of select="$STATUS_MAJOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_DORMANT">
        <xsl:value-of select="$STATUS_INFO_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR">
        <xsl:value-of select="$STATUS_MAJOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_COMPLETED">
        <xsl:value-of select="$STATUS_OK_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode=$OP_STATUS_POWER_MODE">
        <xsl:value-of select="$STATUS_INFO_IMAGE" />
      </xsl:when>

      <!-- Permission denied. -->
      <xsl:when test="$statusCode=$LOCKED">
        <xsl:value-of select="$STATUS_LOCKED_IMAGE" />
      </xsl:when>

      <!-- iLO Log types -->
      <xsl:when test="$statusCode='Informational'">
        <xsl:value-of select="$STATUS_INFO_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode='Caution'">
        <xsl:value-of select="$STATUS_MINOR_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode='Critical'">
        <xsl:value-of select="$STATUS_FAILED_IMAGE" />
      </xsl:when>

      <xsl:when test="$statusCode='Repaired'">
        <xsl:value-of select="$STATUS_OK_IMAGE" />
      </xsl:when>

      <!--
         A catch all. Displays status as unknown if one of the above
         cases is not matched.
      -->
      <xsl:otherwise>
        <xsl:value-of select="$STATUS_UNKNOWN_IMAGE" />
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>
	
</xsl:stylesheet>
