<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="usersDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:include href="../Forms/UserOverviewTable.xsl"/>
	<xsl:include href="../Templates/guiConstants.xsl"/>
	
    <xsl:template match="*">

		<xsl:call-template name="userOverview" />
		
    </xsl:template>
	
</xsl:stylesheet>
