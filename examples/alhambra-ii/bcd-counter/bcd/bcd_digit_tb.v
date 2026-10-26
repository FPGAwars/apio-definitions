// Testbench for bcd_digit.v.
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

module bcd_digit_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // Inputs, driven by the test sequence.
  reg sys_rst = 1;
  reg tick_in = 0;

  // Outputs.
  wire tick_out;
  wire [3:0] count;

  // The digit under test.
  bcd_digit dut (
      .sys_clk(sys_clk),
      .sys_rst(sys_rst),
      .tick_in(tick_in),
      .tick_out(tick_out),
      .count(count)
  );

  // Loop index, the number of ticks so far.
  integer i;

  // The expected count. Compared through [3:0], to match the width of
  // count.
  integer expected;

  // The test sequence.
  initial begin
    $dumpvars(0, bcd_digit_tb);

    // Reset for 2 clocks.
    repeat (2) @(posedge sys_clk);
    #1;
    sys_rst = 0;
    `EXPECT_EQ(count, 4'd0)

    // Tick 25 times, to see the digit wrap around twice.
    for (i = 1; i <= 25; i = i + 1) begin
      // Raise tick_in. tick_out goes high only when the count is 9.
      tick_in = 1;
      #1;
      `EXPECT_EQ(tick_out, (i - 1) % 10 == 9)

      // The digit counts on the next clock.
      @(posedge sys_clk);
      #1;
      tick_in = 0;
      #1;
      expected = i % 10;
      `EXPECT_EQ(count, expected[3:0])
      `EXPECT_EQ(tick_out, 1'b0)

      // Without a tick, the digit holds its value.
      @(posedge sys_clk);
      #1;
      expected = i % 10;
      `EXPECT_EQ(count, expected[3:0])
    end

    $display("End of simulation");
    $finish;
  end

endmodule
