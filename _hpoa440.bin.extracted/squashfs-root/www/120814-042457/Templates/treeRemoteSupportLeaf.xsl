<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2013 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="treeRemoteSupportLeaf">
		<xsl:param name="activeFwVersion" />
		<xsl:param name="enclosureNumber" />
    <xsl:param name="bayNum"  />
    <xsl:param name="ersConfigInfoDoc" />
    
    <div id="{concat('enc', $enclosureNumber, 'ersTreeWrapper')}">    
      <xsl:choose>
        <xsl:when test="number($activeFwVersion) &gt;= number('4.10') and $ersConfigInfoDoc//hpoa:extraData[@hpoa:name='ersSolutionOverrideStatus'] != 'true'">
          <!-- include tree expander for IRS certificate pages -->

          <xsl:element name="div">
            <xsl:attribute name="class">treeClosed</xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'ers16Select')" />
            </xsl:attribute>
                      
            <div class="treeControl">                        
              <xsl:element name="div">
                <xsl:attribute name="class">treeStatusIcon</xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'ersStatusIcon')"/>
                </xsl:attribute>

                <xsl:if test="$ersConfigInfoDoc//hpoa:ersEnabled = 'true'">
                  <xsl:if test="$ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr != '' or $ersConfigInfoDoc//hpoa:ersLastTestAlertErrorStr != ''">
                    <xsl:call-template name="statusIcon">
                      <xsl:with-param name="statusCode" select="'OP_STATUS_DEGRADED'" />
                      <xsl:with-param name="optStyle" select="'margin-top:2px;'" />
                    </xsl:call-template>
                  </xsl:if>
                </xsl:if>        
              </xsl:element>
                        
              <div class="treeDisclosure"></div>
            </div>
            
            <xsl:element name="div">
              <xsl:attribute name="class">treeTitle</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('enc', $enclosureNumber, 'remoteSupportSelect')" />
              </xsl:attribute>
                        
              <xsl:element name="a">
                <xsl:attribute name="devId">
                  <xsl:value-of select="concat('enc', $enclosureNumber, 'remoteSupport')" />
                </xsl:attribute>                          
                <xsl:attribute name="href">../html/remoteSupport.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                <xsl:attribute name="devNum">
                  <xsl:value-of select="16" />
                </xsl:attribute>
                <xsl:attribute name="devType">ers</xsl:attribute>
                <xsl:attribute name="encNum">
                  <xsl:value-of select="$enclosureNumber" />
                </xsl:attribute>
                <xsl:value-of select="$stringsDoc//value[@key='remoteSupport']" />
              </xsl:element>                        
            </xsl:element>
                      
            <div class="treeContents">
                      
              <div class="leafWrapper">
                <div class="treeStatusIcon" />
                <xsl:element name="div">
                  <xsl:attribute name="class">leaf</xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('enc', $enclosureNumber, 'irsCertificateSelect')" />
                  </xsl:attribute>

                  <xsl:element name="a">
                    <xsl:attribute name="href">../html/irsCertificateAdministration.html?emNum=<xsl:value-of select="$bayNum" />&amp;encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
                    <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>
                    <xsl:attribute name="class">treeSelectableLink</xsl:attribute>

                    <xsl:attribute name="devNum">
                      <xsl:value-of select="17" />
                    </xsl:attribute>
                    <xsl:attribute name="devType">ersCert</xsl:attribute>
                    <xsl:attribute name="encNum">
                      <xsl:value-of select="$enclosureNumber" />
                    </xsl:attribute>

                    <xsl:value-of select="$stringsDoc//value[@key='certificateAdmin']" />
                  </xsl:element>
                </xsl:element>
              </div>                      
                        
            </div>  
          </xsl:element>
                    
        </xsl:when>
        <xsl:otherwise>
          <!-- original implementation without tree expander  -->
          <div class="leafWrapper">
            <div class="treeStatusIcon" style="vertical-align:bottom;" id="{concat('enc', $enclosureNumber, 'ersStatusIcon')}">    
              <xsl:if test="$ersConfigInfoDoc//hpoa:ersEnabled = 'true'">
                <xsl:if test="$ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr != '' or $ersConfigInfoDoc//hpoa:ersLastTestAlertErrorStr != ''">
                  <xsl:call-template name="statusIcon">
                    <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                    <xsl:with-param name="optStyle" select="'margin-top:2px;'" />
                  </xsl:call-template>
                </xsl:if>
              </xsl:if>
            </div>
            <xsl:element name="div">
              <xsl:attribute name="class">leaf</xsl:attribute>
              <xsl:attribute name="id">
              <xsl:value-of select="concat('enc', $enclosureNumber, 'remoteSupportSelect')" />
              </xsl:attribute>
              <xsl:element name="a">
              <xsl:attribute name="href">../html/remoteSupport.html?encNum=<xsl:value-of select="$enclosureNumber" /></xsl:attribute>
              <xsl:attribute name="target">CONTENT_HOME</xsl:attribute>                    
              <xsl:attribute name="class">treeSelectableLink</xsl:attribute>
              <xsl:attribute name="showTray">true</xsl:attribute><!-- set to 'false' to hide tray -->
              <xsl:attribute name="devNum">
                <xsl:value-of select="16" />
              </xsl:attribute>                    
              <xsl:attribute name="devType">ers</xsl:attribute>
              <xsl:attribute name="encNum">
                <xsl:value-of select="$enclosureNumber" />
              </xsl:attribute>    		                    
              <xsl:value-of select="$stringsDoc//value[@key='remoteSupport']" />
              </xsl:element>
            </xsl:element>
          </div>
        </xsl:otherwise>
      </xsl:choose>    
    </div>
	</xsl:template>

</xsl:stylesheet>