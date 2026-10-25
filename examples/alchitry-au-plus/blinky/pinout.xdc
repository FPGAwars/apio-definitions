# Constraint file of the blinky example for the Alchitry Au+ board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: alchitry/Alchitry-Labs-V2 (pinout identico al Au, ftg256)

# Clock (100MHz).
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active high.
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN K12   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports {leds[4]}]
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports {leds[5]}]
set_property -dict { PACKAGE_PIN M12   IOSTANDARD LVCMOS33 } [get_ports {leds[6]}]
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports {leds[7]}]
