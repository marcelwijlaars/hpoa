<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/NetworkSettings.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="oaNetworkInfoDoc" />
	<xsl:param name="oaStatusDoc" />
	<xsl:param name="enclosureVersion" />

	<xsl:param name="serviceUserAcl" />
	<xsl:param name="serviceUserOaAccess" />
	<xsl:param name="encNum" />
	<xsl:param name="vlanInfoDoc" />
	<xsl:param name="readOnly" select="false()" />
	
	<xsl:template match="*">

		<xsl:variable name="acquiring" select="($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:ipAddress=$EMPTY_IP_TEST) and ($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:netmask=$EMPTY_IP_TEST)" />
		
       		<b>
			<xsl:value-of select="$stringsDoc//value[@key='ipSettings']" />
		</b><br />

		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='information:']" />&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='currentIPDescription']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span>

		<BR/><BR/><xsl:value-of select="$stringsDoc//value[@key='ipv4Information']" /><BR/><BR/>
			
		<div class="groupingBox">
			
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
								
					<xsl:choose>
						<xsl:when test="$acquiring">
							<TR>
								<TD>
									<xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" />
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
									<em><xsl:value-of select="$stringsDoc//value[@key='acquiring']"/></em>
								</TD>
							</TR>
						</xsl:when>
						<xsl:otherwise>
							<TR>
								<TD>
									<xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" />
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
									<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:ipAddress" />
									<xsl:choose>
										<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dhcpEnabled='true'">
											(<xsl:value-of select="$stringsDoc//value[@key='dhcp']" />)
										</xsl:when>
										<xsl:otherwise>
											(<xsl:value-of select="$stringsDoc//value[@key='static']" />)
										</xsl:otherwise>
									</xsl:choose>
								</TD>
							</TR>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>
							<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dhcpEnabled='true'">
								<TR>
									<TD>
										<xsl:value-of select="$stringsDoc//value[@key='dynDNS:']" />
									</TD>
									<TD width="10">&#160;</TD>
									<TD>
										<xsl:choose>
											<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:dynDnsEnabled='true'">
												<xsl:value-of select="$stringsDoc//value[@key='enabled']" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$stringsDoc//value[@key='disabled']" />
											</xsl:otherwise>
										</xsl:choose>
									</TD>
								</TR>
								<tr>
									<td colspan="3" class="formSpacer">&#160;</td>
								</tr>
							</xsl:if>
							<TR>
								<TD>
									<xsl:value-of select="$stringsDoc//value[@key='subnetMask:']" />
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
									<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:netmask" />
								</TD>
							</TR>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>
							<TR>
								<TD>
									<xsl:value-of select="$stringsDoc//value[@key='gateway:']" />
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
									<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:gateway!=$EMPTY_IP_TEST">
										<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:gateway" />
									</xsl:if>
								</TD>
							</TR>
							</xsl:otherwise>
						</xsl:choose>
						
					</TABLE>			

			</div>	
			
		<BR/><BR/><xsl:value-of select="$stringsDoc//value[@key='ipv6Information']" /><BR/><BR/>		

		<div class="groupingBox">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">

				
				<TR>
					<TD>IPv6:</TD>
						<TD width="10">&#160;</TD>
					<TD>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true'">
									<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
								</xsl:if>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='false'">
									<xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
								</xsl:if>
					</TD>
				</TR>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<!--IPV6 LINK LOCAL -->
					<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">
					
					<xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>

					<xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>
	
					<xsl:if test="contains($temp1, 'LINKLOCAL')">
												
						<TR>
							
							<TD>
							<xsl:value-of select="$stringsDoc//value[@key='ipv6LinkLocalAddr']"/>
	
							</TD>
							<TD width="10">&#160;</TD>
							<TD>
							
							<xsl:variable name="temp2" select="concat('Ipv6Address',(position()-1))"/>

							<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
												
							</TD>
						</TR>
						<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
						</tr>

					</xsl:if>
					</xsl:for-each>
					<!--IPv6 STATIC ADDRESSES-->
					<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">
					
					<xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>

					<xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>
	
					<xsl:if test="contains($temp1, 'STATIC')">
												
						<TR>
							
							<TD nowrap="true">
							<!--	<xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" /> -->
							<xsl:value-of select="concat($stringsDoc//value[@key='ipv6StaticAddr'],position(),':')"/>
	
							</TD>
							<TD width="10">&#160;</TD>
							<TD>
							
							<xsl:variable name="temp2" select="concat('Ipv6Address',(position()-1))"/>

							<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
												
							</TD>
						</TR>
						<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
						</tr>

					</xsl:if>
					</xsl:for-each>
					<!--DYNAMIC DNS -->
					<xsl:if test="$enclosureVersion &gt;= 4.0 and $oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled']='true'">
						<TR>
							<TD>
								<xsl:value-of select="$stringsDoc//value[@key='dynDNSIPv6']" />:
							</TD>
							<TD width="10">&#160;</TD>
							<TD>
								<xsl:choose>
									<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DynamicDns']='true'">
										<xsl:value-of select="$stringsDoc//value[@key='enabled']" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$stringsDoc//value[@key='disabled']" />
									</xsl:otherwise>
								</xsl:choose>
							</TD>
						</TR>
						<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
						</tr>
					</xsl:if>
					<!--DHCP -->
							<TR>
								<TD>
									<xsl:value-of select="$stringsDoc//value[@key='dhcpv6']" /> 
									
									<!--<xsl:value-of select="$stringsDoc//value[@key='subnetMask:']" />-->
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled']='true'">
									<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
								</xsl:if>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DhcpEnabled']='false'">
									<xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
								</xsl:if>
								
						</TD>
							</TR>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>
					<!--DHCPv6 LOOP-->
					<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">
					
					<xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>

					<xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>
	
					<xsl:if test="contains($temp1, 'DHCP')">
												
						<TR>
							
							<TD>
							<!--	<xsl:value-of select="$stringsDoc//value[@key='ipAddress:']" /> -->
							<xsl:value-of select="$stringsDoc//value[@key='dhcpv6Addr:']" />
	
							</TD>
							<TD width="10">&#160;</TD>
							<TD>
							
							<xsl:variable name="temp2" select="concat('Ipv6Address',(position()-1))"/>

							<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
												
							</TD>
						</TR>
						<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
						</tr>

					</xsl:if>
					</xsl:for-each>
					<!-- RADV Traffic CODE -->

                                       			<xsl:if test="$enclosureVersion &gt;= 4.3">
							<TR>
								<TD>
									<xsl:value-of select="$stringsDoc//value[@key='routerTrafficConf']" /> 
									<!--<xsl:value-of select="$stringsDoc//value[@key='subnetMask:']" />-->
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RaTrafficEnabled']='true'">
									<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
								</xsl:if>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RaTrafficEnabled']='false'">
									<xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
								</xsl:if>
								
								</TD>
								
							</TR>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>
							</xsl:if>
							
					<!-- RADV CODE -->
							<TR>
								<TD>
                  <xsl:choose>
                    <xsl:when test="$enclosureVersion &gt;= 4.0"><xsl:value-of select="$stringsDoc//value[@key='statelessAddrAutoconf']" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='routerAdv']" /></xsl:otherwise>
                  </xsl:choose>
								</TD>
								<TD width="10">&#160;</TD>
								<TD>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='true'">
									<xsl:value-of select="$stringsDoc//value[@key='enabled']"/>
								</xsl:if>
								<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6RouterAdvEnabled']='false'">
									<xsl:value-of select="$stringsDoc//value[@key='disabled']"/>
								</xsl:if>
								
								</TD>
								
							</TR>
							<tr>
								<td colspan="3" class="formSpacer">&#160;</td>
							</tr>
							
					<!--START OF RADv LOOP -->
					<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6AddressType')]">
					
					<xsl:variable name="temp" select="concat('Ipv6AddressType',(position()-1))"/>

					<xsl:variable name="temp1" select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp]"/>
	
					<xsl:if test="contains($temp1, 'ROUTERADV')">
												
						<TR>
							
							<TD>
							<xsl:choose>
                <xsl:when test="$enclosureVersion &gt;= 4.0"><xsl:value-of select="$stringsDoc//value[@key='slaacAddr']" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='routerAdvAddr']" /></xsl:otherwise>
              </xsl:choose>							 
	
							</TD>
							<TD width="10">&#160;</TD>
							<TD>
							
							<xsl:variable name="temp2" select="concat('Ipv6Address',(position()-1))"/>
							<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$temp2]" />
												
							</TD>
						</TR>
						

					</xsl:if>
					</xsl:for-each>
					<!--END OF RADV CODE -->
 				

                                       	<!-- Default Gateway - test for OA version 4.20 & up-->
                                       	<xsl:if test="$enclosureVersion &gt;= 4.2">
					<!-- Must show that is not configured when empty -->
                                       <tr>
                                               <td colspan="3" class="formSpacer">&#160;</td>
                                       </tr>

					<TR>
	                                       <TD>
	                                               	<xsl:value-of select="$stringsDoc//value[@key='gatewayIPv6:']" />
                                               </TD>
                                               <TD width="10">&#160;</TD>
                                               <TD>
							<xsl:choose>
                                                        <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DefaultGateway']=''">
	                                                      	<xsl:value-of select="$stringsDoc//value[@key='notSet']" />
                                                        </xsl:when>
                                                      	<xsl:otherwise>
                                                              <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6DefaultGateway']" />
          
							</xsl:otherwise>
							</xsl:choose>

                                               </TD>
                                       </TR>
                                       <tr>
	                                       <td colspan="3" class="formSpacer">&#160;</td>
                                       </tr>
                                       
					<!-- Must test for empty -->
					 <xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6StaticDefaultGateway']!=''">
					<TR>
                                               <TD>
                                                       <xsl:value-of select="$stringsDoc//value[@key='gatewayIPv6Static:']" />
                                               </TD>
                                               <TD width="10">&#160;</TD>
                                               <TD>
                                                       <xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6StaticDefaultGateway']" />
                                               </TD>
                                       </TR>
                                       <tr>
                                               <td colspan="3" class="formSpacer">&#160;</td>
                                       </tr>
					</xsl:if>
					</xsl:if>

					<!-- Static Routes - test for OA version 4.30 & up-->
                                       	<xsl:if test="$enclosureVersion &gt;= 4.3">
						<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6StaticRouteDestination')]">
							<xsl:variable name="SOAPName" select="concat('Ipv6StaticRouteDestination', position())"/>
							<xsl:variable name="GWSOAPName" select="concat('Ipv6StaticRouteGateway', position())"/>
							<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$SOAPName]!=''">
								<TR>
								   <TD>
										<xsl:value-of select="concat($stringsDoc//value[@key='staticipv6routedestination'], position(), ':')" />
								   </TD>
								   <TD width="10">&#160;</TD>
								   <TD>
										<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$SOAPName]" />
								   </TD>
							   </TR>
							   <tr>
									<td colspan="3" class="formSpacer">&#160;</td>
							   </tr>
								<TR>
								   <TD>
										<xsl:value-of select="concat($stringsDoc//value[@key='staticipv6routegateway'], position(), '):')" />
								   </TD>
								   <TD width="10">&#160;</TD>
								   <TD>
										<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$GWSOAPName]" />
								   </TD>
							   </TR>
							   <tr>
									<td colspan="3" class="formSpacer">&#160;</td>
							   </tr>
						</xsl:if>

						</xsl:for-each>
					</xsl:if>
					</TABLE>			
			</div>	
			
	
		<BR/><BR/><xsl:value-of select="$stringsDoc//value[@key='genInformation']" /><BR/><BR/>
                <div id="errorDisplay" class="errorDisplay"></div>
		<div class="groupingBox">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<!-- START IPv4 DNS -->
					<TR>
						<TD width="160">
						<xsl:value-of select="$stringsDoc//value[@key='activeV4DnsServers']" />
						</TD>						
					</TR>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
				<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv4Dns')]">
					<xsl:variable name="v4dns" select="concat('Ipv4Dns',position())"/>
					<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$v4dns]!=''">					
					<TR>
						<TD width="160" style="padding-left:15px">
						<xsl:choose>								
							<xsl:when test="position()=1" >
								<xsl:value-of select="concat($stringsDoc//value[@key='primary'],':')"/>
							</xsl:when>	
							<xsl:when test="position()=2" >
								<xsl:value-of select="concat($stringsDoc//value[@key='secondary'],':')"/>
							</xsl:when>
							<xsl:when test="position()=3" >
								<xsl:value-of select="concat($stringsDoc//value[@key='tertiary'],':')"/>
							</xsl:when>
							<xsl:when test="position()=4" >
								<xsl:value-of select="concat($stringsDoc//value[@key='quaternary'],':')"/>
							</xsl:when>
						</xsl:choose>
						</TD>
						<TD>
						<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$v4dns]" />
						</TD>						
						</TR>
						<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv4Dns1')]) or 
							  $oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv4Dns1']=''">
				<TR>
					<TD width="160" style="padding-left:15px">
					<xsl:value-of select="concat($stringsDoc//value[@key='primary'],':')"/>
					</TD>
					<TD><xsl:value-of select="$stringsDoc//value[@key='notSet']" /></TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>				
				</xsl:if>
				<xsl:if test="not($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv4Dns2')]) or 
							  $oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv4Dns2']=''">
				<TR>
					<TD width="160"  style="padding-left:15px">
					<xsl:value-of select="concat($stringsDoc//value[@key='secondary'],':')"/>
					</TD>
					<TD><xsl:value-of select="$stringsDoc//value[@key='notSet']" /></TD>
				</TR>				
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				</xsl:if>				
				<!-- END IPv4 DNS -->					
				<!-- START IPv6 DNS -->
					<TR>
						<TD width="160">
						<xsl:value-of select="$stringsDoc//value[@key='activeV6DnsServers']" />
						</TD>						
					</TR>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
				<xsl:for-each select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6Dns')]">
					<xsl:variable name="v6dns" select="concat('Ipv6Dns',position())"/>
					<xsl:if test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$v6dns]!=''">					
					<TR>
						<TD width="160" style="padding-left:15px">
						<xsl:choose>								
							<xsl:when test="position()=1" >
								<xsl:value-of select="concat($stringsDoc//value[@key='primary'],':')"/>
							</xsl:when>	
							<xsl:when test="position()=2" >
								<xsl:value-of select="concat($stringsDoc//value[@key='secondary'],':')"/>
							</xsl:when>
							<xsl:when test="position()=3" >
								<xsl:value-of select="concat($stringsDoc//value[@key='tertiary'],':')"/>
							</xsl:when>
							<xsl:when test="position()=4" >
								<xsl:value-of select="concat($stringsDoc//value[@key='quaternary'],':')"/>
							</xsl:when>
						</xsl:choose>
						</TD>
						<TD>
						<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name=$v6dns]" />
						</TD>						
						</TR>
						<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6Dns1')]) or 
							  $oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Dns1']=''">
				<TR>
					<TD width="160" style="padding-left:15px">
					<xsl:value-of select="concat($stringsDoc//value[@key='primary'],':')"/>
					</TD>
					<TD><xsl:value-of select="$stringsDoc//value[@key='notSet']" /></TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>				
				</xsl:if>
				<xsl:if test="not($oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[contains(@hpoa:name,'Ipv6Dns2')]) or 
							  $oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Dns2']=''">
				<TR>
					<TD width="160" style="padding-left:15px">
					<xsl:value-of select="concat($stringsDoc//value[@key='secondary'],':')"/>
					</TD>
					<TD><xsl:value-of select="$stringsDoc//value[@key='notSet']" /></TD>
				</TR>				
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				</xsl:if>				
				<!-- END IPv6 DNS -->					
					
			<xsl:if test="not($acquiring)">
							
						<TR>
							<TD width="200" id="lblOaName">
								<xsl:value-of select="$stringsDoc//value[@key='oaName:']" />
							</TD>
							<!--<TD width="10">&#160;</TD>-->
							<TD>
								<xsl:choose>
									<xsl:when test="$readOnly != 'true'">
										<xsl:element name="input">
											<xsl:attribute name="type">text</xsl:attribute>
											<xsl:attribute name="class">stdInput</xsl:attribute>
											<xsl:attribute name="id">oaName</xsl:attribute>
											<xsl:choose>
												<xsl:when test="$serviceUserAcl = $USER or $serviceUserOaAccess != 'true'">
													<xsl:attribute name="disabled">true</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<!-- validation: string, no spaces, 1-60 characters -->
													<xsl:attribute name="validate-oaName">true</xsl:attribute>
													<xsl:attribute name="rule-list">6;8</xsl:attribute>
													<xsl:attribute name="range">1;32</xsl:attribute>
													<xsl:attribute name="caption-label">lblOaName</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:attribute name="maxlength">32</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="$oaStatusDoc//hpoa:oaStatus/hpoa:oaName"/>
											</xsl:attribute>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$oaStatusDoc//hpoa:oaStatus/hpoa:oaName"/>
									</xsl:otherwise>
								</xsl:choose>
							</TD>
						</TR>
					<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
		</xsl:if>
				<xsl:if test="$vlanInfoDoc//hpoa:vlanInfo/hpoa:vlanEnable='1'">
        				<TR>
            					<TD width="160">
					              <xsl:value-of select="$stringsDoc//value[@key='vlanIdName:']" />
            					</TD>
			       			<!--<TD width="10">&#160;</TD>-->
            					<TD>
					              <xsl:variable name="vlanId" select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:portArray/hpoa:port[@hpoa:deviceType='OA']/hpoa:portVlanId" />
				       	       <xsl:value-of select="$vlanId"/>
					              (<xsl:value-of select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg[hpoa:vlanId=$vlanId]/hpoa:vlanName"/>)
            					</TD>
          				</TR>
					<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
				</xsl:if>
		
						<TR>
							<TD width="160">
							<xsl:value-of select="$stringsDoc//value[@key='macAddress:']" />
							</TD>
							<!--<TD width="10">&#160;</TD>-->
							<TD>
								<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:macAddress"/>
							</TD>
						</TR>		
						
					<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
          <xsl:if test="$enclosureVersion &gt;= 4.0">
						<TR>
							<TD width="160">
							<xsl:value-of select="$stringsDoc//value[@key='domainName:']" />
							</TD>
							<!--<TD width="10">&#160;</TD>-->
							<TD>
							<xsl:choose>
							<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='overridedhcpdn']='true'">
								<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='user_domain_name']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='dhcp_domain_name']" />
							</xsl:otherwise>
						</xsl:choose>
							</TD>
						</TR>		
						
					<tr>
							<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
          </xsl:if>


				<xsl:if test="$readOnly='true'">
					<TR>
						<TD width="160">
							<xsl:value-of select="$stringsDoc//value[@key='nicSettings']" />:
						</TD>
						<!--<TD width="10">&#160;</TD>-->
						<TD>
							<xsl:choose>
								<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICLinkForced'] = 'false'">
									<xsl:value-of select="$stringsDoc//value[@key='autoNeg']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='forcedFull']" />
								</xsl:otherwise>
							</xsl:choose>,&#160;<xsl:choose>
								<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_10'">10Mbps</xsl:when>
								<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_100'">100Mbps</xsl:when>
								<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_1000'">1000Mbps</xsl:when>
								<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed'] = 'NIC_SPEED_10000'">10Gbps</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICSpeed']" />
								</xsl:otherwise>
							</xsl:choose>,&#160;<xsl:choose>
                                                                <xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='NICDuplex'] = 'NIC_DUPLEX_FULL'">
                                                                        <xsl:value-of select="$stringsDoc//value[@key='fullDuplex']" />
								</xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:value-of select="$stringsDoc//value[@key='halfDuplex']" />
                                                                </xsl:otherwise>
                                                        </xsl:choose>

						</TD>
					</TR>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<TR>
						<TD width="160">
							<xsl:value-of select="$stringsDoc//value[@key='linkStatus']"/>:
						</TD>
						<!--<TD width="10">&#160;</TD>-->
						<TD>
							<xsl:choose>
								<xsl:when test="$oaNetworkInfoDoc//hpoa:oaNetworkInfo/hpoa:linkActive='true'">
									<xsl:value-of select="$stringsDoc//value[@key='active']"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='notActive']"/>
								</xsl:otherwise>
							</xsl:choose>
						</TD>
					</TR>

				</xsl:if>
				
			</TABLE>
		</div>
		
		
		<xsl:if test="$readOnly != 'true'">
						<span class="whiteSpacer">&#160;</span><br />
						<span class="whiteSpacer">&#160;</span><br />
						
						<xsl:value-of select="$stringsDoc//value[@key='settings:']" />&#160;<em>
							<xsl:value-of select="$stringsDoc//value[@key='ipSettingsDescription']" />
						</em><br />
						<span class="whiteSpacer">&#160;</span><br />
						<div class="groupingBox">

							<xsl:call-template name="networkSettings" >
							  <xsl:with-param name="stringsDoc" select="$stringsDoc" />
								<xsl:with-param name="oaNetworkInfoDoc" select="$oaNetworkInfoDoc" />
								<xsl:with-param name="readOnly" select="$readOnly" />
							</xsl:call-template>
						</div>

						<span class="whiteSpacer">&#160;</span><br />
						<div align="right">
							<div class='buttonSet' style="margin-bottom:0px;">
								<div class='bWrapperUp'>
									<div>
										<div>
											<button type='button' onclick='setNetworkSettings();'  class='hpButton' id="Button0">
												<xsl:value-of select="$stringsDoc//value[@key='apply']" />
											</button>
										</div>
									</div>
								</div>
							</div>
						</div>

						<span class="whiteSpacer">&#160;</span>
						
						<xsl:value-of select="$stringsDoc//value[@key='nicSettings']" /><br />
						<span class="whiteSpacer">&#160;</span><br />
						
						<div class="groupingBox">
									
							<div id="nicErrorDisplay" class="errorDisplay"></div>
							<xsl:call-template name="nicSettings">
								<xsl:with-param name="oaNetworkInfoDoc" select="$oaNetworkInfoDoc" />
								<xsl:with-param name="oaMode" select="$oaStatusDoc//hpoa:oaStatus/hpoa:oaRole" />
								<xsl:with-param name="encNum" select="$encNum" />
								<xsl:with-param name="readOnly" select="$readOnly" />
							</xsl:call-template>
						</div>

						<span class="whiteSpacer">&#160;</span><br />

						<xsl:if test="$readOnly != 'true'">
							<div align="right">
								<div class='buttonSet' style="margin-bottom:0px;">
									<div class='bWrapperUp'>
										<div>
											<div>
												<button type='button' onclick='setOaNicSettings();'  class='hpButton' id="Button1">
													<xsl:value-of select="$stringsDoc//value[@key='apply']" />
												</button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</xsl:if>
			</xsl:if>
		
			<xsl:if test="$readOnly = 'true'">
			<xsl:if test="$serviceUserAcl!=$USER and $serviceUserOaAccess='true'">
					
			<span class="whiteSpacer">&#160;</span><br />
			<span class="whiteSpacer">&#160;</span><br />
						
			<xsl:value-of select="$stringsDoc//value[@key='modTcpIp-pre']" />
			<xsl:element name="a">
				<xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(20, ENCLOSURE_NETWORK(), <xsl:value-of select="$encNum"/>, true);</xsl:attribute>
				<xsl:value-of select="$stringsDoc//value[@key='clickHere']" />
			</xsl:element><xsl:value-of select="$stringsDoc//value[@key='modTcpIp']" />
			
			</xsl:if>
			</xsl:if>
    </xsl:template>


</xsl:stylesheet>

