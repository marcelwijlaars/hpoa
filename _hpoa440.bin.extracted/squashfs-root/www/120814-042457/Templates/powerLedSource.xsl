<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:output method="text"/>	
	<xsl:param name="powerState" />
	
	<xsl:template match="*">
    
		<xsl:choose>
			<xsl:when test="$powerState='POWER_ON'">
        <xsl:value-of select="'/120814-042457/images/led.gif'"/>
			</xsl:when>
			<xsl:when test="$powerState='POWER_OFF'">
        <xsl:value-of select="'/120814-042457/images/led_amber.gif'"/>
			</xsl:when>
		</xsl:choose>    
		
	</xsl:template>
	
</xsl:stylesheet>
