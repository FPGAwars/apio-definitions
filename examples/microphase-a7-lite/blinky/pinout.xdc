# Constraint file of the blinky example for the MicroPhase A7-Lite board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: MicroPhase A7-Lite Reference Manual + esquematico R1.1

# Clock (50MHz).
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active low.
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports {leds_n[0]}]
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports {leds_n[1]}]
