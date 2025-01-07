<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:hpoa="hpoa.xsd">

	<!--
		(C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
	-->
	
	<!-- Power supply status comparison constants -->
	<xsl:variable name="PS_FULL" select="'PS_FULL'" />
	<xsl:variable name="PS_UNKNOWN" select="'PS_UNKNOWN'" />
	<xsl:variable name="PS_CONSERVE" select="'PS_CONSERVE'" />
	<xsl:variable name="PS_LOW" select="'PS_LOW'" />
	<xsl:variable name="PS_SLEEP" select="'PS_SLEEP'" />

    <!-- Powered constants -->
    <xsl:variable name="POWER_ON" select="'POWER_ON'" />
    <xsl:variable name="POWER_OFF" select="'POWER_OFF'" />
    <xsl:variable name="POWER_STAGED_OFF" select="'POWER_STAGED_OFF'" />
    <xsl:variable name="POWER_SLEEP" select="'POWER_SLEEP'" />
    <xsl:variable name="POWER_OFF_IMMEDIATE" select="'POWER_OFF_IMMEDIATE'" />
    <xsl:variable name="POWER_REBOOT_IMMEDIATE" select="'POWER_REBOOT_IMMEDIATE'" />
    <xsl:variable name="POWER_REBOOT" select="'POWER_REBOOT'" />

	<!-- IPL Device constants -->
	<xsl:variable name="IPL_NO_OP" select="'IPL_NO_OP'" />
	<xsl:variable name="IPL_CD" select="'CD'" />
	<xsl:variable name="IPL_FLOPPY" select="'FLOPPY'" />
	<xsl:variable name="IPL_HDD" select="'HDD'" />
	<xsl:variable name="IPL_USB" select="'USB'" />
	<xsl:variable name="IPL_PXE_NIC1" select="'PXE_NIC1'" />
	<xsl:variable name="IPL_PXE_NIC2" select="'PXE_NIC2'" />
	<xsl:variable name="IPL_PXE_NIC3" select="'PXE_NIC3'" />
	<xsl:variable name="IPL_PXE_NIC4" select="'PXE_NIC4'" />
	
    <!-- Power management constants -->
    <xsl:variable name="PM_PRESENT" select="'PM_PRESENT'" />
    <xsl:variable name="PM_ABSENT" select="'PM_ABSENT'" />
  
	<!-- Presence comparison constants -->
	<xsl:variable name="ABSENT" select="'ABSENT'" />
	<xsl:variable name="PRESENT" select="'PRESENT'" />
	<xsl:variable name="SUBSUMED" select="'SUBSUMED'" />
	<xsl:variable name="LOCKED" select="'LOCKED'" />
	<xsl:variable name="ACTIVE" select="'ACTIVE'" />
	<xsl:variable name="STANDBY" select="'STANDBY'" />
	<xsl:variable name="OA_ABSENT" select="'OA_ABSENT'" />
	
	<!-- New operational status constants -->
	<xsl:variable name="OP_STATUS_OK" select="'OP_STATUS_OK'" />
	<xsl:variable name="OP_STATUS_UNKNOWN" select="'OP_STATUS_UNKNOWN'" />
	<xsl:variable name="OP_STATUS_OTHER" select="'OP_STATUS_OTHER'" />
	<xsl:variable name="OP_STATUS_DEGRADED" select="'OP_STATUS_DEGRADED'" />
	<xsl:variable name="OP_STATUS_STRESSED" select="'OP_STATUS_STRESSED'" />
	<xsl:variable name="OP_STATUS_PREDICTIVE_FAILURE" select="'OP_STATUS_PREDICTIVE_FAILURE'" />
	<xsl:variable name="OP_STATUS_ERROR" select="'OP_STATUS_ERROR'" />
	<xsl:variable name="OP_STATUS_STARTING" select="'OP_STATUS_STARTING'" />
	<xsl:variable name="OP_STATUS_STOPPING" select="'OP_STATUS_STOPPING'" />
	<xsl:variable name="OP_STATUS_STOPPED" select="'OP_STATUS_STOPPED'" />
	<xsl:variable name="OP_STATUS_NON_RECOVERABLE_ERROR" select="'OP_STATUS_NON-RECOVERABLE_ERROR'" />
	<xsl:variable name="OP_STATUS_IN_SERVICE" select="'OP_STATUS_IN_SERVICE'" />
	<xsl:variable name="OP_STATUS_NO_CONTACT" select="'OP_STATUS_NO_CONTACT'" />
	<xsl:variable name="OP_STATUS_LOST_COMMUNICATION" select="'OP_STATUS_LOST_COMMUNICATION'" />
	<xsl:variable name="OP_STATUS_ABORTED" select="'OP_STATUS_ABORTED'" />
	<xsl:variable name="OP_STATUS_DORMANT" select="'OP_STATUS_DORMANT'" />
	<xsl:variable name="OP_STATUS_SUPPORTING_ENTITY_IN_ERROR" select="'OP_STATUS_SUPPORTING_ENTITY_IN_ERROR'" />
	<xsl:variable name="OP_STATUS_COMPLETED" select="'OP_STATUS_COMPLETED'" />
	<xsl:variable name="OP_STATUS_POWER_MODE" select="'OP_STATUS_POWER_MODE'" />
	<xsl:variable name="OP_STATUS_DMTF_RESERVED" select="'OP_STATUS_DMTF_RESERVED'" />
	<xsl:variable name="OP_STATUS_VENDER_RESERVED" select="'OP_STATUS_VENDER_RESERVED'" />

	<xsl:variable name="INTERCONNECT_TRAY_PORT_STATUS_OK" select="'INTERCONNECT_TRAY_PORT_STATUS_OK'" />
	<xsl:variable name="INTERCONNECT_TRAY_PORT_STATUS_UNKOWN" select="'INTERCONNECT_TRAY_PORT_STATUS_UNKOWN'" />
	<xsl:variable name="INTERCONNECT_TRAY_PORT_STATUS_MISMATCH" select="'INTERCONNECT_TRAY_PORT_STATUS_MISMATCH'" />

	<xsl:variable name="FABRIC_STATUS_OK" select="'FABRIC_STATUS_OK'" />
	<xsl:variable name="FABRIC_STATUS_MISMATCH" select="'FABRIC_STATUS_MISMATCH'" />
	<xsl:variable name="FABRIC_STATUS_UNKNOWN" select="'FABRIC_STATUS_UNKNOWN'" />

	<xsl:variable name="FIXED_NIC_ID" select="'Embedded Ethernet'" />

	<xsl:variable name="FAULT_OK" select="'FAULT_OK'" />
	<xsl:variable name="FAULT_UNKNOWN" select="'FAULT_UNKNOWN'" />
	<xsl:variable name="FAULT_CPU" select="'FAULT_CPU'" />
	<xsl:variable name="FAULT_PPM" select="'FAULT_PPM'" />
	
	<xsl:variable name="THERMAL_OK" select="'THERMAL_OK'" />
	<xsl:variable name="THERMAL_UNKNOWN" select="'THERMAL_UNKNOWN'" />
	<xsl:variable name="THERMAL_WARM" select="'THERMAL_WARM'" />
	<xsl:variable name="THERMAL_CAUTION" select="'THERMAL_CAUTION'" />
	<xsl:variable name="THERMAL_CRITICAL" select="'THERMAL_CRITICAL'" />
	
	<!-- UID status comparison constants -->
	<xsl:variable name="UID_ON" select="'UID_ON'" />
	<xsl:variable name="UID_OFF" select="'UID_OFF'" />
  <xsl:variable name="UID_BLINK" select="'UID_BLINK'" />

  <!-- UID Image locations -->
  <xsl:variable name="UID_ON_IMAGE" select="'/120814-042457/images/uid_blue_on.gif'" />
  <xsl:variable name="UID_OFF_IMAGE" select="'/120814-042457/images/uid_blue_off.gif'" />
  <xsl:variable name="UID_BLINK_IMAGE" select="'/120814-042457/images/uid_blink.gif'" />
	
	<!-- Blade background image locations (c7000) -->
	<xsl:variable name="BLADE_HALF_IMAGE" select='"/120814-042457/images/enclosure_blade_half.gif"'></xsl:variable>
	<!-- Intel blade image -->
	<xsl:variable name="BLADE_FULL_IMAGE_I" select='"/120814-042457/images/enclosure_blade_full.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_I4" select='"/120814-042457/images/enclosure_blade_680c.gif"'></xsl:variable>
	<!-- AMD blade images -->
	<xsl:variable name="BLADE_FULL_IMAGE_A" select='"/120814-042457/images/enclosure_blade_full_2.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_A_G6" select='"/120814-042457/images/enclosure_blade_full_2_g6.gif"'></xsl:variable>
	<!-- AMD BL485c blade image -->
	<xsl:variable name="BLADE_FULL_IMAGE_485" select='"/120814-042457/images/enclosure_blade_BL485c.gif"'></xsl:variable>
	<!-- Itanium blade image -->
	<xsl:variable name="BLADE_FULL_IMAGE_IA64" select='"/120814-042457/images/enclosure_blade_BL860c.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_870" select='"/120814-042457/images/enclosure_blade_integrity_double.gif"'></xsl:variable>
	<!-- BL2x220c images -->
	<xsl:variable name="BLADE_HALF_IMAGE_2X220_SIDE_A" select='"/120814-042457/images/enclosure_blade_BL2x220c_side_a.gif"'></xsl:variable>
	<xsl:variable name="BLADE_HALF_IMAGE_2X220_SIDE_B" select='"/120814-042457/images/enclosure_blade_BL2x220c_side_b.gif"'></xsl:variable>
	<xsl:variable name="BLADE_HALF_IMAGE_2X220_SIDE_A_90" select='"/120814-042457/images/enclosure_blade_BL2x220c_side_a_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_HALF_IMAGE_2X220_SIDE_B_90" select='"/120814-042457/images/enclosure_blade_BL2x220c_side_b_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_HALF_IMAGE_2X220_SIDE_A_90_T" select='"/120814-042457/images/enclosure_blade_BL2x220c_side_a_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_HALF_IMAGE_2X220_SIDE_B_90_T" select='"/120814-042457/images/enclosure_blade_BL2x220c_side_b_90_t.gif"'></xsl:variable>
	
	<!-- The bl260c and bl495c use the same graphic, but they are both included here just in case. -->
	<xsl:variable name="BLADE_IMAGE_BL260C" select='"/120814-042457/images/enclosure_blade_bl260c.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IMAGE_BL495C" select='"/120814-042457/images/enclosure_blade_bl260c.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IMAGE_BL260C_90" select='"/120814-042457/images/enclosure_blade_bl260c_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IMAGE_BL495C_90" select='"/120814-042457/images/enclosure_blade_bl260c_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IMAGE_BL260C_90_T" select='"/120814-042457/images/enclosure_blade_bl260c_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IMAGE_BL495C_90_T" select='"/120814-042457/images/enclosure_blade_bl260c_90_t.gif"'></xsl:variable>

  <!-- The BL460C-G6 -->
  <xsl:variable name="BLADE_IMAGE_BL460CG6" select='"/120814-042457/images/enclosure_blade_bl460g6.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL460CG6_90" select='"/120814-042457/images/enclosure_blade_bl460g6_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL460CG6_90_T" select='"/120814-042457/images/enclosure_blade_bl460g6_90_t.gif"'></xsl:variable>
  
  <!-- The BL465C-G7 -->
  <xsl:variable name="BLADE_IMAGE_BL465CG7" select='"/120814-042457/images/enclosure_blade_bl465g7.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL465CG7_90" select='"/120814-042457/images/enclosure_blade_bl465g7_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL465CG7_90_T" select='"/120814-042457/images/enclosure_blade_bl465g7_90_t.gif"'></xsl:variable>
  
  <!-- Gen8 Blades -->
  <xsl:variable name="BLADE_IMAGE_BL420C_G8" select='"/120814-042457/images/enclosure_blade_BL420c_gen8.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL460C_G8" select='"/120814-042457/images/enclosure_blade_BL460c_gen8.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL465C_G8" select='"/120814-042457/images/enclosure_blade_BL465c_gen8.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL685C_G8" select='"/120814-042457/images/enclosure_blade_BL685c_gen8.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL660C_G8" select='"/120814-042457/images/enclosure_blade_BL660c_gen8.gif"'></xsl:variable>
  
  <xsl:variable name="BLADE_IMAGE_BL420C_G8_90" select='"/120814-042457/images/enclosure_blade_BL420c_gen8_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL460C_G8_90" select='"/120814-042457/images/enclosure_blade_BL460c_gen8_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL465C_G8_90" select='"/120814-042457/images/enclosure_blade_BL465c_gen8_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL685C_G8_90" select='"/120814-042457/images/enclosure_blade_BL685c_gen8_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL660C_G8_90" select='"/120814-042457/images/enclosure_blade_BL660c_gen8_90.gif"'></xsl:variable>
  
  <xsl:variable name="BLADE_IMAGE_BL420C_G8_90_T" select='"/120814-042457/images/enclosure_blade_BL420c_gen8_90_t.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL460C_G8_90_T" select='"/120814-042457/images/enclosure_blade_BL460c_gen8_90_t.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL465C_G8_90_T" select='"/120814-042457/images/enclosure_blade_BL465c_gen8_90_t.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL685C_G8_90_T" select='"/120814-042457/images/enclosure_blade_BL685c_gen8_90_t.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL660C_G8_90_T" select='"/120814-042457/images/enclosure_blade_BL660c_gen8_90_t.gif"'></xsl:variable>

  <xsl:variable name="BLADE_IMAGE_BL460C_G9" select='"/120814-042457/images/enclosure_blade_BL460c_gen9.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL660C_G9" select='"/120814-042457/images/enclosure_blade_BL660c_gen9.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL460C_G9_90" select='"/120814-042457/images/enclosure_blade_BL460c_gen9_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL660C_G9_90" select='"/120814-042457/images/enclosure_blade_BL660c_gen9_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL460C_G9_90_T" select='"/120814-042457/images/enclosure_blade_BL460c_gen9_90_t.gif"'></xsl:variable>
  <xsl:variable name="BLADE_IMAGE_BL660C_G9_90_T" select='"/120814-042457/images/enclosure_blade_BL660c_gen9_90_t.gif"'></xsl:variable>
  <!-- Storage blade image -->
	<xsl:variable name="BLADE_STORAGE_IMAGE" select='"/120814-042457/images/enclosure_blade_storage.gif"'></xsl:variable>
	<xsl:variable name="BLADE_STORAGE_TAPE_IMAGE" select='"/120814-042457/images/enclosure_blade_tape.gif"'></xsl:variable>
	<xsl:variable name="BLADE_STORAGE_IO_EXPANSION_IMAGE" select='"/120814-042457/images/enclosure_blade_io_expansion.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IO_AMC_IMAGE" select='"/120814-042457/images/enclosure_blade_amc.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IO_XW_GRAPHICS" select='"/120814-042457/images/enclosure_blade_xw460_graphics.gif"'></xsl:variable>
	<xsl:variable name="BLADE_BLANK_IMAGE" select='"/120814-042457/images/enclosure_blade_blank.gif"'></xsl:variable>
	<xsl:variable name="BLADE_UNKNOWN_IMAGE" select='"/120814-042457/images/enclosure_blade_unknown.gif"'></xsl:variable>

	<!--
		Blade background image locations for the c3000 enclosure (rack mount and tower views).
	-->
	<xsl:variable name="BLADE_HALF_IMAGE_90" select='"/120814-042457/images/enclosure_blade_half_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_HALF_IMAGE_90_T" select='"/120814-042457/images/enclosure_blade_half_90_t.gif"'></xsl:variable>
	<!-- Intel blade image -->
	<xsl:variable name="BLADE_FULL_IMAGE_I_90" select='"/120814-042457/images/enclosure_blade_full_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_FULL_IMAGE_I_90_T" select='"/120814-042457/images/enclosure_blade_full_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_I4_90" select='"/120814-042457/images/enclosure_blade_680c_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_FULL_IMAGE_I4_90_T" select='"/120814-042457/images/enclosure_blade_680c_90_t.gif"'></xsl:variable>
	<!-- AMD blade image -->
	<xsl:variable name="BLADE_FULL_IMAGE_A_90" select='"/120814-042457/images/enclosure_blade_full_A_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_A_G6_90" select='"/120814-042457/images/enclosure_blade_full_A_g6_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_FULL_IMAGE_A_90_T" select='"/120814-042457/images/enclosure_blade_full_A_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_A_G6_90_T" select='"/120814-042457/images/enclosure_blade_full_A_g6_90_t.gif"'></xsl:variable>
	<!-- AMD BL485c blade image -->
	<xsl:variable name="BLADE_FULL_IMAGE_485_90" select='"/120814-042457/images/enclosure_blade_BL485c_90.gif"'></xsl:variable>
	<!-- Itanium blade image -->
	<xsl:variable name="BLADE_FULL_IMAGE_IA64_90" select='"/120814-042457/images/enclosure_blade_BL860c_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_FULL_IMAGE_IA64_90_T" select='"/120814-042457/images/enclosure_blade_BL860c_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_870_90" select='"/120814-042457/images/enclosure_blade_integrity_double_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_FULL_IMAGE_870_90_T" select='"/120814-042457/images/enclosure_blade_integrity_double_90_t.gif"'></xsl:variable>
	<!-- Storage blade image -->
	<xsl:variable name="BLADE_STORAGE_IMAGE_90" select='"/120814-042457/images/enclosure_blade_storage_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_STORAGE_IMAGE_90_T" select='"/120814-042457/images/enclosure_blade_storage_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_STORAGE_TAPE_IMAGE_90" select='"/120814-042457/images/enclosure_blade_tape_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_STORAGE_TAPE_IMAGE_90_T" select='"/120814-042457/images/enclosure_blade_tape_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_STORAGE_IO_EXPANSION_IMAGE_90" select='"/120814-042457/images/enclosure_blade_io_expansion_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_STORAGE_IO_EXPANSION_IMAGE_90_T" select='"/120814-042457/images/enclosure_blade_io_expansion_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IO_AMC_IMAGE_90" select='"/120814-042457/images/enclosure_blade_amc_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IO_AMC_IMAGE_90_T" select='"/120814-042457/images/enclosure_blade_amc_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IO_XW_GRAPHICS_90" select='"/120814-042457/images/enclosure_blade_xw460_graphics_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_IO_XW_GRAPHICS_90_T" select='"/120814-042457/images/enclosure_blade_xw460_graphics_90_t.gif"'></xsl:variable>
	<xsl:variable name="BLADE_BLANK_IMAGE_90" select='"/120814-042457/images/enclosure_blade_blank_90.gif"'></xsl:variable>
	<xsl:variable name="BLADE_UNKNOWN_IMAGE_90" select='"/120814-042457/images/enclosure_blade_unknown_90.gif"'></xsl:variable>
  <xsl:variable name="BLADE_UNKNOWN_IMAGE_90_T" select='"/120814-042457/images/enclosure_blade_unknown_90_t.gif"'></xsl:variable>

  <!-- media image locations -->
  <xsl:variable name='MEDIA_DVD_PRESENT_c3000' select='"/120814-042457/images/rightside_dvd_c3000.gif"'></xsl:variable>
  <xsl:variable name='MEDIA_DVD_NOT_PRESENT_c3000' select='"/120814-042457/images/rightside_no_dvd_c3000.gif"'></xsl:variable>
  <xsl:variable name='MEDIA_DVD_PRESENT_c3000_T' select='"/120814-042457/images/rightside_dvd_c3000_t.gif"'></xsl:variable>
  <xsl:variable name='MEDIA_DVD_NOT_PRESENT_c3000_T' select='"/120814-042457/images/rightside_no_dvd_c3000_t.gif"'></xsl:variable>
  
	<!-- Power supply background image locations -->
	<xsl:variable name="PS_PRESENT_IMAGE" select='"/120814-042457/images/enclosure_ps.gif"'></xsl:variable>
	<xsl:variable name="PS_PRESENT_IMAGE_C3000" select='"/120814-042457/images/enclosure_ps_c3000.gif"'></xsl:variable>
	<xsl:variable name="PS_PRESENT_IMAGE_C3000_RIGHT" select='"/120814-042457/images/enclosure_ps_c3000_2.gif"'></xsl:variable>
	<xsl:variable name="PS_PRESENT_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_ps_c3000_t.gif"'></xsl:variable>
	<xsl:variable name="PS_PRESENT_IMAGE_C3000_RIGHT_T" select='"/120814-042457/images/enclosure_ps_c3000_2_t.gif"'></xsl:variable>
	<xsl:variable name="PS_ABSENT_IMAGE" select='"/120814-042457/images/enclosure_ps_absent.gif"'></xsl:variable>
	<xsl:variable name="PS_PRESENT_DC_IMAGE" select='"/120814-042457/images/enclosure_ps_dc.gif"' />
	<xsl:variable name="PS_PRESENT_DC_IMAGE_RIGHT" select='"/120814-042457/images/enclosure_ps_dc_2.gif"' />
	<xsl:variable name="PS_PRESENT_DC_IMAGE_T" select='"/120814-042457/images/enclosure_ps_dc_t.gif"' />
	<xsl:variable name="PS_PRESENT_DC_IMAGE_RIGHT_T" select='"/120814-042457/images/enclosure_ps_dc_2_t.gif"' />
	
	<!-- Interconnect bay background image locations -->
	<xsl:variable name="IO_STANDARD_IMAGE" select='"/120814-042457/images/io_unknown.gif"'></xsl:variable>
  <xsl:variable name="IO_STANDARD_IMAGE_T" select='"/120814-042457/images/io_unknown_t.gif"'></xsl:variable>
	<xsl:variable name="IO_PASSTHRU_IMAGE" select='"/120814-042457/images/io_passthru.gif"'></xsl:variable>
  <xsl:variable name="IO_PASSTHRU_IMAGE_T" select='"/120814-042457/images/io_passthru_t.gif"'></xsl:variable>
	<xsl:variable name="IO_CISCO_IMAGE" select='"/120814-042457/images/io_cisco.gif"'></xsl:variable>
  <xsl:variable name="IO_CISCO_IMAGE_T" select='"/120814-042457/images/io_cisco_t.gif"'></xsl:variable>
	<xsl:variable name="IO_CISCO_FC_IMAGE" select='"/120814-042457/images/io_cisco_fc.gif"'></xsl:variable>
  <xsl:variable name="IO_CISCO_FC_IMAGE_T" select='"/120814-042457/images/io_cisco_fc_t.gif"'></xsl:variable>
  <xsl:variable name="IO_CISCO_FC_HP-FEX_IMAGE" select='"/120814-042457/images/io_cisco_fc_hp-fex.gif"'></xsl:variable>
  <xsl:variable name="IO_CISCO_FC_HP-FEX_IMAGE_T" select='"/120814-042457/images/io_cisco_fc_hp-fex_t.gif"'></xsl:variable>
  <xsl:variable name="IO_CISCO_IMAGE_3120" select='"/120814-042457/images/io_cisco_3120x.gif"'></xsl:variable>
  <xsl:variable name="IO_CISCO_IMAGE_3120_T" select='"/120814-042457/images/io_cisco_3120x_t.gif"'></xsl:variable>
  <xsl:variable name="IO_GBE2C_IMAGE" select='"/120814-042457/images/io_GbE2c.gif"'></xsl:variable>
  <xsl:variable name="IO_GBE2C_IMAGE_T" select='"/120814-042457/images/io_GbE2c_t.gif"'></xsl:variable>
	<xsl:variable name="IO_GBE2C_LAYER2_3_IMAGE" select='"/120814-042457/images/io_GbE2cLayer2_3.gif"'></xsl:variable>
  <xsl:variable name="IO_GBE2C_LAYER2_3_IMAGE_T" select='"/120814-042457/images/io_GbE2cLayer2_3_t.gif"'></xsl:variable>
	<xsl:variable name="IO_IB_IMAGE" select='"/120814-042457/images/io_mac_x_sm.gif"'></xsl:variable>
  <xsl:variable name="IO_IB_IMAGE_T" select='"/120814-042457/images/io_mac_x_sm_t.gif"'></xsl:variable>
  <xsl:variable name="IO_IB2_IMAGE" select='"/120814-042457/images/io_ib2.gif"'></xsl:variable>
  <xsl:variable name="IO_IB2_IMAGE_T" select='"/120814-042457/images/io_ib2_t.gif"'></xsl:variable>
	<xsl:variable name="IO_IB3_IMAGE" select='"/120814-042457/images/io_ib3.gif"'></xsl:variable>
	<xsl:variable name="IO_IB3_IMAGE_T" select='"/120814-042457/images/io_ib3_t.gif"'></xsl:variable>
  <xsl:variable name="IO_IB4_IMAGE" select='"/120814-042457/images/io_ib4.gif"'></xsl:variable>
	<xsl:variable name="IO_IB4_IMAGE_T" select='"/120814-042457/images/io_ib4_t.gif"'></xsl:variable>
	<xsl:variable name="IO_FC_IMAGE" select='"/120814-042457/images/io_fc.gif"'></xsl:variable>
  <xsl:variable name="IO_FC_IMAGE_T" select='"/120814-042457/images/io_fc_t.gif"'></xsl:variable>
	<xsl:variable name="IO_FC_PASSTHRU_IMAGE" select='"/120814-042457/images/io_fibre_passthru_sm.gif"'></xsl:variable>
  <xsl:variable name="IO_FC_PASSTHRU_IMAGE_T" select='"/120814-042457/images/io_fibre_passthru_sm_t.gif"'></xsl:variable>
 	<xsl:variable name="IO_10GB_PASSTHRU_IMAGE" select='"/120814-042457/images/io_10GbE_passthru.gif"'></xsl:variable>
  <xsl:variable name="IO_10GB_PASSTHRU_IMAGE_T" select='"/120814-042457/images/io_10GbE_passthru.gif_t.gif"'></xsl:variable> 
	<xsl:variable name="IO_VC_ENET_IMAGE" select='"/120814-042457/images/io_vc-enet.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_IMAGE_T" select='"/120814-042457/images/io_vc-enet_t.gif"'></xsl:variable>
	<xsl:variable name="IO_VC_ENET_10GB_IMAGE" select='"/120814-042457/images/io_vc-enet-10Gb.gif"'></xsl:variable>
	<xsl:variable name="IO_VC_ENET_10GB_IMAGE_T" select='"/120814-042457/images/io_vc-enet-10Gb_t.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_10GB_24port_IMAGE" select='"/120814-042457/images/io_vc-enet-10Gb-24.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_10GB_24port_IMAGE_T" select='"/120814-042457/images/io_vc-enet-10Gb-24_t.gif"'></xsl:variable> 
  <xsl:variable name="IO_VC_ENET_10GB_30port_IMAGE" select='"/120814-042457/images/io_vc-enet-10Gb-30port.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_10GB_30port_IMAGE_T" select='"/120814-042457/images/io_vc-enet-10Gb-30port_t.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_40GB_20port_IMAGE" select='"/120814-042457/images/io_vc-enet-40Gb-20port.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_40GB_20port_IMAGE_T" select='"/120814-042457/images/io_vc-enet-40Gb-20port_t.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_40GB_20port_F8_IMAGE" select='"/120814-042457/images/io_vc-enet-40Gb-20port_f8.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_ENET_40GB_20port_F8_IMAGE_T" select='"/120814-042457/images/io_vc-enet-40Gb-20port_f8_t.gif"'></xsl:variable>
	<xsl:variable name="IO_VC_FC_IMAGE" select='"/120814-042457/images/io_vc-fc.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_FC_IMAGE_T" select='"/120814-042457/images/io_vc-fc_t.gif"'></xsl:variable>
	<xsl:variable name="IO_VC_FC_ENET_IMAGE" select='"/120814-042457/images/io_vc-enet-and-fc.gif"'></xsl:variable>
  <xsl:variable name="IO_VC_FC_ENET_IMAGE_T" select='"/120814-042457/images/io_vc-enet-and-fc_t.gif"'></xsl:variable>
	<xsl:variable name="IO_4XGBEC_IMAGE" select='"/120814-042457/images/io_4XGbEc.gif"'></xsl:variable>
  <xsl:variable name="IO_4XGBEC_IMAGE_T" select='"/120814-042457/images/io_4XGbEc_t.gif"'></xsl:variable>
	<xsl:variable name="IO_10GB_ENET_IMAGE" select='"/120814-042457/images/io_10Gb-enet.gif"'></xsl:variable>
  <xsl:variable name="IO_10GB_ENET_IMAGE_T" select='"/120814-042457/images/io_10Gb-enet_t.gif"'></xsl:variable>
	<xsl:variable name="IO_SAS_PASSTHRU_IMAGE" select='"/120814-042457/images/io_sas_passthru.gif"'></xsl:variable>
  <xsl:variable name="IO_SAS_PASSTHRU_IMAGE_T" select='"/120814-042457/images/io_sas_passthru_t.gif"'></xsl:variable>
	<xsl:variable name="IO_SAS_SWITCH_IMAGE" select='"/120814-042457/images/io_sas_switch.gif"'></xsl:variable>
  <xsl:variable name="IO_SAS_SWITCH_IMAGE_T" select='"/120814-042457/images/io_sas_switch_t.gif"'></xsl:variable>
  <xsl:variable name="IO_16GB_BROCADE_SAN_IMAGE" select='"/120814-042457/images/io_16Gb_brocade_SAN.gif"'></xsl:variable>
  <xsl:variable name="IO_16GB_BROCADE_SAN_IMAGE_T" select='"/120814-042457/images/io_16Gb_brocade_SAN_t.gif"'></xsl:variable>
  <xsl:variable name="IO_SERVERNET" select='"/120814-042457/images/io_servernet.gif"'></xsl:variable>
  <xsl:variable name="IO_SERVERNET_T" select='"/120814-042457/images/io_servernet_t.gif"'></xsl:variable>
	<xsl:variable name="IO_VC_8GB_IMAGE" select='"/120814-042457/images/io_vc-fc-8gb.gif"'></xsl:variable>
	<xsl:variable name="IO_VC_8GB_IMAGE_T" select='"/120814-042457/images/io_vc-fc-8gb_t.gif"'></xsl:variable>
 	<xsl:variable name="IO_VC_16GB_IMAGE" select='"/120814-042457/images/io_vc-fc-16gb.gif"'></xsl:variable>
	<xsl:variable name="IO_VC_16GB_IMAGE_T" select='"/120814-042457/images/io_vc-fc-16gb_t.gif"'></xsl:variable> 
	<xsl:variable name="IO_10GB_PASS_THRU" select='"/120814-042457/images/io_10Gb_passthru.gif"'></xsl:variable>
	<xsl:variable name="IO_10GB_PASS_THRU_T" select='"/120814-042457/images/io_10Gb_passthru_t.gif"'></xsl:variable>
  <xsl:variable name="IO_6125G_IMAGE" select='"/120814-042457/images/io_6125_G.gif"'></xsl:variable>
  <xsl:variable name="IO_6125G_IMAGE_T" select='"/120814-042457/images/io_6125_G_T.gif"'></xsl:variable>
  <xsl:variable name="IO_6125G_XG_IMAGE" select='"/120814-042457/images/io_6125_G_XG.gif"'></xsl:variable>
  <xsl:variable name="IO_6125G_XG_IMAGE_T" select='"/120814-042457/images/io_6125_G_XG_T.gif"'></xsl:variable>
  <xsl:variable name="IO_6125_XLG_IMAGE" select='"/120814-042457/images/io_6125_XLG.gif"'></xsl:variable>
  <xsl:variable name="IO_6125_XLG_IMAGE_T" select='"/120814-042457/images/io_6125_XLG_T.gif"'></xsl:variable>

	<!-- Status image locations -->
	<xsl:variable name="STATUS_OK_IMAGE" select='"/120814-042457/images/icon_status_normal.gif"' />
	<xsl:variable name="STATUS_MINOR_IMAGE" select='"/120814-042457/images/icon_status_minor.gif"' />
	<xsl:variable name="STATUS_MAJOR_IMAGE" select='"/120814-042457/images/icon_status_major.gif"' />
	<xsl:variable name="STATUS_FAILED_IMAGE" select='"/120814-042457/images/icon_status_critical.gif"' />
	<xsl:variable name="STATUS_UNKNOWN_IMAGE" select='"/120814-042457/images/icon_status_unknown.gif"' />
  <xsl:variable name="STATUS_DISABLED_IMAGE" select='"/120814-042457/images/icon_status_disabled.gif"' />
	<xsl:variable name="STATUS_INFO_IMAGE" select='"/120814-042457/images/icon_status_informational.gif"' />
	<xsl:variable name="STATUS_STARTING_IMAGE" select='"/120814-042457/images/icon_status_working1.gif"' />
	<xsl:variable name="STATUS_LOCKED_IMAGE" select='"/120814-042457/images/icon_lock_16.gif"' />

	<!-- Fan image locations -->
	<xsl:variable name="FAN_PRESENT_TOP_IMAGE" select='"/120814-042457/images/enclosure_fan.gif"' />
	<xsl:variable name="FAN_PRESENT_BOT_IMAGE" select='"/120814-042457/images/enclosure_fan_bot.gif"' />
	<xsl:variable name="FAN_PRESENT_IMAGE_C3000" select='"/120814-042457/images/enclosure_fan_c3000.gif"' />
  <xsl:variable name="FAN_PRESENT_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_fan_c3000_t.gif"' />
  <xsl:variable name="FAN_1_PRESENT_TOP_IMAGE" select='"/120814-042457/images/enclosure_fan_1.gif"' />
  <xsl:variable name="FAN_1_PRESENT_BOT_IMAGE" select='"/120814-042457/images/enclosure_fan_bot_1.gif"' />
  <xsl:variable name="FAN_1_PRESENT_IMAGE_C3000" select='"/120814-042457/images/enclosure_fan_c3000_1.gif"' />
  <xsl:variable name="FAN_1_PRESENT_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_fan_c3000_t_1.gif"' />
  <xsl:variable name="FAN_BLANK_IMAGE" select='"/120814-042457/images/enclosure_fan_blank.gif"' />
	<xsl:variable name="FAN_BLANK_IMAGE_C3000" select='"/120814-042457/images/enclosure_fan_blank_c3000.gif"' />
  <xsl:variable name="FAN_BLANK_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_fan_blank_c3000_t.gif"' />
	
	<!-- Enclosure manager image locations -->
  <xsl:variable name="EM_PRESENT_IMAGE" select='"/120814-042457/images/enclosure_em.gif"' />
  <xsl:variable name="EM_PRESENT_IMAGE_STANDBY" select='"/120814-042457/images/enclosure_em_standby.gif"' />
  <xsl:variable name="EM_PRESENT_IMAGE_440" select='"/120814-042457/images/enclosure_em_440.gif"' />
  <xsl:variable name="EM_PRESENT_IMAGE_STANDBY_440" select='"/120814-042457/images/enclosure_em_440_standby.gif"' />
  <xsl:variable name="EM_PRESENT_IMAGE_C3000" select='"/120814-042457/images/enclosure_em_c3000.gif"' />
  <xsl:variable name="EM_PRESENT_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_em_c3000_t.gif"' />
  <xsl:variable name="EM_PRESENT_IMAGE_STANDBY_C3000" select='"/120814-042457/images/enclosure_em_c3000_standby.gif"' />
  <xsl:variable name="EM_PRESENT_IMAGE_STANDBY_C3000_T" select='"/120814-042457/images/enclosure_em_c3000_standby_t.gif"' />
  <xsl:variable name="EM_RESERVED_IMAGE_C3000" select='"/120814-042457/images/enclosure_em_reserved_c3000.gif"' />
  <xsl:variable name="EM_RESERVED_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_em_reserved_c3000_t.gif"' />
	<xsl:variable name="LINKNIC_UID_ON_IMAGE" select='"/120814-042457/images/enclosure_link_nics.gif"' />
	<xsl:variable name="LINKNIC_UID_OFF_IMAGE" select='"/120814-042457/images/enclosure_link_nics_off.gif"' />
	<xsl:variable name="LINKNIC_IMAGE_C3000" select='"/120814-042457/images/enclosure_nic_c3000.gif"' />
  <xsl:variable name="LINKNIC_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_nic_c3000_t.gif"' />
	<xsl:variable name="LCD_BLANK_IMAGE_C3000" select='"/120814-042457/images/enclosure_lcd_c3000.gif"' />
  <xsl:variable name="LCD_BLANK_IMAGE_C3000_T" select='"/120814-042457/images/enclosure_lcd_c3000_t.gif"' />
	
	<!-- Rear of power supplies background images -->
	<xsl:variable name="PS_REAR_IMAGE_1P" select='"/120814-042457/images/enclosure_rear_ps.gif"' />
	<xsl:variable name="PS_REAR_IMAGE_3P" select='"/120814-042457/images/enclosure_rear_ps_3phase.gif"' />
	<xsl:variable name="PS_REAR_IMAGE_DC" select='"/120814-042457/images/enclosure_rear_ps_dc.gif"' />
	<xsl:variable name="PS_REAR_IMAGE_IPD" select='"/120814-042457/images/enclosure_rear_ps_ipd.gif"' />
	<xsl:variable name="PS_REAR_IMAGE_SAF-D_GRID" select='"/120814-042457/images/enclosure_rear_ps_saf-d_grid.gif"' />
	
	<xsl:variable name="ADMINISTRATOR" select="'ADMINISTRATOR'" />
	<xsl:variable name="OPERATOR" select="'OPERATOR'" />
	<xsl:variable name="USER" select="'USER'" />
	<xsl:variable name="ANONYMOUS" select="'ANONYMOUS'" />

	<!-- Interconnect bay type constants. -->
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_NIC" select="'INTERCONNECT_TRAY_TYPE_NIC'" />
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_FC" select="'INTERCONNECT_TRAY_TYPE_FC'" />
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_SAS" select="'INTERCONNECT_TRAY_TYPE_SAS'" />
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_IB" select="'INTERCONNECT_TRAY_TYPE_IB'" />
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_PCIE" select="'INTERCONNECT_TRAY_TYPE_PCIE'" />
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_MAX" select="'INTERCONNECT_TRAY_TYPE_MAX'" />
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_10GETH" select="'INTERCONNECT_TRAY_TYPE_10GETH'" />
	<xsl:variable name="INTERCONNECT_TRAY_TYPE_NO_CONNECTION" select="'INTERCONNECT_TRAY_TYPE_NO_CONNECTION'" />

	<xsl:variable name="MEZZ_DEV_TYPE_MT" select="'MEZZ_DEV_TYPE_MT'" />
	<xsl:variable name="MEZZ_DEV_TYPE_FIXED" select="'MEZZ_DEV_TYPE_FIXED'" />
  <xsl:variable name="MEZZ_SLOT_TYPE_FIXED" select="'MEZZ_SLOT_TYPE_FIXED'" />
	<xsl:variable name="MEZZ_NUMBER_FIXED" select="13" />	<!-- 1-based Embedded LOM -->
	<xsl:variable name="FLB_START_IX" select="8" />			<!-- 0-based FLB start -->

	<xsl:variable name="WIZARD_NOT_COMPLETED" select="'WIZARD_NOT_COMPLETED'" />
	<xsl:variable name="WIZARD_SETUP_COMPLETE" select="'WIZARD_SETUP_COMPLETE'" />

	<xsl:variable name="EMPTY_IP_TEST" select="'0.0.0.0'" />

	<xsl:variable name="NOT_REDUNDANT" select="'NOT_REDUNDANT'" />
	<xsl:variable name="AC_REDUNDANT" select="'AC_REDUNDANT'" />
	<xsl:variable name="POWER_SUPPLY_REDUNDANT" select="'POWER_SUPPLY_REDUNDANT'" />
	<xsl:variable name="AC_REDUNDANT_WITH_OVERSUBSCRIPTION" select="'AC_REDUNDANT_WITH_OVERSUBSCRIPTION'" />

  <!--PDU TYPES - PDU type/part number/spares number -->
  <xsl:variable name="PDU_TYPE_1" select="'413374-B21'" />
  <xsl:variable name="PDU_TYPE_2" select="'413375-B21'" />
  <xsl:variable name="PDU_TYPE_3" select="'413376-B21'" />
  <xsl:variable name="PDU_TYPE_4" select="'AH331A    '" />
  <xsl:variable name="PDU_TYPE_5" select="'663698-001'" />
  <xsl:variable name="PDU_TYPE_6" select="'747794-001'" />
  
  <!-- Remote Support Modes -->
  <xsl:variable name="ERS_MODE_DISABLED" select="'ERS_MODE_DISABLED'" />
  <xsl:variable name="ERS_MODE_DIRECT" select="'ERS_MODE_DIRECT'" />
  <xsl:variable name="ERS_MODE_IRS" select="'ERS_MODE_IRS'" />
  
  <xsl:variable name="LL_PREFIX" select="'fe80::'"/>
	
</xsl:stylesheet>
