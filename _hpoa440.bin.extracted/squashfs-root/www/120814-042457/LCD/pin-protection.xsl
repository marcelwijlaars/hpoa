<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/globalTemplates.xsl" />

  <xsl:template name="LcdPinTemplate">
  <xsl:param name="pinInfo"/>
  <xsl:param name="screenInfo"/>
  <xsl:param name="disableAll" />
  <xsl:param name="enclosureNetworkInfo" />

    <xsl:variable name="inputClass">
      <xsl:choose>
        <xsl:when test="$pinInfo//hpoa:lcdPinEnabled = 'true'">
          <xsl:value-of select="'stdInput'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'stdInputDisabled'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
   <xsl:element name="input">
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="id">chkButtonsLocked</xsl:attribute>
      <xsl:attribute name="class">chkLeftAlign</xsl:attribute>
      <xsl:if test="$screenInfo//hpoa:buttonLock = 'true'">
        <xsl:attribute name="checked">checked</xsl:attribute>
      </xsl:if>
      <xsl:if test="$disableAll = 'true'">
        <xsl:attribute name="disabled">true</xsl:attribute>
      </xsl:if>
    </xsl:element>
    <label for="chkButtonsLocked" style="padding-left:5px;">
      <xsl:value-of select="$stringsDoc//value[@key='lcdLockButtons']"/>
    </label>
    
    <div id="chkboxSpacer">&#160;</div>
    
    <xsl:element name="input">
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="id">chkEnablePinProtection</xsl:attribute>      
      <xsl:attribute name="class">chkLeftAlign</xsl:attribute>
      <xsl:attribute name="onclick">togglePinInputsEnabled(this.checked);</xsl:attribute>
      <xsl:if test="$pinInfo//hpoa:lcdPinEnabled = 'true'">
        <xsl:attribute name="checked">checked</xsl:attribute>
      </xsl:if>
	  <xsl:if test="$disableAll = 'true' or $enclosureNetworkInfo//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $enclosureNetworkInfo//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
        <xsl:attribute name="disabled">true</xsl:attribute>
      </xsl:if>
    </xsl:element>
	<label for="chkEnablePinProtection" style="padding-left:5px;">
      <xsl:value-of select="$stringsDoc//value[@key='enableLcdPinProtection']"/>
	  <xsl:call-template name="fipsHelpMsg">
		  <xsl:with-param name="fipsMode" select="$enclosureNetworkInfo//hpoa:extraData[@hpoa:name='FipsMode']" />
		  <xsl:with-param name="msgType">tooltip</xsl:with-param>
		  <xsl:with-param name="msgKey">fipsRequired</xsl:with-param>
	  </xsl:call-template>
    </label>
    <br />
    <br />
    <div id="LCDPinForm">
      <table cellpadding="0" cellspacing="0">
        <tr>
          <TD id="lblPin">
            <xsl:value-of select="$stringsDoc//value[@key='lcdPin:']"/>
          </TD>
          <TD width="5">&#160;</TD>
          <TD style="padding-bottom:3px;">
            <!-- validation: string length=6 w/no spaces -->
            <xsl:element name="input">
              <xsl:attribute name="autocomplete">off</xsl:attribute>
              <xsl:attribute name="type">password</xsl:attribute>
              <xsl:attribute name="maxlength">6</xsl:attribute>                          
              <xsl:attribute name="caption-label">lblPin</xsl:attribute>
              <xsl:attribute name="validate-me">true</xsl:attribute>
              <xsl:attribute name="rule-list">6;8</xsl:attribute>
              <xsl:attribute name="range">1;6</xsl:attribute>
              <xsl:attribute name="name">LCDPin</xsl:attribute>
              <xsl:attribute name="id">LCDPin</xsl:attribute>
              <xsl:if test="$pinInfo//hpoa:lcdPinEnabled = 'false' or $disableAll = 'true'">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if> 
              <xsl:attribute name="class"><xsl:value-of select="$inputClass"/></xsl:attribute>  
            </xsl:element>
          </TD>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <TD>
            <xsl:value-of select="$stringsDoc//value[@key='lcdPinConfirm:']"/>
          </TD>
          <TD width="5">&#160;</TD>
          <TD>
            <!-- validation: must match LCDPin-->
            <xsl:element name="input">
              <xsl:attribute name="autocomplete">off</xsl:attribute>
              <xsl:attribute name="type">password</xsl:attribute>
              <xsl:attribute name="maxlength">6</xsl:attribute>                           
              <xsl:attribute name="validate-me">true</xsl:attribute>
              <xsl:attribute name="rule-list">7</xsl:attribute>
              <xsl:attribute name="related-inputs">LCDPin</xsl:attribute>
              <xsl:attribute name="msg-key">InputLcdPinConfirm</xsl:attribute>
              <xsl:attribute name="name">LCDPinConfirm</xsl:attribute>
              <xsl:attribute name="id">LCDPinConfirm</xsl:attribute>
              <xsl:if test="$pinInfo//hpoa:lcdPinEnabled = 'false' or $disableAll = 'true'">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if> 
              <xsl:attribute name="class"><xsl:value-of select="$inputClass"/></xsl:attribute> 
            </xsl:element>            
          </TD>
        </tr>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>


