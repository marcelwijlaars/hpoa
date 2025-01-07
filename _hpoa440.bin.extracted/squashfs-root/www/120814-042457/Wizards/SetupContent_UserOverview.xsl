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
	<xsl:param name="enclosureInfoDoc" />
	
	<xsl:include href="../Forms/UserOverviewTable.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />
	
	<xsl:template name="SetupUserOverview" match="*">

		<div id="stepInnerContent">
			
			<div class="wizardTextContainer">

				<xsl:value-of select="$stringsDoc//value[@key='localAccountsPara1']"/><br />

				<span class="whiteSpacer">&#160;</span><br />

				<xsl:value-of select="$stringsDoc//value[@key='localAccountsPara2a']"/>&#160;
				<xsl:value-of select="$stringsDoc//value[@key='click']"/>&#160;
				<b><xsl:value-of select="$stringsDoc//value[@key='next']"/></b>&#160;
				<xsl:value-of select="$stringsDoc//value[@key='localAccountsPara2b']"/>
				
			</div>
			
			<span class="whiteSpacer">&#160;</span><br />
			<span class="whiteSpacer">&#160;</span><br />

			<div id="userErrorDisplay" class="errorDisplay"></div>
			<span class="whiteSpacer">&#160;</span>
			<br />
			
			<table border="0" cellpadding="0" cellspacing="0" width="500">
				<tr>
					<td valign="top">
						
						<b>
							<xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:enclosureName"/>&#160;<xsl:value-of select="$stringsDoc//value[@key='users']"/>
						</b>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						
						<div id="userOverviewTableContainer">
							<xsl:call-template name="userOverview" />
						</div>
						
						<span class="whiteSpacer">&#160;</span>
						<br />
						<div class="buttonSet">
							<div class="bWrapperUp"><div><div><button class="hpButton" id="deleteSecObjButton"><xsl:value-of select="$stringsDoc//value[@key='delete']"/></button></div></div></div>
							<div class="bWrapperUp"><div><div><button class="hpButton" id="editSecObjButton"><xsl:value-of select="$stringsDoc//value[@key='edit']"/></button></div></div></div>
							<div class="bWrapperUp"><div><div><button class="hpButton" id="newSecObjButton"><xsl:value-of select="$stringsDoc//value[@key='new']"/></button></div></div></div>
						</div>
						<div class="clearFloats"></div>
						
					</td>
				</tr>
			</table>

		</div>
		<div id="waitContainer" class="waitContainer"></div>

  </xsl:template>

</xsl:stylesheet>

