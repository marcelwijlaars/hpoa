<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	<xsl:param name="ldapInfoDoc" />
	<xsl:param name="stringsDoc" />
	<xsl:include href="../Templates/guiConstants.xsl" />
	
	<xsl:template match="*">

		<xsl:choose>
			<xsl:when test="count($ldapInfoDoc//hpoa:ldapInfo/hpoa:certificates/hpoa:certificate) &gt; 0">

				<xsl:for-each select="$ldapInfoDoc//hpoa:ldapInfo/hpoa:certificates/hpoa:certificate">

					<table class="dataTable" cellpadding="0" cellspacing="0" border="0">
						<tr class="altRowColor">
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certIssuedTo']" /></th>
							<td class="propertyValue">
								<xsl:value-of select="hpoa:subjectCommonName"/>
							</td>
						</tr>
						<tr>
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certIssuedBy']" /></th>
							<td>
								<xsl:value-of select="hpoa:issuerCommonName"/>
							</td>
						</tr>
						<tr class="altRowColor">
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certValidFrom']" /></th>
							<td>
								<xsl:value-of select="hpoa:validFrom"/>
							</td>
						</tr>
						<tr>
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='certValidUntil']" /></th>
							<td>
								<xsl:value-of select="hpoa:validTo"/>
							</td>
						</tr>
						<tr class="altRowColor">
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='serialNumber']" /></th>
							<td>
								<xsl:value-of select="hpoa:serialNumber"/>
							</td>
						</tr>
						<tr>
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='version']" /></th>
							<td class="propertyValue">
								<xsl:value-of select="hpoa:certificateVersion"/>
							</td>
						</tr>
						<tr class="altRowColor">
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='md5Fingerprint']" /></th>
							<td>
								<xsl:value-of select="hpoa:md5Fingerprint"/>
							</td>
						</tr>
						<tr>
							<th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='sha1Fingerprint']" /></th>
							<td class="propertyValue">
								<xsl:value-of select="hpoa:sha1Fingerprint"/>
							</td>
						</tr>
						<xsl:if test="not(hpoa:extraData[@hpoa:name='algorithm'])= false()">
		                <tr class="altRowColor">
        		            <th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='publicKey']" /></th>
                		    <td class="propertyValue">
                        		<xsl:choose>
                            		<xsl:when test="hpoa:extraData[@hpoa:name='algorithm']!='Unknown'">
                                		<xsl:value-of select="hpoa:extraData[@hpoa:name='algorithm']"/>
		                            </xsl:when>
    		                        <xsl:otherwise>
        		                        <xsl:value-of select="$stringsDoc//value[@key='statusUnknown']" />
            		                </xsl:otherwise>
                		        </xsl:choose>
                    		    <xsl:choose>
                        		    <xsl:when test="hpoa:extraData[@hpoa:name='keyStrength']!='0'">
                            		    <xsl:value-of select="concat(' (', hpoa:extraData[@hpoa:name='keyStrength'], ' ', $stringsDoc//value[@key='bits'], ')')"/>
		                            </xsl:when>
    		                    </xsl:choose>
        		            </td>
           	    		</tr>
                		</xsl:if>
					</table>

					<span class="whiteSpacer">&#160;</span>
					<br />
					<div align="right">
						<div class='buttonSet'>
							<div class='bWrapperUp'>
								<div>
									<div>
										<xsl:element name='button'>
											<xsl:attribute name='type'>button</xsl:attribute>
											<xsl:attribute name='class'>hpButton</xsl:attribute>
											<xsl:attribute name='id'>btnRemoveCertificate</xsl:attribute>
											<xsl:attribute name='onclick'>removeCertificate('<xsl:value-of select='hpoa:md5Fingerprint'/>');</xsl:attribute>
											<xsl:value-of select="$stringsDoc//value[@key='remove']" />
										</xsl:element>
										
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<xsl:if test="position() != last()">
						<span class="whiteSpacer">&#160;</span>
						<br />
						<span class="whiteSpacer">&#160;</span>
						<br />
					</xsl:if>

				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stringsDoc//value[@key='noLDAPAvailable']" />
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>
