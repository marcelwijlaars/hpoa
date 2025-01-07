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
  
	<xsl:template name="interconnectBay">
		
    <xsl:param name="deviceImage" />
		<xsl:param name="trayNumber" />
		<xsl:param name="presence" />
		<xsl:param name="status" />
		<xsl:param name="isWizard" />
    <xsl:param name="uidState" />
    <xsl:param name="powerState" />
    <xsl:param name="isTower" select="0" />
    <xsl:param name="ioWidth" select="1" />
    
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="not($isTower)">
          <xsl:choose>
            <xsl:when test="$ioWidth=2">220</xsl:when>
            <xsl:otherwise>110</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>18</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="not($isTower)">18</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$ioWidth=2">220</xsl:when>
            <xsl:otherwise>110</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="displayStatus">
      <xsl:choose>
        <xsl:when test="$presence = $LOCKED or $presence='PRESENCE_NO_OP'">
          <xsl:value-of select="$LOCKED"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$status"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
		
		<xsl:choose>
			<xsl:when test="($presence!=$ABSENT and $presence!=$SUBSUMED)"> 
        
        <xsl:variable name="containerId">
          <xsl:value-of select="concat('interconnectBayContainer', $trayNumber)" />
        </xsl:variable>
        
        <xsl:variable name="mapImage">
          <xsl:choose>
            <xsl:when test="$deviceImage != '' and $displayStatus != $LOCKED"><xsl:value-of select="$deviceImage"/></xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$isTower = 1">BlankInterconnect_t</xsl:when>
                <xsl:otherwise>BlankInterconnect</xsl:otherwise>
              </xsl:choose>
              </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <div id="{$containerId}" style="position:relative;width:{$width}px;height:{$height}px;">
          
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
            
            <xsl:variable name="ledSize">
              <xsl:choose>
                <xsl:when test="not($graphicsMap//device[@image=$deviceImage]/coords/@powerSize)">4</xsl:when>
                <xsl:otherwise><xsl:value-of select="$graphicsMap//device[@image=$deviceImage]/coords/@powerSize"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
                    
						<xsl:choose>
							<!--
								Determine whether or not the bay is on the left or right side.
								Render the checkbox and status icon accordingly. NOTE: This test
								will have to be updated with changes in interconnect bay numbering.
							-->
							<xsl:when test="$trayNumber mod 2 != 0">
								<!-- Align left -->
								<xsl:if test="$isWizard='true'">
								  <input style="position:absolute;top:1px;left:4px;" type="checkbox" rowselector="yes" devid="interconnect" />
								</xsl:if>
                
                <xsl:if test="$deviceImage != '' and not(contains($deviceImage, 'io_unknown')) and $displayStatus != $LOCKED">
                
                   <!--UID image--> 
                  <xsl:call-template name="getUidImage">
                    <xsl:with-param name="imgId" select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Uid')" />
                    <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidTop" />
                    <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidLeft" />
                    <xsl:with-param name="uidState" select="$uidState" />
                    <xsl:with-param name="width" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidWidth" />
                    <xsl:with-param name="height" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidHeight" />
                  </xsl:call-template>
                  
                   <!--Power image--> 
                  <xsl:call-template name="getPowerLed">
                    <xsl:with-param name="imgId" select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Power')" />
                    <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@powerTop" />
                    <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@powerLeft" />
                    <xsl:with-param name="powerState" select="$powerState" />
                    <xsl:with-param name="size" select="$ledSize" />
                  </xsl:call-template>
                
                </xsl:if>
                
                 <!--Status Icon--> 
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$displayStatus" />
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Status')"/>
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$mapImage]/coords/@statusTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$mapImage]/coords/@statusLeft" />
                  <xsl:with-param name="visibility" select="$statusVisibility" />
                </xsl:call-template>
                
							</xsl:when>

							<xsl:otherwise>
								<!-- Align right -->
                
                <xsl:if test="$isWizard='true'">
								  <input style="position:absolute;top:1px;left:88px;" type="checkbox" rowselector="yes" devid="interconnect" />
								</xsl:if>  
                
                <xsl:if test="$deviceImage != '' and not(contains($deviceImage, 'io_unknown')) and $displayStatus != $LOCKED">
                
                   <!--UID image--> 
                  <xsl:call-template name="getUidImage">
                    <xsl:with-param name="imgId" select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Uid')" />
                    <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidTop" />
                    <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidLeft" />
                    <xsl:with-param name="uidState" select="$uidState" />
                    <xsl:with-param name="width" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidWidth" />
                    <xsl:with-param name="height" select="$graphicsMap//device[@image=$deviceImage]/coords/@uidHeight" />
                  </xsl:call-template>
                  
                   <!--Power image--> 
                  <xsl:call-template name="getPowerLed">
                    <xsl:with-param name="imgId" select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Power')" />
                    <xsl:with-param name="top" select="$graphicsMap//device[@image=$deviceImage]/coords/@powerTop" />
                    <xsl:with-param name="left" select="$graphicsMap//device[@image=$deviceImage]/coords/@powerLeft" />
                    <xsl:with-param name="powerState" select="$powerState" />
                    <xsl:with-param name="size" select="$ledSize" />
                  </xsl:call-template>
                
                </xsl:if>
                
                 <!--Status Icon--> 
                <xsl:call-template name="statusIcon">
                  <xsl:with-param name="statusCode" select="$displayStatus" />
                  <xsl:with-param name="imgId" select="concat('enc', $encNum, 'interconnect', $trayNumber, 'Status')"/>
                  <xsl:with-param name="top" select="$graphicsMap//device[@image=$mapImage]/coords[@position='RIGHT']/@statusTop" />
                  <xsl:with-param name="left" select="$graphicsMap//device[@image=$mapImage]/coords[@position='RIGHT']/@statusLeft" />
                  <xsl:with-param name="visibility" select="$statusVisibility" />
                </xsl:call-template>

							</xsl:otherwise>

						</xsl:choose>

					</div>
				
			</xsl:when>      
			<xsl:otherwise>        
        <img src="/120814-042457/images/icon_transparent.gif" border="0" height="{$height}" width="{$width}" alt="" />
      </xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>
