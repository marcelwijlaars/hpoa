<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:template name="firstTimeBootOption">

		<xsl:param name="isWizard" select="'false'" />

		<xsl:value-of select="$stringsDoc//value[@key='oneTimeBoot']" />: <em>
		<xsl:value-of select="$stringsDoc//value[@key='oneTimeBootDesc']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div class="groupingBox">
			<div id="firstTimeErrorDisplay" class="errorDisplay"></div>
			<table cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td>
						<xsl:value-of select="$stringsDoc//value[@key='oneTimeBootFrom:']" />
					</td>
					<td width="10">&#160;</td>
					<td>
						<select style="width:180px;border:1px solid #cccccc;" id="bootDevice">
							<option value=""><xsl:value-of select="$stringsDoc//value[@key='select']" /></option>

							<xsl:element name="option">
								<xsl:attribute name="value">ONE_TIME_BOOT_FLOPPY</xsl:attribute>
								<xsl:if test="$bladeBootInfoDoc//*[starts-with(name(), 'hpoa:bladeBootInfo')]/hpoa:oneTimeBootDevice='ONE_TIME_BOOT_FLOPPY'">
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$stringsDoc//value[@key='fdDriveA']" />
							</xsl:element>

							<xsl:element name="option">
								<xsl:attribute name="value">ONE_TIME_BOOT_CD</xsl:attribute>
								<xsl:if test="$bladeBootInfoDoc//*[starts-with(name(), 'hpoa:bladeBootInfo')]/hpoa:oneTimeBootDevice='ONE_TIME_BOOT_CD'">
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								CD-ROM
							</xsl:element>

							<xsl:element name="option">
								<xsl:attribute name="value">ONE_TIME_BOOT_HARD_DRIVE</xsl:attribute>
								<xsl:if test="$bladeBootInfoDoc//*[starts-with(name(), 'hpoa:bladeBootInfo')]/hpoa:oneTimeBootDevice='ONE_TIME_BOOT_HARD_DRIVE'">
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$stringsDoc//value[@key='hddDriveC']" />&#160;(*)
							</xsl:element>

              <xsl:element name="option">
                <xsl:attribute name="value">RBSU</xsl:attribute>
                <xsl:if test="$bladeBootInfoDoc//*[starts-with(name(), 'hpoa:bladeBootInfo')]/hpoa:oneTimeBootAgent='RBSU'">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>
                RBSU
              </xsl:element>

              <xsl:element name="option">
                <xsl:attribute name="value">PXE</xsl:attribute>
                <xsl:if test="$bladeBootInfoDoc//*[starts-with(name(), 'hpoa:bladeBootInfo')]/hpoa:oneTimeBootAgent='PXE'">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>
					      PXE NIC **
				      </xsl:element>
						</select>
            
            <xsl:if test="$bladeInfoDoc//hpoa:extraData[@hpoa:name='secureBoot'] = 'enabled'">
              <xsl:call-template name="simpleTooltip">
						    <xsl:with-param name="msg" select="$stringsDoc//value[@key='unavailableInSecureBootMode']" />
					    </xsl:call-template>
            </xsl:if>
					</td>
				</tr>
        
			</table>
    
		</div>

	</xsl:template>
	
	<xsl:template name="permanentBootOrder">
    <xsl:variable name="legacyView" select="string(count($bladeBootInfoDoc//hpoa:iplDevice) &gt; 0 or count($bladeBootInfoDoc//hpoa:ipl[@hpoa:bootDevDesc = 'HDD']) &gt; 0)" />

		<xsl:value-of select="$stringsDoc//value[@key='standardBootOrder']" /><em>
		<xsl:value-of select="$stringsDoc//value[@key='standardBootOrderDesc']" /></em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<!-- the form here is a dummy, and is only used because the one-voice code requires it -->
		<form method="POST" class="transferBox" id="bootOrderBox" autocomplete="off" action="#" onsubmit="return false;">
			<div class="groupingBox">
				<div id="orderErrorDisplay" class="errorDisplay"></div>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="vertical-align:top;white-space:nowrap;padding-top:5px;">
							<xsl:value-of select="$stringsDoc//value[@key='iplDevice']" /><br />
							<xsl:value-of select="$stringsDoc//value[@key='bootOrder']" />
						</td>
						<td width="5">&#160;</td>
						<td style="padding-top:5px;">
              
              <xsl:variable name="styleWidth">
                <xsl:choose>
                  <xsl:when test="$legacyView = 'true'">180</xsl:when>
                  <xsl:otherwise>500</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

							<select size="8" name="chosen_items" id="chosen_items" style="width:{$styleWidth}px;border:1px solid #cccccc;" multiple="">

								<!-- OA 4.30 and above use a new EX version of boot info -->
                <xsl:choose>
                  <xsl:when test="count($bladeBootInfoDoc//hpoa:bladeBootInfoEx) &gt; 0" >
                    <xsl:call-template name="getIplBootDevicesEx" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="getIplBootDevices" />
                  </xsl:otherwise>
                </xsl:choose>              

							</select>
						</td>
					</tr>
					<tr>
						<td colspan="3" style="padding-top:10px;">              
							<div class="buttonSet" style="margin-bottom:-5px;">
                <xsl:if test="$bladeInfoDoc//hpoa:extraData[@hpoa:name='secureBoot'] = 'enabled'">
                  <div style="float:right;">
                    <xsl:call-template name="simpleTooltip">
						          <xsl:with-param name="msg" select="$stringsDoc//value[@key='unavailableInSecureBootMode']" />
					          </xsl:call-template>
                  </div>
                </xsl:if>
								<div class="bWrapperUp">
									<div>
										<div>
											<button id="btnMoveUp" class="hpButtonSmall noMinimumWidth" title="{$stringsDoc//value[@key='moveUp']}" style="width:28px;padding-right:2px;" onclick="ourTransferBoxManager.moveSelectedChosenItems(document.getElementById('bootOrderBox'),true);">
												<img src="/120814-042457/images/up.gif" width="13" height="11"></img>
											</button>
										</div>
									</div>
								</div>
								<div class="bWrapperUp">
									<div>
										<div>
											<button id="btnMoveDown" class="hpButtonSmall noMinimumWidth" title="{$stringsDoc//value[@key='moveDown']}" style="width:28px;padding-right:3px;padding-top:1px;" onclick="ourTransferBoxManager.moveSelectedChosenItems(document.getElementById('bootOrderBox'),false);">
												<img src="/120814-042457/images/down.gif" width="13" height="11"></img>
											</button>
										</div>
									</div>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</xsl:template>
  
    <!-- 
  ==========================================================================================
    @Purpose: Displays a disclaimer for cases where the OA cannot set UEFI boot options.
    @notes  : Not shown when boot options are configurable.
  ==========================================================================================
  -->
  <xsl:template name="bootOptionOverride">    
    <div style="min-width:250px;vertical-align:middle;margin:10px 0px 10px 1px;padding:15px 10px 5px 10px;border:2px solid #ccc;">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td style="vertical-align:top;">
            <img src="/120814-042457/images/status_informational_32.gif" style="vertical-align:middle;margin-right:10px;" />
          </td>
          <td style="font-weight:bold;">
            <xsl:value-of select="$stringsDoc//value[@key='543' and @type='USER_REQUEST']" />                
          </td>
        </tr>
      </table>
      <br />    
    </div>
  </xsl:template>	
  
  <!-- 
  ==========================================================================================
    @Purpose: creates an option list of boot devices
    @notes  : supported on OA firmware prior to 4.30
  ==========================================================================================
  -->
  <xsl:template name="getIplBootDevices">
    <xsl:for-each select="$bladeBootInfoDoc//hpoa:bladeBootInfo/hpoa:ipls/hpoa:ipl">
			<xsl:variable name="position" select="position()" />
			<xsl:variable name="bootDevice" select="../hpoa:ipl[hpoa:bootPriority=$position]/hpoa:iplDevice" />

			<xsl:element name="option">
				<xsl:attribute name="value">
					<xsl:value-of select="$bootDevice"/>
				</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$bootDevice=$IPL_CD">
							CD-ROM
						</xsl:when>
						<xsl:when test="$bootDevice=$IPL_FLOPPY">
							<xsl:value-of select="$stringsDoc//value[@key='fdDriveA']" />
						</xsl:when>
						<xsl:when test="$bootDevice=$IPL_HDD">
							<xsl:value-of select="$stringsDoc//value[@key='hddDriveC']" />&#160;(*)
						</xsl:when>
						<xsl:when test="$bootDevice=$IPL_USB">
							<xsl:value-of select="$stringsDoc//value[@key='usbDrivekeyC']" />
						</xsl:when>
						<xsl:when test="contains($bootDevice, 'PXE_NIC')">
              <xsl:variable name="nicIndex" select="substring($bootDevice, 8)" /><!-- extract the index -->                          
              <xsl:value-of select="concat('PXE NIC ', $nicIndex, ' (**)')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$bootDevice"/>
            </xsl:otherwise>
					</xsl:choose>									
			</xsl:element>

		</xsl:for-each>    
  </xsl:template>
  
    <!-- 
  ==========================================================================================
    @Purpose: creates an option list of "Ex" boot devices
    @notes  : supported on OA firmware 4.30 and above with UEFI support. 
            : emulates legacy display for known devices.
  ==========================================================================================
  -->
  <xsl:template name="getIplBootDevicesEx">
    <xsl:for-each select="$bladeBootInfoDoc//hpoa:bladeBootInfoEx/hpoa:ipls/hpoa:ipl">
			<xsl:sort data-type="number" select="hpoa:bootPriority" />


			<xsl:element name="option">
				<xsl:attribute name="value">
					<xsl:value-of select="hpoa:bootDevIdentifier"/>
				</xsl:attribute>
        	<xsl:choose>
						<xsl:when test="@hpoa:bootDevDesc=$IPL_CD">
							CD-ROM
						</xsl:when>
						<xsl:when test="@hpoa:bootDevDesc=$IPL_FLOPPY">
							<xsl:value-of select="$stringsDoc//value[@key='fdDriveA']" />
						</xsl:when>
						<xsl:when test="@hpoa:bootDevDesc=$IPL_HDD">
							<xsl:value-of select="$stringsDoc//value[@key='hddDriveC']" />&#160;(*)
						</xsl:when>
						<xsl:when test="@hpoa:bootDevDesc=$IPL_USB">
							<xsl:value-of select="$stringsDoc//value[@key='usbDrivekeyC']" />
						</xsl:when>
            <xsl:when test="contains(@hpoa:bootDevDesc, 'PXE_NIC')">
              <xsl:variable name="nicIndex" select="substring(@hpoa:bootDevDesc, 8)" /><!-- extract the index -->                          
              <xsl:value-of select="concat('PXE NIC ', $nicIndex, ' (**)')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@hpoa:bootDevDesc" />
            </xsl:otherwise>
					</xsl:choose>				
			</xsl:element>

		</xsl:for-each> 
  </xsl:template>
</xsl:stylesheet>
