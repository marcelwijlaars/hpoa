<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="stringsDoc" />
	
	<xsl:template name="addUser" match="*">

		<b><xsl:value-of select="$stringsDoc//value[@key='addVlan']"/></b>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
    <div id="errorDisplay" class="errorDisplay"></div>
    
    <em><xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;*</em>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
    
    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td id="lblVlanId">
			  <xsl:value-of select="$stringsDoc//value[@key='vlanId:']"/>*
        </td>
        <td style="width:10px;">&#160;</td>
        <td>
          <input maxlength="4" validate-me="true" rule-list="1;9" caption-label="lblVlanId" range="1;4094" class="stdInput" type="text" id="vlanId" />          
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
          <input maxlength="31" size="40" validate-me="true" rule-list="0;6" caption-label="lblVlanName" range="0;31" class="stdInput" type="text" id="vlanName" />
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
                <button type='button' class='hpButton' id="btnAddVlan" onclick="addVlan();">
                  <xsl:value-of select="$stringsDoc//value[@key='add']" />
                </button>
              </div>
            </div>
          </div>
			  <div class='bWrapperUp'>
				  <div>
					  <div>
						  <button type='button' class='hpButton' id="btnCancel" onclick="cancelAdd();">
							  <xsl:value-of select="$stringsDoc//value[@key='cancel']" />
						  </button>
					  </div>
				  </div>
			  </div>
        </div>
      </div>
		
	</xsl:template>
	
</xsl:stylesheet>

