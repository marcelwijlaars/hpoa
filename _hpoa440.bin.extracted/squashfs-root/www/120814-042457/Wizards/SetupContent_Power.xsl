<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Forms/PowerManagement.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />
  
  <xsl:param name="stringsDoc" />
	<xsl:param name="powerConfigInfoDoc" />
	<xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="powerSupplyInfoDoc" />

	<xsl:param name="minVa" />
	<xsl:param name="maxVa" />

	<xsl:param name="enclosureType" select="0" />
	<xsl:param name="isTower" select="'false'" />
	<xsl:param name="serviceUserAcl" select="$ADMINISTRATOR" />
	<xsl:param name="powerCapConfigDoc" />
	<xsl:param name="powerCapExtConfigDoc" />
	<xsl:param name="powerCapBladeStatusDoc" />
	
	<xsl:template name="SetupPower" match="*">

		<xsl:variable name="isDC">
			<xsl:choose>
				<xsl:when test="$powerSubsystemInfoDoc//hpoa:powerSubsystemInfo/hpoa:subsystemType='EXTERNAL_DC'">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="powerUnits">
			<xsl:choose>
				<xsl:when test="$isDC='true'">DC</xsl:when>
				<xsl:otherwise>AC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div id="stepInnerContent">
			<div style="width:auto;max-width:1200px;width:expression(document.body.clientWidth > 1400 ? '1200px' : 'auto');" >

				<div id="powerErrorDisplay" class="errorDisplay"></div>

        <xsl:value-of select="$stringsDoc//value[@key='powerMode']" />:&#160;<em>
          <xsl:value-of select="$stringsDoc//value[@key='selectPwrSubsystemRedundantMode']" />
        </em><br />
				<span class="whiteSpacer">&#160;</span><br />

				<div class="groupingBox">
					<xsl:call-template name="powerRedundancy" />
				</div>

				<span class="whiteSpacer">&#160;</span><br />
				<span class="whiteSpacer">&#160;</span><br />

        <xsl:value-of select="$stringsDoc//value[@key='dynamicPwr']" />:&#160;<em>
          <xsl:value-of select="$stringsDoc//value[@key='dynamicPwrDesc']" />
				</em><br />
				<span class="whiteSpacer">&#160;</span><br />

				<div class="groupingBox">
					<xsl:element name="input">
						<xsl:attribute name="type">checkbox</xsl:attribute>
						<xsl:attribute name="class">stdCheckBox</xsl:attribute>
						<xsl:attribute name="id">dpsEnabled</xsl:attribute>
						<xsl:if test="$powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:dynamicPowerSaverEnabled='true'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
						<xsl:if test="$powerConfigInfoDoc//hpoa:powerConfigInfo/hpoa:redundancyMode='AC_REDUNDANT_WITH_OVERSUBSCRIPTION'">
							<xsl:attribute name="disabled">true</xsl:attribute>
						</xsl:if>
					</xsl:element>
					<label for="dpsEnabled">
            <xsl:value-of select="$stringsDoc//value[@key='enableDynamicPwr']" /></label>
				</div>

				<span class="whiteSpacer">&#160;</span><br />
				<span class="whiteSpacer">&#160;</span><br />

        <xsl:value-of select="$stringsDoc//value[@key='pwrLimit']" />:
				<em>
          <xsl:value-of select="$stringsDoc//value[@key='pwrLimit']" /><xsl:text> </xsl:text>
          <xsl:value-of select="$powerUnits" /><xsl:text> </xsl:text>
          <xsl:value-of select="$stringsDoc//value[@key='pwrLimitDesc2']" /><br />
				<span class="whiteSpacer">&#160;</span><br />
          <xsl:value-of select="$stringsDoc//value[@key='note:']" /><xsl:text> </xsl:text>
          <xsl:value-of select="$stringsDoc//value[@key='theMaximum']" /><xsl:text> </xsl:text>
          <xsl:value-of select="$powerUnits" /><xsl:text> </xsl:text>
          <xsl:value-of select="$stringsDoc//value[@key='pwrLimitNote1']" /><xsl:text> </xsl:text>
          <xsl:value-of select="$stringsDoc//value[@key='pwrLimitNote2']" /><xsl:text> </xsl:text>
          <xsl:value-of select="$powerUnits" /><xsl:text> </xsl:text>
          <xsl:value-of select="$stringsDoc//value[@key='pwrLimitNote3']" />
			</em><br />
				<span class="whiteSpacer">&#160;</span><br />

				<div class="groupingBox">
					<xsl:call-template name="acVaLimit" />
				</div>
				
			</div>
		</div>
		<div id="waitContainer" class="waitContainer"></div>
		
	</xsl:template>
	
</xsl:stylesheet>

