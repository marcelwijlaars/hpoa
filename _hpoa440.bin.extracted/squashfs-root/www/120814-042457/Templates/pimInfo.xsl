<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />

    <xsl:include href="../Templates/guiConstants.xsl" />
    <xsl:include href="../Templates/globalTemplates.xsl" />
	
	<xsl:template match="*">

        <b>
			<xsl:value-of select="$stringsDoc//value[@key='pim']" />
        </b>
        <br />

        <span class="whiteSpacer">&#160;</span>
        <br />
        
        <div class="groupingBox">

			<div id="pimErrorDisplay" class="errorDisplay"></div>
			
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<xsl:value-of select="$stringsDoc//value[@key='pduPartNumber:']" />
					</td>
					<td width="10">
						&#160;
					</td>
					<td>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="class">stdInput</xsl:attribute>
							<xsl:attribute name="id">pduPartNumber</xsl:attribute>
						</xsl:element>
					</td>
				</tr>
			</table>
			
        </div>
		
		<span class="whiteSpacer">&#160;</span><br />
        <div align="right">
            <div class='buttonSet'>
            <div class='bWrapperUp'>
                <div>
                <div>
                    <button type='button' class='hpButton' onclick="updatePartNumber();">
						Change
                    </button>
                </div>
                </div>
            </div>
            </div>
        </div>
        
        
    </xsl:template>
	

</xsl:stylesheet>

