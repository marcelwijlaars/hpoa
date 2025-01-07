<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  
	<xsl:template name="enclosureStatusTotals">
    <xsl:param name="encNbr" />
	  <xsl:param name="statusDoc" />    
    
    <xsl:variable name="totalCritical">
      <xsl:value-of select="count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_NON_RECOVERABLE_ERROR]) + count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_LOST_COMMUNICATION])"/>
    </xsl:variable>
    <xsl:variable name="totalMajor">
      <xsl:value-of select="count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_PREDICTIVE_FAILURE]) + count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_ERROR]) + count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_ABORTED]) + count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR])"/>
    </xsl:variable>
    <xsl:variable name="totalMinor">
      <xsl:value-of select="count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_DEGRADED]) + count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_STRESSED]) + count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_STOPPED])"/>
    </xsl:variable>
    <xsl:variable name="totalUnknown">
      <xsl:value-of select="count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_UNKNOWN]) + count($statusDoc//enclosure[@enclosureNumber=$encNbr]//device[severity=$OP_STATUS_NO_CONTACT])"/>
    </xsl:variable>
    
    <xsl:value-of select="$totalCritical + $totalMajor + $totalMinor + $totalUnknown" />
    
	</xsl:template>
	
</xsl:stylesheet>
