<?xml version="1.0" encoding="UTF-8"?>
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
		
		<b><xsl:value-of select="$stringsDoc//value[@key='localUsers']" /></b>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<xsl:if test="count($usersDoc//hpoa:userInfo[hpoa:acl!=$ANONYMOUS])&gt;19">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div class="buttonSet" style="margin-bottom:3px;">
				<div class="bWrapperUp"><div><div><button class="hpButton" id="deleteSecObjButton1"><xsl:value-of select="$stringsDoc//value[@key='delete']" /></button></div></div></div>
				<div class="bWrapperUp"><div><div><button class="hpButton" id="editSecObjButton1"><xsl:value-of select="$stringsDoc//value[@key='edit']" /></button></div></div></div>
				<div class="bWrapperUp"><div><div><button class="hpButton" id="newSecObjButton1"><xsl:value-of select="$stringsDoc//value[@key='new']" /></button></div></div></div>
			</div>
			<div class="clearFloats"></div>
		</xsl:if>
		
		<div id="userOverviewTableContainer">
			<xsl:call-template name="userOverview" />
		</div>
		
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div class="buttonSet">
			<div class="bWrapperUp"><div><div><button class="hpButton" id="deleteSecObjButton"><xsl:value-of select="$stringsDoc//value[@key='delete']" /></button></div></div></div>
			<div class="bWrapperUp"><div><div><button class="hpButton" id="editSecObjButton"><xsl:value-of select="$stringsDoc//value[@key='edit']" /></button></div></div></div>
			<div class="bWrapperUp"><div><div><button class="hpButton" id="newSecObjButton"><xsl:value-of select="$stringsDoc//value[@key='new']" /></button></div></div></div>
		</div>
		<div class="clearFloats"></div>
		
	</xsl:template>
	
</xsl:stylesheet>

