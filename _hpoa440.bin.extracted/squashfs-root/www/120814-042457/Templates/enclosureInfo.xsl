<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:param name="enclosureInfoDoc" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="serviceUserOaAccess" />
	<xsl:param name="oaSessionKey" />
	<xsl:param name="oaUrl" />
        <xsl:param name="encNum" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureType" select="0" />
  
	<xsl:template match="*">

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<thead>
				<tr class="captionRow">
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='part']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='model']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='manufacturer']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='serialNumber']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='partNumber']" />
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='sparePartNumber']" />
					</th>
				</tr>
			</thead>
			<TBODY>
				<xsl:for-each select="$enclosureInfoDoc//hpoa:enclosureInfo">

					<tr>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='enclosure']" />
						</td>
						<td>
							<xsl:value-of select="hpoa:name" />
						</td>
						<td>
							<xsl:value-of select="hpoa:manufacturer"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:serialNumber"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:partNumber"/>
						</td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
						</td>
					</tr>

					<tr class="altRowColor">
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='encMidplane']" />
						</td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
						</td>
						<td>
							<xsl:value-of select="hpoa:manufacturer"/>
						</td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
						</td>
						<td>
							<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
						</td>
						<td>
							<xsl:value-of select="hpoa:chassisSparePartNumber"/>
						</td>
					</tr>

					<xsl:if test="not(contains(hpoa:name, 'c3000'))">

						<tr>
							<td>
								<xsl:value-of select="$stringsDoc//value[@key='oaTray']" />
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerName" />
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerManufacturer"/>
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerSerialNumber"/>
							</td>
							<td>
								<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
							</td>
							<td>
								<xsl:value-of select="hpoa:interposerPartNumber"/>
							</td>
						</tr>

						<tr class="altRowColor">
							<td>
								<xsl:value-of select="$stringsDoc//value[@key='pim']" />
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="hpoa:extraData[@hpoa:name='pduProductName'] != '[Unknown]'">
										<xsl:value-of select="hpoa:extraData[@hpoa:name='pduProductName']"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								HP
							</td>
							<td>
								<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
							</td>
							<td>
								<!--
									This is not an orderable part number for the PDU.  The
									spare part number should be used instead.
								-->
								<!--<xsl:value-of select="hpoa:pduPartNumber"/>-->
								<xsl:value-of select="$stringsDoc//value[@key='n/a']" />
							</td>
							<td>
								<xsl:value-of select="hpoa:pduSparePartNumber"/>
							</td>
						</tr>

					</xsl:if>

				</xsl:for-each>
			</TBODY>
		</table>

                

                <xsl:if test="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState'] and $enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState']!='0' and $enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState']!='2'">
                    
                <span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

                <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
                    <caption>
                        <xsl:value-of select="$stringsDoc//value[@key='rackInformation']" />
                    </caption>
                    <tbody>
                       
                       <xsl:choose>
                           <xsl:when test="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState']='1'">
                                <tr class="">
                                    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='uLocation']" /></th>
                                    <td class="propertyValue"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureUPosition']"/></td>    
                                </tr>
                                <tr class="altRowColor">
                                    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='rackProductDescription']" /></th>
                                    <td class="propertyValue"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackProductDesc']"/></td>
                                </tr>    
                                <tr class="">
                                    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='rackPartNumber']" /></th>
                                    <td class="propertyValue"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackProductPartNumber']"/></td>
                                </tr>    
                                <tr class="altRowColor">
                                    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='rackSerialNumber']" /></th>
                                    <td class="propertyValue"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackIdentifier']"/></td>
                                </tr>    
                                <tr class="">
                                    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='rackUHeight']" /></th>
                                    <td class="propertyValue"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackUHeight']"/></td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise>
                                 <tr class="">
                                    <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='locationInfo']" /></th>
                                    <td class="propertyValue">
                                        <xsl:value-of select="$stringsDoc//value[@key='dataError']" />&#160;
                                        <a href="javascript:top.mainPage.getHiddenFrame().selectDevice(0, 'enc', {$encNum}, true);">
                                            <xsl:call-template name="statusIcon" >
                                                <xsl:with-param name="statusCode" select="string('Informational')" />
                                            </xsl:call-template>
                                        </a>                                       
                                    </td>    
                                 </tr>
                            </xsl:otherwise>    
                        </xsl:choose>
                    </tbody>
                </table>
                </xsl:if>
                
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:value-of select="$stringsDoc//value[@key='settings']" /><br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div class="groupingBox">

			<div id="errorDisplay" class="errorDisplay"></div>
			
			<form id="enclosureSettingsForm">

				<em>
					<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
				</em>
				<br />
				<span class="whiteSpacer">&#160;</span>
				<br />
				
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ID="Table6">
					<TR>
						<TD>
							<span id="enclosureNameLabel">
								<xsl:value-of select="$stringsDoc//value[@key='enclosureName:']" />*
							</span>
						</TD>
						<TD width="10">&#160;</TD>
						<TD>
							<xsl:element name="input">
								<xsl:attribute name="class">stdInput</xsl:attribute>
								<xsl:attribute name="type">text</xsl:attribute>
								<xsl:attribute name="name">enclosureName</xsl:attribute>
								<xsl:attribute name="id">enclosureName</xsl:attribute>
								<xsl:if test="$serviceUserAcl=$USER or not($serviceUserOaAccess)">
									<xsl:attribute name="readonly">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">
									<xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:enclosureName" />
								</xsl:attribute>
								<xsl:attribute name="maxlength">32</xsl:attribute>
                                                                <xsl:attribute name="size">35</xsl:attribute>
								<!-- validation -->
								<xsl:attribute name="validate-me">true</xsl:attribute>
								<xsl:attribute name="rule-list">6;8</xsl:attribute>
								<xsl:attribute name="range">1;32</xsl:attribute>
								<xsl:attribute name="caption-label">enclosureNameLabel</xsl:attribute>
							</xsl:element>
						</TD>
					</TR>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<TR>
						<TD>
							<span id="rackNameLabel">
								<xsl:value-of select="$stringsDoc//value[@key='rackName:']" />*
							</span>
						</TD>
						<TD width="10">&#160;</TD>
						<TD>
							<xsl:element name="input">
								<xsl:attribute name="class">stdInput</xsl:attribute>
								<xsl:attribute name="type">text</xsl:attribute>
								<xsl:attribute name="name">rackName</xsl:attribute>
								<xsl:attribute name="id">rackName</xsl:attribute>
								<xsl:if test="$serviceUserAcl=$USER or not($serviceUserOaAccess)">
									<xsl:attribute name="readonly">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">
									<xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:rackName" />
								</xsl:attribute>
								<xsl:attribute name="maxlength">32</xsl:attribute>
                                                                <xsl:attribute name="size">35</xsl:attribute>
								<!-- validation -->
								<xsl:attribute name="validate-me">true</xsl:attribute>
								<xsl:attribute name="rule-list">6;8</xsl:attribute>
								<xsl:attribute name="range">1;32</xsl:attribute>
								<xsl:attribute name="caption-label">rackNameLabel</xsl:attribute>
							</xsl:element>
						</TD>
					</TR>
					<tr>
						<td colspan="3" class="formSpacer">&#160;</td>
					</tr>
					<TR>
						<TD>
							<span id="assetTagLabel">
								<xsl:value-of select="$stringsDoc//value[@key='assetTag:']" />
							</span>
						</TD>
						<TD width="10">&#160;</TD>
						<TD>
							<xsl:element name="input">
								<xsl:attribute name="class">stdInput</xsl:attribute>
								<xsl:attribute name="type">text</xsl:attribute>
								<xsl:attribute name="name">assetTag</xsl:attribute>
								<xsl:attribute name="id">assetTag</xsl:attribute>
								<xsl:if test="$serviceUserAcl=$USER or not($serviceUserOaAccess)">
									<xsl:attribute name="readonly">true</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">
									<xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:assetTag" />
								</xsl:attribute>
								<xsl:attribute name="maxlength">32</xsl:attribute>
                                                                <xsl:attribute name="size">35</xsl:attribute>
								<!-- validation: optional;string;no spaces;0-31 characters -->
								<xsl:attribute name="validate-me">true</xsl:attribute>
								<xsl:attribute name="rule-list">0;6;8</xsl:attribute>
								<xsl:attribute name="range">0;31</xsl:attribute>
								<xsl:attribute name="caption-label">assetTagLabel</xsl:attribute>
							</xsl:element>
						</TD>
					</TR>
				</TABLE>
			</form>
		</div>

		<xsl:if test="$serviceUserAcl != $USER and $serviceUserOaAccess='true'">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnApply" onclick="setupEnclosureInfo();">
									<xsl:value-of select="$stringsDoc//value[@key='apply']" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>

		<b><xsl:value-of select="$stringsDoc//value[@key='encLinkConnetions']" /></b><br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:value-of select="$stringsDoc//value[@key='encLinkConnetionsDesc']" />
		<br />

		<span class="whiteSpacer">&#160;</span>
		<br />

		<xsl:choose>

			<xsl:when test="$enclosureType=1">
				<img src="/120814-042457/images/elink_c3000.gif" width="270" height="71" title="{$stringsDoc//value[@key='c3000Connections']}" style="border: 1px solid #000000;" />
				<br />

				<span class="whiteSpacer">&#160;</span>
				<br />
				
				<xsl:value-of select="$stringsDoc//value[@key='encLinkInst']" /><br />

				<ul>
					<li><xsl:value-of select="$stringsDoc//value[@key='encLinkDownLinkPortDesc']" /></li>
					<li><xsl:value-of select="$stringsDoc//value[@key='encLinkUpLinkPortDesc']" /></li>
					<li><xsl:value-of select="$stringsDoc//value[@key='encOAiLOPort1Desc']" /></li>
					<li><xsl:value-of select="$stringsDoc//value[@key='encOAiLOPort2Desc']" /></li>
					<li><xsl:value-of select="$stringsDoc//value[@key='encUIDLightDesc']" /></li>
				</ul>
				
			</xsl:when>
			<xsl:otherwise>
				<img src="/120814-042457/images/elink_c7000.gif" width="164" height="71" title="{$stringsDoc//value[@key='c7000Connections']}" style="border: 1px solid #000000;" />
				<br />

				<span class="whiteSpacer">&#160;</span>
				<br />

				<xsl:value-of select="$stringsDoc//value[@key='encLinkInst']" /><br />

				<ul>
					<li><xsl:value-of select="$stringsDoc//value[@key='encUIDLightDesc']" /></li>
					<li><xsl:value-of select="$stringsDoc//value[@key='encLinkDownLinkPortDesc']" /></li>
					<li><xsl:value-of select="$stringsDoc//value[@key='encLinkUpLinkPortDesc']" /></li>
				</ul>
				
			</xsl:otherwise>
			
		</xsl:choose>
    
    <span class="whiteSpacer">&#160;</span><br />
    <span class="whiteSpacer">&#160;</span><br />    
    <a id="link" href="javascript:load_show_all();"><xsl:value-of select="$stringsDoc//value[@key='showAll']"/></a>
    <xsl:value-of select="$stringsDoc//value[@key='configurationScriptsView2']"/><br />
		
	</xsl:template>
	
</xsl:stylesheet>