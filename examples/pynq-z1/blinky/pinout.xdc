# Constraint file of the blinky example for the Pynq-Z1 board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: #-- Pin source: LEDs: Xilinx/PYNQ base.xdc; 125 MHz PL clock H16: Pynq-Z1 reference manual

# Clock (125MHz).
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active high.
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
