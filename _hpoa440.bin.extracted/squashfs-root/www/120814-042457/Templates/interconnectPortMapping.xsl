<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	
	<xsl:param name="stringsDoc"/>
	<xsl:param name="encNum" />
	<xsl:param name="bladePortMapDoc" />
	<xsl:param name="bladeMezzInfoExDoc" />
	<xsl:param name="interconnectTrayPortMapDoc" />
	<xsl:param name="interconnectTrayInfoDoc" />
	<xsl:param name="bladeInfoDoc" />
	<xsl:param name="isTower" select="'false'" />

	<xsl:variable name="PORTS_PER_ROW" select="8" />
	
	<xsl:template match="*">
		
		<table cellpadding="0" cellspacing="0" border="0" class="fabricTable" align="center">
			<caption>
				<xsl:value-of select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:name"/>
			</caption>
			<tr>

				<xsl:variable name="ioWidth" select="$interconnectTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:width" />
				
				<xsl:element name="td">

					<xsl:choose>
						<xsl:when test="$ioWidth=2">
							<xsl:attribute name="class">portDisplayCell portDisplayCellWide</xsl:attribute>
							<xsl:attribute name="style">width:360px;</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">portDisplayCell</xsl:attribute>
							<xsl:attribute name="style">width:180px;</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:attribute name="align">center</xsl:attribute>
					<xsl:attribute name="height">50</xsl:attribute>

					<xsl:element name="table">
						<xsl:attribute name="border">0</xsl:attribute>
						<xsl:attribute name="cellpadding">0</xsl:attribute>
						<xsl:attribute name="cellspacing">0</xsl:attribute>
						<xsl:attribute name="align">center</xsl:attribute>
						
						<xsl:choose>
							<xsl:when test="$ioWidth=2">
								<xsl:attribute name="width">320</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="width">160</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						
						<xsl:attribute name="style">border:0px none;</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$ioWidth=2">
								<tbody>

									<!-- First row of ports. -->
									<tr>

										<xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap">

											<xsl:choose>
												<!-- This is a special case for the KX4 10Gb pass-thru. The ports have a strange numbering scheme on the faceplate. -->
												<xsl:when test="contains($interconnectTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:name, 'KX4') and $interconnectTrayInfoDoc//hpoa:interconnectTrayInfo/hpoa:interconnectTrayType=$INTERCONNECT_TRAY_TYPE_10GETH">
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=16]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=8]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=15]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=7]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=14]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=6]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=13]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=5]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=12]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=4]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=11]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=3]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=10]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=2]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=9]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[hpoa:interconnectTraySlotPortNumber=1]">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
												</xsl:when>
												<xsl:when test="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:type=$INTERCONNECT_TRAY_TYPE_SAS and hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_ENABLED'">
													<xsl:for-each select="hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port">
														<xsl:sort select="hpoa:interconnectTraySlotPortNumber" data-type="number" order="descending"/>
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap/hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port">
														<xsl:call-template name="portTableCell" />
													</xsl:for-each>
												</xsl:otherwise>
											</xsl:choose>

										</xsl:for-each>
										
									</tr>
									
								</tbody>
							</xsl:when>
							<xsl:otherwise>
								<tbody>

									<!-- First row of ports. -->
									<tr>
										<xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap/hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[position() &lt;= $PORTS_PER_ROW]">
											<xsl:call-template name="portTableCell" />
										</xsl:for-each>
									</tr>

									<!-- Second row of ports. -->
									<tr>
										<xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap/hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port[position() &gt; $PORTS_PER_ROW]">
											<xsl:call-template name="portTableCell" />
										</xsl:for-each>
									</tr>

								</tbody>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:element>

				</xsl:element>
        <xsl:if test="$isTower='true'">
          <td style="background-color:#FFFFFF; border: 0px none; padding-left: 5px;">
            <b>T</b><br /><b>o</b><br /><b>p</b>
          </td>
        </xsl:if>

      </tr>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />

		<table border="0" cellpadding="0" cellspacing="0" class="treeTable">
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$stringsDoc//value[@key='interconnect']"/><br /><xsl:value-of select="$stringsDoc//value[@key='bayPort']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='portStatus']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='serverBay']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='srvMezzSlot']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='srvMezzPort']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='deviceID']"/></th>
				</tr>
			</thead>
			<tbody>

				<xsl:for-each select="$interconnectTrayPortMapDoc//hpoa:interconnectTrayPortMap/hpoa:slot[hpoa:interconnectTraySlotNumber=1]/hpoa:port">

					<xsl:variable name="bladeBayNumber" select="hpoa:bladeBayNumber" />
					<xsl:variable name="symbolicBladeBayNumber" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bladeBayNumber]/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
					<xsl:variable name="bladeMezzNumber" select="hpoa:bladeMezzNumber" />
					<xsl:variable name="bladeMezzPortNumber" select="hpoa:bladeMezzPortNumber" />
					<xsl:variable name="mezzName" select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:name"/>
					<xsl:variable name="mezzType" select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:type"/>

					<xsl:variable name="bladeType" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bladeBayNumber]/hpoa:bladeType" />
          
					<!-- for permission checking -->
					<xsl:variable name="bladePresence" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bladeBayNumber]/hpoa:presence"/>
					
					<xsl:element name="tr">

						<xsl:if test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">
							<xsl:attribute name="class">mismatchRow</xsl:attribute>
						</xsl:if>

						<td class="nested1">
							<xsl:value-of select="hpoa:interconnectTraySlotPortNumber"/>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_OK or hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">
									<xsl:call-template name="getStatusLabel">
										<xsl:with-param name="statusCode" select="hpoa:portStatus" />
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='noConnection']"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td>
							<xsl:if test="$bladeBayNumber != 0">

								<xsl:choose>
									<xsl:when test="$bladePresence=$PRESENT">
										<xsl:element name="a">
											<xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$bladeBayNumber"/>, PM_BLADE(), <xsl:value-of select="$encNum"/>, true);</xsl:attribute>
											<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>
