<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="vlanInfoDoc" />
	<xsl:param name="vlanId" />
	
	<xsl:template name="addUser" match="*">
		<b>
			<xsl:value-of select="$stringsDoc//value[@key='editVlan']"/>
		</b>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
    <div id="errorDisplay" class="errorDisplay"></div>
    
    <span class="whiteSpacer">&#160;</span>
    <br />
    
    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td id="lblVlanId">
			  <xsl:value-of select="$stringsDoc//value[@key='vlanId:']"/>
        </td>
        <td style="width:10px;">&#160;</td>
        <td>
			  <xsl:value-of select="$vlanId"/>
        </td>
      </tr>
      <tr>
        <td class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td id="lblVlanName">
			  <xsl:value-of select="$stringsDoc//value[@key='vlanName:']"/>
        </td>
        <td style="width:10px;">&#160;</td>
        <td>
			  <xsl:element name="input">
				  <xsl:attribute name="type">text</xsl:attribute>
				  <xsl:attribute name="id">vlanName</xsl:attribute>
				  <xsl:attribute name="class">stdInput</xsl:attribute>
				  <xsl:attribute name="caption-label">lblVlanName</xsl:attribute>
				  <xsl:attribute name="range">0:31</xsl:attribute>
				  <xsl:attribute name="rule-list">0;6</xsl:attribute>
				  <xsl:attribute name="validate-me">true</xsl:attribute>
				  <xsl:attribute name="maxlength">31</xsl:attribute>
				  <xsl:attribute name="size">40</xsl:attribute>
				  <xsl:attribute name="value">
					  <xsl:value-of select="$vlanInfoDoc//hpoa:vlanInfo/hpoa:cfgArray/hpoa:cfg[hpoa:vlanId=$vlanId]/hpoa:vlanName"/>
				  </xsl:attribute>
			  </xsl:element>
        </td>
      </tr>
    </table>
    
    <span class="whiteSpacer">&#160;</span>
      <br />
      <div align="right" style="">
        <div class='buttonSet'>
          <div class='bWrapperUp bEmphasized'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnAddVlan" onclick="editVlan();">
                  <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                </button>
              </div>
            </div>
          </div>
			  <div class='bWrapperUp'>
				  <div>
					  <div>
						  <button type='button' class='hpButton' id="btnCancel" onclick="cancelEdit();">
							  <xsl:value-of select="$stringsDoc//value[@key='cancel']" />
						  </button>
					  </div>
				  </div>
			  </div>
        </div>
      </div>
		
	</xsl:template>
	
</xsl:stylesheet>

