<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

        
        
        <xsl:template name="checkMatch">
            <xsl:param name="deviceFwStr" select="''" />
            <xsl:param name="isoFwStr" select="''" />
            <xsl:variable name="str1">
                <xsl:value-of select="normalize-space($deviceFwStr)" />
            </xsl:variable>
            <xsl:variable name="str2">
               <xsl:choose>
                <xsl:when test="contains($isoFwStr,'(')">
                    <xsl:value-of select="normalize-space(substring-before($isoFwStr, '('))" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($isoFwStr)" />
                </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:if test="$str1='' or $str2='' or $str1 != $str2">
               <xsl:call-template name="statusIcon" >
		 <xsl:with-param name="statusCode" select="string('Informational')" />
               </xsl:call-template>&#160;
             </xsl:if>
        </xsl:template>


        <xsl:template name="iloVersionDifference">
            <xsl:param name="iloVersion"/>
            <xsl:param name="isoVersion"/>
            <xsl:variable name="iloVersionFormatted">
                <xsl:call-template name="getIloVersion" >
                    <xsl:with-param name="iloVersion" select="$iloVersion" />
                </xsl:call-template>
            </xsl:variable>

            <xsl:call-template name="checkMatch" >
                 <xsl:with-param name="deviceFwStr" select="$iloVersionFormatted" />
                 <xsl:with-param name="isoFwStr" select="$isoVersion" />
            </xsl:call-template>


        </xsl:template>

        <xsl:template name="getIloVersion">
           <xsl:param name="iloVersion"/>
            
           <xsl:choose>
            <xsl:when test="contains($iloVersion,' ')">
                <xsl:value-of select="substring-before($iloVersion, ' ')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$iloVersion" />
            </xsl:otherwise>
           </xsl:choose>

        </xsl:template>



        <xsl:template name="displayRomVersion">
            <xsl:param name="romVersion"/>
            <xsl:variable name="romFamily">
                <xsl:if test="contains($romVersion,' ')">
                    <xsl:value-of select="substring-before($romVersion, ' ')" />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="formattedRomVersion">
                <xsl:call-template name="getRomVersion" >
                    <xsl:with-param name="romVersion" select="$romVersion" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                    <xsl:when test="$formattedRomVersion!=$romVersion">
                        <xsl:value-of select="$formattedRomVersion" />
                        <br />
                        <xsl:value-of select="concat('Family: ', $romFamily)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$romVersion" />
                    </xsl:otherwise>
            </xsl:choose>
        </xsl:template>

        <xsl:template name="getRomVersion">
            <xsl:param name="romVersion"/>
          
            <xsl:variable name="romDateVersion">
              <xsl:choose>
                <xsl:when test="contains($romVersion, '(') and contains($romVersion, ')')">
                  <!-- handle deprecated extended version in SPP: I36 [I36] 1.00 - (06/26/2014)  -->
                  
                  <xsl:value-of select="substring-before(substring-after($romVersion, '('), ')')" />
                </xsl:when>
                <xsl:when test="contains($romVersion,' ')">
                  <!-- handle family + date version: I36 06/26/2014 -->

                  <xsl:value-of select="substring-after($romVersion, ' ')" />
                </xsl:when>
                <xsl:otherwise>
                  <!-- not used -->
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
          
            <xsl:variable name="month">
                <xsl:if test="contains($romDateVersion,'/')">
                    <xsl:value-of select="substring-before($romDateVersion, '/')" />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="day">
                <xsl:if test="contains(substring-after($romDateVersion, '/'),'/')">
                    <xsl:value-of select="substring-before(substring-after($romDateVersion, '/'), '/')" />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="year">
                <xsl:if test="contains(substring-after($romDateVersion, '/'),'/')">
                    <xsl:value-of select="substring-after(substring-after($romDateVersion, '/'),'/')" />
                </xsl:if>
            </xsl:variable>
            <xsl:choose>
                    <xsl:when test="$month!='' and $year!='' and $day !=''">
                        <xsl:value-of select="concat($year,'.',$month,'.',$day)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$romVersion" />
                    </xsl:otherwise>
            </xsl:choose>
        </xsl:template>






        
</xsl:stylesheet>
