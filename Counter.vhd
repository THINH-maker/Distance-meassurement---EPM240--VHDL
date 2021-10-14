library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter is
	generic(
		n: POSITIVE := 10
	);
	port(
		clk: in std_logic;
		enable: in std_logic;
		reset: in std_logic;
		count_out: out std_logic_vector(n - 1 downto 0) 
	);
end Counter;

architecture Behavioral of Counter is
signal count: std_logic_vector(n - 1 downto 0);
begin
	process(clk, reset, enable)
	begin
		if (reset = '0') then
			count <= (others => '0');
		elsif(clk'event and clk= '1') then
			if (enable = '1') then
				count <= count + 1;
			end if;
		end if;
	end process;	
	count_out <= count;	
end Behavioral;