<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:param name="encNum" />

	<xsl:param name="stringsDoc" />
	<xsl:param name="enclosureInfoDoc" />
  <xsl:param name="isCollapsed">false</xsl:param>
  <xsl:param name="isTower" select="'false'" />
	
	<!--
		Include the gui and enclosure constants files.
		NOTE: The enclosure constants file is dependant on the $enclosureInfoDoc variable.
	 -->
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />
	
	<xsl:template match="*">

    <xsl:element name="div">

      <xsl:attribute name="style">padding:20px;</xsl:attribute>

		 <table cellpadding="0" cellspacing="0" border="0" align="center">
			 <tr>
				 <td>
					 <!-- Table wrapper used to center the enclosure front view -->
					 <table border="0" cellspacing="0" cellpadding="0" width="100%">
						 <tr>
							 <td>
								 <div id="{concat('enclosureFrontView', $encNum)}"></div>
							 </td>
						 </tr>
					 </table>
				 </td>
				 <td>
					 <img src="/120814-042457/images/one_white.gif" width="40" height="40" alt=""/>
				 </td>
				 <td>
					 <!-- Table wrapper used to center the enclosure rear view -->
					 <table border="0" cellspacing="0" cellpadding="0" width="100%">
						 <tr>
							 <td>
								 <div id="{concat('enclosureRearView', $encNum)}"></div>
							 </td>
						 </tr>
					 </table>
				 </td>
			 </tr>
		 </table>

      </xsl:element>

	</xsl:template>

</xsl:stylesheet>