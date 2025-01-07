<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<xsl:template name="LCDMessage">
		<div align="center">
			<xsl:element name="img">
				<xsl:attribute name="src">/120814-042457/images/lcd.jpg</xsl:attribute>
				<xsl:attribute name="border">1</xsl:attribute>
			</xsl:element>
		</div>
		<br />
		
		<span class="whiteSpacerLarge">&#160;</span><br />

		<table BORDER="0" CELLSPACING="0" CELLPADDING="0" align="center">
			<tr>
				<td>
					<b>LCD Message</b>
					<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
						<TR>
							<TD>Message Line 1:</TD>
							<TD width="10">&#160;</TD>
							<TD>
								<input type="text" name="msgL1" id="msgL1" />
							</TD>
						</TR>
						<TR>
							<TD>Message Line 2:</TD>
							<TD width="10">&#160;</TD>
							<TD>
								<input type="text" name="msgL2" id="msgL2" />
							</TD>
						</TR>
						<TR>
							<TD>Message Line 3:</TD>
							<TD width="10">&#160;</TD>
							<TD>
								<input type="text" name="msgL3" id="msgL3" />
							</TD>
						</TR>
						<TR>
							<TD>Message Line 4:</TD>
							<TD width="10">&#160;</TD>
							<TD>
								<input type="text" name="msgL4" id="msgL4" />
							</TD>
						</TR>
						<TR>
							<TD></TD>
							<TD width="10">&#160;</TD>
							<TD>
								<div align="right">
									<div class='buttonSet' style="margin-bottom:0px; margin-top:5px;">
										<div class='bWrapperUp'><div><div><button type='button' class='hpButton' id="Button1">Set Message</button></div></div></div>
									</div>
								</div>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>		
		
		<span class="whiteSpacer">&#160;</span><br />
		
		
	</xsl:template>
	
</xsl:stylesheet>

