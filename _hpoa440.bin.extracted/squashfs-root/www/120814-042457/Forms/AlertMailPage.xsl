<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/AlertMail.xsl" />

	<xsl:include href="../Templates/guiConstants.xsl"/>
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="alertMailInfoDoc" />
	<xsl:param name="networkInfoDoc" />
	<xsl:param name="testSupported" />
	<xsl:param name="nameSupported" />
	
	<xsl:param name="serviceUserAcl" />
	
	<xsl:template match="*">
		
		<b>
        <xsl:value-of select="$stringsDoc//value[@key='alertMail']" />
        </b><br />
	    <span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<div>
			<div id="errorDisplay" class="errorDisplay"></div>
			<em>
				<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
			</em><br />
			<span class="whiteSpacer">&#160;</span><br />
			
			<xsl:call-template name="alertMailSettings">
				<xsl:with-param name="nameSupported" select="$nameSupported" />
			</xsl:call-template>
		</div>

		<xsl:if test="$serviceUserAcl != $USER">
      <br />
      <br />
      <hr style="margin-bottom:10px;" />

			<div align="right" style="margin-top:0px;">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' class='hpButton' id="btnApplyDateTime" onclick="setAlertMail();">
									<xsl:value-of select="$stringsDoc//value[@key='apply']" />
								</button>
							</div>
						</div>
					</div>
					<xsl:if test="$testSupported='true'">

						<div class='bWrapperUp'>
							<div>
								<div>
									<xsl:element name="button">

										<xsl:attribute name="type">button</xsl:attribute>
										<xsl:attribute name="class">hpButton</xsl:attribute>
										<xsl:attribute name="id">btnTestSettings</xsl:attribute>
										<xsl:attribute name="onclick">testAlertmail();</xsl:attribute>

										<xsl:if test="$networkInfoDoc//hpoa:alertmailEnabled!='true'">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>

										<xsl:value-of select="$stringsDoc//value[@key='sndTestAlertMail']" />
									</xsl:element>

								</div>
							</div>
						</div>
						
					</xsl:if>
					
				</div>
			</div>

		</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>

