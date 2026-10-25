# Constraint file of the blinky example for the Cmod A7-35T board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: Digilent/digilent-xdc Cmod-A7-Master.xdc

# Clock (12MHz).
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active high.
set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
