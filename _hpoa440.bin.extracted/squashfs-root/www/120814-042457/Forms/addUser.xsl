<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="passwordSettingsDoc" />
	
	<xsl:template name="addUser" match="*">
		
    <div id="errorDisplay" class="errorDisplay"></div>
    
    <em><xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;*</em>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
    <span class="whiteSpacer">&#160;</span>
    <br />
    
    <table cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td id="lblUsername">
          <xsl:value-of select="$stringsDoc//value[@key='username:']" />&#160;*
        </td>
        <td style="width:10px;">&#160;</td>
        <td>
          <input maxlength="40" size="60" validate-me="true" rule-list="6;8" caption-label="lblUsername" range="1;40" class="stdInput" type="text" id="username" />          
        </td>
      </tr>
      <tr>
        <td class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td id="lblPassword" keyval="password:">
         <xsl:value-of select="$stringsDoc//value[@key='password:']" />&#160;*
        </td>
        <td style="width:10px;">&#160;</td>
        <td>
          <input maxlength="40" size="60" validate-me="true" rule-list="6" caption-label="lblPassword" range="{$passwordSettingsDoc//hpoa:passwordSettings/hpoa:minPasswordLength};40" mirror-controlled="true" class="stdInput" type="password" autocomplete="off" id="password" />
        </td>
      </tr>
      <tr>
        <td class="formSpacer">&#160;</td>
      </tr>
      <tr>
        <td id="lblPasswordConfirm">
          <xsl:value-of select="$stringsDoc//value[@key='passwordConfirm:']" />&#160;*
        </td>
        <td style="width:10px;">&#160;</td>
        <td>
          <input maxlength="40" size="60" validate-me="true" rule-list="7" caption-label="lblPassword" related-inputs="password" class="stdInput" type="password" autocomplete="off" id="passwordConfirm" name="passwordConfirm" />          
        </td>
      </tr>
    </table>
    
    <span class="whiteSpacer">&#160;</span>
      <br />
      <div align="right" style="">
        <div class='buttonSet'>
          <div class='bWrapperUp'>
            <div>
              <div>
                <button type='button' class='hpButton' id="btnApplyDateTime" onclick="addUser();">
                  <xsl:value-of select="$stringsDoc//value[@key='addUser']" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
		
	</xsl:template>
	
</xsl:stylesheet>

