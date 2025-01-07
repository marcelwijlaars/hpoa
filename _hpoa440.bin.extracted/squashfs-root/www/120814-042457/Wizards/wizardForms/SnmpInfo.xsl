<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
    -->
	
	<xsl:include href="../../Templates/guiConstants.xsl" />
	<xsl:include href="../../Templates/globalTemplates.xsl" />

	<xsl:param name="networkInfoDoc" />
	<xsl:param name="snmpInfoDoc" />
  <xsl:param name="snmpInfo3Doc" select="''"/>
  <xsl:param name="snmpv3Supported" select="false"/>
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="stringsDoc" />
    <xsl:param name="encNum" />
	
	<xsl:template name="snmpInfo" match="*">
    <xsl:variable name="fipsEnabled" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-DEBUG'" />
    <b>
		<xsl:value-of select="concat($stringsDoc//value[@key='enclosure:'],' ', $snmpInfoDoc//hpoa:snmpInfo/hpoa:sysName)"/>
    </b>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<div class="groupingBox">
     
			<xsl:element name="input">
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="class">stdCheckBox</xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="concat('SNMPEnabled:', $encNum)"/></xsl:attribute>
        <xsl:if test="$serviceUserAcl = $USER or ($fipsEnabled and $snmpv3Supported !='true')">
          <xsl:attribute name="disabled">true</xsl:attribute>
         </xsl:if>

				<xsl:attribute name="onclick">toggleFormEnabled('<xsl:value-of select="concat('enc', $encNum, 'SnmpForm')"/>', this.checked);</xsl:attribute>
				
				<xsl:if test="$networkInfoDoc//hpoa:snmpEnabled='true'">
					<xsl:attribute name="checked">true</xsl:attribute>
				</xsl:if>
            </xsl:element>

			<xsl:element name="label">
				<xsl:attribute name="for"><xsl:value-of select="concat('SNMPEnabled:', $encNum)"/></xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='enableSNMP']" />
        <xsl:if test="$fipsEnabled and $snmpv3Supported !='true'">
          <xsl:call-template name="fipsHelpMsg">
            <xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']"/>
            <xsl:with-param name="msgType">tooltip</xsl:with-param>
            <xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:element>
            
            <br />
			<span class="whiteSpacer">&#160;</span>
			<br />
			<xsl:element name="div">

				<xsl:attribute name="id">
					<xsl:value-of select="concat('enc', $encNum, 'SnmpForm')"/>
				</xsl:attribute>
				
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td style="white-space:nowrap;">
						<xsl:value-of select="$stringsDoc//value[@key='systemLocation:']" />
					</td>
					<td width="10">&#160;</td>
					<td>
						<xsl:element name="input">

							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of select="concat('systemLocation:', $encNum)"/></xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:sysLocation" />
							</xsl:attribute>
							<xsl:attribute name="maxlength">20</xsl:attribute>
						</xsl:element>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
          <td style="white-space:nowrap;">
            <xsl:value-of select="$stringsDoc//value[@key='systemContact:']" />
          </td>
          <td width="10">&#160;</td>
          <td>
            <xsl:element name="input">

				<xsl:choose>
					<xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
						<xsl:attribute name="class">stdInput</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
						<xsl:attribute name="disabled">true</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('systemContact:', $encNum)"/>
              </xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:sysContact" />
              </xsl:attribute>
				<xsl:attribute name="maxlength">20</xsl:attribute>
            </xsl:element>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="formSpacer"><br /><br /></td>
        </tr>
        <tr>
          <td style="white-space:nowrap;">
						<xsl:value-of select="$stringsDoc//value[@key='readCommunity:']" />
					</td>
					<td width="10">&#160;</td>
					<td style="white-space:nowrap;">
						<xsl:element name="input">
							<xsl:choose>
                <xsl:when test="$fipsEnabled">
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                  <xsl:attribute name="perm-disable">true</xsl:attribute>
                </xsl:when>
                <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of select="concat('readCommunity:', $encNum)"/></xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:roCommunity" />
							</xsl:attribute>
							<xsl:attribute name="maxlength">20</xsl:attribute>
						</xsl:element>
            <xsl:if test="$fipsEnabled">              
              <xsl:call-template name="fipsHelpMsg">
                <xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']"/>
                <xsl:with-param name="msgType">tooltip</xsl:with-param>
                <xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </td>
				</tr>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<tr>
          <td style="white-space:nowrap;">
						<xsl:value-of select="$stringsDoc//value[@key='writeCommunity:']" />
					</td>
					<td width="10">&#160;</td>
					<td style="white-space:nowrap;">
						<xsl:element name="input">

							<xsl:choose>
                <xsl:when test="$fipsEnabled">
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
                  <xsl:attribute name="perm-disable">true</xsl:attribute>
                </xsl:when>
                <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
									<xsl:attribute name="class">stdInput</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
									<xsl:attribute name="disabled">true</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of select="concat('writeCommunity:', $encNum)"/></xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:rwCommunity" />
							</xsl:attribute>
							<xsl:attribute name="maxlength">20</xsl:attribute>
						</xsl:element>
            <xsl:if test="$fipsEnabled">
              <xsl:call-template name="fipsHelpMsg">
                <xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']"/>
                <xsl:with-param name="msgType">tooltip</xsl:with-param>
                <xsl:with-param name="msgKey">fipsUnavailable</xsl:with-param>
              </xsl:call-template>
            </xsl:if>

          </td>
				</tr>
        <tr>
          <td colspan="3" class="formSpacer"><br /><br /></td>
        </tr>
          <tr>
            <td style="white-space:nowrap;">
              <xsl:value-of select="$stringsDoc//value[@key='engineIdString:']" />
            </td>
            <td width="10">&#160;</td>
            <td style="white-space:nowrap;">
              <xsl:element name="input">                
                <xsl:choose>
                  <xsl:when test="$networkInfoDoc//hpoa:snmpEnabled='true'">
                    <xsl:attribute name="class">stdInput</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                    <xsl:attribute name="disabled">true</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('engineIdString:', $encNum)"/>
                </xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:engineIdString" />
                </xsl:attribute>
                <xsl:attribute name="maxlength">27</xsl:attribute>
              </xsl:element>
              <xsl:call-template name="simpleTooltip">
                <xsl:with-param name="msg" select="$stringsDoc//value[@key='snmpv3EngineIdChange']" />
              </xsl:call-template>    
            </td>
          </tr>
        </table>

      </xsl:element>
		</div>
	</xsl:template>
	
</xsl:stylesheet>

