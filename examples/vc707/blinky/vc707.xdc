
#-- VC707 board

#-- System clock (200 MHz, LVDS, bank 38)
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVDS } [get_ports {sysclk_p}]
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVDS } [get_ports {sysclk_n}]
create_clock -period 5.000 [get_ports {sysclk_p}]

#-- User LEDs (GPIO_LED_0..7: banks 15 and 13, 1.8 V)
set_property -dict { PACKAGE_PIN AM39  IOSTANDARD LVCMOS18 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN AN39  IOSTANDARD LVCMOS18 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN AR37  IOSTANDARD LVCMOS18 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN AT37  IOSTANDARD LVCMOS18 } [get_ports {leds[3]}]
set_property -dict { PACKAGE_PIN AR35  IOSTANDARD LVCMOS18 } [get_ports {leds[4]}]
set_property -dict { PACKAGE_PIN AP41  IOSTANDARD LVCMOS18 } [get_ports {leds[5]}]
set_property -dict { PACKAGE_PIN AP42  IOSTANDARD LVCMOS18 } [get_ports {leds[6]}]
set_property -dict { PACKAGE_PIN AU39  IOSTANDARD LVCMOS18 } [get_ports {leds[7]}]

#-- Pins from the VC707 user guide (UG885), as used by
#-- openXC7/nextpnr himbaechel/uarch/xilinx/examples/vc707-johnson
