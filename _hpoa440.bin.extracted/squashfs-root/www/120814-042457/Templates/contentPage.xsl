<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
  xmlns:hpoa="hpoa.xsd">

  <!--
    (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
  -->
  
  <xsl:param name="stringsDoc" />
  <xsl:param name="arguments" />
  <xsl:param name="template" select="'main'" />
  <xsl:param name="showDebuggerMenus" select="'false'" />

  <xsl:template match="*"> 
    <xsl:choose>
      <xsl:when test="$template = 'horizontalMenu'">
        <xsl:call-template name="horizontalMenu" />
      </xsl:when>
      <xsl:otherwise>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" onclick="checkMenuAccess(event);">
          <tr>
            <td class="dropdownNavMainCell"  id="mnuHorizontalMain">
              <xsl:call-template name="horizontalMenu" />	
            </td>
              <td class="dropdownNavRightBorder"><div></div>
            </td>
          </tr>
          <tr>
            <td class="dropdownNavBottomBorder" colspan="2"><div></div>
            </td>
          </tr>
        </table>
        <table class="window-border-table" id="ID_25" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td>
              <table class="title-outer-table" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td id="ID_PORTAL_TITLE" class="title-name" nowrap="nowrap">
                    <xsl:value-of select="$stringsDoc//value[@key='rackOverview']" />
                  </td>
                  <td class="title-links"></td>
                  <td style="background: #cccccc;" height="100%" valign="bottom" nowrap="nowrap">
                    <table border="0" cellpadding="0" cellspacing="0" id="Table3" nowrap="nowrap" style="white-space: nowrap;">
                      <tr>
                        <td style="background: #cccccc;" height="100%" valign="bottom">
                          <table border="0" cellpadding="0" cellspacing="0">
                            <tbody>
                              <tr>
                                <td valign="top">
                                  <div class="buttonSet" style="padding-right: 4px; margin-bottom: 6px;">
                                    <div class="bWrapperUp">
                                      <div>
                                        <button onclick="doPrint();" id="btnPrint" 
                                          style="margin:0px;padding:0px;width:20px;height:16px;" class="hpButtonSmall 
                                          shrinkWrapButton helpButton"><img src="/120814-042457/images/icons/print.gif" style="border-style:none;width:10px;height:10px;" alt="{$stringsDoc//value[@key='mnuPrint']}" />
                                        </button>
                                      </div>
                                    </div>
                                  </div>
                                  <div class="clearFloats">
                                  </div>
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                        <td nowrap="nowrap" height="100%" valign="top">
                          <a href="javascript:void(0);" onclick="doPrint();" id="lnkPrint"><xsl:value-of select="$stringsDoc//value[@key='mnuPrint']"/></a>
                        </td>
                        <td style="background: #cccccc;" height="100%" valign="bottom">
                          <table border="0" cellpadding="0" cellspacing="0">
                            <tbody>
                              <tr>
                                <td valign="top">
                                  <div class="buttonSet" style="padding-right: 4px; margin-bottom: 6px;">
                                    <div class="bWrapperUp">
                                      <div>
                                        <button onclick="top.mainPage.getHelpLauncher().openContextHelp();" id="contextHelp"
                                          style="margin: 0px; padding: 0px; width: 16px; height: 16px;" class="hpButtonSmall 
                                          shrinkWrapButton helpButton"><img src="/120814-042457/images/icons/help.gif" style="border-style: none; width: 6px; height: 10px;" alt="{$stringsDoc//value[@key='mnuHelp']}" />
                                        </button>
                                      </div>
                                    </div>
                                  </div>
                                  <div class="clearFloats">
                                  </div>
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                        <td nowrap="nowrap" height="100%" valign="top">
                          <div style="padding-right: 8px;">
                            <a href="javascript:void(0);" onclick="top.mainPage.getHelpLauncher().openContextHelp();" id="linkHelp"><xsl:value-of select="$stringsDoc//value[@key='mnuHelp']"/></a>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <div id="contentContainer" style="BORDER-RIGHT: #cccccc 3px solid; BORDER-TOP: #cccccc 3px solid; BORDER-LEFT: #cccccc 3px solid; BORDER-BOTTOM: #cccccc 3px solid;" >
          <iframe scrolling="auto" src="contentPanel.html" name="CONTENT_FRAME" id="CONTENT_FRAME" width="100%" height="100%" frameborder="no"></iframe>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- 
    @purpose  : draws the horizontal menu system.
    @notes    : restricts menus when flags are set to 'true'.
  -->
  <xsl:template name="horizontalMenu"> 
    <div id="m02_trigger" class="globalNavTrigger" access-level="OPERATOR" oa-admin="true"><xsl:value-of select="$stringsDoc//value[@key='mnuWizards']"/>
      <ul id="m02" class="dropdownMenu" isdropdownmenu="yes">
        <li access-level="ADMINISTRATOR" oa-admin="true"><a onclick="this.parentNode.className == 'disabled' ? '' : top.mainPage.startWizard('/120814-042457/Wizards/wizardSkeleton.html?stepsDocPath=/120814-042457/Wizards/SetupSteps.xml');"><xsl:value-of select="$stringsDoc//value[@key='mnuFirstTimeSetup...']"/></a></li>
        <xsl:if test="contains($arguments, 'fw-wiz=true')">
          <li access-level="OPERATOR" oa-admin="true"><a onclick="this.parentNode.className == 'disabled' ? '' : top.mainPage.startWizard('../Wizards/wizardSkeleton.html?stepsDocPath=../Wizards/FirmwareUpdateSteps.xml');"><xsl:value-of select="$stringsDoc//value[@key='mnuFirmwareUpdate...']"/></a></li>
        </xsl:if>
        <li class="dropdownMenuSpacer"></li>
        <li id="m0201_trigger" class="subMenuTrigger"><xsl:value-of select="$stringsDoc//value[@key='mnuStartupSettings']"/><ul id="m0201" class="dropdownMenu" isdropdownmenu="yes">
          <li><div id="mnuLaunchWizard" class="dropdownMenuItemUnchecked" oncheck="setWizardCompletedStatus('WIZARD_NOT_COMPLETED');" onuncheck="setWizardCompletedStatus('WIZARD_SETUP_COMPLETE');"></div><xsl:value-of select="$stringsDoc//value[@key='mnuLaunchFtsAtStartup']"/></li>
          </ul>
        </li>					
      </ul>
    </div>
    <div id="m03_trigger" class="globalNavTrigger"><xsl:value-of select="$stringsDoc//value[@key='mnuOptions']"/>
      <ul id="m03" class="dropdownMenu" isdropdownmenu="yes">
        <li id="m0301_trigger" class="subMenuTrigger"><xsl:value-of select="$stringsDoc//value[@key='mnuRefresh']"/><ul id="m0301" class="dropdownMenu" isdropdownmenu="yes">
          <li><a onclick="refreshData();"><xsl:value-of select="$stringsDoc//value[@key='mnuEncInfo']"/></a></li>
          <li><a onclick="top.refreshTopology();"><xsl:value-of select="$stringsDoc//value[@key='mnuRackTopology']"/></a></li>
          </ul>
        </li>
        <li class="dropdownMenuSpacer"></li>
        <li><a href="../html/userPrefs.html" onmouseover="window.status='';return true;" target="CONTENT_HOME"><xsl:value-of select="$stringsDoc//value[@key='mnuUserPreferences...']"/></a></li>
        <!-- debug menu -->
        <xsl:if test="$showDebuggerMenus = 'true'">
          <li class="dropdownMenuSpacer"></li>              
            <li id="m0302_trigger" class="subMenuTrigger">Debug Tools<ul id="m0302" class="dropdownMenu" isdropdownmenu="yes">  
            <li><a onclick="top.openUtility('ExpressionEvaluator');">Expression Evaluator ...</a></li>
            <li class="dropdownMenuSpacer"></li>         
            <li id="mnuTemplateCheck"><div id="mnuTemplates" class="dropdownMenuItemUnchecked" oncheck="top.toggleTemplateCache(true);" onuncheck="top.toggleTemplateCache(false);top.clearCacheItems();"></div>Activate Template Caching</li>  
            <li class="dropdownMenuSpacer"></li>         
            <li id="mnuDebugCheck"><div id="mnuDebugger" class="dropdownMenuItemUnchecked" oncheck="top.toggleDebugger(true);" onuncheck="top.toggleDebugger(false);"></div>Activate Debug Window ...</li>
            <li id="m030201_trigger" class="subMenuTrigger">Theme<ul id="m030201" class="dropdownMenu" isdropdownmenu="yes">
            <li><div id="mnuDbgColor_white" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('white');" onuncheck=""></div>White (Default)</li>
            <li><div id="mnuDbgColor_gray" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('gray');" onuncheck=""></div>Gray</li>
            <li><div id="mnuDbgColor_green" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('green');" onuncheck=""></div>Green</li>
            <li><div id="mnuDbgColor_amber" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('amber');" onuncheck=""></div>Amber</li>
            <li><div id="mnuDbgColor_red" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('red');" onuncheck=""></div>Red</li>
            <li><div id="mnuDbgColor_blue" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('blue');" onuncheck=""></div>Blue</li>
            <li><div id="mnuDbgColor_black" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('black');" onuncheck=""></div>Black</li>
            <li><div id="mnuDbgColor_terminal" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('terminal');" onuncheck=""></div>Terminal</li>
            <li><div id="mnuDbgColor_purple" class="dropdownMenuItemUnchecked" oncheck="setThemeOption('purple');" onuncheck=""></div>Purple</li>          
            </ul>
            </li>
            <li id="m030202_trigger" class="subMenuTrigger">Level<ul id="m030202" class="dropdownMenu" isdropdownmenu="yes">
            <li><div id="mnuDbgLevel1" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(1);" onuncheck=""></div>1 (Min)</li>
            <li><div id="mnuDbgLevel2" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(2);" onuncheck=""></div>2</li>
            <li><div id="mnuDbgLevel3" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(3);" onuncheck=""></div>3</li>
            <li><div id="mnuDbgLevel4" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(4);" onuncheck=""></div>4</li>
            <li><div id="mnuDbgLevel5" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(5);" onuncheck=""></div>5</li>
            <li><div id="mnuDbgLevel6" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(6);" onuncheck=""></div>6 (Default)</li>
            <li><div id="mnuDbgLevel7" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(7);" onuncheck=""></div>7</li>
            <li><div id="mnuDbgLevel8" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(8);" onuncheck=""></div>8</li>
            <li><div id="mnuDbgLevel9" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(9);" onuncheck=""></div>9</li>          
            <li><div id="mnuDbgLevel10" class="dropdownMenuItemUnchecked" oncheck="setLevelOption(10);" onuncheck=""></div>10 (Max)</li>
            </ul>
            </li>
            <li id="m030203_trigger" class="subMenuTrigger">Font Size<ul id="m030203" class="dropdownMenu" isdropdownmenu="yes">
            <li><div id="mnuDbgFont8" class="dropdownMenuItemUnchecked" oncheck="setFontOption(8);" onuncheck=""></div>8 (Min)</li>
            <li><div id="mnuDbgFont9" class="dropdownMenuItemUnchecked" oncheck="setFontOption(9);" onuncheck=""></div>9</li>
            <li><div id="mnuDbgFont10" class="dropdownMenuItemUnchecked" oncheck="setFontOption(10);" onuncheck=""></div>10</li>
            <li><div id="mnuDbgFont11" class="dropdownMenuItemUnchecked" oncheck="setFontOption(11);" onuncheck=""></div>11</li>
            <li><div id="mnuDbgFont12" class="dropdownMenuItemUnchecked" oncheck="setFontOption(12);" onuncheck=""></div>12 (Default)</li>
            <li><div id="mnuDbgFont14" class="dropdownMenuItemUnchecked" oncheck="setFontOption(14);" onuncheck=""></div>14</li>          
            <li><div id="mnuDbgFont16" class="dropdownMenuItemUnchecked" oncheck="setFontOption(16);" onuncheck=""></div>16</li> 
            <li><div id="mnuDbgFont18" class="dropdownMenuItemUnchecked" oncheck="setFontOption(18);" onuncheck=""></div>18</li>   
            <li><div id="mnuDbgFont20" class="dropdownMenuItemUnchecked" oncheck="setFontOption(20);" onuncheck=""></div>20 (Max)</li>
            </ul>
            </li>                   
          </ul>
        </li> 
        </xsl:if>
        <!-- end debug menu -->
      </ul>
    </div>
    <div id="m04_trigger" class="globalNavTrigger"><xsl:value-of select="$stringsDoc//value[@key='mnuHelp']"/>
      <ul id="m04" class="dropdownMenu" isdropdownmenu="yes">					
        <li><a onclick="top.mainPage.getHelpLauncher().openFullHelp('contents');"><xsl:value-of select="$stringsDoc//value[@key='mnuTableOfContents']"/></a></li>
        <li><a onclick="top.mainPage.getHelpLauncher().openFullHelp('index');"><xsl:value-of select="$stringsDoc//value[@key='mnuIndex']"/></a></li>
        <li><a onclick="top.mainPage.getHelpLauncher().openContextHelp();"><xsl:value-of select="$stringsDoc//value[@key='mnuForThisPage']"/></a></li>	
        <li class="dropdownMenuSpacer"></li>					
        <li>
          <xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="$stringsDoc//value[@key='mnuHpBladeSystem_URI']"/></xsl:attribute>
            <xsl:attribute name="onmouseover">window.status='';return true;</xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:value-of select="$stringsDoc//value[@key='mnuHpBladeSystem']"/>
          </xsl:element>
        </li>
        <li class="dropdownMenuSpacer"></li>
        <li><a onclick="top.mainPage.getHelpLauncher().openAbout(true);"><xsl:value-of select="$stringsDoc//value[@key='mnuAboutOnboardAdmin']"/></a></li>
      </ul>				
    </div>
  </xsl:template>

</xsl:stylesheet>
