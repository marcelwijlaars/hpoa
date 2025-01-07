<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:output method="html" />
  <xsl:param name="stringsDoc" />
	<xsl:param name="enclosureList" />
  <xsl:param name="maxConnectionsExceeded" />
  
  <xsl:include href="../Templates/guiConstants.xsl"/>
  <xsl:include href="../Templates/globalTemplates.xsl"/>

	<xsl:template match="*">

		<xsl:for-each select="$enclosureList/enclosures/enclosure">

			<xsl:element name="div">
				<xsl:attribute name="style">display:none;</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enc', @number, 'rackContainer')" /></xsl:attribute>
				<xsl:attribute name="encNum"><xsl:value-of select="@number"/></xsl:attribute>
			</xsl:element>
			
		</xsl:for-each>

		<span class="whiteSpacer">&#160;</span>
		<br />
    <xsl:if test="$maxConnectionsExceeded != ''">
      <div style="color:#cc0000;margin-left:10px;font-weight:bold;">        
        <xsl:call-template name="statusIcon">
          <xsl:with-param name="statusCode" select="$OP_STATUS_IN_SERVICE" />
        </xsl:call-template>&#160;
        <label style="vertical-align:top;">
          <xsl:value-of select="$stringsDoc//value[@key='maxEnclosuresExceeded1']"/>
          <xsl:value-of select="$maxConnectionsExceeded"/>
          <xsl:value-of select="$stringsDoc//value[@key='maxEnclosuresExceeded2']"/>
        </label>
      </div>
    </xsl:if>
    
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button class='hpButton' style='padding-left:5px;padding-right:5px;' id='btnRefreshTopology' onclick="top.refreshTopology();"><xsl:value-of select="$stringsDoc//value[@key='refreshTopology']"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>
