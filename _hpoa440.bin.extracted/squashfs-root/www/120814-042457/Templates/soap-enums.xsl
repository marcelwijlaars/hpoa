<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:fmt="urn:p2plusfmt-xsltformats" 
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:s="http://www.w3.org/2001/XMLSchema"
  xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
  xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/">
  
  <xsl:output method="text" />  
  <xsl:strip-space elements="*" />
  
  <xsl:param name="elementName" />
  <xsl:param name="methodName" />
  <xsl:param name="soapNS" select="'hpoa:'"/><!-- default namespace -->
  
  <xsl:template name="enums" match="*">
  
    <!-- enums are converted to xsd:string in the gui; perform a lookup here to fix -->
    <xsl:variable name="enumType">
      <xsl:choose>
        <xsl:when test="substring-after(//wsdl:types//s:element[@name=$methodName]//s:element[@name=$elementName]/@type, ':') != ''">
          <xsl:value-of select="substring-after(//wsdl:types//s:element[@name=$methodName]//s:element[@name=$elementName]/@type, ':')"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$elementName"/></xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>

    <xsl:if test="count(//wsdl:types//s:simpleType[@name=$enumType]//s:enumeration) &gt; 0">      
      [<xsl:for-each select="//wsdl:types//s:simpleType[@name=$enumType]//s:enumeration/.">
        <xsl:choose>
          <xsl:when test="position() = last()">'<xsl:value-of select="@value"/>'</xsl:when>
          <xsl:otherwise>'<xsl:value-of select="@value"/>', </xsl:otherwise>
        </xsl:choose>        
      </xsl:for-each>]
    </xsl:if> 
    
  </xsl:template>  
</xsl:stylesheet>
