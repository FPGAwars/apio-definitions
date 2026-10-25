# Constraint file of the blinky example for the Alinx AX7035 board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.

# Clock (50MHz).
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active low.
set_property -dict { PACKAGE_PIN F19 IOSTANDARD LVCMOS33 } [get_ports {leds_n[0]}]
set_property -dict { PACKAGE_PIN E21 IOSTANDARD LVCMOS33 } [get_ports {leds_n[1]}]
set_property -dict { PACKAGE_PIN D20 IOSTANDARD LVCMOS33 } [get_ports {leds_n[2]}]
set_property -dict { PACKAGE_PIN C20 IOSTANDARD LVCMOS33 } [get_ports {leds_n[3]}]
