# Constraint file of the blinky example for the Arty A7-35T board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: Digilent/digilent-xdc Arty-A7-35-Master.xdc

# Clock (100MHz).
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active high.
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
