<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
    
    Original SNMP Alerts Form prior to SNMPv3 implementation
	-->
  
  <xsl:variable name="snmpv3TrapCount">
  <xsl:choose>
    <xsl:when test="$snmpv3Supported='true'">
      <xsl:copy-of select="count($snmpInfo3Doc//hpoa:snmpInfo3/hpoa:traps/hpoa:trapInfo)" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="0" />
    </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:variable name="snmpTrapCount">
    <xsl:copy-of select="count($snmpInfoDoc//hpoa:snmpInfo/hpoa:traps/hpoa:trapInfo)" />
  </xsl:variable>
  
  <xsl:template name="SNMPAlerts">
    <xsl:param name="isWizard" select="'false'" />
    
    <xsl:variable name="fipsEnabled" select="$networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-ON' or $networkInfoDoc//hpoa:extraData[@hpoa:name='FipsMode'] = 'FIPS-DEBUG'" />
    
    <xsl:choose>
      <xsl:when test="$serviceUserAcl != $USER">
        <div id="trapContent">
          <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
              <td valign="top">

                <table border="0" cellpadding="0" cellspacing="0" class="dataTable tableHasCheckboxes" onclick="updateCheckboxTableButtons(this.getElementsByTagName('input'), ['deleteSnmpTrapButton']);" id="snmpTrapTable">
                  <thead>
                    <tr class="captionRow" style="cursor:default;">
                      <th class="checkboxCell" width="10">
                        <xsl:if test="($snmpv3TrapCount + $snmpTrapCount) &gt; 0">
                          <input type="checkbox" id="summaryMaster" tableid="snmpTrapTable"/>
                        </xsl:if>
                      </th>
                      <th>
                        <xsl:value-of select="$stringsDoc//value[@key='snmpVersion']" />
                      </th>
                      <th>
                        <xsl:value-of select="$stringsDoc//value[@key='destination']" />
                      </th>
                      <th>
                        <xsl:value-of select="$stringsDoc//value[@key='community']" />
                      </th>
                      <th>
                        <xsl:value-of select="$stringsDoc//value[@key='userAndEngineID']" />
                      </th>
                      <th>
                        <xsl:value-of select="$stringsDoc//value[@key='security']" />
                      </th>
                      <th>
                        <xsl:value-of select="$stringsDoc//value[@key='inform']" />
                      </th>
                    </tr>
                  </thead>
                  <tbody>

                    <xsl:if test="$snmpv3TrapCount + $snmpTrapCount = 0">
                      <tr>
                        <td colspan="7" align="center">
                          <xsl:value-of select="$stringsDoc//value[@key='noAlerts']" />
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:for-each select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:traps/hpoa:trapInfo">
                      <tr style="cursor:default;">
                        <td class="checkboxCell">
                          <xsl:element name="input">
                            <xsl:attribute name="type">checkbox</xsl:attribute>
                            <xsl:attribute name="rowselector">yes</xsl:attribute>
                            <xsl:attribute name="secObjVersion">v1</xsl:attribute>
                            <xsl:attribute name="secObjHost">
                              <xsl:value-of select="hpoa:ipAddress"/>
                            </xsl:attribute>
                            <xsl:attribute name="secObjCommunity">
                              <xsl:value-of select="hpoa:community"/>
                            </xsl:attribute>
                          </xsl:element>
                        </td>
                        <td>
                          <xsl:value-of select="$stringsDoc//value[@key='SnmpVersion12c']" />
                        </td>
                        <td>
                          <xsl:value-of select="hpoa:ipAddress"/>
                        </td>
                        <td>
                          <xsl:value-of select="hpoa:community"/>
                        </td>
                        <td>
                          <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                        </td>
                        <td>
                          <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                        </td>                        
                        <td>
                          <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:if test="$snmpv3Supported='true'">
                      <xsl:for-each select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:traps/hpoa:trapInfo">
                        <xsl:variable name="cur-security" select="concat('TRAP-',hpoa:security)" />
                        <xsl:variable name="cur-inform" select="hpoa:inform" />

                        <tr style="cursor:default;">
                          <td class="checkboxCell">
                            <xsl:element name="input">
                              <xsl:attribute name="type">checkbox</xsl:attribute>
                              <xsl:attribute name="rowselector">yes</xsl:attribute>
                              <xsl:attribute name="secObjVersion">v3</xsl:attribute>
                              <xsl:attribute name="secObjHost">
                                <xsl:value-of select="hpoa:ipAddress"/>
                              </xsl:attribute>
                              <xsl:attribute name="secObjUser">
                                <xsl:value-of select="hpoa:user"/>
                              </xsl:attribute>
                              <xsl:attribute name="secObjEngineId">
                                <!-- 
                                  for internal use, engine id first, for display, user first 
                                  set engine ids that match current oa to be blank
                                  when sent to back end code, correct local engine id will be substitued
                                -->
                                <xsl:choose>
                                  <xsl:when test="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:engineid = hpoa:engineid">
                                    <xsl:value-of select="''"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="hpoa:engineid"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </xsl:element>
                          </td>
                          <td>
                            <xsl:value-of select="$stringsDoc//value[@key='SnmpVersion3']" />
                          </td>
                          <td>
                            <xsl:value-of select="hpoa:ipAddress"/>
                          </td>                                                      
                          <td>
                            <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                          </td>
                          <td>
                            <xsl:value-of select="hpoa:user"/> - <xsl:value-of select="hpoa:engineid"/>
                          </td>
                          <td>
                            <xsl:value-of select="$stringsDoc//value[@key=$cur-security]" />
                          </td>
                          <td>
                            <xsl:choose>
                              <xsl:when test="$cur-inform='true'">
                                <xsl:value-of select="$stringsDoc//value[@key='yes']" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$stringsDoc//value[@key='no']" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                        </tr>
                      </xsl:for-each>
                    </xsl:if>
                  </tbody>
                </table>               
              </td>
            </tr>
          </table>
        </div>
      </xsl:when>
      <xsl:otherwise>

        <table border="0" cellpadding="0" cellspacing="0" class="dataTable tableHasCheckboxes" id="snmpTrapTable">
          <thead>            
            <tr class="captionRow">
              <th>
                <xsl:value-of select="$stringsDoc//value[@key='snmpVersion']" />                
              </th>
              <th>
                <xsl:value-of select="$stringsDoc//value[@key='destination']" />
              </th>
              <th>
                <xsl:value-of select="$stringsDoc//value[@key='community']" />
              </th>
              <th>
                <xsl:value-of select="$stringsDoc//value[@key='userAndEngineID']" />
              </th>
              <th>
                <xsl:value-of select="$stringsDoc//value[@key='security']" />
              </th>
              <th>
                <xsl:value-of select="$stringsDoc//value[@key='inform']" />
              </th>
            </tr>
          </thead>
          <tbody>

            <xsl:if test="$snmpv3TrapCount + $snmpTrapCount = 0">
              <tr>
                <td colspan="6" align="center">
                  <xsl:value-of select="$stringsDoc//value[@key='noAlerts']" />
                </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="$snmpInfoDoc//hpoa:snmpInfo/hpoa:traps/hpoa:trapInfo">
              <tr>
                <td>
                  <xsl:value-of select="$stringsDoc//value[@key='SnmpVersion12c']" />
                </td>
                <td>
                  <xsl:value-of select="hpoa:ipAddress"/>
                </td>
                <td>
                  <xsl:value-of select="hpoa:community"/>
                </td>
                <td>
                  <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                </td>
                <td>
                  <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                </td>
                <td>
                  <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:if test="$snmpv3Supported='true'">
              <xsl:for-each select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:traps/hpoa:trapInfo">
                <xsl:variable name="cur-security" select="concat('TRAP-',hpoa:security)" />
                <xsl:variable name="cur-inform" select="hpoa:inform" />

                <tr>
                  <td>
                    <xsl:value-of select="$stringsDoc//value[@key='SnmpVersion3']" />
                  </td>
                  <td>
                    <xsl:value-of select="hpoa:ipAddress"/>
                  </td>
                  <td>
                    <xsl:value-of select="$stringsDoc//value[@key='n/a']" />
                  </td>
                  <td>
                    <xsl:value-of select="hpoa:user"/> - <xsl:value-of select="hpoa:engineid"/>
                  </td>
                  <td>
                    <xsl:value-of select="$stringsDoc//value[@key=$cur-security]" />
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$cur-inform='true'">
                        <xsl:value-of select="$stringsDoc//value[@key='yes']" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$stringsDoc//value[@key='no']" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:for-each>
            </xsl:if>
          </tbody>
        </table>

      </xsl:otherwise>
    </xsl:choose>
    
    <span class="whiteSpacer">&#160;</span>
    <br />
    <xsl:if test="$serviceUserAcl != $USER">
      <div class="buttonSet">
        <div class="bWrapperUp">
          <div>
            <div>
              <xsl:element name="button">
                <xsl:attribute name="class">hpButton</xsl:attribute>
                <xsl:attribute name="id">deleteSnmpTrapButton</xsl:attribute>
                <xsl:attribute name="onclick">
                  <xsl:choose>
                    <xsl:when test="$isWizard = 'true'">wizRemoveTrapDestinations()</xsl:when>
                    <xsl:otherwise>removeTrapDestinations()</xsl:otherwise>
                  </xsl:choose>                  
                </xsl:attribute>
                <xsl:attribute name="disabled">true</xsl:attribute>
                <!-- always disabled until rows selected -->
                <xsl:value-of select="$stringsDoc//value[@key='delete']" />
              </xsl:element>
            </div>
          </div>
        </div>
        <div class="bWrapperUp">
          <div>
            <div>
              <xsl:element name="button">
                <xsl:attribute name="class">hpButton</xsl:attribute>
                <xsl:attribute name="id">newSnmpTrapButton</xsl:attribute>
                <xsl:attribute name="onclick">
                  <xsl:choose>
                    <xsl:when test="$isWizard = 'true'">wizAddSnmpTrapPage()</xsl:when>
                    <xsl:otherwise>addSnmpTrapPage()</xsl:otherwise>
                  </xsl:choose>                  
                </xsl:attribute>                 
                <xsl:if test="$fipsEnabled and $snmpv3Supported != 'true'">
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$stringsDoc//value[@key='new']" />
              </xsl:element>
            </div>
          </div>
        </div>
      </div>
      <div class="clearFloats"></div>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>


