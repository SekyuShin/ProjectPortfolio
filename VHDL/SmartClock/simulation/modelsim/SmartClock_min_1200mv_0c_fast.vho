-- Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Altera and sold by Altera or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Lite Edition"

-- DATE "11/24/2018 20:59:46"

-- 
-- Device: Altera EP4CE30F23C8 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	SmartClock IS
    PORT (
	clk_50m : IN std_logic;
	seg_com : OUT std_logic_vector(7 DOWNTO 0);
	seg_out : OUT std_logic_vector(7 DOWNTO 0);
	e : OUT std_logic;
	rs : OUT std_logic;
	rw : OUT std_logic;
	lcd_data : OUT std_logic_vector(7 DOWNTO 0);
	bell : OUT std_logic;
	send_req : IN std_logic;
	rx : IN std_logic;
	tx : OUT std_logic
	);
END SmartClock;

-- Design Ports Information
-- clk_50m	=>  Location: PIN_G22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[0]	=>  Location: PIN_J17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[1]	=>  Location: PIN_E7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[2]	=>  Location: PIN_V15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[3]	=>  Location: PIN_T18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[4]	=>  Location: PIN_A5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[5]	=>  Location: PIN_D20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[6]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_com[7]	=>  Location: PIN_V12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[0]	=>  Location: PIN_AB7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[1]	=>  Location: PIN_U14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[2]	=>  Location: PIN_J4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[3]	=>  Location: PIN_G13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[4]	=>  Location: PIN_D21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[5]	=>  Location: PIN_T8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[6]	=>  Location: PIN_J7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- seg_out[7]	=>  Location: PIN_U20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- e	=>  Location: PIN_AA10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rs	=>  Location: PIN_F7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rw	=>  Location: PIN_A15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[0]	=>  Location: PIN_E12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[1]	=>  Location: PIN_G17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[2]	=>  Location: PIN_G9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[3]	=>  Location: PIN_E14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[4]	=>  Location: PIN_E4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[5]	=>  Location: PIN_Y8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[6]	=>  Location: PIN_G15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lcd_data[7]	=>  Location: PIN_T9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- bell	=>  Location: PIN_B3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- send_req	=>  Location: PIN_G21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rx	=>  Location: PIN_T11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tx	=>  Location: PIN_V10,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF SmartClock IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk_50m : std_logic;
SIGNAL ww_seg_com : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_seg_out : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_e : std_logic;
SIGNAL ww_rs : std_logic;
SIGNAL ww_rw : std_logic;
SIGNAL ww_lcd_data : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_bell : std_logic;
SIGNAL ww_send_req : std_logic;
SIGNAL ww_rx : std_logic;
SIGNAL ww_tx : std_logic;
SIGNAL \clk_50m~input_o\ : std_logic;
SIGNAL \send_req~input_o\ : std_logic;
SIGNAL \rx~input_o\ : std_logic;
SIGNAL \seg_com[0]~output_o\ : std_logic;
SIGNAL \seg_com[1]~output_o\ : std_logic;
SIGNAL \seg_com[2]~output_o\ : std_logic;
SIGNAL \seg_com[3]~output_o\ : std_logic;
SIGNAL \seg_com[4]~output_o\ : std_logic;
SIGNAL \seg_com[5]~output_o\ : std_logic;
SIGNAL \seg_com[6]~output_o\ : std_logic;
SIGNAL \seg_com[7]~output_o\ : std_logic;
SIGNAL \seg_out[0]~output_o\ : std_logic;
SIGNAL \seg_out[1]~output_o\ : std_logic;
SIGNAL \seg_out[2]~output_o\ : std_logic;
SIGNAL \seg_out[3]~output_o\ : std_logic;
SIGNAL \seg_out[4]~output_o\ : std_logic;
SIGNAL \seg_out[5]~output_o\ : std_logic;
SIGNAL \seg_out[6]~output_o\ : std_logic;
SIGNAL \seg_out[7]~output_o\ : std_logic;
SIGNAL \e~output_o\ : std_logic;
SIGNAL \rs~output_o\ : std_logic;
SIGNAL \rw~output_o\ : std_logic;
SIGNAL \lcd_data[0]~output_o\ : std_logic;
SIGNAL \lcd_data[1]~output_o\ : std_logic;
SIGNAL \lcd_data[2]~output_o\ : std_logic;
SIGNAL \lcd_data[3]~output_o\ : std_logic;
SIGNAL \lcd_data[4]~output_o\ : std_logic;
SIGNAL \lcd_data[5]~output_o\ : std_logic;
SIGNAL \lcd_data[6]~output_o\ : std_logic;
SIGNAL \lcd_data[7]~output_o\ : std_logic;
SIGNAL \bell~output_o\ : std_logic;
SIGNAL \tx~output_o\ : std_logic;

BEGIN

ww_clk_50m <= clk_50m;
seg_com <= ww_seg_com;
seg_out <= ww_seg_out;
e <= ww_e;
rs <= ww_rs;
rw <= ww_rw;
lcd_data <= ww_lcd_data;
bell <= ww_bell;
ww_send_req <= send_req;
ww_rx <= rx;
tx <= ww_tx;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOOBUF_X67_Y36_N23
\seg_com[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[0]~output_o\);

