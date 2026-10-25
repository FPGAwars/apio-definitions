# Constraint file of the blinky example for the Arty S7-25 board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: #-- Pin source: Digilent/digilent-xdc Arty-S7-25-Master.xdc

# Clock (12MHz).
set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active high.
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN E13   IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
