library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity state_controller is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        emergency_ns : in  STD_LOGIC;
        emergency_ew : in  STD_LOGIC;
        state       : out STD_LOGIC_VECTOR(1 downto 0);
        countdown   : out INTEGER range 0 to 30
    );
end state_controller;

architecture behavioral of state_controller is
    -- State type definition
    type traffic_state_type is (
        NS_GREEN_EW_RED,    -- North-South Green, East-West Red
        NS_YELLOW_EW_RED,   -- North-South Yellow, East-West Red
        NS_RED_EW_GREEN,    -- North-South Red, East-West Green
        NS_RED_EW_YELLOW    -- North-South Red, East-West Yellow
    );
    
    -- Internal signals
    signal current_state : traffic_state_type := NS_GREEN_EW_RED;
    signal timer : INTEGER range 0 to 30 := 0;
    signal paused : BOOLEAN := FALSE;
    signal prev_emergency_ns, prev_emergency_ew : STD_LOGIC := '0';
    
    -- For output encoding
    signal state_output : STD_LOGIC_VECTOR(1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= NS_GREEN_EW_RED;
            timer <= 0;
            paused <= FALSE;
        elsif rising_edge(clk) then
            prev_emergency_ns <= emergency_ns;
            prev_emergency_ew <= emergency_ew;
            
            -- Check if emergency switches changed
            if emergency_ns = '1' or emergency_ew = '1' then
                paused <= TRUE;
                if emergency_ns = '1' then
                    current_state <= NS_GREEN_EW_RED;
                else
                    current_state <= NS_RED_EW_GREEN;
                end if;
            elsif prev_emergency_ns = '1' and emergency_ns = '0' and prev_emergency_ew = '0' and emergency_ew = '0' then
                paused <= FALSE;
                current_state <= NS_GREEN_EW_RED;
                timer <= 0;
            elsif prev_emergency_ew = '1' and emergency_ew = '0' and prev_emergency_ns = '0' and emergency_ns = '0' then
                paused <= FALSE;
                current_state <= NS_RED_EW_GREEN;
                timer <= 0;
            end if;
            
            -- Normal operation when not paused
            if not paused then
                case current_state is
                    when NS_GREEN_EW_RED =>
                        if timer >= 27 then
                            -- Green to Red transition needs yellow
                            current_state <= NS_YELLOW_EW_RED;
                            timer <= 0;
                        else
                            timer <= timer + 1;
                        end if;
                    
                    when NS_YELLOW_EW_RED =>
                        if timer >= 3 then
                            -- After yellow, go to opposite direction green
                            current_state <= NS_RED_EW_GREEN;
                            timer <= 0;
                        else
                            timer <= timer + 1;
                        end if;
                    
                    when NS_RED_EW_GREEN =>
                        if timer >= 27 then
                            -- Green to Red transition needs yellow
                            current_state <= NS_RED_EW_YELLOW;
                            timer <= 0;
                        else
                            timer <= timer + 1;
                        end if;
                    
                    when NS_RED_EW_YELLOW =>
                        if timer >= 3 then
                            -- After yellow, go to opposite direction green
                            current_state <= NS_GREEN_EW_RED;
                            timer <= 0;
                        else
                            timer <= timer + 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    -- Convert current_state to binary output
    with current_state select
        state_output <= "00" when NS_GREEN_EW_RED,
                        "01" when NS_YELLOW_EW_RED,
                        "10" when NS_RED_EW_GREEN,
                        "11" when NS_RED_EW_YELLOW;
    
    state <= state_output;
    countdown <= timer;
end behavioral;