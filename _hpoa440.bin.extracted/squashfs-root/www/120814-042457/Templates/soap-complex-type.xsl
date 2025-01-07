<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:fmt="urn:p2plusfmt-xsltformats" 
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:s="http://www.w3.org/2001/XMLSchema"
  xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
  xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/"
  xmlns:hpoa="hpoa.xsd">

  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="utf-8" version="1.0"/>
  <xsl:param name="type" /><!-- includes namespace (hpoa:permissions) -->
  <xsl:param name="name" /><!-- does not include namespace (permissions) -->
  <xsl:param name="soapNS" /><!-- includes colon (hpoa:) -->

  <!--
      @author   : michael.slama@hp.com 
      @created  : 06-16-2009
      @purpose  : creates a complex xml type from a SOAP WSDL.
      @notes    : 09-04-2009 mds: added attribute loops for new types like hprm:permissions.
  -->
  <xsl:template match="*">
    <xsl:variable name="complexTypeName" select="substring-after($type, ':')" />

    <xsl:if test="//wsdl:types//s:complexType[@name = $complexTypeName] != ''">
      <xsl:element name="{concat($soapNS, $name)}" >
        <!-- attributes -->
        <xsl:for-each select="//wsdl:types//s:complexType[@name = $complexTypeName]/s:attribute/.">
          <xsl:attribute name="{concat($soapNS, @name)}">
            <xsl:call-template name="getDefaultValue">
              <xsl:with-param name="simpleType" select="@type" />
            </xsl:call-template>
          </xsl:attribute>
        </xsl:for-each>  
        <!-- elements -->
        <xsl:for-each select="//wsdl:types//s:complexType[@name = $complexTypeName]//s:element/.">
          <xsl:call-template name="getType">
            <xsl:with-param name="curType" select="@type" />
            <xsl:with-param name="curName" select="@name" />
          </xsl:call-template>
        </xsl:for-each>            
      </xsl:element>
    </xsl:if>

  </xsl:template>

  <!--
      @purpose  : returns either a simple type, or recurses for complex types.
      @notes    : complex type names do not include the namespace in the wsdl.
  -->
  <xsl:template name="getType">
    <xsl:param name="curType" />
    <xsl:param name="curName" />

    <xsl:choose>
      <xsl:when test="contains($curType, $soapNS)">
        <xsl:choose>
          <!-- special case for extraData tags -->
          <xsl:when test="substring-after($curType, ':') = 'extraData'">
            <xsl:element name="{$curType}">
              <xsl:attribute name="{concat($soapNS, 'name')}">SAMPLE</xsl:attribute>
              <xsl:call-template name="getDefaultValue">
                <xsl:with-param name="simpleType" select="'xsd:string'" />
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <!-- complex type handler -->
          <xsl:otherwise>
            <xsl:variable name="complexTypeName" select="substring-after($curType, ':')" />
            <xsl:element name="{concat($soapNS, $curName)}" >
               <!-- attributes -->
               <xsl:for-each select="//wsdl:types//s:complexType[@name = $complexTypeName]/s:attribute/.">
                <xsl:attribute name="{concat($soapNS, @name)}">
                  <xsl:call-template name="getDefaultValue">
                    <xsl:with-param name="simpleType" select="@type" />
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:for-each>  
              <!-- elements -->
              <xsl:for-each select="//wsdl:types//s:complexType[@name = $complexTypeName]//s:element/.">              
                <xsl:call-template name="getType">
                  <xsl:with-param name="curType" select="@type" />
                  <xsl:with-param name="curName" select="@name" />
                </xsl:call-template>                            
              </xsl:for-each>              
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- simple types -->
        <xsl:element name="{concat($soapNS, $curName)}">          
          <xsl:call-template name="getDefaultValue">
            <xsl:with-param name="simpleType" select="$curType" />
          </xsl:call-template> 
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--
      @purpose  : returns a reasonable default value for simple node types.
                : string nodes get populated with TEXT; remove here if not desired.
      @notes    : least used types are tested last. 
  -->
  <xsl:template name="getDefaultValue">
    <xsl:param name="simpleType" />
    <xsl:choose>
      <xsl:when test="$simpleType = 'xsd:string'">TEXT</xsl:when>
      <xsl:when test="$simpleType = 'xsd:boolean'">true</xsl:when>
      <xsl:when test="$simpleType = 'xsd:int'">1</xsl:when>
      <xsl:when test="$simpleType = 'xsd:short'">1</xsl:when>
      <xsl:when test="$simpleType = 'xsd:unsignedShort'">1</xsl:when>
      <xsl:when test="$simpleType = 'xsd:dateTime'">2009-06-10</xsl:when>
      <xsl:when test="$simpleType = 'xsd:byte'">1</xsl:when>
      <xsl:when test="$simpleType = 'xsd:float'">1.0</xsl:when>
      <xsl:when test="$simpleType = 'xsd:base64Binary'">00000000</xsl:when>
      <xsl:when test="$simpleType = 'xsd:hexBinary'">0Fb8</xsl:when>
      <xsl:otherwise>Unknown Type: <xsl:value-of select="$simpleType"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
