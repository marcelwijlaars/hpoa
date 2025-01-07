<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="enclosureList" />
	<xsl:param name="stringsDoc" />

	<xsl:param name="enclosureInfoDoc" />
	<xsl:param name="dateTimeDoc" />
	<xsl:param name="networkInfoDoc" />

	<xsl:include href="../Forms/DateTime.xsl"/>
	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:variable name="serviceUserAcl" select="$ADMINISTRATOR" />

  <!-- Since we added NTP to the wizard we no longer need the isWizard parameter. -->
	<xsl:param name="isWizard" select="'false'" />

  <xsl:template name="Setup_EncSettings" match="*">

    <div id="stepInnerContent">
      
      <div class="wizardTextContainer">        
        <xsl:value-of select="$stringsDoc//value[@key='rackSettingsPara1']"/><br />
		    <span class="whiteSpacer">&#160;</span><br />		  
  		  
        <xsl:value-of select="$stringsDoc//value[@key='rackSettingsPara2']"/><br />		  
      </div>

      <span class="whiteSpacer">&#160;</span>
      <br />
      <span class="whiteSpacer">&#160;</span>
      <br />

      <div id="rackSettingsErrorDisplay" class="errorDisplay"></div>

		<em>
			<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
		</em>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
      <table border="0" cellpadding="0" cellspacing="0" style="margin-bottom:6px;">
        <tr>
          <td width="81">
            <span id="rackNameLabel"><xsl:value-of select="$stringsDoc//value[@key='rackName:']"/><xsl:value-of select="$stringsDoc//value[@key='asterisk']"/></span>
          </td>
			<td width="10">&#160;</td>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="class">stdInput</xsl:attribute>
              <xsl:attribute name="id">rackName</xsl:attribute>
              <!-- validation -->
              <xsl:attribute name="maxlength">32</xsl:attribute>
              <xsl:attribute name="validate-rackname">true</xsl:attribute>
              <xsl:attribute name="rule-list">6;8</xsl:attribute>
              <xsl:attribute name="caption-label">rackNameLabel</xsl:attribute>
              <xsl:attribute name="range">1;32</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:rackName"/>
              </xsl:attribute>
            </xsl:element>
          </td>
        </tr>
      </table>

      <span class="whiteSpacer">&#160;</span>
      <br />
      <hr />
      <span class="whiteSpacer">&#160;</span>
      <br />
      
      <xsl:value-of select="$stringsDoc//value[@key='dateAndTimeSettings:']" />&#160;
      <em><xsl:value-of select="$stringsDoc//value[@key='rackSettingsPara3']"/></em><br />
      
      <xsl:variable name="ntpEnabled">
        <xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpEnabled" />
      </xsl:variable>
      
      <span class="whiteSpacer">&#160;</span>
		  <br />
      <div id="dateTimeErrorDisplay" class="errorDisplay"></div>

      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td valign="top">

            <div class="groupingBox">

              <xsl:element name="input">

                <xsl:attribute name="type">radio</xsl:attribute>
                <xsl:attribute name="name">manualOrNtp</xsl:attribute>
                <xsl:attribute name="id">manualOrNtp_manual</xsl:attribute>
                <xsl:attribute name="class">stdRadioButton</xsl:attribute>
                <xsl:attribute name="value">manual</xsl:attribute>

                <xsl:attribute name="onclick">toggleFormEnabled('dateTimeFormContainer', this.checked);toggleFormEnabled('ntpFormContainer', !this.checked);</xsl:attribute>

                <xsl:if test="not($ntpEnabled='true')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>

              </xsl:element>
              <label for="manualOrNtp_manual"><xsl:value-of select="$stringsDoc//value[@key='setTimeManually']" /></label>
              <br />

              <blockquote>
                <div id="dateTimeFormContainer">
                  <xsl:call-template name="dateTimeForm">
                    <xsl:with-param name="labelCellWidth" select="81" />
                  </xsl:call-template>
                </div>
              </blockquote>

            </div>
            
          </td>

          <td>
            <img src="/120814-042457/images/one_white.gif" width="40" />
          </td>

          <td valign="top">
            <div class="groupingBox">

              <xsl:element name="input">

                <xsl:attribute name="type">radio</xsl:attribute>
                <xsl:attribute name="name">manualOrNtp</xsl:attribute>
                <xsl:attribute name="id">manualOrNtp_ntp</xsl:attribute>
                <xsl:attribute name="class">stdRadioButton</xsl:attribute>
                <xsl:attribute name="value">manual</xsl:attribute>

                <xsl:attribute name="onclick">toggleFormEnabled('ntpFormContainer', this.checked);toggleFormEnabled('dateTimeFormContainer', !this.checked);</xsl:attribute>

                <xsl:if test="$ntpEnabled='true'">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>

              </xsl:element>
              <label for="manualOrNtp_ntp"><xsl:value-of select="$stringsDoc//value[@key='setTimeNtp']" /></label>
              <br />

              <blockquote>
                <div id="ntpFormContainer">
                  <xsl:call-template name="NTPForm" />
                </div>
              </blockquote>
              
            </div>
          </td>
        </tr>
      </table>
    
      <span class="whiteSpacer">&#160;</span>
      <br />
      <hr />
      <span class="whiteSpacer">&#160;</span>
      <br />

      <div id="encSettingsErrorDisplay" class="errorDisplay"></div>

      <xsl:for-each select="$enclosureList//enclosure[selected='true']">

          <!-- Create a container for each of the selected enclosures. -->
		  <xsl:element name="div">
			<xsl:attribute name="id">
			  <xsl:value-of select="concat('enc', enclosureNum)"/>
			</xsl:attribute>&#160;<!-- do not remove space: IE bug -->
		  </xsl:element>

		  <!-- Put a spacer between the enclosure settings forms. -->
		  <xsl:if test="position() != last()">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />
		  </xsl:if>
      </xsl:for-each>
    </div>
    <div id="waitContainer" class="waitContainer"></div>

  </xsl:template>

</xsl:stylesheet>

