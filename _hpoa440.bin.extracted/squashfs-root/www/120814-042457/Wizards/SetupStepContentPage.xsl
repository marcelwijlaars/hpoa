<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="/120814-042457/Wizards/WizardNavigation.xsl" />
	<xsl:include href="/120814-042457/Wizards/WizardButtonSet.xsl" />
	
	<xsl:param name="currentStep" />
	<xsl:param name="wizardStepsDoc" />
	<xsl:param name="stringsDoc" />
	
	<xsl:template match="*">

    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="0%" valign="top">

          <!-- Add the wizard side navigation -->
          <xsl:call-template name="wizardNavigation" />

        </td>
        <td width="100%" valign="top" style="padding-left:10px;">

          <table width="100%" border="0" cellpadding="0" cellspacing="0">           
            <tr>
              <td style="padding-left:3px; padding-bottom:20px;" valign="top">                
                <font class="mxPageSubTitle">
                  <b>
                    <!-- Step title -->
                    <xsl:value-of select="$stringsDoc//value[@key=$wizardStepsDoc//step[number=$currentStep]/title]" />
                  </b>
                </font>
              </td>
            </tr>
            <tr>
              <td valign="top" style="padding-left:3px;padding-right:1px;" height="250">
                <!-- Step content container -->
                <div id="stepContent"></div>
              </td>
            </tr>
          </table>

          <span class="whiteSpacer">&#160;</span>
          <br />

          <hr />

          <!-- Wizard button set section -->

          <xsl:variable name="nextStepNumber">
            <xsl:choose>
              <xsl:when test="count($wizardStepsDoc//step[number=$currentStep]/steps) &gt; 0">
                <xsl:value-of select="$wizardStepsDoc//step[number=$currentStep]/steps/step/number" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$wizardStepsDoc//step[number=$currentStep]/following::number" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <!-- Only display the finish button for the last step -->
          <xsl:variable name="displayFinish" select="$currentStep = count($wizardStepsDoc/Wizard/steps/step)-1" />

          <!-- Only display the skip button on main steps (not substeps), and not on the first or last steps -->
          <xsl:variable name="displaySkip" select="not(contains($currentStep, '.')) and $currentStep != 0 and not($displayFinish)" />

          <!-- Check to see if the step has an initialization function -->
          <xsl:variable name="hasInit" select="count($wizardStepsDoc//step[number=$currentStep]/initFunction) &gt; 0" />

          <!-- Check to see if the step needs to override the fact that it has an init function -->
          <xsl:variable name="overrideHasInit" select="$wizardStepsDoc//step[number=$currentStep]/retainNextStep = 'true'" />

          <!--
            The linkNext variable is a composite value of the above hasInit and overrideInit values.
            If the step has neither an init function, nor the need to override the init function, the
            next button is linked to the next step.
          	
            If the step has an init function and no override, the next button will not be linked to
            the next step.  In this case, the init function will wire up the button.
          	
            However, if the step has an init function and still wants the button to be linked to the next
            step, it can link to the next step by including <retainNextStep>true</retainNextStep>
            in it's step's child nodes.  In this case, both the init function will fire, and the
            button will navigate to the next step.
          -->
          <xsl:variable name="linkNext" select="$hasInit or not($overrideHasInit)" />

          <xsl:choose>
            <!-- button information is explicit -->
            <xsl:when test="$wizardStepsDoc//step[number=$currentStep]/buttons">
              <xsl:call-template name="wizardStepsDocButtonSet">
                <xsl:with-param name="curStep" select="$currentStep" />
                <xsl:with-param name="nextStep" select="$nextStepNumber" />
                <xsl:with-param name="stepsDoc" select="$wizardStepsDoc" />
              </xsl:call-template>
            </xsl:when>
            <!-- button information is implied -->
            <xsl:otherwise>
              <xsl:call-template name="wizardButtonSet">
                <xsl:with-param name="displayNext" select="not($displayFinish)" />
                <xsl:with-param name="linkNext" select="$linkNext" />
                <xsl:with-param name="nextStepNumber" select="$nextStepNumber" />
                <xsl:with-param name="displayPrevious" select="$currentStep != 0" />
                <xsl:with-param name="displaySkip" select="$displaySkip" />
                <xsl:with-param name="skipStepNumber" select="$wizardStepsDoc//step[number=$currentStep]/following::number" />
                <xsl:with-param name="displayFinish" select="$displayFinish" />
                <xsl:with-param name="displayCancel" select="not($displayFinish)" />
              </xsl:call-template>

            </xsl:otherwise>
          </xsl:choose>
					
				</td>
			</tr>
		</table>
		
	</xsl:template>
	
</xsl:stylesheet>

