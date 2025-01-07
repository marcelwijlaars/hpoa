<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:param name="stringsDoc" />
  <xsl:param name="isPopup" />

	<xsl:template match="*">
    <table class="applicationMastheadSmall" cellspacing="0" cellpadding="5" width="510" border="0">
      <tr height="39px">
        <td class="mastheadIcon">
        <img height="19" alt="HP" src="/120814-042457/images/themes/blue/logo_hp_smallmasthead.gif" width="30" border="0"/></td>
        <td class="mastheadTitle" width="90%">
        <h1><span langId="systemName">&#160;</span></h1>
        </td>
      </tr>
    </table>
    <table border="0" width="500" align="top">
      <tr>
        <td width="5"></td>
        <td align="center">
        <img src="/120814-042457/images/themes/blue/hp-logo.gif" border="0" alt="" title=""/></td>
        <td width="72%">
        <table width="100%">
          <tr>
            <td colspan="3">&#160;</td>
          </tr>
          <tr>
            <td class="statNames"><span langId="productName">&#160;</span></td>
            <td>&#160;&#160;&#160;</td>
            <td id="lblSystemName" class="stats"><span langId="systemName">&#160;</span></td>
          </tr>
          <tr>
            <td class="statNames"><span langId="buildVersion">&#160;</span></td>
            <td>&#160;&#160;&#160;</td>
            <td id="lblFwVersion" class="stats"><span langId="loading...">&#160;</span></td>
          </tr>
          <tr>
            <td class="statNames"><span langId="buildDate">&#160;</span></td>
            <td>&#160;&#160;&#160;</td>
            <td id="lblBuildDate" class="stats"><span langId="loading...">&#160;</span></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    <br />
    <table border="0" cellpadding="0" cellspacing="0" class="dataTable" style="margin-left:10px;padding-right:10px;width:480px;">
      <thead>
        <tr class="captionRow">
          <th id="lblHardware" width="60%"><span langId="hardware">&#160;</span></th>
          <th width="10%"><span langId="bay">&#160;</span></th>			
          <th width="18%"><span langId="partNo">&#160;</span></th>
          <th width="12%"><span langId="role">&#160;</span></th>
        </tr>
      </thead>
      <tr id="bay1Row" style="">
        <td id='bay1Hardware'><span langId="loading...">&#160;</span></td>
        <td id='bay1Bay'>1</td>	
        <td id='bay1PartNo'>&#160;</td>	
        <td id='bay1Role'>&#160;</td>
      </tr>
      <tr id="bay2Row" style="display:none;">
        <td id='bay2Hardware'><span langId="loading...">&#160;</span></td>
        <td id='bay2Bay'>2</td>
        <td id='bay2PartNo'>&#160;</td>	
        <td id='bay2Role'>&#160;</td>
      </tr>
    </table>
    <br />
    <table width="490" id="Table9">
      <tr>
        <td width="5"></td>
        <td class="copyright-line"><span langId="copyright">&#160;</span></td>
      </tr>
      <tr>
        <td width="5"></td>
        <td style="padding-top:5px;"><b>        
          <a href="{$stringsDoc//value[@key='mnuTellUsAboutURI']}" target="survey">
            <span langId="tellUsAbout">&#160;</span>&#160;<span langId="systemName">&#160;</span>
          </a>
			  <br />
			  <a href="{$stringsDoc//value[@key='mnuSupportURI']}" target="support">
				  <span langId="supportFor">&#160;</span>&#160;<span langId="systemName">&#160;</span>
			  </a>
        </b>
        </td>
      </tr>
      <tr>
      <td colspan="2" style="padding-top:0px;">        
        <xsl:choose>
          <xsl:when test="$isPopup = 'true'">
            <div class="bWrapperUp"><div><div><button class="hpButton" id="btnClose" onclick="javascript:self.close();"><span langId="ok">&#160;</span></button></div></div></div>      
          </xsl:when>
          <xsl:otherwise>
            <div class="bWrapperUp"><div><div><button class="hpButton" id="btnClose" onclick="closeMe();"><span langId="ok">&#160;</span></button></div></div></div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      </tr>
    </table>
	</xsl:template>
</xsl:stylesheet>
