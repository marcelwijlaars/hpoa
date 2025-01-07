<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.

    Individual device bay template. Contains status icon, uid, 
    power, and checkbox for device (server) bays.    
  -->
  
  <xsl:template name="deviceBay">
    
    <xsl:param name="deviceImage" />
    <xsl:param name="isWizard" />    
    <xsl:param name="bayNumber" />
    <xsl:param name="presence" />
    <xsl:param name="status" />
    <xsl:param name="healthStatus" />
    <xsl:param name="uidState" />
    <xsl:param name="powerState" />
    <xsl:param name="position" />
    <xsl:param name="bladeType" />
    
    <xsl:choose>
      <xsl:when test="$presence=$PRESENT">      
          
        <xsl:variable name="statusVisibility">
          <xsl:choose>
            <xsl:when test="$status != $OP_STATUS_OK">visible</xsl:when>
            <xsl:otherwise>hidden</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="ledSize">
          <xsl:choose>
            <xsl:when test="$bladeType='BLADE_TYPE_STORAGE'">3</xsl:when>
            <xsl:when test="contains($deviceImage, '_gen8')">3</xsl:when>
            <xsl:when test="contains($deviceImage, '_gen9')">3</xsl:when>
            <xsl:otherwise>5</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="supportsPowerLed">
          <xsl:choose>
            <xsl:when test="($graphicsMap//device[@image=$deviceImage]/coords/@supportsPowerLed) = 'no'">false</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
          <xsl:when test="$isWizard='true'">
            <xsl:variable name="chkId" select="concat('svb', $bayNumber, 'Select')" />
            <input id="{$chkId}" style="position:absolute;top:1px;left:4px;" type="checkbox" rowselector="yes" devid="bay" bayNumber="{$bayNumber}" />
          </xsl:when>
          <xsl:otherwise>
              
            <xsl:if test="not(contains($deviceImage, 'enclosure_blade_unknown'))">
            
              <!--UID image--> 
              <xsl:call-template name="getUidImage">
                <xsl:with-param name="imgId" select="concat('enc', $encNum, 'bay', $bayNumber, 'Uid')" />
                <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidTop" />
                <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidLeft" />
                <xsl:with-param name="uidState" select="$uidState" />
                <xsl:with-param name="width" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidWidth" />
                <xsl:with-param name="height" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidHeight" />
              </xsl:call-template>            
              
              <!--Power image-->
              <xsl:if test="$supportsPowerLed != 'false'">
                
                <xsl:call-template name="getPowerLed">
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'bay', $bayNumber, 'Power')" />
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@powerTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@powerLeft" />
                  <xsl:with-param name="powerState" select="$powerState" />
                  <xsl:with-param name="size" select="$ledSize" />
                </xsl:call-template>
                
              </xsl:if>
              
              <!-- Gen8+ LED Health Bars -->
              <xsl:if test="$graphicsMap//device[@image=$deviceImage]/coords/@ledBarWidth != '' and $graphicsMap//device[@image=$deviceImage]/coords/@ledBarHeight != ''">
                
                <xsl:call-template name="getHealthBarLed">
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'bay', $bayNumber, 'HealthBar')" />
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@ledBarTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@ledBarLeft" />
                  <xsl:with-param name="healthState" select="$healthStatus" />
                  <xsl:with-param name="powerState" select="$powerState" />
                  <xsl:with-param name="width" select="$graphicsMap//device[@image=$deviceImage]/coords/@ledBarWidth" />
                  <xsl:with-param name="height" select="$graphicsMap//device[@image=$deviceImage]/coords/@ledBarHeight" />
                </xsl:call-template>
                
              </xsl:if>
            
            </xsl:if>
            
            <xsl:choose>
              <xsl:when test="$position='LEFT' or $position='TOP'">
                
                <!--Status Icon--> 
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$status" />
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'bay', $bayNumber, 'Status')"/>
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@statusTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@statusLeft" />
                  <xsl:with-param name="visibility" select="$statusVisibility" />
                </xsl:call-template>
              
              </xsl:when>
              <xsl:when test="$position='RIGHT' or $position='BOTTOM'">
                
                <!--Status Icon--> 
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$status" />
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'bay', $bayNumber, 'Status')"/>
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords[@position=$position]/@statusTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords[@position=$position]/@statusLeft" />
                  <xsl:with-param name="visibility" select="$statusVisibility" />
                </xsl:call-template>
                        
              </xsl:when>                  
            </xsl:choose>            
          </xsl:otherwise>          
        </xsl:choose>
        
      </xsl:when><!-- end $presence=$PRESENT -->
      <xsl:otherwise>&#160;</xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>	
</xsl:stylesheet>