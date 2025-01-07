<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
   xmlns:hpoa="hpoa.xsd">
   
   <!--
        (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
      -->
  <xsl:output method="html" />
  
  <xsl:param name="stringsDoc" />
  <xsl:param name="certsdoc" />		
  <xsl:param name="type" select="'default'" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  <xsl:include href="../Templates/guiConstants.xsl" />
  
  <xsl:template match="*">
    <xsl:variable name="quote">"</xsl:variable>
  
    <div id="errorDisplay" class="errorDisplay"></div>

    <xsl:choose>
      <xsl:when test="$certsdoc//hpoa:certificate/hpoa:sha1Fingerprint!=''" >
        <xsl:if test="$certsdoc//hpoa:certificate/hpoa:sha1Fingerprint!=''">

          <xsl:for-each select="$certsdoc//hpoa:certificate">
            <table class="dataTable" cellpadding="0" cellspacing="0" border="0">
              <caption>
                <xsl:choose>
                  <xsl:when test="$type='irsCerts'">
                    <xsl:value-of select="$stringsDoc//value[@key='certDetails']" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$stringsDoc//value[@key='caCertDetails']" />
                  </xsl:otherwise>
                </xsl:choose>
              </caption>

              <tr class="altRowColor">
                <th class="propertyName" >
                  <xsl:value-of select="$stringsDoc//value[@key='certVersion']" />
                </th>
                <td class="propertyValue">
                  <xsl:value-of select="hpoa:certificateVersion" />
                </td>
              </tr>
              <tr>
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='certIssueOrg']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:issuerOrganization" />
                </td>
              </tr>
              <tr class="altRowColor">
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='certIssueOrgUnit']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:issuerOrganizationalUnit" />
                </td>
              </tr>
              <tr>
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='certIssuedBy']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:issuerCommonName" />
                </td>
              </tr>
              <tr class="altRowColor">
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='certSubjectOrg']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:subjectOrganization" />
                </td>
              </tr>
              <tr>
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='certIssuedTo']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:subjectCommonName" />
                </td>
              </tr>
              <tr class="altRowColor">
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='certValidFrom']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:validFrom" />
                </td>
              </tr>
              <tr>
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='certValidUpto']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:validTo" />
                </td>
              </tr>
              <tr class="altRowColor">
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='serialNumber']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:serialNumber" />
                </td>
              </tr>
              <tr>
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='extensionCount']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:extensionCount" />
                </td>
              </tr>
              <tr class="altRowColor">
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='md5Fingerprint']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:md5Fingerprint" />
                </td>
              </tr>
              <tr>
                <th class="propertyName">
                  <xsl:value-of select="$stringsDoc//value[@key='sha1Fingerprint']" />
                </th>
                <td>
                  <xsl:value-of select="hpoa:sha1Fingerprint" />
                </td>
              </tr>
            </table>
            <div class="buttonSet" style="margin-bottom:15px;margin-top:10px;">
              <div class="bWrapperUp">
                <div>
                  <xsl:element name="div">
                    <xsl:element name="input">
                      <xsl:attribute name="type">button</xsl:attribute>
                      <xsl:attribute name="value">
                        <xsl:value-of select="$stringsDoc//value[@key='remove']" />
                      </xsl:attribute>

                      <xsl:attribute name="class">hpButton</xsl:attribute>
                      <xsl:attribute name="id">Button</xsl:attribute>
                      <xsl:attribute name="onclick">
                        <xsl:choose>
                          <xsl:when test="$type='irsCerts'">
                            <xsl:value-of select="concat('removeCertificate(', $quote, hpoa:sha1Fingerprint, $quote, ');')" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="concat('unmap(', $quote, hpoa:sha1Fingerprint, $quote, ');')" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                    </xsl:element>
                  </xsl:element>
                </div>
              </div>
            </div>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$type='irsCerts'">
            <xsl:value-of select="$stringsDoc//value[@key='noCertificatesInstalled']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$stringsDoc//value[@key='noCaCertInstalled']" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

                                                                                                                                                                                                                                                        
