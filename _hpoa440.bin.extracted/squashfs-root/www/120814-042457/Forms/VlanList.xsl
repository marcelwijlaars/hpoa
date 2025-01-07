<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="vlanInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="enclosureType" />

	<xsl:template name="vlanControl" match="*">

		<xsl:value-of select="$stringsDoc//value[@key='DefinedVlans']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='DefinedVlansDescription']"/></em>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div class="errorDisplay" id="errorDisplay"></div>

		<xsl:call-template name="vlanList" />

		<xsl:if test="$serviceUserAcl != 'USER'">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnDelete" onclick="removeVlans();">
									<xsl:value-of select="$stringsDoc//value[@key='delete']" />
								</button>
							</div>
						</div>
					</div>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnEdit" onclick="editVlan();">
									<xsl:value-of select="$stringsDoc//value[@key='edit']" />
								</button>
							</div>
						</div>
					</div>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnAdd" onclick="addVlan();">
									<xsl:value-of select="$stringsDoc//value[@key='add']" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		
	</xsl:template>

	<xsl:template name="vlanList">
		
		<xsl:variable name="numDeviceBays">
			<xsl:choose>
				<xsl:when test="$enclosureType=0">16</xsl:when>
				<xsl:when test="$enclosureType=1">8</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="numIoBays">
			<xsl:choose>
				<xsl:when test="$enclosureType=0">8</xsl:when>
				<xsl:when test="$enclosureType=1">4</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" id="vlanListTable">
			<thead>
				<tr class="captionRow">
					<xsl:if test="$serviceUserAcl != 'USER'">
						<th style="width:1px;"></th>
					</xsl:if>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='vlanId']"/>
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='vlanName']"/>
					</th>
					<th>
						<xsl:value-of select="$stringsDoc//value[@key='vlanMembers']"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg">
					<xsl:variable name="vlanId" select="hpoa:vlanId" />
					<xsl:variable name="altRowColor">
						<xsl:choose>
							<xsl:when test="position() mod 2 = 0">altRowColor</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr class="{$altRowColor}">
						<xsl:if test="$serviceUserAcl != 'USER'">
							<td style="width:1px;">
								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="vlanId">
										<xsl:value-of select="$vlanId"/>
									</xsl:attribute>
								</xsl:element>
							</td>
						</xsl:if>
						<td>
							<xsl:value-of select="$vlanId"/>
						</td>
						<td>
							<xsl:value-of select="hpoa:vlanName"/>
						</td>
						<td>

							<xsl:choose>
								<xsl:when test="count(../../hpoa:portArray/hpoa:port[hpoa:portVlanId=$vlanId]) &gt; 0">

									<xsl:if test="count(../../hpoa:portArray/hpoa:port[@hpoa:deviceType='SERVER' and hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numDeviceBays]) &gt; 0">
										<xsl:value-of select="$stringsDoc//value[@key='serverBays']"/>:
										<xsl:for-each select="../../hpoa:portArray/hpoa:port[@hpoa:deviceType='SERVER' and hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numDeviceBays]">
											<xsl:value-of select="@hpoa:bayNumber"/>
											<xsl:if test="position() != last()">,&#160;</xsl:if>
										</xsl:for-each>
										<br />
									</xsl:if>

									<xsl:if test="count(../../hpoa:portArray/hpoa:port[@hpoa:deviceType='INTERCONNECT' and hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numIoBays]) &gt; 0">
										<xsl:value-of select="$stringsDoc//value[@key='interconnectBays']"/>:
										<xsl:for-each select="../../hpoa:portArray/hpoa:port[@hpoa:deviceType='INTERCONNECT' and hpoa:portVlanId=$vlanId and @hpoa:bayNumber &lt;= $numIoBays]">
											<xsl:value-of select="@hpoa:bayNumber"/>
											<xsl:if test="position() != last()">,&#160;</xsl:if>
										</xsl:for-each>
										<br />
									</xsl:if>

									<xsl:if test="count(../../hpoa:portArray/hpoa:port[@hpoa:deviceType='OA' and hpoa:portVlanId=$vlanId]) &gt; 0">
										<xsl:value-of select="$stringsDoc//value[@key='oaBays']"/>
									</xsl:if>

								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='none']"/>
								</xsl:otherwise>
							</xsl:choose>
							
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		
	</xsl:template>
	
</xsl:stylesheet>

 
