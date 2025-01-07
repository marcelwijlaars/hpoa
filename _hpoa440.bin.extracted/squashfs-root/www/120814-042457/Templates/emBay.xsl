<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  
  <!--
    Individual interconnect bay template. Contains status icon and 
    checkbox for interconnect bays.
  -->
  
  <xsl:template name="emBay">
    
    <xsl:param name="emNumber" />
    <xsl:param name="presence" />
    <xsl:param name="status" />
    <xsl:param name="isWizard" select="'false'" />
    <xsl:param name="encNum" />
    <xsl:param name="uidState" />
    <xsl:param name="width" select="92" />
	  <xsl:param name="displayImage" select="$EM_PRESENT_IMAGE" />
    
    <xsl:choose>
      <xsl:when test="$presence != $ABSENT">
        <div style="position:relative;width:{$width}px;height:16px;">
          
            <xsl:variable name="statusVisibility">
              <xsl:choose>
                <xsl:when test="$status != $OP_STATUS_OK">
                  <xsl:value-of select="'visible'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'hidden'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:choose>
              <!--
                Determine whether or not the bay is on the left or right side.
                Render the checkbox and status icon accordingly.
              -->
              <xsl:when test="$emNumber mod 2 != 0">
                
                <!-- Align left -->                
                <xsl:if test="$isWizard='true'">
                  <input style="position:absolute;top:1px;left:4px;" type="checkbox" rowselector="yes" devid="enc_manager" />
                </xsl:if>
                
                <!-- UID image -->
                <xsl:call-template name="getUidImage">
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'oa', $emNumber, 'Uid')" />
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$displayImage]/coords/@uidTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$displayImage]/coords/@uidLeft" />
                  <xsl:with-param name="uidState" select="$uidState" />
                </xsl:call-template>
                
                <!-- Status Icon -->
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$status" />
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'oa', $emNumber, 'Status')"/>
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$displayImage]/coords/@statusTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$displayImage]/coords/@statusLeft" />
                  <xsl:with-param name="visibility" select="$statusVisibility" />
                </xsl:call-template>
               
              </xsl:when>

              <xsl:otherwise>                
                <!-- Align right -->
                
                <xsl:if test="$isWizard='true'">
                  <input style="position:absolute;top:3px;left:75px;" type="checkbox" rowselector="yes" devid="enc_manager" />		
                </xsl:if> 
                
                <!-- UID image -->
                <xsl:call-template name="getUidImage">
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'oa', $emNumber, 'Uid')" />
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$displayImage]/coords[@position='RIGHT']/@uidTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$displayImage]/coords[@position='RIGHT']/@uidLeft" />
                  <xsl:with-param name="uidState" select="$uidState" />
                </xsl:call-template>
              
                <!-- Status Icon -->
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$status" />
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'oa', $emNumber, 'Status')" />
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$displayImage]/coords[@position='RIGHT']/@statusTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$displayImage]/coords[@position='RIGHT']/@statusLeft" />
                  <xsl:with-param name="visibility" select="$statusVisibility" />
                </xsl:call-template>

              </xsl:otherwise>
            </xsl:choose>
         </div>
      </xsl:when>
      <xsl:otherwise>
		  <img src="/120814-042457/images/icon_transparent.gif" border="0" height="1" width="1" alt="" />
	  </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
</xsl:stylesheet>
