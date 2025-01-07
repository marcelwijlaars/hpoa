<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2013 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="bladeBootInfoDoc" />
  <xsl:param name="bladeInfoDoc" />
	
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:include href="../Forms/BootOptions.xsl" />
	
	<xsl:template match="*">
    <xsl:variable name="secureBoot" select="$bladeInfoDoc//hpoa:extraData[@hpoa:name='secureBoot']" />
    
    <xsl:choose>
      <xsl:when test="$bladeBootInfoDoc//hpoa:errorType = 'USER_REQUEST' and $bladeBootInfoDoc//hpoa:errorCode = '543'">
        <!-- No OA support for boot options on this server (UEFI mode) -->
        
        <xsl:call-template name="bootOptionOverride" />
        
      </xsl:when>
      <xsl:otherwise>
        <!-- Normal Boot Options -->
          
        <xsl:call-template name="firstTimeBootOption" />
        
        <xsl:if test="not($secureBoot = 'enabled')">
		      <span class="whiteSpacer">&#160;</span>
		      <br />
		      <div align="right">
			      <div class='buttonSet'>
				      <div class='bWrapperUp'>
					      <div>
						      <div>
							      <button type='button' class='hpButton' onclick="setBladeFirstTimeBoot();">
								      <xsl:value-of select="$stringsDoc//value[@key='apply']" />
							      </button>
						      </div>
					      </div>
				      </div>
			      </div>
		      </div>
        </xsl:if>

		    <span class="whiteSpacer">&#160;</span>
		    <br />

		    <xsl:call-template name="permanentBootOrder" />
		    
        <xsl:if test="not($secureBoot = 'enabled')">
		      <span class="whiteSpacer">&#160;</span>
		      <br />
		      <div align="right">
			      <div class='buttonSet'>
				      <div class='bWrapperUp'>
					      <div>
						      <div>
							      <button type='button' class='hpButton' onclick="setBladeBootOrder();">
								      <xsl:value-of select="$stringsDoc//value[@key='apply']" />
							      </button>
						      </div>
					      </div>
				      </div>
			      </div>
		      </div>
        </xsl:if>
        <xsl:value-of select="$stringsDoc//value[@key='bayBootCntrlOrder']" /><br />
        <xsl:value-of select="$stringsDoc//value[@key='bayEmbeddedNicAndSysOption']" />          
          
      </xsl:otherwise>
    </xsl:choose>		
	</xsl:template>
	
</xsl:stylesheet>