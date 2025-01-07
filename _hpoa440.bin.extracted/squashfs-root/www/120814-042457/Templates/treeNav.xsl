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

	<xsl:template match="*">
		
		<xsl:for-each select="$enclosureList/enclosures/enclosure">

			<xsl:element name="div">

				<xsl:attribute name="style">margin-left:19px;margin-bottom:5px;display:none;</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('enc', @number, 'treeOuterLabel')"/></xsl:attribute>
				
				<b style="cursor:pointer;cursor:default;">
<!--					Enclosure:--><xsl:value-of select="$stringsDoc//value[@key='enclosure:']" />&#160;<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('encNameLabel', @number)"/>
						</xsl:attribute>
					</xsl:element>
				</b>
				<br />

			</xsl:element>

			<xsl:element name="div">

				<xsl:attribute name="class">treeOpen</xsl:attribute>
				<xsl:attribute name="style">width:100%;display:none;margin-bottom:10px;</xsl:attribute>
				
				<xsl:attribute name="id"><xsl:value-of select="concat('enc', @number, 'treeContainer')"/></xsl:attribute>

				<!-- treeControl will be inserted here -->

			</xsl:element>
			
		</xsl:for-each>
		
	</xsl:template>

</xsl:stylesheet>
