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

  // 3 clocks per column and a new random value every 20 clocks, at full
  // intensity so a column is always on.
  main #(
      .N1(3),
      .N2(20),
      .INTENSITY(15)
  ) dut (
      .sys_clk(sys_clk),
      .rows_n (rows_n),
      .cols_n (cols_n)
  );

  // The byte of 'data' for the column that cols_n selects. Column 0 shows
  // bits 31 to 24, column 1 bits 23 to 16, and so on.
  function [7:0] byte_of(input [31:0] value, input [3:0] cols);
    case (cols)
      4'b1110: byte_of = value[31:24];
      4'b1101: byte_of = value[23:16];
      4'b1011: byte_of = value[15:8];
      default: byte_of = value[7:0];
    endcase
  endfunction

  // The sampled random value as of the previous clock.
  reg [31:0] prev_rnd = 0;

  // The columns that were on at least once.
  reg [3:0] seen = 4'b0000;

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // On every clock, at most one column is on and the rows show its
    // byte of the sampled random value, as of the previous clock.
    for (i = 1; i <= 60; i = i + 1) begin
      @(posedge sys_clk);
      #1;
      if (cols_n != 4'b1111) begin
        `EXPECT_EQ(
            cols_n == 4'b1110 || cols_n == 4'b1101 || cols_n == 4'b1011 || cols_n == 4'b0111, 1'b1)
        `EXPECT_EQ(rows_n, ~byte_of(prev_rnd, cols_n))
        seen = seen | ~cols_n;
      end
      prev_rnd = dut.sampled_rnd;
    end
    `EXPECT_EQ(seen, 4'b1111)

    $display("End of simulation");
    $finish;
  end

endmodule
