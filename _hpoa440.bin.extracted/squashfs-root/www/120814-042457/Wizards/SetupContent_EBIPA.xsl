<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="setupType" select="''" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureList" />
	
	<xsl:template name="SetupEBIPA" match="*">
		
		<div class="wizardTextContainer">

			<xsl:value-of select="$stringsDoc//value[@key='ebipaPara1']"/><br />
			

			<span class="whiteSpacer">&#160;</span><br />

			<xsl:value-of select="$stringsDoc//value[@key='ebipaPara2']"/><br />

			<span class="whiteSpacer">&#160;</span><br />

			<xsl:value-of select="$stringsDoc//value[@key='ebipaPara3']"/><br />

			<span class="whiteSpacer">&#160;</span><br />
			<span class="whiteSpacer">&#160;</span><br />
			
			<xsl:element name="div">
				
				<!--
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="count($enclosureList//enclosure[selected='true']) &gt; 1">display:block;</xsl:when>
						<xsl:otherwise>display:none;</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				-->

				<xsl:attribute name="style">display:none;</xsl:attribute>

				<span class="whiteSpacer">&#160;</span><br />

				<xsl:value-of select="$stringsDoc//value[@key='ebipaPara4a']"/>
        <b><xsl:value-of select="$stringsDoc//value[@key='express']"/></b>
        <xsl:value-of select="$stringsDoc//value[@key='ebipaPara4b']"/>
        <b>
          <xsl:value-of select="$stringsDoc//value[@key='custom']"/>
        </b>
        <xsl:value-of select="$stringsDoc//value[@key='ebipaPara4c']"/>
        <br />

				<span class="whiteSpacer">&#160;</span><br />
				<span class="whiteSpacer">&#160;</span><br />
				
				<xsl:element name="input">
					<xsl:attribute name="type">radio</xsl:attribute>
					<xsl:attribute name="name">EBIPAOption</xsl:attribute>
					<xsl:attribute name="value">Express</xsl:attribute>
					<xsl:attribute name="id">EBIPAExpress</xsl:attribute>
					<xsl:attribute name="class">stdRadioButton</xsl:attribute>
					<!--
					<xsl:if test="$setupType='Express'">
						<xsl:attribute name="checked">true</xsl:attribute>
					</xsl:if>
					<xsl:if test="count($enclosureList//enclosure[selected='true']) = 1">
						<xsl:attribute name="checked">true</xsl:attribute>
					</xsl:if>
					-->
					
					<!-- EBIPA changes for v1.30 - always use express mode -->
					<xsl:attribute name="checked">true</xsl:attribute>
					
				</xsl:element>
				<label for="EBIPAExpress"><xsl:value-of select="$stringsDoc//value[@key='express']"/></label>
				<br />

				<xsl:element name="input">
					<xsl:attribute name="type">radio</xsl:attribute>
					<xsl:attribute name="name">EBIPAOption</xsl:attribute>
					<xsl:attribute name="value">Custom</xsl:attribute>
					<xsl:attribute name="id">EBIPACustom</xsl:attribute>
					<xsl:attribute name="class">stdRadioButton</xsl:attribute>
					<!--
					<xsl:if test="$setupType='Custom'">
						<xsl:attribute name="checked">true</xsl:attribute>
					</xsl:if>
					-->
				</xsl:element>
				<label for="EBIPACustom"><xsl:value-of select="$stringsDoc//value[@key='custom']"/></label>
				<br />
				
			</xsl:element>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

      <xsl:value-of select="$stringsDoc//value[@key='click']"/>
      <b>
        <xsl:value-of select="$stringsDoc//value[@key='next']"/>
      </b>
      <xsl:value-of select="$stringsDoc//value[@key='ebipaPara5a']"/>
      <b>
        <xsl:value-of select="$stringsDoc//value[@key='skip']"/>
      </b>
      <xsl:value-of select="$stringsDoc//value[@key='ebipaPara5b']"/>

    </div>
	
	</xsl:template>
	
</xsl:stylesheet>

