<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="networkInfoDoc" />

	<xsl:include href="../Templates/guiConstants.xsl"/>
	
	<xsl:param name="serviceUserAcl" />
	
	<xsl:template match="*">
		
		<b>
        <xsl:value-of select="$stringsDoc//value[@key='llf']" />
        </b><br />
	    <span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='llfDesc']" />
		<br />

		<span class="whiteSpacer">&#160;</span><br />
		
		<em><xsl:value-of select="$stringsDoc//value[@key='note:']" />&#160;
		<xsl:value-of select="$stringsDoc//value[@key='llfNote']" /></em><br />
		
		<span class="whiteSpacer">&#160;</span><br />
		<div class="errorDisplay" id="errorDisplay"></div>
		
		<xsl:variable name="llfEnabled" select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:extraData[@hpoa:name='LinkFailoverEnabled']"/>
		
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<xsl:element name="input">
						<xsl:attribute name="type">checkbox</xsl:attribute>
						<xsl:attribute name="id">llfEnabled</xsl:attribute>
						<xsl:attribute name="onclick">toggleFormEnabled('llfIntervalContainer', this.checked);</xsl:attribute>
						<xsl:if test="$llfEnabled = 'true'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
					</xsl:element>
				</td>
				<td width="10">&#160;</td>
				<td>
					<label for="llfEnabled">
						<xsl:value-of select="$stringsDoc//value[@key='enableLlf']" />
					</label>
				</td>
			</tr>
		</table>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<table cellpadding="0" cellspacing="0" border="0" id="llfIntervalContainer">
			<tr>
				<td id="llfIntervalLabel">
					<xsl:value-of select="$stringsDoc//value[@key='failoverInterval']" />
				</td>
				<td width="10">&#160;</td>
				<td>
					<xsl:element name="input">
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="id">llfInterval</xsl:attribute>
						<xsl:attribute name="class">stdInput</xsl:attribute>

						<xsl:attribute name="validate-me">true</xsl:attribute>
						<xsl:attribute name="rule-list">9</xsl:attribute>
						<xsl:attribute name="range">30;86400</xsl:attribute>
						<xsl:attribute name="caption-label">llfIntervalLabel</xsl:attribute>
						
						<xsl:attribute name="value">
							<xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:extraData[@hpoa:name='LinkFailoverInterval']"/>
						</xsl:attribute>
						<xsl:if test="$llfEnabled = 'false'">
							<xsl:attribute name="disabled">true</xsl:attribute>
							<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
						</xsl:if>
					    </xsl:element>&#160;&#160;<xsl:value-of select="$stringsDoc//value[@key='seconds']" />
				</td>
			</tr>
		</table>

		<xsl:if test="$serviceUserAcl != $USER">

			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnApplyLlf" onclick="setLlfSettings();">
									<xsl:value-of select="$stringsDoc//value[@key='apply']" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>

		</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>

