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

  // The outputs of the design.
  wire [7:0] leds;
  wire wifi_gpio0;

  // A 4 bit counter, so leds[7] toggles every 8 clocks.
  main #(
      .N(4)
  ) dut (
      .sys_clk(sys_clk),
      .leds(leds),
      .wifi_gpio0(wifi_gpio0)
  );

  // Loop index for the LED checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Before the first clock, the counter starts at 0.
    #1;
    `EXPECT_EQ(dut.counter, 4'd0)
    `EXPECT_EQ(leds, 8'b0)

    // After i clocks the counter equals i, so leds[7] shows bit 3
    // of i. The other LEDs stay off.
    for (i = 1; i <= 32; i = i + 1) begin
      @(posedge sys_clk);
      #1;
      `EXPECT_EQ(leds[7], i[3])
      `EXPECT_EQ(leds[6:0], 7'b0)
      `EXPECT_EQ(wifi_gpio0, 1'b1)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
