<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />

  <xsl:param name="networkInfoDoc" />
  <xsl:param name="mpInfoDoc" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="xmlReplyUrl" select="''"/>
  <xsl:param name="templateName" select="''"/>
  
  <xsl:template match="*">
    
    <xsl:choose>
      <xsl:when test="$templateName='federatedBladeList'">
        <xsl:call-template name="federatedBladeList" />
      </xsl:when>
      <xsl:otherwise>  
        <xsl:value-of select="$stringsDoc//value[@key='protocolRestrictions:']" />&#160;<em>
        <xsl:value-of select="$stringsDoc//value[@key='prDescription']" />
        </em>
        <br />
        <span class="whiteSpacer">&#160;</span><br />

        <div id="protocolErrorDisplay" class="errorDisplay"></div>
        
        <div class="groupingBox">
        
          <xsl:call-template name="networkAccessProtocols" />
          
          <br />
        </div>

        <span class="whiteSpacer">&#160;</span><br />

        <xsl:if test="$serviceUserAcl != $USER">
          <div align="right">
            <div class='buttonSet' style="margin-bottom:0px;">
              <div class='bWrapperUp'>
                <div>
                  <div>
                    <button type='button' class='hpButton' id="btnSetProtocols" onclick="setNetworkProtocols();">
                      <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </xsl:if>
        

        
        
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name="networkAccessProtocols">

    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">httpAccess</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:httpsEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="httpAccess">
            <xsl:value-of select="$stringsDoc//value[@key='enableWebProtocol']" />
          </label>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">sshAccess</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:sshEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="sshAccess">
            <xsl:value-of select="$stringsDoc//value[@key='enableSSHProtocol']" />
          </label>
        </td>
      </tr>
		 <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">telnetAccess</xsl:attribute>
			<xsl:if test="$serviceUserAcl = $USER or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
                <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:telnetEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="telnetAccess">
            <xsl:value-of select="$stringsDoc//value[@key='enableTelnetProtocol']" />
			<xsl:call-template name="fipsHelpMsg">
				<xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']" />
				<xsl:with-param name="msgType">tooltip</xsl:with-param>
				<xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
			</xsl:call-template>
          </label>
        </td>
      </tr>
      <tr>
        <td colspan="3" class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td>
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="class">stdCheckBox</xsl:attribute>
            <xsl:attribute name="id">xmlReplyAccess</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:xmlReplyEnabled='true'">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>

          </xsl:element>
          <label for="xmlReplyAccess">
            <xsl:value-of select="$stringsDoc//value[@key='xmlReply']" />
		  </label>
		  <xsl:if test="$xmlReplyUrl != ''">
		  	<span class="whiteSpacer">&#160;</span>
	  		<span class="whiteSpacer">&#160;</span>
			  (<a href="javascript:load_xml();">
				  <xsl:value-of select="$stringsDoc//value[@key='view']" />
			  </a>)
		  </xsl:if>
        </td>
      </tr>
      <!-- display this section only if supported by the data -->
      <xsl:if test="count($networkInfoDoc//hpoa:extraData[@hpoa:name='iLOFederation']) &gt; 0">
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <td>
            <xsl:element name="input">
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:attribute name="class">stdCheckBox</xsl:attribute>
              <xsl:attribute name="id">iLOFederationEnable</xsl:attribute>
              <xsl:if test="$serviceUserAcl = $USER">
                <xsl:attribute name="disabled">true</xsl:attribute>
              </xsl:if>
              <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='iLOFederation']='true'">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>

            </xsl:element>
            <label for="iLOFederationEnable">
              <xsl:value-of select="$stringsDoc//value[@key='enableiLOFederation']" />
            </label>
            <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='iLOFederation']='true'">
              <div id="lblSupportedBladesList" style="display:block;padding:8px 5px 5px 35px;">
                <!-- add loading and results dynamically -->
              </div>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>

      <!-- display this section only if supported by the data -->
      <xsl:if test="count($networkInfoDoc//hpoa:extraData[@hpoa:name='FqdnEnable']) &gt; 0">
        <tr>
          <td colspan="3" class="formSpacer">&#160;</td>
        </tr>
        <tr>
          <td>
	    <xsl:element name="input">
	      <xsl:attribute name="type">checkbox</xsl:attribute>
	      <xsl:attribute name="class">stdCheckBox</xsl:attribute>
	      <xsl:attribute name="id">FqdnSwitch</xsl:attribute>
	      <xsl:if test="$serviceUserAcl = $USER">
		<xsl:attribute name="disabled">true</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FqdnEnable']='true'">
		<xsl:attribute name="checked">true</xsl:attribute>
	      </xsl:if>
	    </xsl:element>
	    <label for="FqdnSwitch">
	      <xsl:value-of select="$stringsDoc//value[@key='enableFqdn']" />
	    </label>
	      <xsl:call-template name="errorTooltip">
	        <xsl:with-param name="stringsFileKey" select="'enableFqdnGuidance'" />
              </xsl:call-template>
          </td>
        </tr>
      </xsl:if>


    </table>

  </xsl:template>
  
  <xsl:template name="federatedBladeList">
    <xsl:variable name="totalSupported" select="count($mpInfoDoc//hpoa:bladeMpInfo/hpoa:extraData[@hpoa:name='EnclosureBayIloFederationEnabled' and text() = 'true'])" />
    <i>
      <xsl:value-of select="$stringsDoc//value[@key='enclosureEnabledFederationBays:']"/>&#160;
      <xsl:choose>
        <xsl:when test="$totalSupported = 0">None</xsl:when>
        <xsl:otherwise>        
          <xsl:for-each select="$mpInfoDoc//hpoa:bladeMpInfo[hpoa:extraData[@hpoa:name='EnclosureBayIloFederationEnabled' and text() = 'true']]">
            <xsl:if test="position() &gt; 1">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:element name="a">
              <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
              <xsl:attribute name="onclick">jumpToiLOPage(<xsl:value-of select="hpoa:bayNumber" />);</xsl:attribute>
              <xsl:choose>
                <xsl:when test="hpoa:extraData[@hpoa:name='SymbolicBladeNumber'] != ''">
                  <xsl:value-of select="hpoa:extraData[@hpoa:name='SymbolicBladeNumber']" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="hpoa:bayNumber" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </i>
  </xsl:template>
  
</xsl:stylesheet>
