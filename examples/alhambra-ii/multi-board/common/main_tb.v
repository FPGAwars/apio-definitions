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

  // Clocks per blink cycle, reduced to run quickly. The LED toggles
  // every HALF_CYCLE clocks.
  localparam integer CLKS_PER_CYCLE = 6;
  localparam integer HALF_CYCLE = CLKS_PER_CYCLE / 2;

  // The LED driven by the design.
  wire led;

  // The design under test.
  main #(
      .CLKS_PER_CYCLE(CLKS_PER_CYCLE)
  ) dut (
      .sys_clk(sys_clk),
      .led(led)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Before the first clock, the LED is off.
    #1;
    `EXPECT_EQ(led, 1'b0)

    // After i clocks the LED has toggled every HALF_CYCLE clocks. The
    // checks use only the design's ports, so that the testbench can also
    // be linted by itself ('apio lint common/main_tb.v'), without main.v.
    for (i = 1; i <= 24; i = i + 1) begin
      @(posedge sys_clk);
      #1;
      `EXPECT_EQ(led, (i/HALF_CYCLE) % 2 == 1)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
