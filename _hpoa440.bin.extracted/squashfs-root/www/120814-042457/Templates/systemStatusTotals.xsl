<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  
	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

  <xsl:param name="stringsDoc" />
	<xsl:param name="systemStatusDocument" />

  <!-- 
    We're just building a semi-colon delimited list of id/value pairs
    that can be split and accessed in an array loop (text output) - mds
    -->
	<xsl:template match="*">
    <xsl:variable name="totalCritical">
      <xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_NON_RECOVERABLE_ERROR]) + count($systemStatusDocument//device[severity=$OP_STATUS_LOST_COMMUNICATION])"/>
    </xsl:variable>

    <xsl:variable name="totalMajor">
      <xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_PREDICTIVE_FAILURE]) + count($systemStatusDocument//device[severity=$OP_STATUS_ERROR]) + count($systemStatusDocument//device[severity=$OP_STATUS_ABORTED]) + count($systemStatusDocument//device[severity=$OP_STATUS_SUPPORTING_ENTITY_IN_ERROR])"/>
    </xsl:variable>

    <xsl:variable name="totalMinor">
      <xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_DEGRADED]) + count($systemStatusDocument//device[severity=$OP_STATUS_STRESSED]) + count($systemStatusDocument//device[severity=$OP_STATUS_STOPPED])"/>
    </xsl:variable>

    <xsl:variable name="totalInformation">
      <xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_OTHER]) + count($systemStatusDocument//device[severity=$OP_STATUS_STOPPING]) + count($systemStatusDocument//device[severity=$OP_STATUS_DORMANT]) + count($systemStatusDocument//device[severity=$OP_STATUS_POWER_MODE]) + count($systemStatusDocument//device[severity='Informational'])"/>
    </xsl:variable>

    <xsl:variable name="totalUnknown">
      <xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_UNKNOWN]) + count($systemStatusDocument//device[severity=$OP_STATUS_NO_CONTACT])"/>
    </xsl:variable>

		<xsl:variable name="totalStarting">
			<xsl:value-of select="count($systemStatusDocument//device[severity=$OP_STATUS_STARTING])"/>
		</xsl:variable>
    
    <xsl:value-of select="concat('tdCritical;',$totalCritical,';tdMajor;',$totalMajor,';tdMinor;',$totalMinor,';tdInformation;',$totalInformation,';tdUnknown;',$totalUnknown,';tdStarting;',$totalStarting)"/>
  
  </xsl:template>
	
</xsl:stylesheet>
