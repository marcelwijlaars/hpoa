<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  
	<xsl:template name="wizardNavigation">
		
		<xsl:variable name="hasSelectedEnclosures" select="'true'" />

		<div style="width:180px;border:7px solid #ccc;">
			<div style="padding:2px;">
				<div class="navigationControlHeader">
					<xsl:choose>
						<xsl:when test="$currentStep != 0">
							<b>
                <xsl:value-of select="$stringsDoc//value[@key='step']" />&#160;<xsl:value-of select="$currentStep" />&#160;<xsl:value-of select="$stringsDoc//value[@key='of']" />&#160;<xsl:value-of select="count($wizardStepsDoc/Wizard/steps/step)-1" />
							</b>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</div>

				<xsl:for-each select="$wizardStepsDoc/Wizard/steps/step">
          
          <xsl:variable name="stepTitleKey" select="title" />

					<xsl:element name="div">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="number=$currentStep">navigationControlOn</xsl:when>
								<xsl:otherwise>navigationControlOff</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<xsl:attribute name="id">
							<xsl:value-of select="concat('stepContainer', number)" />
						</xsl:attribute>

						<xsl:choose>
							<xsl:when test="$hasSelectedEnclosures and $wizardStepsDoc//linkNavigation='true'">
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:location = 'wizardContainerPage.html?step=<xsl:value-of select="number" />';</xsl:attribute>
									<xsl:value-of select="$stringsDoc//value[@key=$stepTitleKey]" />
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$stringsDoc//value[@key=$stepTitleKey]" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>

					<!-- Substep modification -->
					<xsl:if test="$currentStep &gt; number and substring-before($currentStep, '.') = number">            
						<xsl:for-each select="current()/steps/step">
              
              <xsl:variable name="subStepTitleKey" select="title" />
              <xsl:variable name="currentSubStep" select="number" />
              
              <xsl:variable name="singleton">
                <xsl:choose>
                  <xsl:when test="@singleton">
                    <xsl:value-of select="@singleton"/>
                  </xsl:when>
                  <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="($singleton = 'true' and $currentStep = $currentSubStep) or $singleton = 'false'">
							  <xsl:element name="div">
								  <xsl:attribute name="class">
									  <xsl:choose>
										  <xsl:when test="number=$currentStep">navigationControlOn navigationControlSubNav</xsl:when>
										  <xsl:otherwise>navigationControlOff navigationControlSubNav</xsl:otherwise>
									  </xsl:choose>
								  </xsl:attribute>

								  <xsl:attribute name="id">
									  <xsl:value-of select="concat('stepContainer', number)" />
								  </xsl:attribute>

								  <xsl:element name="a">
									  <xsl:attribute name="href">
										  javascript:location = 'wizardContainerPage.html?step=<xsl:value-of select="$currentSubStep" />';
									  </xsl:attribute>
									  <xsl:value-of select="$stringsDoc//value[@key=$subStepTitleKey]" />
								  </xsl:element>
							  </xsl:element>
              </xsl:if>
						</xsl:for-each>
					</xsl:if>

				</xsl:for-each>

			</div>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>
