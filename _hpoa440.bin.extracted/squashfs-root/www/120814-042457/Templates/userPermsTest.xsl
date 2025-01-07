<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/02/xpath-functions"	xmlns:hpoa="hpoa.xsd">
	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  
  <xsl:param name="userInfoNew" />
  <xsl:param name="userInfoOld" />
  
	<xsl:template match="*">

    <xsl:if test="$userInfoOld//hpoa:userInfo and $userInfoNew//hpoa:userInfo">
		  <xsl:if test="$userInfoOld//hpoa:acl != $userInfoNew//hpoa:acl">
        <xsl:value-of select="concat('ACL | old:', $userInfoOld//hpoa:acl, '  new:', $userInfoNew//hpoa:acl, '^')" />
      </xsl:if>
      <xsl:if test="$userInfoOld//hpoa:oaAccess != $userInfoNew//hpoa:oaAccess">
        <xsl:value-of select="concat('OaAccess | old:', $userInfoOld//hpoa:oaAccess, '  new:' , $userInfoNew//hpoa:oaAccess, '^')" />
      </xsl:if>
      <xsl:for-each select="$userInfoOld//hpoa:blade">
        <xsl:variable name="bay" select="hpoa:bayNumber" />
        <xsl:if test="$userInfoNew//hpoa:blade[hpoa:bayNumber=$bay]/hpoa:access != hpoa:access">
          <xsl:value-of select="concat('Bay', $bay, ' | old:',hpoa:access , '  new:', $userInfoNew//hpoa:blade[hpoa:bayNumber=$bay]/hpoa:access, '^')"  />
        </xsl:if>
      </xsl:for-each>
		  <xsl:for-each select="$userInfoOld//hpoa:interconnectTray">
        <xsl:variable name="tray" select="hpoa:bayNumber" />
        <xsl:if test="$userInfoNew//hpoa:interconnectTray[hpoa:bayNumber=$tray]/hpoa:access != hpoa:access">
          <xsl:value-of select="concat('Tray', $tray, ' | old:',hpoa:access , '  new:', $userInfoNew//hpoa:interconnectTray[hpoa:bayNumber=$tray]/hpoa:access, '^')"  />
        </xsl:if>
      </xsl:for-each>
    </xsl:if>		
	</xsl:template>
</xsl:stylesheet>

