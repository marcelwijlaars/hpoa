<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:include href="../Forms/LCDMessage.xsl" />
	
	<xsl:template match="*">
		
		<html>
		<head>
			<title></title>
			<link rel="stylesheet" type="text/css" href="../css/default.css" />
			<link rel="stylesheet" type="text/css" href="../css/blue_theme.css" />
			<link rel="stylesheet" type="text/css" href="../css/MxPortalEx.css" />
			<script type="text/javascript" src="../js/navigationControlManager.js"></script>
			<script type="text/javascript" src="../js/buttonManager.js"></script>
			<script type="text/javascript" src="../js/global.js"></script>
		</head>
		<body style="margin-top:10px; margin-left:10px; margin-right:10px;">
			
			<xsl:call-template name="LCDMessage" />
			
			<script type="text/javascript">
			//<![CDATA[
				reconcileEventHandlers();
			//]]>
			</script>
			
		</body>
		</html>
		
	</xsl:template>
	

</xsl:stylesheet>

