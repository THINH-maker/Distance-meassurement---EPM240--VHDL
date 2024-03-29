library ieee;
use ieee.std_logic_1164.all;
 
entity Trigger_generator is 
	port(
		clk: in std_logic; 
		trigger: out std_logic 
	);
end Trigger_generator;

architecture Behavioral of Trigger_generator is

component Counter is
	generic(
		n: POSITIVE := 10
	);
	port(
		clk: in std_logic;
		enable: in std_logic;
		reset: in std_logic;
		count_out: out std_logic_vector(n - 1 downto 0)
	);
end component;
 

signal reset_counter: std_logic; 

signal output_counter: std_logic_vector(23 downto 0);
begin  
	-- Xung trigger được kích hoạt trong khoảng 250ms - 250ms100us 
	trigg : counter generic map (24) port map (clk, '1', reset_counter, output_counter);	
	process(clk, output_counter) 
	constant ms250: std_logic_vector(23 downto 0) := "101111101011110000100000"; -- 125*10^6
 	constant ms250and100us: std_logic_vector(23 downto 0) := "101111101100000000001000";
	begin
		if(output_counter > ms250 and output_counter < ms250and100us) then
			trigger <= '1';
		else
			trigger <= '0';
		end if;  
		if(output_counter = ms250and100us or output_counter = "XXXXXXXXXXXXXXXXXXXXXXXX") then --x là khong xd
			reset_counter <= '0';  -- active low reset, bắt đầu chạy lại counter để tính thời gian truyền
		else                      
			reset_counter <= '1';
		end if;  
	end process;
end Behavioral;