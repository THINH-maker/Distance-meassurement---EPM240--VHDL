library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sseg_display is
	port(
		clk : in std_logic;
		Display_reset : in std_logic; 
		in2, in1, in0 : in std_logic_vector(3 downto 0); -- giá trị vào (trăm, chục, đơn vị)
  		an : out std_logic_vector(2 downto 0);  --lựa chọn đơn vị hiển thị(trăm, trục, đvi)
  		sseg : out std_logic_vector (7 downto 0)
	);
end entity;

architecture Arch of sseg_display is
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

	signal output_display : std_logic_vector (19 downto 0);
 	signal sel : std_logic_vector( 1 downto 0);
 	signal mux_out : std_logic_vector (3 downto 0);
begin
	Counter_display : Counter generic map(20) port map(clk, '1', not Display_reset, output_display);
    	sel <= std_logic_vector(output_display(19 downto 18));
    	process(sel, in0, in1, in2)
    		begin
      		case sel is
        		when "00" => an <= "011";  -- mạch chọn kênh mux 4:1
        			mux_out <= in0; -- mux_out và in là số bcd
        		when "01" => an <= "101";
        			mux_out <= in1;
 	      		when others => an <= "110";
    			   mux_out <= in2;
      			end case;
    		end process;
		with mux_out select
   	   		sseg(6 downto 0) <=
				"1111110" when "0000", -- 0 
				"0110000" when "0001", -- 1
		 		"1101101" when "0010", -- 2
				"1111001" when "0011", -- 3
				"0110011" when "0100", -- 4 
				"1011011" when "0101", -- 5 
				"1011111" when "0110", -- 6 
				"1110000" when "0111", -- 7 
				"1111111" when "1000", -- 8 
				"1111011" when "1001", -- 9 
				"0001110" when others; -- L
				sseg(7) <= '0';
end architecture;