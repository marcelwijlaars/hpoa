<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../Templates/guiConstants.xsl"/>
  <xsl:include href="../Templates/globalTemplates.xsl"/>
  
  <!-- Universal params -->
  <xsl:param name="stringsDoc" />
  <xsl:param name="encNum" />
  <xsl:param name="deviceType" />
  <xsl:param name="bayNumber" />
  
  <!-- Device Blade params -->
  <xsl:param name="bladeInfoDOM" />
  <xsl:param name="bladeMpInfo" />
  <xsl:param name="mpIpAddress" />  

  <!-- Onboard Admin params -->
  <xsl:param name="oaInfoDoc" />
  <xsl:param name="oaStatusDoc" />
  <xsl:param name="oaNetworkInfoDoc" />
	<xsl:param name="oaIp" />
  
  <!-- Power Supply params -->
  <xsl:param name="psInfoDoc" />
  <xsl:param name="psStatusDoc" />

  <!-- Fan params -->
  <xsl:param name="fanInfoDoc" />
  <xsl:param name="fanZone" />
  
  <!-- DVD params -->
  <xsl:param name="oaMediaDeviceList" />
  
  <xsl:template match="*">
    <xsl:choose>
      <!-- Device Blades -->
      <xsl:when test="$deviceType='device'">
        <xsl:call-template name="deviceBayTooltip">
          <xsl:with-param name="bladeInfo" select="$bladeInfoDOM//hpoa:bladeInfo[hpoa:bayNumber=$bayNumber]" />
          <xsl:with-param name="bladeMpInfo" select="$bladeMpInfo" />
          <xsl:with-param name="mpIpAddress" select="$mpIpAddress" />
        </xsl:call-template>
      </xsl:when>
      
      <!-- Onboard Admins -->
      <xsl:when test="$deviceType='oabay'">
        <xsl:call-template name="emBayTooltip">
          <xsl:with-param name="bayNum" select="$bayNumber" />
          <xsl:with-param name="oaInfo" select="$oaInfoDoc" />
          <xsl:with-param name="oaStatus" select="$oaStatusDoc" />
          <xsl:with-param name="oaNetInfo" select="$oaNetworkInfoDoc" />
					<xsl:with-param name="oaIp" select="$oaIp" />
        </xsl:call-template>
      </xsl:when>
      
      <!-- Power Supplies -->
      <xsl:when test="$deviceType='ps'">
        <xsl:call-template name="powerSupplyTooltip">
          <xsl:with-param name="bayNum" select="$bayNumber" />
          <xsl:with-param name="psInfoDoc" select="$psInfoDoc" />
          <xsl:with-param name="psStatusDoc" select="$psStatusDoc" />
        </xsl:call-template>
      </xsl:when>

      <!-- Fans -->
      <xsl:when test="$deviceType='fan'">
        <xsl:call-template name="fanBayTooltip">
          <xsl:with-param name="bayNum" select="$bayNumber" />
          <xsl:with-param name="fanInfoDoc" select="$fanInfoDoc" />
          <xsl:with-param name="fanZone" select="$fanZone" />
        </xsl:call-template>
      </xsl:when>
      
      <xsl:when test="$deviceType='dvd'">
        <xsl:call-template name="dvdDriveTooltip">
          <xsl:with-param name="encNum" select="$encNum" />
          <xsl:with-param name="drivePresence" select="(count($oaMediaDeviceList//hpoa:oaMediaDevice[hpoa:deviceType=1 and hpoa:devicePresence='PRESENT']) &gt; 0)" />
          <xsl:with-param name="mediaPresence" select="(count($oaMediaDeviceList//hpoa:oaMediaDevice[hpoa:deviceType=1 and hpoa:mediaPresence='PRESENT']) &gt; 0)" />
        </xsl:call-template>
      </xsl:when>
      
      <xsl:otherwise>
        <!-- Not Supported -->
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
</xsl:stylesheet>
