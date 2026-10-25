// Testbench for main.v.
// Run it in batch mode with 'apio test', or view the signals
// in GTKWave with 'apio sim'.

// Checks that 'actual_val' equals 'expected_val'. On a mismatch, prints
// the values and location, sets assertion_err, and stops the simulation.
// Under 'apio sim' the simulation continues so the signals can be viewed.
`define EXPECT_EQ(actual_val, expected_val) \
  if ((actual_val) !== (expected_val)) begin \
    $display("*** ASSERTION FAILED at %s:%0d: expected 'h%h, actual 'h%h", \
             `__FILE__, `__LINE__, (expected_val), (actual_val)); \
    assertion_err = 1; \
    if (!`APIO_SIM) $fatal; \
  end

`timescale 1ns / 1ps

module main_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The RGB LED pins driven by the design, active low.
  wire [2:0] rgb_led;

  // The USB pins driven by the design.
  wire usb_dp, usb_dn, usb_pu;

  // A 5 bit counter, so the colors change every 4 clocks.
  main #(
      .N(5)
  ) dut (
      .sys_clk(sys_clk),
      .rgb_led(rgb_led),
      .usb_dp (usb_dp),
      .usb_dn (usb_dn),
      .usb_pu (usb_pu)
  );

  // Loop index for the LED checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // After i clocks the counter equals i, so the colors show its bits 4,
    // 3 and 2, past its wrap from 31 to 0. The USB lines stay low.
    for (i = 0; i <= 40; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      `EXPECT_EQ(rgb_led, ~{i[4], i[2], i[3]})
      `EXPECT_EQ({usb_dp, usb_dn, usb_pu}, 3'b000)
    end

    $display("End of simulation");
    $finish;
  end


endmodule
