<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2011 Hewlett-Packard Development Company, L.P.
  -->
  
  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="encNetworkInfoDoc" />
  <xsl:param name="serviceUserAcl" />
  
  <xsl:template name="ActiveHealthSystem" match="*">
    
    <h5><xsl:value-of select="$stringsDoc//value[@key='ActiveHealthSystem']"/></h5>
        <xsl:value-of select="$stringsDoc//value[@key='ActiveHealthSystemDesc']" />
    <br/>
    <span class="whiteSpacer">&#160;</span>
    <br/>
    
    <div id="errorDisplay" class="errorDisplay"></div>
    
    <div class="groupingBox">
    
      <!-- ENABLING CHECKBOX -->
      <xsl:element name="input">
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="class">stdCheckBox</xsl:attribute>
      <xsl:attribute name="style">margin-left:0px;vertical-align:middle;</xsl:attribute>
      <xsl:attribute name="id">chkActiveHealthSystem</xsl:attribute>
      <xsl:if test="$serviceUserAcl != $ADMINISTRATOR">
        <xsl:attribute name="disabled">true</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="onclick">toggleFormEnabled('remoteSupportForm', this.checked);</xsl:attribute>
      <xsl:if test="$encNetworkInfoDoc//hpoa:extraData[@hpoa:name='ActiveHealthSystemEnabled'] = 'true'">
        <xsl:attribute name="checked">true</xsl:attribute>
      </xsl:if>
      </xsl:element>
    
      <label for="chkActiveHealthSystem">
        <xsl:value-of select="$stringsDoc//value[@key='enableActiveHealthSystem']" />
      </label>
    
    </div>  
    
    <!-- BUTTON SET -->
    <xsl:if test="$serviceUserAcl = $ADMINISTRATOR">
      <span class="whiteSpacer">&#160;</span>
      <br />
      <div align="right">
        <div class='buttonSet' style="margin-bottom:0px;">          
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnAppy" onclick="setActiveHealthSystem();">
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

