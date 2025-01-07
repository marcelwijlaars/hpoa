<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="testStatusDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:template match="*">

		<xsl:value-of select="$stringsDoc//value[@key='directoryTests']"/><br />
		<span class="whiteSpacer">&#160;</span><br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable">
			<thead>
				<tr class="captionRow">
					<th style="vertical-align:middle;">
						<xsl:value-of select="$stringsDoc//value[@key='testDescription']"/>
					</th>
					<th style="vertical-align:middle;">
						<xsl:value-of select="$stringsDoc//value[@key='status']"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><xsl:value-of select="$stringsDoc//value[@key='oTestStatus']"/></td>
					<td>
						<xsl:choose>
							<xsl:when test="$testStatusDoc//hpoa:ldapTestResult/hpoa:testStatus='TEST_PASSED'">
								<xsl:value-of select="$stringsDoc//value[@key='passed']"/>
							</xsl:when>
							<xsl:when test="$testStatusDoc//hpoa:ldapTestResult/hpoa:testStatus='TEST_FAILED'">
								<xsl:value-of select="$stringsDoc//value[@key='statusFailed']"/>
							</xsl:when>
							<xsl:when test="$testStatusDoc//hpoa:ldapTestResult/hpoa:testStatus='TEST_NOT_RUN'">
								<xsl:value-of select="$stringsDoc//value[@key='notRun']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:for-each select="$testStatusDoc//hpoa:ldapTestResult/hpoa:ldapTestStatusArray/hpoa:ldapTestStatus">

					<xsl:variable name="altRowClass">
						<xsl:if test="position() mod 2 = 0">altRowColor</xsl:if>
					</xsl:variable>
					
					<tr class="{$altRowClass}">
						<td>
							<xsl:variable name="testStringName" select="translate(hpoa:testDescription, ' ', '_')" />
							<xsl:value-of select="$stringsDoc//value[@key=$testStringName]"/>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="hpoa:testStatus='TEST_PASSED'">
									<xsl:value-of select="$stringsDoc//value[@key='passed']"/>
								</xsl:when>
								<xsl:when test="hpoa:testStatus='TEST_FAILED'">
									<xsl:value-of select="$stringsDoc//value[@key='statusFailed']"/>
								</xsl:when>
								<xsl:when test="hpoa:testStatus='TEST_NOT_RUN'">
									<xsl:value-of select="$stringsDoc//value[@key='notRun']"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='testLog']"/><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div class="groupingBox" style="padding: 5px; height:80px;overflow:auto;" id="testLog"></div>

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='testControls:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='testControlsDesc']"/></em><br />
		<span class="whiteSpacer">&#160;</span><br />
		<div class="groupingBox">

			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<TR>
					<TD>
						<xsl:value-of select="$stringsDoc//value[@key='username:']"/>
					</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<input id="username" maxlength="256" type="text" class="stdInput"/>
					</TD>
				</TR>
				<tr>
					<td colspan="3" class="formSpacer">&#160;</td>
				</tr>
				<TR>
					<TD>
						<xsl:value-of select="$stringsDoc//value[@key='password:']"/>
					</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<input id="password" maxlength="1024" autocomplete="off" type="password" class="stdInput"/>
					</TD>
				</TR>
			</TABLE>

		</div>

		<br />
		
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnApply" onclick="testLdap();">
								<xsl:value-of select="$stringsDoc//value[@key='testSettings']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>

</xsl:stylesheet>
