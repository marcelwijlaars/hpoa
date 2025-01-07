<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="sshKeysDoc" />
	<xsl:param name="sshFingerprint" />
	<xsl:param name="stringsDoc" />

	<xsl:template match="*">

		<xsl:value-of select="$stringsDoc//value[@key='sshFingerprint']" /><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div class="groupingBox">
			<xsl:value-of select="$sshFingerprint"/>
		</div>

		<span class="whiteSpacer">&#160;</span><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='authorizedKeys:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='authorizedKeysDesc']" /></em><br />
		<span class="whiteSpacer">&#160;</span><br />
		<div class="errorDisplay" id="keyErrorDisplay"></div>
		<textarea wrap="off" class="stdInput" style="line-height:150%;font-size:9pt;width:100%;" id="sshKeys" rows="10" cols="50">
			<xsl:value-of select="$sshKeysDoc//hpoa:sshKeys"/>
		</textarea>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnClearKeys" onclick="saveSshKeys();">
								<xsl:value-of select="$stringsDoc//value[@key='apply']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='downloadKeyFile:']" />&#160;<em><xsl:value-of select="$stringsDoc//value[@key='downloadKeyDesc']"/></em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<div class="groupingBox">
			<div class="errorDisplay" id="errorDisplay"></div>
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<xsl:value-of select="$stringsDoc//value[@key='keysFileUrl:']" /></td>
					<td width="5">&#160;</td>
					<td>
						<input type="text" class="stdInput" id="urlToKeys" size="40"/>
					</td>
				</tr>
			</table>

		</div>

		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnGetKeys" onclick="downloadSshKeys();">
								<xsl:value-of select="$stringsDoc//value[@key='apply']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>