<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

    <xsl:param name="stringsDoc" />
	<xsl:param name="sessionTimeout" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:template match="*">
		
		<xsl:value-of select="$stringsDoc//value[@key='sessionTimeout:']" />&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='sessionTimeoutDesc']" />
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='sessionTimeoutNote']" /><br />
		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div id="errorDisplay" class="errorDisplay"></div>
		
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			
			<TR>
                <TD>
                    <span id="lblSessionTimeout">
                        <xsl:value-of select="$stringsDoc//value[@key='sessionTimeout:']" />
                    </span>
                </TD>
                <TD width="10">&#160;</TD>
                <TD id="sessionTimeoutCell">
                    <xsl:element name="input">

						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="name">sessionTimeout</xsl:attribute>
						<xsl:attribute name="id">sessionTimeout</xsl:attribute>

						<xsl:attribute name="value">
							<xsl:value-of select="$sessionTimeout"/>
						</xsl:attribute>
						
						<xsl:attribute name="class">stdInput</xsl:attribute>
						<xsl:attribute name="validate-me">true</xsl:attribute>
                        <xsl:attribute name="rule-list">9</xsl:attribute>
                        <xsl:attribute name="range">0;1440</xsl:attribute>
                        <xsl:attribute name="caption-label">lblSessionTimeout</xsl:attribute>

                        <xsl:attribute name="maxlength">4</xsl:attribute>

                    </xsl:element>&#160;<xsl:value-of select="$stringsDoc//value[@key='minutes']" />
                </TD>
            </TR>
        </TABLE>
		
		<span class="whiteSpacer">&#160;</span><br />
		
        <div align="right">
            <div class='buttonSet'>
                <div class='bWrapperUp'>
                    <div>
                        <div>
                            <button type='button' class='hpButton' id="btnApplyDateTime" onclick="setSessionTimeout();">
                                <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </xsl:template>

</xsl:stylesheet>
