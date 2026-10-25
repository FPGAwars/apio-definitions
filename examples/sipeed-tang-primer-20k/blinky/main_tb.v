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

  // The display pins driven by the design.
  wire [6:0] segs_n;
  wire digit_sel;

  // A 4 bit counter, so the segment toggles every 8 clocks.
  main #(
      .N(4)
  ) dut (
      .sys_clk(sys_clk),
      .segs_n(segs_n),
      .digit_sel(digit_sel)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // After i clocks the counter equals i, so segment a shows bit 3 of i
    // (low is on). The other segments stay off, on the right-hand digit.
    for (i = 0; i <= 32; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      `EXPECT_EQ(segs_n, {6'b11_1111, ~i[3]})
      `EXPECT_EQ(digit_sel, 1'b1)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
