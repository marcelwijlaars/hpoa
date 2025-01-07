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
	
  <xsl:param name="stringsDoc" />
	<xsl:param name="statusCode" />
	<xsl:param name="showLabel" select="'false'" />
	<xsl:param name="templateName" />
	<xsl:param name="productId"/>
	<xsl:param name="fwVersion"/>
	<xsl:param name="iloModel"/>
	
	<xsl:template match="*">

		<xsl:choose>

			<xsl:when test="$templateName='statusIcon'">

				<xsl:call-template name="statusIcon">
					<xsl:with-param name="statusCode" select="$statusCode" />
				</xsl:call-template>
				
			</xsl:when>

			<xsl:when test="$templateName='getStatusLabel'">

				<xsl:call-template name="statusIcon">
					<xsl:with-param name="statusCode" select="$statusCode" />
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="$templateName='getIloFwVersionLabel'">
				<xsl:call-template name="getIloFwVersionLabel">
					<xsl:with-param name="productId" select="$productId"/>
					<xsl:with-param name="fwVersion" select="$fwVersion"/>
					<xsl:with-param name="iloModel" select="$iloModel"/>
				</xsl:call-template>
			</xsl:when>

		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>
