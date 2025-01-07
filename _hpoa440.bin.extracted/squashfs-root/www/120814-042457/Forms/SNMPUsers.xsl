<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2012 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../Templates/guiConstants.xsl" />

  <xsl:param name="stringsDoc" />
  <xsl:param name="networkInfoDoc" />
  <xsl:param name="snmpInfoDoc" />
  <xsl:param name="snmpInfo3Doc" select="''"/>
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="testSupported" />
  <xsl:param name="snmpv3Supported" />

  <xsl:include href="../Forms/SnmpUsersTable.xsl"/>
  
  <xsl:template match="*">
    <b>
      <xsl:value-of select="$stringsDoc//value[@key='snmpUsers']" />
    </b>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />

    <div id="snmpUserTableContainer">
      <xsl:call-template name="snmpUserOverview" />
    </div>

  </xsl:template>


</xsl:stylesheet>

