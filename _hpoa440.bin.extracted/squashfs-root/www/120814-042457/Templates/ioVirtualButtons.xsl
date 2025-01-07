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
  <xsl:include href="../Templates/uid.xsl" />

  <xsl:param name="stringsDoc" />
  <xsl:param name="netTrayStatusDoc" />

  <xsl:param name="serviceUserAcl" />

  <xsl:template match="*">

	  <xsl:variable name="uidState" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus/hpoa:uid" />
	  <xsl:variable name="powerState" select="$netTrayStatusDoc//hpoa:interconnectTrayStatus/hpoa:powered" />

	  <xsl:if test="$serviceUserAcl != $USER">
		  <xsl:value-of select="$stringsDoc//value[@key='virtualPower:']" />&#160;<em>
			  <xsl:value-of select="$stringsDoc//value[@key='ioVirtualPowerDes']" />
		  </em><br />
		  <span class="whiteSpacer">&#160;</span><br />

		  <div class="groupingBox">

			  <span id="powerMsg">
				  <xsl:value-of select="$stringsDoc//value[@key='interConnectPowerStateDescription']" />&#160;
				  <xsl:choose>
					  <xsl:when test="$powerState=$POWER_ON"><xsl:value-of select="$stringsDoc//value[@key='on']" /></xsl:when>
					  <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='off']" /></xsl:otherwise>
				  </xsl:choose>
			  </span>
			  <br />

			  <span class="whiteSpacer">&#160;</span>
			  <br />

			  <table cellpadding="0" cellspacing="0" border="0" align="center">
				  <tr>
					  <td>

						  <div align="right">
							  <div class='buttonSet buttonsAreLeftAligned'>
								  <xsl:choose>
									  <xsl:when test="$netTrayStatusDoc//hpoa:interconnectTrayStatus/hpoa:powered=$POWER_ON">
										  <div class='bWrapperUp'>
											  <div>
												  <div>
													  <button type="button" class="hpButton" onclick="setNetTrayPower(false);">
														  <xsl:value-of select="$stringsDoc//value[@key='powerOff']" />
													  </button>
												  </div>
											  </div>
										  </div>
									  </xsl:when>
									  <xsl:otherwise>
										  <div class='bWrapperUp'>
											  <div>
												  <div>
													  <button type="button" class="hpButton" onclick="setNetTrayPower(true);">
														  <xsl:value-of select="$stringsDoc//value[@key='powerOn']" />
													  </button>
												  </div>
											  </div>
										  </div>
									  </xsl:otherwise>
								  </xsl:choose>

								  <xsl:element name="div">

									  <xsl:choose>
										  <xsl:when test="$powerState=$POWER_ON">
											  <xsl:attribute name="class">bWrapperUp</xsl:attribute>
										  </xsl:when>
										  <xsl:otherwise>
											  <xsl:attribute name="class">bWrapperDisabled</xsl:attribute>
										  </xsl:otherwise>
									  </xsl:choose>

									  <div>
										  <div>

											  <xsl:element name="button">

												  <xsl:attribute name="type">button</xsl:attribute>
												  <xsl:attribute name="class">hpButton</xsl:attribute>
												  <xsl:attribute name="onclick">resetNetTray();</xsl:attribute>

												  <xsl:if test="$powerState!=$POWER_ON">
													  <xsl:attribute name="disabled">true</xsl:attribute>
												  </xsl:if>
												  <xsl:value-of select="$stringsDoc//value[@key='reset']" />
												  
											  </xsl:element>
											  
										  </div>
									  </div>
									  
								  </xsl:element>
								  
							  </div>
						  </div>

					  </td>
				  </tr>
			  </table>
		  </div>

		  <span class="whiteSpacer">&#160;</span><br />
		  <span class="whiteSpacer">&#160;</span><br />
	  </xsl:if>

	  <xsl:value-of select="$stringsDoc//value[@key='virtualIndicator']" />
	  <br />
	  <span class="whiteSpacer">&#160;</span>
	  <br />

	  <div class="groupingBox">

		  <xsl:call-template name="uid">
			  <xsl:with-param name="uidState" select="$uidState" />
		  </xsl:call-template>

	  </div>
	  <br />
  </xsl:template>


</xsl:stylesheet>

