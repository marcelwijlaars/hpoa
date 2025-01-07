<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="networkInfoDoc" />
	<xsl:param name="snmpInfoDoc" />
	<xsl:param name="enclosureList" />
	<xsl:param name="encNum" />
	<xsl:param name="serviceUserAcl" />
  <xsl:param name="snmpInfo3Doc" select="''"/>
  <xsl:param name="snmpv3Supported" select="false"/>
  <xsl:param name="serviceUsername" />
  <xsl:param name="testSupported" />
  
  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Forms/SNMPAlerts.xsl" />
  <xsl:include href="../Forms/SnmpUsersTable.xsl"/>
	
	<xsl:template match="*">

		<div id="stepInnerContent">
			<div class="wizardTextContainer">

        <xsl:value-of select="$stringsDoc//value[@key='snmpSettingsPara1']" /><br />

				<span class="whiteSpacer">&#160;</span>
				<br />

        <xsl:value-of select="$stringsDoc//value[@key='snmpSettingsPara2']" />
        <br />
				
			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<div id="snmpErrorDisplay" class="errorDisplay"></div>
			<span class="whiteSpacer">&#160;</span>
			<br />

			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="40%" valign="top">

						<xsl:for-each select="$enclosureList//enclosure">

							<!-- Create a container for each of the selected enclosures. -->
							<xsl:if test="selected='true'">
								<div id="{concat('enc', enclosureNum, 'snmpSettings')}"></div>

								<!-- Put a spacer between the enclosure settings forms. -->
								<xsl:if test="position() != last()">
									<span class="whiteSpacer">&#160;</span>
									<br />
									<span class="whiteSpacer">&#160;</span>
									<br />
								</xsl:if>

							</xsl:if>
							
						</xsl:for-each>

					</td>
					<td style="padding-left:10px;" valign="top">

						<xsl:value-of select="$stringsDoc//value[@key='alertDestinations']" />
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />

						
							<div id="trapsErrorDisplay" class="errorDisplay"></div>
              <div id="snmpTrapContainer" name="snmpTrapContainer">
                <xsl:call-template name="SNMPAlerts">
                  <xsl:with-param name="isWizard" select="'true'" />                  
                </xsl:call-template>
              </div>					
            <br />
            <span class="whiteSpacer">&#160;</span>
            <br />
            <xsl:value-of select="$stringsDoc//value[@key='snmpUsers']" />
            <br />
            <span class="whiteSpacer">&#160;</span>
            <br />

              <div id="usersErrorDisplay" class="errorDisplay"></div>
              <div id="snmpUserTableContainer">
                <xsl:call-template name="snmpUserOverview">
                  <xsl:with-param name="isWizard" select="'true'" />
                </xsl:call-template>
              </div>
          </td>
        </tr>
			</table>
		</div>
		<div id="waitContainer" class="waitContainer"></div>
		
	</xsl:template>
	
</xsl:stylesheet>

