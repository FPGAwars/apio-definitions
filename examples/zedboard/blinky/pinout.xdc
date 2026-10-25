# Constraint file of the blinky example for the ZedBoard board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: #-- Pin source: Digilent/digilent-xdc Zedboard-Master.xdc (GCLK, LD0-LD3)

# Clock (100MHz).
set_property -dict { PACKAGE_PIN Y9    IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active high.
set_property -dict { PACKAGE_PIN T22   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN T21   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN U22   IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN U21   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
