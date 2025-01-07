<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<!--
		Variables indicating the connection and authentication state
		of each of the enclosures on the link.
	-->
  
  <xsl:param name="stringsDoc" />
	<xsl:param name="enclosureList" />
  <xsl:param name="maxConnectionsExceeded"></xsl:param>
  <xsl:param name="allowFirmwareMismatch">false</xsl:param>
  <xsl:param name="allowPrimaryExclusion">false</xsl:param>
  
  <xsl:include href="/120814-042457/Templates/guiConstants.xsl"/>
  <xsl:include href="/120814-042457/Templates/globalTemplates.xsl"/>
	
	<xsl:template match="*">
	
		<xsl:param name="isWizard" select="'true'" />
    
    <xsl:param name="localFirmwareVersion">
      <xsl:value-of select="$enclosureList//enclosure[local='true']/fwVersion" />
    </xsl:param>
    
    <xsl:param name="localTfaEnabled">
      <xsl:value-of select="$enclosureList//enclosure[local='true']/twoFactorEnabled" />
    </xsl:param>
		
		<table border="0" cellpadding="0" cellspacing="0" class="dataTable tableHasCheckboxes" id="enclosureSelectTable">
			<caption class="displayForAuralBrowsersOnly"><xsl:value-of select="$stringsDoc//value[@key='enclosureSelectionTable']"/></caption>
			<thead>
				<tr class="captionRow">
					<xsl:if test="$isWizard = 'true'">
						<th class="checkboxCell" width="15">
							<xsl:if test="count($enclosureList//enclosure) &gt; 1">
								<input type="checkbox" tableid="enclosureSelectTable" ID="encSelectAll" NAME="encSelectAll" />
							</xsl:if>
						</th>
					</xsl:if>
					<th nowrap="true">
						<label for="encSelectAll"><xsl:value-of select="$stringsDoc//value[@key='allEnclosures']"/></label>
					</th>
					<th nowrap="true"><xsl:value-of select="$stringsDoc//value[@key='connection']"/></th>
          <th><xsl:value-of select="$stringsDoc//value[@key='firmware']"/></th>
				</tr>
			</thead>
			<tbody>

				<xsl:for-each select="$enclosureList//enclosure">
          
          <xsl:variable name="disableMe">
            <xsl:choose>
              <xsl:when test="(local = 'true' and $allowPrimaryExclusion != 'true') or (fwVersion != $localFirmwareVersion and $allowFirmwareMismatch != 'true') or (hasPrivileges != 'true') or (twoFactorEnabled = 'true' and $localTfaEnabled != 'true')">true</xsl:when>
              <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

					<xsl:element name="tr">
						<xsl:attribute name="style">cursor:default;</xsl:attribute>
						<xsl:if test="local='true'">
							<xsl:attribute name="class">rowHighlight</xsl:attribute>
						</xsl:if>
						
						<!-- Checkbox table cell -->
						<xsl:if test="$isWizard = 'true'">
							<td style="padding-top:10px;" class="checkboxCell">
									
								<xsl:element name="input">
									<xsl:attribute name="type">checkbox</xsl:attribute>
                  
									<xsl:attribute name="id">
										<xsl:value-of select="enclosureName" />
									</xsl:attribute>
									<xsl:attribute name="encNum">
										<xsl:value-of select="enclosureNum" />
									</xsl:attribute>
									<xsl:attribute name="local">
										<xsl:value-of select="local" />
									</xsl:attribute>
									<xsl:attribute name="authenticated">
										<xsl:value-of select="authenticated" />
									</xsl:attribute>
									<xsl:attribute name="rowselector">yes</xsl:attribute>									

                  <xsl:if test="(local='true' and $allowPrimaryExclusion != 'true') or (selected='true' and $disableMe != 'true')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>										

									<xsl:if test="$disableMe = 'true'">
										<xsl:attribute name="disabled">true</xsl:attribute>
										<xsl:attribute name="allowRowSelect">false</xsl:attribute>
									</xsl:if>
									
								</xsl:element>
								
							</td>
						</xsl:if>

						<!--
				    	Call the enclosure info cells template to display
				    	the enclosure icon and the connection state.
				    -->
						<xsl:call-template name="enclosureInfoCells">
							
							<xsl:with-param name="linkState" select="local" />
							<xsl:with-param name="authState" select="authenticated" />
              <xsl:with-param name="hasPrivs" select="hasPrivileges" />
              <xsl:with-param name="tfaEnabled" select="twoFactorEnabled" />
							<xsl:with-param name="enclosureName" select="enclosureName" />
              <xsl:with-param name="localFirmwareVersion" select="$localFirmwareVersion" />
              <xsl:with-param name="fwVersion" select="fwVersion" />
							<xsl:with-param name="encNum" select="enclosureNum" />
              <xsl:with-param name="enclosureType" select="encType" />
              <xsl:with-param name="isTower" select="isTower" />
						</xsl:call-template>

					</xsl:element>

				</xsl:for-each>

			</tbody>
		</table>
    
    <xsl:if test="count($enclosureList//enclosure[hasPrivileges='false']) &gt; 0">
		  <span class="whiteSpacer">&#160;</span><br />
      <xsl:value-of select="$stringsDoc//value[@key='insufficientPrivs']"/><br />
    </xsl:if>

    <xsl:if test="$maxConnectionsExceeded != ''">
      <span class="whiteSpacer">&#160;</span>
      <br />
      <div style="color:#cc0000;margin-left:10px;font-weight:bold;">
        <xsl:call-template name="statusIcon">
          <xsl:with-param name="statusCode" select="$OP_STATUS_IN_SERVICE" />
        </xsl:call-template>&#160;
        <label style="vertical-align:top;">
          <xsl:value-of select="$stringsDoc//value[@key='maxEnclosuresExceeded1']"/>
          <xsl:value-of select="$maxConnectionsExceeded"/>
          <xsl:value-of select="$stringsDoc//value[@key='maxEnclosuresExceeded2']"/>
        </label>
      </div>
    </xsl:if>
    
    <span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button class='hpButton' style='padding-left:5px;padding-right:5px;' id='btnRefreshTopology' onclick="top.refreshTopology(fwVersionCallback);"><xsl:value-of select="$stringsDoc//value[@key='refreshTopology']"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	
	<!--
		Template used to display an icon for the enclosures on the link.
		The template takes a link state parameter indicating whether or not
		we are directly connected to the enclosure or not, and if not whether
		or not we have authenticated to linked enclosures.
	 -->
	<xsl:template name="enclosureInfoCells">
		
		<xsl:param name="linkState" />
		<xsl:param name="authState" />
    <xsl:param name="hasPrivs" />
    <xsl:param name="tfaEnabled" />
		<xsl:param name="enclosureName" />
    <xsl:param name="localFirmwareVersion" />
    <xsl:param name="fwVersion" />
		<xsl:param name="encNum" />
    <xsl:param name="enclosureType" />
    <xsl:param name="isTower" />

		<xsl:variable name="displayName">		
    	<xsl:choose>
				<xsl:when test="$enclosureName != ''">
					<xsl:value-of select="$enclosureName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
            <xsl:when test="$encNum">
              <xsl:value-of select="concat('Enclosure ', $encNum)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$stringsDoc//value[@key='unnamedEnclosure']"/>
            </xsl:otherwise>
          </xsl:choose> 
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

    <!-- Icon with label table cell -->
    <td style="padding:10px;" nowrap="true">

      <table cellpadding="0" cellspacing="0" border="0" style="border: 0px none;">
        <tr>
          <td style="border: 0px none;">
            <xsl:call-template name="enclosureIcon">
              <xsl:with-param name="encType" select="$enclosureType" />
              <xsl:with-param name="isTower" select="$isTower" />
              <xsl:with-param name="isLocal" select="$linkState" />
              <xsl:with-param name="isAuthenticated" select="$authState" />
             </xsl:call-template>
          </td>
          <td style="border: 0px none;vertical-align:middle" nowrap="true">
            <xsl:value-of select="$enclosureName" />
          </td>
        </tr>
      </table>
    </td>

    <!-- Security table cell -->
    <td style="padding:10px;vertical-align:middle;" nowrap="true">
      <xsl:choose>
        <xsl:when test="$linkState='true'">
          <xsl:value-of select="$stringsDoc//value[@key='primaryConnection']"/>
          <xsl:if test="$tfaEnabled = 'true'">
            <img style="vertical-align:middle;margin-left:12px;" title="{$stringsDoc//value[@key='twoFactorSecurity']}" src="/120814-042457/images/card-reader.gif" />
          </xsl:if>
        </xsl:when>
        <xsl:when test="$linkState='false' and $authState='false'">
          <xsl:value-of select="$stringsDoc//value[@key='linkedNotLoggedIn']"/>
          <xsl:if test="$tfaEnabled = 'true'">
            <img style="vertical-align:middle;margin-left:5px;" title="{$stringsDoc//value[@key='twoFactorSecurity']}" src="/120814-042457/images/card-reader.gif" />
          </xsl:if>
          <xsl:if test="(fwVersion = $localFirmwareVersion) or ($allowFirmwareMismatch = 'true')">
            <!-- only show the input if this enclosure has the right firmware version -->            
            <span class="whiteSpacer" >&#160;</span><br />
            <xsl:choose>
              <xsl:when test="$tfaEnabled = 'true'">                

              </xsl:when>
              <xsl:otherwise>
                <br />
                <span id="{concat('pwdLabel', $encNum)}"><xsl:value-of select="$stringsDoc//value[@key='password:']"/></span>&#160;
                <xsl:element name="input">
                  <xsl:attribute name="autocomplete">off</xsl:attribute>
                  <xsl:attribute name="type">password</xsl:attribute>
                  <xsl:attribute name="class">stdInput</xsl:attribute>                
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('enc', $encNum, 'password')"/>
                  </xsl:attribute>
                  <!-- validation: string, 3 to 40 characters, only if option is selected -->
                  <xsl:attribute name="validate-me">true</xsl:attribute>
                  <xsl:attribute name="option-id"><xsl:value-of select="$enclosureName"/></xsl:attribute>
                  <xsl:attribute name="unique-id">(<xsl:value-of select="$enclosureName"/>)</xsl:attribute>
                  <xsl:attribute name="caption-label"><xsl:value-of select="concat('pwdLabel', $encNum)"/></xsl:attribute>
                  <xsl:attribute name="rule-list">1</xsl:attribute>
                  <xsl:attribute name="maxlength">40</xsl:attribute>
                </xsl:element>                
              </xsl:otherwise>
            </xsl:choose>           
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$hasPrivs = 'true'"><xsl:value-of select="$stringsDoc//value[@key='linkedLoggedIn']"/></xsl:when>
            <xsl:otherwise><font style="color:#CC0000;"><xsl:value-of select="$stringsDoc//value[@key='linkedLoggedIn']"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']"/></font></xsl:otherwise>              
          </xsl:choose>   
          <xsl:if test="$tfaEnabled = 'true'">
            <img style="vertical-align:middle;margin-left:10px;" title="{$stringsDoc//value[@key='twoFactorSecurity']}" src="/120814-042457/images/card-reader.gif" />
          </xsl:if>
          <br />
        </xsl:otherwise>
      </xsl:choose>
    </td>

    <!-- firmware version cell -->
    <xsl:element name="td">
      <xsl:attribute name="id"><xsl:value-of select ="concat('enc', $encNum, 'fw')"/></xsl:attribute>
      <xsl:attribute name="encNum"><xsl:value-of select="$encNum"/></xsl:attribute>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="(fwVersion = $localFirmwareVersion) or ($allowFirmwareMismatch = 'true')">
            padding:10px;vertical-align:middle;color:#000;
          </xsl:when>
          <xsl:otherwise>
            padding:10px;vertical-align:middle;color:#cc0000;
          </xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
      <xsl:attribute name="nowrap">true</xsl:attribute>
      <xsl:value-of select="$fwVersion"/>      
    </xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>

