<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
    <xsl:template name="dateTimeForm" match="*">
		
		  <xsl:param name="labelCellWidth">60</xsl:param>
      
          <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            
			<xsl:variable name="dateTimeString" select="$dateTimeDoc//hpoa:enclosureTime/hpoa:dateTime" />
			  
			<xsl:variable name="ntpEnabled">
				<xsl:choose>
					<xsl:when test="$isWizard='true'"><xsl:value-of select="'false'"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpEnabled" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

            <TR>
                <td id="dateLabel" width="{number($labelCellWidth)}">
					<xsl:value-of select="$stringsDoc//value[@key='date:']" />
                </td>
				<td width="10">&#160;</td>
                <TD>
                    <xsl:element name="input">
                        <xsl:attribute name="class">stdInput</xsl:attribute>
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:attribute name="id">date</xsl:attribute>
                        <xsl:attribute name="name">date</xsl:attribute>
						            <xsl:if test="$serviceUserAcl = $USER">
							            <xsl:attribute name="readonly">true</xsl:attribute>
						            </xsl:if>
                        <xsl:attribute name="value">
                            <xsl:value-of select="substring-before($dateTimeString, 'T')" />
                        </xsl:attribute>
                      <!-- validation -->
                      <xsl:attribute name="validate-datetime">true</xsl:attribute>
                      <xsl:attribute name="rule-list">1</xsl:attribute>
                      <xsl:attribute name="caption-label">dateLabel</xsl:attribute>

						<xsl:attribute name="maxlength">10</xsl:attribute>

						<xsl:choose>
							<xsl:when test="not($ntpEnabled='true')">
								<xsl:attribute name="class">stdInput</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						
                    </xsl:element>
                </TD>
            </TR>
            <tr>
                <td colspan="3" class="formSpacer">&#160;</td>
            </tr>
            <TR>
                <td id="timeLabel">
					<xsl:value-of select="$stringsDoc//value[@key='time:']" />
				</td>
				<td width="10">&#160;</td>
				<TD>
					<xsl:variable name="timeString" select="substring(substring-after($dateTimeString, 'T'), 1, 5)" />
					
					<xsl:element name="input">
						<xsl:attribute name="class">stdInput</xsl:attribute>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="id">time</xsl:attribute>
						<xsl:attribute name="name">time</xsl:attribute>
						<xsl:if test="$serviceUserAcl = $USER">
							<xsl:attribute name="readonly">true</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="contains($timeString, '-')">
									<xsl:value-of select="substring-before($timeString, '-')" />
								</xsl:when>
								<xsl:when test="contains($timeString, '+')">
									<xsl:value-of select="substring-before($timeString, '+')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$timeString" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<xsl:choose>
							<xsl:when test="not($ntpEnabled='true')">
								<xsl:attribute name="class">stdInput</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						
						<xsl:attribute name="maxlength">8</xsl:attribute>
						
						<!-- validation -->
						<xsl:attribute name="validate-datetime">true</xsl:attribute>
						<xsl:attribute name="rule-list">1</xsl:attribute>
						<xsl:attribute name="caption-label">timeLabel</xsl:attribute>
					</xsl:element>
				</TD>
			</TR>
			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>

			  <xsl:choose>

				  <xsl:when test="count(//hpoa:timeZoneArray/hpoa:timeZone) &gt; 0">
						
					  <TR>
						  <TD>
							  <span id="timeZoneLabel">
								  <xsl:value-of select="$stringsDoc//value[@key='timeZone:']" />
							  </span>
						  </TD>
						  <td width="10">&#160;</td>
						  <TD>

							  <xsl:variable name="currentTimeZone" select="$dateTimeDoc//hpoa:enclosureTime/hpoa:timeZone" />

							  <xsl:for-each select="//hpoa:timeZoneArray">
								  
								  <xsl:element name="select">

									  <xsl:attribute name="id">tz_list</xsl:attribute>

									  <xsl:if test="$ntpEnabled='true'">
										  <xsl:attribute name="disabled">true</xsl:attribute>
									  </xsl:if>

									  <xsl:for-each select="//hpoa:timeZoneArray/hpoa:timeZone">

										  <xsl:sort select="current()" data-type="text"/>

										  <xsl:element name="option">

											  <xsl:attribute name="value">
												  <xsl:value-of select="current()"/>
											  </xsl:attribute>

											  <xsl:if test="current() = $currentTimeZone">
												  <xsl:attribute name="selected">true</xsl:attribute>
											  </xsl:if>

											  <xsl:value-of select="current()"/>

										  </xsl:element>

									  </xsl:for-each>

								  </xsl:element>
								  
							  </xsl:for-each>
							  
						  </TD>
					  </TR>
				  </xsl:when>
				  <xsl:otherwise>

					  <TR>
						  <TD>
							  <span id="timeZoneLabel">
								  <xsl:value-of select="$stringsDoc//value[@key='timeZone:']" />
							  </span>
						  </TD>
						  <td width="10">&#160;</td>
						  <TD>
							  <xsl:element name="input">
								  <xsl:attribute name="class">stdInput</xsl:attribute>
								  <xsl:attribute name="type">text</xsl:attribute>
								  <xsl:attribute name="id">timeZone</xsl:attribute>
								  <xsl:attribute name="name">timeZone</xsl:attribute>
								  <xsl:if test="$serviceUserAcl = $USER">
									  <xsl:attribute name="readonly">true</xsl:attribute>
								  </xsl:if>
								  <xsl:attribute name="value">
									  <xsl:value-of select="$dateTimeDoc//hpoa:enclosureTime/hpoa:timeZone" />
								  </xsl:attribute>

								  <xsl:attribute name="maxlength">39</xsl:attribute>

							  </xsl:element>&#160;

							  <a href="javascript:void(0);" onclick="top.mainPage.getHelpLauncher().openContextHelp();">Click here</a> for a list of valid time zones.

						  </TD>
					  </TR>
					  
				  </xsl:otherwise>
				  
			  </xsl:choose>
				
		</TABLE>
	</xsl:template>

	<xsl:template name="NTPForm">

		<xsl:variable name="ntpEnabled">
			<xsl:choose>
				<xsl:when test="$isWizard='true'"><xsl:value-of select="'false'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpEnabled" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" id="ntpTable">
			<TR>
				<TD>
					<xsl:element name="span">
						<xsl:attribute name="id">ntpLabel1</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='primaryNtpServer:']" />
          </xsl:element>
        </TD>
        <TD width="10">&#160;</TD>
        <TD>
          <xsl:element name="input">
            <xsl:choose>
              <xsl:when test="$ntpEnabled='true'">
                  <xsl:attribute name="class">stdInput</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                  <xsl:attribute name="disabled">true</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="id">ntp1</xsl:attribute>
            <xsl:attribute name="name">ntp1</xsl:attribute>
	    <xsl:attribute name="style">width:290px</xsl:attribute>	
            <!-- validation: required String No Space -->
            <xsl:attribute name="validate-ntp">true</xsl:attribute>                       
            <xsl:attribute name="rule-list">6;8</xsl:attribute> 
            <xsl:attribute name="caption-label">ntpLabel1</xsl:attribute>
            <xsl:if test="$serviceUserAcl = $USER">
              <xsl:attribute name="readonly">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpServers//hpoa:ipAddress[position()=1] != $EMPTY_IP_TEST">
              <xsl:attribute name="value">
	              <xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpServers//hpoa:ipAddress[position()=1]" />
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="maxlength">64</xsl:attribute>
	  </xsl:element>
          </TD>
        </TR>
	<tr>
	  <td colspan="2" class="formSpacer">&#160;</td>
	  <td>
	  <xsl:value-of select="$stringsDoc//value[@key='ipDnsExample']" /> 
	</td>
        </tr>
		  <br />
        <TR>
        <TD>
                    <xsl:element name="span">
                        <xsl:attribute name="id">ntpLabel2</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='secondaryNtpServer:']" />
					</xsl:element>
				</TD>
				<TD width="10">&#160;</TD>
				<TD>
					<xsl:element name="input">
						<xsl:choose>
							<xsl:when test="$ntpEnabled='true'">
								<xsl:attribute name="class">stdInput</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">stdInputDisabled</xsl:attribute>
								<xsl:attribute name="disabled">true</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:attribute name="id">ntp2</xsl:attribute>
						<xsl:attribute name="name">ntp2</xsl:attribute>
						<xsl:attribute name="style">width:290px</xsl:attribute>
            <!-- validation: Optional String  NoSpace -->
            <xsl:attribute name="validate-ntp">true</xsl:attribute>                  
            <xsl:attribute name="rule-list">0;6;8</xsl:attribute> 
            <xsl:attribute name="caption-label">ntpLabel2</xsl:attribute>
						<xsl:if test="$serviceUserAcl = $USER">
							<xsl:attribute name="readonly">true</xsl:attribute>
						</xsl:if>
						<xsl:if test="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpServers//hpoa:ipAddress[position()=2] != $EMPTY_IP_TEST">
							<xsl:attribute name="value">
								<xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpServers//hpoa:ipAddress[position()=2]" />
							</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="maxlength">64</xsl:attribute>
						
					</xsl:element>
				</TD>
			</TR>
	<tr>
	  <td colspan="2" class="formSpacer">&#160;</td>
	  <td>
	  <xsl:value-of select="$stringsDoc//value[@key='ipDnsExample']" /> 
	</td>
        </tr>
		  <br />
 			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>
			<TR>
				<TD>
					<span id="pollInvervalLabel">
						<xsl:value-of select="$stringsDoc//value[@key='pollInterval:']" />
          </span>
          </TD>
          <TD width="10">&#160;</TD>
          <TD>
            <xsl:element name="input">
                <xsl:choose>
                    <xsl:when test="$ntpEnabled='true'">
                        <xsl:attribute name="class">stdInput</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">stdInputDisabled</xsl:attribute>
                        <xsl:attribute name="disabled">true</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="id">pollInterval</xsl:attribute>
                <xsl:attribute name="name">pollInterval</xsl:attribute>
                <!-- validation: integer between 60 and 86400 (seconds)-->
                <xsl:attribute name="validate-ntp">true</xsl:attribute>                          
                <xsl:attribute name="rule-list">9</xsl:attribute>
                <xsl:attribute name="range">60;86400</xsl:attribute>
                <xsl:attribute name="caption-label">pollInvervalLabel</xsl:attribute>
		            <xsl:if test="$serviceUserAcl = $USER">
			            <xsl:attribute name="readonly">true</xsl:attribute>
		            </xsl:if>
                <xsl:attribute name="value">
                    <xsl:value-of select="$networkInfoDoc//hpoa:enclosureNetworkInfo/hpoa:ntpPoll" />
                </xsl:attribute>

		            <xsl:attribute name="maxlength">15</xsl:attribute>
		
            </xsl:element>&#160;&#160;<xsl:value-of select="$stringsDoc//value[@key='seconds']" />
			</TD>
            </TR>
			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>

			  <xsl:choose>

				  <xsl:when test="count(//hpoa:timeZoneArray/hpoa:timeZone) &gt; 0">
						
					  <TR>
						  <TD>
							  <span id="timeZoneLabel">
								  <xsl:value-of select="$stringsDoc//value[@key='timeZone:']" />
							  </span>
						  </TD>
						  <td width="10">&#160;</td>
						  <TD>

							  <xsl:variable name="currentTimeZone" select="$dateTimeDoc//hpoa:enclosureTime/hpoa:timeZone" />

							  <xsl:for-each select="//hpoa:timeZoneArray">
								  
								  <xsl:element name="select">

									  <xsl:attribute name="id">tz_list_ntp</xsl:attribute>

									  <xsl:if test="not($ntpEnabled='true')">
										  <xsl:attribute name="disabled">true</xsl:attribute>
									  </xsl:if>

									  <xsl:for-each select="//hpoa:timeZoneArray/hpoa:timeZone">

										  <xsl:sort select="current()" data-type="text"/>

										  <xsl:element name="option">

											  <xsl:attribute name="value">
												  <xsl:value-of select="current()"/>
											  </xsl:attribute>

											  <xsl:if test="current() = $currentTimeZone">
												  <xsl:attribute name="selected">true</xsl:attribute>
											  </xsl:if>

											  <xsl:value-of select="current()"/>

										  </xsl:element>

									  </xsl:for-each>

								  </xsl:element>
								  
							  </xsl:for-each>
							  
						  </TD>
					  </TR>
				  </xsl:when>
				  <xsl:otherwise>

					  <TR>
						  <TD>
							  <span id="timeZoneLabel">
								  <xsl:value-of select="$stringsDoc//value[@key='timeZone:']" />
							  </span>
						  </TD>
						  <td width="10">&#160;</td>
						  <TD>
							  <xsl:element name="input">
								  <xsl:attribute name="class">stdInput</xsl:attribute>
								  <xsl:attribute name="type">text</xsl:attribute>
								  <xsl:attribute name="id">timeZone_ntp</xsl:attribute>
								  <xsl:attribute name="name">timeZone_ntp</xsl:attribute>
								  <xsl:if test="$serviceUserAcl = $USER">
									  <xsl:attribute name="readonly">true</xsl:attribute>
								  </xsl:if>
								  <xsl:attribute name="value">
									  <xsl:value-of select="$dateTimeDoc//hpoa:enclosureTime/hpoa:timeZone" />
								  </xsl:attribute>

								  <xsl:attribute name="maxlength">39</xsl:attribute>

							  </xsl:element>&#160;

							  <a href="javascript:void(0);" onclick="top.mainPage.getHelpLauncher().openContextHelp();">Click here</a> for a list of valid time zones.

						  </TD>
					  </TR>
					  
				  </xsl:otherwise>
				  
			  </xsl:choose>
        </TABLE>

    </xsl:template>
	
</xsl:stylesheet>

