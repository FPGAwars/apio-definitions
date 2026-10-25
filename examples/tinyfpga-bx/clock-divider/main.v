// look in pinout.pcf for all the pin names on the TinyFPGA BX board
module main (
    input sys_clk,  // 16MHz clock
    output led,  // User/boot LED next to the power LED, active high.
    output usb_pu  // USB pull-up resistor, active high.
);

  wire clock_div4_0;
  wire clock_div4_90;

  // drive USB pull-up resistor to '0' to disable USB
  // Keep the USB pull-up off, since this design doesn't use USB.
  assign usb_pu = 1'b0;

  clock_divider cdiv (
      .clock_in(sys_clk),
      .clock_div4_0(clock_div4_0),
      .clock_div4_90(clock_div4_90)
  );


  // light up the LED according to the pattern
  assign led = clock_div4_0;

endmodule
