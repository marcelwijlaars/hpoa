<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="stringsDoc"/>
  
	<xsl:include href="../Templates/globalTemplates.xsl"/>
	<xsl:include href="../Templates/guiConstants.xsl"/>
	
	<xsl:param name="uidState" />

	<xsl:template match="*">
		
		<xsl:call-template name="getUIDLabel">
			<xsl:with-param name="statusCode" select="$uidState" />
		</xsl:call-template>
		
    </xsl:template>


</xsl:stylesheet>

