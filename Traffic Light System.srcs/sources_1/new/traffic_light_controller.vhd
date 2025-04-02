library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light_controller is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        emergency_ns : in  STD_LOGIC;
        emergency_ew : in  STD_LOGIC;
        
        -- Traffic light outputs
        ns_red      : out STD_LOGIC;
        ns_yellow   : out STD_LOGIC;
        ns_green    : out STD_LOGIC;
        ew_red      : out STD_LOGIC;
        ew_yellow   : out STD_LOGIC;
        ew_green    : out STD_LOGIC;
        
        -- Seven segment display outputs
        seg         : out STD_LOGIC_VECTOR(6 downto 0);
        an          : out STD_LOGIC_VECTOR(3 downto 0);
        dp          : out STD_LOGIC
    );
end traffic_light_controller;

architecture dataflow of traffic_light_controller is
    -- Clock divider signals
    signal clk_1hz : STD_LOGIC;
    
    -- State machine signals
    signal current_state : STD_LOGIC_VECTOR(1 downto 0);
    signal countdown : INTEGER range 0 to 30;
    
    -- BCD values for seven segment display
    signal digit0 : STD_LOGIC_VECTOR(3 downto 0);  -- ones place
    signal digit1 : STD_LOGIC_VECTOR(3 downto 0);  -- tens place
    signal digit2 : STD_LOGIC_VECTOR(3 downto 0);  -- ones place for other direction
    signal digit3 : STD_LOGIC_VECTOR(3 downto 0);  -- tens place for other direction
    
    -- Display refresh signals
    signal refresh_counter : STD_LOGIC_VECTOR(19 downto 0);
    signal display_select : STD_LOGIC_VECTOR(1 downto 0);
    signal current_digit : STD_LOGIC_VECTOR(3 downto 0);
    
    -- State definitions
    constant NS_GREEN_EW_RED : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant NS_YELLOW_EW_RED : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant NS_RED_EW_GREEN : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant NS_RED_EW_YELLOW : STD_LOGIC_VECTOR(1 downto 0) := "11";
    
    -- Component declarations
    component clock_divider is
        Port (
            clk_in  : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;
    
    component state_controller is
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            emergency_ns : in  STD_LOGIC;
            emergency_ew : in  STD_LOGIC;
            state       : out STD_LOGIC_VECTOR(1 downto 0);
            countdown   : out INTEGER range 0 to 30
        );
    end component;
    
    component bcd_converter is
        Port (
            count       : in  INTEGER range 0 to 30;
            tens        : out STD_LOGIC_VECTOR(3 downto 0);
            ones        : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    component seven_segment_decoder is
        Port (
            digit       : in  STD_LOGIC_VECTOR(3 downto 0);
            segment     : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    signal ns_countdown, ew_countdown : INTEGER range 0 to 30;
    signal ns_display, ew_display : INTEGER range 0 to 30;
    
begin
    -- Clock divider for 1Hz clock
    clk_div: clock_divider
        port map (
            clk_in  => clk,
            reset   => reset,
            clk_out => clk_1hz
        );
    
    -- State controller
    controller: state_controller
        port map (
            clk         => clk_1hz,
            reset       => reset,
            emergency_ns => emergency_ns,
            emergency_ew => emergency_ew,
            state       => current_state,
            countdown   => countdown
        );
    
    -- Calculate countdown values for each direction (fixed syntax)
    -- Calculate countdown values for each direction
-- Process for handling countdown calculations with emergency switch fixes
process(current_state, countdown, emergency_ns, emergency_ew)
begin
    -- First handle emergency conditions
    if emergency_ns = '1' then
        -- Emergency mode for NS direction
        ns_countdown <= 0;
        ew_countdown <= 0;  -- Both displays should show 00
    elsif emergency_ew = '1' then
        -- Emergency mode for EW direction
        ns_countdown <= 0;  -- Both displays should show 00
        ew_countdown <= 0;
    -- Normal operation when no emergency
    elsif current_state = NS_GREEN_EW_RED then
        -- NS has green light, count down from 27
        ns_countdown <= 27 - countdown;
        -- EW is red, show countdown until green
        ew_countdown <= 30 - countdown;
    elsif current_state = NS_YELLOW_EW_RED then
        -- NS has yellow light, count down from 3
        ns_countdown <= 3 - countdown;
        -- EW is red while NS has yellow, display remaining yellow time
        ew_countdown <= 3 - countdown;
    elsif current_state = NS_RED_EW_GREEN then
        -- NS is red while EW has green
        ns_countdown <= 30 - countdown;
        -- EW has green light, count down from 27
        ew_countdown <= 27 - countdown;
    elsif current_state = NS_RED_EW_YELLOW then
        -- NS is red while EW has yellow, display remaining yellow time
        ns_countdown <= 3 - countdown;
        -- EW has yellow light, count down from 3
        ew_countdown <= 3 - countdown;
    else
        -- Default case
        ns_countdown <= 0;
        ew_countdown <= 0;
    end if;
end process;

-- Display values - no change needed here
ns_display <= ns_countdown;
ew_display <= ew_countdown;
    
    -- Convert countdown to BCD for seven segment display
    ns_bcd: bcd_converter
        port map (
            count => ns_display,
            tens  => digit1,
            ones  => digit0
        );
    
    ew_bcd: bcd_converter
        port map (
            count => ew_display,
            tens  => digit3,
            ones  => digit2
        );
    
    -- Display refresh counter
    process(clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= std_logic_vector(unsigned(refresh_counter) + 1);
        end if;
    end process;
    
    -- Extract 2 MSBs for display selection
    display_select <= refresh_counter(19 downto 18);
    
    -- Select current digit to display
    current_digit <= digit0 when display_select = "00" else
                    digit1 when display_select = "01" else
                    digit2 when display_select = "10" else
                    digit3;
    
    -- Anode control for digit selection
    an <= "1110" when display_select = "00" else
          "1101" when display_select = "01" else
          "1011" when display_select = "10" else
          "0111";
    
    -- Decimal point off
    dp <= '1';
    
    -- Seven segment decoder for digit display
    seg_decoder: seven_segment_decoder
        port map (
            digit   => current_digit,
            segment => seg
        );
    
    -- Traffic light control outputs based on state and emergency switches
    -- North-South lights
    ns_red    <= '0' when emergency_ns = '1' else
                '0' when current_state = NS_GREEN_EW_RED or current_state = NS_YELLOW_EW_RED else '1';
    ns_yellow <= '0' when emergency_ns = '1' else
                '1' when current_state = NS_YELLOW_EW_RED else '0';
    ns_green  <= '1' when emergency_ns = '1' else
                '1' when current_state = NS_GREEN_EW_RED else '0';
    
    -- East-West lights
    ew_red    <= '0' when emergency_ew = '1' else
                '0' when current_state = NS_RED_EW_GREEN or current_state = NS_RED_EW_YELLOW else '1';
    ew_yellow <= '0' when emergency_ew = '1' else
                '1' when current_state = NS_RED_EW_YELLOW else '0';
    ew_green  <= '1' when emergency_ew = '1' else
                '1' when current_state = NS_RED_EW_GREEN else '0';
    
end dataflow;