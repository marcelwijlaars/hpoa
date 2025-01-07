<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="*">
        <xsl:param name="indentCount">0</xsl:param>

        <xsl:if test="$indentCount != 0">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
      
        <xsl:call-template name="indentLoop">
            <xsl:with-param name="indentCount" select="$indentCount"/>
        </xsl:call-template>

        <xsl:copy>
            <xsl:copy-of select="@*"/>

            <xsl:apply-templates>
                <xsl:with-param name="indentCount" select="$indentCount + 1"/>
            </xsl:apply-templates>

            <xsl:if test="*">
                <xsl:text>&#xA;</xsl:text>

                <xsl:call-template name="indentLoop">
                    <xsl:with-param name="indentCount" select="$indentCount"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:copy>

        <xsl:if test="$indentCount=0">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>


    <xsl:template name="indentLoop">
        <xsl:param name="index" select="0"/>
        <xsl:param name="indentCount"/>

        <xsl:if test="$index &lt; $indentCount">
            <xsl:value-of select="'   '"/>
            <xsl:call-template name="indentLoop">
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="indentCount" select="$indentCount"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xsl:template match="text()">
        <xsl:value-of select="translate(., '&#xA;', '')"/>
    </xsl:template>

</xsl:stylesheet>
