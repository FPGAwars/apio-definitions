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

  // The button, driven by the testbench. Released at the start.
  reg btn = 0;

  // The signals driven by the design.
  wire [7:0] leds;
  wire wifi_gpio0;

  // An 8 bit counter, so leds[5:0] show bits 7 to 2 of the count.
  main #(
      .N(8)
  ) dut (
      .sys_clk(sys_clk),
      .btn(btn),
      .leds(leds),
      .wifi_gpio0(wifi_gpio0)
  );

  // Loop index for the checks.
  integer i;

  // The expected counter bits on leds[5:0]. Compared through [5:0], to match the
  // signal's width.
  integer expected;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Check after every clock, past the counter's wrap from 255 to 0.
    // The button is pressed from clock 50 to 100, and leds[6] follows it
    // 2 clocks later, after the synchronizer.
    for (i = 0; i <= 270; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      expected = (i % 256) >> 2;
      `EXPECT_EQ(leds[5:0], expected[5:0])
      `EXPECT_EQ(leds[6], (i >= 52) && (i < 102))
      `EXPECT_EQ(leds[7], 1'b1)
      `EXPECT_EQ(wifi_gpio0, 1'b1)
      if (i == 50) btn = 1;
      if (i == 100) btn = 0;
    end

    $display("End of simulation");
    $finish;
  end

endmodule
