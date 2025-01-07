<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="hpSimInfoDoc" />
	<xsl:param name="stringsDoc" />
	
	<xsl:template match="*">
		
		<xsl:value-of select="$stringsDoc//value[@key='hpSimTrustMode:']" /><em>
		<xsl:value-of select="$stringsDoc//value[@key='hpSimTrustModeDesc']" /></em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div class="groupingBox">

			<div class="errorDisplay" id="trustModeErrorDisplay"></div>
			
			<table cellpadding="0" cellspacing="0" border="0">

				<tr>
					<td><xsl:value-of select="$stringsDoc//value[@key='trustMode:']" /></td>
					<td width="10">&#160;</td>
					<td>
						<select name="simTrustMode" id="simTrustMode">
							<xsl:element name="option">
								<xsl:attribute name="value">HPSIM_DISABLED</xsl:attribute>
								<xsl:if test="$hpSimInfoDoc//hpoa:hpSimInfo/hpoa:trustMode='HPSIM_DISABLED'" >
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$stringsDoc//value[@key='disabled']" />
							</xsl:element>
							<xsl:element name="option">
								<xsl:attribute name="value">TRUST_BY_CERTIFICATE</xsl:attribute>
								<xsl:if test="$hpSimInfoDoc//hpoa:hpSimInfo/hpoa:trustMode='TRUST_BY_CERTIFICATE'" >
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$stringsDoc//value[@key='trustByCert']" />
							</xsl:element>
							
						</select>
					</td>
				</tr>
				
			</table>
			
		</div>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' onclick="setTrustMode();">
								<xsl:value-of select="$stringsDoc//value[@key='apply']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!--
		HP SIM Trusted Server Names: <em>The list below displays the HP SIM Servers that this Onboard Administrator
		trusts.  When the trust mode above is set to "Trust by Name" then any user from the servers in this list can
		start a new session to the Onboard Administrator using Single Sign-on from HP SIM.</em><br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div class="errorDisplay" id="xeNameErrorDisplay"></div>
		
		<table cellpadding="0" cellspacing="0" border="0" class="dataTable" id="xeNameList">

			<thead>
				<tr class="captionRow">
					
					<th style="vertical-align:middle;">
						Server Name
					</th>
					<th>&#160;</th>
				</tr>

				<xsl:choose>
					<xsl:when test="count($hpSimInfoDoc//hpoa:hpSimInfo/hpoa:xeNameList/hpoa:xeName) &gt; 0">

						<xsl:for-each select="$hpSimInfoDoc//hpoa:hpSimInfo/hpoa:xeNameList/hpoa:xeName">

							<xsl:element name="tr">

								<xsl:if test="position() mod 2 = 0">
									<xsl:attribute name="class">altRowColor</xsl:attribute>
								</xsl:if>
								
								<td>
									<xsl:value-of select="current()"/>
								</td>
								<td width="1" style="text-align:right;">
									<xsl:element name="a">

										<xsl:attribute name="href">javascript:removeXeName('<xsl:value-of select="current()"/>');</xsl:attribute>
										Remove
									</xsl:element>
								</td>

							</xsl:element>

						</xsl:for-each>
						
					</xsl:when>
					<xsl:otherwise>

						<tr class="noDataRow">
							<td colspan="2">There are no trusted server names</td>
						</tr>
						
					</xsl:otherwise>
				</xsl:choose>
				
			</thead>
			
		</table>
		
		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		Add HP SIM Trusted Server Names: <em>Use the form below to add Trusted Server Names to
		the Onboard Administrator (5 maximum).</em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div class="groupingBox">

			<div class="errorDisplay" id="xeNameAddErrorDisplay"></div>

			<table cellpadding="0" cellspacing="0" border="0">

				<tr>
					<td>
						<input type="text" id="xeNameAdd" class="stdInput" />
					</td>
				</tr>
				
			</table>

		</div>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' onclick="addXeName();">
								Add
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		-->
	</xsl:template>

</xsl:stylesheet>
