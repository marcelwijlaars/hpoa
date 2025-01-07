<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">
	<xsl:output method="xml" />

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<!--
		This form is used to perform single sign-on to iLO.  The username
		and password values are posted to the iLO login URL.
	-->

  <xsl:param name="stringsDoc" />
	<xsl:param name="username" />
	<xsl:param name="password" />
	<xsl:param name="iLoUrl" />
	<xsl:param name="optionUrl" select="''" />
	<xsl:param name="method" select="'post'" />
	<xsl:param name="windowName" />
  <xsl:param name="showRetry" select='false' />
	
	<xsl:template match="*" name="iLoSso">
		
		<xsl:element name="form">

			<!-- Set up the form attributes to post to the iLO GUI. -->
			<xsl:attribute name="method"><xsl:value-of select="$method" /></xsl:attribute>
			<xsl:attribute name="action"><xsl:value-of select="$iLoUrl" /></xsl:attribute>
			<xsl:attribute name="name">autologin</xsl:attribute>
			<xsl:attribute name="id">autologin</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="$windowName"/></xsl:attribute>
			
			<!-- Username field (ProLiant iLO) -->
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">un</xsl:attribute>
				<xsl:attribute name="id">un</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$username" /></xsl:attribute>
			</xsl:element>
			
			<!-- Username field (Integrity iLO) -->
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">loginId</xsl:attribute>
				<xsl:attribute name="id">loginId</xsl:attribute>
				<xsl:attribute name="size">24</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$username" /></xsl:attribute>
			</xsl:element>
			
			<!-- Password field (ProLiant iLO) -->
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">pw</xsl:attribute>
				<xsl:attribute name="id">pw</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$password" /></xsl:attribute>
			</xsl:element>
			
			<!-- Username field (Integrity iLO) -->
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">password</xsl:attribute>
				<xsl:attribute name="id">password</xsl:attribute>
				<xsl:attribute name="size">24</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$password" /></xsl:attribute>
			</xsl:element>
			
			<!-- Option url field used for signing on directly to remote console. (ProLiant iLO) -->
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">url</xsl:attribute>
				<xsl:attribute name="id">url</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$optionUrl" /></xsl:attribute>
			</xsl:element>

			<!-- Autologin RequestURL field (Integrity iLO) -->
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">requestURL</xsl:attribute>
				<xsl:attribute name="id">requestURL</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$optionUrl" /></xsl:attribute>
			</xsl:element>
      
      <!-- .NET ClickOnce Retry Section -->
      <xsl:if test="$showRetry = 'true'">
        <table align="left" cellspacing="10" style="width:auto;border:0px;">
          <tr>
            <td>
              <xsl:value-of select="$stringsDoc//value[@key='ieClickOnceRetry']" />              
              <br />
              <br />
              <h5><xsl:value-of select="$stringsDoc//value[@key='possibleCauses:']" /></h5>           
              <ul>                
                <li><xsl:value-of select="$stringsDoc//value[@key='securitySettingsLocalIntranet']" /></li>
                <li><xsl:value-of select="$stringsDoc//value[@key='securitySettingsTrustedSites']" /></li>
              </ul>
              <h5><xsl:value-of select="$stringsDoc//value[@key='possibleSolutions:']" /></h5>
              <ul>
                <li><xsl:value-of select="$stringsDoc//value[@key='solutionSecuritySettingsFileDownloads']" /></li>
                <li><xsl:value-of select="$stringsDoc//value[@key='seeMSDNtopic:']" />&#160;<a href="http://msdn.microsoft.com/en-us/library/ms228998.aspx" target="_new"><xsl:value-of select="$stringsDoc//value[@key='msdnTopic228998SectionTitle']" /></a></li>
              </ul>              
            </td>
          </tr>
          <tr>
            <td align="left" style="padding-top:20px;">
              <input type="submit" onclick="showLoading();" style="background-color:#fff;border:none;color:#0000AA;text-decoration:underline;cursor:pointer,hand;font-weight:bold;" value="{$stringsDoc//value[@key='retry']}" />
            </td>
          </tr>
        </table>        
      </xsl:if>
			
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>
