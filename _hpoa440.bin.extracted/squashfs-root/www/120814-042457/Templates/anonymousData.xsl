<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:include href="../Templates/guiConstants.xsl"/>

  <xsl:param name="networkInfoDoc" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="serviceUserAcl" />
  
  <xsl:template match="*">
  
    <xsl:value-of select="$stringsDoc//value[@key='anonymousData']" />:&#160;<em>
      <xsl:value-of select="$stringsDoc//value[@key='anonymousDataDesc']" />
    </em>
    <br />
    <span class="whiteSpacer">&#160;</span><br />

    <div id="anonDataErrorDisplay" class="errorDisplay"></div>
    <xsl:call-template name="anonymousDataForm" />

    <span class="whiteSpacer">&#160;</span><br />

    <xsl:if test="$serviceUserAcl != $USER">
      <div align="right">
        <div class='buttonSet' style="margin-bottom:0px;">
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnSetAnonData" onclick="setAnonymousData();">
                  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>
    
  </xsl:template>

  <xsl:template name="anonymousDataForm">

    <table cellpadding="0" cellspacing="0" border="0">
		 <tr>
			 <td colspan="3" class="formSpacer">&#160;</td>
		 </tr>
		 <tr>
			 <td>
				 <xsl:element name="input">
					 <xsl:attribute name="type">checkbox</xsl:attribute>
					 <xsl:attribute name="class">stdCheckBox</xsl:attribute>
					 <xsl:attribute name="id">guiLoginDetail</xsl:attribute>
					 <xsl:if test="$serviceUserAcl = $USER">
						 <xsl:attribute name="disabled">true</xsl:attribute>
					 </xsl:if>
					 <xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='GuiLoginDetail']='true'">
						 <xsl:attribute name="checked">true</xsl:attribute>
					 </xsl:if>
				 </xsl:element>
				 <label for="guiLoginDetail">
					 <xsl:value-of select="$stringsDoc//value[@key='enableGuiLoginDetailProtocol']" />
				 </label>
			 </td>
		 </tr>  
    </table>

  </xsl:template>
  
</xsl:stylesheet>
