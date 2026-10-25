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

  // The signals driven by the design.
  wire led;
  wire usb_pu;

  // A 7 bit counter, so each step lasts 4 clocks.
  main #(
      .N(7)
  ) dut (
      .sys_clk(sys_clk),
      .led(led),
      .usb_pu(usb_pu)
  );

  // The pattern, as in main.v.
  localparam [31:0] PATTERN = 32'b0000_0101_0100_0111_0111_0111_0001_0101;

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // After i clocks the LED shows step i / 4 of the pattern, past the
    // end of the pattern and back to its start.
    for (i = 0; i <= 140; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      `EXPECT_EQ(led, PATTERN[(i/4)%32])
      `EXPECT_EQ(usb_pu, 1'b0)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
