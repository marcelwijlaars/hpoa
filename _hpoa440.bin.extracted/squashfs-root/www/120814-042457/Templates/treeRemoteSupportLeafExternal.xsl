<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <xsl:output method="html" />
	<!--
		(C) Copyright 2013 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
  <xsl:param name="ersConfigInfoDoc" />
  <xsl:param name="encNum" />
  <xsl:param name="bayNum" />
  <xsl:param name="activeFwVersion" />
	
	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Templates/globalTemplates.xsl"/>
	<xsl:include href="../Templates/treeRemoteSupportLeaf.xsl"/>	
	
	<xsl:template name="treeRemoteSupportLeafExternal" match="*">
    <xsl:call-template name="treeRemoteSupportLeaf">
      <xsl:with-param name="ersConfigInfoDoc" select="$ersConfigInfoDoc"  />
      <xsl:with-param name="bayNum" select="$bayNum"  />
      <xsl:with-param name="enclosureNumber" select="$encNum" />
      <xsl:with-param name="activeFwVersion" select="$activeFwVersion" />
    </xsl:call-template>		
	</xsl:template>

</xsl:stylesheet>