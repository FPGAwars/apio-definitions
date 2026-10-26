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

  // The LED driven by the design.
  wire led_n;

  // An 8 bit counter, whatever the env's WIDTH, so the test runs quickly.
  main #(
      .WIDTH(8)
  ) dut (
      .sys_clk(sys_clk),
      .led_n  (led_n)
  );

  // Loop index for the checks.
  integer i;

  // The expected count. Compared through [7:0], to match the
  // signal's width.
  integer expected;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // After i clocks the counter equals 7*i, past its wrap from 255 to 0.
    for (i = 0; i <= 80; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      expected = (7 * i) % 256;
      `EXPECT_EQ(dut.counter, expected[7:0])
      `EXPECT_EQ(led_n, ~dut.counter[7])
    end

    $display("End of simulation");
    $finish;
  end

endmodule