-- Location: IOOBUF_X5_Y43_N23
\seg_com[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[1]~output_o\);

-- Location: IOOBUF_X50_Y0_N2
\seg_com[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[2]~output_o\);

-- Location: IOOBUF_X67_Y3_N16
\seg_com[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[3]~output_o\);

-- Location: IOOBUF_X14_Y43_N16
\seg_com[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[4]~output_o\);

-- Location: IOOBUF_X67_Y40_N23
\seg_com[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[5]~output_o\);

-- Location: IOOBUF_X32_Y43_N30
\seg_com[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[6]~output_o\);

-- Location: IOOBUF_X41_Y0_N30
\seg_com[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_com[7]~output_o\);

-- Location: IOOBUF_X18_Y0_N23
\seg_out[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[0]~output_o\);

-- Location: IOOBUF_X50_Y0_N16
\seg_out[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[1]~output_o\);

-- Location: IOOBUF_X0_Y29_N16
\seg_out[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[2]~output_o\);

-- Location: IOOBUF_X52_Y43_N16
\seg_out[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[3]~output_o\);

-- Location: IOOBUF_X67_Y36_N2
\seg_out[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[4]~output_o\);

-- Location: IOOBUF_X14_Y0_N30
\seg_out[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[5]~output_o\);

-- Location: IOOBUF_X0_Y30_N9
\seg_out[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[6]~output_o\);

-- Location: IOOBUF_X67_Y7_N16
\seg_out[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \seg_out[7]~output_o\);

-- Location: IOOBUF_X34_Y0_N9
\e~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \e~output_o\);

-- Location: IOOBUF_X3_Y43_N23
\rs~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \rs~output_o\);

-- Location: IOOBUF_X45_Y43_N9
\rw~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \rw~output_o\);

-- Location: IOOBUF_X36_Y43_N9
\lcd_data[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[0]~output_o\);

-- Location: IOOBUF_X67_Y41_N16
\lcd_data[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[1]~output_o\);

-- Location: IOOBUF_X1_Y43_N30
\lcd_data[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[2]~output_o\);

-- Location: IOOBUF_X48_Y43_N9
\lcd_data[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[3]~output_o\);

-- Location: IOOBUF_X0_Y39_N2
\lcd_data[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[4]~output_o\);

-- Location: IOOBUF_X18_Y0_N16
\lcd_data[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[5]~output_o\);

-- Location: IOOBUF_X63_Y43_N23
\lcd_data[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[6]~output_o\);

-- Location: IOOBUF_X14_Y0_N23
\lcd_data[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \lcd_data[7]~output_o\);

-- Location: IOOBUF_X5_Y43_N9
\bell~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \bell~output_o\);

-- Location: IOOBUF_X20_Y0_N16
\tx~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \tx~output_o\);

-- Location: IOIBUF_X67_Y22_N8
\clk_50m~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk_50m,
	o => \clk_50m~input_o\);

-- Location: IOIBUF_X67_Y22_N1
\send_req~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_send_req,
	o => \send_req~input_o\);

-- Location: IOIBUF_X18_Y0_N1
\rx~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rx,
	o => \rx~input_o\);

ww_seg_com(0) <= \seg_com[0]~output_o\;

ww_seg_com(1) <= \seg_com[1]~output_o\;

ww_seg_com(2) <= \seg_com[2]~output_o\;

ww_seg_com(3) <= \seg_com[3]~output_o\;

ww_seg_com(4) <= \seg_com[4]~output_o\;

ww_seg_com(5) <= \seg_com[5]~output_o\;

ww_seg_com(6) <= \seg_com[6]~output_o\;

ww_seg_com(7) <= \seg_com[7]~output_o\;

ww_seg_out(0) <= \seg_out[0]~output_o\;

ww_seg_out(1) <= \seg_out[1]~output_o\;

ww_seg_out(2) <= \seg_out[2]~output_o\;

ww_seg_out(3) <= \seg_out[3]~output_o\;

ww_seg_out(4) <= \seg_out[4]~output_o\;

ww_seg_out(5) <= \seg_out[5]~output_o\;

ww_seg_out(6) <= \seg_out[6]~output_o\;

ww_seg_out(7) <= \seg_out[7]~output_o\;

ww_e <= \e~output_o\;

ww_rs <= \rs~output_o\;

ww_rw <= \rw~output_o\;

ww_lcd_data(0) <= \lcd_data[0]~output_o\;

ww_lcd_data(1) <= \lcd_data[1]~output_o\;

ww_lcd_data(2) <= \lcd_data[2]~output_o\;

ww_lcd_data(3) <= \lcd_data[3]~output_o\;

ww_lcd_data(4) <= \lcd_data[4]~output_o\;

ww_lcd_data(5) <= \lcd_data[5]~output_o\;

ww_lcd_data(6) <= \lcd_data[6]~output_o\;

ww_lcd_data(7) <= \lcd_data[7]~output_o\;

ww_bell <= \bell~output_o\;

ww_tx <= \tx~output_o\;
END structure;


