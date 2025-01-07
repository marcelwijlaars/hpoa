<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
  <xsl:output method="html" />
  
	<xsl:template match="*">

    <html>
      <head>
        <title></title>
        <link rel="stylesheet" type="text/css" href="../css/default.css" />
        <link rel="stylesheet" type="text/css" href="../css/blue_theme.css" />
        <link rel="stylesheet" type="text/css" href="../css/MxPortalEx.css" />
        <script type="text/javascript" src="../js/navigationControlManager.js"></script>
        <script type="text/javascript" src="../js/buttonManager.js"></script>
        <script type="text/javascript" src="../js/global.js"></script>
      </head>
      <body style="margin-top:10px; margin-left:10px; margin-right:10px;">

        <b>Test LDAP Configuration</b><br />
        <span class="whiteSpacer">&#160;</span><br />

          Directory Test Controls<br />
          <span class="whiteSpacer">&#160;</span><br />
          <div class="groupingBox">
            <table cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td>
                  Directory Administrator Distinguished Name:
                </td>
                <td width="10">&#160;</td>
                <td>
                  <input class="stdInput"  type="text" />
                </td>
              </tr>
              <tr>
                <td colspan="3" class="formSpacer">&#160;</td>
              </tr>
              <tr>
                <td>
                  Directory Administrator Password:
                </td>
                <td width="10">&#160;</td>
                <td>
                  <input class="stdInput"  type="password" autocomplete="off" />
                </td>
              </tr>
              <tr>
                <td colspan="3" class="formSpacer">&#160;</td>
              </tr>
              <tr>
                <td>
                  Test Username:
                </td>
                <td width="10">&#160;</td>
                <td>
                  <input class="stdInput" maxlength="256" type="text" />
                </td>
              </tr>
              <tr>
                <td colspan="3" class="formSpacer">&#160;</td>
              </tr>
              <tr>
                <td>
                  Test Password:
                </td>
                <td width="10">&#160;</td>
                <td>
                  <input class="stdInput" maxlength="40" type="password" autocomplete="off" />
                </td>
              </tr>
            </table>
          </div>

          <span class="whiteSpacer">&#160;</span><br />
          <div align="right">
            <div class='buttonSet' style="margin-bottom:0px;">
              <div class='bWrapperUp'>
                <div>
                  <div>
                    <button type='button' class='hpButton' id="btnSetIPSec" onclick="setIpSecurity();">Run Tests</button>
                  </div>
                </div>
              </div>
            </div>
          </div><br />

        <span class="whiteSpacer">&#160;</span><br />

        <table class="dataTable" cellpadding="0" cellspacing="0" border="0">
          <tr class="captionRow">
            <th>Test</th>
            <th>Status</th>
          </tr>
          <tr class="altRowColor">
            <td>Ping Directory Server</td>
            <td>Not Run</td>
          </tr>
          <tr>
            <td>Directory Server IP Address</td>
            <td>Not Run</td>
          </tr>
          <tr class="altRowColor">
            <td>Directory Server DNS Name</td>
            <td>Not Run</td>
          </tr>
          <tr>
            <td>Connect to Directory Server</td>
            <td>Not Run</td>
          </tr>
          <tr class="altRowColor">
            <td>Connect using SSL</td>
            <td>Not Run</td>
          </tr>
          <tr>
            <td>Certificate of Directory Server</td>
            <td>Not Run</td>
          </tr>
          <tr class="altRowColor">
            <td>Bind to Directory Server</td>
            <td>Not Run</td>
          </tr>
          <tr>
            <td>Directory Administrator Login</td>
            <td>Not Run</td>
          </tr>
          <tr class="altRowColor">
            <td>User Authentication</td>
            <td>Not Run</td>
          </tr>
          <tr>
            <td>User Authorization</td>
            <td>Not Run</td>
          </tr>
          <tr class="altRowColor">
            <td>Directory Search Context 1</td>
            <td>Not Run</td>
          </tr>
          <tr>
            <td>Directory Search Context 2</td>
            <td>Not Run</td>
          </tr>
          <tr class="altRowColor">
            <td>Directory Search Context 3</td>
            <td>Not Run</td>
          </tr>
          <tr>
            <td>LOM Object Exists</td>
            <td>Not Run</td>
          </tr>
          <tr class="altRowColor">
            <td>LOM Object Password</td>
            <td>Not Run</td>
          </tr>
        </table>

        <script>
          //<![CDATA[
          reconcileEventHandlers();
          //]]>
        </script>
        
      </body>
    </html>
		
	</xsl:template>
	

</xsl:stylesheet>

