<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="groupsDoc" />
	<xsl:include href="../Forms/GroupOverviewTable.xsl"/>

	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:param name="stringsDoc" />
	
	<xsl:template match="*">
		
		<b><xsl:value-of select="$stringsDoc//value[@key='directoryGroups']" /></b>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<xsl:if test="count($groupsDoc//hpoa:groupInfo)&gt;19">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div class="buttonSet" style="margin-bottom:3px;">
				<div class="bWrapperUp"><div><div><button class="hpButton" id="deleteSecObjButton1"><xsl:value-of select="$stringsDoc//value[@key='delete']" /></button></div></div></div>
				<div class="bWrapperUp"><div><div><button class="hpButton" id="editSecObjButton1"><xsl:value-of select="$stringsDoc//value[@key='edit']" /></button></div></div></div>
				<div class="bWrapperUp"><div><div><button class="hpButton" id="newSecObjButton1"><xsl:value-of select="$stringsDoc//value[@key='new']" /></button></div></div></div>
			</div>
			<div class="clearFloats"></div>
		</xsl:if>
		
		<div id="groupOverviewTableContainer">
			<xsl:call-template name="groupOverview" />
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

