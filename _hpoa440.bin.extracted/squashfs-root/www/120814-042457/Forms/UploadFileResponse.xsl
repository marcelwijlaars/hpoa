<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <xsl:output method="html"/>

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:template match="*">
    <html>
      <body>
        <xsl:choose>
          <!-- on error, create a hidden input with the error message -->
          <xsl:when test="//hpoa:errorCode or //hpoa:internalErrorCode">
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="id">errCode</xsl:attribute>
              <xsl:attribute name="value">
					  <xsl:choose>
						  <xsl:when test="//hpoa:internalErrorCode">
							  <xsl:value-of select="//hpoa:internalErrorCode" />
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of select="//hpoa:errorCode" />
						  </xsl:otherwise>
					  </xsl:choose>
              </xsl:attribute>
            </xsl:element>
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="id">errType</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="//hpoa:errorType" />
              </xsl:attribute>
            </xsl:element>
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="id">errMsg</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="//hpoa:errorText" />
              </xsl:attribute>
            </xsl:element>            
          </xsl:when>
          <xsl:otherwise>
            <!-- on success, create hidden inputs containing file path and type -->
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="id">fileType</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="//hpoa:fileType" />
              </xsl:attribute>
            </xsl:element>
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="id">oaFileToken</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="//hpoa:oaFileToken" />
              </xsl:attribute>
            </xsl:element>
            <xsl:if test="//hpoa:scriptLog">
              <xsl:element name="input">
                <xsl:attribute name="type">hidden</xsl:attribute>
                <xsl:attribute name="id">scriptLog</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//hpoa:scriptLog" />
                </xsl:attribute>
              </xsl:element>
            </xsl:if>
				 <xsl:if test="//hpoa:crc32">
					 <xsl:element name="input">
						 <xsl:attribute name="type">hidden</xsl:attribute>
						 <xsl:attribute name="id">crc32</xsl:attribute>
						 <xsl:attribute name="value">
							 <xsl:value-of select="//hpoa:crc32" />
						 </xsl:attribute>
					 </xsl:element>
				 </xsl:if>
				 <xsl:if test="//hpoa:returnCodeOk">
					 <xsl:element name="input">
						 <xsl:attribute name="type">hidden</xsl:attribute>
						 <xsl:attribute name="id">returnCode</xsl:attribute>
						 <xsl:attribute name="value">OK</xsl:attribute>
					 </xsl:element>
				 </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- debug outputter 
        <xsl:element name="{local-name()}">
			    <xsl:apply-templates />
		    </xsl:element>-->
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

