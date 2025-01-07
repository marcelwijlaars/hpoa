<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/DateTime.xsl" />

	<xsl:include href="../Templates/guiConstants.xsl"/>

	<xsl:param name="stringsDoc" />
	<xsl:param name="dateTimeDoc" />
	<xsl:param name="networkInfoDoc" />

	<xsl:param name="serviceUserAcl" />

	<xsl:param name="isWizard" select="'false'" />
	
	<xsl:template match="*">

		<xsl:variable name="ntpEnabled">
			<xsl:choose>
				<xsl:when test="$isWizard='true'"><xsl:value-of select="'false'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpEnabled" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
        <div id="dateTimeContainer">
    		
            <b>
				<xsl:value-of select="$stringsDoc//value[@key='dateTime']" />
            </b><br />
		    <span class="whiteSpacer">&#160;</span><br />

			<xsl:value-of select="$stringsDoc//value[@key='staticDateTime']" /><br />
		    <span class="whiteSpacer">&#160;</span><br />
      	
		    <div class="groupingBox">
				<div id="dateErrorDisplay" class="errorDisplay"></div>

				<xsl:element name="input">

					<xsl:attribute name="type">radio</xsl:attribute>
					<xsl:attribute name="name">manualOrNtp</xsl:attribute>
					<xsl:attribute name="id">manualOrNtp_manual</xsl:attribute>
					<xsl:attribute name="class">stdRadioButton</xsl:attribute>
					<xsl:attribute name="value">manual</xsl:attribute>

					<xsl:attribute name="onclick">toggleFormEnabled('dateTimeFormContainer', this.checked);toggleFormEnabled('ntpFormContainer', !this.checked);</xsl:attribute>
					
					<xsl:if test="not($ntpEnabled='true')">
						<xsl:attribute name="checked">true</xsl:attribute>
					</xsl:if>
					
				</xsl:element>
				<label for="manualOrNtp_manual"><xsl:value-of select="$stringsDoc//value[@key='setTimeManually']" /></label><br />
				
				<blockquote>
					<div id="dateTimeFormContainer">
						<em>
							<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
						</em>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						<xsl:call-template name="dateTimeForm" />
					</div>
				</blockquote>

			</div>

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<!--
			<xsl:choose>
				<xsl:when test="$serviceUserAcl != $USER">
					<div align="right">
						<div class='buttonSet'>
							<div class='bWrapperUp'>
								<div>
									<div>
										<button type='button' class='hpButton' id="btnApplyDateTime" onclick="setDateTime();">
											<xsl:value-of select="$stringsDoc//value[@key='apply']" />
										</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<span class="whiteSpacer">&#160;</span>
					<br />
				</xsl:otherwise>
			</xsl:choose>
			-->
			
			<xsl:value-of select="$stringsDoc//value[@key='ntpWithAcr']" /><br />
		    <span class="whiteSpacer">&#160;</span><br />
      	
		    <div class="groupingBox">
				<div id="ntpErrorDisplay" class="errorDisplay"></div>

				<xsl:element name="input">

					<xsl:attribute name="type">radio</xsl:attribute>
					<xsl:attribute name="name">manualOrNtp</xsl:attribute>
					<xsl:attribute name="id">manualOrNtp_ntp</xsl:attribute>
					<xsl:attribute name="class">stdRadioButton</xsl:attribute>
					<xsl:attribute name="value">manual</xsl:attribute>

					<xsl:attribute name="onclick">toggleFormEnabled('ntpFormContainer', this.checked);toggleFormEnabled('dateTimeFormContainer', !this.checked);</xsl:attribute>
					
					<xsl:if test="$ntpEnabled='true'">
						<xsl:attribute name="checked">true</xsl:attribute>
					</xsl:if>

				</xsl:element>
				<label for="manualOrNtp_ntp"><xsl:value-of select="$stringsDoc//value[@key='setTimeNtp']" /></label><br />

				<blockquote>
					<div id="ntpFormContainer">
						<em>
							<xsl:value-of select="$stringsDoc//value[@key='requiredField']" />&#160;<xsl:value-of select="$stringsDoc//value[@key='asterisk']" />
						</em>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
						<xsl:call-template name="NTPForm" />
					</div>
				</blockquote>
			    
		    </div>

			<xsl:if test="$serviceUserAcl != $USER">
				<span class="whiteSpacer">&#160;</span>
				<br />
				<div align="right">
					<div class='buttonSet'>
						<div class='bWrapperUp'>
							<div>
								<div>
									<!--
									<button type='button' onclick="setupNTP();" class='hpButton' id="btnApplyNTP">
										<xsl:value-of select="$stringsDoc//value[@key='apply']" />
									</button>
									-->
									<button type='button' onclick="setupDateTime();" class='hpButton' id="btnApplyNTP">
										<xsl:value-of select="$stringsDoc//value[@key='apply']" />
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</xsl:if>
        </div>

	</xsl:template>
	

</xsl:stylesheet>

