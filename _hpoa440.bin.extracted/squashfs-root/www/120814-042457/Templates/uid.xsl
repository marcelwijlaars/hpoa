<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="uid">

        <xsl:param name="uidState" />

        <xsl:call-template name="getUIDLabel">
            <xsl:with-param name="statusCode" select="$uidState" />
        </xsl:call-template>

        <span class="whiteSpacer">&#160;</span>
        <br />
        <span class="whiteSpacer">&#160;</span>
        <br />
        
        <div class="buttonSet buttonsAreLeftAligned">
            <div class="bWrapperUp">
                <div>
                    <div>
						<xsl:element name="button">

							<xsl:attribute name="class">hpButtonSmall</xsl:attribute>
							<xsl:attribute name="onclick">setUidState(UID_CMD_TOGGLE());</xsl:attribute>

							<xsl:if test="$uidState = 'UID_BLINK'">
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:if>

							<xsl:value-of select="$stringsDoc//value[@key='toggleOnOff']" />

						</xsl:element>
                    </div>
                </div>
            </div>
        </div>
        <div class="clearFloats"></div>
		
    </xsl:template>


</xsl:stylesheet>

