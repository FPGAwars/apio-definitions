# Constraint file of the blinky example for the QMTECH XC7A100T core board board.
# It assigns the design's signals to FPGA pins, and lists only
# the pins that this example uses.
# Pin source: ChinaQMTECH XC7A75T-100T-200T Core Board V01 (Test01_led_key)

# Clock (50MHz).
set_property -dict { PACKAGE_PIN U22   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

# LEDs, active low.
set_property -dict { PACKAGE_PIN T23   IOSTANDARD LVCMOS33 } [get_ports {leds_n[0]}]
set_property -dict { PACKAGE_PIN R23   IOSTANDARD LVCMOS33 } [get_ports {leds_n[1]}]
