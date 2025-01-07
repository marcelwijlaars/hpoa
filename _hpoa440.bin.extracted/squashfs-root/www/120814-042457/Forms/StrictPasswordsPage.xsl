<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	
	<xsl:param name="stringsDoc" />
	<xsl:param name="passwordSettingsDoc" />
	<xsl:param name="networkInfoDoc" />

	<xsl:template match="*">

		<b>
        <xsl:value-of select="$stringsDoc//value[@key='passwordSettings']" />
        </b><br />
	    <span class="whiteSpacer">&#160;</span><br />

		<em>
			<xsl:value-of select="$stringsDoc//value[@key='passSettingsNote']"/>
		</em><br />
		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='strictPasswords:']" />&#160;<em>
			<xsl:value-of select="$stringsDoc//value[@key='strictPasswordsDescription']"/>
		</em>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div class="groupingBox">
			<div id="enabledErrorDisplay" class="errorDisplay"></div>
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<TR>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">checkbox</xsl:attribute>
							<xsl:attribute name="id">strictPasswordsEnabled</xsl:attribute>

							<xsl:if test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
                		                                <xsl:attribute name="disabled">true</xsl:attribute>
		                                        </xsl:if>

							<xsl:if test="$passwordSettingsDoc//hpoa:passwordSettings/hpoa:strictPasswordsEnabled='true'">
								<xsl:attribute name="checked">true</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<span id="lblEmail">
							<label for="strictPasswordsEnabled">
								<xsl:value-of select="$stringsDoc//value[@key='enableStrictPasswords']" />
								<xsl:call-template name="fipsHelpMsg">
									<xsl:with-param name="fipsMode" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']" />
									<xsl:with-param name="msgType">tooltip</xsl:with-param>
									<xsl:with-param name="msgKey">fipsRequired</xsl:with-param>
								</xsl:call-template>
							</label>
						</span>
					</TD>
				</TR>
			</TABLE>
		</div>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<xsl:choose>
								<xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
		                                                        <button type='button' class='hpButton' id="btnApply" onclick="setStrictPasswordsEnabled();" disabled="true">
										<xsl:value-of select="$stringsDoc//value[@key='apply']" />
                        		                                </button>
 								</xsl:when>
								<xsl:otherwise>
        	        	                                        <button type='button' class='hpButton' id="btnApply" onclick="setStrictPasswordsEnabled();">
 	                        	                                       <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                	                	                        </button>
 								</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
				</div>
			</div>
		</div>

		<span class="whiteSpacer">&#160;</span><br />

		<xsl:value-of select="$stringsDoc//value[@key='minPassLength:']" />&#160;<em>
		<xsl:choose>
			<xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
				<xsl:value-of select="$stringsDoc//value[@key='minPassLengthDescriptionFips']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stringsDoc//value[@key='minPassLengthDescription']"/>
			</xsl:otherwise>
		</xsl:choose>
		</em>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div class="groupingBox">
			<div id="lengthErrorDisplay" class="errorDisplay"></div>
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
				<TR>
					<TD>
						<span id="lblLength">
							<xsl:value-of select="$stringsDoc//value[@key='length:']" />
						</span>
					</TD>
					<TD width="10">&#160;</TD>
					<TD>
						<xsl:element name="input">
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="id">minPasswordLength</xsl:attribute>
							<xsl:attribute name="class">stdInput</xsl:attribute>
							<!-- 1-255 since we only have 1 byte of storage -->
							<xsl:attribute name="maxlength">3</xsl:attribute>
							<xsl:attribute name="validate-length">true</xsl:attribute>
							<xsl:attribute name="rule-list">9</xsl:attribute>
							<xsl:attribute name="range">
								<xsl:choose>
									<xsl:when test="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode']='FIPS-DEBUG'">
										8;40
									</xsl:when>
									<xsl:otherwise>
										3;40
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="caption-label">lblLength</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="$passwordSettingsDoc//hpoa:passwordSettings/hpoa:minPasswordLength"/>
							</xsl:attribute>
						</xsl:element>
					</TD>
				</TR>
			</TABLE>
		</div>
		<span class="whiteSpacer">&#160;</span>
		<br />
		<div align="right">
			<div class='buttonSet'>
				<div class='bWrapperUp'>
					<div>
						<div>
							<button type='button' class='hpButton' id="btnApply" onclick="setMinPasswordLength();">
								<xsl:value-of select="$stringsDoc//value[@key='apply']" />
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>

	</xsl:template>
	

</xsl:stylesheet>

