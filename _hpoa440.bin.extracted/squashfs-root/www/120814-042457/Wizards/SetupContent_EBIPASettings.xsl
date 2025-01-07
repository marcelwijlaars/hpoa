<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl"/>
	<xsl:include href="../Forms/Ebipa.xsl"/>
	
  <xsl:param name="enclosureList" />
	<xsl:param name="ebipaInfoDoc" />
	<xsl:param name="stringsDoc" />
	
	<xsl:variable name="serviceUserAcl" select="$ADMINISTRATOR" />
    
	<xsl:template match="*">

		<!--
			This variable will be passed to the stylesheet and will determine
			whether or not we display the common setings note.
		-->
		<xsl:variable name="encCount" select="count($enclosureList//enclosure[selected='true'])" />
		
		<div id="stepInnerContent">

			<div class="errorDisplay" id="ebipaErrorDisplay"></div>

			<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceBayRange']"/>&#160;<em>
				<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceBayRangeDesc']"/>
			</em>

			<br />
			<span class="whiteSpacer">&#160;</span><br />

			<em>
				<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
				<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceBayRangeDescNote']" />
			</em>

			<br />
			<span class="whiteSpacer">&#160;</span><br />

			<em>
				<xsl:value-of select="$stringsDoc//value[@key='ebipaDeviceBayRangeDescNote1']" />
			</em>

			<br />

			<span class="whiteSpacer">&#160;</span><br />
			<div class="groupingBox">

        <div id="serverErrorDisplay" class="errorDisplay"></div>
				<xsl:call-template name="ebipaServerWiz">
					<xsl:with-param name="displaySettingsNote" select="($encCount &gt; 1)" />
				</xsl:call-template>
				
			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:value-of select="$stringsDoc//value[@key='ebipaIntrConnectBayRange']" />
			<em>
				<xsl:value-of select="$stringsDoc//value[@key='ebipaIntrConnectBayRangeDesc']" />
			</em>
			<br />
			<span class="whiteSpacer">&#160;</span><br />

			<em>
				<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
				<xsl:value-of select="$stringsDoc//value[@key='ebipaIntrConnectBayRangeDescNote']" />
			</em>

			<br />

			<span class="whiteSpacer">&#160;</span><br />
			
			<div class="groupingBox">
        <div id="interconnectErrorDisplay" class="errorDisplay"></div>
				<xsl:call-template name="ebipaInterconnect">
					<xsl:with-param name="displaySettingsNote" select="($encCount &gt; 1)" />
				</xsl:call-template>
			</div>
		</div>
		<div id="waitContainer"></div>
		
	</xsl:template>
	
</xsl:stylesheet>

