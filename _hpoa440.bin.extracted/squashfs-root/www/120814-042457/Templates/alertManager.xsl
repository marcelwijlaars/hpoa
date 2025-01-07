<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="stringsDoc" />

	<!-- From enum defined in EnvironConstants.js -->
  <xsl:variable name="MSG_TYPE_DEFAULT" select="0" />
	<xsl:variable name="MSG_TYPE_INFO" select="1" />
	<xsl:variable name="MSG_TYPE_NORMAL" select="2" />
	<xsl:variable name="MSG_TYPE_WARNING" select="3" />
  <xsl:variable name="MSG_TYPE_NOT_ALLOWED" select="4" />
	<xsl:variable name="MSG_TYPE_CRITICAL" select="5" />
	<xsl:variable name="MSG_TYPE_QUESTION" select="6" />
  
	<!-- Default the message type to 0 (Information) -->
	<xsl:param name="alertMsgType" select="0" />
	<xsl:param name="alertMessage" />
  <xsl:param name="msgHeight">62</xsl:param>
	
	<xsl:template match="*">

		<!--
			The extended type variable is used to determine whether or not we use
			the icons.  Currently we only hide the icons for the informational type,
			but this variable could be extended for future cases.
		-->
		<xsl:variable name="messageUsesIcon">
			<xsl:choose>
				<xsl:when test="$alertMsgType=$MSG_TYPE_DEFAULT">0</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Determines which buttons to display. -->
		<xsl:variable name="messageRequiresConfirm">
			<xsl:choose>
				<xsl:when test="$alertMsgType=$MSG_TYPE_WARNING">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--
			The informational message type will not have as many columns as
			the types with the icons.
		-->
		<xsl:variable name="colspan">
			<xsl:choose>
				<xsl:when test="$messageUsesIcon=1">5</xsl:when>
				<xsl:otherwise>3</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<table cellpadding="0" cellspacing="0" border="0" width="305">

			<!-- 15px padding row -->
			<tr>
				<xsl:element name="td">
					<xsl:attribute name="width">15</xsl:attribute>
					<xsl:attribute name="colspan"><xsl:value-of select="$colspan" /></xsl:attribute>
					<img src="/120814-042457/images/one_white.gif" width="15" height="15" />
				</xsl:element>
			</tr>

			<!-- Content row with icon and message. -->
			<tr>
				<xsl:choose>

					<!-- Non-extended type -->
					<xsl:when test="$messageUsesIcon=0">
						<td width="15"><img src="/120814-042457/images/one_white.gif" width="15" height="{$msgHeight}" /></td>
						<td valign="top" align="left" width="100%">
							<div style="height:{$msgHeight}px;overflow:auto;">
								<xsl:value-of select="$alertMessage"/>
							</div>
						</td>
						<td width="10"><img src="/120814-042457/images/one_white.gif" width="10" height="{$msgHeight}" /></td>
					</xsl:when>

					<!-- Extended type with icons -->
					<xsl:otherwise>
						<td width="15"><img src="/120814-042457/images/one_white.gif" width="15" height="{$msgHeight}" /></td>
						
						<!-- icon cell -->
						<td width="32" valign="top">
              
              <xsl:choose>
                <xsl:when test="$alertMsgType=$MSG_TYPE_INFO">
                  <img src="/120814-042457/images/status_informational_32.gif" width="32" height="32" />
                </xsl:when>
                <xsl:when test="$alertMsgType=$MSG_TYPE_NORMAL">
                  <img src="/120814-042457/images/status_normal_32.gif" width="32" height="32" />
                </xsl:when>
                <xsl:when test="$alertMsgType=$MSG_TYPE_WARNING">
                  <img src="/120814-042457/images/status_minor_32.gif" width="32" height="32" />
                </xsl:when>
                <xsl:when test="$alertMsgType=$MSG_TYPE_CRITICAL">
                  <img src="/120814-042457/images/status_critical_32.gif" width="32" height="32" />
                </xsl:when>
                <xsl:when test="$alertMsgType=$MSG_TYPE_NOT_ALLOWED">
                  <img src="/120814-042457/images/icon_notallowed_32.gif" width="32" height="32" />
                </xsl:when>
                <xsl:when test="$alertMsgType=$MSG_TYPE_QUESTION">
                  <img src="/120814-042457/images/status_unknown_32.gif" width="32" height="32" />
                </xsl:when>
                <xsl:otherwise>
                  <img src="/120814-042457/images/status_minor_32.gif" width="32" height="32" />
                </xsl:otherwise>
              </xsl:choose>
							
						</td>
						
						<td width="15"><img src="/120814-042457/images/one_white.gif" width="15" height="{$msgHeight}" /></td>
						<td valign="top" align="left" width="100%">
							<div id="txtMessage" style="height:{$msgHeight}px;width:234px;overflow:auto;"></div>
						</td>
						<td width="10"><img src="/120814-042457/images/one_white.gif" width="10" height="{$msgHeight}" /></td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>

			<!-- 20px padding row -->
			<tr>
				<xsl:element name="td">
					<xsl:attribute name="colspan"><xsl:value-of select="$colspan" /></xsl:attribute>
					<img src="/120814-042457/images/one_white.gif" width="20" height="20" />
				</xsl:element>
			</tr>

			<!-- Button row -->
			<tr>

				<xsl:element name="td">
					
					<xsl:attribute name="colspan"><xsl:value-of select="$colspan" /></xsl:attribute>

					<table cellpadding="0" cellspacing="0" border="0" align="center">
						<tr>
							<td>
								<div class='buttonSet'>
									<div class='bWrapperUp bEmphasized'>
										<div><div>
											<button type='button' class='hpButton' id="btnClose" onclick="window.close();">OK</button>
										</div></div>
									</div>
								</div>
							</td>
						</tr>
					</table>
					
				</xsl:element>
				
			</tr>
			
		</table>
		
	</xsl:template>

</xsl:stylesheet>