<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
	
	<!-- html output -->
	<xsl:output method="html" version="4.0" indent="yes" />
	
	<!-- ignored elements -->
	<xsl:template match="topic/source" />
	<xsl:template match="topic/title" />
	<xsl:template match="topic/keywords" />
	<xsl:template match="section/desc" />
	<xsl:template match="related-procedure" />
	<xsl:template match="related-reference" />
	<xsl:template match="related-topic" />
  <xsl:template match="stylesheet" />
	
	<!-- document. add includes, scripts and mandatory elements -->
	<xsl:template match="/">
		<html>
			<head>		
      <!--[if gte IE 10]>
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9"/>
      <![endif]-->
      <link rel="stylesheet" type="text/css" href="/120814-042457/css/default.css" />
			<link rel="stylesheet" type="text/css" href="/120814-042457/css/blue_theme.css" />
			<link rel="stylesheet" type="text/css" href="/120814-042457/css/MxPortalEx.css" />        
			<link rel="stylesheet" type="text/css" href="/120814-042457/Help/stylesheets/help.css" />
        
      <!-- the stylesheet references are added dynamically during conversion -->
      <xsl:for-each select="//stylesheet">
        <xsl:variable name="filename">
          <xsl:value-of select="."/>
        </xsl:variable>
        <!-- omit for AIT output because it interferes with one voice styles 
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="type">text/css</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$filename"/>
          </xsl:attribute>
        </xsl:element>
        -->
      </xsl:for-each>
			<script type="text/javascript" src="/120814-042457/Help/scripts/helpTools.js" />	
			<script type="text/javascript" src="/120814-042457/Help/scripts/helpTopics.js" />
			<script type="text/javascript"><![CDATA[	
        function myOnLoad(title,id){  
          if (!(document.location.href.indexOf("#") > -1 && id.indexOf("_HASH_") == -1)){
            top.getHelpManager().loadTopic(document.location.href, title, id);
          }
        }          
				// apply localized text to fixed help system labels.
				function localizeLabels(){
					var elems = document.getElementsByTagName("SPAN");
					top.getHelpManager().localizeStrings(elems);
				}        
				]]></script>
			</head>
			<!-- do not remove onload() methods (needed for title and history loading, and localization) -->
			<body onload='myOnLoad("{topic/title}","{topic/@topic-id}"); localizeLabels();'>
				<div id="bodyWrapper" style="width:99%;padding-left:5px;">					
					<xsl:apply-templates />
          <div class="popup" id="popup"></div>
				</div>        
			</body>
		</html>
	</xsl:template>
	
	<!-- topic. adds links to top, related links at bottom -->	
	<xsl:template match="topic">
		<!-- section links (only if more than 1 section) -->
		<xsl:if test="count(sections/section) > 1">
		<ul>
		<xsl:for-each select="sections/section/desc">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href">#<xsl:value-of select="." /></xsl:attribute>
					<xsl:value-of select="." /><br />
				</xsl:element>
			</li>
		</xsl:for-each>
		</ul></xsl:if>
		<xsl:apply-templates />
		<!-- related links sections added only if count > 0 -->
		<!-- related procedures -->
		<xsl:if test="count(related-procedure) > 0">
    <br />
		<table border="0" width="100%">
			<tr>
				<td class="section"><span langId="relatedProcedure">Related Procedure</span></td>
			</tr>			
		</table>
		<ul>
		<xsl:for-each select="related-procedure">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
					<xsl:attribute name="onclick">top.getHelpLauncher().openProcedureHelp(<xsl:value-of select="@procedure-id" />);</xsl:attribute>
					<xsl:value-of select="." /><br />
				</xsl:element>
			</li>
		</xsl:for-each>
		</ul>	
		</xsl:if>	
		<!-- related references -->
		<xsl:if test="count(related-reference) > 0">
    <br />
		<table border="0" width="100%">
			<tr>
				<td class="section"><span langId="relatedReference">Related Reference</span></td>
			</tr>			
		</table>
		<ul>
		<xsl:for-each select="related-reference">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
					<xsl:attribute name="onclick">top.getHelpLauncher().openReferenceHelp(<xsl:value-of select="@reference-id" />);</xsl:attribute>
					<xsl:value-of select="." /><br />
				</xsl:element>
			</li>
		</xsl:for-each>
		</ul>	
		</xsl:if>	
		<!-- related topics -->
		<xsl:if test="count(related-topic) > 0">
    <br />
		<table border="0" width="100%">
			<tr>
				<td class="section"><span langId="relatedTopic">Related Topics</span></td>
			</tr>			
		</table>
		<ul>
		<xsl:for-each select="related-topic">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href"><xsl:value-of select="@src" /></xsl:attribute>
					<xsl:value-of select="." /><br />
				</xsl:element>
			</li>
		</xsl:for-each>
		</ul>
		</xsl:if>
	</xsl:template>	
	
	<!-- introductory text. mandatory -->
	<xsl:template match="intro">
		<xsl:apply-templates />
    <xsl:if test="current() != ''">
      <br /><br />
    </xsl:if>
	</xsl:template>
	
	<!-- sections -->
	<xsl:template match="sections">
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- topic section. each section should address single subtopic. -->
	<xsl:template match="section">
    <xsl:if test="desc != ''">
		  <xsl:element name="a">
			  <xsl:attribute name="name"><xsl:value-of select="desc" /></xsl:attribute>
		  </xsl:element>
		  <table width="100%" style="border-collapse:collapse;">
			  <tr>
				  <td class="section"><xsl:value-of select="desc" /></td>
			  </tr>			
		  </table>
    </xsl:if>
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- main content area. -->
	<xsl:template match="content">
    <xsl:choose>
      <xsl:when test="../intro">
        <p><xsl:apply-templates /></p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>	
	</xsl:template>
	
	<!-- supported types: correct | warning | information | not-allowed | critical | settings -->
	<xsl:template match="attention">
		<table class="attention" cellpadding="10">
			<tr>
				<td valign="middle" width="5%"><img hspace="10" border="0" src="/120814-042457/Help/images/{@type}.gif" /></td>
				<td valign="top"><span style="font-size:11px;font-weight:medium;"><xsl:apply-templates /></span></td>
			</tr>		
		</table>
	</xsl:template>
	
	<!-- tip "light bulb" section -->
	<xsl:template match="tip">
		<table class="tips" cellpadding="10">
			<tr>
				<td width="5%"><img hspace="15" border="0" src="/120814-042457/Help/images/tip.gif" /></td>
				<td valign="top"><span style="font-size:11px;font-family:tahoma,arial,san serif"><xsl:apply-templates /></span></td>
			</tr>		
		</table>
	</xsl:template>	
	
	<!-- code block (retains formatting) -->
	<xsl:template match="code">	  
		<table class="code">
			<tr>
				<td class="code"><pre><xsl:apply-templates /></pre></td>
			</tr>			
		</table>
	</xsl:template>
	
	<!-- popup help window. supports html markup -->
	<xsl:template match="popup">
		<xsl:variable name="newId"><xsl:value-of select="generate-id()" />popup</xsl:variable>
		<xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="@width">,'<xsl:value-of select="@width" />'</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
		</xsl:variable>
		<!-- hidden span to store popup text in (html ok) -->
		<xsl:element name="span">
			<xsl:attribute name="id"><xsl:value-of select="$newId" />div</xsl:attribute>
			<xsl:attribute name="style">width:0px;display:none;</xsl:attribute>
			<xsl:apply-templates select="desc" />
		</xsl:element>
		<xsl:element name="a">
			<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$newId" /></xsl:attribute>
			<xsl:attribute name="class">popupText</xsl:attribute>
			<xsl:attribute name="onmousemove">showPopup(event,this,true<xsl:value-of select="$width" />);</xsl:attribute>
			<xsl:attribute name="onmouseout">showPopup(event,this,false);</xsl:attribute>
			<xsl:value-of select="text" />			
		</xsl:element>		
	</xsl:template>
	
	<!-- custom image element. wraps image in a table and supports a centered caption below. -->
	<xsl:template match="image">		
		<table border="0" class="image">
		<tr><td>
		<xsl:element name="img">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
			</xsl:for-each>	
			<xsl:if test="path"><xsl:attribute name="src"><xsl:value-of select="path" /></xsl:attribute></xsl:if>
			<xsl:if test="caption"><xsl:attribute name="title"><xsl:value-of select="caption" /></xsl:attribute></xsl:if>
			<xsl:attribute name="border">
				<xsl:choose>
						<xsl:when test="@border"><xsl:value-of select="@border" /></xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:element>
		</td></tr>
		<xsl:if test="caption">
			<tr>
				<td class="pictureCaption"><xsl:apply-templates select="caption" /></td>
			</tr>
		</xsl:if>
		</table>			
	</xsl:template>
	
	<!-- note section -->
	<xsl:template match="note">
		<table width="100%" cellpadding="5" border="0">
			<tr>
				<td>
					<span langId="note" style="font-size:8pt;font-weight:bold;padding-right:5px;">Note:</span>
					<xsl:apply-templates />
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<!-- spaces. supports: qty(total spaces),size(pixel width of each space) -->
	<xsl:template match="space">
		<xsl:variable name="qty">
			<xsl:choose>
				<xsl:when test="@qty"><xsl:value-of select="@qty" /></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="size">
			<xsl:choose>
				<xsl:when test="@size"><xsl:value-of select="@size" /></xsl:when>
				<xsl:otherwise>4</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="style">padding-left:<xsl:number value="$qty * $size" />px;</xsl:attribute>
		</xsl:element>
	</xsl:template>
	
	<!-- universal handler for html elements -->
	<xsl:template match="a | p | div | span | h1 | h2 | h3 | h4 | h5 | h6 | ul | ol | li | b | i | dl | dt | dd | tt | td | tr | th | tbody | table | sup">
		<xsl:element name="{local-name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
			</xsl:for-each>			
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- handler for single tag html elements -->
	<xsl:template match="img | hr | br">
		<xsl:element name="{local-name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
			</xsl:for-each>	
		</xsl:element><xsl:apply-templates />
	</xsl:template>
		
</xsl:stylesheet>
