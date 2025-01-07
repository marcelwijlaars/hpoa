<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">
	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="certificateRequest" />
	<xsl:param name="certificateRequestStandby" />
	<xsl:param name="isStandby" />
	<xsl:param name="stringsDoc" />

	<xsl:include href="../Templates/globalTemplates.xsl" />
	<xsl:include href="../Templates/guiConstants.xsl" />

	<xsl:template match="*">

		<xsl:value-of select="$stringsDoc//value[@key='certRequestResultDesc1']" />&#160;
		<xsl:value-of select="$stringsDoc//value[@key='certRequestResultDesc2']" />&#160;
		<xsl:value-of select="$stringsDoc//value[@key='certRequestResultDesc3a']" />&#160;
		<b><xsl:value-of select="$stringsDoc//value[@key='certificateUpload']" /></b>&#160;
		<xsl:value-of select="$stringsDoc//value[@key='certRequestResultDesc3b']" /><br />

		<span class="whiteSpacer">&#160;</span><br />

		<textarea rows="14" style="width:100%;font-size:9pt;" class="stdInput" id="certificateRequestOutput" name="certificateRequestOutput">
			<xsl:value-of select="$certificateRequest//hpoa:certificateRequest"/>
		</textarea>

		<xsl:if test="$certificateRequestStandby">
			<span class="whiteSpacer">&#160;</span>
			<br />
			<xsl:choose>
				<xsl:when test="$isStandby='true'">
					<xsl:value-of select="$stringsDoc//value[@key='certRequestActiveOA1a']" />&#160;
					<b><xsl:value-of select="$stringsDoc//value[@key='certificateUpload']" /></b>&#160;
					<xsl:value-of select="$stringsDoc//value[@key='certRequestActiveOA1b']" /><br />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$stringsDoc//value[@key='certRequestStandbyOA1a']" />&#160;
					<b><xsl:value-of select="$stringsDoc//value[@key='certificateUpload']" /></b>&#160;
					<xsl:value-of select="$stringsDoc//value[@key='certRequestStandbyOA1b']" /><br />

				</xsl:otherwise>
			</xsl:choose>
			

			<span class="whiteSpacer">&#160;</span><br />

			<textarea rows="14" style="width:100%;font-size:9pt;" class="stdInput" id="certificateRequestOutputStandby" name="certificateRequestOutputStandby">
				<xsl:value-of select="$certificateRequestStandby//hpoa:certificateRequest"/>
			</textarea>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
