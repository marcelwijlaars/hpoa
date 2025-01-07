<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->

	<xsl:param name="stringsDoc" />

	<xsl:include href="../Templates/guiConstants.xsl" />
	<xsl:include href="../Templates/globalTemplates.xsl" />

	<xsl:param name="enclosureInfoDoc" />
	
	<xsl:template match="*">
    <xsl:variable name="usbEnabled" select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='usbMode']='USB_DVD_ENABLED'" />
    <xsl:variable name="dvdEnabled" select="$enclosureInfoDoc//hpoa:enclosureInfo/hpoa:extraData[@hpoa:name='usbMode']='USB_KVM_ENABLED'" />

		<xsl:value-of select="$stringsDoc//value[@key='enclosureUSB:']"/>&#160;<em><xsl:value-of select="$stringsDoc//value[@key='encUsbFormDescription']"/></em><br />
		<span class="whiteSpacer">&#160;</span>
		<br />

		<div id="errorDisplay" class="errorDisplay"></div>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="class">stdRadioButton</xsl:attribute>
						<xsl:attribute name="name">usb_option</xsl:attribute>
						<xsl:attribute name="id">usb_dvd</xsl:attribute>
						<xsl:if test="$usbEnabled = 'true'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
					</xsl:element>
					<label for="usb_dvd">
						<xsl:value-of select="$stringsDoc//value[@key='enclosureDVDandUSBport']"/>
            <xsl:if test="$usbEnabled = 'true'">
							&#160;<xsl:value-of select="$stringsDoc//value[@key='activeController']"/>
						</xsl:if>
					</label>
				</td>
			</tr>
			<tr>
				<td colspan="3" class="formSpacer">&#160;</td>
			</tr>
			<tr>
				<td>
					<xsl:element name="input">
						<xsl:attribute name="type">radio</xsl:attribute>
						<xsl:attribute name="class">stdRadioButton</xsl:attribute>
						<xsl:attribute name="name">usb_option</xsl:attribute>
						<xsl:attribute name="id">usb_kvm</xsl:attribute>
						<xsl:if test="$dvdEnabled = 'true'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
					</xsl:element>
					<label for="usb_kvm">
						<xsl:value-of select="$stringsDoc//value[@key='enclosureFrontUSBports']"/>
            <xsl:if test="$dvdEnabled = 'true'">
							&#160;<xsl:value-of select="$stringsDoc//value[@key='activeController']"/>
						</xsl:if>
					</label>
				</td>
			</tr>
		</table>

		<span class="whiteSpacer">&#160;</span>
		<br />
		
		<div class='bWrapperUp'>
			<div>
				<div>
					<xsl:element name="button">

						<xsl:attribute name="type">button</xsl:attribute>
						<xsl:attribute name="class">hpButton</xsl:attribute>
						<xsl:attribute name="id">btnSetUsbOption</xsl:attribute>
						<xsl:attribute name="onclick">setEnclosureUsbMode();</xsl:attribute>
						<xsl:value-of select="$stringsDoc//value[@key='apply']"/>
					</xsl:element>

				</div>
			</div>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>

