<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="errorsDoc" />

	<xsl:template match="*">
                <xsl:for-each select="$errorsDoc//hpoa:bladeErrorInfo/hpoa:fwmgmtErrorArray">
                   	<xsl:variable name="bayNumber" select="hpoa:symbolicBladeNumber" />
                        <xsl:choose>
                            <xsl:when test="hpoa:fwmgmtError='INPROGRESS_ERR'">
                                <xsl:value-of select="concat($stringsDoc//value[@key='ERR_FWMGMT_INPROGRESS'], ' (', $stringsDoc//value[@key='bay'], ' ', $bayNumber, ')')"/>
                                <br/>
                            </xsl:when>
                            <xsl:when test="hpoa:fwmgmtError='NOTPRESENT_ERR'">
                                <xsl:value-of select="concat($stringsDoc//value[@key='ERR_FWMGMT_NOTPRESENT'], ' (', $stringsDoc//value[@key='bay'], ' ', $bayNumber, ')')"/>
                                <br/>
                            </xsl:when>
                            <xsl:when test="hpoa:fwmgmtError='UNSUPPORTED_ERR'">
                                <xsl:value-of select="concat($stringsDoc//value[@key='ERR_FWMGMT_UNSUPPORTED'], ' (', $stringsDoc//value[@key='bay'], ' ', $bayNumber, ')')"/>
                                <br/>
                            </xsl:when>
                            <xsl:when test="hpoa:fwmgmtError='POWERNOTOFF_ERR'">
                                <xsl:value-of select="concat($stringsDoc//value[@key='ERR_FWMGMT_POWERNOTOFF'], ' (', $stringsDoc//value[@key='bay'], ' ', $bayNumber, ')')"/>
                                <br/>
                            </xsl:when>
                            <xsl:when test="hpoa:fwmgmtError='SECUREBOOT_ERR'">
                                <xsl:value-of select="concat($stringsDoc//value[@key='544'], ' (', $stringsDoc//value[@key='bay'], ' ', $bayNumber, ')')"/>
                                <br/>
                            </xsl:when>
                        </xsl:choose>
		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>
