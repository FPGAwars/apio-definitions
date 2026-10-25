# Constraint file of the blinky example for the ZXTRES+ board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: zxtres/test_carta_ajuste pines_zxtres.xdc

# Clock (50MHz).
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LED, polarity unknown.
set_property -dict { PACKAGE_PIN H13   IOSTANDARD LVCMOS33 } [get_ports {led}]
