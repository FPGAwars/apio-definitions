# Constraint file of the blinky example for the ColorLight i9plus board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: wuxx/Colorlight-FPGA-Projects (i9plus v6.1, blinky.xdc oficial)

# Clock (25MHz).
set_property -dict { PACKAGE_PIN K4    IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LED, active high.
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports {led}]
