library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Top_Ultrasonic_sensor is 
	port(
		pulse_pin: in std_logic;
		trigger_pin: out std_logic;
		clock: in std_logic;
		speaker: out std_logic;
		an: out std_logic_vector(2 downto 0);
		sseg: out std_logic_vector (7 downto 0)
 	);
end entity;

architecture Arch of Top_Ultrasonic_sensor is
component Ultrasonic_sensor is
	port(
		fpgaclk, pulse: in std_logic;
		trigger_out: out std_logic;
		speaker: out std_logic;
		meters, centimeters, decimeters: out std_logic_vector(3 downto 0)
	);
end component;

component sseg_display is port
(
  clk: in std_logic;
  in2, in1, in0: in std_logic_vector(3 downto 0);
  an: out std_logic_vector(2 downto 0);
  sseg: out std_logic_vector (7 downto 0)
);
end component;

-- Tín hiệu cho các đơn vị đo
signal Ai: std_logic_vector(3 downto 0);
signal Bi: std_logic_vector(3 downto 0);
signal Ci: std_logic_vector(3 downto 0);
begin
	range_sens : Ultrasonic_sensor port map (clock, pulse_pin, trigger_pin, speaker, Ai, Bi, Ci);
	display: sseg_display port map(clock,	 Ai, 	Bi,	 Ci,	 an, 	sseg);
end Arch;