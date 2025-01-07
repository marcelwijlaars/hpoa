<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="userOverview" match="*">
		
		<div id="secObjectContainer">
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td valign="top">

						<table border="0" cellpadding="0" cellspacing="0" class="dataTable tableHasCheckboxes" id="secObjOverviewTable">
							<thead>
								<tr class="captionRow">
									<th class="checkboxCell">&#160;</th>
									<th><xsl:value-of select="$stringsDoc//value[@key='username']" /></th>
									<th><xsl:value-of select="$stringsDoc//value[@key='privilegeLevel']" /></th>
									<th><xsl:value-of select="$stringsDoc//value[@key='fullName']" /></th>
									<th><xsl:value-of select="$stringsDoc//value[@key='contact']" /></th>
									<th><xsl:value-of select="$stringsDoc//value[@key='accountStatus']" /></th>
								</tr>
							</thead>
							<tbody>
								
								<xsl:for-each select="$usersDoc//hpoa:userInfo">
									<xsl:if test="hpoa:acl!=$ANONYMOUS">
										<tr>
											<td class="checkboxCell">
												<xsl:element name="input">
													<xsl:attribute name="type">checkbox</xsl:attribute>
													<xsl:attribute name="rowselector">no</xsl:attribute>
													<xsl:attribute name="secObjId">
														<xsl:value-of select="hpoa:username"/>
													</xsl:attribute>
												</xsl:element>
											</td>
											<td>
												<xsl:value-of select="hpoa:username"/>
											</td>
											<td>
												<xsl:value-of select="hpoa:acl"/>
											</td>
											<td>
												<xsl:value-of select="hpoa:fullname"/>
											</td>
											<td>
												<xsl:value-of select="hpoa:contactInfo"/>
											</td>
											<td>
												<xsl:choose>
													<xsl:when test="hpoa:isEnabled='true'">
														<xsl:value-of select="$stringsDoc//value[@key='enabled']" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$stringsDoc//value[@key='disabled']" />
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</xsl:if>

								</xsl:for-each>

							</tbody>
						</table>
						
					</td>
				</tr>
			</table>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

