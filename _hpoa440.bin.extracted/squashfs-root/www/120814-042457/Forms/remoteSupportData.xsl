<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2011 Hewlett-Packard Development Company, L.P.
  -->
  
  <xsl:include href="../Templates/guiConstants.xsl" />
  <xsl:include href="../Templates/globalTemplates.xsl" />
  <xsl:param name="stringsDoc" />
  <xsl:param name="ersConfigInfoDoc" />
  <xsl:param name="serviceUserAcl" />
  
  <xsl:variable name="mode" select="$ersConfigInfoDoc//hpoa:ersMode" />
  <xsl:variable name="activated" select="$ersConfigInfoDoc//hpoa:ersEnabled = 'true'" />
  <xsl:variable name="onlineRegistrationComplete" select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersOnlineRegistrationComplete'] = 'true'" />
  <xsl:variable name="fullyActivated" select="$activated = true() and (($mode = $ERS_MODE_IRS) or ($onlineRegistrationComplete = true()))" />
  
  <xsl:template name="remoteSupportData" match="*">
    <xsl:choose>
      <xsl:when test="$activated = true()">
        <xsl:call-template name="ersHeader" />
        
        <div id="errorDisplay" class="errorDisplay"></div>
        
        <xsl:variable name="descKey">
          <xsl:choose>
            <xsl:when test="$mode = $ERS_MODE_DIRECT">ersDataCollectionDescDirect</xsl:when>
            <xsl:otherwise>ersDataCollectionDescRemote</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="inventoryTransCount" select="count($ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersLastInventoryTransmissionStr'])" />        
        <xsl:variable name="deprecatedTimeStamp" select="$mode = $ERS_MODE_IRS and (($inventoryTransCount = 0 or $ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersLastInventoryTransmissionStr'] = '0000-00-00T00:00:00') and $ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr != '')" />
        
       <p style="margin:5px 5px 5px 0px;"><xsl:value-of select="$stringsDoc//value[@key=$descKey]" /></p> 
               
        <table align="center" border="0" cellpadding="0" cellspacing="0" class="dataTable" id="tblDataCollections" style="margin-top:5px;">
          <tbody>
            <tr class="captionRow">
              <th class="tableHeading">
                <xsl:value-of select="$stringsDoc//value[@key='item']"/>
              </th>
              <th class="tableheading">
                <xsl:value-of select="$stringsDoc//value[@key='detail']"/>
              </th>
            </tr>
            <tr>
              <td class="propertyValue" style="width:230px;">
                <xsl:value-of select="$stringsDoc//value[@key='lastDataCollectionTransmission']"/>
              </td>
              <td class="propertyValue" style="border-left:1px solid #ccc;">
                
                <xsl:choose>
                  <xsl:when test="$deprecatedTimeStamp = true()">
                    <xsl:value-of select="$ersConfigInfoDoc//hpoa:ersLastInventoryTimeStampStr" />&#160;<b>*</b><!-- footnote added at bottom of screen -->
                  </xsl:when>
                  <xsl:when test="$inventoryTransCount = 0">
                    <xsl:value-of select="$ersConfigInfoDoc//hpoa:ersLastInventoryTimeStampStr" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersLastInventoryTransmissionStr']" />
                  </xsl:otherwise>
                </xsl:choose>                
                <div id="dataCollectionInProgress" style="margin-left:15px;color:#666;display:inline;vertical-align:middle;"></div>
              </td>
            </tr>
            <tr class="altRowColor">
              <td class="propertyValue" style="width:230px;">
                <xsl:value-of select="$stringsDoc//value[@key='lastDataCollectionStatus']"/>
              </td>
              <td class="propertyValue" style="border-left:1px solid #ccc;">
                <xsl:choose>
                  <xsl:when test="$ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr != ''">
                    <xsl:call-template name="statusIcon">
                      <xsl:with-param name="statusCode" select="$OP_STATUS_DEGRADED" />
                      <xsl:with-param name="optStyle" select="'margin-bottom:-2px;'" />
                    </xsl:call-template>&#160;
                    <xsl:call-template name="assertLocalizedString">
                      <xsl:with-param name="localizedStringsDoc" select="$stringsDoc" />
                      <xsl:with-param name="originalString" select="$ersConfigInfoDoc//hpoa:ersLastInventoryErrorStr" />
                      <xsl:with-param name="key" select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name='ersLastInventoryErrorCode']" />
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="getStatusLabel">
                      <xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
                      <xsl:with-param name="optStyle" select="'margin-bottom:-2px;'" />
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
            <xsl:if test="$mode = $ERS_MODE_DIRECT">
              <tr>
                <td class="propertyValue" style="width:230px;">
                  <xsl:value-of select="$stringsDoc//value[@key='nextScheduledDataCollection']" />
                </td>
                <td class="propertyValue" style="border-left:1px solid #ccc;">
                  <xsl:value-of select="$ersConfigInfoDoc//hpoa:ersNextScheduledDataCollectionTimeStampStr" />
                </td>
              </tr>
            </xsl:if>
          </tbody>
        </table>

        <!-- BUTTON SET -->

        <span class="whiteSpacer">&#160;</span>
        <br />
        <div align="right">
          <div class='buttonSet' style="margin-bottom:0px;">
            <div class='bWrapperUp'>
              <div>
                <div>
                  <button type='button' class='hpButton' id="btnAppy" onclick="sendDataCollection();">
                    <xsl:value-of select="$stringsDoc//value[@key='sendDataCollection']" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        
      <xsl:if test="$deprecatedTimeStamp = true()">
        *&#160;<i><xsl:value-of select="$stringsDoc//value[@key='representsLastSuccessfulInventory']" /></i>
      </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="ersHeader" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>	
  
  <xsl:template name="ersHeader">
    <xsl:if test="$fullyActivated != true()">    
      <div style="vertical-align:middle;margin:10px 0px 10px 1px;padding:15px 10px 5px 10px;border:2px solid #E0C135">        
        <table cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td>
              <img src="/120814-042457/images/status_minor_32.gif" style="vertical-align:middle;margin-right:5px;" />
            </td>
            <td style="font-weight:bold;">
              <xsl:choose>
                <xsl:when test="$activated = true()">
                  <xsl:value-of select="$stringsDoc//value[@key='stepOneCompletedDesc']" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$stringsDoc//value[@key='notRegisteredWithRemoteSupport']" />
                </xsl:otherwise>                  
              </xsl:choose>   
            </td>
          </tr>
        </table>
        <span class="whiteSpacer">&#160;</span>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

