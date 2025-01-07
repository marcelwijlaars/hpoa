<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2011 Hewlett-Packard Development Company, L.P.
  -->
  <xsl:include href="../Templates/globalTemplates.xsl"/>
  <xsl:include href="../Templates/guiConstants.xsl" />
  
  <xsl:param name="stringsDoc" />
  <xsl:param name="ersConfigInfoDoc" />
  <xsl:param name="serviceUserAcl" />
  <xsl:param name="sortCriteria" select="''" />
	<xsl:param name="sortAscending" select="'true'" />
  <xsl:param name="templateName" select="''" />
  
  <hpoa:intervals>
    <interval hpoa:minutes="5" hpoa:number="5">minutes</interval>
    <interval hpoa:minutes="10" hpoa:number="10">minutes</interval>
    <interval hpoa:minutes="15" hpoa:number="15">minutes</interval>
    <interval hpoa:minutes="30" hpoa:number="30">minutes</interval>
    <interval hpoa:minutes="60" hpoa:number="1">hour</interval>
    <interval hpoa:minutes="120" hpoa:number="2">hours</interval>
    <interval hpoa:minutes="180" hpoa:number="3">hours</interval>
    <interval hpoa:minutes="240" hpoa:number="4">hours</interval>
    <interval hpoa:minutes="300" hpoa:number="5">hours</interval>
    <interval hpoa:minutes="360" hpoa:number="6">hours</interval>
    <interval hpoa:minutes="420" hpoa:number="7">hours</interval>
    <interval hpoa:minutes="480" hpoa:number="8">hours</interval>  
    <interval hpoa:minutes="540" hpoa:number="9">hours</interval>
    <interval hpoa:minutes="600" hpoa:number="10">hours</interval>
    <interval hpoa:minutes="660" hpoa:number="11">hours</interval>
    <interval hpoa:minutes="1440" hpoa:number="1">day</interval>
    <interval hpoa:minutes="2880" hpoa:number="2">days</interval>
    <interval hpoa:minutes="4320" hpoa:number="3">days</interval>
    <interval hpoa:minutes="5760" hpoa:number="4">days</interval>
    <interval hpoa:minutes="10080" hpoa:number="1">week</interval>
    <interval hpoa:minutes="20160" hpoa:number="2">weeks</interval>
  </hpoa:intervals>
  
  <xsl:variable name="intervalDoc" select="document('')//hpoa:intervals" />
  <xsl:variable name="mode" select="$ersConfigInfoDoc//hpoa:ersMode" />
  <xsl:variable name="activated" select="$ersConfigInfoDoc//hpoa:ersEnabled = 'true'" />
  <xsl:variable name="onlineRegistrationComplete" select="$ersConfigInfoDoc//hpoa:extraData[@hpoa:name = 'ersOnlineRegistrationComplete'] = 'true'" />
  <xsl:variable name="fullyActivated" select="$activated = true() and (($mode = $ERS_MODE_IRS) or ($onlineRegistrationComplete = true()))" />
  
  <xsl:template name="remoteSupportEvents" match="*">  
    <xsl:choose>
      <xsl:when test="$templateName = 'eventLogTable'">
        <xsl:call-template name="eventLogTable" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$activated = true()">     
            <xsl:call-template name="ersHeader" />
            
            <table cellpadding="0" cellspacing="0" border="0" style="margin-top:5px;border-collapse:collapse;">
              <tr>
                <td style="vertical-align:middle;">
                  <h5 style="margin:0px 0px 3px 0px;"><xsl:value-of select="$stringsDoc//value[@key='serviceEventTest']" /></h5>
                </td>
                <td id="serviceEventInProgress" style="vertical-align:middle;padding-left:15px;padding-bottom:3px;color:#666;">
                  &#160;
                </td>
              </tr>
            </table>            
            <div class="errorDisplay" id="errorDisplay"></div>
            
            
            <table id="svcEventsGroup" cellpadding="0" cellspacing="0" width="100%" style="border:1px solid #ccc;">
              <tr>
                <td style="vertical-align:middle;padding:15px;">
                  <i valign="middle"><xsl:value-of select="$stringsDoc//value[@key='serviceEventTestDesc']"/></i>
                </td>
                <td style="padding:10px 15px 0px 0px;">
                  <div class="buttonSet" style="margin:0px;">
                    <div class="bWrapperUp">
                      <div>
                        <div>
                          <button type='button' class='hpButton' id="btnApply" onclick="sendServiceEvent();">
                            <xsl:value-of select="$stringsDoc//value[@key='sendTestEvent']" />
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>                  
                </td>
              </tr>
            </table>
           
            
            <span class="whiteSpacer" style="line-height:5px;">&#160;</span><br /><br />
            
            
            <h5 style="margin-bottom:5px;"><xsl:value-of select="$stringsDoc//value[@key='maintenanceSettings']"/></h5>
            
            <div class="groupingBox">
              <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td>
                    <xsl:element name="input">
                      <xsl:attribute name="type">checkbox</xsl:attribute>
                      <xsl:attribute name="id">chkMaintMode</xsl:attribute>
                      <xsl:attribute name="style">margin-left:0px;</xsl:attribute>
                      <xsl:attribute name="onclick">if (this.checked == false){document.getElementById('cboMaintDuration').disabled = true;}else{document.getElementById('cboMaintDuration').removeAttribute('disabled');}</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="$ersConfigInfoDoc//hpoa:ersMaintenanceMode = 'true'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- whatever -->
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>
                  </td>
                  <td>&#160;</td>
                  <td id="lblMaintMode">
                    <label for="chkMaintMode"><xsl:value-of select="$stringsDoc//value[@key='enableMaintenanceMode']"/></label>
                  </td>
                </tr>
                <tr><td colspan="3" style="line-height:10px;">&#160;</td></tr>
                <tr>
                  <td>&#160;</td>
                  <td>&#160;</td>
                  <td style="padding-left:10px;vertical-align:middle;"><xsl:value-of select="$stringsDoc//value[@key='expiresIn:']" />&#160;
                    <xsl:element name="select">
                      <xsl:attribute name="id">cboMaintDuration</xsl:attribute>
                      <xsl:attribute name="style">vertical-align:middle;</xsl:attribute>
                      <!-- validation rules: integer between 5 and 20160 (sec); custom error; only validate when chkMaintMode checked; -->
                      <xsl:attribute name="validate-me">true</xsl:attribute>
                      <xsl:attribute name="option-id">chkMaintMode</xsl:attribute>
                      <xsl:attribute name="msg-key">maintIntervalRequired</xsl:attribute>
                      <xsl:attribute name="rule-list">9</xsl:attribute>
                      <xsl:attribute name="range">5;20160</xsl:attribute>
                      <!-- end validation rules -->
                      <xsl:if test="$ersConfigInfoDoc//hpoa:ersMaintenanceMode != 'true'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>                    
                      </xsl:if>
                      <option value="0"><xsl:value-of select="$stringsDoc//value[@key='select']"/></option>
                      <xsl:call-template name="addDurationOptions">
                        <xsl:with-param name="currentSelection" select="-1" />
                      </xsl:call-template>                  
                    </xsl:element>               
                  </td>
                </tr>
                <xsl:if test="$ersConfigInfoDoc//hpoa:ersMaintenanceMode = 'true'">
                  <tr>
                    <td>&#160;</td>
                    <td>&#160;</td>
                    <td style="padding-left:10px;"> 
                      <span class="whiteSpacer">&#160;</span><br />
                      
                      <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                          <td><xsl:value-of select="$stringsDoc//value[@key='maintenanceModeEnabled:']" /></td>
                          <td width="10">&#160;</td>
                          <td><xsl:value-of select="$ersConfigInfoDoc//hpoa:ersMaintenanceStartTimeStampStr"/></td>
                        </tr>
                        <tr>
                          <td><xsl:value-of select="$stringsDoc//value[@key='maintenanceModeExpiring:']" /></td>
                          <td>&#160;</td>
                          <td><xsl:value-of select="$ersConfigInfoDoc//hpoa:ersMaintenanceEndTimeStampStr"/></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
              </table>    
              
              <span class="whiteSpacer" style="line-height:5px;">&#160;</span>  
              
            </div> 
            
            <!-- BUTTON SET -->

            <span class="whiteSpacer">&#160;</span>
            <br />
            <div align="right">
              <div class='buttonSet' style="margin-bottom:0px;">          
                <div class='bWrapperUp'>
                  <div>
                    <div>
                      <button type='button' class='hpButton' id="btnApply" onclick="setErsMaintenance();">
                        <xsl:value-of select="$stringsDoc//value[@key='apply']" />
                      </button>
                    </div>
                  </div>
                </div>               
              </div>
            </div>
            <div class="clearFloats"></div> 
            
            <span class="whiteSpacer">&#160;</span>
            <br />
            
            <!-- EVENT LOG -->
            
            <h5><xsl:value-of select="$stringsDoc//value[@key='serviceEventLog']" /></h5>
            <div class="errorDisplay" id="clearLogErrorDisplay"></div>       
            
            <div id="eventLogTable">
              <xsl:call-template name="eventLogTable" />              
            </div>        
            
            <!-- BUTTON SET -->

            <span class="whiteSpacer">&#160;</span>
            <br />
            <div align="right">
              <div class='buttonSet' style="margin-bottom:0px;">          
                <div class='bWrapperUp'>
                  <div>
                    <div>
                      <xsl:choose>
                        <xsl:when test="count($ersConfigInfoDoc//hpoa:ersServiceEvent) = 0">
                          <button type='button' class='hpButton' id="btnClearLog" disabled="disabled">
                            <xsl:value-of select="$stringsDoc//value[@key='clearEventLog']" />
                          </button>
                        </xsl:when>
                        <xsl:otherwise>
                          <button type='button' class='hpButton' id="btnClearLog" onclick="clearErsServiceEventLog();">
                            <xsl:value-of select="$stringsDoc//value[@key='clearEventLog']" />
                          </button>
                        </xsl:otherwise>
                      </xsl:choose>                    
                    </div>
                  </div>
                </div>                 
              </div>
            </div>
            <div class="clearFloats"></div>            
           </xsl:when>
           <xsl:otherwise>
             <xsl:call-template name="ersHeader" />      
           </xsl:otherwise>
        </xsl:choose>        
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  
  <!--
    @purpose    : uses the embedded XML document to render options for the maintenance interval.
    @notes      :
  -->
  <xsl:template name="addDurationOptions">
    <xsl:param name="currentSelection" />
    
    <xsl:for-each select="$intervalDoc//interval">
      <xsl:variable name="textVal" select="." />
      <xsl:call-template name="addOption">
        <xsl:with-param name="currentText" select="concat(@hpoa:number, ' ', $stringsDoc//value[@key=$textVal])" />
        <xsl:with-param name="currentValue" select="@hpoa:minutes" />
        <xsl:with-param name="selectValue" select="$currentSelection" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <!--
    @purpose    : adds a single option element to the combo box.
    @notes      :
  -->
  <xsl:template name="addOption">
    <xsl:param name="currentText" />
    <xsl:param name="currentValue" />
    <xsl:param name="selectValue" />

    <xsl:element name="option">
      <xsl:attribute name="value">
        <xsl:value-of select="$currentValue"/>
      </xsl:attribute>
      <xsl:if test="$selectValue = $currentValue">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="$currentText"/>
    </xsl:element>
  </xsl:template>
  
  <!--
    @purpose    : translates an event code into a readable event type.
    @notes      :
  -->
  <xsl:template name="getEventType">
    <xsl:param name="type" />
    
    <xsl:choose>
      <xsl:when test="$type = '1'"><xsl:value-of select="$stringsDoc//value[@key='test']" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$stringsDoc//value[@key='system']" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--
    @purpose    : renders the log table. 
    @notes      : may be called separately by adding 'eventLogTable' as a parameter for templateName,
                  but the container div must exist in the page already to insert it into. This is mainly
                  done to support column sorting without a complete page redraw.
  -->
  <xsl:template name="eventLogTable">
    <table border="0" cellpadding="0" cellspacing="0" class="dataTable" style="width:100%;" id="logtable">
      <thead>
        <tr class="captionRow">
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'indicationIdentifier'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='idNumber']" />
            <xsl:with-param name="optStyle" select="'padding-right:10px'" />
          </xsl:call-template>

          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'timeOfEventStr'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='timeGenerated']" />
          </xsl:call-template>

          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'typeOfEvent'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='eventType']" />
          </xsl:call-template>

          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'deviceType'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='deviceType']" />
          </xsl:call-template>
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'deviceSerialNumber'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='serialNumber']" />
          </xsl:call-template>
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'bayNumber'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='bay']" />
          </xsl:call-template>
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'severityOfEvent'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='perceivedSeverity']" />
          </xsl:call-template>
          
          <xsl:call-template name="sortableColumnHeader">
            <xsl:with-param name="cmpCriteria" select="'submitStatus'" />
            <xsl:with-param name="columnLabel" select="$stringsDoc//value[@key='submissionStatus']" />
          </xsl:call-template>						  
        </tr>
      </thead>
      <tbody>
        <xsl:choose>
          <xsl:when test="count($ersConfigInfoDoc//hpoa:ersServiceEvent) &gt; 0">           
            
            <xsl:variable name="dataType">
              <xsl:choose>
                <xsl:when test="$sortCriteria = 'sequence' or $sortCriteria = 'indicationIdentifier' or $sortCriteria = 'bayNumber' or $sortCriteria = 'typeOfEvent'">number</xsl:when>
                <xsl:otherwise>text</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="sortOrder">
              <xsl:choose>
                <xsl:when test="$sortAscending != 'false'">ascending</xsl:when>
                <xsl:otherwise>descending</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <!-- override the ID sort with the sequence number because the IDs are randomly generated GUIDs -->
            <xsl:variable name="sortCriteriaCustom">
              <xsl:choose>
                <xsl:when test="$sortCriteria = 'indicationIdentifier'">sequence</xsl:when>
                <xsl:otherwise><xsl:value-of select="$sortCriteria" /></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:for-each select="$ersConfigInfoDoc//hpoa:ersServiceEvent">              
              <xsl:sort select="*[local-name()=$sortCriteriaCustom]" data-type="{$dataType}" order="{$sortOrder}"/>
              
              <xsl:variable name="rowClass">
                <xsl:choose>
                  <xsl:when test="position() mod 2 = 0"></xsl:when>
                  <xsl:otherwise>altRowColor</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <xsl:call-template name="eventLogRow">                    
	              <xsl:with-param name="sequenceId" select="hpoa:indicationIdentifier" />
	              <xsl:with-param name="timeStamp" select="hpoa:timeOfEventStr" />
	              <xsl:with-param name="eventType" select="hpoa:typeOfEvent" />
	              <xsl:with-param name="deviceType" select="hpoa:deviceType" />
                <xsl:with-param name="serialNumber" select="hpoa:deviceSerialNumber" />
	              <xsl:with-param name="bayNumber" select="hpoa:bayNumber" />
	              <xsl:with-param name="status" select="hpoa:severityOfEvent" />
                <xsl:with-param name="submitted" select="hpoa:submitStatus" />
                <xsl:with-param name="rowClass" select="$rowClass" />
              </xsl:call-template>
            </xsl:for-each>  
               
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td colspan="8" style="text-align:center;"><em><xsl:value-of select="$stringsDoc//value[@key='noRecordsFound']" /></em></td>
            </tr>                    
          </xsl:otherwise>
        </xsl:choose>
      </tbody>
    </table>    
  </xsl:template>
  
  <!--
    @purpose    : creates a single column header with click handler.
    @notes      : the format will differ depending on sort order or if unsorted.
  -->
  <xsl:template name="sortableColumnHeader">
    <xsl:param name="cmpCriteria" />
    <xsl:param name="columnLabel" />
    <xsl:param name="sortOrder" />
    <xsl:param name="optStyle" select="''" />

    <xsl:element name="th">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$sortCriteria=$cmpCriteria">
            <xsl:choose>
              <xsl:when test="$sortAscending='true'">sortedAscending</xsl:when>
              <xsl:otherwise>sortedDescending</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>sortable</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="style">vertical-align:top;white-space:nowrap;<xsl:value-of select="$optStyle"/></xsl:attribute>
      <xsl:attribute name="onclick">sortEventLog('<xsl:value-of select="$cmpCriteria" />');</xsl:attribute>
      <xsl:value-of select="$columnLabel" />
    </xsl:element>
  </xsl:template>

  <!--
    @purpose    : renders a single table row containing a log entry.
    @notes      : if sort criteria is present for a specific column it gets a different color.
  -->
  <xsl:template name="eventLogRow">
    <xsl:param name="sequenceId" />
    <xsl:param name="timeStamp" />
    <xsl:param name="eventType" />
    <xsl:param name="deviceType" />
    <xsl:param name="serialNumber" />
    <xsl:param name="bayNumber" />
    <xsl:param name="status" />
    <xsl:param name="submitted" />
    <xsl:param name="rowClass" />

    <tr class="{$rowClass}">
      <xsl:element name="td">
        <xsl:attribute name="title"><xsl:value-of select="concat($stringsDoc//value[@key='sequenceNumber:'], ' ', hpoa:sequence)" /></xsl:attribute>
        <xsl:if test="$sortCriteria='indicationIdentifier'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;width:auto;padding-right:10px;cursor:default;white-space:nowrap;</xsl:attribute>
        <nobr><xsl:value-of select="$sequenceId"/></nobr>
      </xsl:element>

      <xsl:element name="td">
        <xsl:if test="$sortCriteria='timeOfEventStr'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;white-space:nowrap;</xsl:attribute>
        <xsl:value-of select="$timeStamp" />
      </xsl:element>

      <xsl:element name="td">
        <xsl:if test="$sortCriteria='typeOfEvent'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;</xsl:attribute>
        <xsl:call-template name="getEventType">
          <xsl:with-param name="type" select="$eventType" />
        </xsl:call-template>
      </xsl:element>

      <xsl:element name="td">
        <xsl:if test="$sortCriteria='deviceType'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;white-space:nowrap;</xsl:attribute>
        <xsl:call-template name="getDeviceTypeLabel">
          <xsl:with-param name="enumType" select="$deviceType" />
        </xsl:call-template>
      </xsl:element>
      
      <xsl:element name="td">
        <xsl:if test="$sortCriteria='deviceSerialNumber'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;</xsl:attribute>
        <xsl:value-of select="$serialNumber" />
      </xsl:element>
      
      <xsl:element name="td">
        <xsl:if test="$sortCriteria='bayNumber'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$bayNumber &lt; 1"><em><xsl:value-of select="$stringsDoc//value[@key='n/a']"/></em></xsl:when>
          <xsl:otherwise><xsl:value-of select="$bayNumber"/></xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      
      <xsl:element name="td">
        <xsl:if test="$sortCriteria='severityOfEvent'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;white-space:nowrap;</xsl:attribute>
        <xsl:call-template name="getStatusLabel">
		      <xsl:with-param name="statusCode">
            <xsl:choose>
              <xsl:when test="$status = $OP_STATUS_OTHER">Informational</xsl:when>
              <xsl:otherwise><xsl:value-of select="$status"/></xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="optStyle" select="'margin-bottom:-2px'" />
	      </xsl:call-template>
      </xsl:element>
      
      <xsl:element name="td">
        <xsl:if test="$sortCriteria='submitStatus'">
          <xsl:attribute name="class">sorted</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">vertical-align:middle;white-space:nowrap;</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$submitted = 'true'">
            <xsl:call-template name="getStatusLabel">
              <xsl:with-param name="statusCode" select="$OP_STATUS_OK" />
              <xsl:with-param name="optStyle" select="'margin-bottom:-2px'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$submitted = 'false'">
            <xsl:call-template name="statusIcon">
              <xsl:with-param name="statusCode" select="$OP_STATUS_NON_RECOVERABLE_ERROR" />
              <xsl:with-param name="optStyle" select="'margin-bottom:-2px'" />
            </xsl:call-template>&#160;<xsl:value-of select="$stringsDoc//value[@key='statusError']"  />
          </xsl:when>
          <xsl:otherwise>                            
            <xsl:call-template name="getStatusLabel">
              <xsl:with-param name="statusCode" select="$OP_STATUS_UNKNOWN" />
              <xsl:with-param name="optStyle" select="'margin-bottom:-2px'" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </tr>
  </xsl:template>

  <!-- 
  ==========================================================================================
    @Purpose: Header denoting current activation status
    @notes  : Status icons used to conform with iLO implementation.
  ==========================================================================================
  -->
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
