<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Templates/globalTemplates.xsl"/>
    <xsl:include href="../Templates/firmwareMgmtCommon.xsl"/>

        <xsl:param name="stringsDoc" />
        <xsl:param name="iloVersion"/>
	<xsl:param name="isoVersion"/>
        <xsl:param name="templateName" />
        <xsl:template match="*">
            

		<xsl:choose>

			<xsl:when test="$templateName='iloVersionDifference'">

				<xsl:call-template name="iloVersionDifference">
					<xsl:with-param name="iloVersion" select="$iloVersion" />
                                        <xsl:with-param name="isoVersion" select="$isoVersion" />
				</xsl:call-template>
				
			</xsl:when>
			<xsl:when test="$templateName='checkMatch'">

				<xsl:call-template name="checkMatch">
					<xsl:with-param name="deviceFwStr" select="$iloVersion" />
                                        <xsl:with-param name="isoFwStr" select="$isoVersion" />
				</xsl:call-template>

			</xsl:when>
			<xsl:when test="$templateName='getIloVersion'">

				<xsl:call-template name="getIloVersion">
					<xsl:with-param name="iloVersion" select="$iloVersion" />
                                </xsl:call-template>

			</xsl:when>


                </xsl:choose>

	</xsl:template>

</xsl:stylesheet>

