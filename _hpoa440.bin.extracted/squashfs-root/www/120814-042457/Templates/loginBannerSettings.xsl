<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2012 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="serviceUserAcl" />
	<xsl:param name="loginBannerSettings" />
	<xsl:param name="stringsDoc" />
  <xsl:param name="maxBannerLength" select="1500" />

	<xsl:template match="*">
    <div class="errorDisplay" id="errorDisplay"></div>
    
    <xsl:element name="input">
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="id">chkEnableLoginBanner</xsl:attribute>
      <xsl:attribute name="style">margin-left:0px;vertical-align:middle;</xsl:attribute>
      <xsl:attribute name="onclick">updateValidation(this);</xsl:attribute>
      <xsl:if test="$loginBannerSettings//hpoa:bannerEnabled = 'true'">
        <xsl:attribute name="checked">checked</xsl:attribute>
      </xsl:if>
    </xsl:element>
    <label for="chkEnableLoginBanner" style="margin-left:5px;vertical-align:middle;">
      <xsl:value-of select="$stringsDoc//value[@key='enableLoginBanner']"/>
    </label>

    <span class="whiteSpacer">&#160;</span><br />
    <span class="whiteSpacer">&#160;</span><br />

    <label id="lblLoginBanner"><xsl:value-of select="$stringsDoc//value[@key='bannerText']" /></label>:&#160;<em><xsl:value-of select="$stringsDoc//value[@key='loginBannerDesc']" /></em>
		
    <span class="whiteSpacer">&#160;</span><br />

    <xsl:element name="textarea">
      <xsl:attribute name="wrap">on</xsl:attribute>
      <xsl:attribute name="class">stdInput</xsl:attribute>
      <xsl:attribute name="style">line-height:150%;font-size:9pt;width:600px;white-space:wrap;word-wrap:break-word;overflow:auto;margin-top:5px;margin-right:0px;margin-bottom:0px;</xsl:attribute>
      <xsl:attribute name="id">txtLoginBanner</xsl:attribute>
      <xsl:attribute name="rows">20</xsl:attribute>
      <xsl:attribute name="cols">50</xsl:attribute>
      
      <!-- validation -->
      <xsl:attribute name="validate-me">true</xsl:attribute>
      <xsl:attribute name="caption-label">lblLoginBanner</xsl:attribute>
      <xsl:attribute name="rule-list">
        <xsl:choose>
          <xsl:when test="$loginBannerSettings//hpoa:bannerEnabled = 'true'">6;11;16</xsl:when>
          <xsl:otherwise>11</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>      
      <xsl:attribute name="invalid-list"><xsl:text><![CDATA[<(%)\&#>]]></xsl:text></xsl:attribute>
      <xsl:attribute name="range">1;<xsl:value-of select="$maxBannerLength"/></xsl:attribute>
      <xsl:attribute name="onkeyup">updateCharCount(this.value);</xsl:attribute>
      <xsl:attribute name="onclick">updateCharCount(this.value);</xsl:attribute>
      <xsl:attribute name="onchange">updateCharCount(this.value);</xsl:attribute>
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$loginBannerSettings//hpoa:bannerText" />      
    </xsl:element>

    <xsl:variable name="totalColor">
      <xsl:choose>
        <xsl:when test="string-length($loginBannerSettings//hpoa:bannerText) &gt; $maxBannerLength">#cc0000;</xsl:when>
        <xsl:otherwise>#666;</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <div style="margin-top:4px;margin-bottom:2px;">
      <label style="color:#666;">
        <xsl:value-of select="$stringsDoc//value[@key='characters:']"/>
      </label><label id="lblCharCount" style="text-decoration:italic;margin-left:5px;color:{$totalColor};">
        <xsl:value-of select="string-length($loginBannerSettings//hpoa:bannerText)"/>
      </label>
    </div>
    
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnClearKeys" onclick="applyLoginBannerSettings();">
								<xsl:value-of select="$stringsDoc//value[@key='apply']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>