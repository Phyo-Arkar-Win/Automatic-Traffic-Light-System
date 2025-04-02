library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_converter is
    Port (
        count : in  INTEGER range 0 to 30;
        tens  : out STD_LOGIC_VECTOR(3 downto 0);
        ones  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end bcd_converter;

architecture Behavioral of bcd_converter is
begin
    -- Convert integer to BCD
    -- Tens digit: divide by 10
    tens <= std_logic_vector(to_unsigned(count / 10, 4));
    
    -- Ones digit: modulo 10
    ones <= std_logic_vector(to_unsigned(count mod 10, 4));
end Behavioral;