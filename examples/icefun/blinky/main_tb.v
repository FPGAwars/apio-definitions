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

  // The LED matrix pins driven by the design.
  wire [7:0] rows_n;
  wire [3:0] cols_n;

  // Clocks between toggles, reduced to run quickly.
  localparam integer N = 4;

  main #(
      .N(N)
  ) dut (
      .sys_clk(sys_clk),
      .rows_n (rows_n),
      .cols_n (cols_n)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Only column 0 is on. Rows 0 and 1 take turns, swapping every N
    // clocks, and the other rows are off.
    for (i = 0; i <= 24; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      `EXPECT_EQ(cols_n, 4'b1110)
      `EXPECT_EQ(rows_n, ((i/N) % 2 == 1) ? 8'b1111_1110 : 8'b1111_1101)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
