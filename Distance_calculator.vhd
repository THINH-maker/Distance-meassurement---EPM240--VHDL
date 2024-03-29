library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Distance_calculator is
	port(
		clk: in std_logic; 
		Calculation_Reset: in std_logic; 
		-- còi báo
		speaker: out std_logic;
		pulse :in std_logic; 
		Distance: out std_logic_vector(8 downto 0) 
	);
end Distance_calculator;

architecture Behavioral of Distance_calculator is
component Counter is
	generic(
		n: POSITIVE := 10
	);
	port(
		clk: in std_logic;
		enable: in std_logic;
		reset: in std_logic;
		count_out: out std_logic_vector(n-1 downto 0)
	);
end component;

signal Pulse_width : STD_LOGIC_VECTOR(21 downto 0);
begin
	Counter_pulse : Counter generic map(22) port map(clk, pulse, not Calculation_reset, Pulse_width);
	Distance_calculator : process(pulse)
		-- Tần số hoạt động của fpga là 50MHZ. Vận tốc âm thanh truyền 29 us/cm
		-- => khoảng cách = số xung/(50*58) = (số xung *3)/ 8700 ~ (số xung*3)/8192 (dịch 13 bit) => sai số 6%
		variable Result : integer; 
		variable Multiplier : STD_LOGIC_VECTOR(23 downto 0);
		begin
			if(pulse = '0') then  -- nhận tín hiệu phản hồi, chân echo xuống mức 0, counter dừng đến (enable=pulse=0)
				Multiplier := Pulse_width * "11";
				Result := to_integer(unsigned(Multiplier(23 downto 13))); 
				if(Result > 400) then
					Distance <= "111111111";
				else
				   if( Result >16 ) then -- lớn hơn 16cm thì bật còi báo
					speaker <= '1' ;
					else 
					speaker <= '0';
					end if;
					Distance <= STD_LOGIC_VECTOR(to_unsigned(Result,9));
					
				end if;
			end if;
		end process;
end architecture;