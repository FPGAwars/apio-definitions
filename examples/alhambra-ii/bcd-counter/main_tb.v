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

  // The LEDs driven by the design.
  wire [7:0] leds;

  // Count every 3 clocks, so the test runs quickly.
  main #(
      .DIV(3)
  ) dut (
      .sys_clk(sys_clk),
      .leds(leds)
  );

  // The expected count, 0-99.
  integer count;

  // The expected tens and ones digits. Compared through [3:0], to match
  // the width of the LED nibbles.
  integer tens;
  integer ones;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // The reset lasts 3 clocks, the first tick comes 3 clocks later,
    // and the units digit counts on the next clock. So the count
    // becomes n after clock 3*n + 4. Run past 99 to check the
    // wrap around to 00.
    repeat (320) begin
      @(posedge sys_clk);
      #1;
      count = (clk_num < 7) ? 0 : ((clk_num - 4) / 3) % 100;
      tens  = count / 10;
      ones  = count % 10;
      `EXPECT_EQ(leds[7:4], tens[3:0])
      `EXPECT_EQ(leds[3:0], ones[3:0])
    end

    $display("End of simulation");
    $finish;
  end

endmodule
