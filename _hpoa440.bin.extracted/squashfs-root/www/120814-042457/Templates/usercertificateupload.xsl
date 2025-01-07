<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
   xmlns:hpoa="hpoa.xsd">
		
   <!--
   (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
   -->
	<xsl:param name="stringsDoc" />

    <xsl:param name="encNum" />
	<xsl:param name="username" />
	<xsl:param name="fingerprint" />
	<xsl:param name="serviceuser" /> 
	<xsl:param name="serviceUserAcl" />
         <xsl:include href="../Templates/guiConstants.xsl" />
	
<xsl:template match="*">
<div id="errorDisplay" class="errorDisplay"></div>			
<xsl:choose>
		 <xsl:when test="$fingerprint!=''">		 
			<table class="dataTable" cellpadding="0" cellspacing="0" border="0">
	   		<caption><xsl:value-of select="$stringsDoc//value[@key='fingerPrintInfo']" /></caption>				
		    <tr><th class="propertyName"><xsl:value-of select="$stringsDoc//value[@key='fingerprint']" /></th>
		    <td class="propertyValue">
		    <xsl:value-of select="$fingerprint" />
		    </td>
		    </tr>
		    </table>
            <span class="whiteSpacer">&#160;</span><br />
			<xsl:if test="$serviceUserAcl=$ADMINISTRATOR">
            <div class="buttonSet" style="margin-bottom:0px;">
	            <div class="bWrapperUp">
		  	      <div>
				      <div>
					      <button type='button' class='hpButton' id="Button" onclick="unmap();"><xsl:value-of select="$stringsDoc//value[@key='remove']" /></button>
					  </div>
				  </div>
			    </div>
			</div>
			</xsl:if>
		</xsl:when>
	<xsl:otherwise>
   		<xsl:choose>
  		 <xsl:when  test="$serviceUserAcl=$ADMINISTRATOR">
				   		   
   <xsl:value-of select="$stringsDoc//value[@key='x509CertUpload']" />&#160;<em>
   <xsl:value-of select="$stringsDoc//value[@key='x509CertUploadDesc']" /></em><br />
   <span class="whiteSpacer">&#160;</span><br />

   <textarea class="stdInput" id="certificateContents" style="width:100%;font-size:9pt;" rows="10"></textarea>

   <span class="whiteSpacer">&#160;</span><br />
 <div align="right">
   <div class='buttonSet' style="margin-bottom:0px;">
     <div class='bWrapperUp'>
    	<div>
	    	<div>
				<button type='button' class='hpButton' onclick='mapusercert();'><xsl:value-of select="$stringsDoc//value[@key='upload']" /></button>
			</div>
		</div>
	</div>
   </div>
</div>		
<span class="whiteSpacer">&#160;</span><br />

<xsl:value-of select="$stringsDoc//value[@key='downloadFromURL']" />:&#160;<em>
<xsl:value-of select="$stringsDoc//value[@key='downloadFromURLDesc']" /></em><br />
<span class="whiteSpacer">&#160;</span><br />
<div class="groupingBox">
  <div id="errorContent" class="errorDisplay"></div>
	<table cellpadding="0" cellspacing="0" border="0">
 	<tr>
    	<td>
	    	<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td>
					URL:
				</td>
				<td width="10">&#160;</td>
				<td>
					<input class="stdInput"  type="text" name="certUrl" id="certUrl" size="60" />
				</td>
	    	</tr>
			</table>
	   </td>
	</tr>
	</table>
  </div>
<span class="whiteSpacer">&#160;</span><br />
<div align="right">
  <div class='buttonSet' style="margin-bottom:0px;">
	<div class='bWrapperUp'>
    	<div>
		  <div>
				<button type='button' class='hpButton' id="btnSetProtocols" onclick="downloadCertificate();">
		        <xsl:value-of select="$stringsDoc//value[@key='apply']" />
				</button>
		  </div>
		</div>
	</div>
  </div>
</div>
</xsl:when>
<xsl:otherwise>
		<xsl:value-of select="$stringsDoc//value[@key='noCertMapped']" />
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
