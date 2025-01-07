<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:hpoa="hpoa.xsd">

    <!--
        (C) Copyright 2012 Hewlett-Packard Development Company, L.P.
    -->

    <xsl:template name="ebipav6Server">
        <xsl:param name="displaySettingsNote" select="'false'" />

        <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <td valign="top" width="100%">
                    <xsl:value-of select="$stringsDoc//value[@key='deviceList:']" />&#160;<em>
                    <xsl:value-of select="$stringsDoc//value[@key='ebipav6DeviceListDesc']" />&#160;
                    <xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
                    <xsl:value-of select="$stringsDoc//value[@key='ebipav6DeviceListNote']" />
                    </em><br />
                    <span class="whiteSpacer">&#160;</span>
                    <br />

                    <div id="ebipav6DeviceListContainer"></div>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="ebipav6Interconnect">
        <xsl:param name="displaySettingsNote" select="'false'"/>

        <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="89%" valign="top">
                    <xsl:value-of select="$stringsDoc//value[@key='interconnectList:']" />
                    <em>
                        &#160;
                        <xsl:value-of select="$stringsDoc//value[@key='ebipav6InterConnectListDesc']" />&#160;&#160;
                        <xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
                        <xsl:value-of select="$stringsDoc//value[@key='ebipav6InterConnectListNote']" />
                    </em>
                    <br />
                    <span class="whiteSpacer">&#160;</span>
                    <br />

                    <div id="ebipav6InterconnectListContainer"></div>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="ebipav6ServerWiz">
        <xsl:param name="displaySettingsNote" select="'false'" />

        <xsl:value-of select="$stringsDoc//value[@key='deviceList:']" />&#160;<em>
            <xsl:value-of select="$stringsDoc//value[@key='ebipav6DeviceListDesc']" />&#160;
            <xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
            <xsl:value-of select="$stringsDoc//value[@key='ebipav6DeviceListNote']" />
        </em><br />
        <span class="whiteSpacer">&#160;</span>
        <br />

        <div id="ebipav6DeviceListContainer"></div>
    </xsl:template>

</xsl:stylesheet>