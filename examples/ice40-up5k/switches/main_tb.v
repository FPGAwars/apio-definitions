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

  // Clock. The design has no clock, it only paces the checks.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The switches, driven by the testbench.
  reg  [2:0] sws = 3'b000;

  // The RGB LED driven by the design.
  wire [2:0] rgb_led_n;

  main dut (
      .sws(sws),
      .rgb_led_n(rgb_led_n)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Try every combination of the switches, one per clock.
    for (i = 0; i < 8; i = i + 1) begin
      @(posedge sys_clk);
      #1;
      sws = i[2:0];
      #1;
      `EXPECT_EQ(rgb_led_n, {i[0], i[1], i[2]})
    end

    $display("End of simulation");
    $finish;
  end

endmodule
