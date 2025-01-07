<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/powerThermalEnc.xsl" />
	
	<xsl:param name="encNum" />
	<xsl:param name="enclosureInfoDoc" />
	<xsl:param name="enclosureStatusDoc" />
	<xsl:param name="powerSubsystemInfoDoc" />
	<xsl:param name="powerConfigInfoDoc" />
	<xsl:param name="thermalSubsystemInfoDoc" />
	<xsl:param name="enclosureThermalsDoc" />
	<xsl:param name="powerCapConfigDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureType" select="string('0')" />
  <xsl:param name="isAuthenticated" />
	<xsl:param name="isLocal" />
	<xsl:param name="isLoaded" />
	<xsl:param name="enclosureName" />
	
	<xsl:template match="*">
		
<xsl:variable name="hash">
			<xsl:value-of select="concat('enc', $encNum)"/>
		</xsl:variable>
		<xsl:variable name="linkId" select="concat('signOutEnc', $encNum)" />
		<xsl:variable name="linkStyle">
			visibility:visible;margin:0px;
		</xsl:variable>

		<table cellpadding="0" cellspacing="0" border="0" align="center" style="border-collapse:collapse;" width="100%">
			<tr>
				<td style="padding-right:1px;">

					<div style="width:100%;">

						<h3 class="subTitle">
							<a name="{$hash}" />

							<div class="subTitleIcon" id="{$linkId}" style="{$linkStyle}">
								<xsl:choose>
									<xsl:when test="not($isAuthenticated='true')">
										<xsl:element name="a">
											<xsl:attribute name="href">
												<xsl:value-of select="concat('rackOverview.html#enc', $encNum)" />
											</xsl:attribute>
											<xsl:attribute name="style">color:#fff;text-decoration:underline;font-weight:normal;padding-bottom:2px;</xsl:attribute>
											<xsl:attribute name="onclick">selectTab('rackOverview');top.mainPage.getStatusContainer().showStatus(false);</xsl:attribute>
											<xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
											<xsl:value-of select="$stringsDoc//value[@key='linkedNotLoggedIn']" />
										</xsl:element>
									</xsl:when>
									<xsl:when test="$isLocal = 'true'">
										<span style="color:#fff;text-decoration:none;font-weight:bold;padding-bottom:2px;" >
											<xsl:value-of select="$stringsDoc//value[@key='primaryConnection']" />
										</span>
									</xsl:when>
									<xsl:when test="not($isLocal='true') and $isLoaded='true'">
										<span style="color:#fff;text-decoration:none;font-weight:normal;padding-bottom:2px;" >
											<xsl:value-of select="$stringsDoc//value[@key='linkedLoggedIn']" />
										</span>
									</xsl:when>
								</xsl:choose>
							</div>

<!--							<span>Enclosure: </span> -->
							<span><xsl:value-of select="$stringsDoc//value[@key='enclosure']" />:</span>
							<xsl:element name="span">
								<xsl:attribute name="style">display:inline;</xsl:attribute>
								<xsl:attribute name="id">
									<xsl:value-of select="concat('encNameLabel', $encNum)"/>
								</xsl:attribute>
								<xsl:value-of select="$enclosureName"/>
							</xsl:element>

						</h3>

						<div class="subTitleBottomEdge"></div>

						<xsl:element name="div">

							<xsl:attribute name="id">
								<xsl:value-of select="concat('enc', $encNum, 'Content')" />
							</xsl:attribute>
							<xsl:attribute name="class">enclosureWrapper</xsl:attribute>

							<xsl:call-template name="powerThermalEnclosure" />

						</xsl:element>

					</div>

				</td>
			</tr>
		</table>
		
	</xsl:template>
	
</xsl:stylesheet>