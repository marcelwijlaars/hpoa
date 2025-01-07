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
  <xsl:param name="snmpInfoDoc" />
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="snmpv3Supported" select="'false'"/>
  <xsl:param name="networkInfoDoc" />
  <xsl:param name="testSupported" />
  <xsl:param name="isWizard" select="'false'" />

  <xsl:include href="../Forms/SNMPSettings.xsl" />
  <xsl:include href="../Templates/guiConstants.xsl"/>

  <xsl:template match="*">

    <xsl:call-template name="SNMPTrapDestinations">
      <xsl:with-param name="isWizard" select="$isWizard" />
      <xsl:with-param name="showTest">
        <xsl:choose>
          <xsl:when test="$isWizard = 'true'">false</xsl:when>
          <xsl:otherwise>true</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
