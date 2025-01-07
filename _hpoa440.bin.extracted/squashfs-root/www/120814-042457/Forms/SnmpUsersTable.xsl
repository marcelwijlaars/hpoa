<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <xsl:template name="snmpUserOverview" match="*">
    <xsl:param name="isWizard" select="'false'" />

    <div id="snmpUserContainer">
      <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
          <td valign="top">

            <table border="0" cellpadding="0" cellspacing="0" class="dataTable tableHasCheckboxes" onclick="updateCheckboxTableButtons(this.getElementsByTagName('input'), ['deleteSnmpUserButton']);" id="snmpUserTable">
              <thead>
                <!-- user name, engineid, auth protocol, priv protocol, security, accces (checkbox?)-->
                <tr class="captionRow" style="cursor:default;">
                  <xsl:if  test="$serviceUserAcl != $USER">
                    <th class="checkboxCell" width="10">
                      <xsl:if test="count($snmpInfo3Doc//hpoa:userInfo) &gt; 0">
                          <input type="checkbox" id="summaryMaster" tableid="snmpUserTable"/>
                        </xsl:if>
                    </th>
                  </xsl:if>
                  <th>
                    <xsl:value-of select="$stringsDoc//value[@key='username']" />
                  </th>
                  <th>
                    <xsl:value-of select="$stringsDoc//value[@key='snmpAuthentication']" />
                  </th>
                  <th>
                    <xsl:value-of select="$stringsDoc//value[@key='snmpPrivacy']" />
                  </th>
                  <th>
                    <xsl:value-of select="$stringsDoc//value[@key='snmpSecurity']" />
                  </th>
                  <th>
                    <xsl:value-of select="$stringsDoc//value[@key='snmpAccess']" />
                  </th>
                  <th>
                    <xsl:value-of select="$stringsDoc//value[@key='snmpLocal']" />
                  </th>
                  <th>
                    <xsl:value-of select="$stringsDoc//value[@key='engineID']" />
                  </th>
                </tr>
              </thead>
              <tbody>

                <xsl:if test="count($snmpInfo3Doc//hpoa:userInfo) = 0">
                  <tr>
                    <xsl:element name="td">
                      <xsl:choose>
                        <xsl:when test="$serviceUserAcl != $USER">
                          <xsl:attribute name="colspan">8</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="colspan">7</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:attribute name="align">center</xsl:attribute>
                      <xsl:value-of select="$stringsDoc//value[@key='noSnmpUsers']" />
                    </xsl:element>
                  </tr>
                </xsl:if>
                
                <xsl:variable name="snmp-engineid" select="$snmpInfo3Doc//hpoa:snmpInfo3/hpoa:engineid" />
                
                <xsl:for-each select="$snmpInfo3Doc//hpoa:userInfo">
                  <xsl:variable name="cur-auth" select="hpoa:authProtocol" />
                  <xsl:variable name="cur-priv" select="hpoa:privProtocol" />
                  <xsl:variable name="cur-security" select="hpoa:security" />
                  <xsl:variable name="cur-access" select="hpoa:access" />
                  <xsl:variable name="cur-engineid" select="hpoa:engineid" />
                  <tr style="cursor:default;">
                    <xsl:if  test="$serviceUserAcl != $USER">
                      <td class="checkboxCell">
                        <xsl:element name="input">
                          <xsl:attribute name="type">checkbox</xsl:attribute>
                          <xsl:attribute name="rowselector">yes</xsl:attribute>
                          <xsl:attribute name="secObjId">
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
                    </xsl:if>
                    <td>
                      <xsl:value-of select="hpoa:user"/>
                    </td>                    
                    <td>
                      <xsl:value-of select="$stringsDoc//value[@key=$cur-auth]" />                      
                    </td>
                    <td>
                      <xsl:value-of select="$stringsDoc//value[@key=$cur-priv]" />
                    </td>
                    <td>
                      <xsl:value-of select="$stringsDoc//value[@key=$cur-security]" />
                    </td>
                    <td>
                      <xsl:value-of select="$stringsDoc//value[@key=$cur-access]" />
                    </td>
                    <td>                      
                      <xsl:choose>
                        <xsl:when test="$snmp-engineid = $cur-engineid">
                          <xsl:value-of select="$stringsDoc//value[@key='yes']" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$stringsDoc//value[@key='no']" />
                        </xsl:otherwise>
                      </xsl:choose>

                    </td>
                    <td>
                      <xsl:value-of select="hpoa:engineid"/>
                    </td>
                  </tr>

                </xsl:for-each>

              </tbody>
            </table>

          </td>
        </tr>
      </table>
    </div>
    

    <xsl:if  test="$serviceUserAcl = 'ADMINISTRATOR'">
      <span class="whiteSpacer">&#160;</span>
      <br />      
      
      <div class="buttonSet">
        <div class="bWrapperUp">
          <div>
            <div>
              <xsl:element name="button">
                <xsl:attribute name="class">hpButton</xsl:attribute>
                <xsl:attribute name="id">deleteSnmpUserButton</xsl:attribute>      
                <xsl:attribute name="onclick">
                  <xsl:choose>
                    <xsl:when test="$isWizard = 'true'">wizDelSnmpUser()</xsl:when>
                    <xsl:otherwise>deleteSnmpUsers(function(){if (ourTabManager.getCurrentTab() == 'snmpUsers'){setTabContent('snmpUsers');}})</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="disabled">true</xsl:attribute><!-- always disabled until rows selected -->  
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
                <xsl:attribute name="id">newSnmpUserButton</xsl:attribute>
                <xsl:attribute name="onclick">
                  <xsl:choose>
                    <xsl:when test="$isWizard = 'true'">wizAddSnmpUser()</xsl:when>
                    <xsl:otherwise>addSnmpUserPage()</xsl:otherwise>
                  </xsl:choose>                  
                </xsl:attribute>
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

