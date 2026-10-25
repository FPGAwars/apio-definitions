# Constraint file of the pll example for the Arty A7-35T board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.

# Clock (100MHz).
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports {ext_clk}]

# LED (LD4), active high.
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports {led}]
