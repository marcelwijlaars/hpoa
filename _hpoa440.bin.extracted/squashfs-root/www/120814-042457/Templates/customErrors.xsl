<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd"
   xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:variable name="stringsDoc" select="document('/120814-042457/Strings/strings.en.xml')" />
	
	<xsl:template match="*">
		<html style="height:100%;">
			<head>
				<title>HP BladeSystem Onboard Administrator</title>
				<link rel="SHORTCUT ICON" href="/120814-042457/images/favicon.ico" />
				<link href="/120814-042457/css/default.css" rel="stylesheet" type="text/css"/>
				<link href="/120814-042457/css/blue_theme.css" rel="stylesheet" type="text/css"/>
				<link href="/120814-042457/css/MxPortalEx.css" rel="stylesheet" type="text/css"/>
				<link href="/120814-042457/css/widgets.css" rel="stylesheet" type="text/css"/>
			</head>

			<body class="body-flush-fit" style="overflow:hidden; height:100%;">
				<table cellpadding="0" cellspacing="0" border="0" style="width: 100%; height: 100%; margin:0px;" >
					<tr style="height: 39px; padding: 0px;">
						<td>
							<table border="0" cellpadding="0" cellspacing="0" class="applicationMastheadSmall" style="width: 100%; margin: 0px;">
								<tr>
									<td class="mastheadIcon">
										<img src="/120814-042457/images/themes/blue/logo_hp_smallmasthead.gif" alt="HP" width="30" height="19" />
									</td>
									<td class="mastheadTitle" style="width: 70%;">
										<h1 style="color: white;">HP BladeSystem Onboard Administrator</h1>
									</td>
									<td>
										<div class="mastheadPhoto">
											<img src="/120814-042457/images/masthead_photo_small.jpg" alt="" border="0"/>
										</div>
									</td>
									<td class="mastheadlinks" width="30%">&#160;</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr style="padding: 0px;">
						<td style="width: 100%; padding: 5px; vertical-align: top;">
							<table style="width: 100%; height: 100%; border: 3px solid #cccccc; padding: 0px;">
								<tr>
									<td style="height: 70%; width: 25%;">&#160;</td>
									<td style="height: 70%; width: 50%; vertical-align: middle;" align="center">
										<span class="whiteSpacer">&#160;</span>
										<span class="whiteSpacer">&#160;</span>
										<table cellpadding="0" cellspacing="0" border="0">
											<tr>
												<td valign="top">
													<img border="0" src="/120814-042457/images/status_informational_32.gif"/>
												</td>
												<td style="padding-left:10px;" valign="top">
													<xsl:choose>
														<xsl:when test="//SOAP-ENV:Fault/SOAP-ENV:Detail/hpoa:faultInfo/hpoa:errorCode='500'">
															<xsl:value-of select="$stringsDoc//value[@key='apache_500']"/>
														</xsl:when>
														<xsl:when test="//SOAP-ENV:Fault/SOAP-ENV:Detail/hpoa:faultInfo/hpoa:errorCode='502' or //SOAP-ENV:Fault/SOAP-ENV:Detail/hpoa:faultInfo/hpoa:errorCode='503'">
															<xsl:value-of select="$stringsDoc//value[@key='apache_502-503']"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$stringsDoc//value[@key='apache_500']"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>

										</table>
									</td>
									<td style="height: 70%; width: 25%;">&#160;</td>
								</tr>
								<tr>
									<td style="height: 30%;" colspan="3">&#160;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>

		</html>
	</xsl:template>

</xsl:stylesheet>
