<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <!--
		Generic tree node leaf template. Takes enclosure number, device number,
		and device label (device type) as parameters.
		
		This template depends on the globalTemplates.xsl file being
		included in the topmost template.
	-->
  
  <xsl:param name="oaStatusDoc" />
  <xsl:param name="lcdStatusDoc" />
  <xsl:param name="enclosureInfoDoc" />
  <xsl:param name="enclosureStatusDoc" />
  <xsl:param name="lcdInfoDoc" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="encNum" />
  <xsl:param name="encType" />
  <xsl:param name="isTower" />
  <xsl:param name="isLocal" />
  <xsl:param name="isTfaEnabled" />
  <xsl:param name="hasMultiple" />
	<xsl:param name="serviceUserAcl" />
	<xsl:param name="serviceUserOaAccess" />
  <xsl:param name="vcmInfoDoc" />
  <xsl:param name="activeOaNetworkInfo" />
  
  <xsl:include href="../Templates/guiConstants.xsl"/>
  <xsl:include href="../Templates/globalTemplates.xsl"/>

  <xsl:template match="*">

    <xsl:variable name="lcdHealthState">
      <xsl:value-of select="$lcdStatusDoc//hpoa:lcdSetupHealth"/>
    </xsl:variable>

    <xsl:variable name="activeOaBayNumber">
      <xsl:value-of select="$oaStatusDoc//hpoa:oaStatus[hpoa:oaRole='ACTIVE']/hpoa:bayNumber"/>
    </xsl:variable>

    <xsl:variable name="imageName">
      <xsl:value-of select="concat('imgLCD',$encNum)"/>
    </xsl:variable>

    <table border="0" cellspacing="0" cellpadding="0" class="pad1x10" style="width:100%; table-layout: fixed;">
        <col width="50%" />
        <col width="50%" />
      <tr>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$stringsDoc//value[@key='enclosureName:']" />
        </td>
        <td style="word-wrap:break-word" valign="top">
          <xsl:element name="a">
            <xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(1, 'enc', <xsl:value-of select="$encNum"/>, true);</xsl:attribute>
            <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:enclosureName"/>
          </xsl:element>
        </td>
      </tr>
      
      <xsl:if test="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState'] and $enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState']!='0' and $enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState']!='2'">
        <tr>
            <td style="word-wrap:break-word" valign="top">
                <xsl:value-of select="$stringsDoc//value[@key='uLocation']" />:
            </td>
            <td style="word-wrap:break-word" valign="top">
                 <xsl:choose>
                    <xsl:when test="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState']='1'">
                        <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureUPosition']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$stringsDoc//value[@key='dataError']" />&#160;
                        <a href="javascript:top.mainPage.getHiddenFrame().selectDevice(0, 'enc', {$encNum}, true);">
                        <xsl:call-template name="statusIcon" >
                            <xsl:with-param name="statusCode" select="string('Informational')" />
                        </xsl:call-template>
                        </a>
                       
                    </xsl:otherwise>    
                 </xsl:choose>   
            </td>
        </tr>    
      </xsl:if>
      <tr>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$stringsDoc//value[@key='serialNumber:']" />
        </td>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:serialNumber"/>
        </td>
      </tr>
		 <tr>
			 <td style="word-wrap:break-word" valign="top">
				 <xsl:value-of select="$stringsDoc//value[@key='uuid:']" />
			 </td>
			 <td style="word-wrap:break-word" valign="top">
				 <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:uuid"/>
			 </td>
		 </tr>
      <tr>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$stringsDoc//value[@key='partNumber:']" />
        </td>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:partNumber"/>
        </td>
      </tr>
      <tr>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$stringsDoc//value[@key='assetTag:']" />
        </td>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:assetTag"/>
        </td>
      </tr>
      <tr>
        <td style="word-wrap:break-word" valign="top">
          <xsl:value-of select="$stringsDoc//value[@key='uidState:']" />
        </td>
        <td style="word-wrap:break-word" valign="top">
          <span id="{concat('uidLabel',$encNum)}">
			  <xsl:choose>
				  <xsl:when test="$serviceUserOaAccess='true'">
					  <xsl:element name="a">
						  <xsl:attribute name="href">javascript:toggleEnclosureUid(<xsl:value-of select="$encNum"/>);</xsl:attribute>
						  <xsl:call-template name="getUIDLabel">
							<xsl:with-param name="statusCode" select="$enclosureStatusDoc//hpoa:enclosureStatus/hpoa:uid" />
						  </xsl:call-template>
					  </xsl:element>
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:call-template name="getUIDLabel">
						  <xsl:with-param name="statusCode" select="$enclosureStatusDoc//hpoa:enclosureStatus/hpoa:uid" />
					  </xsl:call-template>
				  </xsl:otherwise>
			  </xsl:choose>
          </span>
        </td>
      </tr>
    </table>

    <span class="whiteSpacer">&#160;</span>
    <br />
    
    <xsl:variable name="displayType">
      <xsl:choose>
        <xsl:when test="$lcdInfoDoc//hpoa:partNumber = '' or $lcdInfoDoc//hpoa:partNumber = '415839-001' "></xsl:when>
        <xsl:otherwise>_vert</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$serviceUserOaAccess='true'">
      <table cellpadding="0" cellspacing="0" border="0"  class="pad1x10">
        <tr>
          <td>
            <xsl:element name="a">
              <xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$activeOaBayNumber"/>, 'lcd', <xsl:value-of select="$encNum" />, true);</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$enclosureStatusDoc//hpoa:uid = 'UID_ON'">
                  <img id="{$imageName}" title="{concat($lcdInfoDoc//hpoa:lcdInfo/hpoa:manufacturer,' ',$lcdInfoDoc//hpoa:lcdInfo/hpoa:name)}"  src="{concat('/120814-042457/images/enclosure_lcd_uid',$displayType,'.gif')}" align="middle" border="0"/>
                </xsl:when>
                <xsl:when test="$lcdHealthState = 'LCD_SETUP_HEALTH_OK'">
                  <img id="{$imageName}" title="{concat($lcdInfoDoc//hpoa:lcdInfo/hpoa:manufacturer,' ',$lcdInfoDoc//hpoa:lcdInfo/hpoa:name)}"  src="{concat('/120814-042457/images/enclosure_lcd_normal',$displayType,'.gif')}" align="middle" border="0"/>
                </xsl:when>
                <xsl:when test="$lcdHealthState = 'LCD_SETUP_HEALTH_DEGRADED' or $lcdHealthState = 'LCD_SETUP_HEALTH_FAILED' or $lcdHealthState = 'LCD_SETUP_HEALTH_INFORMATIONAL'">
                  <img id="{$imageName}" title="{concat($lcdInfoDoc//hpoa:lcdInfo/hpoa:manufacturer,' ',$lcdInfoDoc//hpoa:lcdInfo/hpoa:name)}"  src="{concat('/120814-042457/images/enclosure_lcd_degraded',$displayType,'.gif')}" align="middle" border="0"/>
                </xsl:when>
                <xsl:otherwise>
                  <img id="{$imageName}" title="{concat($lcdInfoDoc//hpoa:lcdInfo/hpoa:manufacturer,' ',$lcdInfoDoc//hpoa:lcdInfo/hpoa:name)}"  src="{concat('/120814-042457/images/enclosure_lcd',$displayType,'.gif')}" align="middle" border="0"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </td>
          <td style="padding-left:10px;">
            <xsl:element name="a">
              <xsl:attribute name="href">javascript:top.mainPage.getHiddenFrame().selectDevice(<xsl:value-of select="$activeOaBayNumber"/>, 'lcd', <xsl:value-of select="$encNum" />, true);</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='lcdScreen']" />
            </xsl:element>
          </td>
        </tr>
      </table>
    </xsl:if>

    <xsl:if test="$hasMultiple='true'">
      <table cellpadding="0" cellspacing="0" border="0" class="pad1x10">
        <tr>
          <td>
            <xsl:call-template name="enclosureIcon">
              <xsl:with-param name="encType" select="$encType" />
              <xsl:with-param name="isTower" select="$isTower" />                  
              <xsl:with-param name="isLocal" select="$isLocal" />
              <xsl:with-param name="isAuthenticated" select="'true'" />
            </xsl:call-template>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="$isLocal='true'">
                <xsl:value-of select="$stringsDoc//value[@key='primaryConnection']" />
              </xsl:when>
              <xsl:otherwise>  
                <xsl:value-of select="$stringsDoc//value[@key='linkedLoggedIn']" />
              </xsl:otherwise>
            </xsl:choose>  
            <xsl:if test="$isTfaEnabled = 'true'">
              <img style="vertical-align:middle;margin-left:5px;" title="{$stringsDoc//value[@key='twoFactorSecurity']}" src="/120814-042457/images/card-reader.gif" />
            </xsl:if>
          </td>
        </tr>
      </table>     
    </xsl:if>   

	<!-- If the IPv4 address field is not empty -->
	<xsl:variable name="vcmHasIpv4Address">
		<xsl:choose>
			<xsl:when test="$vcmInfoDoc//hpoa:vcmUrl != 'empty' and $vcmInfoDoc//hpoa:vcmUrl != ''">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- If IPv6 is enabled and if there are non-empty IPv6 addresses to be displayed -->
	<xsl:variable name="vcmHasIpv6Address">
		<xsl:choose>
			<xsl:when test="$activeOaNetworkInfo//hpoa:oaNetworkInfo/hpoa:extraData[@hpoa:name='Ipv6Enabled']='true' and count($vcmInfoDoc//hpoa:extraData[@hpoa:name='IPv6URL']/text()) &gt; 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="vcmfqdn" select="$vcmInfoDoc//hpoa:extraData[@hpoa:name='VCMFQDNURL']" />
	<!-- If the FQDN address field is not empty -->
	<xsl:variable name="vcmHasFqdnAddress">
		<xsl:choose>
			<xsl:when test="string-length($vcmfqdn) &gt; 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

    <xsl:if test="$vcmHasIpv4Address='true' or $vcmHasIpv6Address='true' or $vcmHasFqdnAddress='true'">
      <span class="whiteSpacer">&#160;</span>
      <br />
      <table cellpadding="0" cellspacing="0" border="0"  class="pad1x10">
        <tr>
          <td>
            <xsl:element name="a">
			  <xsl:if test="$vcmHasFqdnAddress='true'">
				<xsl:attribute name="href">
					<xsl:value-of select="$vcmfqdn" />
				</xsl:attribute>
			  </xsl:if>
			  <xsl:if test="$vcmHasFqdnAddress='false' and $vcmHasIpv4Address='true'">
				<xsl:attribute name="href">
					<xsl:value-of select="$vcmInfoDoc//hpoa:vcmUrl" />
				</xsl:attribute>
			  </xsl:if>
              <xsl:attribute name="target">_blank</xsl:attribute>
              <xsl:value-of select="$stringsDoc//value[@key='vcManager']" />
            </xsl:element>

			<xsl:if test="$vcmHasIpv6Address='true' or $vcmHasFqdnAddress='true'">
              <xsl:call-template name="urlListTooltip">
				<xsl:with-param name="fqdn" select="$vcmfqdn" />
				<xsl:with-param name="defaultUrl" select="$vcmInfoDoc//hpoa:vcmUrl" />
				<xsl:with-param name="urlList" select="$vcmInfoDoc//hpoa:extraData[@hpoa:name='IPv6URL']" />
			  </xsl:call-template>
            </xsl:if>

          </td>
        </tr>
        <xsl:if test="$vcmInfoDoc//hpoa:isVcmMode='true'">
          <tr>
            <td>
              VC Domain Name:
              <xsl:value-of select="$vcmInfoDoc//hpoa:vcmDomainName" />
            </td>
          </tr>
          <!--
          <tr>
						<td>
							<xsl:element name="button">
							 <xsl:attribute name="class">hpButton</xsl:attribute>
							 <xsl:attribute name="onclick">resetVcmMode(<xsl:value-of select="$encNum"/>
							 <xsl:value-of select="$stringsDoc//value[@key='resetVcm']"/>
							</xsl:element>
						</td>
					</tr> 
          -->
        </xsl:if>
      </table>
      <br />
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
