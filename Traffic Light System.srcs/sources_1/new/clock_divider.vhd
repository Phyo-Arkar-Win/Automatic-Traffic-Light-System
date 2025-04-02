library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk_in  : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        clk_out : out STD_LOGIC
    );
end clock_divider;

architecture behavioral of clock_divider is
    -- 100MHz to 1Hz (100,000,000 cycles)
    constant MAX_COUNT : integer := 50000000;
    signal count : integer range 0 to MAX_COUNT-1;
    signal temp_clk : STD_LOGIC := '0';
begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            count <= 0;
            temp_clk <= '0';
        elsif rising_edge(clk_in) then
            if count = MAX_COUNT-1 then
                count <= 0;
                temp_clk <= not temp_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    clk_out <= temp_clk;
end behavioral;