<!--TODO: use BladeNumber if symbolic is not defined -->
											<xsl:value-of select="$stringsDoc//value[@key='bay']"/>&#160;<xsl:value-of select="$symbolicBladeBayNumber"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$stringsDoc//value[@key='bay']"/>&#160;<xsl:value-of select="$symbolicBladeBayNumber"/>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:if>
						</td>
						<td>
							<xsl:if test="$bladeMezzNumber != 0">

								<xsl:choose>
									<xsl:when test="$mezzType='MEZZ_DEV_TYPE_FIXED'">
										<xsl:choose>
											<xsl:when test="$bladeType='BLADE_TYPE_STORAGE'">
												<xsl:value-of select="$stringsDoc//value[@key='fixedSAS']"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$stringsDoc//value[@key='embedded']"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>

										<!-- Physical Mezz or FLB -->
										<xsl:choose>
											<!-- If FLB, convert mezzNumber to FLB value and add FLB%d notation -->
											<xsl:when test="$bladeMezzNumber &lt; $FLB_START_IX">
												<!-- Display mezzNumber directly -->
												<xsl:value-of select="$stringsDoc//value[@key='slot']"/>&#160;<xsl:value-of select="$bladeMezzNumber"/>
											</xsl:when>
											<xsl:otherwise>									
												<xsl:variable name="FLBNumber" select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:extraData[@hpoa:name='aMezzNum']"/>
												<xsl:value-of select="concat('FLB', ' ', $FLBNumber)"/>
											</xsl:otherwise>
										</xsl:choose>
										
									</xsl:otherwise>
								</xsl:choose>

							</xsl:if>
						</td>

						<xsl:choose>
							<xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoExArray/hpoa:bladeMezzInfoEx[hpoa:bayNumber=$bladeBayNumber]/hpoa:mezzInfo[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:guid) &gt; 0">
								<td nowrap="true">
									<xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoExArray/hpoa:bladeMezzInfoEx[hpoa:bayNumber=$bladeBayNumber]/hpoa:mezzInfo[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:guid">
                    <xsl:call-template name="getGuidLabel">
                      <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                      <xsl:with-param name="guidStruct" select="." />
                      <xsl:with-param name="mezzNumber" select="$bladeMezzNumber" />
                    </xsl:call-template>
										<br />
									</xsl:for-each>
								</td>
								<td>
									<xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoExArray/hpoa:bladeMezzInfoEx[hpoa:bayNumber=$bladeBayNumber]/hpoa:mezzInfo[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:guid">
										<xsl:value-of select="hpoa:guid"/>
										<br/>
									</xsl:for-each>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>
									<xsl:if test="$bladeMezzPortNumber != 0">
										<xsl:value-of select="$stringsDoc//value[@key='port']"/>&#160;<xsl:value-of select="$bladeMezzPortNumber"/>
									</xsl:if>
									<xsl:if test="count($bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']) &gt; 0">
										<br />
										iSCSI
									</xsl:if>
								</td>
								<td>
									<xsl:value-of select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:wwpn"/>
									<xsl:if test="count($bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']) &gt; 0">
										<br />
										<xsl:value-of select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']"/>
									</xsl:if>
								</td>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:element>
					
				</xsl:for-each>
				
			</tbody>
		</table>

		<br />
		<span class="whiteSpacer" >&#160;</span>
		<hr />
		<span class="whiteSpacer" >&#160;</span>
		<a href="javascript:void(0);" onclick="openPortLegend();"><xsl:value-of select="$stringsDoc//value[@key='viewPortLegend']"/>&#160;...</a>
		<br />
		<span class="whiteSpacer" >&#160;</span>
		<br />
		
	</xsl:template>

	<!-- Cell template used to display individual switch ports. -->
	<xsl:template name="portTableCell">
		
		<xsl:element name="td">
      <xsl:variable name="cellId">
        <xsl:value-of select="concat('bay', ../../hpoa:interconnectTrayBayNumber, 'port', hpoa:interconnectTraySlotPortNumber)"/>
      </xsl:variable>

      <xsl:attribute name="portStatus">
        <xsl:value-of select="hpoa:portStatus"/>
      </xsl:attribute>
      
      <xsl:attribute name="id">
        <xsl:value-of select="$cellId"/>
      </xsl:attribute>
      
      <xsl:variable name="portType">
        <xsl:choose>
          <xsl:when test="../../hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_DISABLED'">internal</xsl:when>
          <xsl:otherwise>external</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="bladeMezzNumber" select="hpoa:bladeMezzNumber" />
      <xsl:variable name="bladeMezzPortNumber" select="hpoa:bladeMezzPortNumber" />
      <xsl:variable name="bladeBayNumber" select="hpoa:bladeBayNumber" />

      <xsl:variable name="class">
        <xsl:choose>
					<xsl:when test="../../hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_DISABLED'">
						<xsl:choose>
							<xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_OK">portNumberCell portLinkedInternal</xsl:when>
							<xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">portNumberCell portMismatchInternal</xsl:when>
							<xsl:otherwise>portNumberCell portCellInternal</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="../../hpoa:passThroughModeEnabled='INTERCONNECT_TRAY_PASSTHROUGH_ENABLED'">
						<xsl:choose>
							<xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_OK">portNumberCell portLinkedExternal</xsl:when>
							<xsl:when test="hpoa:portStatus=$INTERCONNECT_TRAY_PORT_STATUS_MISMATCH">portNumberCell portMismatchExternal</xsl:when>
							<xsl:otherwise>portNumberCell portCellExternal</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- what ? -->
					</xsl:otherwise>
				</xsl:choose>		     
      </xsl:variable>  
      
      <xsl:variable name="linked">
        <xsl:value-of select="not(contains($class,'portCellInternal') or contains($class,'portCellExternal'))" />
      </xsl:variable>  
      
      <xsl:variable name="tipWidth">
        <xsl:choose>
          <xsl:when test="$linked = 'true'">
            <xsl:choose>
              <xsl:when test="string-length($bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:name) &gt; 30">
                <xsl:value-of select="330"/>
              </xsl:when>
				<xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoExArray/hpoa:bladeMezzInfoEx[hpoa:bayNumber=$bladeBayNumber]/hpoa:mezzInfo[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:port/hpoa:guid) &gt; 0">
					<xsl:value-of select="330"/>
				</xsl:when>
              <xsl:otherwise>270</xsl:otherwise>
            </xsl:choose> 
          </xsl:when>
          <xsl:otherwise>130</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

			<xsl:attribute name="class">
        <xsl:value-of select="$class"/>			
			</xsl:attribute>
      
      <!-- tooltip events -->
      <xsl:attribute name="onmouseover">try{loadDeviceInfoTip(event,this,<xsl:value-of select="$tipWidth"/>);}catch(e){};if(!document.al){this.style.backgroundPosition='1 1';}var el=this.getElementsByTagName('div')[1];el.style.border='1px solid #99CCFF';el.style.width=(document.all?'18px':'16px');el.style.height=(document.all?'18px':'16px');el.style.padding='2px 0px 0px 2px';</xsl:attribute>
      <xsl:attribute name="onmousemove">try{removeDeviceInfoTip(event,this,false);}catch(e){}</xsl:attribute>
      <xsl:attribute name="onmousedown">try{removeDeviceInfoTip(event,this,true);}catch(e){}</xsl:attribute>
      <xsl:attribute name="onmouseout">try{removeDeviceInfoTip(event,this,true);}catch(e){};if(!document.all){this.style.backgroundPosition='0 0';}var el=this.getElementsByTagName('div')[1];el.style.border='0px';el.style.width=(document.all?'18px':'17px');el.style.height=(document.all?'18px':'17px');el.style.padding='1px 0px 0px 1px';</xsl:attribute>

      <!-- tooltip element -->
      <xsl:element name="div">
        <xsl:attribute name="style">background:transparent;border:0px;padding:0px;overflow:hidden;</xsl:attribute>
        <xsl:attribute name="class">deviceInfo</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat($cellId,'InfoTip')"/>
        </xsl:attribute>
        <table cellspacing="0" style="border:1px solid #333;width:100%;">
          <tr>
            <td style="width:30%;white-space:nowrap;text-align:left;padding-left:2px;background-color:#666;color:white;">
              <b>
                <xsl:value-of select="concat($stringsDoc//value[@key='port:'],' ')"/>
              </b>
            </td>
            <td style="width:70%;text-align:left;padding-left:2px;background-color:#666;color:white;">
              <b><xsl:value-of select="hpoa:interconnectTraySlotPortNumber"/></b>
            </td>
          </tr>
          <tr>
            <td style="white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
              <b>
                <xsl:value-of select="concat($stringsDoc//value[@key='type:'],' ')"/>
              </b>
            </td>
            <td style="text-align:left;padding-left:2px;background:white;border:0px;">
              <xsl:choose>
                <xsl:when test="$portType='internal'">
                  <xsl:value-of select="$stringsDoc//value[@key='internal']"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='external']"/>
                </xsl:otherwise>
              </xsl:choose>              
            </td>
          </tr>
          <tr>
            <td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
              <b>
                <xsl:value-of select="concat($stringsDoc//value[@key='status:'],' ')"/>
              </b>              
            </td>
            <td style="text-align:left;padding-left:2px;background:white;border:0px;">
              <xsl:variable name="symbolicBayNumber" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bladeBayNumber]/hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
              <xsl:choose>
                <xsl:when test="contains($class,'portLinkedInternal') or contains($class,'portLinkedExternal')">
                  <xsl:value-of select="concat($stringsDoc//value[@key='linkedToServerBay'],' ',$symbolicBayNumber)" />
                </xsl:when>
                <xsl:when test="contains($class,'portMismatchInternal') or contains($class,'portMismatchExternal')">
                  <xsl:value-of select="concat($stringsDoc//value[@key='portMismatchToServerInBay'],' ',$symbolicBayNumber)" />
                </xsl:when>
                <xsl:when test="contains($class,'portCellInternal') or contains($class,'portCellExternal')">
                  <xsl:value-of select="$stringsDoc//value[@key='notLinked']" />
                </xsl:when>
              </xsl:choose>              
            </td>
          </tr> 
          <xsl:if test="not(contains($class,'portCellInternal') or contains($class,'portCellExternal'))">
            <xsl:if test="$bladeMezzNumber != $MEZZ_NUMBER_FIXED">
            <tr>             
                <td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
                  <b>
                    <xsl:value-of select="concat($stringsDoc//value[@key='mezzSlot:'],' ')"/>
                  </b>
                </td>
                <td style="text-align:left;padding-left:2px;background:white;border:0px;">
                  <xsl:choose>
                    <xsl:when test="$bladeMezzNumber &gt; $FLB_START_IX">
                      FLB <xsl:value-of select="($bladeMezzNumber - $FLB_START_IX)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$bladeMezzNumber" />
                    </xsl:otherwise>
                  </xsl:choose>							   
                </td>
              </tr> 
           </xsl:if> 
           <tr>             
              <td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
                <b>
                  <xsl:value-of select="concat($stringsDoc//value[@key='mezzDesc:'],' ')"/>
                </b>
              </td>
              <td style="text-align:left;padding-left:2px;background:white;border:0px;">
                <xsl:call-template name="getApprovedMezzName">
                  <xsl:with-param name="bladeType" select="$bladeInfoDoc//hpoa:bladeInfo[hpoa:bayNumber=$bladeBayNumber]/hpoa:bladeType" />
                  <xsl:with-param name="dataName" select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:name"/>
                </xsl:call-template>
              </td>
            </tr>
			  
			<xsl:choose>
				<xsl:when test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoExArray/hpoa:bladeMezzInfoEx[hpoa:bayNumber=$bladeBayNumber]/hpoa:mezzInfo[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:guid) &gt; 0">

          <xsl:for-each select="$bladeMezzInfoExDoc//hpoa:bladeMezzInfoExArray/hpoa:bladeMezzInfoEx[hpoa:bayNumber=$bladeBayNumber]/hpoa:mezzInfo[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:guid">
						<tr>
							<td style="vertical-align:top;white-space:nowrap;text-align:right;padding-left:2px;background:white;border:0px;">
								<b>
                  <xsl:call-template name="getGuidLabel">
                    <xsl:with-param name="bladeInfo" select="$bladeInfoDoc" />
                    <xsl:with-param name="guidStruct" select="." />
                    <xsl:with-param name="mezzNumber" select="$bladeMezzNumber" />
                  </xsl:call-template>
								</b>
							</td>
							<td style="text-align:left;padding-left:2px;background:white;border:0px;">
								<xsl:value-of select="hpoa:guid"/>
							</td>
						</tr>

					</xsl:for-each>

				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
							<b>
								<xsl:value-of select="concat($stringsDoc//value[@key='deviceId:'],' ')"/>
							</b>
						</td>
						<td style="text-align:left;padding-left:2px;background:white;border:0px;">
							<xsl:value-of select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:wwpn"/>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
			  
			  <xsl:if test="count($bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']) &gt; 0">
				  <xsl:if test="count($bladeMezzInfoExDoc//hpoa:bladeMezzInfoExArray/hpoa:bladeMezzInfoEx[hpoa:bayNumber=$bladeBayNumber]/hpoa:mezzInfo[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:port/hpoa:guid)=0">
					  <tr>
						  <td style="vertical-align:top;white-space:nowrap;text-align:left;padding-left:2px;background:white;border:0px;">
							  <b>
								  <xsl:value-of select="$stringsDoc//value[@key='iScsiDeviceId:']"/>
							  </b>
						  </td>
						  <td style="text-align:left;padding-left:2px;background:white;border:0px;">
							  <xsl:value-of select="$bladePortMapDoc//hpoa:bladePortMap[hpoa:bladeBayNumber=$bladeBayNumber]/hpoa:mezz[hpoa:mezzNumber=$bladeMezzNumber]/hpoa:mezzDevices/hpoa:port[hpoa:portNumber=$bladeMezzPortNumber]/hpoa:extraData[@hpoa:name='iSCSIwwpn']"/>
						  </td>
					  </tr>
				  </xsl:if>
			  </xsl:if>
			  
          </xsl:if>
        </table>
      </xsl:element>

      <!-- div size and location here are critical to cell sizing and mouseovers - don't move/change :mds -->
			<div style="width:17px;height:17px;padding:1px 0px 0px 1px;"><xsl:value-of select="hpoa:interconnectTraySlotPortNumber"/></div>

		</xsl:element>

	</xsl:template>

</xsl:stylesheet>
