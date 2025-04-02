## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## Reset button (Center button)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Emergency switches
set_property PACKAGE_PIN V17 [get_ports emergency_ns]
set_property IOSTANDARD LVCMOS33 [get_ports emergency_ns]
set_property PACKAGE_PIN V16 [get_ports emergency_ew]
set_property IOSTANDARD LVCMOS33 [get_ports emergency_ew]

## Traffic Lights (using LEDs)
# North-South lights
set_property PACKAGE_PIN B15 [get_ports ns_red]
set_property IOSTANDARD LVCMOS33 [get_ports ns_red]
set_property PACKAGE_PIN A16 [get_ports ns_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports ns_yellow]
set_property PACKAGE_PIN A14 [get_ports ns_green]
set_property IOSTANDARD LVCMOS33 [get_ports ns_green]

# East-West lights
set_property PACKAGE_PIN J2 [get_ports ew_red]
set_property IOSTANDARD LVCMOS33 [get_ports ew_red]
set_property PACKAGE_PIN L2 [get_ports ew_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports ew_yellow]
set_property PACKAGE_PIN J1 [get_ports ew_green]
set_property IOSTANDARD LVCMOS33 [get_ports ew_green]

## 7-segment display
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN W7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property PACKAGE_PIN V7 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

set_property PACKAGE_PIN U5 [get_ports {seg[2]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]

