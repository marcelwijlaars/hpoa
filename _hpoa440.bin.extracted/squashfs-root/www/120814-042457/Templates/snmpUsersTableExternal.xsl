<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:param name="stringsDoc" />
  <xsl:param name="snmpInfo3Doc" select="''"/>
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="isWizard" select="'false'"/>
  
  <xsl:include href="../Forms/SnmpUsersTable.xsl"/>
  <xsl:include href="../Templates/guiConstants.xsl"/>
	
  <xsl:template match="*">
    <xsl:call-template name="snmpUserOverview">
      <xsl:with-param name="isWizard" select="$isWizard" />
    </xsl:call-template>
  </xsl:template>
	
</xsl:stylesheet>
