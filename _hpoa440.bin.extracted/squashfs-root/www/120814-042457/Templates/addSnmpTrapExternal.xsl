<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:param name="stringsDoc" select="''" />
  <xsl:param name="snmpInfo3Doc" select="''" />
  <xsl:param name="snmpv3Supported" select="'false'" />
  <xsl:param name="isWizard" select="'false'" />
  <xsl:param name="networkInfoDoc" select="''" />
  
  <xsl:include href="../Forms/addSnmpTrap.xsl" />
  
  <xsl:template match="*">

      <xsl:call-template name="addSnmpTrap" />

  </xsl:template>

</xsl:stylesheet>
