<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<!-- XML document parameters containing bay information and status -->
	<xsl:param name="netTrayInfoDoc" />
	<xsl:param name="netTrayStatusDoc" />
	<xsl:param name="numIoBays" select="8" />
	<xsl:param name="isLocal" />
	<xsl:param name="proxyUrl" />
  <xsl:param name="serviceUserAcl" />
	<xsl:param name="enclosureNumber" select="''"/>

	<xsl:template match="*">
    <table border="0" cellpadding="0" cellspacing="0" width="102%">
      <tr>
        <td>
          <h3 class="subTitle">            
            <xsl:value-of select="$stringsDoc//value[@key='interconnectList']" />
          </h3>
          <div class="subTitleBottomEdge" style="margin-bottom:0px;"></div>
        </td>
      </tr>
      <tr>
        <td style="background-color:#cccccc;">
          <xsl:call-template name="menuRow" />
        </td>
      </tr>
      <tr>
        <td style="background-color:#cccccc;padding:0px 10px 10px 10px;">
          <table border="0" cellpadding="0" cellspacing="0" class="dataTable" ID="interconnectTable">
            <thead>
              <tr class="captionRow">
                <th style="width:10px;">
					<xsl:if test="count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence=$PRESENT])&gt;0">
						<input type="checkbox" devid="bay" id="summaryMaster" tableid="interconnectTable" />
					</xsl:if>
							  </th>
                <th>
                  <xsl:value-of select="$stringsDoc//value[@key='bay']" />
                </th>
                <th>
                  <xsl:value-of select="$stringsDoc//value[@key='status']" />
                </th>
                <th style="vertical-align:top;width:50px;">
								  UID
							  </th>
							  <th style="vertical-align:top;">
								  <xsl:value-of select="$stringsDoc//value[@key='powerState']" />
							  </th>
                <th>
                  <xsl:value-of select="$stringsDoc//value[@key='trayType']" />
                </th>
                <th>                  
                  <xsl:value-of select="$stringsDoc//value[@key='managementUrl']" />
                  <font style="font-size:100%;vertical-align:top;">&#160;*</font>
                </th>
                <th>
                  <xsl:value-of select="$stringsDoc//value[@key='productName']" />
                </th>
              </tr>
            </thead>
            <tbody>

              <xsl:choose>
                <xsl:when test="count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence=$PRESENT])&gt;0">

                  <!-- Loop through each of the bay values in the blade info document. -->
                  <xsl:for-each select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence='PRESENT']">

					  <xsl:variable name="delayRemaining" select="hpoa:extraData[@hpoa:name='PowerDelayRemaining']" />
					  
                    <xsl:if test="1">

                      <!--
									      Determine if the row is odd or even using Mod division, and set the
									      table row class accordingly.
								      -->
                      <xsl:variable name="alternateRowClass">
                        <xsl:if test="position() mod 2 = 0">altRowColor</xsl:if>
                      </xsl:variable>

                      <xsl:variable name="currentBayNumber" select="hpoa:bayNumber" />

                      <xsl:if test="hpoa:presence != $ABSENT and hpoa:presence != $SUBSUMED">
                        <!-- Table row element for each of the bay values in the array -->
                        <xsl:element name="tr">

                          <!-- Set the class attribute of the table cell for alternating -->
                          <xsl:attribute name="class">
                            <xsl:value-of select="$alternateRowClass" />
                          </xsl:attribute>
							
							<xsl:attribute name="originalClass"><xsl:value-of select="$alternateRowClass"/></xsl:attribute>
                          
                          <td style="vertical-align:middle;">
												    <xsl:element name="input">
													    <xsl:attribute name="type">checkbox</xsl:attribute>
													    <xsl:attribute name="devid">bay</xsl:attribute>
													    <xsl:attribute name="affectsMenus">true</xsl:attribute>
													    <xsl:attribute name="bayNumber"><xsl:value-of select="hpoa:bayNumber"/></xsl:attribute>
													    <xsl:attribute name="id"><xsl:value-of select="concat('chk', hpoa:bayNumber)"/></xsl:attribute>
														<xsl:attribute name="rowselector">yes</xsl:attribute>
												    </xsl:element>
											    </td>
									<td style="vertical-align:middle;">
                            <xsl:element name="a">
                              <xsl:attribute name="href">javascript:selectDevice(<xsl:value-of select="hpoa:bayNumber" />);</xsl:attribute>
                              <xsl:value-of select="hpoa:bayNumber" />
                            </xsl:element>
                          </td>

                          <!--
											      Get the current bay's blade status value. Call the Status Label template
											      to set the text and image for the current bay's blade status.
										      -->
									<td style="vertical-align:middle;">
                            <xsl:call-template name="getStatusLabel">
                              <xsl:with-param name="statusCode" select="hpoa:operationalStatus" />
                            </xsl:call-template>
                          </td>
                          											  <!--
													Get the UID value for the current bay's blade. Call the UID Label template
													to set the text and image for the UID's state.
												-->
									<td style="vertical-align:middle;">

												  <div id="{concat('bay', $currentBayNumber, 'uid')}">
													  <xsl:call-template name="getUIDLabel">
														  <xsl:with-param name="statusCode" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:uid" />
													  </xsl:call-template>
												  </div>
												  
											  </td>

											  <!--
													Get the power state for the current interconnect. Call the Power State
													Label template to get the text for the interconnect's power state.
												-->
									<td style="vertical-align:middle;">
												  <div id="{concat('bay', $currentBayNumber, 'powerState')}">
													  <xsl:choose>
														  <xsl:when test="number($delayRemaining) &gt; 0">
															  <xsl:value-of select="$stringsDoc//value[@key='delayed']" /> (<xsl:value-of select="$delayRemaining"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='seconds']" />)
														  </xsl:when>
														  <xsl:when test="number($delayRemaining)=-1">
															  <xsl:value-of select="$stringsDoc//value[@key='delayed']" /> - <xsl:value-of select="$stringsDoc//value[@key='noPoweron']"/>
														  </xsl:when>
														  <xsl:otherwise>
															  <xsl:call-template name="getPowerStateLabel">
																  <xsl:with-param name="powerState" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:bayNumber=$currentBayNumber]/hpoa:powered" />
															  </xsl:call-template>
														  </xsl:otherwise>
													  </xsl:choose>
													  
												  </div>
											  </td>
									<td style="vertical-align:middle;">
									  <xsl:variable name="extendedType">
										  <xsl:value-of select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='ExtendedFabricType']"/>
									  </xsl:variable>

									  <xsl:variable name="interconnectType">
										  <xsl:choose>
											  <xsl:when test="$extendedType!=''">
												  <xsl:value-of select="$extendedType"/>
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:interconnectTrayType"/>
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:variable>
                            <xsl:call-template name="getInterconnectTypeLabel">
                              <xsl:with-param name="type" select="$interconnectType" />
                            </xsl:call-template>
                          </td>
									<td style="vertical-align:middle;">

							  <xsl:variable name="mgmtUrl" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:urlToMgmt" />
							  <xsl:variable name="mgmtIp" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:inBandIpAddress" />
							  <xsl:variable name="fqdn" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[@hpoa:name='urlToMgmtFQDN']" />

							  <xsl:variable name="isThereBayIPv6">
								<xsl:choose>
									<xsl:when test="count($netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]) &gt; 0">
										<xsl:value-of select="'true'" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'false'" />
									</xsl:otherwise>
								</xsl:choose>
							  </xsl:variable>
							  <xsl:if test="string-length($fqdn) &gt; 0 and $fqdn != 'http://' and $fqdn != 'https://' and $fqdn != 'http:///' and $fqdn != 'https:///'">
								<xsl:choose>
									<!-- is using proxy -->
									<xsl:when test="starts-with($fqdn, '/') and $isLocal='false'">
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="concat($proxyUrl, $fqdn)"/></xsl:attribute>
											<xsl:attribute name="target">_blank</xsl:attribute>
											<xsl:value-of select="$fqdn"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="$fqdn"/></xsl:attribute>
											<xsl:attribute name="target">_blank</xsl:attribute>
											<xsl:value-of select="$fqdn"/>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							  </xsl:if>
							  <!-- empty FQDN URL, IPv4 mgmt URL should be the default hyperlink -->
							  <xsl:if test="string-length($fqdn) &lt; 1">
							  	<xsl:choose>
									<xsl:when test="$mgmtUrl != 'http://' and $mgmtUrl != 'https://' and $mgmtUrl != 'http:///' and $mgmtUrl != 'https:///' and $mgmtUrl != ''">
									  <xsl:choose>
										  <xsl:when test="starts-with($mgmtUrl, '/') and $isLocal='false'"> <!-- is using proxy -->
											  <xsl:element name="a">
												  <xsl:attribute name="href"><xsl:value-of select="concat($proxyUrl, $mgmtUrl)"/></xsl:attribute>
												  <xsl:attribute name="target">_blank</xsl:attribute>
												  <xsl:value-of select="$mgmtUrl"/>
											  </xsl:element>
										  </xsl:when>
										  <xsl:otherwise>
											  <xsl:element name="a">
												  <xsl:attribute name="href"><xsl:value-of select="$mgmtUrl"/></xsl:attribute>
												  <xsl:attribute name="target">_blank</xsl:attribute>
												  <xsl:value-of select="$mgmtUrl"/>
											  </xsl:element>
										  </xsl:otherwise>
									  </xsl:choose>
									</xsl:when>
									<xsl:otherwise> <!-- empty IPv4 URL, show message if IPv6 exists -->
										<xsl:if test="$isThereBayIPv6 = 'true'">
											<xsl:value-of select="$stringsDoc//value[@key='noIPv4Url']" />
										</xsl:if>
									</xsl:otherwise>
							  	</xsl:choose>
							  </xsl:if>
							  <xsl:if test="$isThereBayIPv6 = 'true' or string-length($fqdn) &gt; 0">
								<xsl:text> </xsl:text>
								<xsl:element name="a">
									<xsl:attribute name="devId">
										<xsl:value-of select="concat('enc', $enclosureNumber, 'bay', $currentBayNumber)" />
									</xsl:attribute>
									<xsl:attribute name="target">_blank</xsl:attribute>
									<xsl:attribute name="class">treeSelectableLink</xsl:attribute>
									<xsl:call-template name="urlListTooltip">
										<xsl:with-param name="fqdn" select="$fqdn" />
										<xsl:with-param name="defaultUrl" select="$mgmtUrl" />
										<xsl:with-param name="urlList" select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:extraData[contains(@hpoa:name,'urlToMgmtIPv6')]" />
										<xsl:with-param name="itemProxyUrl" select="$proxyUrl" />
										<xsl:with-param name="isLocal" select="$isLocal" />
									</xsl:call-template>
								</xsl:element>
							  </xsl:if>                            

                          </td>

                          <!--
											      Get the current bay's server blade name and display it in the table cell.
										      -->
									<td style="vertical-align:middle;">
                            <xsl:value-of select="$netTrayInfoDoc//hpoa:interconnectTrayInfo[hpoa:bayNumber=$currentBayNumber]/hpoa:name" />
                          </td>

                        </xsl:element>
                      </xsl:if>
                    </xsl:if>
                  </xsl:for-each>

                </xsl:when>
                <!-- Check for no permissions altogether. -->
                <xsl:when test="(count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence='PRESENCE_NO_OP'])+count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence=$LOCKED]))=$numIoBays">
                  <tr class="noDataRow">
                    <td colspan="8"><xsl:value-of select="$stringsDoc//value[@key='noPermissionToInterconnects']" /></td>
                  </tr>
                </xsl:when>
                <!-- Check for some permissions and some locked. -->
                <xsl:when test="count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence=$ABSENT])&gt;0 and (count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence='PRESENCE_NO_OP'])+count($netTrayStatusDoc//hpoa:interconnectTrayStatus[hpoa:presence=$LOCKED]))&gt;0">
                  <tr class="noDataRow">
                    <td colspan="8" style="padding-left:20px;padding-right:20px;">
                      <xsl:value-of select="$stringsDoc//value[@key='notAllBaysCanBeDisplayed']" />
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr class="noDataRow">
                    <td colspan="8"><xsl:value-of select="$stringsDoc//value[@key='noInterconnectsToDisplay']" /></td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>

            </tbody>
          </table>
        </td>
      </tr>
    </table>
    
    <span class="whiteSpacer">&#160;</span>
		<br />

		<div class='buttonSet' style='margin-bottom:0px;'>
			<div class='bWrapperUp'>
				<div>
					<div>
						<button type='button' class='hpButton' onclick="refreshSummary();">
							<xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']" />
						</button>
					</div>
				</div>
			</div>
		</div>
    <div class="clearFloats" style="margin-bottom:0px;"></div>
    <font style="font-size:120%;margin-right:3px;">
      <xsl:value-of select="$stringsDoc//value[@key='asterisk']"/>
    </font>
    <em>
      <xsl:value-of select="$stringsDoc//value[@key='ioMgmtUrlDislaimer']" />
    </em>
    </xsl:template>
  
  <!-- 
  @Purpose: Adds a new row with menus for setting power and UID states.
  @Created: 08-31-2006
  @Author : michael.slama@hp.com
  -->
  <xsl:template name="menuRow">
	  <table style="background-color:#cccccc;margin-left:3px;">
		  <tr>
			  <td colspan="6" style="background-color:#CCCCCC;padding:2px;">
				  <table style="border:0px;width:100%;">
					  <tr>
						  <td style="border:0px;background-color:#CCCCCC;" onmouseover="updateMenuStatus();">
                <xsl:if test="$serviceUserAcl != $USER">
							    <div id="m01_trigger" class="localNavTrigger">
								    <xsl:value-of select="$stringsDoc//value[@key='virtualPower']" />
								    <ul id="m01" class="dropdownMenu" isdropdownmenu="yes" >
									    <li id="turnOn" class="">
										    <a href="javascript:void(0);" onmouseover="window.status='';return true;" 
                          onclick="(this.parentNode.className=='disabled' ? '':setInterconnectsPower(true))">
											    <xsl:value-of select="$stringsDoc//value[@key='turnOn']" />
										    </a>
									    </li>
                      <li id="turnOff" class="">
										    <a href="javascript:void(0);" onmouseover="window.status='';return true;" 
                          onclick="(this.parentNode.className=='disabled' ? '':setInterconnectsPower(false))">
											    <xsl:value-of select="$stringsDoc//value[@key='turnOff']" />
										    </a>
									    </li>
                    </ul>
                  </div>
                </xsl:if>
                <div id="m02_trigger" class="localNavTrigger">
                  <xsl:value-of select="$stringsDoc//value[@key='uidState']" />
                  <ul id="m02" class="dropdownMenu" isdropdownmenu="yes">
                    <li id="toggleOn" class="">
                      <a href="javascript:void(0)" onmouseover="window.status='';return true;" 
                        onclick="(this.parentNode.className=='disabled' ? '':toggleInterconnectsUids(UID_CMD_ON()));">											  
											  <xsl:value-of select="$stringsDoc//value[@key='turnOn']" />
										  </a>
									  </li>
									  <li id="toggleOff" class="">
										  <a href="javascript:void(0)" onmouseover="window.status='';return true;" 
                        onclick="(this.parentNode.className=='disabled' ? '':toggleInterconnectsUids(UID_CMD_OFF()));">											  
											  <xsl:value-of select="$stringsDoc//value[@key='turnOff']" />
									  </a>
								  </li>
							  </ul>
						  </div>
						  </td>
					  </tr>
				  </table>
			  </td>
		  </tr>
	  </table>	  
  </xsl:template>

</xsl:stylesheet>

  
  
