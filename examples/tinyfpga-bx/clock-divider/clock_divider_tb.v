// Testbench for clock_divider.v.
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

module clock_divider_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The divided clocks driven by the module.
  wire clock_div4_0;
  wire clock_div4_90;

  clock_divider dut (
      .clock_in(sys_clk),
      .clock_div4_0(clock_div4_0),
      .clock_div4_90(clock_div4_90)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, clock_divider_tb);

    // clock_div2 toggles on every sys_clk rising edge. clock_div4_0
    // toggles on its rising edges (clocks 1, 3, 5, ...) and clock_div4_90
    // on its falling edges (clocks 2, 4, 6, ...), so clock_div4_90 lags by
    // one sys_clk, a quarter of the divided period.
    for (i = 0; i <= 20; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      `EXPECT_EQ(dut.clock_div2, i[0])
      `EXPECT_EQ(clock_div4_0, ((i + 1) / 2) % 2)
      `EXPECT_EQ(clock_div4_90, (i/ 2) % 2)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
