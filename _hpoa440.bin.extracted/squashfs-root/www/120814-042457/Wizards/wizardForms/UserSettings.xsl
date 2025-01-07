<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../../Forms/Users.xsl" />

  <xsl:template name="userSettings">
  
	<xsl:variable name="addMultiple" select="count($enclosureList//enclosure[selected='true']) &gt; 1 and $action='add'"/>

    <xsl:if test="$addMultiple">

			<input style="margin-top:0px;" type="checkbox" id="addToAllEnclosures" class="stdCheckBox" 
          onclick="var elem=document.getElementById('overwriteExisting');elem.disabled=!this.checked;if(!this.checked)elem.checked=false;" />
			<label for="addToAllEnclosures"><xsl:value-of select="$stringsDoc//value[@key='addThisUserToEnc']" /></label>
			<br />      
        <input style="margin: 10px 5px 0px 20px;" type="checkbox" id="overwriteExisting" class="stdCheckBox" disabled="disabled" />
		    <label for="overwriteExisting">
          <xsl:value-of select="$stringsDoc//value[@key='overwriteSettingsExistUsers']" /></label>
      <br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			
		</xsl:if>
		
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td>
          <xsl:value-of select="$stringsDoc//value[@key='userInformation']" /><br /><span class="whiteSpacer">&#160;</span><br />
				</td>
				<xsl:if test="$username!='Administrator'">
					<td></td>
					<td>
            <xsl:value-of select="$stringsDoc//value[@key='userPermissions']" /><xsl:if test="not($linkHasMixed = 'true')">: <em>
              <xsl:value-of select="$stringsDoc//value[@key='clickIndividualBayOrAllBay']" /></em><br /><span class="whiteSpacer">&#160;</span><br /></xsl:if>
					</td>
				</xsl:if>
			</tr>
			<tr>
				<td class="groupingBox" valign="top">
					
					<xsl:call-template name="userInformation">
						<xsl:with-param name="showTooltip" select="$addMultiple" />
					</xsl:call-template>
					
				</td>
				<xsl:if test="$username!='Administrator'">
					<td>
						<img src="/120814-042457/images/one_white.gif" width="10" />
					</td>

					<td class="groupingBox" style="padding-left:10px;" valign="top">

						<xsl:choose>
							<xsl:when test="$linkHasMixed = 'true'">

								<input type="hidden" id="linkHasMixed" />
                <xsl:value-of select="$stringsDoc//value[@key='userSettingsFormPara1']" /><br />

								<span class="whiteSpacer">&#160;</span>
								<br />

								<xsl:element name="input">
									<xsl:attribute name="onclick">oaToggle(<xsl:value-of select="$encNum" />,this.checked);</xsl:attribute>
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>
									<xsl:attribute name="name">userOaAccess</xsl:attribute>
									<xsl:attribute name="id">userOaAccess</xsl:attribute>
									<xsl:if test="hpoa:oaAccess='true'">
										<xsl:attribute name="checked">true</xsl:attribute>
									</xsl:if>
								</xsl:element>
								<label for="userOaAccess">
                  <xsl:value-of select="$stringsDoc//value[@key='oaBays']" /></label>
								<span class="whiteSpacer">&#160;</span>
								<br />
								<hr />

								<!-- All device bay select -->
								<xsl:element name="input">

									<xsl:attribute name="onclick">checkboxToggle(this, 'devid', 'bay', '<xsl:value-of select="concat('svbSelectEnc', $encNum)" />');</xsl:attribute>
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat($encNum,' Bay Select')" />
									</xsl:attribute>
									<xsl:attribute name="devid">bay</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>
								</xsl:element>

								<xsl:element name="label">
									<xsl:attribute name="for">
										<xsl:value-of select="concat($encNum,' Bay Select')" />
									</xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='allServerBays']" />
                </xsl:element><br />

								<span class="whiteSpacer">&#160;</span>
								<br />

								<!-- All interconnect bay select -->
								<xsl:element name="input">

									<xsl:attribute name="onclick">checkboxToggle(this, 'devid', 'interconnect', '<xsl:value-of select="concat('swmSelectEnc', $encNum)" />');</xsl:attribute>
									<xsl:attribute name="type">checkbox</xsl:attribute>
									<xsl:attribute name="id">
										<xsl:value-of select="concat($encNum,' IO Select')" />
									</xsl:attribute>
									<xsl:attribute name="devid">bay</xsl:attribute>
									<xsl:attribute name="class">stdCheckBox</xsl:attribute>
								</xsl:element>

								<xsl:element name="label">
									<xsl:attribute name="for">
										<xsl:value-of select="concat($encNum,' IO Select')" />
									</xsl:attribute>
                  <xsl:value-of select="$stringsDoc//value[@key='allInterconnectBays']" />
                </xsl:element>
								
							</xsl:when>
							<xsl:otherwise>
								
								<xsl:for-each select="$userInfoDoc//hpoa:bayPermissions">
									<xsl:call-template name="userPermissions" />
								</xsl:for-each>
								
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
				</xsl:if>
			</tr>
		</table>

	</xsl:template>
	

</xsl:stylesheet>

