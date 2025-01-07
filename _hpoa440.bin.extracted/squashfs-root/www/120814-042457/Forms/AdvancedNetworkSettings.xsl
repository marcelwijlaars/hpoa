<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="advancedNetworkSettings">
		
		<xsl:param name="enclosureName" />
		<xsl:param name="isWizard" />
		<xsl:param name="hasNTP" select="'false'" />
		
		<xsl:if test="$isWizard='true'">
			
			<xsl:element name="input">
			
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="onclick">toggleFormEnabled('<xsl:value-of select="concat('advancedNetSettings', $enclosureName)" />', this.checked);</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('inclusionRange ', $enclosureName)" /></xsl:attribute>
				<xsl:attribute name="style">margin-right:5px;</xsl:attribute>
				
			</xsl:element>
				
			<xsl:element name="label">
				<xsl:attribute name="for"><xsl:value-of select="concat('inclusionRange ', $enclosureName)" /></xsl:attribute>
				Include interconnect bays in server bay range
			</xsl:element><br />
			
			<span class="whiteSpacer">&#160;</span><br />
			
		</xsl:if>
		
		<xsl:element name="div">
			
			<xsl:attribute name="id"><xsl:value-of select="concat('advancedNetSettings', $enclosureName)" /></xsl:attribute>
			
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<TR>
					<TD>Domain Name:</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<input class="stdInput" type="text" name="domain" id="domain" />
            </TD>
          </TR>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <TR>
            <TD>Primary DNS Server:</TD>
            <TD width="10">&#160;</TD>
            <TD>
              <input class="stdInput" type="text" name="primaryDNS" id="primaryDNS" />
            </TD>
          </TR>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <TR>
            <TD>Secondary DNS Server:</TD>
            <TD width="10">&#160;</TD>
            <TD>
              <input class="stdInput" type="text" name="secondaryDNS" id="secondaryDNS" />
            </TD>
          </TR>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <TR>
            <TD>Tertiary DNS Server:</TD>
            <TD width="10">&#160;</TD>
            <TD>
              <input class="stdInput" type="text" name="tertiaryDNS" id="tertiaryDNS" />
            </TD>
          </TR>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <TR>
            <TD>Primary WINS Server:</TD>
            <TD width="10">&#160;</TD>
            <TD>
              <input class="stdInput" type="text" name="primaryWINS" id="primaryWINS" />
            </TD>
          </TR>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <TR>
            <TD>Secondary WINS Server:</TD>
            <TD width="10">&#160;</TD>
            <TD>
              <input class="stdInput" type="text" name="secondaryWINS" id="secondaryWINS" />
            </TD>
          </TR>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <TR>
            <TD>Static Route 1 (destination, gateway):</TD>
            <TD width="10">&#160;</TD>
            <TD>
              <input class="stdInput" type="text" name="staticRoute1" id="staticRoute1" />
            </TD>
          </TR>
          <tr>
            <td colspan="3" class="formSpacer">&#160;</td>
          </tr>
          <TR>
            <TD>Static Route 2 (destination, gateway):</TD>
            <TD width="10">&#160;</TD>
            <TD>
              <input class="stdInput" type="text" name="staticRoute2" id="staticRoute2" />
            </TD>
          </TR>

          <xsl:if test="$hasNTP='true'">

            <tr>
              <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
            <TR>
              <TD>NTP Server 1:</TD>
              <TD width="10">&#160;</TD>
              <TD>
                <input class="stdInput" type="text" name="ntp1" id="ntp1" />
              </TD>
            </TR>
            <tr>
              <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
            <TR>
              <TD>NTP Server 2:</TD>
              <TD width="10">&#160;</TD>
              <TD>
                <input class="stdInput" type="text" name="ntp2" id="ntp2" />
						</TD>
					</TR>
					
				</xsl:if>
					
			</TABLE>
		</xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>

