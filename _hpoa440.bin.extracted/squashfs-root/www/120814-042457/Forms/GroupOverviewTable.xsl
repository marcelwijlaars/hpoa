<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:include href="../Templates/escape-uri.xsl" />
	
	<xsl:template name="groupOverview" match="*">

		<xsl:param name="doEscape" select="'true'" />
		
		<div id="secObjectContainer">
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td valign="top">

						<table border="0" cellpadding="0" cellspacing="0" class="dataTable tableHasCheckboxes" id="secObjOverviewTable">
							<thead>
								<tr class="captionRow">
									<th class="checkboxCell">&#160;</th>
									<th><xsl:value-of select="$stringsDoc//value[@key='groupName']" /></th>
									<th><xsl:value-of select="$stringsDoc//value[@key='privilegeLevel']" /></th>
									<th><xsl:value-of select="$stringsDoc//value[@key='description']" /></th>
								</tr>
							</thead>
							<tbody>
								<xsl:choose>

									<xsl:when test="count($groupsDoc//hpoa:ldapGroupInfo)&gt;0">
										<xsl:for-each select="$groupsDoc//hpoa:ldapGroupInfo">
											
											<xsl:variable name="groupNameURI">
												<xsl:choose>
													<xsl:when test="$doEscape='true'">
														<xsl:call-template name="my-escape-uri">
															<xsl:with-param name="str" select="hpoa:ldapGroupName"/>
															<xsl:with-param name="allow-utf8" select="true()"/>
															<xsl:with-param name="escape-amp" select="true()"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="hpoa:ldapGroupName"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											
											<tr>
												<td class="checkboxCell">
													<xsl:element name="input">
														<xsl:attribute name="type">checkbox</xsl:attribute>
														<xsl:attribute name="rowselector">no</xsl:attribute>
														<xsl:attribute name="secObjId"><xsl:value-of select="$groupNameURI"/></xsl:attribute>
													</xsl:element>
												</td>
												<td>
													<xsl:value-of select="hpoa:ldapGroupName"/>
												</td>
												<td>
													<xsl:value-of select="hpoa:acl"/>
												</td>
												<td>
													<xsl:value-of select="hpoa:description"/>
												</td>
											</tr>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<tr class="noDataRow">
											<td colspan="4"><xsl:value-of select="$stringsDoc//value[@key='noDirectoryGroup']" /></td>
										</tr>
									</xsl:otherwise>
								</xsl:choose>
								
							</tbody>
						</table>
						
					</td>
				</tr>
			</table>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

