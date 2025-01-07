<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
				xmlns:hpoa="hpoa.xsd">

  <!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

  <!--
		Generic tree node leaf template. Takes enclosure number, device number,
		and device label (device type) as parameters.
		
		This template depends on the globalTemplates.xsl file being
		included in the topmost template.
	-->
  
  <xsl:param name="enclosureInfoDoc" />
  <xsl:param name="stringsDoc" />
  <xsl:include href="../Templates/guiConstants.xsl"/>
  <xsl:include href="../Templates/globalTemplates.xsl"/>

  <xsl:template match="*">

    <xsl:if test="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState'] and $enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureLocationState']='1'">
     <table border="0" cellspacing="0" cellpadding="0" class="pad1x10" style="width: 100%; table-layout: fixed;">
        <col width="50%" />
        <col width="50%" />
        <tr>
            <td style="word-wrap:break-word" valign="top">
                <xsl:value-of select="$stringsDoc//value[@key='rackName']" />:
            </td>
            <td style="word-wrap:break-word" valign="top">
                <xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:rackName" />
           </td>
        </tr>
        <tr>
            <td style="word-wrap:break-word" valign="top">
                <xsl:value-of select="$stringsDoc//value[@key='rackProductDescription']" />:
            </td>
            <td style="word-wrap:break-word" valign="top"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackProductDesc']"/></td>
        </tr>
        <tr>
            <td style="word-wrap:break-word" valign="top">
               <xsl:value-of select="$stringsDoc//value[@key='rackPartNumber']" />:
            </td>
            <td style="word-wrap:break-word" valign="top"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackProductPartNumber']"/></td>
        </tr>    
        <tr>
            <td style="word-wrap:break-word" valign="top">
               <xsl:value-of select="$stringsDoc//value[@key='rackSerialNumber']" />:
            </td>
            <td style="word-wrap:break-word" valign="top"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackIdentifier']"/></td>
        </tr>    
        <tr>
            <td style="word-wrap:break-word" valign="top">
               <xsl:value-of select="$stringsDoc//value[@key='rackUHeight']" />:
            </td>
            <td style="word-wrap:break-word" valign="top"><xsl:value-of select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='enclosureRackUHeight']"/></td>
        </tr>    
     </table>
     </xsl:if>
  </xsl:template>

</xsl:stylesheet>
