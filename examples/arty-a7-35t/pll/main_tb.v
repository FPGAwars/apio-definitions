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

  // The external clock. In simulation the PLL passes it through
  // unchanged, so it is also the design's sys_clk.
  reg ext_clk = 0;
  always #5 ext_clk = ~ext_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge ext_clk) clk_num <= clk_num + 1;

  // Clocks between LED toggles, reduced to run quickly.
  localparam integer DIV = 4;

  // The LED driven by the design.
  wire led;

  // The design under test.
  main #(
      .DIV(DIV)
  ) dut (
      .ext_clk(ext_clk),
      .led(led)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Check after every clock. The reset is high for the first 3
    // clocks, so after clock i >= 3 the counter has counted i - 3
    // clocks and the LED, on after reset, toggled every DIV of them.
    for (i = 1; i <= 24; i = i + 1) begin
      @(posedge ext_clk);
      #1;
      `EXPECT_EQ(dut.sys_rst, i < 3)
      if (i < 3) begin
        `EXPECT_EQ(dut.counter, 32'd0)
        `EXPECT_EQ(led, 1'b1)
      end else begin
        `EXPECT_EQ(dut.counter, (i - 3) % DIV)
        `EXPECT_EQ(led, ((i - 3) /DIV) % 2 == 0)
      end
    end

    $display("End of simulation");
    $finish;
  end

endmodule
