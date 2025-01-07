<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />
	<xsl:param name="activeSessionsDoc" />
	<xsl:param name="standbySessionsDoc" />

	<xsl:param name="activeBayNumber" />
	<xsl:param name="standbyBayNumber" />

	<xsl:param name="currentSessionCompare" />

	<xsl:template match="*">

		<!--
			This variable indicates whether or not we have any other users
			logged in besides ourself.
		-->
		<xsl:variable name="hasLoggedInUsers" select="count($activeSessionsDoc//hpoa:getOaSessionArrayResponse/hpoa:oaSession[substring(hpoa:session, string-length(hpoa:session)-3)!=$currentSessionCompare])&gt;0 or count($standbySessionsDoc//hpoa:getOaSessionArrayResponse/hpoa:oaSession)&gt;0"/>

		<xsl:value-of select="$stringsDoc//value[@key='signedInUserDesc']"/>
		<br />

		<span class="whiteSpacer">&#160;</span>
		<br />
		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<div class="errorDisplay" id="sessionErrorDisplay"></div>

		<xsl:value-of select="$stringsDoc//value[@key='currentSession']"/><br />

		<span class="whiteSpacer">&#160;</span>
		<br />

		<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" id="currentSessionTable">
			<thead>
				<tr class="captionRow">
					<th><xsl:value-of select="$stringsDoc//value[@key='username']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='ipAddress']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='age']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='idleTime']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='userType']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='sessionType']"/></th>
					<th><xsl:value-of select="$stringsDoc//value[@key='oaModule']"/></th>
				</tr>
			</thead>
			<TBODY>
				
				<xsl:for-each select="$activeSessionsDoc//hpoa:getOaSessionArrayResponse/hpoa:oaSession[substring(hpoa:session, string-length(hpoa:session)-3)=$currentSessionCompare]">
					<xsl:call-template name="sessionsRow">
						<xsl:with-param name="bayNumber" select="$activeBayNumber" />
						<xsl:with-param name="oaMode"><xsl:value-of select="$stringsDoc//value[@key='active']"/></xsl:with-param>
						<xsl:with-param name="isCurrentUser">true</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				
			</TBODY>
		</table>

		<xsl:if test="$hasLoggedInUsers">

			<span class="whiteSpacer">&#160;</span>
			<br />
			<span class="whiteSpacer">&#160;</span>
			<br />

			<xsl:value-of select="$stringsDoc//value[@key='otherSessions']"/><br />

			<span class="whiteSpacer">&#160;</span>
			<br />
      
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" id="activeSessionsTable">
				<thead>
					<tr class="captionRow">
						<th>
							<!--
							<xsl:if test="$hasLoggedInUsers">
								<input type="checkbox" id="summaryMaster" tableid="activeSessionsTable"/>
							</xsl:if>
							-->
						</th>
						<th><xsl:value-of select="$stringsDoc//value[@key='username']"/></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='ipAddress']"/></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='age']"/></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='idleTime']"/></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='userType']"/></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='sessionType']"/></th>
						<th><xsl:value-of select="$stringsDoc//value[@key='oaModule']"/></th>
					</tr>
				</thead>
				<TBODY>
					
					<xsl:for-each select="$activeSessionsDoc//hpoa:getOaSessionArrayResponse/hpoa:oaSession[(substring(hpoa:session, string-length(hpoa:session)-3)!=$currentSessionCompare) and hpoa:username != 'vcmuser_']">
						<xsl:call-template name="sessionsRow">
							<xsl:with-param name="bayNumber" select="$activeBayNumber" />
							<xsl:with-param name="oaMode"><xsl:value-of select="$stringsDoc//value[@key='active']"/></xsl:with-param>
							<xsl:with-param name="isCurrentUser">false</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:for-each select="$standbySessionsDoc//hpoa:getOaSessionArrayResponse/hpoa:oaSession">
						<xsl:call-template name="sessionsRow">
							<xsl:with-param name="bayNumber" select="$standbyBayNumber" />
							<xsl:with-param name="oaMode"><xsl:value-of select="$stringsDoc//value[@key='standby']"/></xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					
				</TBODY>
			</table>
			
			<span class="whiteSpacer">&#160;</span>
			<br />
			<div align="right">
				<div class='buttonSet'>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' disabled='true' class='hpButton' id="btnTerminate" onclick="terminateSessions();">
									<xsl:value-of select="$stringsDoc//value[@key='terminateSessions']"/>
								</button>
							</div>
						</div>
					</div>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' disabled='true' class='hpButton' id="btnDisable" onclick="doUserAction('disableUsers');">
									<xsl:value-of select="$stringsDoc//value[@key='disableUsers']"/>
								</button>
							</div>
						</div>
					</div>
					<div class='bWrapperUp'>
						<div>
							<div>
								<button type='button' disabled='true' class='hpButton' id="btnDelete" onclick="doUserAction('deleteUsers');">
									<xsl:value-of select="$stringsDoc//value[@key='deleteUsers']"/>
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>

		</xsl:if>
		
	</xsl:template>

	<xsl:template name="sessionsRow">

		<xsl:param name="bayNumber" />
		<xsl:param name="oaMode" />
		<xsl:param name="isCurrentUser" />
		
		<xsl:element name="tr">

			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="class">altRowColor</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isCurrentUser!='true'">
				<td class="checkboxCell">
					<xsl:element name="input">
						<xsl:attribute name="type">checkbox</xsl:attribute>
						<xsl:attribute name="sessionId">
							<xsl:value-of select="hpoa:session"/>
						</xsl:attribute>
						<xsl:attribute name="username">
							<xsl:value-of select="hpoa:username"/>
						</xsl:attribute>
            <xsl:attribute name="userType">
              <xsl:value-of select="hpoa:userType"/>
            </xsl:attribute>
						<xsl:attribute name="bayNumber">
							<xsl:value-of select="$bayNumber"/>
						</xsl:attribute>

						<xsl:attribute name="local">
							<xsl:choose>
								<xsl:when test="$isCurrentUser='true'">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<xsl:attribute name="onclick">sessionSelected();</xsl:attribute>
						
					</xsl:element>
				</td>
			</xsl:if>

			<td>
				<xsl:value-of select="hpoa:username"/>
			</td>
			<td>
				<xsl:value-of select="hpoa:ipAddress"/>
			</td>
			<td>
				<xsl:value-of select="hpoa:ageTime"/>
			</td>
			<td>
				<xsl:value-of select="hpoa:idleTime"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="hpoa:userType=0">
						<xsl:value-of select="$stringsDoc//value[@key='local']"/>
					</xsl:when>
					<xsl:when test="hpoa:userType=1">
						LDAP
					</xsl:when>
					<xsl:when test="hpoa:userType=2">
						HP SSO
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$stringsDoc//value[@key='statusUnknown']"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="hpoa:extraData[@hpoa:name='sType']='SOAP'">
						<xsl:value-of select="$stringsDoc//value[@key='stypeSoap']"/>
					</xsl:when>
					<xsl:when test="hpoa:extraData[@hpoa:name='sType']='SSH'">
						<xsl:value-of select="$stringsDoc//value[@key='stypeSsh']"/>
					</xsl:when>
					<xsl:when test="hpoa:extraData[@hpoa:name='sType']='TELNET'">
						<xsl:value-of select="$stringsDoc//value[@key='stypeTelnet']"/>
					</xsl:when>
					<xsl:when test="hpoa:extraData[@hpoa:name='sType']='KVM'">
						<xsl:value-of select="$stringsDoc//value[@key='stypeKvm']"/>
					</xsl:when>
					<xsl:when test="hpoa:extraData[@hpoa:name='sType']='SERIAL'">
						<xsl:value-of select="$stringsDoc//value[@key='stypeSerial']"/>
					</xsl:when>
					<xsl:when test="hpoa:extraData[@hpoa:name='sType']='SOAP_FACTORY'">
						<xsl:value-of select="$stringsDoc//value[@key='stypeFactory']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$stringsDoc//value[@key='unknown']"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="$oaMode"/>&#160;(bay <xsl:value-of select="$bayNumber"/>)
			</td>
			
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>