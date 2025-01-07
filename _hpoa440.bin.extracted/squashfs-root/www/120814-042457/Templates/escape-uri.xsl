<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>

<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">
	
	<xsl:output method="html" indent="no" encoding="UTF-8"
		 doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>

	<!-- Escape URIs -->

	<!--<xsl:variable name="uri-input">The@dog-z went/_&#127;_%ab%zu%c</xsl:variable>
	<xsl:variable name="uri-output">The%40dog-z%20went%2F_%7F_%ab%25zu%25c</xsl:variable>
	<xsl:variable name="have-escape-uri" select="escape-uri($uri-input, true()) = $uri-output"/>-->
	<xsl:variable name="have-escape-uri" select="false()" />

	<!-- According to the RFC, non-ascii chars will be utf-8 encoded and escaped
     with %s by the xslt-engine when in a 'uri' attribute or by the browser
     if the xlst-engine doesn't. This is ok, but not enough since we still
     won't have working RFC822 (email) Froms! since they need =s. 
     However, as there is nothing I can do about this, I will just hope for
     the best if an xslt engine doesn't have uri-escape. -->
	<xsl:variable name="ascii-charset"> !&quot;#$%&amp;&apos;()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~&#127;</xsl:variable>
	<xsl:variable name="uri-ok">-_.!~*&apos;()0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="hex">0123456789ABCDEFabcdef</xsl:variable>

	<xsl:template name="do-escape-uri">
		<xsl:param name="str"/>
		<xsl:param name="allow-utf8"/>
		<xsl:param name="escape-amp" />

		<xsl:if test="$str">
			<xsl:variable name="first-char" select="substring($str,1,1)"/>
			<xsl:choose>
				<xsl:when test="$first-char = '%' and string-length($str) &gt;= 3 and contains($hex, substring($str,2,1)) and contains($hex, substring($str,3,1))">
					<!-- The percent char is ok IF it followed by a valid hex pair -->
					<xsl:value-of select="$first-char"/>
				</xsl:when>
				<xsl:when test="contains($uri-ok, $first-char)">
					<!-- This char is ok inside urls -->
					<xsl:value-of select="$first-char"/>
				</xsl:when>
				<xsl:when test="(not(contains($ascii-charset, $first-char)))">
					<!-- Non-ascii output raw based on utf8 allowed or not -->
					<xsl:choose>
						<xsl:when test="$allow-utf8">
							<xsl:value-of select="$first-char"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>%3F</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- URL escape this char -->
					<xsl:variable name="ascii-value" select="string-length(substring-before($ascii-charset,$first-char)) + 32"/>
					<xsl:text>%</xsl:text>
					<xsl:if test="$escape-amp">25</xsl:if>
					<xsl:value-of select="substring($hex,floor($ascii-value div 16) + 1,1)"/>
					<xsl:value-of select="substring($hex,$ascii-value mod 16 + 1,1)"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:call-template name="do-escape-uri">
				<xsl:with-param name="str" select="substring($str,2)"/>
				<xsl:with-param name="allow-utf8" select="$allow-utf8"/>
				<xsl:with-param name="escape-amp" select="$escape-amp"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="my-escape-uri">
		<xsl:param name="str"/>
		<xsl:param name="allow-utf8"/>
		<xsl:param name="escape-amp"/>

		<xsl:choose>
			<xsl:when test="$have-escape-uri">
				<!--<xsl:value-of select="escape-uri($str, true())"/>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="do-escape-uri">
					<xsl:with-param name="str" select="$str"/>
					<xsl:with-param name="allow-utf8" select="$allow-utf8"/>
					<xsl:with-param name="escape-amp" select="$escape-amp"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>