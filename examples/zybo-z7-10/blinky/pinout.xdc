# Constraint file of the blinky example for the Zybo Z7-10 board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: #-- Pin source: Digilent/digilent-xdc Zybo-Z7-Master.xdc

# Clock (125MHz).
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active high.
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
