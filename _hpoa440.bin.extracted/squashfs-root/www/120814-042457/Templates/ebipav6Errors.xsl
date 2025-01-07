<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
    xmlns:hpoa="hpoa.xsd">

    <!--
        (C) Copyright 2012 Hewlett-Packard Development Company, L.P.
    -->

    <xsl:param name="stringsDoc" />
    <xsl:param name="errorsDoc" />

    <xsl:include href="../Templates/guiConstants.xsl" />
    <xsl:include href="../Templates/globalTemplates.xsl" />

    <xsl:template match="*">

        <xsl:for-each select="$errorsDoc//hpoa:deviceBays//hpoa:bay">
            <xsl:variable name="bayNumber" select="hpoa:bayNumber" />
            <xsl:if test="hpoa:ipAddress='true'">
                <xsl:value-of select="concat($stringsDoc//value[@key='EBIPAV6_DEVICE_IP'], ' ', $bayNumber)"/>
                <br />
            </xsl:if>
            <xsl:if test="hpoa:domain='true'">
                <xsl:value-of select="concat($stringsDoc//value[@key='EBIPAV6_DEVICE_DOMAIN'], ' ', $bayNumber)"/>
                <br />
            </xsl:if>
            <xsl:if test="hpoa:gateway='true'">
				      <xsl:value-of select="concat($stringsDoc//value[@key='EBIPA_DEVICE_GATEWAY'], ' ', $bayNumber)"/>
				      <br />
			      </xsl:if>       
            <xsl:if test="hpoa:dns1='true' or hpoa:dns2='true' or hpoa:dns3='true'">
                <xsl:value-of select="concat($stringsDoc//value[@key='EBIPAV6_DEVICE_DNS'], ' ', $bayNumber)"/>
                <br />
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="$errorsDoc//hpoa:interconnectBays//hpoa:bay">
            <xsl:variable name="bayNumber" select="hpoa:bayNumber" />
            <xsl:if test="hpoa:ipAddress='true'">
                <xsl:value-of select="concat($stringsDoc//value[@key='EBIPAV6_INTERCONNECT_IP'], ' ', $bayNumber)"/>
                <br />
            </xsl:if>
            <xsl:if test="hpoa:domain='true'">
                <xsl:value-of select="concat($stringsDoc//value[@key='EBIPAV6_INTERCONNECT_DOMAIN'], ' ', $bayNumber)"/>
                <br />
            </xsl:if>
            <xsl:if test="hpoa:gateway='true'">
				      <xsl:value-of select="concat($stringsDoc//value[@key='EBIPA_INTERCONNECT_GATEWAY'], ' ', $bayNumber)"/>
				      <br />
			      </xsl:if>
            <xsl:if test="hpoa:dns1='true' or hpoa:dns2='true' or hpoa:dns3='true'">
                <xsl:value-of select="concat($stringsDoc//value[@key='EBIPAV6_INTERCONNECT_DNS'], ' ', $bayNumber)"/>
                <br />
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>