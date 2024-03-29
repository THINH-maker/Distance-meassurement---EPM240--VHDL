library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Ultrasonic_sensor is
	port(
		fpgaclk, pulse : in std_logic; 
		-- Xung trigger kích hoạt
		trigger_out : out std_logic; 
		-- còi báo
		speaker: out std_logic;
	
		meters, centimeters, decimeters : out std_logic_vector(3 downto 0)
	);
end Ultrasonic_sensor;

architecture Behavioral of Ultrasonic_sensor is 
component trigger_generator is 
	port(
		clk: in std_logic;
		trigger: out std_logic
	);
end component; 
	
component Distance_calculator is
	port(
		clk: in std_logic;
		Calculation_Reset: in std_logic;
		pulse :in std_logic;
		speaker: out std_logic;
		Distance: out std_logic_vector(8 downto 0)
	);
end component;

component bin2bcd is
  port(
	Distance : in std_logic_vector(8 downto 0);
	hundreds, tens, unit: out std_logic_vector(3 downto 0)
  );
end component;


	signal distance_out: std_logic_vector(8 downto 0);

	signal trigg_out: std_logic;
	
begin
	trigger_out <= trigg_out;

	trig: trigger_generator port map(fpgaclk,	trigg_out);
	dist: Distance_calculator port map(fpgaclk, 	trigg_out, 	pulse, 	speaker,	distance_out);
	BCD_conv: bin2bcd port map(distance_out, 	meters, 	centimeters,	 decimeters);
end Behavioral;